class Dashboard::UsersController < Dashboard::BaseController

  def download_existing_customers
    @merchant = current_user
    ids = @merchant.existing_customer_ids
    @users = User.find(ids)
    data = User.build_existing_customers_csv(@users, @merchant)
    send_data data, type: "text/csv", disposition: "attachment"
  end

  def download_potential_customers
    @merchant = current_user
    ids = @merchant.existing_customer_ids
    @users = User.potential_customers(ids)
    data = User.build_potential_customers_csv(@users, @merchant)
    send_data data, type: "text/csv", disposition: "attachment"
  end
end
