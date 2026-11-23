#!/bin/bash
# Initialise the local ODC index used by compose.yaml: add every product
# definition in /products, index every STAC item under OWS_DATA_DIR, and
# create/refresh the OWS ranges. Run it inside the ows container:
#
#   docker compose run --rm ows /local-setup.sh
#
# Safe to rerun: existing products and datasets are skipped/updated.
set -euo pipefail

: "${OWS_DATA_DIR:?OWS_DATA_DIR must be set}"

datacube system init

for product in /products/*.yaml; do
    echo "Adding product ${product}"
    datacube product add "${product}" || echo "WARNING: could not add ${product}"
done

mapfile -t items < <(find "${OWS_DATA_DIR}" -name 'stac_item.json' | sort)
echo "Indexing ${#items[@]} STAC items under ${OWS_DATA_DIR}"
if ((${#items[@]} > 0)); then
    printf '%s\0' "${items[@]}" | xargs -0 -n 200 datacube dataset add --ignore-lineage
fi

datacube-ows-update --schema
datacube-ows-update
