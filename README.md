# 🌱 AgroGest – Sistema Integral de Gestión Agropecuaria

**Parcial I – Ingeniería de Software III – Ingeniería de Sistemas – Corporación Universitaria Remington (2026-02)**

Aplicación web para el sector agropecuario (proyecto de investigación *AgroCosto*: costeo de la producción para pequeños productores).
Esta primera entrega implementa el **Acceso al sistema**, la **carga del menú según el perfil**, la **recuperación de credenciales por correo** y el **CRUD completo con inhabilitación lógica** de los formularios **Perfil, Usuario y Persona**, conectados a MySQL.

| Capa | Tecnología |
|---|---|
| Backend | Java 21 · Spring Boot 3.3 · Spring MVC · Spring Security · Spring Data JPA / Hibernate · Bean Validation · Maven |
| Frontend | Thymeleaf · HTML5 · CSS3 · JavaScript · Bootstrap 5.3 · Bootstrap Icons (servidos localmente, sin depender de internet) |
| Base de datos | MySQL 8 (`agrogest_db`) |
| Servicios | JavaMailSender (SMTP) · BCrypt |
| Pruebas | JUnit 5 · Mockito · Spring Security Test · H2 (70 pruebas) |

---

## ✅ Funcionalidades

- **Acceso al sistema:** Ingresar, Cancelar/Limpiar, ¿Olvidaste tu contraseña? y Registrarse. Mensajes claros para campos vacíos, usuario no registrado, contraseña incorrecta, usuario inhabilitado y perfil inhabilitado. Todo se consulta en MySQL; no hay usuarios escritos en el código.
- **Recuperación de credenciales:** el usuario digita su correo (o su nombre de usuario). Si está registrado se muestra *"Su usuario y contraseña fue enviado al correo registrado"* y le llega un correo con su **nombre de usuario** y un **enlace seguro** (token aleatorio, de un solo uso, que vence en 30 minutos) para crear una nueva contraseña. Si no existe, se muestra *"El usuario no se encuentra registrado"*. Cada envío queda registrado en la tabla `registro_correo`.
- **Registrarse:** abre el formulario Gestión Persona con los datos de acceso y crea la persona y su usuario **en una sola transacción**, siempre con perfil `USUARIO`.
- **Dashboard:** identidad agropecuaria, indicadores reales de la base de datos, tarjetas agro demostrativas (marcadas como tal) y menú según el perfil.
- **Gestión Perfil / Usuario / Persona:** botones **Nuevo/Limpiar, Guardar, Consultar, Modificar, Inhabilitar y Regresar**, tabla de resultados con búsqueda y clic en la fila para cargar el registro.
- **Inhabilitación lógica:** **nunca** se ejecuta `DELETE`. El botón Inhabilitar cambia `estado` a `INACTIVO` (pide confirmación) y el registro se conserva.
- **Permisos (según la tabla de requisitos del parcial):**

| Gestión | Acción | Persona (perfil USUARIO u otros) | Administrador |
|---|---|:-:|:-:|
| Perfil | Crear, Consultar, Modificar, Inhabilitar, Guardar, Salir | – | ✔ |
| Usuario | Crear, Consultar, Modificar, Inhabilitar, Guardar, Salir | – | ✔ |
| Persona | Crear, Consultar, Modificar, Guardar, Salir | ✔ | ✔ |
| Persona | Inhabilitar | – | ✔ |
| Acceso | Ingresar, Cancelar, Recuperar, Registrarse | ✔ | ✔ |

  Los permisos se validan en el **backend** (rutas + `@PreAuthorize`), no solo ocultando botones: una petición directa por URL sin permiso responde 403.

---

## 🚀 Instalación y ejecución

