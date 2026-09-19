ARG BASE=debian:trixie-slim
FROM $BASE AS builder

ARG PG_MAJOR
ARG PGNODEMX_VERSION

USER 0

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends postgresql-common ca-certificates && \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y && \
    apt-get install -y --no-install-recommends -o Dpkg::::="--force-confdef" -o Dpkg::::="--force-confold" \
      "postgresql-${PG_MAJOR}-pgnodemx=${PGNODEMX_VERSION}"

FROM scratch
ARG PG_MAJOR

# Licenses
COPY --from=builder /usr/share/doc/postgresql-${PG_MAJOR}-pgnodemx/copyright  /licenses/postgresql-${PG_MAJOR}-pgnodemx/

# Libraries
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/pgnodemx*  /lib/
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/pgnodemx/ /lib/bitcode/pgnodemx

# Share
COPY --from=builder \
  /usr/share/postgresql/${PG_MAJOR}/extension/pgnodemx* \
  /usr/share/postgresql/${PG_MAJOR}/extension/pg_proctab* \
  /share/extension/

USER 65532:65532
