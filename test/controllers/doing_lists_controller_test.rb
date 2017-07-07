require 'test_helper'

class DoingListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doing_list = doing_lists(:one)
  end

  test "should get index" do
    get doing_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_doing_list_url
    assert_response :success
  end

  test "should create doing_list" do
    assert_difference('DoingList.count') do
      post doing_lists_url, params: { doing_list: { tweet_id: @doing_list.tweet_id, user_id: @doing_list.user_id } }
    end

    assert_redirected_to doing_list_url(DoingList.last)
  end

  test "should show doing_list" do
    get doing_list_url(@doing_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_doing_list_url(@doing_list)
    assert_response :success
  end

  test "should update doing_list" do
    patch doing_list_url(@doing_list), params: { doing_list: { tweet_id: @doing_list.tweet_id, user_id: @doing_list.user_id } }
    assert_redirected_to doing_list_url(@doing_list)
  end

  test "should destroy doing_list" do
    assert_difference('DoingList.count', -1) do
      delete doing_list_url(@doing_list)
    end

    assert_redirected_to doing_lists_url
  end
end
