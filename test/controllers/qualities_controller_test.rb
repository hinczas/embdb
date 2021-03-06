require 'test_helper'

class QualitiesControllerTest < ActionController::TestCase
  setup do
    @quality = qualities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:qualities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quality" do
    assert_difference('Quality.count') do
      post :create, quality: { notes: @quality.notes, quality: @quality.quality }
    end

    assert_redirected_to quality_path(assigns(:quality))
  end

  test "should show quality" do
    get :show, id: @quality
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quality
    assert_response :success
  end

  test "should update quality" do
    patch :update, id: @quality, quality: { notes: @quality.notes, quality: @quality.quality }
    assert_redirected_to quality_path(assigns(:quality))
  end

  test "should destroy quality" do
    assert_difference('Quality.count', -1) do
      delete :destroy, id: @quality
    end

    assert_redirected_to qualities_path
  end
end
