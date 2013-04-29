require 'test_helper'

class Admin::ProductsControllerTest < ActionController::TestCase

  context "Controller" do
    #      admin_products GET    /admin/products(.:format)          {:controller=>"admin/products", :action=>"index"}
    #                     POST   /admin/products(.:format)          {:controller=>"admin/products", :action=>"create"}
    #   new_admin_product GET    /admin/products/new(.:format)      {:controller=>"admin/products", :action=>"new"}
    #  edit_admin_product GET    /admin/products/:id/edit(.:format) {:controller=>"admin/products", :action=>"edit"}
    #       admin_product GET    /admin/products/:id(.:format)      {:controller=>"admin/products", :action=>"show"}
    #                     PUT    /admin/products/:id(.:format)      {:controller=>"admin/products", :action=>"update"}
    #                     DELETE /admin/products/:id(.:format)      {:controller=>"admin/products", :action=>"destroy"}
    should "have valid routes" do
      route(:get, "/admin/products").to :controller=>"admin/products", :action => :index
      route(:post, "/admin/products").to :controller=>"admin/products", :action => :create
      route(:get, "/admin/products/new").to :controller=>"admin/products", :action => :new
      route(:get, "/admin/products/1").to :action => :show, :id => 1
      route(:get, "/admin/products/1/edit").to :controller=>"admin/products", :action => :edit, :id => 1
      route(:put, "/admin/products/1").to :controller=>"admin/products", :action => :update, :id => 1
      route(:delete, "/admin/products/1").to :controller=>"admin/products", :action => :destroy, :id => 1
    end

  end

  context "when signed out handling GET /admin/products" do
    setup do
      get :index
    end

    should_deny_access :flash => /You need to sign in or sign up before continuing./i
  end

  signed_in_admin_context do

    context "handling GET /admin/products" do
      setup do
        @products = [FactoryGirl.create(:product)]
        get :index
      end

      should assign_to(:products).with { @products }
      should respond_with :success
      should render_template :index
      should_not set_the_flash
    end

    context "handling GET /admin/products/1" do
      setup do
        @product = FactoryGirl.create(:product)
        get :show, :id => @product.id
      end

      should assign_to(:product).with { @product }
      should respond_with :success
      should render_template :show
      should_not set_the_flash
    end

    context "handling GET /admin/products/new" do
      setup do
        get :new
      end

      should assign_to(:product)
      should respond_with :success
      should render_template :new
      should_not set_the_flash
    end

    context "handling POST /admin/products" do
      setup do
        category_attributes = FactoryGirl.attributes_for(:product)
        post :create, :product => category_attributes
      end

      should assign_to :product
      should set_the_flash.to "Product was successfully created"
      should redirect_to("index of products") { admin_products_path }
    end

    context "handling GET /admin/products/1/edit" do
      setup do
        @product = FactoryGirl.create(:product)
        get :edit, :id => @product.id
      end

      should assign_to(:product).with { @product }
      should respond_with :success
      should render_template :edit
      should_not set_the_flash
    end

    context "handling PUT /admin/products/1" do
      setup do
        @product = FactoryGirl.create(:product)
        product_attributes = FactoryGirl.attributes_for(:product, :title => "new Title")
        put :update, :id => @product.id, :product => product_attributes
      end

      should assign_to(:product).with { @product }
      should set_the_flash.to /Product was successfully updated/i
      should redirect_to("index of products") { admin_products_path }
    end

    context "handling PUT /admin/products/1 with error" do
      setup do
        @product = FactoryGirl.create(:product)
        product_attributes = FactoryGirl.attributes_for(:product, :title => "")
        put :update, :id => @product.id, :product => product_attributes
      end

      should assign_to(:product).with { @product }
      should_not set_the_flash #.to /Product was successfully updated/i
      should render_template :edit
    end

    context "handling DELETE /admin/products/:id" do
      setup do
        @product = FactoryGirl.create(:product)
        delete :destroy, :id => @product
      end

      should assign_to(:product).with { @product }
      should set_the_flash.to /Product was successfully deleted/i
      should redirect_to("index of products") { admin_products_path }
    end

  end

end
