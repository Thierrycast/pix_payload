require_relative "../generator"

options = {}
OptionParser.new do |opts|
  opts.banner = "Uso: pix_payload generate [opções]"

  opts.on("--chave CHAVE", "Chave PIX") { |v| options[:chave] = v }
  opts.on("--nome NOME", "Nome do recebedor") { |v| options[:nome] = v }
  opts.on("--cidade CIDADE", "Cidade") { |v| options[:cidade] = v }
  opts.on("--valor VALOR", Float, "Valor opcional") { |v| options[:valor] = v }
  opts.on("--txid TXID", "TxID") { |v| options[:txid] = v }
  opts.on("--descricao DESC", "Descrição") { |v| options[:descricao] = v }
  opts.on("-h", "--help", "Ajuda") do
    puts opts
    exit
  end
end.parse!

unless options[:chave] && options[:nome] && options[:cidade]
  puts "Erro: faltam argumentos obrigatórios. Use --help para ver as opções."
  exit 1
end

puts PixPayload::Generator.generate_payload(
  chave: options[:chave],
  nome: options[:nome],
  cidade: options[:cidade],
  valor: options[:valor],
  txid: options[:txid],
  descricao: options[:descricao]
)
