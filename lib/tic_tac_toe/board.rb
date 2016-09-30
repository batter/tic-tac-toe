module TicTacToe
  class Board
    attr_accessor :grid

    def initialize
      self.grid = [
        Array.new(3),
        Array.new(3),
        Array.new(3)
      ]
    end

    def row1
      self.grid[0]
    end

    def row2
      self.grid[1]
    end

    def row3
      self.grid[2]
    end

    def to_h
      self.grid.map do |row|
        row.map { |move| move && move.to_h }
      end
    end

    def to_simple_h
      self.grid.map do |row|
        row.map { |move| move && move.player && move.player.symbol }
      end
    end
  end
end
