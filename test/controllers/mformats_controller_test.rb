require 'test_helper'

class MformatsControllerTest < ActionController::TestCase
  setup do
    @mformat = mformats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mformats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mformat" do
    assert_difference('Mformat.count') do
      post :create, mformat: { mformat: @mformat.mformat, notes: @mformat.notes }
    end

    assert_redirected_to mformat_path(assigns(:mformat))
  end

  test "should show mformat" do
    get :show, id: @mformat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mformat
    assert_response :success
  end

  test "should update mformat" do
    patch :update, id: @mformat, mformat: { mformat: @mformat.mformat, notes: @mformat.notes }
    assert_redirected_to mformat_path(assigns(:mformat))
  end

  test "should destroy mformat" do
    assert_difference('Mformat.count', -1) do
      delete :destroy, id: @mformat
    end

    assert_redirected_to mformats_path
  end
end
