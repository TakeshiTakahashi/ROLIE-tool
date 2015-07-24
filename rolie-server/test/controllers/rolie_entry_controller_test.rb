require 'test_helper'

class RolieEntryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get get" do
    get :get
    assert_response :success
  end

  test "should get put" do
    get :put
    assert_response :success
  end

  test "should get post" do
    get :post
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
