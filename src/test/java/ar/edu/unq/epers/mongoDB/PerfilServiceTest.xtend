package ar.edu.unq.epers.mongoDB

import ar.edu.unq.epers.aterrizar.servicios.PerfilService
import org.junit.Assert
import org.junit.Test
import org.junit.Before
import ar.edu.unq.epers.aterrizar.home.MongoHome
import ar.edu.unq.epers.aterrizar.servicios.DocumentsServiceRunner
import org.junit.After
import ar.edu.unq.epers.aterrizar.model.Usuario
import ar.edu.unq.epers.aterrizar.model.Destiny
import ar.edu.unq.epers.aterrizar.servicios.SocialNetworkingService
import ar.edu.unq.epers.aterrizar.model.Perfil
import ar.edu.unq.epers.aterrizar.model.Comment
import ar.edu.unq.epers.aterrizar.model.Like
import ar.edu.unq.epers.aterrizar.model.Dislike
import ar.edu.unq.epers.aterrizar.model.Visibility
import ar.edu.unq.epers.aterrizar.servicios.TramoService
import ar.edu.unq.epers.aterrizar.servicios.AsientoService
import ar.edu.unq.epers.aterrizar.model.Asiento
import ar.edu.unq.epers.aterrizar.model.Tramo
import ar.edu.unq.epers.aterrizar.home.BaseHome

class PerfilServiceTest {
	PerfilService service
	MongoHome<Perfil> home
	Usuario usuarioPepe
	Usuario usuarioLuis
	Usuario usuarioJuanAmigoDeNadie
	Destiny marDelPlataDestiny
	Destiny cancunDestiny
	Destiny barilocheDestiny
	Destiny bahiaBlancaDestiny
	Comment queFrio
	Comment queCalor
	Comment queAburrido
	Like likePepe
	Dislike dislikePepe
	SocialNetworkingService socialService
	TramoService tramoService
	Visibility visibilityPrivado
	Visibility visibilityPublico
	Visibility visibilityAmigos
	AsientoService asientoService
	BaseHome homeBase
	Asiento asiento
	Tramo tramo
	
	@Before
	def void setUp() {
		
		home = DocumentsServiceRunner.instance().collection(Perfil)
		socialService = new SocialNetworkingService
		tramoService = new TramoService
		service = new PerfilService(home, socialService, tramoService)
		usuarioPepe = new Usuario()
		usuarioPepe.nombreDeUsuario = "pepe"
		usuarioLuis = new Usuario()
		usuarioLuis.nombreDeUsuario = "luis"
		usuarioJuanAmigoDeNadie = new Usuario()
		usuarioJuanAmigoDeNadie.nombreDeUsuario = "juan"
		marDelPlataDestiny = new Destiny()
		marDelPlataDestiny.nombre = "Mar del plata"
		cancunDestiny = new Destiny()
		cancunDestiny.nombre = "cancun"
		barilocheDestiny = new Destiny()
		barilocheDestiny.nombre = "bariloche"
		bahiaBlancaDestiny = new Destiny()
		bahiaBlancaDestiny.nombre = "bahiaBlanca"
		queFrio = new Comment("que frio")
		likePepe = new Like("pepe")
		dislikePepe = new Dislike("pepe")
		visibilityPrivado = Visibility.PRIVADO
		visibilityPublico = Visibility.PUBLICO
		visibilityAmigos = Visibility.AMIGOS
		queCalor = new Comment("que calor")
		queAburrido = new Comment("que aburrido")
		tramoService = new TramoService
		asientoService = new AsientoService
		asiento = new Asiento
		tramo = new Tramo("Berazategui", "Mar del plata")
		homeBase = new BaseHome
	}
	
