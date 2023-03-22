#!/bin/bash                                                             
set -xue
                                                                        
CPU=${CPU:-"Xeon E5-2686 v4 / 1900MHz"}                                        
DIR=${INFLATE_DIR:-"Xeon-E52686-v4-1900MHz-silesia-2022-12-14-01-old-code-inflate"}       
                                                                        
java \
-cp build/benchmarks/ io.simonis.CreateVegaLiteGraph \
-legend "" \
-title "Inflater throughput for Silesia corpus on $CPU" \
-template benchmarks/java/io/simonis/file-throughput-horizontal.json \
-map "openjdk-bundled:ojdk / zlib-bundled,openjdk-system:ojdk / zlib-system,openjdk-cloudflare:ojdk / zlib-cloudflare,openjdk-chromium:ojdk / zlib-chromium" \
-sort "ojdk / zlib-bundled,ojdk / zlib-system,ojdk / zlib-cloudflare,ojdk / zlib-chromium" \
-json graphs/$DIR/file-inflate-silesia-horizontal-all.json \
-svg graphs/$DIR/file-inflate-silesia-horizontal-all.svg \
-png graphs/$DIR/file-inflate-silesia-horizontal-all.png \
-default-impl ristretto8-bundled results/$DIR/ristretto*.json


