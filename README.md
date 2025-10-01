# Movimentações API

Uma API simples feita em Ruby on Rails para exibir movimentações bancárias do PostgreSQL.

## Como usar

```
# Instalar dependências
bundle install

# Configurar banco de dados (edite config/database.yml primeiro)
rails db:create
rails db:migrate

# Iniciar servidor
rails server
```

## Endpoints

- `GET /movimentacoes` - Ver todas as movimentações
- `GET /extrato/:id` - Ver extrato por correntista
- `POST /pagar` - Fazer pagamento
- `POST /transferir` - Transferir valor
- `POST /sacar` - Sacar dinheiro
- `POST /depositar` - Depositar dinheiro

Feito para a disciplina de Sistemas Corporativos.