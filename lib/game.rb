require 'pry'
class Game
  include Players
  attr_accessor :board, :player_1, :player_2
  ::WIN_COMBINATIONS = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [6,4,2]]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    if self.board.turn_count.odd?
      self.player_2
    else
      self.player_1
    end
  end

  def won?
      winning_combination = ::WIN_COMBINATIONS.find do |combination|
                              self.board.position(combination[0]+1) == self.board.position(combination[1]+1) and
                              self.board.position(combination[0]+1) == self.board.position(combination[2]+1) and
                              self.board.position(combination[0]+1) != " "
                             end

      winning_combination if winning_combination != nil
  end

  def draw?
    true if self.board.full? == true and self.won? == nil
  end

  def over?
    true if self.draw? == true or self.won? != nil
  end

  def winner
    self.board.cells[self.won?[0]] if self.won? != nil
  end

  def turn
    player = current_player
    current_move = player.move(@board)
    if !@board.valid_move?(current_move)
      turn
    else
      puts "Turn: #{@board.turn_count+1}\n"
      @board.display
      @board.update(current_move, player)
      puts "#{player.token} moved #{current_move}"
      @board.display
      puts "\n\n"
    end
  end

  def play
    while !over? or won? == nil
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end

end
