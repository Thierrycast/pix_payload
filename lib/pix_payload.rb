# frozen_string_literal: true

require_relative "pix_payload/version"

module PixPayload
  class Generator
    def self.generate_payload(chave:, nome:, cidade:, valor: nil, txid: "***")
      payload = ""

      payload += emv("00", "01") # padrao
      payload += emv("26", emv("00", "BR.GOV.BCB.PIX") + emv("01", chave))
      payload += emv("52", "0000")
      payload += emv("53", "986")

      payload += emv("54", "%.2f" % valor) if valor

      payload += emv("58", "BR")
      payload += emv("59", nome[0..24])
      payload += emv("60", cidade[0..14])
      payload += emv("62", emv("05", txid))

      payload += "6304"
      crc = crc16(payload)
      payload + crc
    end

    def self.crc16(texto)
      resultado = 0xFFFF

      texto.each_byte do |caractere|
        resultado ^= (caractere << 8)

        8.times do
          if resultado & 0x8000 != 0
            resultado = (resultado << 1) ^ 0x1021
          else
            resultado <<= 1
          end

          resultado &= 0xFFFF
        end
      end
      resultado.to_s(16).upcase.rjust(4, "0")
    end

    def self.emv(id, value)
      length = value.length.to_s.rjust(2, "0")
      "#{id}#{length}#{value}"
    end
  end
end
