logger=dofile("logger.lua")
config=dofile("config.lua")
ua_utils=dofile("uart.lua")
api=dofile("api.lua")
print('soft start ....')
-- init gpio
pin=4
ip=''
gpio.mode(pin,gpio.OUTPUT)
--init uart
uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
-- init wifi
wifi.setmode(wifi.STATIONAP)  
local station_cfg={}
station_cfg.ssid=config.wifiSsid
station_cfg.pwd=config.wifiPwd
wifi.sta.config(station_cfg) 
wifi.sta.connect() 
-- connect wifi 
local uTmr = tmr.create()
uTmr:register(1000, tmr.ALARM_AUTO, function (t)  
    flash(pin)
    if wifi.sta.getip() == nil then
        print("connecting...")
    else 
        t:unregister()
        ip=wifi.sta.getip()
        print("connected,Ip is :"..wifi.sta.getip())
        gpio.write(pin,1)
        --sync time
        api.syncSntp() 
        ua_utils.run(ip)
    end

end)
uTmr:start()



