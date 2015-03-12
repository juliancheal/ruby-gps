require 'rubyserial'

@sp = Serial.new('/dev/cu.SLAB_USBtoUART', 4800)
# puts @sp.read(5)

while(@sentence = @sp.read(1)) do
  puts @sentence
end