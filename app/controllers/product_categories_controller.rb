class ProductCategoriesController < ApplicationController
  def index
    @product_category = ProductCategory.all
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_params)
    if @product_category.save
      redirect_to @product_category
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product_category).permit(:name, :code)
  end
end
