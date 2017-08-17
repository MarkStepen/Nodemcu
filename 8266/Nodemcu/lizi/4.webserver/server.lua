  SSID = "Mik"
  password = "12345678"

    print(wifi.sta.getip())
            --nil
            wifi.setmode(wifi.STATION)
            wifi.sta.config(SSID,password)
            wifi.sta.connect()
            tmr.alarm(1, 1000, 1, function()
                 if wifi.sta.getip() == nil then
                     print("Connecting...")
                 else
                     tmr.stop(1)
                     print("Connected, IP is "..wifi.sta.getip())
                 end
            end)         

srv=net.createServer(net.TCP)  
srv:listen(80,function(conn)  
  conn:on("receive",function(conn,payload)  
    print(payload)  
        local html = string.format("HTTP/1.0 200 OK\r\n"  
        .."Content-Type: text/html\r\n"  
        .."Connection: Close\r\n\r\n"  
        .."<h1> Hello, NodeMCU!!! </h1>")  
    conn:send(html)  
  end)  
  conn:on("sent",function(conn) conn:close() end)  
end)  