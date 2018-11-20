object rolando {

	var valorBaseDeHechiceria = 3
	var hechizoPreferido
	var valorBaseDeLucha = 1
	const artefactos = []

	method nivelDeHechiceria() {
		try {
			return valorBaseDeHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()
		} catch e {
			return fuerzaOscura.valor()
		}
	}

	method hechizoPreferido(_hechizoPreferido) {
		hechizoPreferido = _hechizoPreferido
	}

	method poderoso() = hechizoPreferido.poderoso()

	method habilidadParaLaLucha() = valorBaseDeLucha + self.unidadesDeLucha()

	method unidadesDeLucha() = artefactos.sum({ _artefacto => _artefacto.unidadesDeLucha() })

	method valorBaseDeLucha(_valorBaseDeLucha) {
		valorBaseDeLucha = _valorBaseDeLucha
	}

	method agregarArtefacto(_artefacto) {
		artefactos.add(_artefacto)
	}

	method removerArtefacto(_artefacto) {
		artefactos.remove(_artefacto)
	}

	method mayorHabilidadParaLaLucha() = self.habilidadParaLaLucha() > self.nivelDeHechiceria()

	method mejorArtefacto() {
		try {
			return artefactos.filter({ _artefacto => _artefacto != espejo }).sortedBy({ _artefacto1 , _artefacto2 => _artefacto1.unidadesDeLucha() > _artefacto2.unidadesDeLucha() }).head()
		} catch e {
			return null
		}
	}

	method estaCargado() = artefactos.size() > 4

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

	override method unidadesDeLucha() = cantidadDePerlas

	method cantidadDePerlas(_cantidadDePerlas) {
		cantidadDePerlas = _cantidadDePerlas
	}

}

object mascaraOscura inherits Artefacto {

	var unidadesDeLuchaMinimas = 4

	override method unidadesDeLucha() = unidadesDeLuchaMinimas.max(self.unidadesDeLuchaOscuras())

	method unidadesDeLuchaOscuras() = fuerzaOscura.dividida()

}

object armadura inherits Artefacto {

	var unidadesDeLuchaBase = 2
	var refuerzo

	override method unidadesDeLucha() {
		try {
			return unidadesDeLuchaBase + refuerzo.valor()
		} catch e {
			return unidadesDeLuchaBase
		}
	}

	method refuerzo(_refuerzo) {
		refuerzo = _refuerzo
	}

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

object hechizo inherits Refuerzo {

	var hechizoActivo

	override method valor() = hechizoActivo.poder()

	method hechizoActivo(_hechizoActivo) {
		hechizoActivo = _hechizoActivo
	}

}

object espejo inherits Artefacto {

	override method unidadesDeLucha() {
		try {
			return rolando.mejorArtefacto().unidadesDeLucha()
		} catch e {
			return 0
		}
	}

}

object libroDeHechizos inherits Hechizo {

	const hechizos = []

	override method poder() = hechizos.filter({ _hechizo => _hechizo.poderoso() }).sum({ _hechizo => _hechizo.poder() })

	override method poderoso() = hechizos.any({ _hechizo => _hechizo.poderoso() })

	method agregarHechizo(_hechizo) {
		hechizos.add(_hechizo)
	}

	method removerHechizo(_hechizo) {
		hechizos.remove(_hechizo)
	}

}

