class Correntista < ApplicationRecord
  self.table_name = 'correntistas'
  self.primary_key = 'correntista_id'
  
  has_many :movimentacoes, foreign_key: 'correntista_id'
  
  validates :nome_correntista, presence: true, length: { maximum: 50 }
  validates :saldo, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

