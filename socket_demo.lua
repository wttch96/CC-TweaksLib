-- 测试luasocket
local socket = require("socket")
local io = require("io")

local ip = "0.0.0.0"
local port = 18896

local client = socket.tcp()
client:settimeout(5)
local success, err = client:connect(ip, port)

if not success then
    print("连接失败:", err)
    return
end
print("连接成功！")

client:send("[CONVERT]王冲,200,30,100,100,0,0,0,0\n")

-- 写入临时 .nfp 文件
local f = io.open("/tmp/temp.nfp", "w")
while true do
    local chunk, err = client:receive(1024)
    if not chunk then break end
    f:write(chunk)
end
f:close()
client:close()

local monitor = peripheral.wrap("top")
-- 读取并显示
local image = paintutils.loadImage("/tmp/temp.nfp")
paintutils.drawImage(image, 1, 1, monitor)

client:close()
