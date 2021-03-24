class Promotion < ApplicationRecord
  has_many :coupons
  validates :name, :code, :discount_rate,
            :coupon_quantity, :expiration_date,
            presence: true
  validates :code, :name, uniqueness: true

  def generate_coupons!
    return if coupons.any?
      (1..coupon_quantity).each do |number|
        coupons.create!(code: "#{code} - #{'%04d' % number}")
      end
  end

  # TODO: Fazer testes para esse método
  def coupons?
    coupons.any?
  end
end
