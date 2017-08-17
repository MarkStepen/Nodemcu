uart.setup(0,9600,8,0,1,0)
        sv=net.createServer(net.TCP, 2880)
        print("creat server")
        global_c = nil
        sv:listen(8080, function(c)
            if global_c~=nil then
                global_c:close()
            end
            global_c=c
            c:on("receive",function(sck,pl) node.input(pl) end)
        end)