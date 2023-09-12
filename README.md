IP2Location.io OpenResty SDK
============================
This OpenResty package enables user to query for an enriched data set, such as country, region, district, city, latitude & longitude, ZIP code, time zone, ASN, ISP, domain, net speed, IDD code, area code, weather station data, MNC, MCC, mobile brand, elevation, usage type, address type, advertisement category and proxy data with an IP address. It supports both IPv4 and IPv6 address lookup.

This package requires API key to function. You may sign up for a free API key at https://www.ip2location.io/pricing.


Installation
============
```bash

opm get ip2location/ip2location-io-resty

```


Usage Example
============
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
                  ngx.say("proxy => is_spammer: " .. tostring(result.proxy.is_spammer))
                  ngx.say("proxy => is_scanner: " .. tostring(result.proxy.is_scanner))
                  ngx.say("proxy => is_botnet: " .. tostring(result.proxy.is_botnet))
                end
            }
        }
    }
}
```


Response Parameter
============
### IP Geolocation Lookup function
| Parameter | Type | Description |
|---|---|---|
|ip|string|IP address.|
|country_code|string|Two-character country code based on ISO 3166.|
|country_name|string|Country name based on ISO 3166.|
|region_name|string|Region or state name.|
|city_name|string|City name.|
|latitude|double|City latitude. Defaults to capital city latitude if city is unknown.|
|longitude|double|City longitude. Defaults to capital city longitude if city is unknown.|
|zip_code|string|ZIP/Postal code.|
|time_zone|string|UTC time zone (with DST supported).|
|asn|string|Autonomous system number (ASN).|
|as|string|Autonomous system (AS) name.|
|isp|string|Internet Service Provider or company's name.|
|domain|string|Internet domain name associated with IP address range.|
|net_speed|string|Internet connection type. DIAL = dial-up, DSL = broadband/cable/fiber/mobile, COMP = company/T1|
|idd_code|string|The IDD prefix to call the city from another country.|
|area_code|string|A varying length number assigned to geographic areas for calls between cities.|
|weather_station_code|string|The special code to identify the nearest weather observation station.|
|weather_station_name|string|The name of the nearest weather observation station.|
|mcc|string|Mobile Country Codes (MCC) as defined in ITU E.212 for use in identifying mobile stations in wireless telephone networks, particularly GSM and UMTS networks.|
|mnc|string|Mobile Network Code (MNC) is used in combination with a Mobile Country Code (MCC) to uniquely identify a mobile phone operator or carrier.|
|mobile_brand|string|Commercial brand associated with the mobile carrier.|
|elevation|integer|Average height of city above sea level in meters (m).|
|usage_type|string|Usage type classification of ISP or company.|
|address_type|string|IP address types as defined in Internet Protocol version 4 (IPv4) and Internet Protocol version 6 (IPv6).|
|continent.name|string|Continent name.|
|continent.code|string|Two-character continent code.|
|continent.hemisphere|array|The hemisphere of where the country located. The data in array format with first item indicates (north/south) hemisphere and second item indicates (east/west) hemisphere information.|
|continent.translation|object|Translation data based on the given lang code.|
|district|string|District or county name.|
|country.name|string|Country name based on ISO 3166.|
|country.alpha3_code|string|Three-character country code based on ISO 3166.|
|country.numeric_code|string|Three-character country numeric code based on ISO 3166.|
|country.demonym|string|Native of the country.|
|country.flag|string|URL of the country flag image.|
|country.capital|string|Capital of the country.|
|country.total_area|integer|Total area in km2.|
|country.population|integer|Population of the country.|
|country.currency|object|Currency of the country.|
|country.language|object|Language of the country.|
|country.tld|string|Country-Code Top-Level Domain.|
|country.translation|object|Translation data based on the given lang code.|
|region.name|string|Region or state name.|
|region.code|string|ISO3166-2 code.|
|region.translation|object|Translation data based on the given lang code.|
|city.name|string| City name.|
|city.translation|object|Translation data based on the given lang code.|
|time_zone_info.olson|string|Time zone in Olson format.|
|time_zone_info.current_time|string|Current time in ISO 8601 format.|
|time_zone_info.gmt_offset|integer|GMT offset value in seconds.|
|time_zone_info.is_dst|boolean|Indicate if the time zone value is in DST.|
|time_zone_info.sunrise|string|Time of sunrise. (hh:mm format in local time, i.e, 07:47)|
|time_zone_info.sunset|string|Time of sunset. (hh:mm format in local time, i.e 19:50)|
|geotargeting.metro|string|Metro code based on zip/postal code.|
|ads_category|string|The domain category code based on IAB Tech Lab Content Taxonomy.|
|ads_category_name|string|The domain category based on IAB Tech Lab Content Taxonomy. These categories are comprised of Tier-1 and Tier-2 (if available) level categories widely used in services like advertising, Internet security and filtering appliances.|
|is_proxy|boolean|Whether is a proxy or not.|
|proxy.last_seen|integer|Proxy last seen in days.|
|proxy.proxy_type|string|Type of proxy.|
|proxy.threat|string|Security threat reported.|
|proxy.provider|string|Name of VPN provider if available.|
|proxy.is_vpn|boolean|Anonymizing VPN services.|
|proxy.is_tor|boolean|Tor Exit Nodes.|
|proxy.is_data_center|boolean|Hosting Provider, Data Center or Content Delivery Network.|
|proxy.is_public_proxy|boolean|Public Proxies.|
|proxy.is_web_proxy|boolean|Web Proxies.|
|proxy.is_web_crawler|boolean|Search Engine Robots.|
|proxy.is_residential_proxy|boolean|Residential proxies.|
|proxy.is_spammer|boolean|Email and forum spammers.|
|proxy.is_scanner|boolean|Network security scanners.|
|proxy.is_botnet|boolean|Malware infected devices.|

```json
{
  "ip": "8.8.8.8",
  "country_code": "US",
  "country_name": "United States of America",
  "region_name": "California",
  "city_name": "Mountain View",
  "latitude": 37.405992,
  "longitude": -122.078515,
  "zip_code": "94043",
  "time_zone": "-07:00",
  "asn": "15169",
  "as": "Google LLC",
  "isp": "Google LLC",
  "domain": "google.com",
  "net_speed": "T1",
  "idd_code": "1",
  "area_code": "650",
  "weather_station_code": "USCA0746",
  "weather_station_name": "Mountain View",
  "mcc": "-",
  "mnc": "-",
  "mobile_brand": "-",
  "elevation": 32,
  "usage_type": "DCH",
  "address_type": "Anycast",
  "continent": {
    "name": "North America",
    "code": "NA",
    "hemisphere": [
      "north",
      "west"
    ],
    "translation": {
      "lang": "es",
      "value": "Norteamérica"
    }
  },
  "district": "Santa Clara County",
  "country": {
    "name": "United States of America",
    "alpha3_code": "USA",
    "numeric_code": 840,
    "demonym": "Americans",
    "flag": "https://cdn.ip2location.io/assets/img/flags/us.png",
    "capital": "Washington, D.C.",
    "total_area": 9826675,
    "population": 331002651,
    "currency": {
      "code": "USD",
      "name": "United States Dollar",
      "symbol": "$"
    },
    "language": {
      "code": "EN",
      "name": "English"
    },
    "tld": "us",
    "translation": {
      "lang": "es",
      "value": "Estados Unidos de América (los)"
    }
  },
  "region": {
    "name": "California",
    "code": "US-CA",
    "translation": {
      "lang": "es",
      "value": "California"
    }
  },
  "city": {
    "name": "Mountain View",
    "translation": {
      "lang": null,
      "value": null
    }
  },
  "time_zone_info": {
    "olson": "America/Los_Angeles",
    "current_time": "2023-09-03T18:21:13-07:00",
    "gmt_offset": -25200,
    "is_dst": true,
    "sunrise": "06:41",
    "sunset": "19:33"
  },
  "geotargeting": {
    "metro": "807"
  },
  "ads_category": "IAB19-11",
  "ads_category_name": "Data Centers",
  "is_proxy": false,
  "proxy": {
    "last_seen": 3,
    "proxy_type": "DCH",
    "threat": "-",
    "provider": "-",
    "is_vpn": false,
    "is_tor": false,
    "is_data_center": true,
    "is_public_proxy": false,
    "is_web_proxy": false,
    "is_web_crawler": false,
    "is_residential_proxy": false,
    "is_spammer": false,
    "is_scanner": false,
    "is_botnet": false
  }
}
```


LICENCE
=====================
See the LICENSE file.
