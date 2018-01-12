require 'test_helper'

class PcbsControllerTest < ActionController::TestCase
  setup do
    @pcb = pcbs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pcbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pcb" do
    assert_difference('Pcb.count') do
      post :create, pcb: { brd_file: @pcb.brd_file, changelog: @pcb.changelog, cost: @pcb.cost, end_date: @pcb.end_date, name: @pcb.name, notes: @pcb.notes, parent_id: @pcb.parent_id, sch_file: @pcb.sch_file, start_date: @pcb.start_date, version: @pcb.version }
    end

    assert_redirected_to pcb_path(assigns(:pcb))
  end

  test "should show pcb" do
    get :show, id: @pcb
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pcb
    assert_response :success
  end

  test "should update pcb" do
    patch :update, id: @pcb, pcb: { brd_file: @pcb.brd_file, changelog: @pcb.changelog, cost: @pcb.cost, end_date: @pcb.end_date, name: @pcb.name, notes: @pcb.notes, parent_id: @pcb.parent_id, sch_file: @pcb.sch_file, start_date: @pcb.start_date, version: @pcb.version }
    assert_redirected_to pcb_path(assigns(:pcb))
  end

  test "should destroy pcb" do
    assert_difference('Pcb.count', -1) do
      delete :destroy, id: @pcb
    end

    assert_redirected_to pcbs_path
  end
end
