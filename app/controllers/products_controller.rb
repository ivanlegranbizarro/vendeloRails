class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async
    @products = Product.all.with_attached_image.order(created_at: :desc).load_async

    @products = @products.where(category_id: params[:category_id]) if params[:category_id]

    @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?

    return unless params[:max_price].present?

    @products = @products.where('price <= ?', params[:max_price])
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
