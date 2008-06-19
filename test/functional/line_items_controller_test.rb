require File.dirname(__FILE__) + '/../test_helper'

class LineItemsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_line_item
    assert_difference('LineItem.count') do
      post :create, :line_item => { }
    end

    assert_redirected_to line_item_path(assigns(:line_item))
  end

  def test_should_show_line_item
    get :show, :id => line_items(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => line_items(:one).id
    assert_response :success
  end

  def test_should_update_line_item
    put :update, :id => line_items(:one).id, :line_item => { }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  def test_should_destroy_line_item
    assert_difference('LineItem.count', -1) do
      delete :destroy, :id => line_items(:one).id
    end

    assert_redirected_to line_items_path
  end
end
