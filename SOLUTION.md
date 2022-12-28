APACHE

● Configura en apache un virtualhost https con certificado y un redirect hacia otro dominio:

○ dominio: example.example.com

○ dominio\_destino: example-dest.example.com

(ficheros default-ssl.conf y virtualhost añadidos)


DOCKER

● Genera un Dockerfile con las siguientes características:

○ Imagen: alpine

○ Actualiza el sistema e instala el servidor web apache

○ Copia el fichero index.html al directorio "DocumentRoot" por defecto de apache en el

contenedor

○ Crea la variable de entorno "port" con el valor 80

○ Exponer puerto 80

○ Comando a ejecutar al crear el contenedor: "/usr/bin/apache2ctl"

Nota: aqui no acabo de entender porque se quiere ejecutar el apache2ctl en vez del daemon httpd

(fichero Dockerfile añadido)

○ Construye la imagen a partir del Dockerfile que has creado anteriormente.

docker build -t test/apache:1.0 .

● Crea y ejecuta un contenedor con la imagen creada anteriormente.

docker run -it --name apachetest --hostname apachetest -e DEVHOST=192.168.15.21 -p:80:80 -p:443:443 test/apache:1.0


MYSQL/MARIADB

Indica los comandos, de línea de comandos, que utilizarías para realizar las siguientes acciones:

● Crea una base de datos llamada administración.

CREATE DATABASE IF NOT EXISTS administracion CHARACTER SET utf8;

● Crea un usuario con las siguientes características:

○ username: demo

○ password: passT0db

○ acceso remoto desde: 192.168.15.23

CREATE USER 'demo'@'192.168.15.23' IDENTIFIED BY 'passT0db';

● Asígnale privilegios de select y update a la base de datos administración.

GRANT SELECT,UPDATE ON administracion TO 'demo'@'192.168.15.23';

FLUSH PRIVILEGES;


POSTGRESQL

● Crea una base de datos llamada finanzas.

CREATE DATABASE finanzas LOCALE 'es\_ES.utf8' TEMPLATE template0;

● Crea un usuario (demo) con permisos de select en la base de datos finanzas.

1. crear usuario:

CREATE USER demo WITH PASSWORD 'passT0db';

1. conceder acceso:

GRANT CONNECT ON DATABASE finanzas TO demo;

1. conceder acceso al esquema:

GRANT USAGE ON SCHEMA schema TO demo;

1. conceder select:

GRANT SELECT ON ALL TABLES IN SCHEMA schema TO demo;

Para conceder el acceso a futuras nuevas tablas automaticamente:

ALTER DEFAULT PRIVILEGES IN SCHEMA schema GRANT SELECT ON TABLES TO demo;


● Configura en el servidor, el acceso remoto a la base de datos finanzas:

○ origen: 192.168.15.23○ usuario: demo

Editar pg\_hba.conf y añadir la linea:

host demo all 192.168.15.23/32 trust

(trust no seria la mas segura de las opciones, quizas seria mejor md5, pero tambien complica un poco el acceso imho)

Editar el fichero postgresql.conf y cambiar la linea:

listen\_addresses='localhost'

por:

listen\_addresses='192.168.15.23'


AWS

● Pros y contras de ECS/EKS y EC2/Fargate

ECS:

- Pros: integrado con amazon, autoescalable, poco mantenimiento
- Cons: vendor lock-in, precio

Fargate:

- Pros: subconjunto de ecs, sencillo de usar, serverless
- Cons: vendor lock-in

EKS:

- Pros: relativamente agnostico
- Cons: todos los cons de kubernetes, es decir, es complejo, necesita software adicional de monitorizacion, mantenimiento, etc

○ ¿Qué tendrías en cuenta para escoger entre ECS/EKS EC2/Fargate a la hora de migrar

contenedores on premise al cloud?

Yo intentaria aprovechar todas las caracteristicas intrinsecas del cloud intentando mantener la arquitectura lo mas agnostica posible (amazon, nos conocemos) y el precio lo mas bajo posible (aqui amazon nos conocemos mucho).

Intentaria al mismo tiempo crear la menor infraestructura posible (crear infraestructura es lento y caro) y crear los mayores contenedores posibles (crear contenedores es rapido y barato)

Escogeria ECS/Fargate si supiera que amazon no va a ser un problema y EKS si tuviese dudas sobre amazon.

Pero teniendo como base mi experiencia, no tengo claro si escogeria finalmente Amazon como proveedor de cloud (o quizas al menos no el unico), es antiguo, se le notan las costuras, los primeros datacenters construidos la decada pasada ya empiezan a dar fallos, y sobretodo es el mas caro con demasiados costes variables ocultos, excesivamente complejo y con demasiadas capacidades para la mayoria de las empresas que lo usan... El vendor lock-in, en mi experiencia, acaba pasando una factura empresarial, en ocasiones excesiva.

