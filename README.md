# pix_payload

Gem Ruby para gerar payloads do tipo **PIX Copia e Cola**, seguindo o padrão do Banco Central do Brasil (EMVCo).  
Permite personalizar a chave PIX, valor, nome do recebedor, cidade e identificador da transação (TxID).  
Retorna uma string válida com o campo CRC16 já calculado.

---

## ✨ Funcionalidades

- Geração completa do payload PIX com suporte a:
  - Chave PIX (e-mail, CPF, telefone, chave aleatória, etc)
  - Valor (opcional)
  - Nome e cidade do recebedor
  - Identificador da transação (TxID)
- Cálculo automático do CRC16 (padrão CCITT-FALSE)
- Pronto para ser convertido em QR Code

---

## 💎 Instalação

Adicione ao seu `Gemfile`:

```ruby
gem "pix_payload", github: "Thierrycast/pix_payload"
```

Ou instale diretamente:

```bash
git clone https://github.com/Thierrycast/pix_payload.git
cd pix_payload
bundle install
```

---

## 🧪 Exemplo de uso

```ruby
require "pix_payload"

payload = PixPayload::Generator.generate_payload(
  chave: "thierry@email.com",
  nome: "Thierry Castro",
  cidade: "Sardoa",
  valor: 42.50,
  txid: "REF123"
)

puts payload
# => retorna uma string longa do tipo Copia e Cola (com campo 63 incluso)
```

---

## 📥 Parâmetros esperados

| Parâmetro | Tipo     | Obrigatório | Detalhes                                                                 |
|-----------|----------|-------------|--------------------------------------------------------------------------|
| `chave:`  | `String` | ✅          | Chave PIX (e-mail, CPF, aleatória, etc)                                  |
| `nome:`   | `String` | ✅          | **Nome cadastrado na instituição financeira da chave** (máx. 25 chars)   |
| `cidade:` | `String` | ✅          | Cidade do recebedor (máx. 15 chars)¹                                     |
| `valor:`  | `Float`  | ❌          | Valor da transação (omitido se não informado)                            |
| `txid:`   | `String` | ❌          | Identificador da transação (padrão: `"***"`)                             |


---

## 📤 Saída

Retorna uma `String` no padrão PIX Copia e Cola, já com o campo `6304XXXX` (CRC) calculado no final.

Você pode usar essa string:
- Como QR Code (com bibliotecas como `rqrcode`)
- Copiar e colar diretamente em apps bancários

---

## 🔧 Exemplo prático (via IRB)

```bash
$ bin/console
```

```ruby
PixPayload::Generator.generate_payload(
  chave: "email@pix.com",
  nome: "Loja Exemplo",
  cidade: "SAO PAULO",
  valor: 99.90,
  txid: "pedido123"
)
```

---

## ✅ Conformidade

Este projeto segue o padrão **EMVCo** adotado pelo Banco Central do Brasil.
Referência: [Manual do Padrão BR Code - BACEN (PDF)](https://www.bcb.gov.br/content/estabilidadefinanceira/pix/Regulamento_Pix_ManualdePadroesparaIniciacaodoPix.pdf)

---


## 📄 Licença

MIT