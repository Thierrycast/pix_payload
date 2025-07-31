# frozen_string_literal: true

require_relative "version"

module PixPayload
  class Parser
    def self.parse_emv_fields(payload)
      payload = payload.to_s
      fields = {}
      index = 0

      while index < payload.length
        id = payload[index, 2]
        length = payload[index + 2, 2].to_i
        value = payload[index + 4, length]
        index += 4 + length

        # subcampos
        fields[id] = if %w[26 62].include?(id)
                       parse_emv_fields(value)
                     else
                       value
                     end
      end

      fields
    end

    def self.interpretar_payload(parsed_emv)
      {
        chave: parsed_emv.dig("26", "01"),
        descricao: parsed_emv.dig("26", "02"),
        valor: parsed_emv["54"]&.to_f,
        nome: parsed_emv["59"],
        cidade: parsed_emv["60"],
        txid: parsed_emv.dig("62", "05")
      }.compact
    end

    def self.parse_payload(payload)
      emv = parse_emv_fields(payload)
      interpretar_payload(emv)
    end
  end
end
