wifi.setmode(wifi.STATIONAP)  
wifi.sta.config("101","88888888") 
wifi.sta.connect() 
tmr.alarm(2,1000,1,function()
    if wifi.sta.getip() == nil then
        print("connecting...")
    else tmr.stop(2)
        print("connected,Ip is "..wifi.sta.getip()) 
    end
end)


pin=4
gpio.mode(pin,gpio.OUTPUT)

srv=net.createServer(net.TCP,28800) 
srv:listen(8888,function(conn)   
    conn:on("receive",function(conn,payload) 
    
    if (payload >= "31") then  
        gpio.write(pin,gpio.LOW)  
        print(1)
    elseif (payload <="31") then  
        gpio.write(pin,gpio.HIGH)  
        print(0)
    else
        print(3) 
    end
        
    print(payload) 
    end)
end)
