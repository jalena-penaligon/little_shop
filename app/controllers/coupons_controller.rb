class CouponsController < ApplicationController

  def index
    @merchant = User.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show
    @merchant = User.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end

  def new
    @coupon = Coupon.new
    @merchant = User.find(params[:merchant_id])
  end

  def create
    @merchant = User.find(params[:merchant_id])
    @coupon = @merchant.coupons.new(coupon_params)
    if @merchant.coupon_limit_reached?
      flash[:danger] = "You have added the maximum number of coupons."
    else
      @coupon.save
    end
    redirect_to merchant_coupons_path(@merchant)
  end

  def edit
    @merchant = User.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    @merchant = User.find(params[:merchant_id])
    if @coupon.update(coupon_params)
      flash[:success] = "Your coupon has been updated!"
      redirect_to merchant_coupons_path(@merchant)
    else
      flash[:danger] = "Your coupon was missing info."
      render :edit
    end
  end

  def redeem
    if @coupon = Coupon.find_by(name: params[:coupon_code])
      if @coupon.valid_for_items?(cart) && @coupon.valid_for_user?(current_user) && @coupon.active
        session["coupon_code"] = @coupon.name
        flash[:success] = "Your coupon code has been applied."
        redirect_to cart_path
      elsif @coupon.valid_for_user?(current_user) == false
        flash[:danger] = "You have already used this coupon code."
        redirect_to cart_path
      elsif @coupon.active == false
        flash[:danger] = "Coupon is no longer active."
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

  def active_toggle
    @coupon = Coupon.find(params[:coupon_id])
    @merchant = User.find(params[:merchant_id])
    if @coupon.active
      @coupon.active = false
      @coupon.save
      flash[:success] = "Your coupon is now disabled."
      redirect_to merchant_coupons_path(@merchant)
    else
      @coupon.active = true
      @coupon.save
      flash[:success] = "Your coupon is now enabled."
      redirect_to merchant_coupons_path(@merchant)
    end
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @merchant = User.find(params[:merchant_id])
    if @coupon.destroy
      flash[:success] = "Your coupon has been deleted."
    end
    redirect_to merchant_coupons_path(@merchant)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :coupon_type, :value)
  end
end
