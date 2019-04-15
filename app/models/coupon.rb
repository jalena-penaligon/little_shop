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
end
