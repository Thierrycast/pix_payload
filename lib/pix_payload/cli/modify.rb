require_relative "../modifier"
require_relative "../parser"

options = {}
OptionParser.new do |opts|
  opts.banner = "Uso: pix_payload modify --payload CODIGO [--valor NOVO_VALOR] [--txid NOVO_TXID] ..."

  opts.on("--payload PAYLOAD", "Código original") { |v| options[:payload] = v }
  opts.on("--valor VALOR", Float, "Novo valor") { |v| options[:valor] = v }
  opts.on("--txid TXID", "Novo TxID") { |v| options[:txid] = v }
  opts.on("--descricao DESC", "Nova descrição") { |v| options[:descricao] = v }
  opts.on("--nome NOME", "Novo nome") { |v| options[:nome] = v }
  opts.on("--cidade CIDADE", "Nova cidade") { |v| options[:cidade] = v }
  opts.on("--chave CHAVE", "Nova chave") { |v| options[:chave] = v }
  opts.on("-h", "--help", "Ajuda") do
    puts opts
    exit
  end
end.parse!

if options[:payload]
  if options[:payload] && !options[:payload].include?("6304")
    warn "⚠️ Payload parece incompleto. Use aspas para argumentos com espaços."
    exit 1
  end

  novo_payload = PixPayload::Modifier.alterar(options.delete(:payload), options)
  if novo_payload
    puts novo_payload
  else
    puts "Erro: payload inválido ou os dados originais não puderam ser lidos."
    exit 1
  end
else
  puts "Erro: informe --payload"
  exit 1
end
