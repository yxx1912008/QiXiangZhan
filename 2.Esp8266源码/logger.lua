-- add a logger
local logger = {}
logger.path="log.txt"
function logger.info(info)
    file.open(logger.path,"a+")
    file.writeline(info)
    file.close()
end
return logger
