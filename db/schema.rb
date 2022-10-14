# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_18_180846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counters", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "razao"
    t.string "iss"
    t.string "cnpj"
    t.string "cei"
    t.string "cgf"
    t.string "cod"
    t.string "logradouro"
    t.string "numero"
    t.string "bairro"
    t.string "complemento"
    t.string "municipio"
    t.string "estado"
    t.string "telefone"
    t.string "telefone2"
    t.string "telefone3"
    t.string "celular"
    t.string "celular2"
    t.string "email"
    t.string "email2"
    t.string "contato"
    t.string "contato2"
    t.string "endereco_coleta"
    t.float "honorarios"
    t.datetime "desde"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "id_emp"
    t.string "cep"
    t.string "cpf"
    t.string "srf"
    t.string "sefaz"
    t.string "senha_iss"
    t.string "orgao"
    t.string "e_cpf"
    t.string "e_cnpj"
    t.boolean "decimo3"
    t.integer "star"
    t.boolean "active", default: true
    t.integer "group_id"
    t.string "gerente"
    t.string "gerente_cpf"
    t.boolean "gerente_c"
    t.string "cotista"
    t.string "cotista_cpf"
    t.boolean "cotista_c"
    t.string "titular"
    t.string "titular_cpf"
    t.boolean "titular_c"
    t.string "titular2"
    t.string "titular2_cpf"
    t.boolean "titular2_c"
    t.boolean "area_fiscal"
    t.boolean "area_imp_renda_pj"
    t.boolean "area_trabalhista_previdenciaria"
    t.boolean "area_contabil"
    t.string "dia_cobranca"
    t.boolean "area_livro_caixa"
  end

  create_table "customers_observations", id: false, force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "observation_id", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "observations", force: :cascade do |t|
    t.string "descricao"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "parametro"
    t.string "descricao"
    t.string "valor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
