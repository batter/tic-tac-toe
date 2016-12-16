require File.expand_path('../../lib/tic_tac_toe', __FILE__)
require File.expand_path('../player', __FILE__)

class Game
  include TicTacToe::BoardSequence
  DEFAULT_BOARD = [Array.new(3), Array.new(3), Array.new(3)]

  include Mongoid::Document
  include Mongoid::Timestamps

  field :board, type: Array, default: DEFAULT_BOARD
  field :winner_symbol
  field :game_over, type: Boolean, default: false
  field :current_turn_symbol, default: Player::VALID_SYMBOLS.first

  index({winner_symbol: 1, game_over: 1})

  embeds_many :players do
    def find_by_symbol(symbol)
      where(symbol: symbol).first
    end
  end

  scope :unfinished, -> { where(game_over: false) }
  scope :finished,   -> { where(game_over: true) }

  def add_player!(name)
    symbol = players.size == 1 ? 'O' : 'X'
    players.size < 2 && players.create!(name: name, symbol: symbol)
  end

  def move(player_id, coords)
    return "The game is already over, #{winner.name} won" if winner?

    return 'Please wait for a 2nd player before making your first move' unless players.size == 2
    raise ArgumentError, '`coords` argument must be an array' unless coords.is_a?(Array)

    player = players.find(player_id)
    raise ArgumentError, "`player_id` arugment didn't match a valid player" unless player.is_a?(Player)

    if current_turn_symbol == player.symbol
      if board[coords.first][coords.last].nil?
        # Make the desired move
        self.board[coords.first][coords.last] = player.symbol
        # check to see if there is a winner or the game is full
        self.check_game_status!
        # Advance the turn sequence
        self.current_turn_symbol = player.symbol == 'X' ? 'O' : 'X'
        self.save
      else
        'Please select an empty spot'
      end
    else
      'Out of order, you must wait until the other player moves'
    end
  end

  def to_h
    attributes.merge({
      players: players.map(&:to_h),
      winner: winner? && winner.to_h,
      game_over: winner? || board_full?,
      _id: self.id.to_s
    })
  end

  def winner
    @winner ||= self.winning_sequence && players.find_by_symbol(winning_sequence.first)
  end

  def winner?
    !!winning_sequence
  end

  def board_full?
    @board_full ||=
      board_sequences.all? { |sequence| sequence.compact.size == board.size }
  end

  protected

  def check_game_status!
    self.winner_symbol = winner.symbol if self.winner?
    self.game_over = self.winner? || self.board_full?
  end

  def winning_sequence
    @winning_sequence ||= board_sequences.detect do |sequence|
      sequence.compact.size == board.size && sequence.uniq.size == 1
    end
  end
end
