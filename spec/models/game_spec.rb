require 'spec_helper'

describe Game, type: :model do
  it { expect(Game.included_modules).to include(Mongoid::Document) }
end
