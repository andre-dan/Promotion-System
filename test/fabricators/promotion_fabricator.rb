Fabricator(:promotion) do
  name 'Natal'
  description 'Promoção de natal'
  code { sequence(:code) { |i| "NATAL#{i}" } }
  discount_rate 15
  coupon_quantity 5
  expiration_date '22/12/2033'
  user
end
