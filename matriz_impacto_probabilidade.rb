# aula do marcio de gerência de projetos
# exemplo de matriz de impacto & probabilidade
# exemplo http://twitpic.com/g5r2z e http://twitpic.com/g5so4
fatores_de_escala = {
  :nulo => { 
    :probabilidade => 0...19,
    :percentual_sobre_custo => 0,
    :qualidade =>  'Nenhuma funcionalidade será afetada',
    :peso => 0,
    :peso_tempo_custo_qualidade => 0,
    :atraso => 0},
  :mbx => { 
    :probabilidade => 10...29,
    :percentual_sobre_custo => 1...14,
    :qualidade =>  'Totalmente irrelevante',
    :peso => 0.1,
    :peso_tempo_custo_qualidade => 0.05,
    :atraso => 1},
  :bx => { 
    :probabilidade => 30...49,
    :percentual_sobre_custo => 5...8,
    :qualidade =>  'Pouco Importante',
    :peso => 0.3,
    :peso_tempo_custo_qualidade => 0.1,
    :atraso => 2},
  :med => { 
    :probabilidade => 50...69,
    :percentual_sobre_custo => 9...12,
    :qualidade =>  'Importante',
    :peso => 0.5,
    :peso_tempo_custo_qualidade => 0.2,
    :atraso => 3},
  :alt => { 
    :probabilidade => 70...89,
    :percentual_sobre_custo => 13...16,
    :qualidade => 'Muito Importante',
    :peso => 0.7,
    :peso_tempo_custo_qualidade => 0.4,
    :atraso => 5},
  :malt => { 
    :probabilidade => 90...100,
    :percentual_sobre_custo => 16...100,
    :qualidade =>  'Essencial',
    :peso => 0.9,
    :peso_tempo_custo_qualidade => 0.8,
    :atraso => 8},
}

dimensoes_de_risco = {
  "$" => "Custo",
  "T" => "Tempo",
  "P" => "Politico",
  "C" => "Comercial",
  "Q" => "Qualidade",
  "L" => "Legal"
}

dimensiona_risco = lambda do |matriz_risco|
  resultado = {} 
  matriz_risco.each do |risco_probabilidade, pesos|
    pesos.each do |peso, dimensoes|
      dimensoes.each do |dimensao| 
        fator = risco_probabilidade == :probabilidade ? :peso : :peso_tempo_custo_qualidade
        (resultado[dimensao]||={})[risco_probabilidade] = fatores_de_escala[peso][fator]
      end
    end
  end
  resultado 
end

# mesmo exemplo que http://twitpic.com/g5r2z
=begin
matriz_risco = {
  :probabilidade => {
    :alt => ["C", "P", "Q", "T", "$", "L"]
  },
  :impacto => {
    :malt => ["C", "P", "Q"],
    :alt  => ["T", "$", "L"]
  }
}
=end

requisitos = [
{
  :probabilidade => {
    :med => %w(P C),
    :alt => %w(Q L),
    :malt => %w($ T)
  },
  :impacto => {
    :malt => %w(P C $ T),
    :alt => %w(Q L)
  }
},{
  :probabilidade => {
    :mbx => %w(C P),
    :alt => %w($ T),
    :malt => %w(Q L)
  },
  :impacto => {
    :malt => %w(Q L),
    :alt => %w($ T),
    :med => %w(C P)
  }
},{
  :probabilidade => {
    :bx => %w(Q L),
    :alt => %w($ T),
    :malt => %w(P C)
  },
  :impacto => {
    :malt => %w(P C),
    :med => %w($ T),
    :bx => %w(Q L)
  }
},{
  :probabilidade => {
    :bx => %w(P C),
    :alt => %w($),
    :malt => %w(Q T)
  },
  :impacto => {
    :malt => %w($ Q),
    :med => %w(T),
    :bx => %w(P C)
  }
},{
  :probabilidade => {
    :alt => %w($),
    :malt => %w(Q T P C)
  },
  :impacto => {
    :malt => %w(T Q),
    :alt => %w($),
    :med => %w(P C)
  }
}
]

ordem_de_prioridade = {}
requisitos.each_with_index do |matriz_risco, i|
  risco = 0.0 

  puts "requisito: #{i}"
  puts "dimensa|  impacto   | probabilid. | risco dimensao"

  dimensiona_risco.call(matriz_risco).each do |dimensao, calculo|
    risco_dimensao = calculo[:probabilidade].to_f*calculo[:impacto].to_f
    risco += risco_dimensao
    puts [dimensao, calculo[:impacto], calculo[:probabilidade], risco_dimensao].join("     |     ")
  end

  ordem_de_prioridade[i] = risco
  puts risco
  puts "--------------------"
end

puts "ordem de prioridade"
puts "requisito | indice risco"
ordem_de_prioridade.sort_by{|ordem, indice_risco|indice_risco}.reverse.each do |requisito,indice_risco|
  puts "      #{requisito}   |   #{indice_risco}"
end

