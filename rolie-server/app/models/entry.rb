class Entry < ActiveRecord::Base
  belongs_to :collection

  def iodef
    @iodef ||= Nokogiri::XML(self.content)
  end

  def iodef_document
    iodef.xpath('/iodef:IODEF-Document', 'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')[0]
  end

  def published
    reportTimes = iodef.xpath('/iodef:IODEF-Document/iodef:Incident/iodef:ReportTime/text()', 'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')
    parsed = reportTimes.map {|s|
      # xs:dateTime
      # RFC 3339
      DateTime.rfc3339(s.to_s)
    }
    # XXX: 'published' is undefined if multiple reportTimes exist
    parsed.max
  end

  def description
    ds = iodef.xpath('/iodef:IODEF-Document/iodef:Incident/iodef:Description', 'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')
    if d = ds[0]
      d.child.to_s
    else
      nil
    end
  end

  def xml=(xml)
    iodef_elm = xml.xpath('/atom:entry/atom:content/iodef:IODEF-Document',
                          'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0',
                          'atom' => 'http://www.w3.org/2005/Atom')
    iodef = Nokogiri::XML::Document.new
    iodef.add_child(iodef_elm)
    SCHEMA_iodef.validate(iodef).each {|e|
      raise e
    }
    # clear IncidentID
    # TODO: rename to AlternativeID?
    iid = iodef.xpath('/iodef:IODEF-Document/iodef:Incident/iodef:IncidentID',
                      'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')
    iid.each {|e|
      e['name'] = ''
      e.children = e.document.create_text_node('')
    }

    @iodef = nil
    self.content = iodef.to_xml

    title = xml.xpath('/atom:entry/atom:title/text()',
                      'atom' => 'http://www.w3.org/2005/Atom')
    self.title = title.first

    links = xml.xpath('/atom:entry/atom:link',
                      'atom' => 'http://www.w3.org/2005/Atom')
    self.links = links.to_xml
  end

end
