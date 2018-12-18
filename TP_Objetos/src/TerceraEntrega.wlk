class Personaje {
	var property valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var artefactos = []
	var property oro = 100
	var property pesoMaximo = 200
	
	/*constructor (_pesoMaximo) {
		pesoMaximo = _pesoMaximo
	}*/
	
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
	
	method pesoTotalArtefactos() = artefactos.map({artefacto => artefacto.pesoTotal(self)}).sum()
	
	method calcularCostoArtefacto(_artefacto, _comerciante) = _comerciante.precioArtefacto(_artefacto, self)
	
	method comprarArtefacto(_artefacto,_comerciante) {
		if(self.calcularCostoArtefacto(_artefacto,_comerciante) <= oro && (self.pesoTotalArtefactos() + _artefacto.pesoTotal(self)) <= pesoMaximo) {
			oro = oro - self.calcularCostoArtefacto(_artefacto,_comerciante)
			_artefacto.fechaDeCompra(new Date())
			artefactos.add(_artefacto)
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
	
	method calcularCostoHechizo(_hechizo, _comerciante) = (_comerciante.precioHechizo(_hechizo, self) - (hechizoPreferido.precio()/2)).max(0)
	
	method comprarHechizo(_hechizo, _comerciante) {
		if(self.calcularCostoHechizo(_hechizo, _comerciante) <= oro) {
			oro = oro - self.calcularCostoHechizo(_hechizo, _comerciante)
			hechizoPreferido = _hechizo
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
}

class Comerciante {
	var property tipo = registrado
	var property comision = 0
	
	method precioArtefacto(_artefacto, personaje) = _artefacto.precio(personaje) + tipo.costoAdicionalArtefacto(_artefacto, personaje, comision)
	method precioHechizo(_hechizo, personaje) = _hechizo.precio() + tipo.costoAdicionalHechizo(_hechizo, personaje, comision)
}

object independiente {
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	= comision
	method costoAdicionalHechizo(_hechizo, personaje, comision)	= comision
}
object registrado {
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	= _artefacto.precio(personaje)*0.21
	method costoAdicionalHechizo(_hechizo, personaje, comision)	= _hechizo.precio()*0.21
}
object ganancias {
	const property minimoNoImponible = 0
	
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	{
		if (_artefacto.precio(personaje) > minimoNoImponible) {
			return (minimoNoImponible - _artefacto.precio(personaje)) * 0.35
		} else {
			return 0
		}
	}
	method costoAdicionalHechizo(_hechizo, personaje, comision)	{
		if (_hechizo.precio() > minimoNoImponible) {
			return (minimoNoImponible - _hechizo.precio()) * 0.35
		} else {
			return 0
		}
	}
}

/*object rolando inherits Personaje {}*/

class Hechizo {
	
	method poder()

	method poderoso()
	
	method valor(personaje) = self.poder()
	
	method peso() {
		if (self.poderPar()){
			return 2
		} else {
			return 1
		}
	}
	
	method poderPar() {
		return (self.poder()%2) == 0
	} 
	
	method precio() = self.poder()
}

class HechizoEspecial inherits Hechizo {
	var property nombre = "Espectro Malefico"

	override method poder() = nombre.size()

	override method poderoso() = self.poder() > 15
	
}

class HechizoBasico inherits Hechizo {
	
	override method poder() = 10
	override method poderoso() = false
}

class HechizoLogos inherits Hechizo {
	var property nombre = "Hechizo Logos"
	var property multiploPoder = 1

	override method poder() = nombre.size() * (self.multiploPoder())
	override method poderoso() = self.poder() > 15
	method multiploPoder(_multiploPoder) {
		multiploPoder = _multiploPoder
	}
}

class HechizoComercial inherits Hechizo {
	const nombre = "El Hechizo Comercial"
	var porcentaje = 20
	var multiplicador = 2

	override method poder() = nombre.length() * (porcentaje / 100) * multiplicador

	override method poderoso() = self.poder() > 15

	method porcentaje(_porcentaje) {
		porcentaje = _porcentaje
	}

	method multiplicador(_multiplicador) {
		multiplicador = _multiplicador
	}
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
	var property fechaDeCompra = new Date()
	
	method pesoTotal(personaje) = peso - self.factorDeCorreccion()
	method factorDeCorreccion() = 1.min((new Date()-fechaDeCompra)/1000)
	method precio(personaje)
	method unidadesDeLucha(personaje)
	method esEspejo() = false
}

class Espada inherits Artefacto {
	override method unidadesDeLucha(personaje) = 3
	override method precio(personaje) = self.pesoTotal(personaje) * 5
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
	override method precio(personaje) = 10 * indiceDeOscuridad
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
	override method esEspejo() = true
}


class Armadura inherits Artefacto {
	var  property refuerzo = ninguno
	var property valorBase = 2
	
	override method unidadesDeLucha(personaje) = valorBase + refuerzo.valor(personaje)
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
	var property valorDeLucha = 1
	var property peso = 1
	
	override method peso() = peso
	override method valor(personaje) = 1
	//override method precio(armadura, personaje) = armadura.unidadesDeLucha(personaje) / 2
	override method precio(armadura, personaje) = (valorDeLucha / 2) - armadura.valorBase() 
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
	var property peso = 10
	var property fechaDeCompra = new Date()
	
	method pesoTotal(personaje) = peso - self.factorDeCorreccion()
	method factorDeCorreccion() = 1.min((new Date()-fechaDeCompra)/1000)
	
	method agregarHechizo(_hechizo) {
		hechizos.add( _hechizo)
	}
	
	method hechizosPoderosos() = hechizos.filter({hechizo => hechizo.poderoso()})
	
	override method poder() = self.hechizosPoderosos().sum({hechizo => hechizo.poder()})

	override method poderoso() = self.hechizosPoderosos().length() > 0
	
	method precio(personaje) = hechizos.size() * 10  + self.poder()
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
