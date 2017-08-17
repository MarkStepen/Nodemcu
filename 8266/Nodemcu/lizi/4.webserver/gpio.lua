  SSID = "Mik"
  password = "12345678"
  pin = 4
  wifi.setmode(wifi.STATION)
  wifi.sta.config(SSID,password)
  print(wifi.sta.getip())
  
  gpio.mode(pin, gpio.OUTPUT)

  srv=net.createServer(net.TCP)
  srv:listen(80,function(conn)
       conn:on("receive", function(conn,payload)
           print(payload)

           local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP");
           if(method == nil)then
               _, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP");
           end
           local _GET = {}
           if (vars ~= nil)then
               for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                   _GET[k] = v
               end
           end

           -- HTML
           local buf = "";
           buf = buf.."<h1> Web Server</h1>";
           buf = buf.."<p>LIGHT 1 "
           buf = buf.."<a href=\"?pin=ON4\"><button>LED OFF</button></a>&nbsp;"
           buf = buf.."<a href=\"?pin=OFF4\"><button>LED ON</button></a></p>";

           if(_GET.pin == "ON4")then
                 gpio.write(pin, gpio.HIGH);
           elseif(_GET.pin == "OFF4")then
                 gpio.write(pin, gpio.LOW);
           end

           conn:send(buf);
           conn:close();
           collectgarbage();
       end)
   end)
