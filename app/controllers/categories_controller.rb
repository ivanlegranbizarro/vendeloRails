class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = t('.created')
      redirect_to categories_url
    else
      render :new, status: :unprocessable_entity, alert: t('.not_created')
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = t('.updated')
      redirect_to categories_url
    else
      render :edit, status: :unprocessable_entity, alert: t('.not_updated')
    end
  end

  def destroy
    @category.destroy
    if @category.destroyed?
      flash[:notice] = t('.deleted')
      redirect_to categories_url
    else
      redirect_to categories_url, status: :unprocessable_entity, alert: t('.not_deleted')
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
