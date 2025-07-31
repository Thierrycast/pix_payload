require "json"
require_relative "../parser"

options = {}
OptionParser.new do |opts|
  opts.banner = "Uso: pix_payload parse --payload COPIA_E_COLA"

  opts.on("--payload PAYLOAD", "Código Copia e Cola") { |v| options[:payload] = v }
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
  result = PixPayload::Parser.parse_payload(options[:payload])
  puts "Aviso: nenhum dado foi extraído do payload." if result.empty?
  puts JSON.pretty_generate(result)
else
  puts "Erro: informe --payload"
  exit 1
end
