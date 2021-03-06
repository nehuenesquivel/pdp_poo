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

	method habilidadParaLaLucha(personaje) = valorBaseDeLucha + self.unidadesDeLucha(personaje)
	
	method unidadesDeLucha(personaje) = artefactos.fold(0,{acum, artefacto =>acum + artefacto.unidadesDeLucha(personaje)})

	method agregarArtefacto(_artefacto) {
		artefactos.add(_artefacto)
	}

	method removerArtefacto(_artefacto) {
		artefactos.remove(_artefacto)
	}

	method mayorHabilidadParaLaLucha(personaje) = self.habilidadParaLaLucha(personaje) > self.nivelDeHechiceria()
	
		
	method mejorArtefacto(personaje) = artefactos.filter({ _artefacto => !_artefacto.esEspejo() }).sortedBy({ _artefacto1 , _artefacto2 => _artefacto1.unidadesDeLucha(personaje) > _artefacto2.unidadesDeLucha(personaje) }).head()
	
	
	method estaCargado() = artefactos.size() >= 5
	
	method cantidadDeArtefactos() = artefactos.size()
	
	method comprarArtefacto(_artefacto) {
		if((_artefacto.precio(self)) <= oro) {
			oro = oro - _artefacto.precio(self)
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

	override method poder() = nombre.size() * self.multiploPoder()
	override method poderoso() = self.poder() > 15
	
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
	method precio(personaje)
	method unidadesDeLucha(personaje)
	method esEspejo() = false
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
			return personaje.mejorArtefacto(personaje).unidadesDeLucha(personaje)
		}
	} 
	override method precio(personaje) = 90
	override method esEspejo() = true
}


class Armadura inherits Artefacto {
	var property refuerzo = ninguno
	var property valorBase = 2
	
	override method unidadesDeLucha(personaje) = valorBase + refuerzo.valor(personaje)
	override method precio(personaje) = valorBase + refuerzo.precio(self, personaje)
}

class Refuerzo {
	method valor(personaje)
	method precio(armadura, personaje)
}

class CotaDeMalla inherits Refuerzo {
	var property valorDeLucha = 1
	
	override method valor(personaje) = valorDeLucha	
	//override method precio(armadura, personaje) = armadura.unidadesDeLucha(personaje) / 2 
	override method precio(armadura, personaje) = (valorDeLucha / 2) - armadura.valorBase()
}

class Bendicion inherits Refuerzo {
	override method valor(personaje) = personaje.nivelDeHechiceria()
	override method precio(armadura, personaje) = 0
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