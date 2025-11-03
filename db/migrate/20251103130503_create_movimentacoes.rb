class CreateMovimentacoes < ActiveRecord::Migration[8.0]
  def change
    create_table :movimentacoes, primary_key: :movimentacao_id do |t|
      t.string :tipo_operacao, limit: 1, null: false
      t.bigint :correntista_id, null: false
      t.bigint :beneficiario_id, null: true
      t.decimal :valor_operacao, precision: 12, scale: 2, null: false
      t.datetime :data_operacao, null: false
      t.string :descricao, limit: 50, null: false

      t.timestamps
    end

    add_foreign_key :movimentacoes, :correntistas, column: :correntista_id, primary_key: :correntista_id
    add_foreign_key :movimentacoes, :correntistas, column: :beneficiario_id, primary_key: :correntista_id
  end
end
