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

ActiveRecord::Schema[8.0].define(version: 2025_11_03_130503) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "correntistas", primary_key: "correntista_id", force: :cascade do |t|
    t.string "nome_correntista", limit: 50, null: false
    t.decimal "saldo", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movimentacoes", primary_key: "movimentacao_id", force: :cascade do |t|
    t.string "tipo_operacao", limit: 1, null: false
    t.bigint "correntista_id", null: false
    t.bigint "beneficiario_id"
    t.decimal "valor_operacao", precision: 12, scale: 2, null: false
    t.datetime "data_operacao", null: false
    t.string "descricao", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "movimentacoes", "correntistas", column: "beneficiario_id", primary_key: "correntista_id"
  add_foreign_key "movimentacoes", "correntistas", primary_key: "correntista_id"
end
