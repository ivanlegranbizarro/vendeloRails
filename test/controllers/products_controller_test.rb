require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "render the list of products" do
    get products_path
    assert_response :success
    assert_select ".product", 2
  end

  test "render the details of a product" do
    get product_path(products(:one))
    assert_response :success
    assert_select ".title", "Nintendo Switch"
    assert_select ".price", "225.35€"
    assert_select ".description", "Una Nintendo Switch que funciona fantásticamente"
  end

  test "render the form to create a new product" do
    get new_product_path
    assert_response :success
    assert_select "form" do
      assert_select "input[name='product[title]']"
      assert_select "input[name='product[price]']"
      assert_select "textarea[name='product[description]']"
    end
  end

  test "create a new product" do
    assert_difference "Product.count", 1 do
      post products_path, params: { product: { title: "Nintendo Switch", price: 225.35, description: "Una Nintendo Switch que funciona fantásticamente" } }
    end
    assert_redirected_to products_path
  end
end
