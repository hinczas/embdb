require 'test_helper'

class ThreedsControllerTest < ActionController::TestCase
  setup do
    @threed = threeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:threeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create threed" do
    assert_difference('Threed.count') do
      post :create, threed: { notes: @threed.notes, threed: @threed.threed }
    end

    assert_redirected_to threed_path(assigns(:threed))
  end

  test "should show threed" do
    get :show, id: @threed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @threed
    assert_response :success
  end

  test "should update threed" do
    patch :update, id: @threed, threed: { notes: @threed.notes, threed: @threed.threed }
    assert_redirected_to threed_path(assigns(:threed))
  end

  test "should destroy threed" do
    assert_difference('Threed.count', -1) do
      delete :destroy, id: @threed
    end

    assert_redirected_to threeds_path
  end
end
