require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email',	with: 'andre@iugu.com.br'
    fill_in 'Senha',	with: 'password'
    fill_in 'Confirmação de senha',	with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'andre@iugu.com.br'
    assert_text 'Sair'
    assert_no_link 'Cadastrar'
    # TODO: não logar e ir para o login
    # TODO: confirmar a conta
    # TODO: mandar email
    # TODO: validar a qualidade da senha
    # TODO: captcha
  end

  test 'user sign in' do
    user = User.create!(email: 'andre@iugu.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email',	with: user.email
    fill_in 'Senha',	with: user.password
    click_on 'Login'

    assert_text 'Login efetuado com sucesso!'
    assert_text 'andre@iugu.com'
    assert_current_path root_path
    assert_text 'Sair'
    assert_no_link 'Entrar'
  end

  # TODO: Teste de sair.
  # TODO: Falha ao registrar
  # TODO: Falha ao logar
  # TODO: Recuperar senha
  # TODO: Completar I18n do user
  # TODO: Editar o usiario
  # TODO: Incluir campos no login user tipo nome, etc
end
