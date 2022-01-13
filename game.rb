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
      puts "Make a move"
      player_input = gets.chomp
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

  def grid
    Game.board.each do |k|
      puts k.each { |v| v }.join(' ')
    end
  end
end

# prints the board
def grid(array)
  array.each do |k|
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
  check_rows || check_columns || check_win
end

puts 'Enter a name for Player 1'
name = gets 
player_1 = Game.new(name, 'o')

puts 'Enter a name for Player 2'
name = gets 
player_2 = Game.new(name, 'x')

puts 'Player 1 plays as \'o\'. Player 2 plays as \'x\'.'