### 1. Requisitos
- **JDK 21** (por ejemplo [Eclipse Temurin 21](https://adoptium.net/)). Maven **no** hace falta: el proyecto trae Maven Wrapper (`mvnw`).
- **MySQL 8** en ejecución (y MySQL Workbench si desea ver el modelo).
- Git.

### 2. Descargar el proyecto
```bash
git clone https://github.com/Ruberemix/agrogest.git
```
```bash
cd agrogest
```

### 3. Crear la base de datos
Opción A, **MySQL Workbench**: *File › Open SQL Script* › `database/agrogest_db.sql` › ejecutar (⚡).

Opción B, consola:
```bash
mysql -u root -p < database/agrogest_db.sql
```
> Si se omite este paso, la aplicación crea la base `agrogest_db` y sus tablas al arrancar.

### 4. Configurar las variables (`.env`)
Copie `.env.example` como `.env` (en la raíz del proyecto) y complete:

| Variable | Descripción |
|---|---|
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | Conexión a MySQL |
| `AGROGEST_ADMIN_USER`, `AGROGEST_ADMIN_PASSWORD`, `AGROGEST_ADMIN_EMAIL` | Administrador inicial (se crea **solo** si no existe ninguno). Contraseña: 8-64 caracteres con mayúscula, minúscula, número y carácter especial |
| `MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_FROM` | Servidor SMTP para la recuperación de contraseña |
| `APP_BASE_URL` | URL de la aplicación (para el enlace del correo) |

El archivo `.env` está en `.gitignore`: **nunca** se sube a GitHub.

#### Correo con Gmail
1. En la cuenta de Google active la **verificación en dos pasos**.
2. Cree una **contraseña de aplicación** en <https://myaccount.google.com/apppasswords>.
3. En `.env`: `MAIL_HOST=smtp.gmail.com`, `MAIL_PORT=587`, `MAIL_USERNAME=sucorreo@gmail.com`, `MAIL_PASSWORD=<la contraseña de aplicación de 16 letras, sin espacios>`, `MAIL_FROM=sucorreo@gmail.com`.

### 5. Ejecutar
Windows, con doble clic: abra **`iniciar_agrogest.bat`**. El archivo busca un JDK 21 instalado (aunque Windows use otra versión de Java por defecto), inicia la aplicación y abre el navegador. Para detenerla, cierre la ventana.

Windows, desde la terminal (con `JAVA_HOME` apuntando a un JDK 21):
```bash
mvnw.cmd spring-boot:run
```
Linux / macOS:
```bash
./mvnw spring-boot:run
```
Abra <http://localhost:8080> e ingrese con el usuario administrador configurado en `.env`.

Para generar un ejecutable `.jar`:
```bash
mvnw.cmd clean package
```
```bash
java -jar target/agrogest.jar
```

### 6. Ejecutar las pruebas
```bash
mvnw.cmd test
```
Las pruebas usan una base H2 en memoria, así que no modifican MySQL.

---

## 🗂️ Estructura del proyecto

```
agrogest/
├── database/agrogest_db.sql          Script MySQL (tablas, PK, FK, índices, restricciones, datos iniciales)
├── docs/                             Documentación técnica, manual de usuario, pruebas y guion del video
├── src/main/java/co/edu/uniremington/agrogest/
│   ├── config/        Configuración y datos iniciales seguros
│   ├── controller/    Controladores MVC (Acceso, Registro, Recuperación, Dashboard, Perfil, Usuario, Persona, Mi cuenta)
│   ├── dto/           Objetos de formulario con Bean Validation
│   ├── entity/        Entidades JPA (Perfil, Usuario, Persona, TokenRecuperacion, RegistroCorreo)
│   ├── exception/     Excepciones de negocio y manejo centralizado
│   ├── repository/    Repositorios Spring Data JPA
│   ├── security/      Spring Security, BCrypt, mensajes de acceso
│   ├── service/       Lógica de negocio y transacciones
│   └── validation/    Validaciones personalizadas (contraseña segura, confirmación, edad)
├── src/main/resources/
│   ├── templates/     Vistas Thymeleaf (auth, dashboard, perfiles, usuarios, personas, cuenta, correo, error)
│   ├── static/        CSS, JavaScript e imágenes SVG
│   ├── db/schema.sql  Esquema que la aplicación crea al arrancar
│   └── application.properties
├── src/test/          Pruebas unitarias y de integración
├── .env.example       Plantilla de configuración
└── pom.xml
```

## 📚 Documentación
- [Manual técnico](docs/manual-tecnico/README.md): requisitos, arquitectura, diagramas, modelo relacional y diccionario de datos.
- [Manual de usuario](docs/manual-usuario/README.md)
- [Documentación de pruebas](docs/pruebas/README.md)
- [Guion para el video de sustentación](docs/sustentacion/guion-video.md)
- [Trabajo en equipo y ramas Git](docs/equipo/README.md)

## 👥 Equipo
| Integrante | Rol |
|---|---|
| Integrante 1 | Backend y seguridad |
| Integrante 2 | Base de datos y lógica de negocio |
| Integrante 3 | Frontend y experiencia de usuario |
