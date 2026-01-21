# 💰 CorpBank - Sistema Bancário Corporativo

![Ruby](https://img.shields.io/badge/Ruby-3.0+-red?logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0-red?logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-blue?logo=postgresql)
![JWT](https://img.shields.io/badge/Auth-JWT-green)
![WebSocket](https://img.shields.io/badge/WebSocket-ActionCable-purple)

Sistema bancário corporativo desenvolvido como projeto acadêmico para a disciplina de **Sistemas Corporativos**. A aplicação é uma API RESTful em Ruby on Rails com autenticação JWT, comunicação em tempo real via WebSocket (ActionCable) e um front-end moderno integrado.

---

## 📋 Funcionalidades

### API Backend
- ✅ **Autenticação JWT** - Login seguro com tokens
- ✅ **Listar Movimentações** - Exibe todas as transações do sistema
- ✅ **Extrato por Correntista** - Histórico completo de uma conta
- ✅ **Operação de Depósito** - Adiciona saldo à conta
- ✅ **Operação de Saque** - Retira valor da conta
- ✅ **Operação de Pagamento** - Realiza pagamentos com descrição
- ✅ **Operação de Transferência** - Transfere entre contas
- ✅ **WebSocket (ActionCable)** - Notificações em tempo real

### Front-end
- ✅ **Tela de Login** - Autenticação via JWT
- ✅ **Dashboard** - Visão geral da conta selecionada
- ✅ **Operações** - Interface para todas as operações bancárias
- ✅ **Extrato** - Visualização do histórico de movimentações
- ✅ **Correntistas** - Lista de todas as contas
- ✅ **Notificações em Tempo Real** - Via WebSocket
- ✅ **Design Responsivo** - Funciona em desktop e mobile

---

## 🚀 Como Executar

### Pré-requisitos
- Ruby 3.0+
- Rails 8.0+
- PostgreSQL 15+
- Bundler

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/movimentacoes_api.git
cd movimentacoes_api
```

### 2. Instale as dependências
```bash
bundle install
```

### 3. Configure o ambiente
```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite o arquivo .env com suas configurações
# ADMIN_PASSWORD=sua_senha
# JWT_SECRET=sua_chave_secreta
```

### 4. Configure o banco de dados
Edite `config/database.yml` com suas credenciais do PostgreSQL:
```yaml
default: &default
  adapter: postgresql
  host: localhost
  port: 5432
  username: seu_usuario
  password: sua_senha
```

### 5. Crie o banco e execute as migrações
```bash
rails db:create
rails db:migrate
rails db:seed  # Popula com dados de exemplo
```

### 6. Inicie o servidor
```bash
rails server
```

### 7. Acesse a aplicação
- **Front-end:** http://localhost:3000/index.html
- **API:** http://localhost:3000

---

## 🔐 Autenticação

### Login
```bash
POST /auth/login
Content-Type: application/json

{
  "password": "sua_senha"
}
```

**Resposta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "expires_at": "2025-01-22T12:00:00Z",
  "message": "Token gerado com sucesso"
}
```

### Usar o Token
Inclua o token no header de todas as requisições:
```
Authorization: Bearer seu_token_jwt
```

---

## 📡 Endpoints da API

### Correntistas
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/correntistas` | Lista todos os correntistas |
| GET | `/correntistas/:id` | Detalhes de um correntista |

### Movimentações
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/movimentacoes` | Lista todas as movimentações |
| GET | `/extrato/:correntista_id` | Extrato de um correntista |
| POST | `/depositar` | Realiza depósito |
| POST | `/sacar` | Realiza saque |
| POST | `/pagar` | Realiza pagamento |
| POST | `/transferir` | Realiza transferência |

### Exemplos de Requisições

#### Depósito
```bash
POST /depositar
Authorization: Bearer seu_token

{
  "correntista_id": 1,
  "valor": 100.00
}
```

#### Saque
```bash
POST /sacar
Authorization: Bearer seu_token

{
  "correntista_id": 1,
  "valor": 50.00
}
```

#### Pagamento
```bash
POST /pagar
Authorization: Bearer seu_token

{
  "correntista_id": 1,
  "valor": 89.90,
  "descricao": "Conta de luz"
}
```

#### Transferência
```bash
POST /transferir
Authorization: Bearer seu_token

{
  "correntista_id": 1,
  "beneficiario_id": 2,
  "valor": 200.00
}
```

---

## 🔌 WebSocket (ActionCable)

### Conexão
```javascript
const ws = new WebSocket('ws://localhost:3000/cable');

ws.onopen = () => {
  // Inscreve no canal de movimentações
  ws.send(JSON.stringify({
    command: 'subscribe',
    identifier: JSON.stringify({ channel: 'MovimentacoesChannel' })
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  if (data.message) {
    console.log('Nova movimentação:', data.message);
  }
};
```

### Formato das Notificações
```json
{
  "tipo": "credito",
  "movimentacao_id": 123,
  "correntista_id": 1,
  "valor": 100.00,
  "descricao": "Depósito de R$ 100.00 realizado",
  "timestamp": "2025-01-21T15:30:00Z"
}
```

---

## 📁 Estrutura do Projeto

```
movimentacoes_api/
├── app/
│   ├── channels/
│   │   ├── application_cable/
│   │   │   ├── channel.rb
│   │   │   └── connection.rb
│   │   └── movimentacoes_channel.rb
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── auth_controller.rb
│   │   ├── correntistas_controller.rb
│   │   └── movimentacoes_controller.rb
│   └── models/
│       ├── correntista.rb
│       └── movimentacao.rb
├── config/
│   ├── cable.yml
│   ├── database.yml
│   └── routes.rb
├── db/
│   ├── migrate/
│   ├── schema.rb
│   └── seeds.rb
├── public/
│   └── index.html          # Front-end da aplicação
├── .env                     # Variáveis de ambiente
├── .env.example
├── Gemfile
└── README.md
```

---

## 🗃️ Banco de Dados

### Tabela: correntistas
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| correntista_id | bigint | Chave primária |
| nome_correntista | varchar(50) | Nome do correntista |
| saldo | decimal(12,2) | Saldo atual |
| created_at | datetime | Data de criação |
| updated_at | datetime | Data de atualização |

### Tabela: movimentacoes
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| movimentacao_id | bigint | Chave primária |
| tipo_operacao | char(1) | C=Crédito, D=Débito |
| correntista_id | bigint | FK para correntistas |
| beneficiario_id | bigint | FK para correntistas (opcional) |
| valor_operacao | decimal(12,2) | Valor da operação |
| data_operacao | datetime | Data/hora da operação |
| descricao | varchar(50) | Descrição da operação |

---

## 🛠️ Tecnologias Utilizadas

- **Ruby 3.x** - Linguagem de programação
- **Rails 8.0** - Framework web
- **PostgreSQL** - Banco de dados relacional
- **JWT** - Autenticação via tokens
- **ActionCable** - WebSockets em tempo real
- **Rack-CORS** - Controle de CORS
- **HTML/CSS/JavaScript** - Front-end puro (sem frameworks)

---

## 👨‍🎓 Informações Acadêmicas

- **Disciplina:** Sistemas Corporativos
- **Aluno:** José Augusto
- **Período:** 2025

---

## 📄 Licença

Este projeto é desenvolvido para fins acadêmicos.

---

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.