class Admin::UsersController < ApplicationController

  layout 'admin'

  before_filter :authenticate_admin!
  before_filter :get_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.order(get_order(params)).all()
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created'
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def edit; end

  def update
    if @user.update_with_password(params[:user])
      flash[:notice] = 'User was successfully updated'
      redirect_to admin_users_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = 'User was successfully deleted'
    redirect_to admin_users_path
  end

private

  def get_user
    @user = User.find(params[:id])
  end

end
