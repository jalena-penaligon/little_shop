require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :value }
    it { should validate_presence_of :coupon_type }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
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

    it '.valid_for_user returns true if user has not redeemed coupon code' do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      item_1 = merchant.items.create(id: 1, name: "Item 1", price: 1, description: "Description", image: "image.jpg", inventory: 10)
      cart = Cart.new({"1" => 3})
      user = create(:user)

      expect(coupon_1.valid_for_user?(user)).to eq(true)

      order = user.orders.create(coupon_id: coupon_1.id)
      expect(coupon_1.valid_for_user?(user)).to eq(false)

      user = nil
      expect(coupon_1.valid_for_user?(user)).to eq(true)
    end

    it '.discount_percent_off(item) calculates the price from coupon' do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      item_1 = merchant.items.create(id: 1, name: "Item 1", price: 10, description: "Description", image: "image.jpg", inventory: 10)

      expect(coupon_1.discount_percent_off(item_1)).to eq(5.0)
    end

    describe '.discount_dollar_off(item) calculates the price from coupon' do
      it 'calculates when dollar off is less than current price' do
        merchant = create(:merchant)
        coupon_1 = merchant.coupons.create(name: "take5", value: 5, coupon_type: 1)
        item_1 = merchant.items.create(id: 1, name: "Item 1", price: 5, description: "Description", image: "image.jpg", inventory: 10)
        quantity = 2

        expect(coupon_1.discount_dollar_off(item_1, quantity, coupon_1.value)).to eq(2.50)
      end

      it 'calculates when dollar off is greater than current price' do
        merchant = create(:merchant)
        coupon_1 = merchant.coupons.create(name: "take20", value: 20, coupon_type: 1)
        item_1 = merchant.items.create(id: 1, name: "Item 1", price: 5, description: "Description", image: "image.jpg", inventory: 10)
        quantity = 2

        expect(coupon_1.discount_dollar_off(item_1, quantity, coupon_1.value)).to eq([0, 10.0])
      end
    end

    it '.redeemed? returns true when a user has redeemed code' do
      merchant = create(:merchant)
      coupon_1 = merchant.coupons.create(name: "take20", value: 20, coupon_type: 1)

      expect(coupon_1.redeemed?).to eq(false)

      user = create(:user)
      order = user.orders.create(coupon_id: coupon_1.id)
      expect(coupon_1.redeemed?).to eq(true)
    end
  end
end
