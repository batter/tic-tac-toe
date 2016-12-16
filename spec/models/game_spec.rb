require 'spec_helper'

describe Game, type: :model do
  let(:game) { Game.create }

  it { expect(Game.included_modules).to include(Mongoid::Document) }

  describe "Associations" do
    describe :players do
      it { expect(Game.embedded_relations.keys).to include('players') }

      describe :find_by_symbol do
        let!(:player) { game.add_player!('Ben') }

        it "should locate a player via it's symbol" do
          expect(game.players.find_by_symbol(player.symbol)).to eq(player)
        end

        it "should not raise if no matching player is found" do
          expect(game.players.find_by_symbol('Z')).to be_nil
        end
      end
    end
  end

  describe "Scopes" do
    let!(:new_game) { game }
    let!(:finished_game) { Game.create(game_over: true, winner_symbol: 'X') }

    describe :unfinished do
      it "should return unfinished games" do
        expect(Game.unfinished).to include(new_game)
      end
    end

    describe :finished do
      it "should return finished games" do
        expect(Game.finished).to include(finished_game)
      end
    end
  end
end
