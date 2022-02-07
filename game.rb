# a game class containing the board and players
class Game
  attr_reader :name, :symbol

  @@board = Array.new(3) { Array.new(3) { '-' } }
  # initialize with player names and empty board
  def self.board
    @@board
  end
  # create player

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def move
    loop do
      puts "#{@name}'s turn. Make a move."
      player_input = ''
      loop do
        player_input = gets.chomp 
        break if check_input(player_input)
      end 
      move_array = player_input.slice(1, player_input.length - 2).split(',')
      move = {:row => move_array[0].to_i, :column => move_array[1].to_i}
      if @@board[move[:row]][move[:column]] != '-'
        puts 'Invalid move, please try again.'
      else
        @@board[move[:row]][move[:column]] = @symbol 
        break
      end
    end
  end

  def check_input(string)
    if string.length != 5 || !string.split(',') 
      puts 'Invalid input, please enter a position in the format \'[row,column]\'.'
      return #false
    end 
    if !/[0-2]/.match(string[1]) || !/[0-2]/.match(string[3])
      puts 'Invalid input, please enter a position in the format \'[row,column]\'.'
      return #false 
    end
    return string
  end 

  def self.grid
    Game.board.each do |k|
      puts k.each { |v| v }.join(' ')
    end
  end

  def check_rows
    Game.board.any? do |row|
      row.all? { |x| x == row[0] }
    end
  end
  
  def check_columns
    Game.board.transpose.any? do |column|
      column.all? { |x| x == column[0] }
    end
  end
  
  def check_diagonals
    array = Game.board.flatten
    up_down = []
    (0..array.length - 1).step(4).each do |index|
      up_down.push(array[index])
    end
    down_up = []
    (2..6).step(2).each do |index|
      down_up.push(array[index])
    end
    up_down.all? { |x| x == up_down[0]} || down_up.all? { |x| x == down_up[0]}
  end
  
  def check_win
    if check_rows || check_columns || check_diagonals 
      puts @name 
    end
  end
end



def check_rows
  Game.board.any? do |row|
    row.all? { |x| x == row[0] }
  end
end

def check_columns
  Game.board.transpose.any? do |column|
    column.all? { |x| x == column[0] }
  end
end

def check_diagonals
  array = Game.board.flatten
  up_down = []
  (0..array.length - 1).step(4).each do |index|
    up_down.push(array[index])
  end
  down_up = []
  (2..6).step(2).each do |index|
    down_up.push(array[index])
  end
  up_down.all? { |x| x == up_down[0]} || down_up.all? { |x| x == down_up[0]}
end

def check_win
  if check_rows || check_columns || check_diagonals 
    p "there is a winner"
  end 
end

puts 'Enter a name for Player 1'
name = gets.chomp
player_1 = Game.new(name, 'o')


puts 'Enter a name for Player 2'
name = gets.chomp
player_2 = Game.new(name, 'x')

puts "#{player_1.name} plays as \'o\'. #{player_2.name} plays as \'x\'."
puts 'Enter a position in the format [row,column] where row and column are between 0 and 2.'
player_1.move
Game.grid 
player_2.move
Game.grid
player_2.check_win

########## starting over 

# game class containing the class instance variable board which will be available to players
class Game
  class << self
    attr_accessor :board
  end
  @board = Array.new(3) { Array.new(3) }

  def new_game
    i = 1
    Game.board.each_with_index do |row, r|
      row.each_with_index do |column, c|
        Game.board[r][c] = i
        i += 1
      end
    end
  end

  def self.grid
    @board.each do |k|
      puts k.join('|')
    end
  end
end

# Player class
class Player
  #Player < Game
  attr_accessor :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  # Assigns symbol to position if position is vacant
  def move(num)
    Game.board.each_with_index do |row, row_index|
      row.each_with_index do |_column, column_index|
        Game.board[row_index][column_index] = @symbol if Game.board[row_index][column_index] == num
      end
    end
    Game.grid
  end

  def check_rows
    winner = Game.board.any? do |row|
      row.all?(@symbol)
    end
    if winner puts "#{@name}" 
    return false 
  end

  def check_columns
    Game.board.transpose.each do |column|
      break @name if column.all?(@symbol)
    end
    puts "#{@name} wins!"
  end

  def check_win
    return if check_rows
    return if check_columns
  end 


end 

def player_name
  puts 'Enter a name.'
  loop do
    name = gets.chomp
    break name unless name.empty?

    puts 'Please enter a name.'
  end
end

# gets a number between 1-9
def input
  loop do
    puts 'Enter a number between 1-9'
    number = gets.chomp.to_i
    break number if (1..9).include?(number)
  end
end



# creates game object
game = Game.new
# numbers the array
game.new_game
# initialises player one and two
player_one = Player.new(player_name, 'o')
player_two = Player.new(player_name, 'x')

puts "#{player_one.name} plays as \'#{player_one.symbol}\'."
puts "#{player_two.name} plays as \'#{player_two.symbol}\'."

player_one.move(input)
player_one.move(input)
player_one.move(input)
player_one.check_rows
