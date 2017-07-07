require 'test_helper'

class VoteCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vote_category = vote_categories(:one)
  end

  test "should get index" do
    get vote_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_vote_category_url
    assert_response :success
  end

  test "should create vote_category" do
    assert_difference('VoteCategory.count') do
      post vote_categories_url, params: { vote_category: { category_id: @vote_category.category_id, vote_id: @vote_category.vote_id } }
    end

    assert_redirected_to vote_category_url(VoteCategory.last)
  end

  test "should show vote_category" do
    get vote_category_url(@vote_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_vote_category_url(@vote_category)
    assert_response :success
  end

  test "should update vote_category" do
    patch vote_category_url(@vote_category), params: { vote_category: { category_id: @vote_category.category_id, vote_id: @vote_category.vote_id } }
    assert_redirected_to vote_category_url(@vote_category)
  end

  test "should destroy vote_category" do
    assert_difference('VoteCategory.count', -1) do
      delete vote_category_url(@vote_category)
    end

    assert_redirected_to vote_categories_url
  end
end
