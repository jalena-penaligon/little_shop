require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :value }
    it { should validate_presence_of :coupon_type }
  end

  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'instance methods' do
    it '.percent_off returns true when value is % off' do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1)

      expect(coupon_1.percent_off?).to eq(true)
      expect(coupon_2.percent_off?).to eq(false)
    end

    it ".dollar_off returns true when valus is $ off" do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1)

      expect(coupon_1.dollar_off?).to eq(false)
      expect(coupon_2.dollar_off?).to eq(true)
    end

    it '.valid_for_items returns true if coupon user_id and item user_id match' do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      item_1 = merchant.items.create(id: 1, name: "Item 1", price: 1, description: "Description", image: "image.jpg", inventory: 10)
      cart = Cart.new({"1" => 3})

      expect(coupon_1.valid_for_items?(cart)).to eq(true)
    end
  end
end
