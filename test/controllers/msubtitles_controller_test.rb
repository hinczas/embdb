require 'test_helper'

class MsubtitlesControllerTest < ActionController::TestCase
  setup do
    @msubtitle = msubtitles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:msubtitles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create msubtitle" do
    assert_difference('Msubtitle.count') do
      post :create, msubtitle: { msubtitle: @msubtitle.msubtitle, notes: @msubtitle.notes }
    end

    assert_redirected_to msubtitle_path(assigns(:msubtitle))
  end

  test "should show msubtitle" do
    get :show, id: @msubtitle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @msubtitle
    assert_response :success
  end

  test "should update msubtitle" do
    patch :update, id: @msubtitle, msubtitle: { msubtitle: @msubtitle.msubtitle, notes: @msubtitle.notes }
    assert_redirected_to msubtitle_path(assigns(:msubtitle))
  end

  test "should destroy msubtitle" do
    assert_difference('Msubtitle.count', -1) do
      delete :destroy, id: @msubtitle
    end

    assert_redirected_to msubtitles_path
  end
end
