# lib/pix_payload/modifier.rb
module PixPayload
  class Modifier
    def self.alterar(payload, campos = {})
      dados_originais = PixPayload::Parser.parse_payload(payload)
      if dados_originais.empty? || dados_originais[:chave].nil? || dados_originais[:nome].nil? || dados_originais[:cidade].nil?
        return nil
      end

      dados_finais = dados_originais.merge(campos.transform_keys(&:to_sym))

      PixPayload::Generator.generate_payload(
        chave: dados_finais[:chave],
        nome: dados_finais[:nome],
        cidade: dados_finais[:cidade],
        valor: dados_finais[:valor],
        txid: dados_finais[:txid],
        descricao: dados_finais[:descricao]
      )
    end
  end
end
