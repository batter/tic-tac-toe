require 'spec_helper'

describe Player, type: :model do
  describe "Constants" do
    describe :VALID_SYMBOLS do
      it { expect(Player.const_defined?(:VALID_SYMBOLS)).to eq(true) }
      it { expect(Player::VALID_SYMBOLS).to eq(%w(X O)) }
    end
  end

  describe "Methods" do
    let(:symbol) { Player::VALID_SYMBOLS.sample }
    let(:game) { Game.create }
    let(:instance) { game.players.create(name: 'Jasper', symbol: symbol) }

    describe :to_h do
      let(:value) { instance.to_h }

      it "should return the player's attributes as a hash" do
        expect(value).to eq({'_id' => instance._id.to_s, 'name' => 'Jasper', 'symbol' => symbol})
      end
    end
  end
end