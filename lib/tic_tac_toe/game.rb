module TicTacToe
  class Game
    attr_accessor :board, :player1, :player2, :turn

    def initialize
      self.board = Board.new
    end

    def add_player(name)
      if players.size < 2
        if player1.nil?
          self.player1 = Player.new(name)
          self.turn = player1.id
          self.player1
        else
          self.player2 = Player.new(name, 'O')
        end
      end
    end

    def to_a
      board.grid
    end

    def players
      [player1, player2].compact
    end

    def move(player_id, coords)
      raise ArgumentError, '`coords` argument must be an array' unless coords.is_a?(Array)
      return 'Please wait for a 2nd player before making your first move' unless players.size == 2

      player = players.select { |player| player.id == player_id }.first
      raise ArgumentError, "`player_id` arugment didn't match a valid player" unless player.is_a?(Player)

      if turn == player_id
        if board.grid[coords.first][coords.last].nil?
          move = board.grid[coords.first][coords.last] = Move.new(player)

          other_player = players.reject { |player| player.id == player_id }.first
          self.turn = other_player && other_player.id
          move
        else
          'Please select an empty spot'
        end
      else
        'Out of order, you must wait until the other player moves'
      end
    end

    def simple_state
      {
        board: board.to_simple_h,
        players: players.compact.map(&:to_h)
      }
    end

    def to_h
      self.simple_state.merge({
        game: board.to_h,
        turn: turn,
        winner: winner
      })
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
  end
end
