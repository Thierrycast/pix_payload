# frozen_string_literal: true

require_relative "version"

module PixPayload
  class Generator
    def self.generate_payload(chave:, nome:, cidade:, valor: nil, txid: "***", descricao: nil)
      payload = ""

      merchant_info = emv("00", "BR.GOV.BCB.PIX") + emv("01", chave)
      merchant_info += emv("02", descricao.to_s[0..72]) if descricao

      payload += emv("00", "01")
      payload += emv("26", merchant_info)
      payload += emv("52", "0000")
      payload += emv("53", "986")
      payload += emv("54", format("%.2f", valor)) if valor
      payload += emv("58", "BR")
      payload += emv("59", nome[0..24])
      payload += emv("60", cidade[0..14])
      payload += emv("62", emv("05", txid)) if txid

      payload += "6304"
      payload + crc16(payload)
    end

    def self.crc16(texto)
      crc = 0xFFFF
      texto.each_byte do |b|
        crc ^= (b << 8)
        8.times do
          crc = crc & 0x8000 != 0 ? ((crc << 1) ^ 0x1021) : (crc << 1)
          crc &= 0xFFFF
        end
      end
      crc.to_s(16).upcase.rjust(4, "0")
    end

    def self.emv(id, valor)
      tamanho = valor.to_s.length.to_s.rjust(2, "0")
      "#{id}#{tamanho}#{valor}"
    end
  end
end
