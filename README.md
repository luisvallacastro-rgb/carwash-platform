# CarWash

Plataforma mobile-first para presentar servicios de lavado, consultar una orden de forma segura y operar las áreas de cliente, recepción, operación y administración.

## Arquitectura

- **Presentación:** Next.js/Vinext, React 19, TypeScript y Tailwind CSS 4. La experiencia se divide en sitio público, consulta, acceso, cliente, operación y administración.
- **Dominio:** reglas puras en `lib/domain.mjs` para transiciones, tiempos estimados, promociones, consulta pública y propiedad de órdenes.
- **Datos:** Cloudflare D1 + Drizzle ORM. `db/schema.ts` define 23 tablas, llaves foráneas, índices, restricciones y eliminación lógica. La migración generada está en `drizzle/`.
- **Seguridad:** el modelo contempla hash de contraseña, intentos fallidos, estados de usuario, RBAC, auditoría, control optimista mediante `version`, códigos de retiro con hash y consulta pública con código + teléfono.
- **Integraciones:** notificaciones y almacenamiento se mantienen detrás de proveedores configurables. Un fallo de entrega se registra y no bloquea la orden.

## Módulos y flujos

1. El cliente explora servicios y promociones administrables.
2. Recepción crea cliente, vehículo y orden; el cálculo suma duración, cola y ajuste autorizado.
3. El operador solo avanza por transiciones válidas, puede pausar y actualizar la estimación.
4. Cada cambio genera historial y auditoría; las notificaciones se procesan de forma independiente.
5. El cliente consulta con código único y teléfono, o desde su cuenta; nunca basta la placa.
6. Para entregar, el personal valida el código de retiro y marca la orden como entregada.

## Preparación local

Requisitos: Node.js 22.13 o posterior.

```bash
npm install
cp .env.example .env.local
npm run db:generate
npm run dev
```

Abre `http://localhost:3000`. El enlace `#track` abre la consulta, `#customer` el panel de cliente, `#operations` la operación y `#admin` la administración.

## Datos de demostración

Ejecuta `drizzle/seed.sql` después de la migración en una base D1 de desarrollo. Incluye seis roles, un administrador, una recepcionista, dos operadores, tres clientes, cuatro vehículos, ocho servicios y tres promociones. Las cadenas de contraseña del SQL son marcadores deliberadamente inválidos: el alta real debe producir PBKDF2/Argon2 mediante el adaptador de identidad del entorno.

Accesos interactivos de la maqueta funcional:

| Área | Correo | Contraseña de desarrollo |
|---|---|---|
| Cliente | `cliente@carwash.demo` | `Cliente123!` |
| Operación | `operador1@carwash.demo` | `Operador123!` |
| Administración | `admin@carwash.demo` | `Admin123!` |

También hay accesos directos en la pantalla de inicio de sesión. La consulta pública de demostración usa `CW-8472` y `7788-1122`.

> Estos accesos son solo para desarrollo. La plataforma de hosting utiliza identidad gestionada; antes de producción debe conectarse el formulario público al proveedor de identidad aprobado, conservar cookies HttpOnly/Secure/SameSite y habilitar verificación y rate limiting perimetral.

## Configuración

El nombre, logotipo, colores, ubicación, teléfonos, horarios, moneda, impuestos, métodos de pago, redes, plantillas, estados y políticas pertenecen a `business_settings`. Los valores actuales son demostrativos. `.env.example` no contiene secretos reales.

## Validación

```bash
npm run build
npm run lint
npm test
```

Las pruebas cubren transiciones inválidas, permisos de cancelación, cálculo de entrega, promociones, consulta con teléfono, enmascaramiento, aislamiento entre clientes y renderizado del sitio.

## Evolución recomendada

- Conectar el adaptador de identidad pública aprobado y sesiones seguras.
- Implementar Route Handlers sobre D1 para cada comando y control optimista con `version`.
- Conectar R2 para evidencias e imágenes con validación de tipo/tamaño.
- Añadir correo y WhatsApp/SMS a la cola de notificaciones; después SSE/WebSockets y push PWA.
- Incorporar pagos sin hacerlos requisito para el flujo operativo.
