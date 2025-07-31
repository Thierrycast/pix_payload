require_relative "../modifier"
require_relative "../parser"
require_relative "../generator"

def solicitar(label)
  print "#{label}: "
  gets.strip
end

def solicitar_valor(label)
  loop do
    entrada = solicitar("#{label} (ex: 42.5, pressione ENTER para não alterar)")
    return nil if entrada.empty?

    begin
      return Float(entrada)
    rescue StandardError
      puts("⚠️ Valor inválido. Tente novamente.")
    end
  end
end

def solicitar_limite(label, limite)
  loop do
    entrada = solicitar("#{label} (máx #{limite} caracteres, ENTER para manter)")
    return nil if entrada.empty?
    return entrada if entrada.length <= limite

    puts "⚠️ Excedeu o limite de #{limite} caracteres. Tente novamente."
  end
end

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

options[:payload] = solicitar("Informe o payload Copia e Cola existente") unless options[:payload]

options[:payload] = options[:payload].gsub(/\A"|"\Z/, "")

unless options[:payload].include?("6304")
  warn "⚠️ Payload parece incompleto. Use aspas para argumentos com espaços."
  exit 1
end

campos_alteraveis = %i[chave nome cidade valor txid descricao]
campos_preenchidos = options.keys & campos_alteraveis

if campos_preenchidos.empty?
  puts "⚙️  Deseja alterar algum campo? Pressione ENTER para manter o original."

  campos_alteraveis.each do |campo|
    case campo
    when :valor
      valor = solicitar_valor("Novo valor")
      options[:valor] = valor unless valor.nil?
    when :nome
      entrada = solicitar_limite("Novo nome", 25)
      options[:nome] = entrada unless entrada.nil?
    when :cidade
      entrada = solicitar_limite("Nova cidade", 15)
      options[:cidade] = entrada unless entrada.nil?
    else
      entrada = solicitar("Novo valor para #{campo} (ENTER para manter)")
      options[campo] = entrada unless entrada.empty?
    end
  end
end

novo_payload = PixPayload::Modifier.alterar(options.delete(:payload), options)
if novo_payload
  puts novo_payload
else
  puts "Erro: payload inválido ou os dados originais não puderam ser lidos."
  exit 1
end
