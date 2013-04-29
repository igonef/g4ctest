class Admin::ProductsController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :get_product, :only => [:show, :edit, :update, :destroy]

  def index
    @products = Product.order(get_order(params)).all()
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Product was successfully created'
      redirect_to admin_products_path
    else
      render :action => 'new'
    end
  end

  def edit; end

  def update
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated'
      redirect_to admin_products_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = 'Product was successfully deleted'
    redirect_to admin_products_path
  end

private

  def get_product
    @product = Product.find(params[:id])
  end

end
