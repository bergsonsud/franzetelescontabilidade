require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = customers(:one)
  end

  test "should get index" do
    get customers_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_url
    assert_response :success
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post customers_url, params: { customer: { bairro: @customer.bairro, cei: @customer.cei, celular: @customer.celular, celular2: @customer.celular2, cgf: @customer.cgf, cnpj: @customer.cnpj, cod: @customer.cod, complemento: @customer.complemento, contato: @customer.contato, contato2: @customer.contato2, desde: @customer.desde, email: @customer.email, email2: @customer.email2, endereco_coleta: @customer.endereco_coleta, estado: @customer.estado, honorarios: @customer.honorarios, iss: @customer.iss, logradouro: @customer.logradouro, municipio: @customer.municipio, numero: @customer.numero, razao: @customer.razao, telefone: @customer.telefone, telefone2: @customer.telefone2, telefone3: @customer.telefone3 } }
    end

    assert_redirected_to customer_url(Customer.last)
  end

  test "should show customer" do
    get customer_url(@customer)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_url(@customer)
    assert_response :success
  end

  test "should update customer" do
    patch customer_url(@customer), params: { customer: { bairro: @customer.bairro, cei: @customer.cei, celular: @customer.celular, celular2: @customer.celular2, cgf: @customer.cgf, cnpj: @customer.cnpj, cod: @customer.cod, complemento: @customer.complemento, contato: @customer.contato, contato2: @customer.contato2, desde: @customer.desde, email: @customer.email, email2: @customer.email2, endereco_coleta: @customer.endereco_coleta, estado: @customer.estado, honorarios: @customer.honorarios, iss: @customer.iss, logradouro: @customer.logradouro, municipio: @customer.municipio, numero: @customer.numero, razao: @customer.razao, telefone: @customer.telefone, telefone2: @customer.telefone2, telefone3: @customer.telefone3 } }
    assert_redirected_to customer_url(@customer)
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete customer_url(@customer)
    end

    assert_redirected_to customers_url
  end
end
