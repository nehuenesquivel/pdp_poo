object rolando {
	
	var hechiceria 
	
	var fuerzaOscura = 5
	
	var hechizoPreferido
	
	var habilidad = 1
	
	method calcularNivelHechiceria(_ataque){
		
	 	hechizoPreferido = _ataque
		
		if (eclipse.hayEclipse()){
			
			fuerzaOscura = fuerzaOscura * 2
		}
		
		hechiceria = (3*_ataque.poderDeAtaque())+fuerzaOscura
	}
	
	method verFuerzaOscura() {return fuerzaOscura}
	
	method nivelHechiceria(){return hechiceria}
	
	method cambiarHechizo(_hechizo){ hechizoPreferido = _hechizo }
	
	method esPoderoso() { return hechizoPreferido.saberSiEsPoderoso() }
	
	method cambiarHabilidadBase(cantidad){habilidad = cantidad}
	
	method habilidadDeLucha(_artefacto){
		
		habilidad = habilidad + _artefacto.aporte()
		
			
	}
	
	method saberHabilidadDeLucha(){return habilidad}
}

object espectroMalefico{
	
	var poder = 17
	
	var esPoderoso = true
	
	method poderDeAtaque(){return poder}
	
	method saberSiEsPoderoso(){return esPoderoso}
}

object hechizoBasico{
	
	var poder = 10
	
	var esPoderoso = false
	
	method poderDeAtaque(){return poder}
	
	method saberSiEsPoderoso(){return esPoderoso}
	
}

object eclipse{
	
	const presente = new Date()
	
	method hayEclipse() {
		
		return (presente.dayOfWeek()%2 == 0)
	}	
}

object espadaDelDestino{
	
	var poder = 3
	
	method aporte(){return poder}	
}

object collarDivino{
	
	var poder = 1
	
	var perlas = 1
	
	method aporte (){return (poder + perlas)}
}

object mascaraOscura{
	
	var poder = 4
		
	method aporte (){return poder}
}
