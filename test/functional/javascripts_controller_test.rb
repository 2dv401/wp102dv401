require 'test_helper'

class JavascriptsControllerTest < ActionController::TestCase
  test "should get maps" do
    get :maps
    assert_response :success
  end

end
