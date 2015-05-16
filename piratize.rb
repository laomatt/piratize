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
      output.map! {|word| (word.split('').include?('.'))&&(word.split('').none?{|e| 'abcdefghijklmnopqrstuvwxyz'.split('').include?(e.downcase)}) ? float_helper(word.to_f) : word}

      #If it encounters a instance that includes the module Ship it should call #board! on it
      # output.map! { |word| word.is_a? Ship ? word.board! : word}
      output2=[]

      output.each do |word|
        if word.is_a? Ship
          begin
            word.board!
          rescue PartyRepelledError
            output2 << "new ShipWreck(new Pirate_Ship)"
          rescue NoTreasureError
            p "Ya! No treasure were found me 'earty!"
          end
        elsif word.class == Symbol
          raise WhatBeThisError.new("'Ere, what be a 'symbol'")
        else
            output2 << word
        end
      end

      # output.join(' ')
      output2.join(' ')

    end

    def process_speech(array, position=0)
      if array.class==Array
        puts translate(array[position])
        if array[position+1]!=nil
          process_speech(array, position+1)
        end

      elsif array.class==Hash
        key=array.keys[position]
        puts translate(array[key])
        if array[array.keys[position+1]]!=nil
          process_speech(array, position+1)
        end
      end
    end
  end


  class Pirate_Ship
    attr_accessor :sunk
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

  class ShipWreck
    attr_accessor :original_ship
    def initialize ship
      @original_ship = ship
      ship.sink!
    end
  end

  queen_anns_revenge=Pirate_Ship.new(34,67)
  jolly_roger=Pirate_Ship.new(3,900)

  ship = ShipWreck.new queen_anns_revenge

# queen_anns_revenge.process_speech([1,2,3])
# queen_anns_revenge.process_speech({a:1,b:2,c:3,d:3})

queen_anns_revenge.process_speech(["Hello, my name is Matt", "I live in San Francisco, at exactl 2.3 miles from the dogpatch area", "I am a web developer", "looking for a full time position", "where I can earn gold", "thank you for your time and consideration and your coins as well"])
queen_anns_revenge.process_speech({a:"Data science is great!",b:"I have a Bachelors in Math and Coin science",c:"Don't I sound like it?",d:"I would certanly treasure a chance to meet and interview for a junior dev position!"})

# p jolly_roger.is_a? Ship
# p ship.original_ship
# Ship::tran "hello, my name is matt"