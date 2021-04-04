require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_as_before
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_as_before
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
      
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_as_before
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_as_before
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
                                        
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_as_before
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_as_before
    visit root_path 
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
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

  test 'create and code/name must be unique' do
    user = login_as_before
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
  
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Nome', with: 'Natal'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    user = login_as_before
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100, expiration_date: '22/12/2033', user: user)
    promotion.create_promotion_approval(
      user: User.create!(email: 'john.doe@iugu.com.br', password: '1234567')
    )

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001 (Ativo)'
    assert_text 'NATAL10-0002 (Ativo)'
    assert_text 'NATAL10-0100 (Ativo)'
    assert_no_text 'NATAL10-0101'
    assert_link 'Desabilitar', count: 100
  end

  test 'search promotions by term and finds results' do
    user = login_as_before
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
    assert_text '2 promoções encontradas para o termo: natal'
  end

  test 'search promotions by term and finds one result' do
    user = login_as_before
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    refute_text cyber_monday.name
    assert_text '1 promoção encontrada para o termo: natal'
  end

  test 'search promotions by term and do not find results' do
    user = login_as_before
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina',
                                    description: 'Promoção de Natal',
                                    code: 'NATAL11', discount_rate: 10,
                                    coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)

    
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'test'
    click_on 'Buscar'

    refute_text christmas.name
    refute_text christmassy.name
    refute_text cyber_monday.name
    assert_text 'Nenhuma promoção encontrada para o termo: test'
  end

  #TODO: Edit promotion only if the user is the create'
  #redirect_to root_path, notice: 'Permissão negada: Você não é o Usuario Criador dessa Promoção' unless @promotion.user == current_user
  
  test 'Editing Promotion' do
    user = login_as_before
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    new_name = 'Ano Novo'
    visit edit_promotion_path(promotion.id)
    fill_in 'Nome', with: new_name
    click_on 'Atualizar promoção'

    assert_text 'Promoção atualizada com sucesso'
    assert_text new_name
  end

  test 'Destroy Promotion' do
    user = login_as_before 
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit promotions_path
    click_on 'Apagar'

    assert_text 'Promoção excluída com sucesso'
  end

  test ' do not view promotion link without login' do 
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotion using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'do view details without login' do 
    user = User.create!(email: 'andre@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100, expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create promotion without login' do
    visit new_promotion_path

    assert_current_path new_user_session_path
  end

  test 'can not editing without login' do 
    user = User.create!(email: 'andre@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100, expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion.id)

    assert_current_path new_user_session_path
  end

  test 'can not search promotions without login' do
    visit search_promotions_path(q: 'test')

    assert_current_path new_user_session_path
  end 

  test 'user approves promotion' do
    user = User.create!(email: 'adriano@iugu.com.br', password: '123456')
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    approver = login_as_before
    visit promotion_path(christmas)
    accept_confirm { click_on 'Aprovar' }

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_button 'Gerar cupons'
    refute_link 'Aprovar'
  end

  test 'user can not approves his promotions' do
    user = login_as_before
    christmas = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(christmas)

    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end

end
