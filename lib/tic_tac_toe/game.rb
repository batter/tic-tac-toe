module TicTacToe
  class Game
    attr_accessor :board, :player1, :player2

    def initialize
      self.board = Board.new
    end

    def to_a
      board.grid
    end

    def players
      [player1, player2].compact
    end

    def to_h
      {
        players: players.compact.map(&:to_h),
        game: board.to_h,
        board: board.to_simple_h
      }
    end

    def winner
      board.sequences.any? do |sequence|
        player = sequence.compact.size == 3 &&
          sequence.map(&:player).map(&:id).uniq.size == 1 &&
            sequence.first.player
        return player if player
      end
    end

    def winner?
      !!self.winner
    end

    def move(player_id, coords)
      raise ArgumentError, '`coords` argument must be an array' unless coords.is_a?(Array)

      player = players.select { |player| player.id == player_id }.first
      raise ArgumentError, "`player_id` arugment didn't match a valid player" unless player.is_a?(Player)

      if board.grid[coords.first][coords.last].nil?
        board.grid[coords.first][coords.last] = Move.new(player)
      else
        return false
      end
    end
  end
end
