require 'rails_helper'

RSpec.describe 'coupon show page' do
  describe 'as a merchant' do
    it "can display a single coupon page" do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)
      coupon_2 = merchant.coupons.create(name: "$10 Off", value: 10, coupon_type: 1)
      coupon_3 = merchant.coupons.create(name: "10 Percent", value: 10, coupon_type: 0)

      visit merchant_coupons_path(merchant)

      click_link "#{coupon_1.name}"

      expect(current_path).to eq(merchant_coupon_path(merchant, coupon_1))

      expect(page).to have_content(coupon_1.name)
      expect(page).to have_content("Value: 50% Off")
      expect(page).to have_button("Disable")
      expect(page).to have_button("Edit")
      expect(page).to have_button("Delete")
    end
  end

  describe 'when I visit my coupon show page' do
    it 'has a button to enable or disable coupons' do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)

      visit merchant_coupon_path(merchant, coupon_1)

      click_button("Disable")
      coupon_1.reload
      expect(coupon_1.active).to eq(false)

      visit merchant_coupon_path(merchant, coupon_1)

      click_button("Enable")
      coupon_1.reload
      expect(coupon_1.active).to eq(true)
    end
  end
end
