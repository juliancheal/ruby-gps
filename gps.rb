require './lib/gps'
require './lib/nmea'

gps = GPS::Serials.new('/dev/tty.SLAB_USBtoUART', 4800)

while true
  data =gps.parse_nmea
  lat = data[:latitude]
  lon = data[:longitude]

  puts "Lat: #{lat}, Lon: #{lon}" unless lat.nil? && lon.nil?
end
# puts gps.parse_raw
