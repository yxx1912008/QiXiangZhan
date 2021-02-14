--net api 
local api={}

api.key='SdLPuilrOC2nzwIR6'
api.city='Hangzhou'
api.language='en'
api.host='http://api.seniverse.com/v3/weather/now.json?'
api.sntp='203.107.6.88'
api.sim_time='%04d-%d-%d'
api.full_time='%04d/%02d/%02d %02d:%02d:%02d'



-- get weather
function api.getW()
local url=api.host..'key='..api.key..'&location='..api.city
http.get(url, nil, function(code,data)
    if (code < 0) then
      uart.write(0,'page main',0xff,0xff,0xff)
    else
      local res=sjson.decode(data)
      uart.write(0,'t1.txt="'..res.results[1].location.name..'"',0xff,0xff,0xff)
      uart.write(0,'t2.txt="'..res.results[1].now.text..'"',0xff,0xff,0xff)
      uart.write(0,'t3.txt="'..res.results[1].now.temperature..'"',0xff,0xff,0xff)
      uart.write(0,'t4.txt="'..res.results[1].last_update..'"',0xff,0xff,0xff)
    end
  end)
end




function api.syncSntp()
    sntp.sync(api.sntp)
end

-- get simple time example 2021-2-14
function api.getSimTime()
    sec,usec,rate=rtctime.get()
    time = rtctime.epoch2cal(sec+28800,usec,rate)
    print(string.format(api.sim_time, 
                        time["year"], 
                        time["mon"], 
                        time["day"], 
                        time["hour"] , 
                        time["min"], 
                        time["sec"]))
end

-- get fullTime
function api.getFullTime()
    sec,usec,rate=rtctime.get()
    time = rtctime.epoch2cal(sec+28800,usec,rate)
    return string.format(api.full_time,time["year"],time["mon"],time["day"],time["hour"], 
                        time["min"], 
                        time["sec"])
end



return api
