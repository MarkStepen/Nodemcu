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