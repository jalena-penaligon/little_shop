class Profile::OrdersController < ApplicationController
  before_action :require_reguser

  def index
    @user = current_user
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
    if @order.coupon_id != nil
      @coupon = Coupon.find(@order.coupon_id)
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.user == current_user
      @order.order_items.where(fulfilled: true).each do |oi|
        item = Item.find(oi.item_id)
        item.inventory += oi.quantity
        item.save
        oi.fulfilled = false
        oi.save
      end

      @order.status = :cancelled
      @order.save

      redirect_to profile_orders_path
    else
      render file: 'public/404', status: 404
    end
  end

  def create
    if coupon != nil && coupon.valid_for_user?(current_user) == false
      flash[:danger] = "You have already used coupon #{coupon.name}."
      session[:coupon_code].clear
      redirect_to cart_path
    else
      if coupon == nil
        order = Order.create(user: current_user, status: :pending)
      else
        order = Order.create(user: current_user, status: :pending, coupon_id: coupon.id)
        coupon_value = coupon.value
      end
      cart.items.each do |item, quantity|
        if percent_coupon_applied?(item)
          item_price = coupon.discount_percent_off(item)
          order.order_items.create(item: item, quantity: quantity, price: item_price)
        elsif dollar_coupon_applied?(item)
          item_price = coupon.discount_dollar_off(item, quantity, coupon_value)
          coupon_value = 0
          if item_price.class == Array
            price = item_price[0]
            coupon_value = item_price[1]
          end
          order.order_items.create(item: item, quantity: quantity, price: item_price)
        else
          order.order_items.create(item: item, quantity: quantity, price: item.price)
        end
      end
      session.delete(:cart)
      session.delete(:coupon_code)
      flash[:success] = "Your order has been created!"
      redirect_to profile_orders_path(@discounted_total)
    end
  end
end
