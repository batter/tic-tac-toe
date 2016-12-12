require 'spec_helper'

describe Player, type: :model do
  let(:attributes) { { name: 'Ben', symbol: Player::VALID_SYMBOLS.sample } }
  let(:instance) { Player.new(attributes) }

  it { expect(Game.included_modules.include?(Mongoid::Document)).to eq(true) }

  describe "Constants" do
    describe :VALID_SYMBOLS do
      it { expect(Player.const_defined?(:VALID_SYMBOLS)).to eq(true) }
      it { expect(Player::VALID_SYMBOLS).to eq(%w(X O)) }
    end
  end

  describe "Validations" do
    context 'valid attributes' do
      it { expect(instance).to be_valid }
    end

    describe :name do
      context 'invalid attributes' do
        let(:attributes) { { symbol: Player::VALID_SYMBOLS.sample } }

        it "should validate presence" do
          expect(instance).to_not be_valid
          expect(instance.errors[:name]).to include("can't be blank")
        end
      end
    end
 
    describe :symbol do
      context 'invalid attributes' do
        let(:attributes) { { symbol: nil } }

        it "should validate symbol" do
          expect(instance).to_not be_valid
          expect(instance.errors[:symbol]).to include("is not included in the list")
        end
      end
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