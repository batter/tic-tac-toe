require 'securerandom'

module TicTacToe
  class Player
    attr_accessor :name, :id, :symbol

    def initialize(name, symbol, id = SecureRandom.uuid)
      self.name = name
      self.symbol = symbol
      self.id = id
    end

    def to_h
      {
        name: name,
        symbol: symbol,
        id: id
      }
    end
  end
end
