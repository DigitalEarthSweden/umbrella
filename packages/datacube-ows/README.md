# datacube-ows

Builds the DES datacube-ows image with the configuration in
`org-config/des/packages/datacube-ows/config/` baked in.

## Testing configuration changes locally

`compose.yaml` runs OWS against a throwaway PostGIS Open Data Cube index
(kept in tmpfs, so it is gone when the postgis container stops). The OWS
config directory is mounted over the one in the image, so config edits only
need a restart.

You need:

- `OWS_PRODUCTS_DIR`: the ODC product definitions, i.e.
  `docker/files/products` in an ssdl-core toolbox checkout. Every product in
  `global.json` must be defined here, or OWS will not start.
- `OWS_DATA_DIR`: a directory with toolbox output (`stac_item.json` next to
  the COGs). It is mounted at the same absolute path inside the container,
  since the STAC asset hrefs are relative to the item.

```shell
cd packages/datacube-ows
export OWS_PRODUCTS_DIR=~/ssdl-core/toolbox/docker/files/products
export OWS_DATA_DIR=~/.local/toolbox/storage/sentinel3-s3sl2lst-des-2026

docker compose build ows
docker compose up -d postgis
docker compose run --rm ows /local-setup.sh   # add products, index, OWS ranges
docker compose up -d ows                      # http://localhost:9080

# After editing the config:
docker compose run --rm --entrypoint datacube-ows-cfg ows check -i /config/global.json
docker compose restart ows
# After adding/removing layers or indexing more data:
docker compose run --rm --entrypoint datacube-ows-update ows

docker compose down                           # drops the index
```

Example requests (`EPSG:3006` is configured northing-first, so its BBOX is
`minN,minE,maxN,maxE` in both WMS 1.1.1 and 1.3.0):

```shell
# Capabilities
curl 'http://localhost:9080/wms?service=WMS&version=1.3.0&request=GetCapabilities'
# Map of Sweden
curl -o lst.png 'http://localhost:9080/wms?service=WMS&version=1.3.0&request=GetMap&layers=des_s3_slstr_l2lst&styles=lst&crs=EPSG:3006&bbox=6100000,200000,7700000,1000000&width=256&height=512&format=image/png&transparent=true&time=2026-07-16'
# Legend
curl -o legend.png 'http://localhost:9080/wms?service=WMS&version=1.3.0&request=GetLegendGraphic&layer=des_s3_slstr_l2lst&styles=lst&format=image/png'
```

The local OWS does not read `global.json` directly but through
`local_ows_cfg.py`, which only replaces `allowed_urls` with
`http://localhost:9080`. Otherwise the capabilities advertise production
(`https://ows.digitalearth.se`) for GetMap, GetFeatureInfo and legends, and
clients such as QGIS fetch from there. In QGIS, add a WMS connection to
`http://localhost:9080/wms` with all "Ignore ... URI" options unticked: when
QGIS builds GetLegendGraphic itself it sends `STYLE=`, which OWS 1.9.19
ignores (it only reads `STYLES=`), so every style would show the default
style's legend.

`OWS_BASE_IMAGE` and `POSTGIS_IMAGE` override the images; the OWS default
must match the version in `Makefile`.
