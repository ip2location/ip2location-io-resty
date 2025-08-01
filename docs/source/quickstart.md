# Quickstart

## Dependencies

This module requires API key to function. You may sign up for a free API key at <https://www.ip2location.io/pricing>.

## Installation

```bash

opm get ip2location/ip2location-io-resty

```

## Sample Codes

### Lookup IP Address Geolocation Data
```lua
worker_processes  1;
error_log logs/error.log;
events {
    worker_connections 1024;
}
http {
    resolver 8.8.8.8 ipv6=off;
    server {
        listen 8080 reuseport;
        location / {
            default_type text/html;
            content_by_lua_block {
                local cjson = require("cjson")
                local configuration = require("configuration")
                local ipgeolocation = require("ipgeolocation")

                local apikey = "YOUR_API_KEY"

                local lang = "fr" -- leave as blank if not needed

                configuration.api_key = apikey
                local ip = "8.8.8.8"
                local ipl = ipgeolocation:open(configuration)

                local result = ipl:lookup(ip, lang)

                ngx.say("version: " .. configuration.version)
                ngx.say("ip: " .. result.ip)
                ngx.say("country_code: " .. result.country_code)
                ngx.say("country_name: " .. result.country_name)
                ngx.say("region_name: " .. result.region_name)
                ngx.say("city_name: " .. result.city_name)
                ngx.say("latitude: " .. result.latitude)
                ngx.say("longitude: " .. result.longitude)
                ngx.say("zip_code: " .. result.zip_code)
                ngx.say("time_zone: " .. result.time_zone)
                ngx.say("asn: " .. result.asn)
                ngx.say("as: " .. result.as)
                ngx.say("isp: " .. result.isp)
                ngx.say("domain: " .. result.domain)
                ngx.say("net_speed: " .. result.net_speed)
                ngx.say("idd_code: " .. result.idd_code)
                ngx.say("area_code: " .. result.area_code)
                ngx.say("weather_station_code: " .. result.weather_station_code)
                ngx.say("weather_station_name: " .. result.weather_station_name)
                ngx.say("mcc: " .. result.mcc)
                ngx.say("mnc: " .. result.mnc)
                ngx.say("mobile_brand: " .. result.mobile_brand)
                ngx.say("elevation: " .. result.elevation)
                ngx.say("usage_type: " .. result.usage_type)
                ngx.say("address_type: " .. result.address_type)
                ngx.say("category: " .. result.category)
                ngx.say("category_name: " .. result.category_name)
                ngx.say("district: " .. result.district)
                ngx.say("ads_category: " .. result.ads_category)
                ngx.say("ads_category_name: " .. result.ads_category_name)
                ngx.say("is_proxy: " .. tostring(result.is_proxy))
                ngx.say("fraud_score: " .. result.fraud_score)

                -- continent addon
                if result["continent"] ~= nil then
                  ngx.say("continent => name: " .. result.continent.name)
                  ngx.say("continent => code: " .. result.continent.code)
                  ngx.say("continent => hemisphere: " .. table.concat(result.continent.hemisphere, ","))
                  if lang ~= "" and result.continent.translation.lang ~= cjson.null then
                    ngx.say("continent => translation => lang: " .. result.continent.translation.lang)
                    ngx.say("continent => translation => value: " .. result.continent.translation.value)
                  end
                end

                -- country addon
                if result["country"] ~= nil then
                  ngx.say("country => name: " .. result.country.name)
                  ngx.say("country => alpha3_code: " .. result.country.alpha3_code)
                  ngx.say("country => numeric_code: " .. result.country.numeric_code)
                  ngx.say("country => demonym: " .. result.country.demonym)
                  ngx.say("country => flag: " .. result.country.flag)
                  ngx.say("country => capital: " .. result.country.capital)
                  ngx.say("country => total_area: " .. result.country.total_area)
                  ngx.say("country => population: " .. result.country.population)
                  ngx.say("country => tld: " .. result.country.tld)

                  ngx.say("country => currency => code: " .. result.country.currency.code)
                  ngx.say("country => currency => name: " .. result.country.currency.name)
                  ngx.say("country => currency => symbol: " .. result.country.currency.symbol)

                  ngx.say("country => language => code: " .. result.country.language.code)
                  ngx.say("country => language => name: " .. result.country.language.name)

                  if lang ~= "" and result.country.translation.lang ~= cjson.null then
                    ngx.say("country => translation => lang: " .. result.country.translation.lang)
                    ngx.say("country => translation => value: " .. result.country.translation.value)
                  end
                end

                -- region addon
                if result["region"] ~= nil then
                  ngx.say("region => name: " .. result.region.name)
                  ngx.say("region => code: " .. result.region.code)
                  if lang ~= "" and result.region.translation.lang ~= cjson.null then
                    ngx.say("region => translation => lang: " .. result.region.translation.lang)
                    ngx.say("region => translation => value: " .. result.region.translation.value)
                  end
                end

                -- city addon
                if result["city"] ~= nil then
                  ngx.say("city => name: " .. result.city.name)
                  if lang ~= "" and result.city.translation.lang ~= cjson.null then
                    ngx.say("city => translations => lang: " .. result.city.translation.lang)
                    ngx.say("city => translations => value: " .. result.city.translation.value)
                  end
                end

                -- time_zone_info addon
                if result["time_zone_info"] ~= nil then
                  ngx.say("time_zone_info => olson: " .. result.time_zone_info.olson)
                  ngx.say("time_zone_info => current_time: " .. result.time_zone_info.current_time)
                  ngx.say("time_zone_info => gmt_offset: " .. result.time_zone_info.gmt_offset)
                  ngx.say("time_zone_info => is_dst: " .. tostring(result.time_zone_info.is_dst))
                  ngx.say("time_zone_info => sunrise: " .. result.time_zone_info.sunrise)
                  ngx.say("time_zone_info => sunset: " .. result.time_zone_info.sunset)
                end

                -- geotargeting addon
                if result["geotargeting"] ~= nil then
                  ngx.say("geotargeting => metro: " .. result.geotargeting.metro)
                end

                -- proxy addon
                if result["proxy"] ~= nil then
                  ngx.say("proxy => last_seen: " .. result.proxy.last_seen)
                  ngx.say("proxy => proxy_type: " .. result.proxy.proxy_type)
                  ngx.say("proxy => threat: " .. result.proxy.threat)
                  ngx.say("proxy => provider: " .. result.proxy.provider)
                  ngx.say("proxy => is_vpn: " .. tostring(result.proxy.is_vpn))
                  ngx.say("proxy => is_tor: " .. tostring(result.proxy.is_tor))
                  ngx.say("proxy => is_data_center: " .. tostring(result.proxy.is_data_center))
                  ngx.say("proxy => is_public_proxy: " .. tostring(result.proxy.is_public_proxy))
                  ngx.say("proxy => is_web_proxy: " .. tostring(result.proxy.is_web_proxy))
                  ngx.say("proxy => is_web_crawler: " .. tostring(result.proxy.is_web_crawler))
                  ngx.say("proxy => is_residential_proxy: " .. tostring(result.proxy.is_residential_proxy))
                  ngx.say("proxy => is_consumer_privacy_network: " .. tostring(result.proxy.is_consumer_privacy_network))
                  ngx.say("proxy => is_enterprise_private_network: " .. tostring(result.proxy.is_enterprise_private_network))
                  ngx.say("proxy => is_spammer: " .. tostring(result.proxy.is_spammer))
                  ngx.say("proxy => is_scanner: " .. tostring(result.proxy.is_scanner))
                  ngx.say("proxy => is_botnet: " .. tostring(result.proxy.is_botnet))
                end
            }
        }
    }
}
```
