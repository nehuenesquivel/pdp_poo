object rolando {
	var valorBaseDeHechiceria = 3
	var hechizoPreferido
	var valorBaseDeLucha = 1
	var artefactos = []

	method nivelDeHechiceria() = valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method hechizoPreferido(_hechizoPreferido) {
		hechizoPreferido = _hechizoPreferido
	}

	method poderoso() {
		return hechizoPreferido.poderoso()
	}

	method habilidadParaLaLucha() = valorBaseDeLucha + self.unidadesDeLucha()
	
	method unidadesDeLucha() = artefactos.map({artefacto => artefacto.unidadesDeLucha()}).sum()

	method valorBaseDeLucha(_valorBaseDeLucha) {
		valorBaseDeLucha = _valorBaseDeLucha
	}

	method agregarArtefacto(_artefacto) {
		artefactos = artefactos + [_artefacto]
	}

	method removerArtefacto(_artefacto) {
		artefactos = artefactos.filter({artefacto => artefacto != _artefacto})
	}

	method mayorHabilidadParaLaLucha() = self.habilidadParaLaLucha() > self.nivelDeHechiceria()
	
	method mejorArtefacto() = artefactos.sortedBy({artefacto1, artefacto2 => artefacto1.unidadesDeLucha() > artefacto2.unidadesDeLucha()}).head()
	
	method estaCargado() = artefactos.length() >= 5
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
	
	method valor() = self.poder()
}

object hechizoBasico inherits Hechizo {
	override method poder() = 10

	override method poderoso() = false
	
	method valor() = self.poder()
}

object fuerzaOscura {
	var valor = 5

	method valor() = valor

	method duplicada() {
		valor = valor * 2
	}
	
	method dividida() = valor / 2
}

object eclipse {
	method inicia() {
		fuerzaOscura.duplicada()
	}
}

class Artefacto {
	method unidadesDeLucha()
}

object espadaDelDestino inherits Artefacto {
	override method unidadesDeLucha() = 3
}

object collarDivino inherits Artefacto {
	var cantidadDePerlas = 0
	
	method cantidadDePerlas(_cantidadDePerlas) {
		cantidadDePerlas = _cantidadDePerlas
	}

	override method unidadesDeLucha() = cantidadDePerlas
}

object mascaraOscura inherits Artefacto {
	var unidadesDeLuchaMinimas = 4

	override method unidadesDeLucha() = unidadesDeLuchaMinimas.max(fuerzaOscura.dividida())
}

object armadura inherits Artefacto {
	var refuerzo = ninguno
	
	method agregarRefuerzo(_refuerzo) {
		refuerzo = _refuerzo
	}
	
	override method unidadesDeLucha() = 2 + refuerzo.valor()
}

class Refuerzo {
	method valor()
}

object cotaDeMalla inherits Refuerzo {
	override method valor() = 1
}

object bendicion inherits Refuerzo {
	override method valor() = rolando.nivelDeHechiceria()
}

object ninguno inherits Refuerzo {
	override method valor() = 0
}

object espejo inherits Artefacto {
	override method unidadesDeLucha() = rolando.mejorArtefacto().unidadesDeLucha()
}

object libroDeHechizos inherits Hechizo {
	var hechizos = []
	
	method agregarHechizo(_hechizo) {
		hechizos += _hechizo
	}
	
	method hechizosPoderosos() = hechizos.filter({hechizo => hechizo.poderoso()})
	
	override method poder() = self.hechizosPoderosos().poder().sum()

	override method poderoso() = self.hechizosPoderosos().length() > 0
	
	method valor() = self.poder()
}