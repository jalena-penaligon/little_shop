class ChangeCouponValueToIntegerInCoupons < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :coupon_type, 'integer USING CAST(coupon_type AS integer)'
  end
end
