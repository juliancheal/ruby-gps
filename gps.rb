require './lib/gps'
require './lib/nmea'

gps = GPS::Serial.new("/dev/tty.SLAB_USBtoUART", 4800, 8, 1, SerialPort::NONE)

while true
  data =gps.parse_nmea
  lat = data[:latitude]
  lon = data[:longitude]
  
  puts "Lat: #{lat}, Lon: #{lon}" unless lat.nil? && lon.nil?
end
# puts gps.parse_raw