# Análisis de seguridad del túnel

## 1. Publicación del servicio

Se utilizó ngrok para publicar temporalmente el servidor Apache local mediante un túnel seguro.

Comando utilizado:

ngrok http 80 --host-header=parcial.empresa.local

El túnel publicó el servicio HTTP local en una URL pública HTTPS.

La página personalizada fue accesible mediante:

/pagina_personalizada.html

La prueba desde un teléfono utilizando datos móviles confirmó el acceso desde una red externa a la red local.

## 2. Verificación de compresión a través del túnel

La compresión configurada en Apache se mantuvo activa al acceder mediante la URL pública del túnel.

### Gzip

Solicitud:

Accept-Encoding: gzip

Resultado:

HTTP/1.1 200 OK
Content-Encoding: gzip
Content-Length: 32990
Content-Type: text/javascript
Vary: Accept-Encoding

Se confirmó que app-prueba.js fue entregado comprimido mediante Gzip a través del túnel.

### Brotli

Solicitud:

Accept-Encoding: br

Resultado:

HTTP/1.1 200 OK
Content-Encoding: br
Content-Type: text/javascript
Vary: Accept-Encoding
Transfer-Encoding: chunked

Se confirmó que app-prueba.js fue entregado comprimido mediante Brotli a través del túnel.

## 3. Riesgo 1: exposición pública del servicio

El túnel hace accesible el servidor Apache desde Internet. Una persona que conozca la URL pública puede intentar realizar solicitudes contra los recursos expuestos.

### Mitigación

Publicar únicamente los recursos necesarios para la demostración, evitar información sensible y utilizar autenticación o controles de acceso en un entorno real.

## 4. Riesgo 2: exposición accidental de recursos

Una configuración incorrecta de Apache podría permitir el acceso a archivos o recursos que no deberían estar publicados.

### Mitigación

Mantener un DocumentRoot controlado, evitar la publicación innecesaria de directorios y archivos, revisar permisos y exponer únicamente el servicio requerido.

## 5. Riesgo 3: URL pública compartida

La URL temporal del túnel puede ser compartida mientras el túnel permanezca activo.

### Mitigación

Detener el proceso de ngrok al finalizar la demostración y utilizar mecanismos permanentes de autenticación y control de acceso para un despliegue real.

## 6. Conclusión

El túnel permitió publicar temporalmente el servicio Apache desde una red local y hacerlo accesible desde una red externa.

Las pruebas realizadas demostraron:

- Acceso HTTPS mediante ngrok.
- Acceso desde un teléfono utilizando datos móviles.
- Funcionamiento de Gzip a través del túnel.
- Funcionamiento de Brotli a través del túnel.
- Preservación del encabezado Vary: Accept-Encoding.

El túnel se considera adecuado para la demostración académica del parcial, pero no debe considerarse por sí solo una configuración de producción.