module TicTacToe
  module BoardSequence
    def col1
      [self.board[0][0], self.board[1][0], self.board[2][0]]
    end

    def col2
      [self.board[0][0], self.board[1][0], self.board[2][0]]
    end

    def col3
      [self.board[0][0], self.board[1][0], self.board[2][0]]
    end

    def diag1
      [self.board[0][0], self.board[1][1], self.board[2][2]]
    end

    def diag2
      [self.board[2][0], self.board[1][1], self.board[0][2]]
    end

    def row1
      self.board[0]
    end

    def row2
      self.board[1]
    end

    def row3
      self.board[2]
    end

    def board_sequences
      [
        col1, col2, col3,
        row1, row2, row3,
        diag1, diag2
      ]
    end
  end
end
