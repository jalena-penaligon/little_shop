class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
    @contents.default = 0
  end

  def total_item_count
    @contents.values.sum
  end

  def add_item(item_id)
    @contents[item_id.to_s] += 1
  end

  def remove_item(item_id)
    @contents[item_id.to_s] -= 1
    @contents.delete(item_id.to_s) if count_of(item_id) == 0
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def items
    @items ||= load_items
  end

  def load_items
    @contents.map do |item_id, quantity|
      item = Item.find(item_id)
      [item, quantity]
    end.to_h
  end

  def total
    items.sum do |item, quantity|
      item.price * quantity
    end
  end

  def subtotal(item)
    count_of(item.id) * item.price
  end

  def discounted_total(coupon_name)
    discount_total = 0
    coupon = Coupon.find_by(name: coupon_name)
    coupon_value = coupon.value
    self.contents.each do |id, quantity|
      item = Item.find(id.to_i)
      if item.user.id == coupon.user.id
        if coupon.percent_off?
          current_price = item.price.to_f * quantity
          price = current_price - (coupon.value.to_f / 100) * current_price
        elsif coupon.dollar_off?
          current_price = item.price.to_f * quantity
          if current_price > coupon_value
            price = current_price - coupon_value
            coupon_value = 0
          else
            price = 0
            coupon_value = coupon_value - current_price
          end
        end
        discount_total += price
      else
        discount_total += (item.price.to_f * quantity)
      end
    end
    discount_total
  end

  def coupon_applied?(coupon)
    coupon != nil
  end

end
