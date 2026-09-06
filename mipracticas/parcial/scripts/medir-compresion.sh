#!/bin/bash

set -e

BASE_URL="http://parcial.empresa.local"
SITE_DIR="/var/www/parcial"
DEF_CONFIG="/etc/apache2/conf-available/compresion-deflate.conf"
BR_CONFIG="/etc/apache2/conf-available/compresion-brotli.conf"
SALIDA="/home/vagrant/entrega-parcial/resultados/tabla-compresion.csv"

REPETICIONES=3

ARCHIVOS=(
    "pagina-prueba.html|HTML"
    "estilos-prueba.css|CSS"
    "estilos-prueba.min.css|CSS minificado"
    "app-prueba.js|JavaScript"
    "datos-grandes.json|JSON"
    "grafico.svg|SVG"
    "feed.xml|XML"
    "texto-grande.txt|Texto plano"
    "imagen.png|PNG"
    "foto.jpg|JPEG"
    "clip.mp4|MP4"
    "paquete.zip|ZIP"
)

echo "Archivo,Tipo,Algoritmo,Nivel,Tamaño original (bytes),Tamaño comprimido (bytes),Reducción (%),Tiempo promedio (s),Content-Encoding" > "$SALIDA"

obtener_original() {
    local archivo="$1"
    stat -c%s "$SITE_DIR/pruebas/$archivo"
}

obtener_encoding_real() {
    local archivo="$1"
    local encoding="$2"

    curl -sS -I \
        --resolve parcial.empresa.local:80:192.168.50.3 \
        -H "Accept-Encoding: $encoding" \
        "$BASE_URL/pruebas/$archivo" |
    awk 'BEGIN{IGNORECASE=1}
         /^Content-Encoding:/ {
             gsub("\r","",$2)
             print $2
             exit
         }'
}

medir() {
    local archivo="$1"
    local tipo="$2"
    local algoritmo="$3"
    local nivel="$4"
    local encoding="$5"

    local original
    original=$(obtener_original "$archivo")

    local suma_tamano=0
    local suma_tiempo=0
    local resultado
    local tamano
    local tiempo

    for ((i=1; i<=REPETICIONES; i++)); do

        resultado=$(
            curl -sS \
                --resolve parcial.empresa.local:80:192.168.50.3 \
                -H "Accept-Encoding: $encoding" \
                -o /dev/null \
                -w "%{size_download};%{time_total}" \
                "$BASE_URL/pruebas/$archivo"
        )

        tamano="${resultado%%;*}"
        tiempo="${resultado##*;}"

        suma_tamano=$((suma_tamano + tamano))
        suma_tiempo=$(awk -v a="$suma_tiempo" -v b="$tiempo" \
            'BEGIN { printf "%.9f", a+b }')
    done

    local promedio_tamano
    local promedio_tiempo
    local reduccion
    local content_encoding

    promedio_tamano=$(awk -v s="$suma_tamano" -v n="$REPETICIONES" \
        'BEGIN { printf "%.0f", s/n }')

    promedio_tiempo=$(awk -v s="$suma_tiempo" -v n="$REPETICIONES" \
        'BEGIN { printf "%.9f", s/n }')

    reduccion=$(awk -v o="$original" -v c="$promedio_tamano" \
        'BEGIN {
            if (o == 0) printf "0.000";
            else printf "%.3f", (1 - c/o) * 100
        }')

    content_encoding=$(obtener_encoding_real "$archivo" "$encoding")
    [ -z "$content_encoding" ] && content_encoding="-"

    echo "$archivo,$tipo,$algoritmo,$nivel,$original,$promedio_tamano,$reduccion,$promedio_tiempo,$content_encoding" >> "$SALIDA"

    echo "$archivo | $algoritmo $nivel | original=$original | comprimido=$promedio_tamano | reduccion=$reduccion% | tiempo=$promedio_tiempo s | encoding=$content_encoding"
}

configurar_gzip() {
    local nivel="$1"

    sudo sed -i \
        -E "s/DeflateCompressionLevel [0-9]+/DeflateCompressionLevel $nivel/" \
        "$DEF_CONFIG"
}

configurar_brotli() {
    local nivel="$1"

    sudo sed -i \
        -E "s/BrotliCompressionQuality [0-9]+/BrotliCompressionQuality $nivel/" \
        "$BR_CONFIG"
}

recargar_apache() {
    sudo apache2ctl configtest
    sudo systemctl reload apache2
}

echo "=============================================="
echo "   MEDICION COMPLETA DE COMPRESION APACHE"
echo "=============================================="
echo

echo "Restaurando configuración inicial: Gzip 6 / Brotli 5"
configurar_gzip 6
configurar_brotli 5
recargar_apache

echo
echo "=== IDENTITY ==="

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Identity" "-" "identity"
done

echo
echo "=== GZIP 1 ==="

configurar_gzip 1
recargar_apache

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Gzip" "1" "gzip"
done

echo
echo "=== GZIP 6 ==="

configurar_gzip 6
recargar_apache

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Gzip" "6" "gzip"
done

echo
echo "=== GZIP 9 ==="

configurar_gzip 9
recargar_apache

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Gzip" "9" "gzip"
done

echo
echo "=== BROTLI 5 ==="

configurar_gzip 6
configurar_brotli 5
recargar_apache

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Brotli" "5" "br"
done

echo
echo "=== BROTLI 11 ==="

configurar_brotli 11
recargar_apache

for entrada in "${ARCHIVOS[@]}"; do
    IFS='|' read -r archivo tipo <<< "$entrada"
    medir "$archivo" "$tipo" "Brotli" "11" "br"
done

echo
echo "=============================================="
echo " Restaurando configuración FINAL"
echo " Gzip 6 / Brotli 5"
echo "=============================================="

configurar_gzip 6
configurar_brotli 5
recargar_apache

echo
echo "Mediciones terminadas."
echo "CSV generado en:"
echo "$SALIDA"
echo
echo "Cantidad de registros:"
tail -n +2 "$SALIDA" | wc -l
