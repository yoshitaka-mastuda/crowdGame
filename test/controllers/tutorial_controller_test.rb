require 'test_helper'

class TutorialControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get tutorial_home_url
    assert_response :success
  end

end
