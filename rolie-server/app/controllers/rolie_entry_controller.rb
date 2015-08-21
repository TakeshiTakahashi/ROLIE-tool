class RolieEntryController < ApplicationController
  def index
    load_collection

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.feed('xmlns' => 'http://www.w3.org/2005/Atom',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'xsi:schemaLocation' => 'http://www.w3.org/2005/Atom file:/C:/schemas/atom.xsd urn:ietf:params:xml:ns:iodef-1.0 file:/C:/schemas/iodef-1.0.xsd'
               ) {
        xml.generator "ROLIE prototype server"
        xml.id_(url_for)
        xml.title('type' => 'text') {
          xml.text @collection.title
        }
        xml.updated(DateTime.now.rfc3339)
        xml << @collection.author
        xml.link('href' => url_for, 'rel' => 'self')

        @collection.entries.find_each {|entry|
          xml.entry {
            xml.id_(entry.atomid)
            xml.title(entry.title)
            xml.link('href' => url_for(:action => :get, :id => entry.id), 'rel' => 'self')
            xml.link('href' => url_for(:action => :get, :id => entry.id), 'rel' => 'alternate')
            xml.published(entry.published.rfc3339)
            xml.updated(entry.updated_at.to_datetime.rfc3339)
            xml.category
            if summary = entry.summary || entry.description
              xml.summary(summary)
            end
          }
        }
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def get
    load_entry
    render_entry
  end

  def put
    doc = parse_body
    load_entry

    @entry.xml = doc
    @entry.save!

    render_entry
  end

  def post
    doc = parse_body
    load_collection

    @entry = Entry.new
    @entry.collection = @collection
    @entry.xml = doc
    @entry.save!

    render_entry
  end

  def delete
    load_entry

    render :nothing => true
  end

  def search
  end

  private

  def load_collection
    @workspace = Workspace.find_by!(path: params[:workspace])
    @collection = @workspace.collections.find_by!(path: params[:collection])
  end

  def load_entry
    load_collection
    @entry = @collection.entries.find(params[:id])
  end

  def parse_body
    doc = Nokogiri::XML(request.body) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NONET
    end
  end

  def render_entry
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
        xml.id_(@entry.atomid)
        xml.title(@entry.title)
        xml.link('href' => url_for(:action => :get, :id => @entry.id), 'rel' => 'self')
        xml.link('href' => url_for(:action => :get, :id => @entry.id), 'rel' => 'alternate')
        xml.published(@entry.published.rfc3339)
        xml.updated(@entry.updated_at.to_datetime.rfc3339)
        xml.category
        if summary = @entry.summary || @entry.description
          xml.summary(summary)
        end
        xml.content('type' => 'application/xml') {
          xml.parent.add_child @entry.iodef_document.dup
        }
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end
end
