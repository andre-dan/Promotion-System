require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do 
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email',	with: 'andre@iugu.com.br'
    fill_in 'senha',	with: 'password'
    click_on 'Cadastrar'

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'andre@iugu.com.br'
    assert_text 'Sair'
    assert_no_link 'Cadastrar'
  end
end