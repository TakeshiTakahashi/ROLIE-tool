class ServiceController < ApplicationController
  def index
  end

  def svcdoc
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.service('xmlns' => 'http://www.w3.org/2007/app',
                  'xmlns:atom' => 'http://www.w3.org/2005/Atom') {
        Workspace.find_each {|ws|
          xml.workspace {
            xml['atom'].title('type' => 'text') {
              xml.text(ws.title)
            }
            ws.collections.find_each {|c|
              xml.collection('href' => url_for(:controller => 'rolie_entry', :action => 'index', :workspace => ws.path, :collection => c.path)) {
                xml['atom'].title('type' => 'text') {
                  xml.text(c.title)
                }
                xml.accept {
                  xml.text('application/atom+xml; type=entry')
                }
              }
            }
          }
        }
      }
    end
    render :xml => builder.to_xml
  end
end
