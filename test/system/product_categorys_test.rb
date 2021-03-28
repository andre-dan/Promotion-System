require 'application_system_test_case'

class ProductCategorysTest < ApplicationSystemTestCase
  test 'view product ' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    login_as_before  
    visit root_path
    click_on 'Produtos'

    assert_text 'Produto AntiFraude'
  end

  test 'view product details' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_category_path(product.id)

    assert_text 'Detalhes do Produto'
    assert_text product.name
    assert_text product.code
  end

  # test 'no product are available' do
  #   visit root_path
  #   click_on 'Promoções'

  #   assert_text 'Nenhuma promoção cadastrada'
  # end

  test 'return to home page' do
    ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    login_as_before  
    visit root_path
    click_on 'Produtos'
    click_on 'Home'

    assert_current_path root_path
  end

  test 'view details and return to product page' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code: 'ANTIFRA')

    visit product_category_path(product)
    assert_text product.name
    assert_text product.code
    click_on 'Voltar'

    assert_current_path product_categories_path
  end

  test 'create product' do
    visit new_product_category_path
  
    fill_in 'Nome', with: 'Produto Controle'
    fill_in 'Código', with: 'CONT123'
    click_on 'Criar produto'
    
    assert_text 'Produto Controle'
    assert_text 'CONT123'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_as_before
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  # test 'create and code/name must be unique' do
  #   Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
  #                     code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
  #                     expiration_date: '22/12/2033')

  #   visit root_path
  #   click_on 'Promoções'
  #   click_on 'Registrar uma promoção'
  #   fill_in 'Código', with: 'NATAL10'
  #   fill_in 'Nome', with: 'Natal'
  #   click_on 'Criar promoção'

  #   assert_text 'deve ser único', count: 2
  # end

  # test 'generate coupons for a promotion' do
  #   promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
  #                                 code: 'NATAL10', discount_rate: 10,
  #                                 coupon_quantity: 100, expiration_date: '22/12/2033')
    
  #   visit promotion_path(promotion)
  #   click_on 'Gerar cupons'

  #   assert_text 'Cupons gerados com sucesso'
  #   assert_no_link 'Gerar cupons'
  #   assert_no_text 'NATAL10 - 0000'
  #   assert_text 'NATAL10 - 0001'
  #   assert_text 'NATAL10 - 0002'
  #   assert_text 'NATAL10 - 0100'
  #   assert_no_text 'NATAL10 - 0101'

  # end

  # test 'Promotion Edition' do
  #   promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
  #                                 code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
  #                                 expiration_date: '22/12/2033')

  #   new_name = 'Ano Novo'
  #   visit(edit_promotion_path(promotion.id))
  #   fill_in('Nome', with: new_name)
  #   click_on('Atualizar promoção')

  #   assert_text 'Cliente atualizado com sucesso'
  #   assert_text new_name
  # end

  # test 'Destroy Promotion' do 
  #   Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
  #                     code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
  #                     expiration_date: '22/12/2033')

  #   visit promotions_path
  #   click_on 'Apagar'

  #   assert_text 'Promoção excluída com sucesso'
  # end
end