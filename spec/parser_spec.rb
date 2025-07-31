require "spec_helper"

RSpec.describe PixPayload::Parser do
  let(:payload) do
    PixPayload::Generator.generate_payload(
      chave: "thierry@pix.com",
      nome: "THIERRY CASTRO",
      cidade: "SAO PAULO",
      valor: 42.0,
      txid: "ABC123",
      descricao: "top demais hehe"
    )
  end

  it "extrai os campos corretamente" do
    resultado = described_class.parse_payload(payload)

    expect(resultado[:chave]).to eq("thierry@pix.com")
    expect(resultado[:nome]).to eq("THIERRY CASTRO")
    expect(resultado[:cidade]).to eq("SAO PAULO")
    expect(resultado[:valor]).to eq(42.0)
    expect(resultado[:txid]).to eq("ABC123")
    expect(resultado[:descricao]).to eq("top demais hehe")
  end
end
