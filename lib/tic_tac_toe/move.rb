module TicTacToe
  class Move
    attr_accessor :player

    def initialize(player)
      self.player = player
    end

    def to_h
      { player: player.id, move: player.symbol }
    end
  end
end