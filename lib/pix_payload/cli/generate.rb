require_relative "../generator"

def solicitar_obrigatorio(label, max = nil)
  loop do
    print "#{label}#{max ? " (máx #{max} caracteres)" : ""}: "
    entrada = gets.strip
    if entrada.empty?
      puts "⚠️ Campo obrigatório. Tente novamente."
    elsif max && entrada.length > max
      puts "⚠️ Limite de #{max} caracteres excedido. Tente novamente."
    else
      return entrada
    end
  end
end

def solicitar_opcional(label, tipo: :string)
  print "#{label} (pressione ENTER para ignorar): "
  entrada = gets.strip
  return nil if entrada.empty?

  if tipo == :float
    begin
      Float(entrada)
    rescue ArgumentError
      puts "⚠️ Valor inválido. Deve ser um número (ex: 42.5)."
      solicitar_opcional(label, tipo: :float)
    end
  else
    entrada
  end
end

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

options[:chave]  ||= solicitar_obrigatorio("Informe a chave PIX")
options[:nome]   ||= solicitar_obrigatorio("Informe o nome do recebedor", 25)
options[:cidade] ||= solicitar_obrigatorio("Informe a cidade", 15)

options[:valor] ||= solicitar_opcional("Informe o valor (ex: 42.5)", tipo: :float)
options[:txid] ||= solicitar_opcional("Informe o TxID")
options[:descricao] ||= solicitar_opcional("Informe a descrição")

puts PixPayload::Generator.generate_payload(
  chave: options[:chave],
  nome: options[:nome],
  cidade: options[:cidade],
  valor: options[:valor],
  txid: options[:txid],
  descricao: options[:descricao]
)
