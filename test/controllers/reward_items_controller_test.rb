require "test_helper"

class RewardItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reward_items_create_url
    assert_response :success
  end

  test "should get update" do
    get reward_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get reward_items_destroy_url
    assert_response :success
  end
end
