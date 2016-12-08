require 'spec_helper'

describe Game, type: :model do
  it { expect(Game.included_modules.include?(Mongoid::Document)).to eq(true) }
end
