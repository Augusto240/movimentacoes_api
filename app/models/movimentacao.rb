class Movimentacao < ApplicationRecord
  self.table_name = 'movimentacoes'
  self.primary_key = 'movimentacao_id'
  
  belongs_to :correntista, foreign_key: 'correntista_id'
  belongs_to :beneficiario, class_name: 'Correntista', foreign_key: 'correntista_beneficiario_id', optional: true
  
  validates :tipo_operacao, presence: true, inclusion: { in: %w[C D] }
  validates :valor_operacao, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true, length: { maximum: 50 }
  validates :data_operacao, presence: true
  
  scope :creditos, -> { where(tipo_operacao: 'C') }
  scope :debitos, -> { where(tipo_operacao: 'D') }
end