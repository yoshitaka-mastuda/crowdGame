require 'test_helper'

class UserBehaviorControllerTest < ActionDispatch::IntegrationTest
  test "should get click" do
    get user_behavior_click_url
    assert_response :success
  end

end
