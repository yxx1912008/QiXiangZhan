--net api 
local api={}

api.sntp='203.107.6.88'
api.full_time='%04d/%02d/%02d %02d:%02d:%02d'

-- url
api.wurl='http://api.seniverse.com/v3/weather/now.json?key=SdLPuilrOC2nzwIR6&location=Hangzhou'
api.ow='http://v1.alapi.cn/api/hitokoto'
api.wnurl='http://v2.alapi.cn/api/lunar?token=9CeTvaTVnUatKEph'
api.zhurl='http://v1.alapi.cn/api/zhihu/latest'

-- get weather
function api.getW()
http.get(api.wurl, nil, function(code,data)
    if (code < 0) then
      uart.write(0,'page main',0xff,0xff,0xff)
    else
      local res=sjson.decode(data)
      uart.write(0,'t1.txt="'..res.results[1].location.name..'"',0xff,0xff,0xff)
      uart.write(0,'t2.txt="'..res.results[1].now.text..'"',0xff,0xff,0xff)
      uart.write(0,'t3.txt="'..res.results[1].now.temperature..'"',0xff,0xff,0xff)
      uart.write(0,'t4.txt="'..res.results[1].last_update..'"',0xff,0xff,0xff)
      res=nil
      data=nil
    end
  end)
end

-- syng time
function api.syncSntp()
    sntp.sync(api.sntp)
end

-- get fullTime
function api.getFullTime()
    local sec,usec,rate=rtctime.get()
    local time = rtctime.epoch2cal(sec+28800,usec,rate)
    return string.format(api.full_time,time["year"],time["mon"],time["day"],time["hour"], 
                        time["min"], 
                        time["sec"])
end



-- get one word
function api.getOneWd()
http.get(api.ow, nil, function(code,data)
    if (code < 0) then
      uart.write(0,'page main',0xff,0xff,0xff)
    else
      local res=sjson.decode(data)
      uart.write(0,'t0.txt="'..res.data.hitokoto..'"',0xff,0xff,0xff)
      uart.write(0,'t2.txt="'..res.data.from..'"',0xff,0xff,0xff)
      res=nil
      data=nil
    end
  end)
end



-- get wan nian li
function api.wnl()
http.get(api.wnurl, nil, function(code,data)
    if (code < 0) then
      uart.write(0,'page main',0xff,0xff,0xff)
    else
      local res=sjson.decode(data,{null=''})
      uart.write(0,'t5.txt="'..res.data.gregorian_year..'"',0xff,0xff,0xff)
      uart.write(0,'t10.txt="'..res.data.gregorian_month..'"',0xff,0xff,0xff)
      uart.write(0,'t11.txt="'..res.data.gregorian_day..'"',0xff,0xff,0xff)
      uart.write(0,'t6.txt="'..res.data.ganzhi_year..'"',0xff,0xff,0xff)
      uart.write(0,'t12.txt="'..res.data.ganzhi_month..'"',0xff,0xff,0xff)
      uart.write(0,'t13.txt="'..res.data.ganzhi_day..'"',0xff,0xff,0xff)
      uart.write(0,'t14.txt="'..res.data.ganzhi_hour..'"',0xff,0xff,0xff)
      local term=' '
      if not ( res.data.term=='' or res.data.term==nil or res.data.term=='null') then 
        term=res.data.term
      end
      uart.write(0,'t7.txt="'..term..'"',0xff,0xff,0xff)
      uart.write(0,'t8.txt="'..res.data.animal..'"',0xff,0xff,0xff)
      uart.write(0,'t9.txt="'..res.data.week_name..'"',0xff,0xff,0xff)
      res=nil
      data=nil
      collectgarbage("collect")
    end
  end)
end


-- get zhihu
function api.zh()
http.get(api.zhurl, nil, function(code,data)
    if (code < 0) then
      uart.write(0,'page main',0xff,0xff,0xff)
    else
      local res=sjson.decode(data,{null=''})
      uart.write(0,'g0.txt="'..res.data.stories[1].title..'"',0xff,0xff,0xff)
      uart.write(0,'zh1.txt="'..res.data.stories[1].url..'"',0xff,0xff,0xff)
      
      uart.write(0,'g1.txt="'..res.data.stories[2].title..'"',0xff,0xff,0xff)
      uart.write(0,'zh2.txt="'..res.data.stories[2].url..'"',0xff,0xff,0xff)
      
      uart.write(0,'g2.txt="'..res.data.stories[3].title..'"',0xff,0xff,0xff)
      uart.write(0,'zh3.txt="'..res.data.stories[3].url..'"',0xff,0xff,0xff)

      uart.write(0,'g3.txt="'..res.data.stories[4].title..'"',0xff,0xff,0xff)
      uart.write(0,'zh4.txt="'..res.data.stories[4].url..'"',0xff,0xff,0xff)

      uart.write(0,'g4.txt="'..res.data.stories[5].title..'"',0xff,0xff,0xff)
      uart.write(0,'zh5.txt="'..res.data.stories[5].url..'"',0xff,0xff,0xff)
      res=nil 
      data=nil
      collectgarbage("collect")            
    end
    
  end)
end

return api
