class Coupon < ApplicationRecord
  validates :name, uniqueness: true
  validates_presence_of :value, :coupon_type
  belongs_to :user

  enum coupon_type: [:percent, :dollar]

  def percent_off?
    self.coupon_type == "percent"
  end

  def dollar_off?
    self.coupon_type == "dollar"
  end

  def valid_for_items?(cart)
    cart.contents.any? do |item, quantity|
      item = Item.find(item.to_i)
      item.user.id == self.user.id
    end
  end

  # def redeem(cart)
  #   discount_total = 0
  #   cart.contents.each do |id, quantity|
  #     item = Item.find(id.to_i)
  #     if item.user.id == self.user.id
  #       if self.percent_off?
  #         current_price = item.price.to_f * quantity
  #         price = current_price - (self.value.to_f / 100) * current_price
  #       elsif self.dollar_off?
  #         price = (item.price.to_f * quantity) - self.value
  #       end
  #       discount_total += price
  #     else
  #       discount_total += (item.price.to_f * quantity)
  #     end
  #   end
  #   if discount_total < 0
  #     discount_total = 0
  #   end
  #   discount_total
  # end
end
