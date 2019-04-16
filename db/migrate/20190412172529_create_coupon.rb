class CreateCoupon < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :value
      t.string :type

      t.timestamps
    end
  end
end
