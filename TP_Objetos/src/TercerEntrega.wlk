class Personaje {
	var property valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var artefactos = []
	var property oro = 100
	const property pesoMaximo
	
	constructor (_pesoMaximo) {
		pesoMaximo = _pesoMaximo
	}
	
	method artefactos() {
		return artefactos
	}

	method nivelDeHechiceria() = valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method poderoso() {
		return hechizoPreferido.poderoso()
	}

	method habilidadParaLaLucha(personaje) = valorBaseDeLucha + self.unidadesDeLucha(personaje)
	
	method unidadesDeLucha(personaje) = artefactos.map({artefacto => artefacto.unidadesDeLucha(self)}).sum()

	method agregarArtefacto(_artefacto) {
		artefactos.add(_artefacto)
	}

	method removerArtefacto(_artefacto) {
		artefactos.remove(_artefacto)
	}

	method mayorHabilidadParaLaLucha(personaje) = self.habilidadParaLaLucha(personaje) > self.nivelDeHechiceria()
	
		
	method mejorArtefacto(personaje) = artefactos.sortedBy({artefacto1, artefacto2 => artefacto1.unidadesDeLucha(personaje) > artefacto2.unidadesDeLucha(personaje)}).head()
	
	
	method estaCargado() = artefactos.size() >= 5
	
	method cantidadDeArtefactos() = artefactos.size()
	
	method pesoTotalArtefactos() = artefactos.map({artefacto => artefacto.pesoTotal(self)}).sum()
	
	method comprarArtefacto(_artefacto) {
		if((_artefacto.precio(self)) <= oro && (self.pesoTotalArtefactos() + _artefacto.pesoTotal(self)) <= pesoMaximo) {
			oro = oro - _artefacto.precio(self)
			_artefacto.fechaDeCompra(new Date())
			artefactos.add(_artefacto)
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
	
	method calcularCostoHechizo(_hechizo,_artefacto) = (_hechizo.precio(self,_artefacto) - (hechizoPreferido.precio(self,_artefacto)/2)).max(0)
	
	method comprarHechizo(_hechizo,_artefacto) {
		if(self.calcularCostoHechizo(_hechizo,_artefacto) <= oro) {
			oro = oro - self.calcularCostoHechizo(_hechizo,_artefacto)
			hechizoPreferido = _hechizo
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
}

/*object rolando inherits Personaje {}*/

class Hechizo {
	
	method poder()

	method poderoso()
	
	method valor(personaje) = self.poder()
	
	method peso() {
		if (self.poder().isOdd()){
			return 2
		} else {
			return 1
		}
	}
}

class HechizoEspecial inherits Hechizo {
	var property nombre = "Espectro Malefico"

	override method poder() = nombre.size()

	override method poderoso() = self.poder() > 15
	
}

class HechizoBasico inherits Hechizo {
	
	override method poder() = 10
	override method poderoso() = false
	method precio(armadura,personaje) = 10
}

class HechizoLogos inherits Hechizo {
	var property nombre = "Hechizo Logos"
	var property multiploPoder = 1

	override method poder() = nombre.size() * (self.multiploPoder())
	override method poderoso() = self.poder() > 15
	method multiploPoder(_multiploPoder) {
		multiploPoder = _multiploPoder
	}
	method precio(armadura,personaje) = self.poder()
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
	var property peso
	var property fechaDeCompra
	
	method pesoTotal(personaje) = peso - self.factorDeCorreccion()
	method factorDeCorreccion() = 1.max((new Date()-fechaDeCompra)/1000)
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
	override method pesoTotal(personaje) {
		return super(personaje) + 0.5 * cantidadDePerlas
	} 
}

class Mascara inherits Artefacto {
	var property unidadesDeLuchaMinimas = 4
	var property indiceDeOscuridad = 0
	
	override method unidadesDeLucha(personaje) = unidadesDeLuchaMinimas.max(fuerzaOscura.dividida() * indiceDeOscuridad)
	override method precio(personaje) = 0
	override method pesoTotal(personaje) {
		if (self.unidadesDeLucha(personaje)>3) {
			return super(personaje) + self.unidadesDeLucha(personaje) - 3
		} else {
			return super(personaje)
		}
	}
}

/*object mascaraOscura inherits Mascara {}*/


class Espejo inherits Artefacto {
	override method unidadesDeLucha(personaje) {
		if (personaje.artefactos().size() == 1) {
			return 0
		} else {
			return personaje.mejorArtefacto(personaje).unidadesDeLucha(personaje)
		}
	} 
	override method precio(personaje) = 90
}


class Armadura inherits Artefacto {
	var  property refuerzo = ninguno
	
	override method unidadesDeLucha(personaje) = 2 + refuerzo.valor(personaje)
	override method precio(personaje) = refuerzo.precio(self, personaje)
	override method pesoTotal(personaje) {
		return super(personaje) + self.refuerzo().peso()
	}
}

class Refuerzo {
	method peso() = 0
	method valor(personaje)
	method precio(armadura, personaje)
}

class CotaDeMalla inherits Refuerzo {
	var property peso = 1
	
	override method peso() = peso
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
	
	override method poder() = self.hechizosPoderosos().sum({hechizo => hechizo.poder()})

	override method poderoso() = self.hechizosPoderosos().length() > 0
	
	method precio(personaje) = hechizos.size() * 10  + self.poder()
}

object hechizoComercial inherits Hechizo {
	const nombre = "El Hechizo Comercial"
	var porcentaje = 20
	var multiplicador = 2

	override method poder() = nombre.length() * porcentaje / 100 * multiplicador

	override method poderoso() = self.poder() > 15

	method porcentaje(_porcentaje) {
		porcentaje = _porcentaje
	}

	method multiplicador(_multiplicador) {
		multiplicador = _multiplicador
	}
}

class NPC inherits Personaje {
	var nivel

	override method habilidadParaLaLucha(_personaje) = super(_personaje) * nivel.valor()

	method nivel(_nivel) {
		nivel = _nivel
	}
}

class Nivel {
	var valor

	constructor(_valor) {
		valor = _valor
	}
	
	method valor() = valor
}

object facil inherits Nivel(1) {}

object moderado inherits Nivel(2) {}

object dificil inherits Nivel(4) {}
