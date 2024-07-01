
# Proyecto Dockerizado para PHP 8.1 + MariaDB + Nginx + OCI8

Aquí encontrarás una guía simple y clara para configurar y ejecutar este proyecto utilizando Docker y Docker Compose.

## Requisitos

Antes de empezar, asegúrate de tener lo siguiente instalado en tu sistema:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

## Pasos para configurar el proyecto

### 1. Instalar Docker y Docker Compose

#### Docker

Sigue las instrucciones en la [documentación oficial de Docker](https://docs.docker.com/get-docker/) para instalar Docker en tu sistema operativo.

#### Docker Compose

Sigue las instrucciones en la [documentación oficial de Docker Compose](https://docs.docker.com/compose/install/) para instalar Docker Compose.

### 2. Clonar el repositorio

Abre una terminal y ejecuta el siguiente comando para clonar el repositorio:

```sh
git clone https://github.com/albertonunezdev/docker-php-fpm81-oci8.git
```

### 3. Configurar el archivo `.env`

Navega al directorio del proyecto clonado:

```sh
cd docker-php-fpm81-oci8
```

Crea un archivo `.env` en el directorio raíz del proyecto y copia el siguiente contenido:

```env
MARIADB_ROOT_PASSWORD=your_root_password
MARIADB_DATABASE=your_db
MARIADB_USER=your_user
MARIADB_PASSWORD=your_password
NGINX_PORT=80
MARIADB_PORT=3306
```

Asegúrate de reemplazar `your_root_password`,`your_password`, `your_user`, `your_db` con tu datos para conectarte a MariaDB.

### 4. Iniciar Docker Compose

Ejecuta el siguiente comando para iniciar los servicios definidos en el archivo `docker-compose.yml`:

```sh
docker-compose up -d
```

Este comando descargará las imágenes necesarias (si no están ya descargadas) y levantará los contenedores en segundo plano.

### 5. Acceder a la aplicación

Una vez que Docker Compose haya iniciado los servicios, puedes acceder a tu aplicación en el navegador web:

- Nginx: [http://localhost](http://localhost)

NGINX y MariaDB, de ejecutan en el puerto configurado en `.env`

### 6. Parar los servicios

Para detener los servicios, ejecuta:

```sh
docker-compose down
```

## Estructura del Proyecto

- `Dockerfile`: Configuración de Docker para PHP-FPM y las extensiones necesarias.
- `docker-compose.yml`: Configuración de los servicios Docker (Nginx, PHP-FPM, y MariaDB).
- `.env.example`: Archivo de ejemplo para las variables de entorno.
- `oracle/`: Directorio con InstantClient 19.23
- `html/`: Directorio donde colocar los archivos de WordPress.
- `nginx/`: Directorio con la configuración default.conf para Nginx
- `db/`: Directorio con la configuración inicial para MariaDB
- `php/`: Directorio con la configuración php.ini para PHP

## Notas adicionales

- Asegúrate de que los puertos configurados en el archivo `.env` no estén siendo utilizados por otros servicios en tu máquina.
- Para verificar los logs de los contenedores, puedes usar el siguiente comando:

```sh
docker-compose logs -f
```

- Si necesitas acceder al contenedor de MariaDB, puedes hacerlo con:

```sh
docker exec -it mariadb mariadb -u root -p
```

¡Listo! Ahora deberías tener todo lo necesario para configurar y ejecutar este proyecto. Si tienes algún problema o pregunta, no dudes en crear un issue en el repositorio o contactar al mantenedor del proyecto.

---

**Autor:** Alberto Núñez  
**Correo:** info@albertonunez.dev  
**GitHub:** [albertonunezdev](https://github.com/albertonunezdev)
