class CouponsController < ApplicationController

  def index
    @merchant = User.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def new
    @coupon = Coupon.new
    @merchant = User.find(params[:merchant_id])
  end

  def create
    @merchant = User.find(params[:merchant_id])
    @coupon = @merchant.coupons.new(coupon_params)
    @coupon.save

    redirect_to merchant_coupons_path(@merchant)
  end

  def redeem
    if @coupon = Coupon.find_by(name: params[:coupon_code])
      if @coupon.valid_for_items?(cart)
        # session["discounted_total"] = @coupon.redeem(cart)
        session["coupon_code"] = @coupon.name
        flash[:success] = "Your coupon code has been applied."
        redirect_to cart_path
      else
        flash[:danger] = "Coupon code is not valid for your cart items."
        redirect_to cart_path
      end
    else
      flash[:danger] = "Invalid coupon code."
      redirect_to cart_path
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :coupon_type, :value)
  end
end
