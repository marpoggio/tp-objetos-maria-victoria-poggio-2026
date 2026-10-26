import error.*

// ENTRADAS
class Entradas {
    const banda
    method banda() = banda
    const fecha
    method fecha() = fecha
    const precioBase = 1000

    method precioFinal() = precioBase + productora.precioExtra()
}

// ASISTENTES
class Asistentes {
    const tipoDeAbono
    const historialEntradas = []
    var property dineroDisponible

    method puedeComprar() = (dineroDisponible > 0)
    method comprar(entrada) {
        if (!self.puedeComprar()) {
            throw new SaldoInsuficienteException()
        }
        const montoPagar = entrada.precioFinal() - tipoDeAbono.porcentajeDescuento(entrada.precioFinal())
        historialEntradas.add(entrada)
        dineroDisponible -= montoPagar
        const banda = entrada.banda()
        banda.agregarEntradas(1, entrada.precioFinal())
    }
    method nombreBandas() = historialEntradas.map({ entrada => entrada.banda().nombre() }).asSet()
    method entradasAnioPasado() = historialEntradas.filter({ entrada => entrada.fecha().year() == new Date().year() - 1 })
    
    method bonificar() {
        tipoDeAbono.bonificar()
    }
}
// concepto: polimorfismo
class Fan {
    method porcentajeDescuento(precio) = 0
    method bonificar() {}
}
class Vip {
    var descuento
    method porcentajeDescuento(precio) = precio * descuento
    method bonificar() {
        descuento += 0.01
    }
}
// son clases para que asi el descuento de cada asistente viva dentro de ellos mismos.

// BANDAS
// concepto: herencia
class Banda {
    const nombre
    method nombre() = nombre
    method canon() = 1000000
    method gastoExtra()
    method presupuesto() = self.canon() + self.gastoExtra()
    method popularidad()

    var cantidadEntradas = 0
    var recaudacion = 0
    method cantidadEntradas() = cantidadEntradas
    method recaudacion() = recaudacion
    method agregarEntradas(cantidad, precio) { 
        cantidadEntradas += cantidad
        recaudacion += precio * cantidad
    }
}
class BandaRock inherits Banda {
    const cantidadSolosGuitarra

    override method gastoExtra() = 10000
    override method popularidad() = 100 * cantidadSolosGuitarra
}
class BandaTrap inherits Banda {
    const tieneHielo

    override method gastoExtra() = 0
    override method popularidad() {
        if (tieneHielo) {
            return 1000
        }
        else {
            return 0
        }
    }
    override method canon() = super() * self.popularidad()
}
class BandaIndie inherits Banda {
    const cantidadInstrumentos

    override method popularidad() = self.nombre().size() * 3.14
    override method gastoExtra() = cantidadInstrumentos * 500
}

//concepto: well known object
object productora { 
    const listaBandas = []
    const listaAsistentes = []
    // concepto: encapsulamiento
    method agregarBanda(banda) {
        listaBandas.add(banda)
    }
    method agregarAsistente(asistente) {
        listaAsistentes.add(asistente)
    }
    var property precioExtra = 10 //numero ejemplo.
    //aunque en el codigo no hay nada que cambia el precioExtra en si, por el "podría variar" me decidi por dejarlo en var en vez de const.
    
    //concepto (tambien en banda) : delegacion
    method presupuestoTotal() = listaBandas.sum({ banda => banda.presupuesto() })
    method ganancia() = listaBandas.sum({ banda => banda.recaudacion() })
    method gananciaTotal() = self.ganancia() - self.presupuestoTotal()

    method cantidadEntradasVendidas() = listaBandas.sum({ banda => banda.cantidadEntradas() })
    
    method bandaMasPopular() = listaBandas.max({ banda => banda.cantidadEntradas() })
    // max en vez de sortedBy() + first(), porque obtiene el mismo resultado sin ordenar toda la lista.
    method bonificarAsistentesVip() {
        listaAsistentes.forEach({ asistente => asistente.bonificar() })
    }
}
//la justificacion esta en el otro md: "justificaciones.md"
