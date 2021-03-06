# Copyright (c) 2009 Paolo Capriotti <p.capriotti@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

class ValidatorBase
  def initialize(state)
    @state = state
  end

  # whether this move satisfies basic conditions
  # for validity
  # 
  def proper?(move)
    return false unless @state.board.valid? move.src
    return false unless @state.board.valid? move.dst
    
    piece = @state.board[move.src]
    return false unless piece and piece.color == @state.turn
    true
  end
  
  def check_legality(piece, target, move)
    king_pos = @state.board.find(@state.piece_factory.new(piece.color, :king))
    if king_pos
      not attacked?(king_pos)
    end
  end
  
  def check_pseudolegality(piece, target, move)
    return false if move.dst == move.src
    
    target ||= @state.board[move.dst]
    return false if piece.same_color_of?(target)
  
    m = validator_method(piece.type)
    valid = if respond_to? m
      send(m, piece, target, move)
    end
  end

  def validator_method(type)
    "validate_#{type.to_s}"
  end

  def attacked?(dst, target = nil)
    @state.board.to_enum(:each_square).any? do |src|
      to_enum(:each_move, src, dst, target).any? { true }
    end
  end
end
