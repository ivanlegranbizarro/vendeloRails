class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async

    @pagy, @products = pagy_countless(FindProducts.new.call(params).load_async, items: 12)
  end

  def show
    product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity, alert: t('.not_created')
    end
  end

  def edit
    product
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity, notice: t('.not_updated')
    end
  end

  def destroy
    @product.destroy
    if @product.destroyed?
      redirect_to products_path, notice: t('.deleted')
    else
      redirect_to products_path, status: :unprocessable_entity, alert: t('.not_deleted')
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :description, :image, :category_id)
  end

  def product
    @product = Product.find(params[:id])
  end
end