● Caso de uso: Actualmente tenemos una aplicación web corriendo en una subred privada, necesita

realizar peticiones a varios dominios de internet.

○ ¿Cómo permitirías este acceso?

Con un servicio NAT Gateway o Internet Gateway

○ ¿Qué opciones hay para permitir este acceso solo a unos dominios determinados (whitelist)?

Con una Network ACL

Con un security groups

○ ¿Qué pros y contras tienen cada una de ellas?

Ninguna de estas opciones permite dominios, solo direcciones IP's o puertos

De hecho pensaba que no se podia hacer y la unica manera era instalando una instancia adicional haciendo de proxy a los dominios hasta que he hecho una pequeña busqueda y he encontrado esto:

https://aws.amazon.com/es/blogs/security/how-to-automatically-update-your-security-groups-for-amazon-cloudfront-and-aws-waf-by-using-aws-lambda/

● La empresa ACME tiene 2 microservicios: ventas y envíos, y desde negocio nos piden que estos

microservicios deben estar comunicados. ¿Cuales servicios/métodos utilizarías si la comunicación tiene

que ser síncrona y cuales si la comunicación fuese asíncrona?

Sincrona: comunicacion http o API REST

Asincrona: comunicacion con colas a traves de rabbit o kafka

● La empresa ACME maneja sus usuarios en IAM, y nos piden un usuario que permita operar múltiples

servicios en múltiples regiones. ¿Crearias policies por región/por servicio ó crearias una sola? ¿Qué

otra opción propondrías?

Crearia una politica por region


LINUX

● What is the difference between an A Record, C Record and MX Record?

Registro de tipo A: es el standard nombre-a-direccion IP

Registro de tipo CNAME: es un alias de un nombre a otro nombre de registro de tipo A

Registro de tipo MX: es es registro de tipo mail exchanger

● What is the local host, or "home" IP address?

Es la direccion IP que siempre corresponde al propio host: 127.0.0.1

● How many IP addresses are in this network address: 177.199.1.0/24

Hay 256 direcciones, de la 0 a la 255, pero solamente hay 254 direcciones IP válidas, de la 1 a la 254

● On your Linux host, there are many processes running at a time. However, one information can

uniquely identify a process. What is it called?

PID: process ID

● When your system boots, it starts the very first process on your instance. What is it called?

La pregunta no acabo de entenderla exactamente. Los procesos de arranque de linux son los init, el primero es el init0

● You are asked by your system administrator to identify all processes that you own on the host. Which

command would you run to do that?

ps -u $USER

● You are asked by your system administrator to identify all the processes on your system. Can you

provide two commands that display all processes on the host?

ps aux

top

● What syntax is used on Linux in order to execute a process in the background?

./mi\_programa &

● You executed a command in the background, but you want to have your process executed in the foreground:

What command would you execute?

fg (previamente hay que haber ejecutado el comando bg)

● Your process is now executed in the foreground. What controls would you hit on your keyboard in order

to stop the process (and not kill it) ?

CTRL+Z : pausa el proceso

● Your process is now interrupted:

How would you resume the execution in the background?

bg

● What command is used on Linux in order to list all processes given a specific pattern?

ps aux |grep pattern o mas simple pgrep

● What command would you use in order to easily kill (SIGKILL) all processes starting with “fire” ?

pkill --signal SIGKILL fire\*

● What command can be used on Linux in order to monitor processes in real time?

top en todas sus variantes: top htop atop iftop...

● What command would you use to find last ssh logins on Linux?

last

Tambien se puede mirar inspeccionando el fichero auth.log

● Write a linux command that delete all the files in the directory /home/pepe/ more than a year old and which extensions are .txt or .tgz?

find /home/pepe/\* -regex '.\*\.\(txt\|tgz\)' -mtime +365 -delete

TERRAFORM

La empresa ACME usa ECS y nos han pedido que tengamos el siguiente deploy:

● crear un servicio llamado “forest”

● una task definition llamada “webserver”

● que use esta imagen: nginx:1.11.3¿Cómo harías este deployment usando terraform?¿Cuáles serían los pasos para actualizar la versión de la

imagen a 1.19?

No tengo apenas experiencia en terraform tal como comenté en la primera entrevista.

Mirando informacion creo que es asi:

Pasos para el deployment: (añadido main.tf, vars.tf y backend.tf)

- terraform init
- terraform plan
- terraform apply

Para actualizar la imagen a 1.19:

- cambiar en el fichero vars.tf el valor default de 1.11.3 a 1.19
- terraform plan
- terraform apply

Para esto debes crear un repositorio de github con el nombre “devops-test”.

Este repositorio debe contener un archivo llamado SOLUTION.md con la información que creas conveniente

agregar para el correcto funcionamiento del deployment y/o cualquier otra nota adicional.
