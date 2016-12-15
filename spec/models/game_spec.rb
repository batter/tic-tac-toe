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
end
