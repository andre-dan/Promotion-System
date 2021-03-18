class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.string :code
      t.string :expiration_date
      t.integer :discount_rate
      t.integer :coupon_quantity

      t.timestamps
    end
  end
end
