require "spec_helper"

RSpec.describe PixPayload::Generator do
  describe ".generate_payload" do
    it "gera um payload valido com todos os campos" do
      payload = described_class.generate_payload(
        chave: "thierry@pix.com",
        nome: "THIERRY CASTRO",
        cidade: "SAO PAULO",
        valor: 123.45,
        txid: "TX123456",
        descricao: "teste de pagamento"
      )

      expect(payload).to include("0014BR.GOV.BCB.PIX")
      expect(payload).to include("thierry@pix.com")
      expect(payload).to include("THIERRY CASTRO")
      expect(payload).to include("SAO PAULO")
      expect(payload).to match(/6304[A-F0-9]{4}$/) # CRC16
    end
  end
end
