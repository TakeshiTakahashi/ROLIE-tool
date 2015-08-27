require 'test_helper'

class RolieEntryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :workspace => 'public', :collection => 'incidents'
    assert_response :success
  end

  test "should get" do
    get :get, :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response :success
  end

  test "should not put invalid xml" do
    xml = ''
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response 400
  end

  test "should not put invalid atom entry" do
    xml = '<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom"></entry>'
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response 400
  end

  test "should not put invalid iodef" do
    xml = <<XML
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom">
  <id>test</id>
  <title>test</title>
  <published>2001-09-13T23:19:24+00:00</published>
  <updated>2015-08-25T11:01:59+00:00</updated>
  <summary>test</summary>
  <content type="application/xml">
    <hoge></hoge>
  </content>
</entry>
XML
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response 400
  end

  test "should put minimum iodef" do
    xml = <<XML
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom">
  <id>test/12345</id>
  <title>test</title>
  <published>2001-09-13T23:19:24+00:00</published>
  <updated>2015-08-25T11:01:59+00:00</updated>
  <summary>test</summary>
  <content type="application/xml">
    <IODEF-Document xmlns="urn:ietf:params:xml:ns:iodef-1.0" lang="en">
      <Incident purpose="reporting">
        <IncidentID name="test">12345</IncidentID>
        <ReportTime>2001-09-13T23:19:24+00:00</ReportTime>
        <Assessment>
          <Impact completion="failed" type="admin"/>
        </Assessment>
        <Contact role="creator" type="organization">
        </Contact>
      </Incident>
    </IODEF-Document>
  </content>
</entry>
XML
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response :success
  end

  test "should not put minimum iodef with history" do
    xml = <<XML
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom">
  <id>test/12345</id>
  <title>test</title>
  <published>2001-09-13T23:19:24+00:00</published>
  <updated>2015-08-25T11:01:59+00:00</updated>
  <summary>test</summary>
  <content type="application/xml">
    <IODEF-Document xmlns="urn:ietf:params:xml:ns:iodef-1.0" lang="en">
      <Incident purpose="reporting">
        <IncidentID name="test">12345</IncidentID>
        <ReportTime>2001-09-13T23:19:24+00:00</ReportTime>
        <Assessment>
          <Impact completion="failed" type="admin"/>
        </Assessment>
        <Contact role="creator" type="organization">
        </Contact>
        <History>
          <HistoryItem action="contact-source-site">
            <DateTime>2001-09-14T08:19:01+00:00</DateTime>
          </HistoryItem>
        </History>
      </Incident>
    </IODEF-Document>
  </content>
</entry>
XML
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response 400
  end

  test "should post" do
    xml = <<XML
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom">
  <id>test/12345</id>
  <title>test</title>
  <published>2001-09-13T23:19:24+00:00</published>
  <updated>2015-08-25T11:01:59+00:00</updated>
  <summary>test</summary>
  <content type="application/xml">
    <IODEF-Document xmlns="urn:ietf:params:xml:ns:iodef-1.0" lang="en">
      <Incident purpose="reporting">
        <IncidentID name="test">12345</IncidentID>
        <ReportTime>2001-09-13T23:19:24+00:00</ReportTime>
        <Assessment>
          <Impact completion="failed" type="admin"/>
        </Assessment>
        <Contact role="creator" type="organization">
        </Contact>
      </Incident>
    </IODEF-Document>
  </content>
</entry>
XML
    post :post, xml, :workspace => 'public', :collection => 'incidents'
    assert_response 201
    assert_not_nil response.location
  end

  test "should delete" do
    delete :delete, :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response :success
  end

  #test "should get search" do
  #  get :search
  #  assert_response :success
  #end

end
