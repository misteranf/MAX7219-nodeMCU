--Usage example for max7219 nodemcu module
max = require("max7219")
max.setup()
max.clear_digits()            --clear the buffer
tmr.delay(2500000)
max.print_string("23.01 -25") --print various symbols
tmr.delay(2500000)
max.test_on()                 -- test pattern on
tmr.delay(2500000)
max.test_off()                -- test pattern off
tmr.delay(2000000)
max.display_off()             -- display off, buffer still intact
tmr.delay(2000000) 
max.clear_digits()            -- clear buffer again
max.set_bright(0)
max.print_string("80085 1.")  -- print more greetings
tmr.delay(2000000)              
max.set_bright(10)            --change brightness
tmr.delay(25000)
max.set_bright(0)             --several times to draw attention
tmr.delay(200000)
max.set_bright(10)
tmr.delay(25000)
max.set_bright(0)

-- Disclaimer: using tmr.delay() like this will ruin WIFI functionality and probably cause reboots!
-- Please don't do it  on real applications