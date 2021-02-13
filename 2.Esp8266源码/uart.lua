local ua_utils ={}

-- api
local api={}

api.key='SdLPuilrOC2nzwIR6'
api.city='Hangzhou'
api.language='en'
api.host='http://api.seniverse.com/v3/weather/now.json?'

-- connect with screen and send/get command
function ua_utils.run(ip)

uart.on("data","$",function(data)
--init connect with screen and return to main page 
if data == "init$" then
    uart.write(0,0x74,0x30,0x2E,0x74,0x78,0x74,0x3D,0x22,0xE5,0x88,0x9D,0xE5,0xA7,0x8B,0xE5,0x8C,0x96,0xE6,0x88,0x90,0xE5,0x8A,0x9F,0x22,0xff,0xff,0xff)
    uart.write(0,'tm0.en=0',0xff,0xff,0xff)
    tmr.delay(3000000)
    uart.write(0,'page main',0xff,0xff,0xff)
end

-- return project connect ip info 
if data == "ip$" then
    uart.write(0,'t1.txt="'..ip..'"',0xff,0xff,0xff)
    uart.write(0,'tm1.en=0',0xff,0xff,0xff)
end

-- return weather
if data == "weather$" then
    getW()
end

--

end,0)
end

-- get weather
function getW()
local url=api.host..'key='..api.key..'&location='..api.city
http.get(url, nil, function(code,data)
    if (code < 0) then
      print("HTTP request failed")
    else
      local res=sjson.decode(data)
      uart.write(0,'t1.txt="'..res.results[1].location.name..'"',0xff,0xff,0xff)
      uart.write(0,'t2.txt="'..res.results[1].now.text..'"',0xff,0xff,0xff)
      uart.write(0,'t3.txt="'..res.results[1].now.temperature..'"',0xff,0xff,0xff)
      uart.write(0,'t4.txt="'..res.results[1].last_update..'"',0xff,0xff,0xff)
    end
  end)
end


return ua_utils

