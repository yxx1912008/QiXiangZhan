local ua_utils ={}

-- connect with screen and send/get command
function ua_utils.run(ip)

uart.on("data","$",function(data)
--init connect with screen and return to main page 
if data == "init$" then
    local tm=api.getFullTime()
    uart.write(0,'tm0.en=0',0xff,0xff,0xff)
    uart.write(0,'page inok',0xff,0xff,0xff)      
    uart.write(0,'t4.txt="'..tm..'"',0xff,0xff,0xff)
end

-- return project connect ip info 
if data == "ip$" then
    uart.write(0,'t1.txt="'..ip..'"',0xff,0xff,0xff)
    uart.write(0,'tm1.en=0',0xff,0xff,0xff)
end

-- return weather
if data == "weather$" then
    api.getW()
end

--

end,0)
end




return ua_utils

