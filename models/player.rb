class Player
  VALID_SYMBOLS = %w(X O)

  include Mongoid::Document

  field :name
  field :symbol

  embedded_in :game

  validates_inclusion_of :symbol, in: VALID_SYMBOLS

end
