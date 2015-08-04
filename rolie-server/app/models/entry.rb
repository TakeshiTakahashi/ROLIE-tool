class Entry < ActiveRecord::Base
  belongs_to :collection

  def iodef
    @iodef ||= Nokogiri::XML(self.content)
  end

  def atomid
    id = iodef.xpath('/iodef:IODEF-Document/iodef:Incident/iodef:IncidentID', 'iodef' => 'urn:ietf:params:xml:ns:iodef-1.0')[0]
    "#{id['name']}/#{id.child}"
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
end