	@Test
	def void getPerfil() {
		service.addPerfil(usuarioPepe)
		var perfilPepe = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepe.username, "pepe")
		service.addPerfil(usuarioLuis)
		var perfilLuis = service.getPerfil(usuarioLuis)
		Assert.assertEquals(perfilLuis.username, "luis")
	}
	
	@Test
	def void addDestinyTest() {
		service.addPerfil(usuarioPepe)
		asientoService.guardar(asiento)
		asientoService.reservarAsientoParaUsuario(asiento, usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		var perfilPepe = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepe.destinations.size, 1)
		Assert.assertEquals(perfilPepe.destinations.get(0).nombre, "Mar del plata")	
	}
	  
	@Test
	def void addCommentTest() {
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addComment(usuarioPepe, marDelPlataDestiny, queFrio)
		val perfilPepe = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepe.destinations.get(0).comments.size, 1)
		Assert.assertEquals(perfilPepe.destinations.get(0).comments.get(0).description, "que frio")
	}
	
	 
	@Test
	def void addLikeTest() {
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addlike(usuarioPepe, marDelPlataDestiny)
		val perfil_pepe = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfil_pepe.destinations.get(0).likes.size, 1)
		Assert.assertEquals(perfil_pepe.destinations.get(0).likes.get(0).username, "pepe")
		service.addlike(usuarioPepe, marDelPlataDestiny)
		Assert.assertEquals(perfil_pepe.destinations.get(0).likes.size, 1)
	}
	 
	
	@Test
	def void addDislikeTest() {
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addDislike(usuarioPepe, marDelPlataDestiny)
		val perfilPepe = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepe.destinations.get(0).dislikes.size, 1)
		Assert.assertEquals(perfilPepe.destinations.get(0).dislikes.get(0).username, "pepe")
		service.addDislike(usuarioPepe, marDelPlataDestiny)
		Assert.assertEquals(perfilPepe.destinations.get(0).dislikes.size, 1)
		service.addlike(usuarioPepe, marDelPlataDestiny)
		Assert.assertEquals(perfilPepe.destinations.get(0).likes.size, 0)
		Assert.assertEquals(perfilPepe.destinations.get(0).dislikes.size, 1)
	}
	  
	   
	@Test
	def void addVisibilityDestinyTest() {
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, visibilityPrivado)
		val perfilPepePrivado = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepePrivado.destinations.get(0).visibility.toString, "PRIVADO")
		service.addVisibility(usuarioPepe, marDelPlataDestiny, visibilityPublico)
		val perfilPepePublico = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepePublico.destinations.get(0).visibility.toString, "PUBLICO")
	}
	
	@Test
	def void addVisibilityCommentTest() {
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addComment(usuarioPepe, marDelPlataDestiny, queFrio)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queFrio, visibilityPrivado)
		val perfilPepePrivado = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepePrivado.destinations.get(0).comments.get(0).visibility.toString, "PRIVADO")
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queFrio, visibilityPublico)
		val perfilPepePublico = service.getPerfil(usuarioPepe)
		Assert.assertEquals(perfilPepePublico.destinations.get(0).comments.get(0).visibility.toString, "PUBLICO")
	}
	 
	  
	@Test
	def void stalkearYoMismoTest() {
		socialService.agregarPersona(usuarioPepe)
		service.addPerfil(usuarioPepe)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addComment(usuarioPepe, marDelPlataDestiny, queFrio)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, visibilityPrivado)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queFrio, visibilityPrivado)
		val perfilPepe = service.stalkear(usuarioPepe, usuarioPepe)
		Assert.assertEquals(perfilPepe.destinations.get(0).visibility.toString, "PRIVADO")
		Assert.assertEquals(perfilPepe.destinations.get(0).comments.get(0).visibility.toString, "PRIVADO")
	}
	
	@Test
	def void stalkearNoAmigoTest() {
		socialService.agregarPersona(usuarioPepe)
		socialService.agregarPersona(usuarioJuanAmigoDeNadie)
		service.addPerfil(usuarioPepe)
		service.addPerfil(usuarioJuanAmigoDeNadie)
		service.addDestiny(usuarioPepe, marDelPlataDestiny)
		service.addComment(usuarioPepe, marDelPlataDestiny, queFrio)
		service.addDestiny(usuarioPepe, bahiaBlancaDestiny)
		service.addDestiny(usuarioPepe, barilocheDestiny)
		service.addComment(usuarioPepe, marDelPlataDestiny, queCalor)
		service.addComment(usuarioPepe, marDelPlataDestiny, queAburrido)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, visibilityPublico)
		service.addVisibility(usuarioPepe, bahiaBlancaDestiny, visibilityPrivado)
		service.addVisibility(usuarioPepe, barilocheDestiny, visibilityAmigos)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queFrio, visibilityPublico)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queCalor, visibilityPrivado)
		service.addVisibility(usuarioPepe, marDelPlataDestiny, queAburrido, visibilityAmigos)
		val perfilPepe = service.stalkear(usuarioPepe, usuarioJuanAmigoDeNadie)
		Assert.assertEquals(perfilPepe.destinations.size, 1)
		Assert.assertEquals(perfilPepe.destinations.get(0).nombre, "Mar del plata")
		Assert.assertEquals(perfilPepe.destinations.get(0).comments.size, 1)
		Assert.assertEquals(perfilPepe.destinations.get(0).comments.get(0).description, "que frio")
	}
	
	@Test
	def void stalkearAmigoTest() {
		socialService.agregarPersona(usuarioPepe)
		socialService.agregarPersona(usuarioLuis)
		service.addPerfil(usuarioPepe)
		service.addPerfil(usuarioLuis)
		socialService.amigoDe(usuarioPepe, usuarioLuis)
		service.addDestiny(usuarioLuis, marDelPlataDestiny)
		service.addComment(usuarioLuis, marDelPlataDestiny, queFrio)
		service.addDestiny(usuarioLuis, bahiaBlancaDestiny)
		service.addDestiny(usuarioLuis, barilocheDestiny)
		service.addComment(usuarioLuis, marDelPlataDestiny, queCalor)
		service.addComment(usuarioLuis, marDelPlataDestiny, queAburrido)
		service.addVisibility(usuarioLuis, marDelPlataDestiny, visibilityPublico)
		service.addVisibility(usuarioLuis, bahiaBlancaDestiny, visibilityPrivado)
		service.addVisibility(usuarioLuis, barilocheDestiny, visibilityAmigos)
		service.addVisibility(usuarioLuis, marDelPlataDestiny, queFrio, visibilityPublico)
		service.addVisibility(usuarioLuis, marDelPlataDestiny, queCalor, visibilityPrivado)
		service.addVisibility(usuarioLuis, marDelPlataDestiny, queAburrido, visibilityAmigos)
		val perfilLuis = service.stalkear(usuarioPepe, usuarioLuis)
		Assert.assertEquals(perfilLuis.destinations.size, 2)
		Assert.assertEquals(perfilLuis.destinations.get(0).nombre, "Mar del plata")
		Assert.assertEquals(perfilLuis.destinations.get(1).nombre, "bariloche")
		Assert.assertEquals(perfilLuis.destinations.get(0).comments.size, 2)
		Assert.assertEquals(perfilLuis.destinations.get(0).comments.get(0).description, "que frio")
		Assert.assertEquals(perfilLuis.destinations.get(0).comments.get(1).description, "que aburrido")
	}
	
	
	@After
	def void cleanDB(){
		home.mongoCollection.drop
		homeBase.hqlTruncate('asiento')
        homeBase.hqlTruncate('usuario')
	}
}