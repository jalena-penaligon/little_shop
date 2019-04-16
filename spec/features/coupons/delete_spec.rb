require 'rails_helper'

RSpec.describe 'delete a coupon', type: :feature do
  context "as a merchant" do
    describe "when I visit my coupons index page" do
      it "has a link to delete a coupon" do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)

        visit merchant_coupon_path(merchant, coupon_1)

        click_button("Delete")
        expect(current_path).to eq(merchant_coupons_path(merchant))

        expect(page).to_not have_content(coupon_1.name)
        expect(page).to have_content("Your coupon has been deleted.")
      end
    end

    describe "if a coupon has been redeemed" do
      it "cannot be deleted" do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        coupon_1 = merchant.coupons.create(name: "Half Off", value: 50, coupon_type: 0)

        user = create(:user)
        order = user.orders.create(coupon_id: coupon_1.id)

        visit merchant_coupon_path(merchant, coupon_1)

        expect(page).to_not have_button("Delete")
      end
    end
  end
end
