require 'rails_helper'

RSpec.describe 'redeem a coupon code', type: :feature do
  context 'as a registered user' do
    describe 'when I visit my cart page' do
      it 'can add a coupon code before checkout' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, user: merchant_1, inventory: 3)
        item_2 = create(:item, user: merchant_1)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        expect(page).to have_content("Your coupon code has been applied.")
        expect(page).to have_content("Discounted Total: $6.00")
        expect(page).to have_content("Applied to Cart: save20")
      end

      it 'only applies the discount to the coupon merchants items' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 8, user: merchant_2)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        expect(page).to have_content("Your coupon code has been applied.")
        expect(page).to have_content("Discounted Total: $12.00")
        expect(page).to have_content("Applied to Cart: save20")
      end

      it 'will not apply an invalid coupon code' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 8, user: merchant_2)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "fakecouponcode"
        click_button "Apply"

        expect(page).to have_content("Invalid coupon code.")
        expect(page).to have_content("Total: $13.00")
      end

      it 'will not apply an inactive coupon code' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 8, user: merchant_2)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0, active: false)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        expect(page).to have_content("Coupon is no longer active.")
        expect(page).to have_content("Total: $13.00")
      end

      it 'will not apply a valid code if no items from that merchant are added' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_2, inventory: 3)
        item_2 = create(:item, price: 8, user: merchant_2)
        coupon = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        expect(page).to have_content("Coupon code is not valid for your cart items.")
        expect(page).to have_content("Total: $13.00")
        expect(page).to_not have_content("Applied to Cart: save20")
      end

      it 'will only allow 1 code at a time' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        item_2 = create(:item, price: 8, user: merchant_2)
        coupon_1 = merchant_1.coupons.create(name: "save20", value: 20, coupon_type: 0)
        coupon_2 = merchant_2.coupons.create(name: "take5", value: 5, coupon_type: 1)

        visit item_path(item_1)
        click_on "Add to Cart"
        visit item_path(item_2)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "save20"
        click_button "Apply"

        expect(page).to have_content("Your coupon code has been applied.")
        expect(page).to have_content("Discounted Total: $12.00")
        expect(page).to have_content("Applied to Cart: save20")

        fill_in "Coupon Code:", with: "take5"
        click_button "Apply"

        expect(page).to have_content("Your coupon code has been applied.")
        expect(page).to have_content("Discounted Total: $8.00")
        expect(page).to have_content("Applied to Cart: take5")
      end

      it 'will not drop cart price below 0' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 5, user: merchant_1, inventory: 3)
        coupon_1 = merchant_1.coupons.create(name: "take10", value: 10, coupon_type: 1)

        visit item_path(item_1)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "take10"
        click_button "Apply"

        expect(page).to have_content("Your coupon code has been applied.")
        expect(page).to have_content("Discounted Total: $0.00")
        expect(page).to have_content("Applied to Cart: take10")
      end

      it 'will not allow a user to use the same code twice' do
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 15, user: merchant_1, inventory: 3)
        coupon_1 = merchant_1.coupons.create(name: "take10", value: 10, coupon_type: 1)

        visit item_path(item_1)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "take10"
        click_button "Apply"
        click_button "Check Out"

        user.reload

        visit item_path(item_1)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "take10"
        click_button "Apply"

        expect(page).to have_content("You have already used this coupon code.")
        expect(page).to have_content("Total: $15.00")
        expect(page).to_not have_content("Applied to Cart: take10")
      end

      it 'will not allow a user to add code as visitor then login and checkout with previously used code' do
        user = create(:user)
        merchant_1 = create(:merchant)
        item_1 = create(:item, price: 15, user: merchant_1, inventory: 3)
        coupon_1 = merchant_1.coupons.create(name: "take10", value: 10, coupon_type: 1)
        user.orders.create(coupon_id: coupon_1.id)
        visit item_path(item_1)
        click_on "Add to Cart"

        visit cart_path

        fill_in "Coupon Code:", with: "take10"
        click_button "Apply"

        click_link "Log in"

        fill_in :Email, with: user.email
        fill_in :Password, with: user.password

        click_button("Log in")

        visit cart_path

        click_button "Check Out"

        expect(page).to have_content("You have already used coupon take10.")
      end
    end
  end
end
