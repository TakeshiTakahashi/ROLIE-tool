class RolieEntryController < ApplicationController
  def index
    workspace = Workspace.find_by!(path: params[:workspace])
    collection = workspace.collections.find_by!(path: params[:collection])

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.feed('xmlns' => 'http://www.w3.org/2005/Atom',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'xsi:schemaLocation' => 'http://www.w3.org/2005/Atom file:/C:/schemas/atom.xsd urn:ietf:params:xml:ns:iodef-1.0 file:/C:/schemas/iodef-1.0.xsd'
               ) {
        xml.generator "ROLIE prototype server"
        xml.id_ "http://www.example.org/ TODO: stub"
        xml.title('type' => 'text') {
          xml.text collection.title
        }
        xml.updated # TODO
        xml.author # TODO
        xml.link

        collection.entries.find_each {|entry|
          xml.entry {
            xml.id_ "TODO"
            xml.title "TODO"
            xml.link
            xml.published "TODO"
            xml.updated "TODO"
            xml.category
            xml.summary "TODO"
          }
        }
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def get
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def put
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def post
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def delete
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.entry {
      }
    end
    render :xml => builder.to_xml(encoding: 'utf-8')
  end

  def search
  end
end
