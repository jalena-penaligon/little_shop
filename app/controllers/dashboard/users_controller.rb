class Dashboard::UsersController < Dashboard::BaseController

  def download_existing_customers
    @users = User.all.first(5)
    data = User.build_existing_customers_csv(@users)
    send_data data, type: "text/csv", disposition: "attachment"
  end

  private

  # def build_existing_customers_csv(users)
  #   attributes = %w{name email}
  #
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  #
  #     users.each do |user|
  #       csv << user.attributes.values_at(*attributes)
  #     end
  #   end
  # end

end
