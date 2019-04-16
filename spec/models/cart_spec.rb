require 'rails_helper'

RSpec.describe Cart do
  describe "Cart with existing contents" do
    before :each do
      @item_1 = create(:item, id: 1)
      @item_4 = create(:item, id: 4)
      @cart = Cart.new({"1" => 3, "4" => 2})
    end

    describe "#total_item_count" do
      it "returns the total item count" do
        expect(@cart.total_item_count).to eq(5)
      end
    end

    describe "#contents" do
      it "returns the contents" do
        expect(@cart.contents).to eq({"1" => 3, "4" => 2})
      end
    end

    describe "#count_of" do
      it "counts a particular item" do
        expect(@cart.count_of(1)).to eq(3)
      end
    end

    describe "#add_item" do
      it "increments an existing item" do
        @cart.add_item(1)
        expect(@cart.count_of(1)).to eq(4)
      end

      it "can increment an item not in the cart yet" do
        @cart.add_item(2)
        expect(@cart.count_of(2)).to eq(1)
      end
    end

    describe "#remove_item" do
      it "decrements an existing item" do
        @cart.remove_item(1)
        expect(@cart.count_of(1)).to eq(2)
      end

      it "deletes an item when count goes to zero" do
        @cart.remove_item(1)
        @cart.remove_item(1)
        @cart.remove_item(1)
        expect(@cart.contents.keys).to_not include("1")
      end
    end

    describe "#items" do
      it "can map item_ids to objects" do

        expect(@cart.items).to eq({@item_1 => 3, @item_4 => 2})
      end
    end

    describe "#total" do
      it "can calculate the total of all items in the cart" do
        expect(@cart.total).to eq(@item_1.price * 3 + @item_4.price * 2)
      end
    end

    describe "#subtotal" do
      it "calculates the total for a single item" do
        expect(@cart.subtotal(@item_1)).to eq(@cart.count_of(@item_1.id) * @item_1.price)
      end
    end

    describe "#discounted_total" do
      it 'returns the discounted price w/coupon' do
        merchant = create(:merchant)
        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
        item_1 = merchant.items.create(id: 10, name: "Item 1", price: 2.50, description: "Description", image: "image.jpg", inventory: 10)
        cart = Cart.new({"10" => 3})

        expect(cart.discounted_total(coupon_1.name)).to eq(3.75)
      end

      it 'only reduces price for coupon merchants items' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        coupon_1 = merchant_1.coupons.create(name: "take5", value: 5, coupon_type: 1)
        item_1 = merchant_1.items.create(id: 2, name: "Item 1", price: 2.50, description: "Description", image: "image.jpg", inventory: 10)
        item_2 = merchant_2.items.create(id: 3, name: "Item 1", price: 1, description: "Description", image: "image.jpg", inventory: 10)
        cart = Cart.new({"2" => 3, "3" => 2})

        expect(cart.discounted_total(coupon_1.name)).to eq(4.50)
      end

      it 'will not drop cart price below 0' do
        merchant_1 = create(:merchant)
        coupon_1 = merchant_1.coupons.create(name: "take10", value: 10, coupon_type: 1)
        item_1 = merchant_1.items.create(id: 27, name: "Item 1", price: 2.50, description: "Description", image: "image.jpg", inventory: 10)
        cart = Cart.new({"27" => 3})

        expect(cart.discounted_total(coupon_1.name)).to eq(0)
      end

      it 'will not apply a $ off discount multiple times' do
        merchant_1 = create(:merchant)
        coupon_1 = merchant_1.coupons.create(name: "take10", value: 10, coupon_type: 1)
        item_1 = merchant_1.items.create(id: 5, name: "Item 1", price: 15, description: "Description", image: "image.jpg", inventory: 10)
        item_2 = merchant_1.items.create(id: 6, name: "Item 2", price: 20, description: "Description", image: "image.jpg", inventory: 10)
        cart = Cart.new({"5" => 1, "6" => 1})

        expect(cart.discounted_total(coupon_1.name)).to eq(25)
      end
    end

    describe "#coupon_applied?" do
      it 'returns true when coupon applied' do
        merchant = create(:merchant)
        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
        item_1 = merchant.items.create(id: 7, name: "Item 1", price: 2.50, description: "Description", image: "image.jpg", inventory: 10)
        cart = Cart.new({"7" => 3})
        cart.discounted_total(coupon_1.name)

        expect(cart.coupon_applied?(coupon_1)).to eq(true)
        expect(cart.coupon_applied?(nil)).to eq(false)
      end
    end
  end

  describe "Cart with empty contents" do
    before :each do
      @cart = Cart.new(nil)
    end

    describe "#total_item_count" do
      it "returns 0 when there are no contents" do
        expect(@cart.total_item_count).to eq(0)
      end
    end

    describe "#contents" do
      it "returns empty contents" do
        expect(@cart.contents).to eq({})
      end
    end

    describe "#count_of" do
      it "counts non existent items as zero" do
        expect(@cart.count_of(1)).to eq(0)
      end
    end

    describe "#add_item" do
      it "increments the item's count" do
        @cart.add_item(2)
        expect(@cart.count_of(2)).to eq(1)
      end
    end
  end
end
