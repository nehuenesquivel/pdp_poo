object rolando {
	var valorBase = 3
	var hechizoPreferido = hechizoEspecial

	method nivelDeHechiceria() = valorBase * hechizoPreferido.poder() + fuerzaOscura.valor()
	
	method hechizoPreferido(_hechizoPreferido) {
		hechizoPreferido = _hechizoPreferido
	}
	
	method poderoso() {
		return hechizoPreferido.poderoso()
	}
}

class Hechizo {
	method poder()

	method poderoso()
}

object hechizoEspecial inherits Hechizo {
	var nombre = "Espectro Malefico"

	override method poder() = nombre.size()

	override method poderoso() = self.poder() > 15

	method nombre(_nombre) {
		nombre = _nombre
	}
}

object hechizoBasico inherits Hechizo {
	override method poder() = 10

	override method poderoso() = false
}

object fuerzaOscura {
	var valor = 5

	method valor() = valor

	method duplicada() {
		valor = valor * 2
	}
}

object eclipse {
	method inicia() {
		fuerzaOscura.duplicada()
	}
}