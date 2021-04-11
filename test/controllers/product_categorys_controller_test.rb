require 'test_helper'

class ProductCategorysControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get product_categorys_index_url
    assert_response :success
  end
end
