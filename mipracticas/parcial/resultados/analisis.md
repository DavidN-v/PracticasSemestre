@'

\# Análisis de resultados de compresión



\## Resultados de HTML, SVG y XML



Los archivos textuales fueron comprimidos correctamente mediante Gzip y Brotli:



\- `index.html`: 452 bytes sin compresión, 296 bytes con Gzip y 210 bytes con Brotli.

\- `grafico.svg`: 308 bytes sin compresión, 209 bytes con Gzip y 171 bytes con Brotli.

\- `feed.xml`: 250 bytes sin compresión, 199 bytes con Gzip y 167 bytes con Brotli.



En estos casos, Brotli obtuvo un tamaño menor que Gzip.



\## Archivo de texto grande



El archivo `texto-grande.txt` tenía un tamaño original de 1.940.000 bytes.



| Método | Tamaño | Reducción |

|---|---:|---:|

| Identity | 1.940.000 bytes | 0 % |

| Gzip nivel 6 | 6.697 bytes | 99,655 % |

| Brotli calidad 5 | 304 bytes | 99,984 % |



Brotli obtuvo la mayor reducción de tamaño. Sin embargo, los niveles más altos pueden consumir más CPU.



\## Archivos binarios



Los archivos JPEG, PNG, MP4 y ZIP conservaron su tamaño original y no recibieron la cabecera `Content-Encoding`.



Esto es correcto porque estos formatos ya utilizan compresión propia. Comprimirlos nuevamente no produce una reducción significativa y puede aumentar el consumo de CPU.



\## Cabecera Vary



Apache envió la cabecera:



```text

Vary: Accept-Encoding

