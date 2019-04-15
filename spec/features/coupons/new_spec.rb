require 'rails_helper'

RSpec.describe 'create new coupon' do
  describe 'as a merchant' do
    describe 'when I visit my coupons page' do
      it 'has a link to add new coupons' do
        merchant = create(:merchant, id: 1)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        visit merchant_coupons_path(merchant)

        click_link("Add a New Coupon")

        expect(current_path).to eq(new_merchant_coupon_path(merchant))

        fill_in :coupon_name, with: "A Coupon Has No Name"
        fill_in :coupon_value, with: 10
        choose(:coupon_coupon_type_percent)

        click_button "Create Coupon"

        coupon = merchant.coupons.last
      
        expect(current_path).to eq(merchant_coupons_path(merchant))

        within "#coupon-#{coupon.id}" do
          expect(page).to have_content(coupon.name)
          expect(page).to have_content("Value: 10% Off")
        end
      end
    end
  end
end
