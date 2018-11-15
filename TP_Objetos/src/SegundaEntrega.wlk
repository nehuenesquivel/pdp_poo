class Personaje {
	var valorBaseDeHechiceria = 3
	var hechizoPreferido
	var valorBaseDeLucha = 1
	var artefactos = []
	var oro = 100

	method nivelDeHechiceria() = valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method hechizoPreferido(_hechizoPreferido) {
		hechizoPreferido = _hechizoPreferido
	}

	method poderoso() {
		return hechizoPreferido.poderoso()
	}

	method habilidadParaLaLucha() = valorBaseDeLucha + self.unidadesDeLucha()
	
	method unidadesDeLucha() = artefactos.map({artefacto => artefacto.unidadesDeLucha(self)}).sum()

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
	
	method comprarArtefacto(_artefacto) {
		oro = oro - _artefacto.precio(self)
		artefactos = artefactos + [_artefacto]
	}
	
	method comprarHechizo(_hechizo) {
		oro = oro - (_hechizo.precio(self) - (hechizoPreferido.precio(self)/2)).max(0)
		hechizoPreferido = _hechizo
	}
}

object rolando inherits Personaje {}

class Hechizo {
	method poder()

	method poderoso()
}

class HechizoEspecial inherits Hechizo {
	var nombre = "Espectro Malefico"

	override method poder() = nombre.size()

	override method poderoso() = self.poder() > 15

	method nombre(_nombre) {
		nombre = _nombre
	}
	
	method valor() = self.poder()
}

class HechizoBasico inherits Hechizo {
	
	override method poder() = 10

	override method poderoso() = false
	
	method valor() = self.poder()
	
	method precio(personaje) = 10
}

class HechizoLogos inherits Hechizo {
	var nombre
	var multiploPoder

	override method poder() = nombre.size() * multiploPoder

	override method poderoso() = self.poder() > 15

	method multiploPoder(_multiploPoder) {
		multiploPoder = _multiploPoder
	}
	method nombre(_nombre) {
		nombre = _nombre
	}
	
	method valor() = self.poder()
	method precio(personaje) = self.poder()
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
	method precio(personaje)
	method unidadesDeLucha(personaje)
}

class Espada inherits Artefacto {
	override method unidadesDeLucha(personaje) = 3
	override method precio(personaje) = self.unidadesDeLucha(personaje) * 5
}

object espadaDelDestino inherits Espada {}

object collarDivino inherits Artefacto {
	var cantidadDePerlas = 0
	
	method cantidadDePerlas(_cantidadDePerlas) {
		cantidadDePerlas = _cantidadDePerlas
	}

	override method unidadesDeLucha(personaje) = cantidadDePerlas
	
	override method precio(personaje) = cantidadDePerlas * 2
}

class Mascara inherits Artefacto {
	var unidadesDeLuchaMinimas = 4
	var indiceDeOscuridad
	
	method indiceDeOscuridad(_indiceDeOscuridad) {
		indiceDeOscuridad = _indiceDeOscuridad
	}
	override method unidadesDeLucha(personaje) = unidadesDeLuchaMinimas.max(fuerzaOscura.dividida() * indiceDeOscuridad)
	
	override method precio(personaje) = 0
}

object mascaraOscura inherits Mascara {}

class Armadura inherits Artefacto {
	var refuerzo = ninguno
	
	method agregarRefuerzo(_refuerzo) {
		refuerzo = _refuerzo
	}
	
	override method unidadesDeLucha(personaje) = 2 + refuerzo.valor(personaje)
	
	override method precio(personaje) = refuerzo.precio(self)
}

class Refuerzo {
	method valor(personaje)
	method precio(armadura)
}

class CotaDeMalla inherits Refuerzo {
	override method valor(personaje) = 1
	override method precio(armadura) = armadura.unidadesDeLucha() / 2 
}

class Bendicion inherits Refuerzo {
	override method valor(personaje) = personaje.nivelDeHechiceria()
	override method precio(armadura) = 2
}

object ninguno inherits Refuerzo {
	override method valor(personaje) = 0
	override method precio(armadura) = 0
}

object espejo inherits Artefacto {
	override method unidadesDeLucha(personaje) = personaje.mejorArtefacto().unidadesDeLucha()
	override method precio(personaje) = 90
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
	
	method precio(personaje) = (hechizos.length() * 10) + hechizos.poder().sum() 
}