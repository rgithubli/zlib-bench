#!/bin/bash
set -xue

CPU=${CPU:-"i7-8650U / 1900MHz"}
DIR=${DEFLATE_DIR:-"i7-8650U-1900MHz-deflate-silesia-openjdk-2020-07-17"}       

java \
 -cp build/benchmarks/ io.simonis.CreateVegaLiteGraph \
 -legend "" \
 -title "Deflater throughput for Silesia corpus on $CPU" \
 -template benchmarks/java/io/simonis/file-throughput-horizontal.json \
 -map "openjdk-bundled:ojdk / zlib-bundled,openjdk-system:ojdk / zlib-system,openjdk-cloudflare:ojdk / zlib-cloudflare,openjdk-chromium:ojdk / zlib-chromium" \
 -sort "ojdk / zlib-bundled,ojdk / zlib-system,ojdk / zlib-chromium,ojdk / zlib-cloudflare" \
 -json graphs/$DIR/file-silesia-openjdk-horizontal-all.json \
 -svg graphs/$DIR/file-silesia-openjdk-horizontal-all.svg \
 -png graphs/$DIR/file-silesia-openjdk-horizontal-all.png \
 -default-impl ristretto19-madler results/$DIR/ristretto19-*.json

