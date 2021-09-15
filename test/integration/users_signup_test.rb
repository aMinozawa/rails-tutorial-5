require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path 
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post user_path, params: { user: { 
        name:  "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar" } }
    end
    assert_template 'user/new'
    assert_select 'div#error explanation'
    assert_select 'div..field_with_errors'
    assert_select 'li', "Name can't be blank"
  end
end
