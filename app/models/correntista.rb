class Correntista < ApplicationRecord
  self.table_name = 'correntistas'
  self.primary_key = 'correntista_id'
  
  # Relacionamentos
  has_many :movimentacoes, class_name: 'Movimentacao', foreign_key: 'correntista_id'
  has_many :transferencias_recebidas, class_name: 'Movimentacao', foreign_key: 'beneficiario_id'
  
  # Validações
  validates :nome_correntista, presence: true, length: { maximum: 50 }
  validates :saldo, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Método para formatar saldo
  def saldo_formatado
    "R$ #{format('%.2f', saldo)}"
  end

  # Verifica se tem saldo suficiente
  def saldo_suficiente?(valor)
    saldo >= valor
  end

  # Realiza débito
  def debitar!(valor)
    raise "Saldo insuficiente" unless saldo_suficiente?(valor)
    update!(saldo: saldo - valor)
  end

  # Realiza crédito
  def creditar!(valor)
    update!(saldo: saldo + valor)
  end
end

