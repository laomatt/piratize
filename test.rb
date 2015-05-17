require_relative 'piratize'

queen_anns_revenge=Piratize.new(34,67)
jolly_roger=Piratize.new(3,0)
# ship = ShipWreck.new queen_anns_revenge

describe "Strings should be translated to pirish" do
  it "works with sentences" do
    expect(queen_anns_revenge.translate("my name is matt")).to eq "me name be matt"
  end
  it "works with words" do
    expect(queen_anns_revenge.translate("my")).to eq "me"
    expect(queen_anns_revenge.translate("the")).to eq "tha"
    expect(queen_anns_revenge.translate("looking")).to eq "lookin'"
  end
  it 'should remove any instances of Strings: "gold", "treasure", "coin", "coins"' do
    expect(queen_anns_revenge.translate("my gold")).to eq "me "
    expect(queen_anns_revenge.translate("the treasure")).to eq "tha "
    expect(queen_anns_revenge.translate("my Coin")).to eq "me "
  end

  it 'floats should be converted to the nearest rational where 8 is the denominator, eg 2.5 becomes 20/8 and 0.3 becomes 2/8' do
    expect(queen_anns_revenge.translate("2.3 miles")).to eq "18 /8 miles"
    expect(queen_anns_revenge.translate("2.5 kilometers")).to eq "20 /8 kilometers"
    expect(queen_anns_revenge.translate(".3")).to eq "2 /8"
  end

  it 'encounters a instance that includes the module Ship it should call #board! on it' do
    # queen_anns_revenge.process(jolly_roger).should_receive("Ya! No treasure were found me 'earty!").with(nil)
  end

  it 'If #board! raises PartyRepelledError it should replace the instance with a new instance of ShipWreck' do
    montley_crue=BoardingParty.new(42)
    no_crue=BoardingParty.new(12)
    expect(queen_anns_revenge.process(jolly_roger).class).to eq ShipWreck
  end

  it 'If #board! raises NoTreasureError it should print "Ya! No treasure were found me earty!" and continue' do
    # expect { queen_anns_revenge.process(jolly_roger) }.to raise_error()
  end

  it 'Symbols should raise WhatBeThisError with the message Ere, what be a symbol' do
    expect { queen_anns_revenge.process(:tortuga) }.to raise_error(WhatBeThisError)
  end



end