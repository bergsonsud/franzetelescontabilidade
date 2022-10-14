require "application_system_test_case"

class CustomersTest < ApplicationSystemTestCase
  setup do
    @customer = customers(:one)
  end

  test "visiting the index" do
    visit customers_url
    assert_selector "h1", text: "Customers"
  end

  test "creating a Customer" do
    visit customers_url
    click_on "New Customer"

    fill_in "Bairro", with: @customer.bairro
    fill_in "Cei", with: @customer.cei
    fill_in "Celular", with: @customer.celular
    fill_in "Celular2", with: @customer.celular2
    fill_in "Cgf", with: @customer.cgf
    fill_in "Cnpj", with: @customer.cnpj
    fill_in "Cod", with: @customer.cod
    fill_in "Complemento", with: @customer.complemento
    fill_in "Contato", with: @customer.contato
    fill_in "Contato2", with: @customer.contato2
    fill_in "Desde", with: @customer.desde
    fill_in "Email", with: @customer.email
    fill_in "Email2", with: @customer.email2
    fill_in "Endereco coleta", with: @customer.endereco_coleta
    fill_in "Estado", with: @customer.estado
    fill_in "Honorarios", with: @customer.honorarios
    fill_in "Iss", with: @customer.iss
    fill_in "Logradouro", with: @customer.logradouro
    fill_in "Municipio", with: @customer.municipio
    fill_in "Numero", with: @customer.numero
    fill_in "Razao", with: @customer.razao
    fill_in "Telefone", with: @customer.telefone
    fill_in "Telefone2", with: @customer.telefone2
    fill_in "Telefone3", with: @customer.telefone3
    click_on "Create Customer"

    assert_text "Customer was successfully created"
    click_on "Back"
  end

  test "updating a Customer" do
    visit customers_url
    click_on "Edit", match: :first

    fill_in "Bairro", with: @customer.bairro
    fill_in "Cei", with: @customer.cei
    fill_in "Celular", with: @customer.celular
    fill_in "Celular2", with: @customer.celular2
    fill_in "Cgf", with: @customer.cgf
    fill_in "Cnpj", with: @customer.cnpj
    fill_in "Cod", with: @customer.cod
    fill_in "Complemento", with: @customer.complemento
    fill_in "Contato", with: @customer.contato
    fill_in "Contato2", with: @customer.contato2
    fill_in "Desde", with: @customer.desde
    fill_in "Email", with: @customer.email
    fill_in "Email2", with: @customer.email2
    fill_in "Endereco coleta", with: @customer.endereco_coleta
    fill_in "Estado", with: @customer.estado
    fill_in "Honorarios", with: @customer.honorarios
    fill_in "Iss", with: @customer.iss
    fill_in "Logradouro", with: @customer.logradouro
    fill_in "Municipio", with: @customer.municipio
    fill_in "Numero", with: @customer.numero
    fill_in "Razao", with: @customer.razao
    fill_in "Telefone", with: @customer.telefone
    fill_in "Telefone2", with: @customer.telefone2
    fill_in "Telefone3", with: @customer.telefone3
    click_on "Update Customer"

    assert_text "Customer was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer" do
    visit customers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer was successfully destroyed"
  end
end
