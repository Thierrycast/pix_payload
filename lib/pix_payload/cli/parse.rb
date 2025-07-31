require "json"
require_relative "../parser"

options = {}

begin
  OptionParser.new do |opts|
    opts.banner = "Uso: pix_payload parse --payload COPIA_E_COLA [--raw]"

    opts.on("--payload PAYLOAD", "Código Copia e Cola") { |v| options[:payload] = v }
    opts.on("--raw", "Exibe estrutura EMV bruta") { options[:raw] = true }
    opts.on("-h", "--help", "Ajuda") do
      puts opts
      exit
    end
  end.parse!
rescue OptionParser::MissingArgument
end

unless options[:payload]
  print "Informe o payload Copia e Cola: "
  options[:payload] = gets.strip
end

options[:payload] = options[:payload].gsub(/\A"|"\Z/, "")

unless options[:payload].include?("6304")
  warn "⚠️ Payload parece incompleto. Use aspas para argumentos com espaços."
  exit 1
end

if options[:raw]
  puts JSON.pretty_generate(PixPayload::Parser.parse_emv_fields(options[:payload]))
else
  result = PixPayload::Parser.parse_payload(options[:payload])
  puts "Aviso: nenhum dado foi extraído do payload." if result.empty?
  puts JSON.pretty_generate(result)
end
