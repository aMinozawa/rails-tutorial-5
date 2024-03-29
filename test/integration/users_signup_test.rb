require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path 
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { 
        name:  "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar" } }
    end
    assert_template 'user/new'
    assert_select 'div#error explanation'
    assert_select 'div..field_with_errors'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email is invalid"
    assert_select 'li', "Password confirmation doesn't match"
    assert_select 'li', "Password is too short(long)"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post user_path, params: { user: { 
        name:  "Example User",
        email: "user@example.com",
        password:  "password",
        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
