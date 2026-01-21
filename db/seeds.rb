# =============================================================================
# SEED DE DADOS INICIAIS - Sistema Bancário Corporativo
# =============================================================================
# Este arquivo popula o banco de dados com dados de exemplo para testes
# Execute com: rails db:seed
# =============================================================================

puts "🏦 Iniciando seed do Sistema Bancário Corporativo..."

# Limpar dados existentes (cuidado em produção!)
puts "🧹 Limpando dados existentes..."
Movimentacao.delete_all
Correntista.delete_all

# =============================================================================
# CRIAR CORRENTISTAS
# =============================================================================
puts "👥 Criando correntistas..."

correntistas_data = [
  { nome_correntista: "João Silva", saldo: 5000.00 },
  { nome_correntista: "Maria Santos", saldo: 12500.50 },
  { nome_correntista: "Carlos Oliveira", saldo: 3200.75 },
  { nome_correntista: "Ana Pereira", saldo: 8750.00 },
  { nome_correntista: "Pedro Costa", saldo: 1500.25 },
  { nome_correntista: "Lucia Ferreira", saldo: 25000.00 },
  { nome_correntista: "Roberto Almeida", saldo: 4320.80 },
  { nome_correntista: "Fernanda Lima", saldo: 9800.00 }
]

correntistas = correntistas_data.map do |data|
  correntista = Correntista.create!(data)
  puts "  ✓ #{correntista.nome_correntista} - Saldo: R$ #{format('%.2f', correntista.saldo)}"
  correntista
end

# =============================================================================
# CRIAR MOVIMENTAÇÕES DE EXEMPLO
# =============================================================================
puts "\n💰 Criando movimentações de exemplo..."

# Movimentações para João Silva (correntista 1)
joao = correntistas[0]
maria = correntistas[1]
carlos = correntistas[2]

movimentacoes_joao = [
  { tipo: 'C', valor: 1000.00, desc: 'Depósito inicial', dias: 30 },
  { tipo: 'C', valor: 2500.00, desc: 'Salário', dias: 25 },
  { tipo: 'D', valor: 150.00, desc: 'Pagamento: Conta de luz', dias: 20 },
  { tipo: 'D', valor: 89.90, desc: 'Pagamento: Internet', dias: 18 },
  { tipo: 'D', valor: 500.00, desc: 'Saque', dias: 15 },
  { tipo: 'D', valor: 200.00, desc: 'Transferência', beneficiario: maria, dias: 10 },
  { tipo: 'C', valor: 350.00, desc: 'Depósito em conta', dias: 5 },
  { tipo: 'D', valor: 75.50, desc: 'Pagamento: Farmácia', dias: 2 }
]

movimentacoes_joao.each do |mov|
  Movimentacao.create!(
    tipo_operacao: mov[:tipo],
    correntista_id: joao.correntista_id,
    valor_operacao: mov[:valor],
    data_operacao: Time.now - mov[:dias].days,
    descricao: mov[:desc],
    beneficiario_id: mov[:beneficiario]&.correntista_id
  )
end
puts "  ✓ #{movimentacoes_joao.length} movimentações para #{joao.nome_correntista}"

# Movimentações para Maria Santos
movimentacoes_maria = [
  { tipo: 'C', valor: 5000.00, desc: 'Depósito inicial', dias: 28 },
  { tipo: 'C', valor: 200.00, desc: 'Transferência recebida', dias: 10 },
  { tipo: 'D', valor: 1200.00, desc: 'Pagamento: Aluguel', dias: 8 },
  { tipo: 'D', valor: 300.00, desc: 'Saque', dias: 5 },
  { tipo: 'D', valor: 150.00, desc: 'Transferência', beneficiario: carlos, dias: 3 },
  { tipo: 'C', valor: 4500.00, desc: 'Salário', dias: 1 }
]

movimentacoes_maria.each do |mov|
  Movimentacao.create!(
    tipo_operacao: mov[:tipo],
    correntista_id: maria.correntista_id,
    valor_operacao: mov[:valor],
    data_operacao: Time.now - mov[:dias].days,
    descricao: mov[:desc],
    beneficiario_id: mov[:beneficiario]&.correntista_id
  )
end
puts "  ✓ #{movimentacoes_maria.length} movimentações para #{maria.nome_correntista}"

# Movimentações para Carlos Oliveira
movimentacoes_carlos = [
  { tipo: 'C', valor: 2000.00, desc: 'Depósito inicial', dias: 20 },
  { tipo: 'C', valor: 150.00, desc: 'Transferência recebida', dias: 3 },
  { tipo: 'D', valor: 450.00, desc: 'Pagamento: Cartão', dias: 7 },
  { tipo: 'D', valor: 100.00, desc: 'Saque', dias: 1 }
]

movimentacoes_carlos.each do |mov|
  Movimentacao.create!(
    tipo_operacao: mov[:tipo],
    correntista_id: carlos.correntista_id,
    valor_operacao: mov[:valor],
    data_operacao: Time.now - mov[:dias].days,
    descricao: mov[:desc]
  )
end
puts "  ✓ #{movimentacoes_carlos.length} movimentações para #{carlos.nome_correntista}"

# Algumas movimentações para outros correntistas
[correntistas[3], correntistas[4], correntistas[5]].each do |c|
  Movimentacao.create!(
    tipo_operacao: 'C',
    correntista_id: c.correntista_id,
    valor_operacao: c.saldo,
    data_operacao: Time.now - 15.days,
    descricao: 'Depósito inicial'
  )
  puts "  ✓ 1 movimentação para #{c.nome_correntista}"
end

# =============================================================================
# RESUMO FINAL
# =============================================================================
puts "\n" + "=" * 60
puts "✅ SEED CONCLUÍDO COM SUCESSO!"
puts "=" * 60
puts "📊 Resumo:"
puts "   • Correntistas criados: #{Correntista.count}"
puts "   • Movimentações criadas: #{Movimentacao.count}"
puts "   • Saldo total no sistema: R$ #{format('%.2f', Correntista.sum(:saldo))}"
puts ""
puts "🔐 Credenciais de acesso:"
puts "   • Senha administrativa: verifique o arquivo .env"
puts ""
puts "🚀 Execute 'rails server' para iniciar a aplicação!"
puts "=" * 60

