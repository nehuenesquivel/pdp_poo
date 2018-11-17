class Personaje {
	var property valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var artefactos = []
	var property oro = 100
	
	method artefactos() {
		return artefactos
	}

	method nivelDeHechiceria() = valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method poderoso() {
		return hechizoPreferido.poderoso()
	}

	method habilidadParaLaLucha() = valorBaseDeLucha + self.unidadesDeLucha()
	
	method unidadesDeLucha() = artefactos.map({artefacto => artefacto.unidadesDeLucha(self)}).sum()

	method agregarArtefacto(_artefacto) {
		artefactos.add(_artefacto)
	}

	method removerArtefacto(_artefacto) {
		artefactos.remove(_artefacto)
	}

	method mayorHabilidadParaLaLucha() = self.habilidadParaLaLucha() > self.nivelDeHechiceria()
	
	method mejorArtefacto() = artefactos.sortedBy({artefacto1, artefacto2 => artefacto1.unidadesDeLucha() > artefacto2.unidadesDeLucha()}).head()
	
	method estaCargado() = artefactos.size() >= 5
	
	method cantidadDeArtefactos() = artefactos.size()
	
	method comprarArtefacto(_artefacto) {
		if((_artefacto.precio(self)) <= oro) {
			oro = oro - _artefacto.precio(self)
			artefactos.add(_artefacto)
		}
	}
	
	method calcularCostoHechizo(_hechizo) = (_hechizo.precio() - (hechizoPreferido.precio()/2)).max(0)
	
	method comprarHechizo(_hechizo) {
		if(self.calcularCostoHechizo(_hechizo) <= oro) {
			oro = oro - self.calcularCostoHechizo(_hechizo)
			hechizoPreferido = _hechizo
		}
	}
}

/*object rolando inherits Personaje {}*/

class Hechizo {
	method poder()

	method poderoso()
	
	method valor(personaje) = self.poder()
}

class HechizoEspecial inherits Hechizo {
	var property nombre = "Espectro Malefico"

	override method poder() = nombre.length()

	override method poderoso() = self.poder() > 15
	
}

class HechizoBasico inherits Hechizo {
	
	override method poder() = 10
	override method poderoso() = false
	method precio() = 10
}

class HechizoLogos inherits Hechizo {
	var property nombre = "Hechizo Logos"
	var multiploPoder = 1

	override method poder() = nombre.length() * multiploPoder
	override method poderoso() = self.poder() > 15
	method multiploPoder(_multiploPoder) {
		multiploPoder = _multiploPoder
	}
	method precio() = self.poder()
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

/*object espadaDelDestino inherits Espada {}*/

class CollarDivino inherits Artefacto {
	var property cantidadDePerlas = 0

	override method unidadesDeLucha(personaje) = cantidadDePerlas
	override method precio(personaje) = cantidadDePerlas * 2
}

class Mascara inherits Artefacto {
	var property unidadesDeLuchaMinimas = 4
	var property indiceDeOscuridad = 0
	
	override method unidadesDeLucha(personaje) = unidadesDeLuchaMinimas.max(fuerzaOscura.dividida() * indiceDeOscuridad)
	override method precio(personaje) = 0
}

/*object mascaraOscura inherits Mascara {}*/


class Espejo inherits Artefacto {
	override method unidadesDeLucha(personaje) {
		if (personaje.artefactos().size() == 1) {
			return 0
		} else {
			return personaje.mejorArtefacto().unidadesDeLucha(personaje)
		}
	} 
	override method precio(personaje) = 90
}


class Armadura inherits Artefacto {
	var  property refuerzo = ninguno
	
	override method unidadesDeLucha(personaje) = 2 + refuerzo.valor(personaje)
	override method precio(personaje) = refuerzo.precio(self, personaje)
}

class Refuerzo {
	method valor(personaje)
	method precio(armadura, personaje)
}

class CotaDeMalla inherits Refuerzo {
	override method valor(personaje) = 1
	override method precio(armadura, personaje) = armadura.unidadesDeLucha(personaje) / 2 
}

class Bendicion inherits Refuerzo {
	override method valor(personaje) = personaje.nivelDeHechiceria()
	override method precio(armadura, personaje) = 2
}

object ninguno inherits Refuerzo {
	override method valor(personaje) = 0
	override method precio(armadura, personaje) = 0
}

object libroDeHechizos inherits Hechizo {
	var hechizos = []
	
	method agregarHechizo(_hechizo) {
		hechizos.add( _hechizo)
	}
	
	method hechizosPoderosos() = hechizos.filter({hechizo => hechizo.poderoso()})
	
	override method poder() = self.hechizosPoderosos().poder().sum()

	override method poderoso() = self.hechizosPoderosos().length() > 0
	
	method precio() = (hechizos.length() * 10) + hechizos.poder().sum() 
}