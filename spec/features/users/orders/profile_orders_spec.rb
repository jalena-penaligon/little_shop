require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Profile Orders page', type: :feature do
  before :each do
    @user = create(:user)
    @admin = create(:admin)

    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_2)
  end

  context 'as a registered user' do
    describe 'should show a message when user no orders' do
      scenario 'when logged in as user' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_orders_path

        expect(page).to have_content('You have no orders yet')
      end
    end

    describe 'should show information about each order when I do have orders' do
      before :each do
        yesterday = 1.day.ago
        @order = create(:order, user: @user, created_at: yesterday)
        @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
        @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)
      end

      scenario 'when logged in as user' do
        @user.reload
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_orders_path
      end

      after :each do
        expect(page).to_not have_content('You have no orders yet')

        within "#order-#{@order.id}" do
          expect(page).to have_link("Order ID #{@order.id}")
          expect(page).to have_content("Created: #{@order.created_at}")
          expect(page).to have_content("Last Update: #{@order.updated_at}")
          expect(page).to have_content("Status: #{@order.status}")
          expect(page).to have_content("Item Count: #{@order.total_item_count}")
          expect(page).to have_content("Total Cost: #{@order.total_cost}")
        end
      end
    end

    describe 'should show a single order show page' do
      before :each do
        yesterday = 1.day.ago
        @order = create(:order, user: @user, created_at: yesterday)
        @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 3, created_at: yesterday, updated_at: yesterday)
        @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 5, created_at: yesterday, updated_at: 2.hours.ago)
      end

      scenario 'when logged in as user' do
        @user.reload
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit profile_order_path(@order)
      end

      after :each do
        expect(page).to have_content("Order ID #{@order.id}")
        expect(page).to have_content("Created: #{@order.created_at}")
        expect(page).to have_content("Last Update: #{@order.updated_at}")
        expect(page).to have_content("Status: #{@order.status}")
        within "#oitem-#{@oi_1.id}" do
          expect(page).to have_content(@oi_1.item.name)
          expect(page).to have_content(@oi_1.item.description)
          expect(page.find("#item-#{@oi_1.item.id}-image")['src']).to have_content(@oi_1.item.image)
          expect(page).to have_content("Merchant: #{@oi_1.item.user.name}")
          expect(page).to have_content("Price: #{number_to_currency(@oi_1.price)}")
          expect(page).to have_content("Quantity: #{@oi_1.quantity}")
          expect(page).to have_content("Subtotal: #{number_to_currency(@oi_1.price*@oi_1.quantity)}")
          expect(page).to have_content("Subtotal: #{number_to_currency(@oi_1.price*@oi_1.quantity)}")
          expect(page).to have_content("Fulfilled: No")
        end
        within "#oitem-#{@oi_2.id}" do
          expect(page).to have_content(@oi_2.item.name)
          expect(page).to have_content(@oi_2.item.description)
          expect(page.find("#item-#{@oi_2.item.id}-image")['src']).to have_content(@oi_2.item.image)
          expect(page).to have_content("Merchant: #{@oi_2.item.user.name}")
          expect(page).to have_content("Price: #{number_to_currency(@oi_2.price)}")
          expect(page).to have_content("Quantity: #{@oi_2.quantity}")
          expect(page).to have_content("Subtotal: #{number_to_currency(@oi_2.price*@oi_2.quantity)}")
          expect(page).to have_content("Fulfilled: Yes")
        end
        expect(page).to have_content("Item Count: #{@order.total_item_count}")
        expect(page).to have_content("Total Cost: #{number_to_currency(@order.total_cost)}")
      end
    end

    describe 'when an order is placed with a coupon code' do
      it 'displays code on completed order page' do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 5, user: merchant_1)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        click_button "Check Out"

        order = Order.last

        visit profile_order_path(order)

        expect(page).to have_content("Total Cost: $8.00")
        expect(page).to have_content("Coupon Redeemed: save20")
      end

      it 'calculates the discounted price of the order' do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 10, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 20, user: merchant_1)
        coupon = merchant_1.coupons.create(name: "save5", value: 5, coupon_type: 1)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save5"
        click_button "Apply"

        click_button "Check Out"

        order = Order.last

        visit profile_order_path(order)

        expect(page).to have_content("Total Cost: $25.00")
        expect(page).to have_content("Coupon Redeemed: save5")
      end

      it 'calculates accurately when the discount is larger than the item price' do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 10, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 20, user: merchant_1)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 1)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        click_button "Check Out"

        order = Order.last

        visit profile_order_path(order)

        expect(page).to have_content("Total Cost: $10.00")
        expect(page).to have_content("Coupon Redeemed: save20")
      end
    end
  end
end
