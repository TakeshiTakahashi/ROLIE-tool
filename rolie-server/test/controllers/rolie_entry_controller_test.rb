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
    xml = '<?xml version="1.0"?><entry></entry>'
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response 400
  end

  test "should put" do
    xml = '<?xml version="1.0"?><hoge></hoge>'
    put :put, xml,  :workspace => 'public', :collection => 'incidents', :id => 1
    assert_response :success
  end

  test "should post" do
    post :post, :workspace => 'public', :collection => 'incidents'
    assert_response :success
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
