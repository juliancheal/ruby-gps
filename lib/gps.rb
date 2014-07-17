require 'serialport'
$:.unshift File.join(File.dirname(__FILE__))
module GPS
  class Serial
    
    def initialize(device, baud=4800, bits=8, stop=1, parity=SerialPort::NONE)
  		@sp = SerialPort.new(device, baud, bits, stop, parity)
  	end
  
    def parse_nmea
      while(@sentence = @sp.gets) do
        nmea = Nmea.new
        sentance = nmea.parse_sentance(@sentence)
        return sentance
      end
    end
  
    def parse_raw
      while(@sentence = @sp.gets) do
        nmea = Nmea.new
        sentance = nmea.parse_raw(@sentence)
        puts sentance
      end
    end
  end
end