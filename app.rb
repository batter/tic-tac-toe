require 'roda'
# require 'rack/indifferent'
require 'haml'
require 'securerandom'
require './lib/tic_tac_toe'

class App < Roda

  plugin :hooks
  plugin :render, engine: 'haml'
  plugin :partials
  plugin :json
  plugin :all_verbs
  # plugin :params_capturing
  plugin :indifferent_params
  plugin :assets, css: 'application.css', js: 'application.js',
    js_compressor: :uglifier

  def self.root
    @@root ||= Pathname.new(File.dirname(__FILE__))
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
        @game && @game.move(player_id, [params[:row].to_i, params[:col].to_i])
        @game_file.save
        {move: success}
      end

      # GET /game/players
      r.on 'players' do
        r.is do
          r.get do
            @game && @game.players.map(&:to_h) || []
          end
        end

        r.post 'enter' do
          @game && @game.players.sample.to_h
        end

        r.get 'enter' do
          @game && @game.players.sample.to_h
        end
      end
      
    end
  end
end
