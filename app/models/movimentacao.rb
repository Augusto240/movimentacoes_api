class Movimentacao < ApplicationRecord
  self.table_name = 'movimentacoes'
  self.primary_key = 'movimentacao_id'
  
  # Relacionamentos
  belongs_to :correntista, class_name: 'Correntista', foreign_key: 'correntista_id'
  belongs_to :beneficiario, class_name: 'Correntista', foreign_key: 'beneficiario_id', optional: true

  # Validações
  validates :tipo_operacao, presence: true, inclusion: { in: %w[C D] }
  validates :valor_operacao, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true, length: { maximum: 50 }
  validates :data_operacao, presence: true
  
  # Scopes para filtrar movimentações
  scope :creditos, -> { where(tipo_operacao: 'C') }
  scope :debitos, -> { where(tipo_operacao: 'D') }
  scope :recentes, -> { order(data_operacao: :desc) }
  scope :do_correntista, ->(id) { where(correntista_id: id) }

  # Método para formatar tipo de operação
  def tipo_formatado
    tipo_operacao == 'C' ? 'Crédito' : 'Débito'
  end

  # Método para valor formatado com sinal
  def valor_formatado
    sinal = tipo_operacao == 'D' ? '-' : '+'
    "#{sinal} R$ #{format('%.2f', valor_operacao)}"
  end
end