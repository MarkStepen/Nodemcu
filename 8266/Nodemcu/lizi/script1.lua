print(wifi.sta.getip())
--nil
wifi.setmode(wifi.STATION)
wifi.sta.config("Mik","12345678")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
     if wifi.sta.getip() == nil then
         print("Connecting...")
     else
         tmr.stop(1)
         print("Connected, IP is "..wifi.sta.getip())
     end
end)

uart.setup(0,9600,8,0,1,0)
  sv=net.createServer(net.TCP, 2880)
  global_c = nil
  sv:listen(8899, function(c)
    if global_c~=nil then
        global_c:close()
    end
    global_c=c
    c:on("receive",function(sck,pl) uart.write(0,pl) end)
  end)

uart.on("data",4, function(data)
    if global_c~=nil then
        global_c:send(data)
    end
    end, 0)
