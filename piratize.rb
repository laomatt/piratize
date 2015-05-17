require 'talk_like_a_pirate'
class PartyRepelledError < StandardError ; end
class NoTreasureError < StandardError ; end
class WhatBeThisError < StandardError ; end

module Ship
  def float_helper(num)
    "#{(num*8).to_i} /8"
  end

  def translate(string)
    phrase = TalkLikeAPirate.translate(string)
      #first we remove all the instances of gold, treasure, coins and coin
      output = phrase.split(' ').map {|word| ['gold', 'treasure', 'coins', 'coin'].include?(word.downcase) ? '' : word}

      #then we account for the floats
      output.map! {|word| word.scan(/\d*\.\d*/).length>0 ? float_helper(word.scan(/\d*\.\d*/).first.to_f) : word}.join(' ')

    end

    def process(array, position=0, boarders=BoardingParty.new(0))
      if array.class==Array
        puts translate(array[position])
        if array[position+1]!=nil
          process(array, position+1)
        end

      elsif array.class==Hash
        key=array.keys[position]
        puts translate(array[key])
        if array[array.keys[position+1]]!=nil
          process(array, position+1)
        end

      elsif array.is_a? Ship
        begin
          array.board! boarders
        rescue PartyRepelledError
          ShipWreck.new(Piratize.new(0,0))
        rescue NoTreasureError
          puts "Ya! No treasure were found me 'earty!"
        else
          puts "we boarded and looted!"
        end

      elsif array.class == Symbol
        raise WhatBeThisError.new("'Ere, what be a 'symbol'")
      else
        puts translate(array)
      end
  end
end



class BoardingParty
attr_accessor :size
  def initialize(size)
    @size = size
  end
end

class ShipWreck
  attr_accessor :original_ship
  def initialize ship
    @original_ship = ship
    ship.sink!
  end
end


class Piratize
  attr_accessor :sunk, :size
  include Ship
  def initialize size, treasure
    @size = size
    @treasure = treasure
    @sunk = false
  end

  def sink!
    @sunk=true
  end

  def board! boarding_party
    raise "boarding party must be an instance of BoardingParty" unless boarding_party.is_a?(BoardingParty)
    if boarding_party.size <= @size
      raise PartyRepelledError.new
    end

    if @treasure == 0
      raise NoTreasureError.new
    end

    @treasure = 0

  end
end

queen_anns_revenge=Piratize.new(34,67)
jolly_roger=Piratize.new(3,0)
no_crue=BoardingParty.new(12)
montley_crue=BoardingParty.new(42)
ship = ShipWreck.new queen_anns_revenge



queen_anns_revenge.process(["Hello, my name is Matt", "I live in San Francisco, at exactl 2.3 miles from the dogpatch area", "I am a web developer", "looking for a full time position", "where I can earn gold", "thank you for your time and consideration and your coins as well"])
queen_anns_revenge.process({a:"Data science is great!",b:"I have a Bachelors in Math and Coin science",c:"Don't I sound like it?",d:"I would certanly treasure a chance to meet and interview for a junior dev position!"})
# queen_anns_revenge.process("my name is matt")
p queen_anns_revenge.process(jolly_roger, montley_crue)
p montley_crue.size
p jolly_roger.size
# queen_anns_revenge.process(queen_anns_revenge)
# queen_anns_revenge.process(:tortuga)
# p jolly_roger.is_a? Ship
# p ship.original_ship
# Ship::tran "hello, my name is matt"


