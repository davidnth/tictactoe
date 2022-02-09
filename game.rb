# a class containing the board
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

# Player class containing name and symbol
class Player
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

  # gets a number between 1-9
  def input
    puts "#{@name}'s turn to move. Enter a number between 1-9."
    loop do
      number = gets.to_i
      puts 'Invalid move. Enter an unoccupied number.' unless unoccupied?(number)
      break number if (1..9).include?(number) && unoccupied?(number)
    end
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
    return @name if right_left
    return @name if left_right

    false
  end

  def left_right
    k = Game.board.length + 1
    arr = Game.board.flatten
    left_right = []
    arr.each_slice(k) { |n| left_right << n.first }
    return @name if left_right.all?(@symbol)

    false
  end

  def right_left
    arr = Game.board.flatten
    row_size = Game.board.length
    right_left = []
    arr.slice(1, arr.length - row_size).each_slice(row_size - 1) { |n| right_left << n.last }
    return @name if right_left.all?(@symbol)

    false
  end

  # checks if the player has one
  def check_win
    if check_rows || check_columns || check_diagonals
      puts "#{@name} wins!"
      return @name
    end
    false
  end
end

def player_name(num)
  puts "Enter a name for player #{num}"
  loop do
    name = gets.chomp
    break name unless name.empty?

    puts 'Please enter a name.'
  end
end

# checks position is unoccupied
def unoccupied?(number)
  Game.board.any? { |row| row.any? { |val| val == number } }
end

def board_full?
  if Game.board.all? { |row| row.none? { |square| square.is_a? Integer } }
    puts 'It\'s a draw.'
    return true
  end

  false
end

def play_game(player_one, player_two)
  loop do
    player_one.move(player_one.input)
    break if player_one.check_win || board_full?

    player_two.move(player_two.input)
    break if player_two.check_win || board_full?
  end
end

def play_again?(player_one, player_two, game)
  loop do
    puts 'Play again? Y/N'
    answer = gets.chomp
    if %w[y Y].include? answer
      game.new_game
      Game.grid
      play_game(player_one, player_two)
    end
    break if %w[n N].include? answer
  end
end

game = Game.new
game.new_game

player_one = Player.new(player_name('one'), 'o')
player_two = Player.new(player_name('two'), 'x')

puts "#{player_one.name} plays as \'#{player_one.symbol}\'."
puts "#{player_two.name} plays as \'#{player_two.symbol}\'."

Game.grid
play_game(player_one, player_two)
play_again?(player_one, player_two, game)
