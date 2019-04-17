class User < ApplicationRecord
  has_secure_password

  enum role: [:default, :merchant, :admin]

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  # as a consumer
  has_many :orders
  has_many :order_items, through: :orders

  # as a merchant
  has_many :items, foreign_key: 'merchant_id'
  has_many :coupons

  def active_items
    items.where(active: true).order(:name)
  end

  def coupon_limit_reached?
    self.coupons.count == 5
  end

  def top_items_sold_by_quantity(limit)
    items.joins(order_items: :order)
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .select('items.id, items.name, sum(order_items.quantity) as quantity')
         .group(:id)
         .order('quantity DESC, id')
         .limit(limit)
  end

  def total_items_sold
    items.joins(order_items: :order)
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .pluck('sum(order_items.quantity)')
         .first
  end

  def percent_of_items_sold
    ((total_items_sold.to_f / total_inventory_remaining.to_f)*100)
  end

  def total_inventory_remaining
    items.sum(:inventory)
  end

  def top_states_by_items_shipped(limit)
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .group('users.state')
         .select('users.state, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(limit)
  end

  def top_cities_by_items_shipped(limit)
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .group('users.state, users.city')
         .select('users.state, users.city, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(limit)
  end

  def top_users_by_money_spent(limit)
    items.joins(:order_items)
        .joins('join orders on orders.id = order_items.order_id')
        .joins('join users on users.id = orders.user_id')
        .where(order_items: {fulfilled: true})
        .group('users.id')
        .select('users.name, sum(order_items.quantity * order_items.price) AS total')
        .order('total DESC')
        .limit(limit)
  end

  def top_user_by_order_count
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true})
         .group('users.id')
         .select('users.name, count(orders.id) AS count')
         .order('count DESC')
         .limit(1).first
  end

  def top_user_by_item_count
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true})
         .group('users.id')
         .select('users.name, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(1).first
  end

  def self.active_merchants
    where(role: :merchant, active: true)
  end

  def self.default_users
    where(role: :default)
  end

  def self.top_merchants_by_revenue(limit)
    merchants_sorted_by_revenue.limit(limit)
  end

  def self.merchants_sorted_by_revenue
    self.joins(:items)
        .joins('join order_items on items.id = order_items.item_id')
        .joins('join orders on orders.id = order_items.order_id')
        .where(orders: {status: :shipped}, order_items: {fulfilled: true})
        .group(:id)
        .select('users.*, sum(order_items.quantity * order_items.price) AS total')
        .order("total DESC")
  end

  def self.merchants_sorted_by_fulfillment_time(limit, order = :asc)
    self.joins(:items)
        .joins('join order_items on items.id = order_items.item_id')
        .joins('join orders on orders.id = order_items.order_id')
        .where.not(orders: {status: :cancelled})
        .where(order_items: {fulfilled: true})
        .group(:id)
        .select('users.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time')
        .order("fulfillment_time #{order}")
        .limit(limit)
  end

  def self.top_merchants_by_fulfillment_time(limit)
    merchants_sorted_by_fulfillment_time(limit)
  end

  def self.bottom_merchants_by_fulfillment_time(limit)
    merchants_sorted_by_fulfillment_time(limit, :desc)
  end

  def self.top_user_states_by_order_count(limit)
    self.joins(:orders)
        .where(orders: {status: :shipped})
        .group(:state)
        .select('users.state, count(orders.id) AS order_count')
        .order('order_count DESC')
        .limit(limit)
  end

  def self.top_user_cities_by_order_count(limit)
    self.joins(:orders)
        .where(orders: {status: :shipped})
        .group(:state, :city)
        .select('users.city, users.state, count(orders.id) AS order_count')
        .order('order_count DESC')
        .limit(limit)
  end

  def existing_customer_ids
    items.joins(:order_items)
    .joins('join orders on orders.id = order_items.order_id')
    .joins('join users on users.id = orders.user_id')
    .where(active: true)
    .order('users.name')
    .group('users.id')
    .pluck('users.id')
  end

  def self.potential_customers(ids)
    where.not(id: ids)
    .where(role: 0)
    .order(:name)
  end

  def self.spent_on_items(merchant_id, user_id)
    joins(orders: {order_items: :item})
    .where("orders.user_id = #{user_id}")
    .where("items.merchant_id = #{merchant_id}")
    .select("users.id, sum(order_items.quantity * order_items.price) as total")
    .group(:id)
  end

  def self.total_spend(user_id)
    joins(orders: {order_items: :item})
    .where("orders.user_id = #{user_id}")
    .select("users.id, sum(order_items.quantity * order_items.price) as total_spend")
    .group(:id)
  end

  def total_orders
    orders.count
  end

  def generate_csv_row(merchant, current_customer = true)
    row = []
    row << self.name
    row << self.email
    if current_customer == true
      row << User.spent_on_items(merchant.id, self.id).first.total.round(2)
    else
      row << self.total_orders
    end
    row << User.total_spend(self.id).first.total_spend.round(2)
  end

  def self.build_existing_customers_csv(users, merchant)
    headers = %w{name email spent_on_your_items all_merchant_spend}

    CSV.generate(headers: true) do |csv|
      csv << headers

      users.each do |user|
        if user.active
          csv << user.generate_csv_row(merchant)
        end
      end
    end
  end

  def self.build_potential_customers_csv(users, merchant)
    headers = %w{name email total_orders total_spent}

    CSV.generate(headers: true) do |csv|
      csv << headers

      users.each do |user|
        if user.active
          csv << user.generate_csv_row(merchant, current_customer = false)
        end
      end
    end
  end
end
