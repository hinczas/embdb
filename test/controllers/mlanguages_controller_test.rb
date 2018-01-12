require 'test_helper'

class MlanguagesControllerTest < ActionController::TestCase
  setup do
    @mlanguage = mlanguages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mlanguages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mlanguage" do
    assert_difference('Mlanguage.count') do
      post :create, mlanguage: { mlanguage: @mlanguage.mlanguage, notes: @mlanguage.notes }
    end

    assert_redirected_to mlanguage_path(assigns(:mlanguage))
  end

  test "should show mlanguage" do
    get :show, id: @mlanguage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mlanguage
    assert_response :success
  end

  test "should update mlanguage" do
    patch :update, id: @mlanguage, mlanguage: { mlanguage: @mlanguage.mlanguage, notes: @mlanguage.notes }
    assert_redirected_to mlanguage_path(assigns(:mlanguage))
  end

  test "should destroy mlanguage" do
    assert_difference('Mlanguage.count', -1) do
      delete :destroy, id: @mlanguage
    end

    assert_redirected_to mlanguages_path
  end
end
