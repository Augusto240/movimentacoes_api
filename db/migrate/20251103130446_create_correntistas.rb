class CreateCorrentistas < ActiveRecord::Migration[8.0]
  def change
    create_table :correntistas, primary_key: :correntista_id do |t|
      t.string :nome_correntista, limit: 50, null: false
      t.decimal :saldo, precision: 12, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
