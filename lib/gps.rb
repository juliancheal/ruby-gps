require 'rubyserial'
$:.unshift File.join(File.dirname(__FILE__))
module GPS
  class Serials

    def initialize(device, baud=4800)
  		@sp = Serial.new(device, baud)
  	end

    def parse_nmea
      while(@sentence = @sp.read(1024)) do
        nmea = Nmea.new
        sentance = nmea.parse_sentance(@sentence)
        return sentance
      end
    end

    def parse_raw
      while(@sentence = @sp.read(1024)) do
        nmea = Nmea.new
        sentance = nmea.parse_raw(@sentence)
        puts sentance
      end
    end
  end
end
