require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  context "Controller" do
    #      admin_users GET    /admin/users(.:format)          {:controller=>"admin/users", :action=>"index"}
    #                  POST   /admin/users(.:format)          {:controller=>"admin/users", :action=>"create"}
    #   new_admin_user GET    /admin/users/new(.:format)      {:controller=>"admin/users", :action=>"new"}
    #  edit_admin_user GET    /admin/users/:id/edit(.:format) {:controller=>"admin/users", :action=>"edit"}
    #       admin_user GET    /admin/users/:id(.:format)      {:controller=>"admin/users", :action=>"show"}
    #                  PUT    /admin/users/:id(.:format)      {:controller=>"admin/users", :action=>"update"}
    #                  DELETE /admin/users/:id(.:format)      {:controller=>"admin/users", :action=>"destroy"}
    should "have valid routes" do
      route(:get, "/admin/users").to :controller=>"admin/users", :action => :index
      route(:post, "/admin/users").to :controller=>"admin/users", :action => :create
      route(:get, "/admin/users/new").to :controller=>"admin/users", :action => :new
      route(:get, "/admin/users/1").to :action => :show, :id => 1
      route(:get, "/admin/users/1/edit").to :controller=>"admin/users", :action => :edit, :id => 1
      route(:put, "/admin/users/1").to :controller=>"admin/users", :action => :update, :id => 1
      route(:delete, "/admin/users/1").to :controller=>"admin/users", :action => :destroy, :id => 1
    end

  end


  context "when signed out handling GET /admin/users" do
    setup do
      get :index
    end

    should_deny_access :flash => /You need to sign in or sign up before continuing./i
  end

  signed_in_admin_context do

    context "handling GET /admin/users" do
      setup do
        @users = [FactoryGirl.create(:user)]
        get :index
      end

      should assign_to(:users).with { @users }
      should respond_with :success
      should render_template :index
      should_not set_the_flash
    end

    context "handling GET /admin/users/1" do
      setup do
        @user = FactoryGirl.create(:user)
        get :show, :id => @user.id
      end

      should assign_to(:user).with { @user }
      should respond_with :success
      should render_template :show
      should_not set_the_flash
    end

    context "handling GET /admin/users/new" do
      setup do
        get :new
      end

      should assign_to(:user)
      should respond_with :success
      should render_template :new
      should_not set_the_flash
    end

    context "handling POST /admin/users" do
      setup do
        category_attributes = FactoryGirl.attributes_for(:user)
        post :create, :user => category_attributes
      end

      should assign_to :user
      should set_the_flash.to "User was successfully created"
      should redirect_to("index of users") { admin_users_path }
    end

    context "handling GET /admin/users/1/edit" do
      setup do
        @user = FactoryGirl.create(:user)
        get :edit, :id => @user.id
      end

      should assign_to(:user).with { @user }
      should respond_with :success
      should render_template :edit
      should_not set_the_flash
    end

    context "handling PUT /admin/users/1" do
      setup do
        @user = FactoryGirl.create(:user)
        user_attributes = FactoryGirl.attributes_for(:user, :first_name => "new name", :current_password => "user")
        put :update, :id => @user.id, :user => user_attributes
      end

      should assign_to(:user).with { @user }
      should set_the_flash.to /User was successfully updated/i
      should redirect_to("index of users") { admin_users_path }
    end

    context "handling PUT /admin/users/1 with error" do
      setup do
        @user = FactoryGirl.create(:user)
        category_attributes = FactoryGirl.attributes_for(:user, :email => "", :current_password => "user")
        put :update, :id => @user.id, :user => category_attributes
      end

      should assign_to(:user).with { @user }
      should_not set_the_flash #.to /User was successfully updated/i
      should render_template :edit
    end

    context "handling DELETE /admin/users/:id" do
      setup do
        @user = FactoryGirl.create(:user)
        delete :destroy, :id => @user
      end

      should assign_to(:user).with { @user }
      should set_the_flash.to /User was successfully deleted/i
      should redirect_to("index of users") { admin_users_path }
    end

  end

end
