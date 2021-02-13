--net api 
local api={}

api.key='SdLPuilrOC2nzwIR6'
api.city='Hangzhou'
api.language='en'
api.host='http://api.seniverse.com/v3/weather/now.json?'
-- json result:200    {"results":[{"location":{"id":"WTMKQ069CCJ7","name":"Hangzhou","country":"CN","path":"Hangzhou,Hangzhou,Zhejiang,China","timezone":"Asia/Shanghai","timezone_offset":"+08:00"},"now":{"text":"Cloudy","code":"4","temperature":"12"},"last_update":"2021-02-13T21:40:00+08:00"}]}

-- get weather
function getW()
local url=api.host..'key='..api.key..'&location='..api.city
print('start api')
http.get(url, nil, function(code,data)
    if (code < 0) then
      print("HTTP request failed")
    else
      local res=sjson.decode(data)
      print(res.results[1].location.name)
      --uart.write(0,'t0.txt="'..res.results[1].location.name..'"',0xff,0xff,0xff)
    end
  end)
end

return api
