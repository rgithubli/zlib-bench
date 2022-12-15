#!/bin/bash

# (export PATH=$PATH:/share/software/vega-cli/node_modules/vega-lite/bin:/share/software/vega-cli/node_modules/vega-cli/bin)

CPU="Xeon E5-2686 v4 / 1900MHz"
DIR=${DEFLATE_DIR:-"Xeon-E52686-v4-1900MHz-deflate-silesia-2022-12-13"}


java -cp build/benchmarks/ io.simonis.CreateVegaLiteGraph -legend "" -title "Deflater throughput for Silesia corpus (part1) at compression level 6 on $CPU" -template benchmarks/java/io/simonis/file-throughput-horizontal.json -sort "zlib,chromium,ng,jtkukunas,ipp,cloudflare,isal" -json graphs/$DIR/file-deflate-silesia-horizontal-part1.json -svg graphs/$DIR/file-deflate-silesia-horizontal-part1.svg -png graphs/$DIR/file-deflate-silesia-horizontal-part1.png -default-impl system -isal-level 3 results/$DIR/*dickens.json results/$DIR/*mozilla.json results/$DIR/*mr.json results/$DIR/*nci.json results/$DIR/*ooffice.json results/$DIR/*osdb.json

java -cp build/benchmarks/ io.simonis.CreateVegaLiteGraph -legend "" -title "Deflater throughput for Silesia corpus (part2) at compression level 6 on $CPU" -template benchmarks/java/io/simonis/file-throughput-horizontal.json -sort "zlib,chromium,ng,jtkukunas,ipp,cloudflare,isal" -json graphs/$DIR/file-deflate-silesia-horizontal-part2.json -svg graphs/$DIR/file-deflate-silesia-horizontal-part2.svg -png graphs/$DIR/file-deflate-silesia-horizontal-part2.png -default-impl system -isal-level 3 results/$DIR/*reymont.json results/$DIR/*samba.json results/$DIR/*sao.json results/$DIR/*webster.json results/$DIR/*xml.json results/$DIR/*x-ray.json

# Removed from png results/$DIR/*reymont.json 
