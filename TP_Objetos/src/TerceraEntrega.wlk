class Personaje {
	var property valorBaseDeHechiceria = 3
	var property hechizoPreferido
	var property valorBaseDeLucha = 1
	var artefactos = []
	var property oro = 100
	var property pesoMaximo = 200
	
	method artefactos() {
		return artefactos
	}

	method nivelDeHechiceria() = valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method poderoso() {
		return hechizoPreferido.poderoso()
	}

	method habilidadParaLaLucha() = valorBaseDeLucha + self.unidadesDeLucha()
	
	method unidadesDeLucha() = artefactos.fold(0,{acum, artefacto =>acum + artefacto.unidadesDeLucha(self)})

	method agregarArtefacto(_artefacto) {
		artefactos.add(_artefacto)
	}

	method removerArtefacto(_artefacto) {
		artefactos.remove(_artefacto)
	}

	method mayorHabilidadParaLaLucha() = self.habilidadParaLaLucha() > self.nivelDeHechiceria()
	
		
	method mejorArtefacto() = artefactos.filter({ _artefacto => !_artefacto.esEspejo() }).sortedBy({ _artefacto1 , _artefacto2 => _artefacto1.unidadesDeLucha(self) > _artefacto2.unidadesDeLucha(self) }).head()
	
	method estaCargado() = artefactos.size() >= 5
	
	method cantidadDeArtefactos() = artefactos.size()
	
	method pesoTotalArtefactos() = artefactos.map({artefacto => artefacto.pesoTotal()}).sum()
	
	method calcularCostoArtefacto(_artefacto, _comerciante) = _comerciante.precioArtefacto(_artefacto, self)
	
	method comprarArtefacto(_artefacto,_comerciante) {
		if(self.calcularCostoArtefacto(_artefacto,_comerciante) <= oro && (self.pesoTotalArtefactos() + _artefacto.pesoTotal()) <= pesoMaximo) {
			oro = oro - self.calcularCostoArtefacto(_artefacto,_comerciante)
			_artefacto.fechaDeCompra(new Date())
			artefactos.add(_artefacto)
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
	
	method calcularCostoHechizo(_hechizo,_artefacto, _comerciante) = (_hechizo.precio() - (hechizoPreferido.precio()/2)).max(0)
	
	method comprarHechizo(_hechizo,_artefacto, _comerciante) {
		if(self.calcularCostoHechizo(_hechizo,_artefacto, _comerciante) <= oro) {
			oro = oro - self.calcularCostoHechizo(_hechizo,_artefacto, _comerciante)
			hechizoPreferido = _hechizo
		} else {
			throw new Exception("No tiene oro suficiente")
		}
	}
}

class Comerciante {
	var property tipo = independiente
	var property comision = 0
	
	method precioArtefacto(_artefacto, personaje) = _artefacto.precio() + tipo.costoAdicionalArtefacto(_artefacto, personaje,self.comision())
	method precioHechizo(_hechizo,_artefacto, personaje) = _hechizo.precio(_artefacto) + tipo.costoAdicionalHechizo(_hechizo,_artefacto ,personaje,self.comision())
	method recategorizar() {
		if (tipo == registrado){
			tipo = ganancias
		} else if (tipo == independiente){
			if (self.noSupera21Porciento(comision*2)) {
					self.comision(comision*2)
			} else {
				tipo = registrado
			}
		}	
	}
	
	method noSupera21Porciento(_comision) {
		return (_comision <= 0.21)
	}
}

object independiente {
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	= comision
	method costoAdicionalHechizo(_hechizo, _artefacto, personaje, comision)	= comision
}

object registrado {
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	= _artefacto.precio()*0.21
	method costoAdicionalHechizo(_hechizo, _artefacto, personaje, comision)	= _hechizo.precio(_artefacto)*0.21
}

object ganancias {
	var property minimoNoImponible = 0
	
	method costoAdicionalArtefacto(_artefacto, personaje, comision)	{
		if (_artefacto.precio() > minimoNoImponible) {
			return (minimoNoImponible - _artefacto.precio()) * 0.35
		} else {
			return 0
		}
	}
	method costoAdicionalHechizo(_hechizo, _artefacto , personaje, comision)	{
		if (_hechizo.precio() > minimoNoImponible) {
			return (minimoNoImponible - _hechizo.precio()) * 0.35
		} else {
			return 0
		}
	}
}


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
	var property fechaDeCompra 
	
	method pesoTotal() = peso - self.factorDeCorreccion()
	method factorDeCorreccion() = 1.min((new Date()- fechaDeCompra)/100)
	method precio()
	method unidadesDeLucha(personaje)
	method esEspejo() = false
}

class Espada inherits Artefacto {
	override method unidadesDeLucha(personaje) = 3
	override method precio() = self.pesoTotal() * 5
}


class CollarDivino inherits Artefacto {
	var property cantidadDePerlas = 0

	override method unidadesDeLucha(personaje) = cantidadDePerlas
	override method precio() = cantidadDePerlas * 2
	override method pesoTotal() {
		return super() + 0.5 * cantidadDePerlas
	} 
}

class Mascara inherits Artefacto {
	var property unidadesDeLuchaMinimas = 4
	var property indiceDeOscuridad = 1
	var property personaje
	method valorDeLucha(personaje2) = fuerzaOscura.dividida() * indiceDeOscuridad
	override method unidadesDeLucha(personaje2) = unidadesDeLuchaMinimas.max(self.valorDeLucha(personaje2))
	override method precio() = 10 * indiceDeOscuridad
	override method pesoTotal() {
		if (self.valorDeLucha(personaje)>3 and indiceDeOscuridad != 0) {
			return super() + self.unidadesDeLucha(personaje) - 3
		} else {
			return super()
		}
	}
}


class Espejo inherits Artefacto {
	override method unidadesDeLucha(personaje) {
		if (personaje.artefactos().size() == 1) {
			return 0
		} else {
			return personaje.mejorArtefacto().unidadesDeLucha(personaje)
		}
	} 
	override method precio() = 90
	override method esEspejo() = true
}


class Armadura inherits Artefacto {
	var  property refuerzo = ninguno
	var property valorBase = 2
	
	override method unidadesDeLucha(personaje) = valorBase + refuerzo.valor(personaje)
	override method precio() = refuerzo.precio()
	override method pesoTotal() {
		return super() + self.refuerzo().peso()
	}
}

class Refuerzo {
	method peso() = 0
	method valor(personaje)
	method precio()
}

class CotaDeMalla inherits Refuerzo {
	var property valorDeLucha = 1
	var property peso = 1
	var property armadura = new Armadura()
	
	override method peso() = peso
	override method valor(personaje) = 1
	override method precio() = (valorDeLucha / 2) - armadura.valorBase() 
}

class Bendicion inherits Refuerzo {
	override method valor(personaje) = personaje.nivelDeHechiceria()
	override method precio() = 2
}

object ninguno inherits Refuerzo {
	override method valor(personaje) = 0
	override method precio() = 0
}

object libroDeHechizos inherits Hechizo {
	var hechizos = []
	var property peso = 10
	var property fechaDeCompra = new Date()
	
	method pesoTotal() = peso - self.factorDeCorreccion()
	method factorDeCorreccion() = 1.min((new Date()-fechaDeCompra)/1000)
	
	method agregarHechizo(_hechizo) {
		hechizos.add( _hechizo)
	}
	
	method hechizosPoderosos() = hechizos.filter({hechizo => hechizo.poderoso()})
	
	override method poder() = self.hechizosPoderosos().sum({hechizo => hechizo.poder()})

	override method poderoso() = self.hechizosPoderosos().length() > 0
	
	override method precio() = hechizos.size() * 10  + self.poder()
}

class NPC inherits Personaje {
	var property nivel

	override method habilidadParaLaLucha() = super() * nivel.valor()

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
