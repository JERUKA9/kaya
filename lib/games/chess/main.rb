require 'games/games'
require 'games/chess/state'
require 'games/chess/move'
require 'games/chess/board'
require 'games/chess/policy'
require 'games/chess/animator'
require 'games/chess/validator'
require 'games/chess/serializer'

module Chess

Game.add :chess do
  Game.new :size => Point.new(8, 8),
           :policy => Policy.new,
           :state_component => State,
           :state => lambda { state_component.new(board.new, move, piece) },
           :board_component => Board,
           :board => lambda { board_component.new(size) },
           :move => Move,
           :animator => Animator,
           :validator => Validator,
           :piece => Piece,
           :players => [:white, :black],
           :serializer => lambda {|rep| Serializer.new(rep, validator, move, piece) },
           :keywords => %w(chess)
end

Game.add :chess5x5, [:chess] do |chess|
  chess.extend(:size => Point.new(5, 5))
end

end