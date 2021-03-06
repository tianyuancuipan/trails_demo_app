require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:anny)
  end

  test "should redirect new when logged in" do
    log_in_as(@user)
    get new_password_reset_path
    assert_redirected_to root_path
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
          user: {  password: "barbar", password_confirmation: "foobar" }}
    assert flash.empty?
    # Empty password
    patch password_reset_path(user.reset_token), params: { email: user.email,
          user: { password: "", password_confirmation: "" }}
    assert flash.empty?
    # Valid password and confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
          user: { password: "foobarbar", password_confirmation: "foobarbar" }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: "foofoofoo",
                            password: "foofoofoo" }}
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
