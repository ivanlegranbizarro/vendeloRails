class ProductsController < ApplicationController
  def index
    @products = Product.all.with_attached_image
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
      redirect_to products_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity, notice: "Product was not created."
    end
  end

  def edit
    product
  end

  def update
    if product.update(product_params)
      redirect_to products_path, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity, notice: "Product was not updated."
    end
  end

  def destroy
    product.destroy
    if product.destroyed?
      redirect_to products_path, notice: "Product was successfully deleted."
    else
      redirect_to products_path, status: :unprocessable_entity, alert: "Product was not deleted."
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :description, :image)
  end

  def product
    @product = Product.find(params[:id])
  end
end
