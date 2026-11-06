# IP2Location.io OpenResty SDK — IP Geolocation & IP Intelligence for OpenResty

**IP2Location.io OpenResty SDK** (`ip2location-io-resty`) is an OpenResty/Lua package for retrieving **IPv4 and IPv6 geolocation, network and IP intelligence data** using the [IP2Location.io API](https://www.ip2location.io/). It integrates IP lookups into OpenResty applications using the Nginx Lua module and can return available location, ASN, ISP, time zone and proxy-related information.

**Quick links:** [Get an API key](https://www.ip2location.io/pricing) · [Developer documentation](https://ip2location-io-resty.readthedocs.io/en/latest/index.html) · [API reference](https://ip2location-io-resty.readthedocs.io/en/latest/code.html) · [GitHub repository](https://github.com/ip2location/ip2location-io-resty)

## Features

- **IPv4 and IPv6 geolocation:** Look up available country, region, district, city, postal code, latitude and longitude.
- **Network and ASN information:** Access ASN, AS name, ISP, associated domain, connection speed and usage type where included in the API response.
- **Time zone and localization data:** Retrieve time zone information and eligible daylight saving details; request translated continent, country, region and city names on Plus and Security plans.
- **Proxy and security signals:** Access available proxy, VPN, Tor, data center, crawler and other network-risk indicators, including a fraud score when provided by the plan.
- **Additional IP intelligence:** Retrieve eligible mobile carrier (MCC/MNC), country metadata, elevation, weather station and advertising category fields.
- **OpenResty integration:** Perform lookups from Nginx `content_by_lua_block` handlers and use the results in OpenResty applications.

> **Plan availability:** Not all attributes are included in every API plan or returned for every address. See the [pricing page](https://www.ip2location.io/pricing) and [OpenResty response field reference](https://ip2location-io-resty.readthedocs.io/en/latest/code.html) for details.

## SDK modules

The [official OpenResty API reference](https://ip2location-io-resty.readthedocs.io/en/latest/code.html) documents the following configuration and geolocation interfaces:

| Module / method | Description |
| --- | --- |
| [`configuration`](https://ip2location-io-resty.readthedocs.io/en/latest/code.html#configuration-class) | Stores the API key for IP2Location.io lookups. Set `configuration.api_key`. |
| [`ipgeolocation:open(configuration)`](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html) | Initializes the geolocation client with the configuration object. |
| [`ipl:lookup(ip, lang)`](https://ip2location-io-resty.readthedocs.io/en/latest/code.html#ipgeolocation-class) | Looks up an IPv4 or IPv6 address; `lang` is an optional translation-language code. |

This OpenResty SDK's published documentation covers **IP geolocation**. Although the IP2Location.io platform offers separate Domain WHOIS and Hosted Domain APIs, the OpenResty SDK documentation does **not** describe corresponding SDK modules or methods. Therefore, those examples are intentionally not included here.

## API access and query limits

IP2Location.io offers keyless geolocation queries through its REST API and a Free plan with an API key:

| API service | Keyless (no API key) | Free plan (with API key) |
| --- | --- | --- |
| IP Geolocation API | **1,000 queries/day** | **50,000 queries/month** |

- **Keyless access:** The limited [IP Geolocation REST API](https://www.ip2location.io/ip2location-documentation) supports requests without registration. Its allowance resets daily at **00:00 UTC**. **This SDK requires an API key**, so the examples below use authenticated access.
- **Free plan:** Sign up for an API key to use the published monthly allowance.
- **Attribution:** Keyless and Free-plan usage require attribution. See the [pricing page](https://www.ip2location.io/pricing) for current conditions.
- **Paid plans:** Higher quotas and additional fields are available; consult the [pricing page](https://www.ip2location.io/pricing).

The platform also offers Domain WHOIS and Hosted Domain API quotas, but those are **separate services**, not documented functions of this OpenResty SDK.

## Requirements

- [OpenResty](https://openresty.org/) with its bundled Nginx Lua support.
- The [OpenResty Package Manager (`opm`)](https://opm.openresty.org/) to install the SDK.
- An [IP2Location.io API key](https://www.ip2location.io/pricing) for SDK lookups.
- Outbound HTTPS access to the IP2Location.io API endpoint and DNS resolution for the upstream host.

The official quickstart demonstrates the SDK within an OpenResty/Nginx configuration, rather than as a standalone Lua script. The documentation does not specify a minimum OpenResty release; use a supported OpenResty installation with `opm` available.

## Installation

### 1. Install the OpenResty package

Use the command provided by the [official repository](https://github.com/ip2location/ip2location-io-resty) and [quickstart](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html):

```bash
opm get ip2location/ip2location-io-resty
```

### 2. Configure the API key

The official quickstart sets `configuration.api_key = apikey` within its Lua handler. For a deployed application, you can keep the key out of source control by supplying it through the process environment.

**Linux / macOS terminal:**

```bash
export IP2LOCATION_API_KEY='YOUR_API_KEY'
```

In the **main** (top-level) section of your OpenResty/Nginx configuration, preserve that environment variable for workers:

```nginx
env IP2LOCATION_API_KEY;
```

> **Deployment note:** Environment-variable handling depends on how OpenResty is launched (for example, a service manager may not inherit your interactive shell environment). Ensure the variable is available to the OpenResty master process. The official sample alternatively uses a literal `YOUR_API_KEY` placeholder.

## Quickstart: IP geolocation lookup

The following `nginx.conf` example follows the [official OpenResty quickstart](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html) with an environment-supplied API key and a shorter response.

```nginx
# Main context
env IP2LOCATION_API_KEY;
worker_processes 1;
error_log logs/error.log;

events {
    worker_connections 1024;
}

http {
    resolver 8.8.8.8 ipv6=off;

    server {
        listen 8080;

        location / {
            default_type text/plain;
            content_by_lua_block {
                local configuration = require("configuration")
                local ipgeolocation = require("ipgeolocation")

                configuration.api_key = os.getenv("IP2LOCATION_API_KEY")
                local ipl = ipgeolocation:open(configuration)
                local result = ipl:lookup("8.8.8.8", "")

                ngx.say("IP: " .. result.ip)
                ngx.say("Country: " .. result.country_name)
                ngx.say("City: " .. result.city_name)
                ngx.say("ASN: " .. result.asn)
            }
        }
    }
}
```

Save the configuration in the appropriate location for your OpenResty installation, then validate and start or reload OpenResty using your deployment's normal commands. For example, after the server is running:

```bash
curl http://127.0.0.1:8080/
```

The sample intentionally uses the fixed address `8.8.8.8`, as in the official quickstart. Substitute your target IP as appropriate. The optional second argument is the translation language; an empty string requests no translation. Available response fields depend on the API plan.

## OpenResty response handling

The documented `lookup()` result is a decoded response table. Use Lua table access for fields (`result.country_name`), and check optional nested objects before reading them (`result.proxy`, `result.time_zone_info`, etc.). For boolean values printed with `ngx.say`, `tostring()` matches the convention in the [official example](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html).

The examples in the next section are **Lua snippets intended for `content_by_lua_block`** (or another appropriate OpenResty Lua handler). Each snippet assumes these common initialization lines have already been run:

```lua
local configuration = require("configuration")
local ipgeolocation = require("ipgeolocation")
configuration.api_key = os.getenv("IP2LOCATION_API_KEY")
local ipl = ipgeolocation:open(configuration)
```

## More usage examples

### Request translated location names

Pass an ISO 639-1 language code as the optional second argument. The [official reference](https://ip2location-io-resty.readthedocs.io/en/latest/code.html#ipgeolocation-class) specifies that translations are available with **Plus and Security** plans.

```lua
local result = ipl:lookup("8.8.8.8", "fr")

if result.country ~= nil and result.country.translation ~= nil then
    ngx.say("Country translation: " .. tostring(result.country.translation.value))
end
```

The translated value may be unavailable for an address or field even when a language code is requested.

### Retrieve ASN and ISP details

The API can return a top-level ASN and AS name, as well as additional structured AS information on eligible plans:

```lua
local result = ipl:lookup("8.8.8.8", "")

ngx.say("ASN: " .. tostring(result.asn))
ngx.say("AS name: " .. tostring(result.as))
ngx.say("ISP: " .. tostring(result.isp))

if result.as_info ~= nil then
    ngx.say("AS domain: " .. tostring(result.as_info.as_domain))
    ngx.say("AS CIDR: " .. tostring(result.as_info.as_cidr))
end
```

### Inspect proxy and security indicators

Proxy-related fields and fraud scores depend on the plan and returned data. The nested proxy object is optional.

```lua
local result = ipl:lookup("8.8.8.8", "")

ngx.say("Is proxy: " .. tostring(result.is_proxy))

if result.proxy ~= nil then
    ngx.say("Is VPN: " .. tostring(result.proxy.is_vpn))
    ngx.say("Is Tor: " .. tostring(result.proxy.is_tor))
    ngx.say("Is data center: " .. tostring(result.proxy.is_data_center))
end
```

Use these indicators alongside other signals when reviewing risk; a single IP attribute is not definitive evidence of fraud.

### Retrieve time zone information

Eligible responses can include detailed time zone information, including Olson time zone, UTC offset and daylight saving status.

```lua
local result = ipl:lookup("8.8.8.8", "")

ngx.say("Time zone: " .. tostring(result.time_zone))

if result.time_zone_info ~= nil then
    ngx.say("Olson: " .. tostring(result.time_zone_info.olson))
    ngx.say("GMT offset: " .. tostring(result.time_zone_info.gmt_offset))
    ngx.say("DST active: " .. tostring(result.time_zone_info.is_dst))
end
```

### Return a JSON geolocation response

You can return selected fields as JSON from an OpenResty handler. This example is an **additional integration example** rather than a verbatim sample from the SDK quickstart.

```lua
local cjson = require("cjson")
local result = ipl:lookup("8.8.8.8", "")

ngx.header.content_type = "application/json"
ngx.say(cjson.encode({
    ip = result.ip,
    country_code = result.country_code,
    country_name = result.country_name,
    city_name = result.city_name,
    asn = result.asn
}))
```

### Use the client IP in an OpenResty handler

For an application endpoint, you can pass a request IP to the same documented `lookup()` method. This is an **additional integration example**, not a separate SDK method.

```lua
local ip = ngx.var.remote_addr
local result = ipl:lookup(ip, "")

ngx.say("Client IP: " .. tostring(ip))
ngx.say("Country: " .. tostring(result.country_name))
```

`ngx.var.remote_addr` represents the address OpenResty sees as the client. Behind a reverse proxy or load balancer, configure trusted proxy handling correctly before using it as the originating client IP. Avoid trusting arbitrary forwarded-IP headers.

## OpenResty troubleshooting

- **`module 'configuration' not found` or `module 'ipgeolocation' not found`:** Confirm `opm get ip2location/ip2location-io-resty` completed successfully and that the OpenResty process uses the Lua module search path provided by the package installation.
- **API key missing:** Check that `IP2LOCATION_API_KEY` is present in the OpenResty master process environment and that the top-level `env IP2LOCATION_API_KEY;` directive is configured. Alternatively, use the API key assignment shown in the official quickstart.
- **DNS or outbound HTTPS issues:** Make sure the OpenResty host can resolve and contact the API service. The official sample configures an Nginx `resolver` directive.
- **Missing optional fields:** Verify your API plan and check whether an optional nested object exists before accessing its members. Missing values do not necessarily indicate an SDK failure.

## Common use cases

- **Website localization:** Use approximate IP location to select region-relevant content or language in an OpenResty application.
- **Traffic and network analytics:** Add country, city, ISP and ASN context to request-related data.
- **Security review:** Supplement other risk signals using available proxy, VPN, Tor and data center indicators.
- **Location-aware API responses:** Return selected geolocation fields as JSON from an OpenResty endpoint.
- **Time zone-aware experiences:** Read available time zone data to suggest location-appropriate displays or settings.

## Documentation and support

- [OpenResty SDK quickstart and sample code](https://ip2location-io-resty.readthedocs.io/en/latest/quickstart.html)
- [OpenResty API reference and response fields](https://ip2location-io-resty.readthedocs.io/en/latest/code.html)
- [Official GitHub repository](https://github.com/ip2location/ip2location-io-resty)
- [OpenResty Package Manager](https://opm.openresty.org/)
- [IP2Location.io API plans and query limits](https://www.ip2location.io/pricing)
- [IP Geolocation API authentication and rate limits](https://www.ip2location.io/ip2location-documentation)
- [Report an SDK issue or request a feature](https://github.com/ip2location/ip2location-io-resty/issues)
- [API and account support](https://www.ip2location.io/contact-us)

## License

Licensed under the **MIT License**. See [LICENSE](./LICENSE).
