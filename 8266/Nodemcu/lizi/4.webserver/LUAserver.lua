-- LUA Webserver --        
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
                print("Heap = "..node.heap().." Bytes")
                print("Print payload:\n"..payload)

                -- write HTML
                head =   "<html><head><title>ESP8266 Webserver</title></head>"
                body =   "<body><h1>Welcome to Nodemcu</h1>"
                para =   "<p>The size of the memory available: "..tostring(node.heap()).." Bytes </p>"
                ending = "</body></html>"

                reply1 = head..body
                reply2 = para..ending
                payloadLen = string.len(reply1)
                payloadLen = string.len(reply2)

                conn:send("HTTP/1.1 200 OK\r\n")
                conn:send("Content-Length:" .. tostring(payloadLen) .. "\r\n")
                conn:send("Connection:close\r\n\r\n")
                conn:send(reply1)
                conn:send(reply2)

                collectgarbage()
            end)

             conn:on("sent",function(conn)
                conn:close()
            end)

        end)
