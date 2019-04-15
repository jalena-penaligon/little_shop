require 'rails_helper'

RSpec.describe 'edit a coupon', type: :feature do
  context "as a merchant" do
    describe 'when I visit my coupon index page' do
      it 'has a link to edit a coupon' do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
        coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1, active: false)
        coupon_3 = merchant.coupons.create(name: "10 Percent", value: 10, coupon_type: 0)

        visit merchant_coupons_path(merchant)

        within "#coupon-#{coupon_1.id}" do
          click_button("Edit")
        end

        expect(current_path).to eq(edit_merchant_coupon_path(merchant, coupon_1))
        expect(page).to have_selector("input[value='#{coupon_1.name}']")
        expect(page).to have_selector("input[value='#{coupon_1.value}']")

        fill_in :coupon_name, with: "A Coupon Has No Name"
        fill_in :coupon_value, with: 10
        choose(:coupon_coupon_type_dollar)

        click_button "Update Coupon"


        coupon_1.reload
        expect(coupon_1.name).to eq("A Coupon Has No Name")
        expect(coupon_1.value).to eq(10)
        expect(coupon_1.coupon_type).to eq("dollar")
        expect(current_path).to eq(merchant_coupons_path(merchant))
        expect(page).to have_content("Your coupon has been updated!")
      end
    end
  end

end
