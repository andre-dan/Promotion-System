require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do
    login_as_before
    post '/promotions', params: { promotion: {
      name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10,
      coupon_quantity: 100, expiration_date: '22/12/2033'
    } }

    assert_redirected_to promotion_path(Promotion.last)
    follow_redirect!
    assert_select 'h3', 'Natal'
  end

  test 'cannot create a promotion without login' do
    post '/promotions', params: { promotion: {
      name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10,
      coupon_quantity: 100, expiration_date: '22/12/2033'
    } }

    assert_redirected_to new_user_session_path
  end

  test 'cannot generate coupons without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100, expiration_date: '22/12/2033', user: user)

    post generate_coupons_promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'cannot update a promotion without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Cyber Monday',
                                  coupon_quantity: 100,
                                  description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15,
                                  expiration_date: '22/12/2033', user: user)

    patch promotion_path(promotion), params: { **@promotion_params }
    assert_redirected_to new_user_session_path
  end

  test 'cannot destroy a promotion without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Cyber Monday',
                                  coupon_quantity: 100,
                                  description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15,
                                  expiration_date: '22/12/2033', user: user)
    delete promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  # TODO: teste de login da aprovação

  test 'cannot approve if owner' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Cyber Monday',
                                  coupon_quantity: 100,
                                  description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15,
                                  expiration_date: '22/12/2033', user: user)
    login_as_before(user)
    post approve_promotion_path(promotion)
    assert_redirected_to promotion_path(promotion)
    assert_not promotion.reload.approved?
    assert_equal 'Ação não permitida', flash[:alert]
  end
end
