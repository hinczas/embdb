require 'test_helper'

class MyearsControllerTest < ActionController::TestCase
  setup do
    @myear = myears(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:myears)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create myear" do
    assert_difference('Myear.count') do
      post :create, myear: { myear: @myear.myear, notes: @myear.notes }
    end

    assert_redirected_to myear_path(assigns(:myear))
  end

  test "should show myear" do
    get :show, id: @myear
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @myear
    assert_response :success
  end

  test "should update myear" do
    patch :update, id: @myear, myear: { myear: @myear.myear, notes: @myear.notes }
    assert_redirected_to myear_path(assigns(:myear))
  end

  test "should destroy myear" do
    assert_difference('Myear.count', -1) do
      delete :destroy, id: @myear
    end

    assert_redirected_to myears_path
  end
end
