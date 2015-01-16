require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get main" do
    get :main
    assert_response :success
  end

  test "should get app" do
    get :app
    assert_response :success
  end

end
