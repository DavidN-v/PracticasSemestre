# AnÃ¡lisis de resultados de compresiÃ³n

## Resultados de HTML, SVG y XML

Los archivos textuales fueron comprimidos correctamente mediante Gzip y Brotli:

- `index.html`: 452 bytes sin compresiÃ³n, 296 bytes con Gzip y 210 bytes con Brotli.
- `grafico.svg`: 308 bytes sin compresiÃ³n, 209 bytes con Gzip y 171 bytes con Brotli.
- `feed.xml`: 250 bytes sin compresiÃ³n, 199 bytes con Gzip y 167 bytes con Brotli.

En estos casos, Brotli obtuvo un tamaÃ±o menor que Gzip.

## Archivo de texto grande

El archivo `texto-grande.txt` tenÃ­a un tamaÃ±o original de 1.940.000 bytes.

| MÃ©todo | TamaÃ±o | ReducciÃ³n |
|---|---:|---:|
| Identity | 1.940.000 bytes | 0 % |
| Gzip nivel 6 | 6.697 bytes | 99,655 % |
| Brotli calidad 5 | 304 bytes | 99,984 % |

Brotli obtuvo la mayor reducciÃ³n de tamaÃ±o. Sin embargo, los niveles mÃ¡s altos pueden consumir mÃ¡s CPU.

## Tabla comparativa resumida

Recurso evaluado: `texto-grande.txt`  
TamaÃ±o original: `1.940.000 bytes`

| Algoritmo / nivel | TamaÃ±o comprimido | Ratio | Ahorro % | Tiempo promedio |
|---|---:|---:|---:|---:|
| Sin comprimir (Identity) | 1.940.000 bytes | 1,0000 | 0 % | 0,011969 s |
| Gzip nivel 1 | 13.502 bytes | 0,00696 | 99,304 % | 0,243944 s |
| Gzip nivel 6 | 6.697 bytes | 0,00345 | 99,655 % | 0,025571 s |
| Gzip nivel 9 | 6.697 bytes | 0,00345 | 99,655 % | 0,247073 s |
| Brotli calidad 5 | 304 bytes | 0,00016 | 99,984 % | 0,007028 s |
| Brotli calidad 11 | 133 bytes | 0,00007 | 99,993 % | 0,400808 s |

### InterpretaciÃ³n de la tabla

Brotli calidad 11 produjo el archivo mÃ¡s pequeÃ±o, con una reducciÃ³n aproximada del 99,993 %. Sin embargo, Brotli calidad 5 fue seleccionado para la configuraciÃ³n final porque ofrece una reducciÃ³n excelente con menor costo de procesamiento.

Gzip nivel 6 fue seleccionado como configuraciÃ³n final porque reduce considerablemente el tamaÃ±o del archivo sin utilizar el costo adicional del nivel 9, que en esta prueba produjo el mismo tamaÃ±o comprimido.

Los tiempos que aparecen como `No medido` no deben interpretarse como cero. Corresponden a combinaciones que todavÃ­a no fueron medidas individualmente.

## Archivos binarios

Los archivos JPEG, PNG, MP4 y ZIP conservaron su tamaÃ±o original y no recibieron la cabecera `Content-Encoding`.

Esto es correcto porque estos formatos ya utilizan compresiÃ³n propia. Comprimirlos nuevamente no produce una reducciÃ³n significativa y puede aumentar el consumo de CPU.

## Cabecera Vary

Apache enviÃ³ la cabecera:

```text
Vary: Accept-Encoding

