require 'test_helper'

class BehaviorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @behavior = behaviors(:one)
  end

  test "should get index" do
    get behaviors_url
    assert_response :success
  end

  test "should get new" do
    get new_behavior_url
    assert_response :success
  end

  test "should create behavior" do
    assert_difference('Behavior.count') do
      post behaviors_url, params: { behavior: { state_id: @behavior.state_id, tweet_id: @behavior.tweet_id, user_id: @behavior.user_id, vote_id: @behavior.vote_id } }
    end

    assert_redirected_to behavior_url(Behavior.last)
  end

  test "should show behavior" do
    get behavior_url(@behavior)
    assert_response :success
  end

  test "should get edit" do
    get edit_behavior_url(@behavior)
    assert_response :success
  end

  test "should update behavior" do
    patch behavior_url(@behavior), params: { behavior: { state_id: @behavior.state_id, tweet_id: @behavior.tweet_id, user_id: @behavior.user_id, vote_id: @behavior.vote_id } }
    assert_redirected_to behavior_url(@behavior)
  end

  test "should destroy behavior" do
    assert_difference('Behavior.count', -1) do
      delete behavior_url(@behavior)
    end

    assert_redirected_to behaviors_url
  end
end
