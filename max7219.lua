-- This module is designed to control 8 digit 7segdisplay
-- Inspired by http://frightanic.com/iot/nodemcu-max7219-8x8-led-matrix-display/
-- based on MAX7219 It has basic set of regisers defined below
-- written by Antons M, usping parts from http://frightanic.com/iot/nodemcu-max7219-8x8-led-matrix-display/
-- License: http://www.wtfpl.net/

local moduleName = ... 
local M = {}
_G[moduleName] = M

MAX7219_REG_NOOP        = 0x00 -- "do nothing" for daisychaining purposes
MAX7219_REG_DECODEMODE  = 0x09 -- 0x00 for no-decode mode, 0xFF - decode everything. (See datasheet if confused)
MAX7219_REG_INTENSITY   = 0x0A -- 0 for min; 0x0F (decimal 15) for max and anything in between
MAX7219_REG_SCANLIMIT   = 0x0B -- defines how many digits to multiplex (0x00 - only 0th digit, 0x03 Display 0,1,2,3; and 0x07 - all 8digits) )
MAX7219_REG_SHUTDOWN    = 0x0C -- 0 for all segments off; 1 for normal operation
MAX7219_REG_DISPLAYTEST = 0x0F -- 1 for test mode (all sefments @ full brightness); 0 for normal operation
local init = false
local function sendByte(reg, data) --sends a byte. copied from http://frightanic.com/iot/nodemcu-max7219-8x8-led-matrix-display/
 -- print(reg .." - ".. data)
  spi.send(1,reg * 256 + data)
  tmr.delay(50)
end
local function string_to_display(string) 
-- Displays a string, from left to right. Num, spaces, dashes and decimal point alloved only.
-- decimal point  will be rendered as a part of a preceding digit. 
--If 8.5 inputed, dot will be printed as a part of digit 8
    local a = 8   
    for i = 1, #string do
        local c = string:sub(i,i)
        if c == " " then c = 15 end  --parse "space"
        if c == "-" then c = 10 end  --parse "-"
        if c == "." then a=a+1 c = string:sub(i-1,i-1) + 240 end --write decimal point to previous digit
        sendByte(a, c)
        a=a-1
    end
    sendByte (MAX7219_REG_SHUTDOWN, 1)
end --string_to_display()
function M.setup()
    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 16, 8)

    sendByte (MAX7219_REG_SHUTDOWN, 0)
    sendByte (MAX7219_REG_SCANLIMIT, 7)
    sendByte (MAX7219_REG_DECODEMODE, 0xFF)
    sendByte (MAX7219_REG_DISPLAYTEST, 0)
    sendByte (MAX7219_REG_INTENSITY, 9)
   
    M.clear_digits()
    tmr.stop(0)
    init = true
end
function M.print_string(string)
if (not init) then
        print("setup() must be called before read.")
    else
        string_to_display(string)
    end
end --M.print_string
function M.clear_digits() -- clears all digit regisers to blank
     local a = 0
    while a < 8 do
          sendByte(a+1, 15)
          a = a + 1
          tmr.delay(50)
        
    end --while a  
end
function M.test_on() -- puts MAX7219 into test mode, register values are preserved
    sendByte(MAX7219_REG_DISPLAYTEST, 1)
end --M.test_on
function M.test_off() --Exits test mode
    sendByte(MAX7219_REG_DISPLAYTEST, 0)
end --M.test_off
function M.set_bright(string)-- 0 for min; 0x0F (decimal 15) for max and anything in between
    sendByte (MAX7219_REG_INTENSITY, string)
end --M.set_bright
function M.display_on() -- Turns display on
    sendByte (MAX7219_REG_SHUTDOWN, 1)
end
function M.display_off() -- Turns display off, register values stay intact
    sendByte (MAX7219_REG_SHUTDOWN, 0)
end
--setup()

return M
--string_to_display("12.3.4-56.7") -- a simple functionality test
