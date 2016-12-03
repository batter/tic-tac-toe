module TicTacToe
  module BoardSequence
    def board_sequences_hash
      sequences = {}
      size = board.size - 1
      (0..size).each do |y|
        (0..size).each do |x|
          (sequences["r#{y}"] ||= []) << board[y][x]
          (sequences["c#{x}"] ||= []) << board[y][x]
          if x == y
            (sequences['fd'] ||= []) << board[y][x]
          end
          if (x + y) == size
            (sequences['bd'] ||= []) << board[y][x]
          end
        end
      end
      sequences
    end

    def board_sequences
      self.board_sequences_hash.values
    end
  end
end
