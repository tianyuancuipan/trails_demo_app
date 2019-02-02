require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:anny)
    @micropost = @user.microposts.build(content: "A micropost")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "     "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "associated comments should be destroyed" do
    @micropost.save
    @micropost.comments.create!(content: "Lorem ipsum", user_id: @user.id)
    assert_difference 'Comment.count', -1 do
      @micropost.destroy
    end
  end

  test "associated likes should be destroyed" do
    @micropost.save
    @micropost.likes.create!(user_id: @user.id)
    assert_difference 'Like.count', -1 do
      @micropost.destroy
    end
  end
end
