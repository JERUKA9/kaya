require 'games/chess/policy'

module Shogi

class Policy < Chess::Policy
  def initialize(move_factory, validator_factory)
    @move_factory = move_factory
    @validator_factory = validator_factory
  end
  
  def new_move(state, src, dst, opts = {})
    move = @move_factory.new(src, dst, opts.merge(:promote => true))
    valid = @validator_factory.new(state)
    move = @move_factory.new(src, dst, opts.merge(:promote => false)) unless valid[move]
    move
  end
end

end