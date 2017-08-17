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
  pin = 4
  gpio.mode(pin, gpio.OUTPUT)

  srv=net.createServer(net.TCP,30)
  srv:listen(80,function(conn)
      conn:on("receive", function(conn,payload)
          print(payload)
          local _, _, method, vars = string.find(payload, "([A-Z]+) /(.+) HTTP");
          print(method,vars);
          local filename = nil

          if     (vars == nil) then filename = "Home.html"  
          elseif (vars ~= nil) then
              local _, _, key, value = string.find(vars,".*?(%w+)=(%w+).*")    

              if (value ~= nil) then
                  if (value =="ON4") then gpio.write(pin, gpio.HIGH);
                  elseif (value =="OFF4") then gpio.write(pin, gpio.LOW);
                  end

                  filename = "LED.html"  

              elseif (value == nil) then filename = vars
              end
          end    

          print(filename)
          file.open(filename,"r")
          local length = file.seek("end")
          file.seek("set")

          local function send ()         
              if (file.seek("cur") == length ) then
                  conn:close()
                  file.close()
                  print(filename.." has been sent.")
              else
                  local buf2 = file.read(1024)
                  conn:send(buf2)
                  print(file.seek("cur"))
              end
          end         

          send()
          conn:on("sent", send)   

     end)
  end)

  print(wifi.sta.getip())
