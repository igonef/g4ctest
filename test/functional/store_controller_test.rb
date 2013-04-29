require 'test_helper'

class StoreControllerTest < ActionController::TestCase

  context "Controller" do
    #    checkout_store_index POST   /store/checkout(.:format)          store#checkout
    #  empty_cart_store_index POST   /store/empty_cart(.:format)        store#empty_cart
    #       add_to_cart_store POST   /store/:id/add_to_cart(.:format)   store#add_to_cart
    #             store_index GET    /store(.:format)                   store#index
    should "have valid routes" do
      route(:post, "/store/checkout").to :controller=>"store", :action => :checkout
      route(:post, "/store/empty_cart").to :controller=>"store", :action => :empty_cart
      route(:post, "/store/1/add_to_cart").to :controller=>"store", :action => :add_to_cart, :id => 1
      route(:get, "/store").to :controller=>"store", :action => :index
    end

  end


end
