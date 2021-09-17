require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post user_path, params: { user: { 
        name:  "Example User",
        email: "user@example.com",
        password:  "password",
        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'user/show'
    assert is_logged_in?
  end
end
