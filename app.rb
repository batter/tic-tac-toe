require 'roda'
require 'haml'
require 'json'
require 'rack/indifferent'

require File.expand_path('../models/all', __FILE__)

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

  # before hook runs before every request execution
  before do
    @game = Game.last || Game.new
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
          @game = Game.create!
          @game.to_h
        end
      end

      r.post ':player_id/move' do |player_id|
        move = @game.move(player_id, [params[:row].to_i, params[:col].to_i])
        if move == true
          @game.to_h.merge(move: true)
        else
          {move: false, error: move.to_s}
        end
      end

      # /game/players
      r.on 'players' do
        r.is do
          # GET /game/players
          r.get do
            @game.players.map(&:to_h)
          end
        end

        # POST /game/players/join/:name
        r.post 'join/:name' do |name|
          if @game.add_player!(name.gsub(/%20/, ' '))
            @game.to_h.merge(player: @game.players.last.to_h)
          else
            {error: 'Game Full'}
          end
        end
      end
    end
  end
end
