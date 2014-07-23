require 'rubyserial'

@sp = Serial.new('/dev/tty.SLAB_USBtoUART', 4800)
# puts @sp.read(5)

while(@sentence = @sp.read(5)) do
  puts @sentence
end