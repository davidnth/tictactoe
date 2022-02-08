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

  # checks horizontally for a winner 
  def check_rows
    winner = Game.board.any? { |row| row.all?(@symbol) }
    return @name if winner

    false
  end
  # checks vertically for a winner
  def check_columns
    winner = Game.board.transpose.any? { |column| column.all?(@symbol) }
    return @name if winner

    false
  end

  # checks diagonally for a winner
  def check_diagonals
    right_left
    left_right
  end 

  def left_right
    k = Game.board.length + 1
    v = Game.board.length - 1
    arr = Game.board.flatten
    left_right = []
    arr.each_slice(k) { |n| left_right << n.first }
    puts "#{@name} wins diagonally (left-right)" if left_right.all?(@symbol)
    return @name if left_right.all?(@symbol)

    false
  end
  
  def right_left
    arr = Game.board.flatten
    row_size = Game.board.length
    right_left = []
    arr.slice(1, arr.length - row_size).each_slice(row_size - 1) { |n| right_left << n.last }
    puts "#{@name} wins diagonally (right-left)" if right_left.all?(@symbol) 
    return @name if right_left.all?(@symbol)

    false
  end 

  def check_win
    puts "#{@name} wins" if check_rows
    puts "#{@name} wins" if check_columns
    puts "#{@name} wins" if check_diagonals
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
player_one.check_win
