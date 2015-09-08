class RolieEntryController < ApplicationController
  rescue_from Nokogiri::XML::SyntaxError do |e|
    render plain: e.to_s, status: 400
  end

  def index
    load_collection
    q = params[:q]

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

        entries = @collection.entries
        unless q.blank?
          entries = entries.like(q)
        end
        entries.find_each {|entry|
          self_url = url_for(:action => :get, :id => entry.id)
          xml.entry {
            xml.id_(self_url)
            xml.title(entry.title)
            xml.link('href' => self_url, 'rel' => 'self')
            xml.link('href' => self_url, 'rel' => 'alternate')
            xml << entry.links
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

    response.header['Location'] = url_for(:action => :get, :id => @entry.id)
    render_entry(201)
  end

  def delete
    load_entry
    @entry.delete
    render :nothing => true
  end

  def search_spec
    load_collection
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.OpenSearchDescription('xmlns' => 'http://a9.com/-/spec/opensearch/1.1/') {
        xml.ShortName('CSIRT search')
        xml.Description('Cyber security information sharing consortium search interface')
        xml.Tags('example csirt indicator search')
        xml.Contact('admin@example.org')
        xml.Url('type' => 'application/opensearchdescription+xml',
                'rel' => 'self',
                'template' => url_for)
        xml.Url('type' => 'application/atom+xml',
                'rel' => 'results',
                'template' => url_for(:action => :index, :q => disable_url_encode('{searchTerms}')))
        xml.LongName 'www.example.org CSIRT search'
        xml.Query 'role' => "example", 'searchTerms' => "incident"
        xml.Language 'en-us'
        xml.OutputEncoding 'UTF-8'
        xml.InputEncoding 'UTF-8'
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
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
    error = SCHEMA_Atom.validate(doc)
    error.each {|e|
      # report the first error
      raise e
    }
    doc
  end

  def render_entry(status = 200)
    self_url = url_for(:action => :get, :id => @entry.id)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
        xml.id_(self_url)
        xml.title(@entry.title)
        xml.link('href' => self_url, 'rel' => 'self')
        xml.link('href' => self_url, 'rel' => 'alternate')
        xml << @entry.links
        xml.published(@entry.published.rfc3339)
        xml.updated(@entry.updated_at.to_datetime.rfc3339)
        xml.category
        if summary = @entry.summary || @entry.description
          xml.summary(summary)
        end
        xml.content('type' => 'application/xml') {
          iodef = @entry.iodef_document.dup
          iid = iodef.xpath('.//iodef:IncidentID',
                            'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')
          iid.each {|e|
            e['name'] = url_for(:action => :index)
            e.children = e.document.create_text_node(@entry.id.to_s)
          }
          xml.parent.add_child iodef
        }
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8'), :status => status
  end

  def disable_url_encode(s)
    s = s.dup
    def s.to_query(key)
      "#{CGI.escape(key.to_param)}=#{to_param.to_s}"
    end
    s
  end
end
