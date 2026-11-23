"""OWS config for the local compose setup.

Loads the production /config/global.json unchanged except for
allowed_urls, so the capabilities document advertises the local server
instead of https://ows.digitalearth.se. Without this, clients such as QGIS
follow the advertised URLs and fetch maps and legends from production.
"""

import json

with open("/config/global.json", encoding="utf-8") as f:
    ows_cfg = json.load(f)

ows_cfg["global"]["allowed_urls"] = ["http://localhost:9080"]
