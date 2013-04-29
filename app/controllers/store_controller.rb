class StoreController < ApplicationController

  before_filter :find_cart, :except => :empty_cart
  before_filter :verify_merchant_credentials, :only => [:google]

  def index
    @products = Product.order(:title).all()
  end

  def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index("Invalid product")
    else
      @current_item = @cart.add_product(product)
      redirect_to_index unless request.xhr?
    end
  end

  def empty_cart
    session[:cart] = nil
    redirect_to_index
  end


  def checkout
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      # Use your own merchant ID and Key, set use_sandbox to false for production
      @frontend = Google4R::Checkout::Frontend.new(FRONTEND_CONFIGURATION)
      @frontend.tax_table_factory = TaxTableFactory.new
      checkout_command = @frontend.create_checkout_command
      # Adding an item to shopping cart
      checkout_command.shopping_cart.create_item do |item|
        item.name = "Dry Food Pack"
        item.description = "A pack of highly nutritious..."
        item.unit_price = Money.new(3500, "USD") # $35.00
        item.quantity = 1
      end
      # Create a flat rate shipping method
      checkout_command.create_shipping_method(Google4R::Checkout::FlatRateShipping) do |shipping_method|
        shipping_method.name = "UPS Standard 3 Day"
        shipping_method.price = Money.new(500, "USD")
        # Restrict to ship only to California
        shipping_method.create_allowed_area(Google4R::Checkout::UsStateArea) do |area|
          area.state = "CA"
        end
      end
      response = checkout_command.send_to_google_checkout
      puts response.redirect_url
    end
  end



  #def save_order
  #  @order = Order.new(params[:order])
  #  @order.add_line_items_from_cart(@cart)
  #  if @order.save
  #    session[:cart] = nil
  #    redirect_to_index("Thank you for your order")
  #  else
  #    render :action => :checkout
  #  end
  #end

  def google
    frontend = Google4R::Checkout::Frontend.new(FRONTEND_CONFIGURATION)
    handler = frontend.create_notification_handler

    begin
       notification = handler.handle(request.raw_post) # raw_post contains the XML
    rescue Google4R::Checkout::UnknownNotificationType
       # This can happen if Google adds new commands and Google4R has not been
       # upgraded yet. It is not fatal.
       logger.warn "Unknown notification type"
       return render :text => 'ignoring unknown notification type', :status => 200
    end

    case notification
    when Google4R::Checkout::NewOrderNotification then

      # handle a NewOrderNotification

    when Google4R::Checkout::OrderStateChangeNotification then

      # handle an OrderStateChangeNotification

    else
      return head :text => "I don't know how to handle a #{notification.class}", :status => 500
    end

    notification_acknowledgement = Google4R::Checkout::NotificationAcknowledgement.new(notification)
    render :xml => notification_acknowledgement.to_xml, :status => 200
  end

private

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to "/" #store_index_url
  end


  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

  def verify_merchant_credentials
    authenticate_or_request_with_http_basic("Google Checkout notification endpoint") do |merchant_id, merchant_key|
      (FRONTEND_CONFIGURATION['merchant_id'].to_s == merchant_id.to_s) and (FRONTEND_CONFIGURATION['merchant_key'].to_s == merchant_key.to_s)
    end
  end
end

class TaxTableFactory
  def effective_tax_tables_at(time)
    # Tax table 1 will be used before Apr 09 2008
    if time < Time.parse("Wed Apr 09 08:56:03 CDT 2008") then
      table1 = Google4R::Checkout::TaxTable.new(false)
      table1.name = "Default Tax Table"
      table1.create_rule do |rule|
        # Set California tax to 8%
        rule.area = Google4R::Checkout::UsStateArea.new("CA")
        rule.rate = 0.08
      end
      [ table1 ]
    else
      table2 = TaxTable.new
      # ... set rules
      [ table2 ]
    end
  end
end

