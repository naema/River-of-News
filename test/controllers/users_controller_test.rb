require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { api_url: @user.api_url, box_color: @user.box_color, crypted_password: @user.crypted_password, email: @user.email, font_color: @user.font_color, font_name: @user.font_name, font_size: @user.font_size, salt: @user.salt }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { api_url: @user.api_url, box_color: @user.box_color, crypted_password: @user.crypted_password, email: @user.email, font_color: @user.font_color, font_name: @user.font_name, font_size: @user.font_size, salt: @user.salt }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
