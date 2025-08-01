IP2Location.io OpenResty SDK
============================
This OpenResty package enables user to query for an enriched data set, such as country, region, district, city, latitude & longitude, ZIP code, time zone, ASN, ISP, domain, net speed, IDD code, area code, weather station data, MNC, MCC, mobile brand, elevation, usage type, address type, advertisement category and proxy data with an IP address. It supports both IPv4 and IPv6 address lookup.

This package requires API key to function. You may sign up for a free API key at https://www.ip2location.io/pricing.

Developer Documentation
=====================

To learn more about installation, usage, and code examples, please visit the developer documentation at [https://ip2location-io-resty.readthedocs.io/en/latest/index.html](https://ip2location-io-resty.readthedocs.io/en/latest/index.html).


Installation
============
```bash

opm get ip2location/ip2location-io-resty

```


Usage Example
============

Refer to the [Sample Code section](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html#sample-codes)


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
|time_zone_info.abbreviation|string|The time zone abbreviation of the Olson time zone, for example EST and EEST.|
|time_zone_info.dst_start_date|string|The date (UTC) of Daylight Saving Time (DST) begins.|
|time_zone_info.dst_end_date|string|The date (UTC) of Daylight Saving Time (DST) ends.|
|time_zone_info.sunrise|string|Time of sunrise. (hh:mm format in local time, i.e, 07:47)|
|time_zone_info.sunset|string|Time of sunset. (hh:mm format in local time, i.e 19:50)|
|geotargeting.metro|string|Metro code based on zip/postal code.|
|ads_category|string|The domain category code based on IAB Tech Lab Content Taxonomy.|
|ads_category_name|string|The domain category based on IAB Tech Lab Content Taxonomy. These categories are comprised of Tier-1 and Tier-2 (if available) level categories widely used in services like advertising, Internet security and filtering appliances.|
|is_proxy|boolean|Whether is a proxy or not.|
|fraud_score|integer|Potential risk score (0 - 99) associated with IP address. A higher IP2Proxy Fraud Score indicates a greater likelihood of fraudulent activity and a lower reputation.|
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
|proxy.is_consumer_privacy_network|boolean|Consumer Privacy Networks.|
|proxy.is_enterprise_private_network|boolean|Enterprise Private Networks.|

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
  "fraud_score": 0,
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
    "is_consumer_privacy_network":false,
    "is_enterprise_private_network":false,
    "is_spammer": false,
    "is_scanner": false,
    "is_botnet": false
  }
}
```


LICENCE
=====================
See the LICENSE file.
