# Análisis de resultados de compresión

## Resultados de HTML, SVG y XML

Los archivos textuales fueron comprimidos correctamente mediante Gzip y Brotli:

- `index.html`: 452 bytes sin compresión, 296 bytes con Gzip y 210 bytes con Brotli.
- `grafico.svg`: 308 bytes sin compresión, 209 bytes con Gzip y 171 bytes con Brotli.
- `feed.xml`: 250 bytes sin compresión, 199 bytes con Gzip y 167 bytes con Brotli.

En estos casos, Brotli obtuvo un tamaño menor que Gzip.

## Archivo de texto grande

El archivo `texto-grande.txt` tenía un tamaño original de 1.940.000 bytes.

| Método | Tamaño | Reducción |
|---|---:|---:|
| Identity | 1.940.000 bytes | 0 % |
| Gzip nivel 6 | 6.697 bytes | 99,655 % |
| Brotli calidad 5 | 304 bytes | 99,984 % |

Brotli obtuvo la mayor reducción de tamaño. Sin embargo, los niveles más altos pueden consumir más CPU.

## Tabla comparativa resumida

Recurso evaluado: `texto-grande.txt`  
Tamaño original: `1.940.000 bytes`

| Algoritmo / nivel | Tamaño comprimido | Ratio | Ahorro % | Tiempo promedio |
|---|---:|---:|---:|---:|
| Sin comprimir (Identity) | 1.940.000 bytes | 1,0000 | 0 % | 0,011969 s |
| Gzip nivel 1 | 13.502 bytes | 0,00696 | 99,304 % | No medido |
| Gzip nivel 6 | 6.697 bytes | 0,00345 | 99,655 % | 0,025571 s |
| Gzip nivel 9 | 6.697 bytes | 0,00345 | 99,655 % | No medido |
| Brotli calidad 5 | 304 bytes | 0,00016 | 99,984 % | 0,007028 s |
| Brotli calidad 11 | 133 bytes | 0,00007 | 99,993 % | No medido |

### Interpretación de la tabla

Brotli calidad 11 produjo el archivo más pequeño, con una reducción aproximada del 99,993 %. Sin embargo, Brotli calidad 5 fue seleccionado para la configuración final porque ofrece una reducción excelente con menor costo de procesamiento.

Gzip nivel 6 fue seleccionado como configuración final porque reduce considerablemente el tamaño del archivo sin utilizar el costo adicional del nivel 9, que en esta prueba produjo el mismo tamaño comprimido.

Los tiempos que aparecen como `No medido` no deben interpretarse como cero. Corresponden a combinaciones que todavía no fueron medidas individualmente.

## Archivos binarios

Los archivos JPEG, PNG, MP4 y ZIP conservaron su tamaño original y no recibieron la cabecera `Content-Encoding`.

Esto es correcto porque estos formatos ya utilizan compresión propia. Comprimirlos nuevamente no produce una reducción significativa y puede aumentar el consumo de CPU.

## Cabecera Vary

Apache envió la cabecera:

```text
Vary: Accept-Encoding
