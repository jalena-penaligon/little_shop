class Coupon < ApplicationRecord
  validates :name, uniqueness: true
  validates_presence_of :value, :coupon_type
  belongs_to :user
  has_many :orders

  enum coupon_type: [:percent, :dollar]

  def percent_off?
    self.coupon_type == "percent"
  end

  def dollar_off?
    self.coupon_type == "dollar"
  end

  def redeemed?
    Order.any?{ |o| o.coupon_id == self.id }
  end

  def valid_for_items?(cart)
    cart.contents.any? do |item, quantity|
      item = Item.find(item.to_i)
      item.user.id == self.user.id
    end
  end

  def valid_for_user?(user)
    if user == nil
      true
    elsif user.orders == []
      true
    else
      user.orders.none?{ |o| o.coupon_id == self.id }
    end
  end

  def discount_percent_off(item)
    current_price = item.price.to_f
    price = current_price - ((self.value.to_f / 100) * current_price)
  end

  def discount_dollar_off(item, quantity, coupon_value)
    current_price = item.price.to_f * quantity
    if current_price > coupon_value
      price = current_price - coupon_value
      coupon_value = 0
      item_price = price / quantity
    else
      price = 0
      coupon_value = coupon_value - current_price
      remainder = [price, coupon_value]
    end
  end

end
