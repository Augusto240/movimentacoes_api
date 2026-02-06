# 💰 CorpBank - Sistema Bancário Corporativo

![Ruby](https://img.shields.io/badge/Ruby-3.0+-red?logo=ruby)
![Rails](https://img.shields.io/badge/Rails-8.0-red?logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-blue?logo=postgresql)
![JWT](https://img.shields.io/badge/Auth-JWT-green)
![WebSocket](https://img.shields.io/badge/WebSocket-ActionCable-purple)

> Sistema bancário corporativo desenvolvido como projeto acadêmico para a disciplina de **Desenvolvimento de Sistemas Corporativos**. A aplicação é uma API RESTful em Ruby on Rails com autenticação JWT, comunicação em tempo real via **WebSocket (ActionCable)** e um front-end moderno integrado.

---

## 📋 Índice

- [Funcionalidades](#-funcionalidades)
- [Pré-requisitos e Instalação do Zero](#-pré-requisitos-e-instalação-do-zero)
- [Configuração do Projeto](#-configuração-do-projeto)
- [Executando a Aplicação](#-executando-a-aplicação)
- [Como Usar o Sistema](#-como-usar-o-sistema)
- [API REST - Endpoints](#-api-rest---endpoints)
- [WebSocket em Detalhes](#-websocket-actioncable---como-funciona)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Banco de Dados](#-banco-de-dados)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Problemas Comuns](#-problemas-comuns)
- [Informações Acadêmicas](#-informações-acadêmicas)

---

## ✅ Funcionalidades

### API Backend
| Funcionalidade | Descrição |
|---|---|
| ✅ Autenticação JWT | Login seguro com tokens que expiram em 24h |
| ✅ Listar Movimentações | Exibe todas as transações do sistema |
| ✅ Extrato por Correntista | Histórico completo de uma conta |
| ✅ Operação de Depósito | Adiciona saldo à conta |
| ✅ Operação de Saque | Retira valor da conta (com validação de saldo) |
| ✅ Operação de Pagamento | Realiza pagamentos com descrição personalizada |
| ✅ Operação de Transferência | Transfere valores entre contas diferentes |
| ✅ WebSocket (ActionCable) | **Notificações em tempo real** para todos os clientes conectados |

### Front-end
| Funcionalidade | Descrição |
|---|---|
| ✅ Tela de Login | Autenticação via JWT com validação |
| ✅ Dashboard | Visão geral: saldo, estatísticas, últimas movimentações |
| ✅ Operações Bancárias | Interface para depósito, saque, pagamento e transferência |
| ✅ Extrato | Histórico completo de movimentações por conta |
| ✅ Correntistas | Lista de todas as contas cadastradas com saldos |
| ✅ Notificações em Tempo Real | Via WebSocket — aparece um toast na tela quando qualquer operação é feita |
| ✅ Indicador de Conexão WS | Mostra na sidebar se o WebSocket está "Conectado" (verde) ou "Desconectado" (vermelho) |
| ✅ Design Responsivo | Funciona em desktop, tablet e mobile |

---

## 🔧 Pré-requisitos e Instalação do Zero

> **Nunca usou Ruby?** Sem problemas! Siga o passo a passo abaixo para o seu sistema operacional.

### 1️⃣ Instalar Ruby

<details>
<summary><strong>🐧 Linux — Arch Linux / Manjaro</strong></summary>

```bash
# Instala o Ruby e o RubyGems
sudo pacman -Sy ruby

# Verifica a versão instalada
ruby -v
# Deve mostrar algo como: ruby 3.4.x

# Instala o Bundler (gerenciador de dependências do Ruby)
gem install bundler

# ⚠️ IMPORTANTE: Adicione o caminho das gems ao PATH
# Cole este comando para funcionar permanentemente:
echo 'export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verifica se o bundle está funcionando
bundle -v
# Deve mostrar algo como: Bundler version 4.x.x
```

</details>

<details>
<summary><strong>🐧 Linux — Ubuntu / Debian / Mint</strong></summary>

```bash
# Atualiza os pacotes
sudo apt update

# Instala Ruby, suas dependências de compilação e o bundler
sudo apt install -y ruby-full build-essential

# Verifica a versão
ruby -v

# Instala o Bundler
gem install bundler

# Adiciona o caminho ao PATH (se necessário)
echo 'export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

bundle -v
```

</details>

<details>
<summary><strong>🐧 Linux — Fedora / RHEL / CentOS</strong></summary>

```bash
# Instala Ruby
sudo dnf install -y ruby ruby-devel gcc make

# Verifica a versão
ruby -v

# Instala o Bundler
gem install bundler

bundle -v
```

</details>

<details>
<summary><strong>🍎 macOS</strong></summary>

```bash
# Usando Homebrew (instale em https://brew.sh se não tiver)
brew install ruby

# Adiciona ao PATH
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

ruby -v

# Instala o Bundler
gem install bundler

bundle -v
```

</details>

<details>
<summary><strong>🪟 Windows</strong></summary>

```
1. Baixe o instalador em: https://rubyinstaller.org/downloads/
2. Escolha a versão "Ruby+Devkit 3.x.x (x64)"
3. Execute o instalador e marque "Add Ruby to PATH"
4. No final, quando perguntar sobre o MSYS2, escolha opção 3
   (MSYS2 and MINGW development toolchain)
5. Abra um novo terminal (cmd ou PowerShell) e verifique:
   ruby -v
   gem install bundler
   bundle -v
```

</details>

### 2️⃣ Instalar PostgreSQL

<details>
<summary><strong>🐧 Arch Linux / Manjaro</strong></summary>

```bash
# Instala o PostgreSQL
sudo pacman -Sy postgresql

# Inicializa o banco de dados (só na primeira vez)
sudo -u postgres initdb -D /var/lib/postgres/data

# Inicia o serviço
sudo systemctl start postgresql
sudo systemctl enable postgresql   # para iniciar junto com o sistema

# Cria um usuário postgres com senha
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '0908';"
```

</details>

<details>
<summary><strong>🐧 Ubuntu / Debian / Mint</strong></summary>

```bash
# Instala o PostgreSQL
sudo apt install -y postgresql postgresql-contrib libpq-dev

# Inicia o serviço
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Define uma senha para o usuário postgres
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '0908';"
```

</details>

<details>
<summary><strong>🍎 macOS</strong></summary>

```bash
brew install postgresql@15
brew services start postgresql@15
createuser -s postgres
psql -U postgres -c "ALTER USER postgres PASSWORD '0908';"
```

</details>

<details>
<summary><strong>🪟 Windows</strong></summary>

```
1. Baixe em: https://www.postgresql.org/download/windows/
2. Execute o instalador
3. Defina a senha do usuário "postgres" como "0908" (ou a que preferir)
4. Mantenha a porta padrão 5432
5. Conclua a instalação
```

</details>

---

## ⚙️ Configuração do Projeto

### Passo 1 — Clone o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd movimentacoes_api
```

### Passo 2 — Instale as dependências Ruby

```bash
bundle install
```

> 💡 Se der erro de permissão, use:
> ```bash
> bundle config set --local path 'vendor/bundle'
> bundle install
> ```

### Passo 3 — Configure as variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto:

```bash
touch .env
```

Abra o arquivo e adicione:

```env
# Senha para login no sistema (pode ser qualquer uma)
ADMIN_PASSWORD=admin123

# Chave secreta para gerar tokens JWT (pode ser qualquer texto longo)
JWT_SECRET=minha_chave_secreta_super_segura_2025
```

### Passo 4 — Configure o banco de dados

Edite o arquivo `config/database.yml` com as credenciais do **seu** PostgreSQL:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: 127.0.0.1
  port: 5432
  username: postgres     # ← seu usuário do PostgreSQL
  password: 0908         # ← sua senha do PostgreSQL
  pool: 5
```

### Passo 5 — Crie o banco e popule com dados

```bash
# Cria os bancos de dados
rails db:create

# Executa as migrações (cria as tabelas)
rails db:migrate

# Popula com dados de exemplo (8 correntistas + 21 movimentações)
rails db:seed
```

Saída esperada do seed:
```
🏦 Iniciando seed do Sistema Bancário Corporativo...
👥 Criando correntistas...
  ✓ João Silva - Saldo: R$ 5000.00
  ✓ Maria Santos - Saldo: R$ 12500.50
  ...
✅ SEED CONCLUÍDO COM SUCESSO!
📊 Resumo:
   • Correntistas criados: 8
   • Movimentações criadas: 21
```

---

## 🚀 Executando a Aplicação

```bash
rails server
```

Pronto! Acesse no navegador:

| O quê | URL |
|-------|-----|
| 🌐 **Front-end (Sistema completo)** | http://localhost:3000/index.html |
| 🔌 **API REST** | http://localhost:3000 |
| 📡 **WebSocket** | ws://localhost:3000/cable |

> 💡 Se a porta 3000 estiver ocupada, use: `rails server -p 3001`

### Credenciais de acesso

| Campo | Valor |
|-------|-------|
| Senha | `admin123` (ou o que você definiu no `.env`) |

---

## 🖥️ Como Usar o Sistema

### 1. Login
Acesse `http://localhost:3000/index.html`, digite a senha e clique em **"Entrar no Sistema"**.

### 2. Dashboard
Selecione uma conta no dropdown para ver o saldo, estatísticas de créditos/débitos e as últimas movimentações.

### 3. Operações Bancárias
Vá na aba **"Operações"** e escolha uma das 4 opções:
- **Depósito** → Selecione a conta e o valor
- **Saque** → Selecione a conta e o valor (valida saldo)
- **Pagamento** → Selecione a conta, valor e descrição (ex: "Conta de luz")
- **Transferência** → Selecione conta de origem, destino e valor

### 4. Notificações em Tempo Real (WebSocket)
> **🔥 Este é o principal destaque do projeto!**

Ao realizar qualquer operação, uma **notificação toast** aparece automaticamente no canto superior direito da tela em **todas as abas/janelas** que estiverem abertas.

**Como testar o WebSocket:**
1. Abra **2 abas** do navegador em `http://localhost:3000/index.html`
2. Faça login em ambas
3. Na **Aba 1**, realize um depósito
4. Na **Aba 2**, observe a notificação aparecer instantaneamente! 🎉

O indicador na sidebar mostra o status da conexão:
- 🟢 **Conectado** — WebSocket ativo, recebendo notificações
- 🔴 **Desconectado** — Sem conexão (reconecta automaticamente em 3 segundos)

### 5. Extrato
Vá na aba **"Extrato"**, selecione uma conta e veja todo o histórico de movimentações com datas, descrições, tipos e valores.

### 6. Correntistas
Vá na aba **"Correntistas"** para ver todas as contas com seus saldos. Clique em **"Ver Extrato"** para ir direto ao extrato de qualquer conta.

---

## 📡 API REST - Endpoints

### Autenticação

```bash
POST /auth/login
Content-Type: application/json

{ "password": "admin123" }
```

Resposta:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "expires_at": "2026-02-07T00:00:00Z",
  "message": "Token gerado com sucesso"
}
```

> ⚠️ Use o token no header de **todas** as outras requisições:
> ```
> Authorization: Bearer seu_token_aqui
> ```

### Correntistas

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/correntistas` | Lista todos os correntistas |
| `GET` | `/correntistas/:id` | Detalhes de um correntista |

### Movimentações e Operações

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/movimentacoes` | Lista todas as movimentações |
| `GET` | `/extrato/:correntista_id` | Extrato de um correntista |
| `POST` | `/depositar` | Realiza depósito |
| `POST` | `/sacar` | Realiza saque |
| `POST` | `/pagar` | Realiza pagamento |
| `POST` | `/transferir` | Realiza transferência |

### Exemplos de Requisições

<details>
<summary><strong>💵 Depósito</strong></summary>

```bash
curl -X POST http://localhost:3000/depositar \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{"correntista_id": 1, "valor": 100.00}'
```

Resposta:
```json
{
  "mensagem": "Depósito realizado com sucesso",
  "movimentacao": { "movimentacao_id": 22, "tipo_operacao": "C", "valor_operacao": "100.0" },
  "saldo_atual": "5100.0"
}
```
</details>

<details>
<summary><strong>💸 Saque</strong></summary>

```bash
curl -X POST http://localhost:3000/sacar \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{"correntista_id": 1, "valor": 50.00}'
```

Resposta:
```json
{
  "mensagem": "Saque realizado com sucesso",
  "movimentacao": { "movimentacao_id": 23, "tipo_operacao": "D", "valor_operacao": "50.0" },
  "saldo_atual": "4950.0"
}
```
</details>

<details>
<summary><strong>📄 Pagamento</strong></summary>

```bash
curl -X POST http://localhost:3000/pagar \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{"correntista_id": 1, "valor": 89.90, "descricao": "Conta de luz"}'
```

Resposta:
```json
{
  "mensagem": "Pagamento realizado com sucesso",
  "movimentacao": { "movimentacao_id": 24, "tipo_operacao": "D", "descricao": "Conta de luz" },
  "saldo_atual": "4860.1"
}
```
</details>

<details>
<summary><strong>🔄 Transferência</strong></summary>

```bash
curl -X POST http://localhost:3000/transferir \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN" \
  -d '{"correntista_id": 1, "beneficiario_id": 2, "valor": 200.00}'
```

Resposta:
```json
{
  "mensagem": "Transferência realizada com sucesso",
  "movimentacao_debito": { "tipo_operacao": "D", "valor_operacao": "200.0" },
  "movimentacao_credito": { "tipo_operacao": "C", "valor_operacao": "200.0" },
  "saldo_remetente": "4660.1",
  "saldo_beneficiario": "12700.5"
}
```
</details>

---

## 🔌 WebSocket (ActionCable) - Como Funciona

O WebSocket é o recurso principal solicitado na atividade. Abaixo está a explicação detalhada de como foi implementado.

### Arquitetura

```
┌─────────────────────┐          ┌──────────────────────────────┐
│   FRONT-END (JS)    │          │     BACK-END (Rails)         │
│                     │          │                              │
│  1. Conecta no WS   ├────────►│  ActionCable Connection      │
│     ws://host/cable │          │  (connection.rb)             │
│                     │          │                              │
│  2. Se inscreve no  ├────────►│  MovimentacoesChannel        │
│     canal           │          │  (movimentacoes_channel.rb)  │
│                     │          │                              │
│                     │          │  3. Operação bancária        │
│                     │          │     (movimentacoes_controller│
│                     │          │      .rb)                    │
│                     │          │                              │
│  4. Recebe notif.  ◄──────────┤  ActionCable.server.broadcast│
│     em tempo real   │          │  ("movimentacoes_channel",   │
│                     │          │   { dados da movimentação }) │
│  5. Mostra toast    │          │                              │
│     + atualiza tela │          │                              │
└─────────────────────┘          └──────────────────────────────┘
```

### Arquivos Envolvidos

| Arquivo | Função |
|---------|--------|
| `config/cable.yml` | Configura o adapter do ActionCable (`async` em dev) |
| `config/routes.rb` | Monta o endpoint `/cable` para WebSocket |
| `app/channels/application_cable/connection.rb` | Gerencia conexões WS (gera UUID por conexão) |
| `app/channels/movimentacoes_channel.rb` | Define o canal e o `stream_from` |
| `app/controllers/movimentacoes_controller.rb` | Faz `broadcast` a cada operação bancária |
| `public/index.html` | Conecta, se inscreve, recebe e mostra as notificações |

### Código do Servidor — Canal (movimentacoes_channel.rb)

```ruby
class MovimentacoesChannel < ApplicationCable::Channel
  def subscribed
    # Todos os clientes recebem notificações de todas as operações
    stream_from "movimentacoes_channel"

    # Também faz stream individual por correntista (quando passado)
    if params[:correntista_id].present?
      stream_from "movimentacoes_correntista_#{params[:correntista_id]}"
    end
  end

  def unsubscribed
    # Cleanup quando o cliente desconecta
  end
end
```

### Código do Servidor — Broadcast no Controller

Toda operação (depósito, saque, pagamento, transferência) chama este método:

```ruby
def broadcast_movimentacao(movimentacao, mensagem)
  dados = {
    tipo: movimentacao.tipo_operacao == "C" ? "credito" : "debito",
    movimentacao_id: movimentacao.movimentacao_id,
    correntista_id: movimentacao.correntista_id,
    beneficiario_id: movimentacao.beneficiario_id,
    valor: movimentacao.valor_operacao,
    descricao: mensagem,
    timestamp: Time.current.iso8601
  }

  # Broadcast para TODOS os clientes conectados
  ActionCable.server.broadcast("movimentacoes_channel", dados)

  # Broadcast individual para o correntista envolvido
  ActionCable.server.broadcast(
    "movimentacoes_correntista_#{movimentacao.correntista_id}",
    dados
  )
end
```

### Código do Front-end — Conexão e Recebimento (index.html)

```javascript
// 1. Conecta no WebSocket
const ws = new WebSocket('ws://localhost:3000/cable');

// 2. Ao conectar, se inscreve no canal
ws.onopen = () => {
  ws.send(JSON.stringify({
    command: 'subscribe',
    identifier: JSON.stringify({ channel: 'MovimentacoesChannel' })
  }));
};

// 3. Ao receber mensagem, mostra notificação
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  if (data.type === 'ping') return; // ignora heartbeats

  if (data.message) {
    // Mostra notificação toast na tela
    showNotification('success', 'Nova Movimentação', data.message.descricao);
    // Atualiza saldos e tabelas automaticamente
    loadCorrentistas();
  }
};

// 4. Se desconectar, reconecta automaticamente em 3 segundos
ws.onclose = () => {
  setTimeout(connectWebSocket, 3000);
};
```

### Formato da Notificação Recebida via WebSocket

```json
{
  "tipo": "credito",
  "movimentacao_id": 123,
  "correntista_id": 1,
  "beneficiario_id": null,
  "valor": "100.0",
  "descricao": "Depósito de R$ 100.00 realizado",
  "timestamp": "2026-02-06T00:32:42-03:00"
}
```

---

## 📁 Estrutura do Projeto

```
movimentacoes_api/
├── app/
│   ├── channels/                          # 🔌 WebSocket (ActionCable)
│   │   ├── application_cable/
│   │   │   ├── channel.rb                 #    Base class dos canais
│   │   │   └── connection.rb              #    Gerencia conexões WS
│   │   └── movimentacoes_channel.rb       #    Canal de notificações em tempo real
│   ├── controllers/                       # 🎮 Controllers da API
│   │   ├── application_controller.rb      #    Autenticação JWT (base)
│   │   ├── auth_controller.rb             #    Login e geração de token
│   │   ├── correntistas_controller.rb     #    CRUD de contas
│   │   └── movimentacoes_controller.rb    #    Operações bancárias + broadcast WS
│   └── models/                            # 📦 Models (ActiveRecord)
│       ├── correntista.rb                 #    Model de conta bancária
│       └── movimentacao.rb                #    Model de transação
├── config/
│   ├── cable.yml                          #    Configuração do ActionCable
│   ├── database.yml                       #    Configuração do PostgreSQL
│   ├── routes.rb                          #    Rotas da API + mount /cable
│   ├── environments/
│   │   └── development.rb                 #    Config dev (WS forgery disabled)
│   └── initializers/
│       └── cors.rb                        #    Configuração CORS
├── db/
│   ├── migrate/                           #    Migrações do banco
│   │   ├── 20251103130446_create_correntistas.rb
│   │   └── 20251103130503_create_movimentacoes.rb
│   ├── schema.rb                          #    Schema atual do banco
│   └── seeds.rb                           #    Dados de exemplo
├── public/
│   └── index.html                         # 🌐 Front-end completo (HTML/CSS/JS)
├── .env                                   #    Variáveis de ambiente
├── Gemfile                                #    Dependências Ruby
└── README.md                              #    Este arquivo
```

---

## 🗃️ Banco de Dados

### Diagrama Relacional

```
┌──────────────────────┐       ┌──────────────────────────┐
│     correntistas     │       │      movimentacoes       │
├──────────────────────┤       ├──────────────────────────┤
│ correntista_id (PK)  │◄──┐  │ movimentacao_id (PK)     │
│ nome_correntista     │   ├──│ correntista_id (FK)       │
│ saldo                │   └──│ beneficiario_id (FK null) │
│ created_at           │      │ tipo_operacao (C/D)       │
│ updated_at           │      │ valor_operacao            │
└──────────────────────┘      │ data_operacao             │
                              │ descricao                 │
                              │ created_at                │
                              │ updated_at                │
                              └──────────────────────────┘
```

### Tabela: correntistas
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `correntista_id` | `bigint` (PK) | Chave primária |
| `nome_correntista` | `varchar(50)` | Nome do correntista |
| `saldo` | `decimal(12,2)` | Saldo atual da conta |
| `created_at` | `datetime` | Data de criação |
| `updated_at` | `datetime` | Última atualização |

### Tabela: movimentacoes
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `movimentacao_id` | `bigint` (PK) | Chave primária |
| `tipo_operacao` | `char(1)` | `C` = Crédito, `D` = Débito |
| `correntista_id` | `bigint` (FK) | Conta do correntista |
| `beneficiario_id` | `bigint` (FK, nullable) | Conta do beneficiário (transferências) |
| `valor_operacao` | `decimal(12,2)` | Valor da operação |
| `data_operacao` | `datetime` | Data/hora da operação |
| `descricao` | `varchar(50)` | Descrição da operação |

### Correntistas Pré-cadastrados (seed)

| ID | Nome | Saldo Inicial |
|----|------|---------------|
| 1 | João Silva | R$ 5.000,00 |
| 2 | Maria Santos | R$ 12.500,50 |
| 3 | Carlos Oliveira | R$ 800,00 |
| 4 | Ana Costa | R$ 25.000,00 |
| 5 | Pedro Souza | R$ 3.200,75 |
| 6 | Juliana Lima | R$ 15.750,00 |
| 7 | Roberto Almeida | R$ 7.420,30 |
| 8 | Fernanda Rocha | R$ 1.050,00 |

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Finalidade |
|------------|--------|------------|
| **Ruby** | 3.x | Linguagem de programação |
| **Rails** | 8.0 | Framework web (API mode) |
| **PostgreSQL** | 15+ | Banco de dados relacional |
| **JWT** | gem `jwt` | Autenticação via tokens |
| **ActionCable** | built-in Rails | **WebSockets em tempo real** |
| **Rack-CORS** | gem `rack-cors` | Controle de CORS |
| **Puma** | gem `puma` | Servidor web (suporta WebSocket) |
| **dotenv** | gem `dotenv-rails` | Variáveis de ambiente |
| **HTML/CSS/JS** | vanilla | Front-end (sem frameworks) |

---

## ❓ Problemas Comuns

<details>
<summary><strong>❌ "bundle: comando não encontrado"</strong></summary>

O diretório das gems não está no PATH. Execute:
```bash
# Arch Linux / Manjaro
echo 'export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Ubuntu / Debian
echo 'export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
</details>

<details>
<summary><strong>❌ Erro de permissão no "bundle install"</strong></summary>

Configure o bundle para instalar localmente:
```bash
bundle config set --local path 'vendor/bundle'
bundle install
```
</details>

<details>
<summary><strong>❌ "PG::ConnectionBad: could not connect to server"</strong></summary>

O PostgreSQL não está rodando. Inicie o serviço:
```bash
# Arch Linux / Manjaro
sudo systemctl start postgresql

# Ubuntu / Debian
sudo service postgresql start
```
</details>

<details>
<summary><strong>❌ Porta 3000 já em uso</strong></summary>

Outra aplicação está usando a porta. Libere ou use outra porta:
```bash
# Liberar a porta
sudo fuser -k 3000/tcp

# Ou usar outra porta
rails server -p 3001
```
</details>

<details>
<summary><strong>❌ WebSocket não conecta / notificações não aparecem</strong></summary>

Verifique se a configuração do ActionCable está correta em `config/environments/development.rb`:
```ruby
config.action_cable.disable_request_forgery_protection = true
```
</details>

<details>
<summary><strong>❌ "rails db:create" dá erro de autenticação</strong></summary>

Verifique se o usuário e senha no `config/database.yml` correspondem ao seu PostgreSQL:
```yaml
username: postgres
password: sua_senha_aqui
```
</details>

---

## 👨‍🎓 Informações Acadêmicas

| | |
|---|---|
| **Disciplina** | Desenvolvimento de Sistemas Corporativos |
| **Aluno** | José Augusto |
| **Período** | 2025.2 |
| **Atividade** | 2º Bimestre — Funcionalidade com WebSocket |

---

## 📄 Licença

Este projeto é desenvolvido exclusivamente para fins acadêmicos.
