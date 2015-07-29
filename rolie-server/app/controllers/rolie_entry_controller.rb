class RolieEntryController < ApplicationController
  def index
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.feed('xmlns' => 'http://www.w3.org/2005/Atom',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'xsi:schemaLocation' => 'http://www.w3.org/2005/Atom file:/C:/schemas/atom.xsd urn:ietf:params:xml:ns:iodef-1.0 file:/C:/schemas/iodef-1.0.xsd'
               ) {
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
