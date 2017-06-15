require 'test_helper'

class EvaluationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get evaluation_index_url
    assert_response :success
  end

end
