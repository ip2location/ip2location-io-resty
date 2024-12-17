local cjson = require("cjson")

ipgeolocation = {
  configuration = nil,
  source = "sdk-resty-iplio",
  format = "json",
  error_message = "IPGeolocation lookup error.",
}
ipgeolocation.__index = ipgeolocation

ipgeolocationresult = {
  ip = "",
  country_code = "",
  country_name = "",
  region_name = "",
  city_name = "",
  latitude = 0,
  longitude = 0,
  zip_code = "",
  time_zone = "",
  asn = "",
  as = "",
  isp = "",
  domain = "",
  net_speed = "",
  idd_code = "",
  area_code = "",
  weather_station_code = "",
  weather_station_name = "",
  mcc = "",
  mnc = "",
  mobile_brand = "",
  elevation = 0,
  usage_type = "",
  address_type = "",
  category = "",
  category_name = "",
  continent = nil,
  district = "",
  country = nil,
  region = nil,
  city = nil,
  time_zone_info = nil,
  geotargeting = nil,
  ads_category = "",
  ads_category_name = "",
  is_proxy = false,
  fraud_score = 0,
  proxy = nil,
}
ipgeolocationresult.__index = ipgeolocationresult

ipgeolocationerror = {
  error = nil,
}
ipgeolocationerror.__index = ipgeolocationerror

ipgeolocationparam = {
  format = "",
  source = "",
  source_version = "",
  key = "",
  ip = "",
}
ipgeolocationparam.__index = ipgeolocationparam

-- initialize the component with the configuration
function ipgeolocation:open(configuration)
  local x = {}
  setmetatable(x, ipgeolocation) -- make ipgeolocation handle lookup
  x.configuration = configuration
  return x
end

-- main query
function ipgeolocation:lookup(ipaddress, translatelang)
  local httpc = require("resty.http").new() -- as mentioned in GitHub https://github.com/ledgetech/lua-resty-http/issues/299

  local myhost = "api.ip2location.io"
  local x = {}
  setmetatable(x, ipgeolocationparam) -- make ipgeolocationparam handle lookup
  x.format = self.format
  x.source = self.source
  x.source_version = self.configuration.version
  x.key = self.configuration.api_key
  x.ip = ipaddress

  if translatelang ~= "" then
    x["lang"] = translatelang -- lang param only supported in Plus and Security plans
  end

  local jsonstr = ""
  local code = 0

  -- First establish a connection
  local ok, err, ssl_session = httpc:connect({
      scheme = "http",
      host = myhost,
      port = 80,
    })
  if not ok then
    ngx.log(ngx.ERR, "connection failed: ", err)
    return
  end

  local res, err = httpc:request({
      path = "/",
      query = x,
      headers = {
        ["Host"] = myhost,
      },
    })
  if not res then
    ngx.log(ngx.ERR, "request failed: ", err)
    return
  end

  -- At this point, the status and headers will be available to use in the `res`
  -- table, but the body and any trailers will still be on the wire.

  -- We can use the `body_reader` iterator, to stream the body according to our
  -- desired buffer size.
  local reader = res.body_reader
  local buffer_size = 8192
  code = res.status

  repeat
    local buffer, err = reader(buffer_size)
    if err then
      ngx.log(ngx.ERR, err)
      break
    end

    if buffer then
      jsonstr = jsonstr .. buffer
    end
  until not buffer

  local trailer = res:read_trailers()

  if trailer then
    jsonstr = jsonstr .. trailer
  end

  local ok, err = httpc:set_keepalive()
  if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
  end

  if code == 200 then
    local result = cjson.decode(jsonstr)
    setmetatable(result, ipgeolocationresult)
    return result
  elseif code == 400 or code == 401 then
    local result = cjson.decode(jsonstr)
    setmetatable(result, ipgeolocationerror)
    if result["error"] ~= nil then
      error(result.error.error_message)
    end
  end
  error(self.error_message)
end

return ipgeolocation
