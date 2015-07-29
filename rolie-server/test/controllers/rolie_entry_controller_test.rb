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

  test "should put" do
    put :put, :workspace => 'public', :collection => 'incidents', :id => 1
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
