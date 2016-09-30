require 'roda'
require 'rack/indifferent'
require 'haml'
require 'securerandom'
require './lib/tic_tac_toe'

class App < Roda
  plugin :hooks
  plugin :render, engine: 'haml'
  plugin :partials
  plugin :json
  plugin :indifferent_params
  plugin :all_verbs
  plugin :assets, css: 'application.css', js: 'application.js',
    js_compressor: :uglifier

  def self.root
    @@root ||= Pathname.new(File.dirname(__FILE__))
  end

  def save!
    @game_file.save
  end

  # before hook runs before every request execution
  before do
    @game_file = TicTacToe::GameStore.current_game
    @game = @game_file.game
  end

  route do |r|
    r.assets unless ENV['RACK_ENV'] == 'production'

    # GET /
    r.root { view :index }

    r.on 'game' do
      # root routes
      r.is do
        # get current game state
        # GET /game
        r.get do
          @game.to_h
        end

        # create a new game
        # POST /game
        r.post do
          @game_file = TicTacToe::GameStore.new_game!
          @game_file.game.to_h
        end
      end

      r.post ':player_id/move' do |player_id|
        move = @game.move(player_id, [params[:row].to_i, params[:col].to_i])
        if move.is_a?(TicTacToe::Move)
          save!
          if @game.winner?
            {move: true, winner: @game.winner.to_h}
          else
            {move: true}
          end
        elsif move == false
          {move: false, error: 'Please select an empty spot'}
        else
          {move: false, error: move}
        end
      end

      # /game/players
      r.on 'players' do
        r.is do
          # GET /game/players
          r.get do
            @game.players.map(&:to_h) || []
          end
        end

        # POST /game/players/join/:name
        r.post 'join/:name' do |name|
          if player = @game.add_player(name)
            save!
            player.to_h
          else
            {error: 'Game Full'}
          end
        end
      end
      
    end
  end
end
