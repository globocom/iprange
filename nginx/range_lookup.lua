local redis = require "redis"
local cjson = require "cjson"

local function ip_to_i(ip)
  local o1,o2,o3,o4 = ip:match("(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)")
  return 2^24*o1 + 2^16*o2 + 2^8*o3 + o4
end

local function range_lookup(ip)
  local red = redis:new()
  red:set_timeout(1000)
  local ok, err = red:connect("127.0.0.1", 6379)
  if not ok then
    return nil, "failed to connect: " .. err
  end

  if not ip or ip == "" then
    return nil, "no ip provided"
  end

  local res, err = red:istab("ip_table", ip_to_i(ip))
  if not res then
    return nil, "failed to get range: " .. err
  end

  if not res[1] then
    return nil, "range not found"
  end

  local range = res[1]
  local metadata, err = red:hgetall("ip_table:" .. range)

  if err then
    return nil, "no metadata"
  end

  local response = {}
  for i = 1, #metadata, 2 do
    local key = metadata[i]
    local value = metadata[i + 1]
    response[key] = value
  end
  response.range = range
  return response, nil
end

local response, err = range_lookup(ngx.var.ip)
if err then
  ngx.say(cjson.encode({status="error", msg=err}))
else
  ngx.say(cjson.encode({status="ok", data=response}))
end
