require 'json'

module TicTacToe
  module GameStore
    STORE_DIRECTORY = File.expand_path('../../../tmp', __FILE__)

    def self.current_game=(game_file)
      @current_game = game_file
    end

    def self.current_game
      @current_game ||= GameFile.new
    end

    def self.new_game!
      self.current_game = GameFile.new(Game.new)
      self.current_game.save
      self.current_game
    end

    class GameFile
      attr_accessor :file_path, :data, :game

      def initialize(game = nil, file_path = "#{STORE_DIRECTORY}/game.json")
        self.file_path = file_path
        self.data = File.file?(file_path) && self.class.load(file_path)
        self.game ||= game || load_game
      end

      def self.load(file_path = nil)
        file_path ||= Dir["#{STORE_DIRECTORY}/*.json"].last
        file_path && JSON.parse(File.open(file_path, 'r') { |f| f.read }, symbolize_names: true)
      end

      def save
        self.data = JSON.dump(game.to_h)
        File.open(file_path, 'w') { |f| f.write(data) }
      end

      def load_game
        self.game ||=
          TicTacToe::Game.new.tap do |game|
            player1 = data[:players].first
            player2 = data[:players].last
            game.player1 = Player.new(player1[:name], player1[:symbol], player1[:id])
            game.player2 = Player.new(player2[:name], player2[:symbol], player2[:id])
            game.board = Board.new.tap do |board|
              board.grid = data[:game].map do |row|
                row.map do |obj|
                  if obj.nil?
                    nil
                  else
                    player = obj[:player] == game.player1.id ? game.player1 : game.player2
                    Move.new(player)
                  end
                end
              end
            end
          end
      end
    end

  end
end
