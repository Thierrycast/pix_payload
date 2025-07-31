# 💸 pix_payload

**Gem Ruby** para geração, modificação e análise de payloads do tipo **PIX Copia e Cola**, seguindo o padrão oficial do Banco Central do Brasil (EMVCo).

Suporte completo a chave Pix, valor, nome, cidade, TxID e descrição.  

---

## ✨ Funcionalidades

✅ Geração completa do payload PIX  
🛠️ Modificação do valor em payloads existentes  
🔍 Análise e extração dos dados de um payload  
🔢 Cálculo automático do CRC16 (padrão CCITT-FALSE)  
📦 Pronto para ser convertido em QR Code 
💻 CLI interativo 

---

## 🚀 Instalação

Adicione ao seu `Gemfile`:

```ruby
gem "pix_payload", github: "Thierrycast/pix_payload"
```

Ou instale manualmente:

```bash
git clone https://github.com/Thierrycast/pix_payload.git
cd pix_payload
bundle install
```

## 📦 Uso via CLI

```bash
./bin/pix_payload generate --chave thierry@pix.com --nome "Thierry Castro" --cidade "SAO PAULO" --valor 42.5
````

Se você omitir campos obrigatórios, um modo **interativo** será ativado automaticamente:

```bash
./bin/pix_payload generate
# Informe a chave PIX:
# Informe o nome do recebedor:
# ...
```

### 🔎 Parse

```bash
./bin/pix_payload parse --payload "000201..."
# ou
./bin/pix_payload parse --payload "000201..." --raw
```

### ✏️ Modify

```bash
./bin/pix_payload modify --payload "000201..." --valor 99.99 --descricao "nova"
# ou, modo interativo (se campos não forem informados via CLI):
./bin/pix_payload modify
```

> ⚠️ Atenção sobre argumentos com espaços: use sempre **aspas** no `--payload`

---

## 📚 Módulos disponíveis

| Módulo                 | Função                                                   |
|------------------------|----------------------------------------------------------|
| `PixPayload::Generator` | Gera payloads completos a partir de parâmetros          |
| `PixPayload::Modifier`  | Altera campos de um payload existente (ex: valor)       |
| `PixPayload::Parser`    | Lê um payload e extrai seus dados de forma estruturada  |

> **⚠️ Atenção sobre o campo `nome`:**  
> Algumas instituições financeiras validam o nome do recebedor exatamente como consta no banco de destino.  
> Se o nome estiver incorreto ou divergente, o pagamento pode ser recusado.  
> Isso vale tanto ao gerar quanto ao modificar um payload.

---

## 🧪 Exemplos

### 📦 Gerar um payload completo

```ruby
require "pix_payload"

payload = PixPayload::Generator.generate_payload(
  chave: "chave-pix@exemplo.com",
  nome: "Thierry Castro",
  cidade: "SAO PAULO",
  valor: 42.50,
  txid: "abc123",
  descricao: "Pagamento pelo serviço"
)

puts payload
```

---

### ✏️ Alterar o valor de um payload existente

```ruby
novo_payload = PixPayload::Modifier.alterar_valor(payload, 99.99)
puts novo_payload
```

---

### 🔎 Analisar um payload existente

```ruby
dados = PixPayload::Parser.parse_payload(payload)

puts dados
# {
#   chave: "chave-pix@exemplo.com",
#   nome: "Thierry Castro",
#   cidade: "SAO PAULO",
#   valor: 42.5,
#   txid: "abc123",
#   descricao: "Pagamento pelo serviço"
# }
```

---

## 🧰 Parâmetros aceitos

| Parâmetro    | Tipo     | Obrigatório | Detalhes                                                        |
|--------------|----------|-------------|-----------------------------------------------------------------|
| `chave:`     | `String` | ✅          | Pode ser e-mail, CPF, CNPJ, telefone ou chave aleatória         |
| `nome:`      | `String` | ✅          | Nome do recebedor (máx. 25 caracteres)                          |
| `cidade:`    | `String` | ✅          | Cidade do recebedor (máx. 15 caracteres)                        |
| `valor:`     | `Float`  | ❌          | Valor da cobrança (ex: `42.50`)                                 |
| `txid:`      | `String` | ❌          | Identificador da transação. Padrão: `"***"`                     |
| `descricao:` | `String` | ❌          | Descrição da cobrança (máx. 72 caracteres)                      |

---

## 💡 Curiosidade técnica

O padrão do PIX Copia e Cola é baseado na estrutura **EMVCo**, que usa a seguinte lógica:

```
ID (2 dígitos) + TAMANHO (2 dígitos) + VALOR
```

Por exemplo:

```text
59 25 Thierry Barreto de Castro
```

Aqui:
- `59` é o campo para **nome do recebedor**
- `25` indica que o nome tem 25 caracteres
- `Thierry Barreto de Castro` é o valor real

Alguns campos contêm **subcampos** aninhados (ex: o campo `26`, que abriga a chave e a descrição).

Você pode explorar mais IDs no [Manual do BR Code - BACEN (PDF)](https://www.bcb.gov.br/content/estabilidadefinanceira/spb_docs/ManualBRCode.pdf)

---


## ✅ Conformidade

Este projeto segue a especificação oficial do Banco Central do Brasil (EMVCo).

📄 [Manual do Padrão BR Code - BACEN (PDF)](https://www.bcb.gov.br/content/estabilidadefinanceira/spb_docs/ManualBRCode.pdf)

---

## 📄 Licença

MIT
