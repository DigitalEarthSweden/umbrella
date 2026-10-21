import os

CUBEDASH_DEFAULT_PRODUCTS = "s2_msi_l2a"
CUBEDASH_DEFAULT_TIMEZONE = "Europe/Stockholm"
CUBEDASH_INSTANCE_TITLE = "DES"
CUBEDASH_DATA_S3_REGION = None
default_map_zoom = 3
default_map_center = [61.7423912, 8.4457781]

CUBEDASH_BASEMAP_URL_TEMPLATE = os.environ.get("CUBEDASH_BASEMAP_URL_TEMPLATE") or (
    "https://storage.googleapis.com/terria-datasets-public/basemaps/natural-earth-tiles/{z}/{x}/{-y}.png"
)
CUBEDASH_BASEMAP_ATTRIBUTION = os.environ.get("CUBEDASH_BASEMAP_ATTRIBUTION") or (
    "Natural Earth II, public domain"
)

STAC_ENDPOINT_ID = "des-explorer"
STAC_ENDPOINT_TITLE = "Digital Earth Sweden Explorer instance"
STAC_ENDPOINT_DESCRIPTION = "STAC endpoint for Digital Earth Sweden"
