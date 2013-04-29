require 'test_helper'

class CartTest < ActiveSupport::TestCase

  context "A Cart add unique products" do

    setup do
      @cart = Cart.new
      @rails_book = FactoryGirl.create(:product)
      @ruby_book  = FactoryGirl.create(:product)
      @cart.add_product @rails_book
      @cart.add_product @ruby_book
    end

    subject { @cart }

    should "valid items size" do
      assert_equal 2, subject.items.size
    end

    should "valid total price" do
      assert_equal @rails_book.price+@ruby_book.price, subject.total_price
    end

  end

  context "A Cart add duplicate product" do

    setup do
      @cart = Cart.new
      @rails_book = FactoryGirl.create(:product)
      @cart.add_product @rails_book
      @cart.add_product @rails_book
    end

    subject { @cart }

    should "valid items size" do
      assert_equal 1, subject.items.size
    end

    should "valid first item quantity" do
      assert_equal 2, subject.items[0].quantity
    end

    should "valid total price" do
      assert_equal 2*@rails_book.price, subject.total_price
    end

  end

end
