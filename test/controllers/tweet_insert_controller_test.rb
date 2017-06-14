require 'test_helper'

class TweetInsertControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tweet_insert_index_url
    assert_response :success
  end

  test "should get show" do
    get tweet_insert_show_url
    assert_response :success
  end

  test "should get create" do
    get tweet_insert_create_url
    assert_response :success
  end

end
