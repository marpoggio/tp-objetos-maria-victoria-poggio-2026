// ENTRADAS
class Entradas {
    const banda
    method banda() = banda
    const fecha
    method fecha() = fecha
    const precioBase = 1000
    const precioExtra = 0

    method precioFinal() = precioBase + precioExtra
}

// ASISTENTES
class Asistentes {
    const tipoDeAbono // objetos fan o vip
    const historialEntradas = []
    var property dineroDisponible
    var property descuento // ??
    
    method agregarDescuento(cantidad) { //para poder cambiar el valor desde otras clases
        descuento += cantidad
    }

    method puedeComprar() = (dineroDisponible > 0) //throw error? -> "deberá notificarse adecuadamente"
    method comprar(entrada) {
        if (self.puedeComprar()) {
            const montoPagar = entrada.precioFinal() - tipoDeAbono.porcentajeDescuento(entrada, self)
            historialEntradas.add(entrada)
            dineroDisponible =- montoPagar
            const banda = entrada.banda()
            banda.agregarEntradas(1)
        }
    }
    method nombreBandas() = historialEntradas.asSet().map({ entrada => entrada.banda() })
    const hoy = new Date()
    method entradasAnioPasado() = historialEntradas.filter({ entrada => entrada.fecha().year() == hoy.minusYears(1) })
}
object fan {
    method porcentajeDescuento(entrada, asistente) = 0
}
object vip {
    method porcentajeDescuento(entrada, asistente) = entrada.precioFinal() * (asistente.descuento()) //asistente.descuento es el porcentaje de descuento particular para cada asistente, solo de los vips
} // o clase tipo abono con estas que heredan?

// BANDAS
class Banda {
    const nombre
    method nombre() = nombre
    method canon() = 1000000
    method gastoExtra()
    method presupuesto() = self.canon() + self.gastoExtra()
    method popularidad()

    var property cantidadEntradas
    method agregarEntradas(cantidad) { 
        cantidadEntradas += cantidad
    }
}
class BandaRock inherits Banda {
    const cantidadSolosGuitarra
    method cantidadSolosGuitarra() = cantidadSolosGuitarra

    override method gastoExtra() = 10000
    override method popularidad() = 100 * self.cantidadSolosGuitarra()
}
class BandaTrap inherits Banda {
    const tieneHielo
    method tieneHielo() = tieneHielo

    override method gastoExtra() = 0
    override method popularidad() {
        if (self.tieneHielo()) {
            return 1000
        }
        else {
            return 0
        }
    }
    override method canon() = 1000000 * self.popularidad() //??
}
class BandaIndie inherits Banda {
    const cantidadInstrumentos
    method cantidadInstrumentos() = cantidadInstrumentos

    override method popularidad() = self.nombre().size() * 3.14
    override method gastoExtra() = self.cantidadInstrumentos() * 500
}

class Productora { //revisar
    const property listaBandas = [] // #{}? ??
    
    var property presupuestoTotal
    const property presupuestoBandas = listaBandas.forEach({ banda => presupuestoTotal += banda.presupuesto()})
    
    var property cantidadEntradasVendidasTotales
    const property cantidadEntradasVendidas = listaBandas.forEach({ banda => cantidadEntradasVendidasTotales += banda.cantidadEntradas() })
    
    method gananciaTotal(entradas) = (self.cantidadEntradasVendidasTotales() * entradas.precioFinal()) - self.presupuestoTotal()
    method bandaMasPopular() {
        const lista = listaBandas.sortedBy({ banda1, banda2 => banda1.cantidadEntradas() > banda2.cantidadEntradas() })
        return lista.first()
    }
    method bonificarAsistentesVip(asistente) {
        if (asistente.tipoDeAbono() == "vip") { // ?
            asistente.agregarDescuento(0.01)
        }
    }
}
