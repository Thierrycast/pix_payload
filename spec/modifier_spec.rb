require "spec_helper"

RSpec.describe PixPayload::Modifier do
  let(:payload_original) do
    PixPayload::Generator.generate_payload(
      chave: "thierry@pix.com",
      nome: "THIERRY CASTRO",
      cidade: "SAO PAULO",
      valor: 100.0,
      txid: "ORIGINAL"
    )
  end

  it "altera apenas o valor mantendo os demais dados" do
    novo_payload = described_class.alterar(payload_original, valor: 55.5)
    dados = PixPayload::Parser.parse_payload(novo_payload)

    expect(dados[:valor]).to eq(55.5)
    expect(dados[:txid]).to eq("ORIGINAL")
    expect(dados[:chave]).to eq("thierry@pix.com")
  end

  it "retorna nil se payload for inválido" do
    expect(described_class.alterar("invalido")).to be_nil
  end
end
