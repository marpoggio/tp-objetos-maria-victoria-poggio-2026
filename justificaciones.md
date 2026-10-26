## Justificación de conceptos y decisiones tomadas.
### Polimorfismo:
Se encuentra dentro de los tipos de abono **Fan** y **Vip**. Ambos entienden los mismos mensajes (`porcentajeDescuento()` y `bonificar()`). Asistentes no pregunta qué tipo de abono tiene con un if, ya que cada uno le responde a su manera. Esto hace el código más **declarativo**: `comprar` dice qué se quiere (el descuento que corresponda) y no cómo se calcula para cada caso, y si apareciera un abono nuevo no habría que tocar `Asistentes`.

### Herencia: 
**Banda** define lo que tienen en común todas las bandas, pero dejando `gastoExtra()` y `popularidad()` sin implementar, porque cada tipo de banda las resuelve distinto. `presupuesto()` está definido en la superclase ya que adentro usa métodos que las subclases cambian, pero siempre hace lo mismo. **BandaTrap** redefine además `canon()` usando `super()`. Se eligió **herencia** y no composición porque el tipo de una banda no cambia durante la ejecución: una banda de rock no pasa a ser de trap.
En cambio, para el abono se eligió **composición**: el asistente *tiene* un `tipoDeAbono` en lugar de que existan subclases como `AsistenteFan` y `AsistenteVip`. Esto es porque el abono es comportamiento que puede cambiar (un asistente podría pasar de fan a vip, y el descuento vip varía con `bonificar()`).

### Delegación: 
La **productora** delega en cada banda el contar las entradas y su recaudación (`banda.cantidadEntradas()`, `banda.recaudacion()`). Por eso después `presupuestoTotal()`, `ganancia()` y `cantidadEntradasVendidas` le piden el dato a cada banda en vez de calcularlo ellas mismas, productora solo los junta.
`Asistentes.bonificar()` delega en el **tipoDeAbono**, y **Entradas** delega en la productora el impuesto. 

### Encapsulamiento:
Las `listas` de la productora son privadas y solo se modifican con `agregarBanda()` y `agregarAsistente()`, en vez de con `property`. Al igual que con cantidadEntradas de las bandas, solo se altera con `agregarEntradas()`.

### Objeto bien conocido / Well Known Object: 
**productora** es único, no va a existir más de uno. Se encarga del `precioExtra` (impuesto a las entradas), que es el mismo para todas las entradas. Ahí vive el impuesto (precioExtra), en un solo lugar, y así, **Entradas** (o cualquier otro que puede necesitarlo) solo lo consulta desde la productora.

### Manejo de errores: 
En vez de ignorar que pasa cuando no se puede comprar, `SaldoInsuficienteException` es una **excepción propia**, definida en su archivo (`error.wlk`), que cuenta que fué lo que paso, debido a que el enunciado dice que deberá notificarse adecuadamente. `comprar`, cuando el saldo no es positivo, lo usa a través del `throw new ...`. Así, la notificación llega a quien intentó comprar y la compra no falla en silencio. El modelo solo lanza el error: quien use `comprar` (capaz alguien que le pida al asistente la compra) puede decidir qué hacer con un `try/catch`, que intenta la compra y, si el `catch` atrapa este error específico, maneja ese caso puntual (por ejemplo, mostrando el mensaje).

### Decisiones
Un `contador` de entradas y recaudación acumulada en cada venta de la propia banda, así, registro el precio vigente al momento de la compra, si el impuesto cambia, lo ya recaudado no se modifica, pero lo siguiente va a agregarse con el nuevo impuesto.

En `nombreBandas()` se hace primero `map` a los nombres y después `asSet()`, para que si un asistente compró varias entradas de la misma banda, el nombre no se repita.

Se registra `entrada.precioFinal()` y no lo que pagó el asistente, porque el enunciado dice que el descuento VIP lo cubren los sponsors, entonces no hay que tenerlo en cuenta en el calculo de la `gananciaTotal`.

`Fan` y `Vip` son `clases` para que el descuento de cada asistente viva en su propia instancia de Vip y no cargar a un asistente fan con un dato que no usa. Así, al crear un asistente, se hace: const persona = new Asistentes (tipoDeAbono = new Vip(descuento = 0.1), dineroDisponible...), con su propio descuento.
 
`productora` y su `precioExtra`, se declaró var property porque el enunciado dice que puede variar si así quisiera la productora, a pesar de que en el código no hay ninguna función que lo cambie.

En `bandaMasPopular`, al principio en el laboratorio lo había hecho como listaBandas.sortedBy({ banda1, banda2 => banda1.cantidadEntradas() > banda2.cantidadEntradas() }), lista.first(), pero me parecía muy largo, asi que buscando en la documentación de wollok lo acorte usando max(). El resultado es el mismo, con lo que había hecho primero la lista se ordena de manera que quede en la cabeza la banda que vendió más entradas, y después devuelvo esa. Con max, directamente lo que se hace es agarrar el que sea mayor, sin tener que ordenar. Además, max es más declarativo porque dice qué se busca, no cómo. Con `max`, el código expresa directamente "la banda con más entradas vendidas", mientras que `sortedBy` + `first` obliga a leer cómo se ordena para recién entender qué se busca.
