class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async
    @products = Product.all.with_attached_image

    @products = @products.where(category_id: params[:category_id]) if params[:category_id]
    @products = @products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    @products = @products.where('price <= ?', params[:max_price]) if params[:max_price].present?

    # Filtrar productos por nombre y descripción si el parámetro 'name' está presente
    if params[:name].present?
      search_term = "%#{params[:name].downcase}%"
      @products = @products.where('LOWER(title) LIKE ? OR LOWER(description) LIKE ?', search_term, search_term)
    end

    orders = {
      newest: 'created_at DESC',
      expensive: 'price DESC',
      cheapest: 'price ASC'
    }.fetch(params[:order_by]&.to_sym, 'created_at DESC')
    @products = @products.order(orders).load_async

    @pagy, @products = pagy_countless(@products, items: 10)
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
