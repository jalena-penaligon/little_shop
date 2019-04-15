require 'rails_helper'

RSpec.describe 'coupon index' do
  describe 'as a merchant' do
    describe 'when I visit my dashboard' do
      it 'has a link to view my coupons' do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
        coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1)
        coupon_3 = merchant.coupons.create(name: "10 Percent", value: 10, coupon_type: 0)

        visit dashboard_path

        click_link "View My Coupons"

        expect(current_path).to eq(merchant_coupons_path(merchant))

        within "#coupon-#{coupon_1.id}" do
          expect(page).to have_content(coupon_1.name)
          expect(page).to have_content("Value: 50% Off")
        end

        within "#coupon-#{coupon_2.id}" do
          expect(page).to have_content(coupon_2.name)
          expect(page).to have_content("Value: $10 Off")
        end

        within "#coupon-#{coupon_3.id}" do
          expect(page).to have_content(coupon_3.name)
          expect(page).to have_content("Value: 10% Off")
        end
      end
    end

    describe 'when I visit my coupons page' do
      it 'has a button to enable or disable coupons' do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
        coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1, active: false)
        coupon_3 = merchant.coupons.create(name: "10 Percent", value: 10, coupon_type: 0)

        visit merchant_coupons_path(merchant)

        within "#coupon-#{coupon_1.id}" do
          click_button("Disable")
          coupon_1.reload
          expect(coupon_1.active).to eq(false)
        end

        within "#coupon-#{coupon_2.id}" do
          click_button("Enable")
          coupon_2.reload
          expect(coupon_2.active).to eq(true)
        end
      end
    end
  end
end
