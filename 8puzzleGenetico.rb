require "rubygems"
require "ai4r/genetic_algorithm/genetic_algorithm"

def pieza_x_y(estado, pieza)
  x = -1
  y = 0
  estado.each_with_index do |el, i|
    y += 1
    if i % 3 == 0
      x+=1
      y = 0
    end
    return [x, y] if pieza == el 
  end
end

def manhattan(estado_actual)
  estado_objetivo = [1,2,3,4,5,6,7,8,0]
  manhattan = 0
  estado_actual.each do |pieza|
    pieza_x_y_actual = pieza_x_y(estado_actual, pieza) #[0, 0]
    pieza_x_y_objetivo = pieza_x_y(estado_objetivo, pieza) # [2, 1]

    manhattan += (pieza_x_y_objetivo[0] - pieza_x_y_actual[0]).abs + (pieza_x_y_objetivo[1] - pieza_x_y_actual[1]).abs
  end
  manhattan
end

def estado_correcto?(estado)
  estado.uniq.size == 9
end

class Ai4r::GeneticAlgorithm::GeneticSearch
  def run
    generate_initial_population                    #Generate initial population 
    @max_generation.times do |i|
     # puts manhattan(best_chromosome.data)
   #   puts manhattan(@population.last.data)
      selected_to_breed = selection                #Selecciona para reproducir 
      offsprings = reproduction selected_to_breed  #Generate the population for this new generation
      replace_worst_ranked offsprings
    end
    best_chromosome
  end

  def selection
    @population.sort! { |x,y| y.fitness <=> x.fitness }
    best_fitness = @population.first.fitness
    worst_fitness = @population.last.fitness
#    puts "best:#{best_fitness}"
 #   puts "worst:#{worst_fitness}"
    if best_fitness-worst_fitness > 0
      @population.each do |chromosome| 
        chromosome.normalized_fitness = (chromosome.fitness - worst_fitness)/(best_fitness-worst_fitness)
      end
    else
      @population.each { |chromosome| chromosome.normalized_fitness = 1}  
    end
    selected_to_breed = []
    ((2*@population_size)/3).times do |i|
      selected_to_breed << @population[i]
    end
    selected_to_breed
  end
end

class Ai4r::GeneticAlgorithm::Chromosome
  def fitness
    if !estado_correcto?(@data)
      #@fitness = @data.size * 4 # Maximo manhattan 
      @fitness = 0
    else
      @fitness = 1.0/(manhattan(@data)+1)
    end
  end

  def self.seed
    return self.new((0..8).to_a.shuffle)
  end

  def self.reproduce(a,b)
    #[8, 1, 5, 0, 2, 6, 7, 3, 4]
    rep_size = rand(a.data.size) + 1
    rep_size -= 1 if rep_size == a.data.size
    rep = Array.new(a.data)
    rep_size.times do |i|
      rep[i] = b.data[i]
    end
    return self.new(rep) 
  end
end

search = Ai4r::GeneticAlgorithm::GeneticSearch.new(500, 200)
result = search.run
puts "Best: " + manhattan(search.best_chromosome.data).to_s
puts search.best_chromosome.inspect