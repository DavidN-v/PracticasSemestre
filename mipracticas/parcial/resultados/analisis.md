# Análisis de resultados de compresión

## Recursos evaluados

Se evaluaron los siguientes recursos:

- `pagina-prueba.html` — HTML
- `estilos-prueba.css` — CSS sin minificar
- `estilos-prueba.min.css` — CSS minificado
- `app-prueba.js` — JavaScript
- `datos-grandes.json` — JSON
- `grafico.svg` — SVG
- `feed.xml` — XML
- `texto-grande.txt` — texto plano
- `imagen.png` — PNG
- `foto.jpg` — JPEG
- `clip.mp4` — MP4
- `paquete.zip` — ZIP

Para cada recurso se midieron seis configuraciones: Identity, Gzip 1, Gzip 6, Gzip 9, Brotli 5 y Brotli 11. Cada medición de tiempo corresponde al promedio de tres solicitudes.

## 1. Brotli vs. Gzip

Los resultados muestran que Brotli obtiene menores tamaños comprimidos que Gzip en los recursos textuales evaluados.

### HTML

Para `pagina-prueba.html`:

| Método | Tamaño | Ahorro |
|---|---:|---:|
| Identity | 262.750 B | 0,000 % |
| Gzip 1 | 2.117 B | 99,194 % |
| Gzip 6 | 1.176 B | 99,552 % |
| Gzip 9 | 1.176 B | 99,552 % |
| Brotli 5 | 204 B | 99,922 % |
| Brotli 11 | 181 B | 99,931 % |

Brotli obtiene una reducción mayor que Gzip.

### CSS

Para `estilos-prueba.css`:

| Método | Tamaño | Ahorro |
|---|---:|---:|
| Identity | 346.750 B | 0,000 % |
| Gzip 1 | 8.121 B | 97,658 % |
| Gzip 6 | 7.326 B | 97,888 % |
| Gzip 9 | 7.251 B | 97,909 % |
| Brotli 5 | 3.877 B | 98,882 % |
| Brotli 11 | 3.220 B | 99,071 % |

Brotli obtiene una reducción claramente superior a Gzip.

Para el CSS minificado también se observó una reducción importante con ambos algoritmos.

### JavaScript

Para `app-prueba.js`:

| Método | Tamaño | Ahorro |
|---|---:|---:|
| Identity | 829.263 B | 0,000 % |
| Gzip 1 | 34.133 B | 95,884 % |
| Gzip 6 | 32.990 B | 96,022 % |
| Gzip 9 | 32.279 B | 96,108 % |
| Brotli 5 | 12.971 B | 98,436 % |
| Brotli 11 | 13.669 B | 98,352 % |

Brotli obtiene una reducción considerablemente superior a Gzip. En este recurso Brotli 11 produjo ligeramente más bytes que Brotli 5, por lo que la calidad máxima no garantiza una reducción adicional en todos los contenidos.

### JSON

Para `datos-grandes.json`:

| Método | Tamaño | Ahorro |
|---|---:|---:|
| Identity | 3.780.896 B | 0,000 % |
| Gzip 1 | 45.150 B | 98,806 % |
| Gzip 6 | 40.118 B | 98,939 % |
| Gzip 9 | 40.118 B | 98,939 % |
| Brotli 5 | 18.909 B | 99,500 % |
| Brotli 11 | 17.185 B | 99,545 % |

La diferencia entre Brotli y Gzip es significativa en este JSON grande.

### SVG, XML y texto plano

También se observó que Brotli produce menores tamaños comprimidos que Gzip en `grafico.svg`, `feed.xml` y `texto-grande.txt`.

En `texto-grande.txt`:

| Método | Tamaño | Ahorro |
|---|---:|---:|
| Identity | 1.940.000 B | 0,000 % |
| Gzip 1 | 13.502 B | 99,304 % |
| Gzip 6 | 6.697 B | 99,655 % |
| Gzip 9 | 6.697 B | 99,655 % |
| Brotli 5 | 304 B | 99,984 % |
| Brotli 11 | 133 B | 99,993 % |

## 2. Niveles de compresión y rendimientos decrecientes

### Gzip

En general, pasar de Gzip 1 a Gzip 6 produjo una reducción importante del tamaño.

En varios recursos, pasar de Gzip 6 a Gzip 9 produjo una mejora muy pequeña. En `texto-grande.txt`, por ejemplo, ambos niveles produjeron exactamente 6.697 bytes.

En `datos-grandes.json`, Gzip 6 y Gzip 9 también produjeron el mismo tamaño: 40.118 bytes.

Por lo tanto, el paso de 6 a 9 presenta rendimientos decrecientes en estos recursos.

### Brotli

Brotli 11 produce en algunos recursos tamaños menores que Brotli 5, pero el costo temporal puede aumentar mucho.

El caso más evidente es `datos-grandes.json`:

- Brotli 5: 18.909 B y 0,037947333 s.
- Brotli 11: 17.185 B y 28,384867333 s.

El ahorro adicional de tamaño es pequeño frente al aumento del tiempo de procesamiento.

En `app-prueba.js`, Brotli 5 produjo 12.971 B mientras que Brotli 11 produjo 13.669 B. Esto demuestra que la calidad máxima no siempre produce un archivo menor.

Por este motivo, para compresión al vuelo se seleccionó Brotli 5.

## 3. Tipos de archivo y exclusión de binarios

Los recursos PNG, JPEG, MP4 y ZIP fueron excluidos de la compresión.

Las pruebas confirmaron que conservaron exactamente su tamaño original y no recibieron la cabecera `Content-Encoding`.

| Archivo | Tamaño original | Tamaño transferido |
|---|---:|---:|
| `imagen.png` | 6.176 B | 6.176 B |
| `foto.jpg` | 17.538 B | 17.538 B |
| `clip.mp4` | 7.074 B | 7.074 B |
| `paquete.zip` | 1.159 B | 1.159 B |

Estos formatos ya utilizan mecanismos de compresión propios. Comprimirlos nuevamente puede aumentar el procesamiento sin obtener un beneficio significativo e incluso puede incrementar el tamaño.

## 4. Impacto en CPU y ancho de banda

La compresión disminuye considerablemente la cantidad de bytes transmitidos, por lo que reduce el uso de ancho de banda.

Sin embargo, generar una representación comprimida consume CPU. Las mediciones muestran que los niveles altos pueden aumentar considerablemente el tiempo de procesamiento.

El caso más evidente es `datos-grandes.json`, donde Brotli 11 consigue solo una reducción adicional pequeña respecto de Brotli 5, pero con un tiempo de procesamiento mucho mayor.

Bajo concurrencia alta, ese costo puede multiplicarse porque el servidor debe procesar muchas solicitudes simultáneas.

Por ello, la selección del nivel debe considerar simultáneamente el tamaño transferido, la latencia y la capacidad de procesamiento del servidor.

## 5. Contenido estático vs. dinámico

Para contenido estático que cambia poco, es conveniente considerar la precompresión en disco. De esta manera se genera una representación comprimida una sola vez y no es necesario repetir el proceso para cada solicitud.

Para contenido dinámico o que cambia frecuentemente, resulta más práctico comprimir al vuelo.

Una configuración recomendada para producción es utilizar Brotli con una calidad moderada para contenido textual cuando el cliente lo soporte y mantener Gzip como alternativa de compatibilidad.

Para archivos grandes, estáticos y que cambian poco, puede considerarse la precompresión con Brotli de calidad alta.

No se recomienda comprimir nuevamente JPEG, PNG, MP4 y ZIP.

## Encabezado Vary

Apache utiliza:

```text
Vary: Accept-Encoding
