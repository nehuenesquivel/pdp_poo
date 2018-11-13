object rolando {
	var nivelDeHechizeria = (3*hechizoPreferido.poder())+fuerzaOscura.valor()
	var hechizoPreferido = espectroMalefico
	
	method hechizoPreferido() {
		return hechizoPreferido
	}

	method nivelDeHechizeria() {
		return nivelDeHechizeria
	}
	method seCreePoderoso() {
		hechizoPreferido.esPoderoso()
	}
}

object fuerzaOscura {
	var property valor = 5
	method eclipse() {
		valor *= 2
	}
}

object espectroMalefico {
	var nombre = "Espectro Malefico"
	
	method poder() {
		return nombre.length()
	}
	method esPoderoso() {
		return nombre.length()>15
	}
}
object hechizoBasico {
	method poder() {
		return 10
	}
	method esPoderonso() {
		return false
	}
}