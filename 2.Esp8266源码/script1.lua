logger=dofile("logger.lua")
local config=dofile("config.lua")
print('soft start ....')
-- init gpio
pin=4
ip=''
gpio.mode(pin,gpio.OUTPUT)
--init uart
uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
-- init wifi
wifi.setmode(wifi.STATIONAP)  
wifi.sta.config(config.wifiSsid,config.wifiPwd) 
wifi.sta.connect() 
-- connect wifi 
tmr.alarm(1,1000,1,function()
    flash(pin)
    if wifi.sta.getip() == nil then
        print("connecting...")
    else tmr.stop(1)
        ip=wifi.sta.getip()
        print("connected,Ip is :"..ip)
        gpio.write(pin,1) 
    end
end)

print(ip)
