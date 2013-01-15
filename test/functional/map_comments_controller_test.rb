require 'test_helper'

class MapCommentsControllerTest < ActionController::TestCase
  setup do
    @map_comment = map_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:map_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create map_comment" do
    assert_difference('MapComment.count') do
      post :create, map_comment: { content: @map_comment.content }
    end

    assert_redirected_to map_comment_path(assigns(:map_comment))
  end

  test "should show map_comment" do
    get :show, id: @map_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @map_comment
    assert_response :success
  end

  test "should update map_comment" do
    put :update, id: @map_comment, map_comment: { content: @map_comment.content }
    assert_redirected_to map_comment_path(assigns(:map_comment))
  end

  test "should destroy map_comment" do
    assert_difference('MapComment.count', -1) do
      delete :destroy, id: @map_comment
    end

    assert_redirected_to map_comments_path
  end
end
