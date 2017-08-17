    SSID = "Mik"
    password = "12345678"

    pin = 4
    gpio.mode(pin, gpio.OUTPUT)
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

    file.open("print.txt","w+")
    file.write('Command:')
    file.close()

    srv=net.createServer(net.TCP,30)
    srv:listen(80,function(conn)
    -- save node.output to print.txt
       function s_output(str)
          if(conn~=nil) then
               file.open("print.txt","a+")
               file.write(str)
           file.close()
           end
       end
       node.output(s_output, 1)

       conn:on("receive", function(conn,payload)
       -- parse Header
            local _, _, vars = string.find(payload, "[A-Z]+ /(.+) HTTP");
            local _, _, method = string.find(payload, "([A-Z]+) /.* HTTP");
            local filename = nil

           if (method =="GET") then
               if     (vars == nil) then filename = "form2.html"
               elseif (vars ~= nil) then filename = vars
               end
           elseif (method =="POST") then
               local _, _, comments =
               string.find(payload,"comments=(.*)")

               local symbol = {
                   ['%2B'] = '+',
                   ['%2F'] = '/',
                   ['%28'] = '(',
                   ['%29'] = ')',
                   ['%22'] = '"',
                   ['%27'] = "'",
                   ['%2C'] = ","
               }
              -- replace symbol in comments
               if (comments ~= nil)then
                   for sym1,sym2 in pairs(symbol) do
                        com_sub,n = string.gsub(comments,'%'..sym1,sym2)
                        if n~=0 then comments = com_sub end
                    end

           -- execute comments
                    print(comments)
                    node.input(comments)
               end

           -- redirect
               filename = "form2.html"
           end

       -- send file
           local pos = 0;
           local function send ()
               file.open(filename,"r")
               if (file.seek("set",pos) == nil ) then
                   conn:close()
                   collectgarbage()
               else
                   local buf2 = file.read(1024)
                   conn:send(buf2)
                   pos = pos +1024
               end
               file.close()
           -- initialize print.txt
               if (filename == "print.txt") then
                   file.open("print.txt","w+")
                   file.write('Command:')
                   file.close()
               end
           end

           conn:on("sent", send)
           send()

       end )
    end )
