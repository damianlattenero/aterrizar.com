package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.home.MongoHome
import ar.edu.unq.epers.aterrizar.model.Usuario
import ar.edu.unq.epers.aterrizar.model.Destiny
import ar.edu.unq.epers.aterrizar.model.Visibility
import ar.edu.unq.epers.aterrizar.model.Comment
import ar.edu.unq.epers.aterrizar.model.Perfil
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.model.Like
import ar.edu.unq.epers.aterrizar.model.Dislike
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoTieneAsientoEnDestinoException
import ar.edu.unq.epers.aterrizar.exceptions.UsuarioNoTienePermisoParaMGoNMGException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PerfilService {
	var PerfilCacheService pcs
	MongoHome<Perfil> perfilHome
	SocialNetworkingService networkService
	TramoService tramoService
	

	new(MongoHome<Perfil> c, SocialNetworkingService networkService, TramoService tramoService) {
		this.perfilHome = c
		this.networkService = networkService
		this.tramoService = tramoService
		pcs = new PerfilCacheService 
	}
	
	def Perfil getPerfil(Usuario u) {
		perfilHome.getPerfil(u)
	}
	
	def addPerfil(Usuario u) {
		var perfil = new Perfil
		perfil.username = u.nombreDeUsuario
		perfil.destinations = new ArrayList()
		perfilHome.insert(perfil)
	}
	
	def void addDestiny(Usuario u, Destiny d) {
		var perfil = getPerfil(u)
		//if(tramoService.tieneReservadoAsiento(u, d)) perfil.addDestiny(d)
		if(true) perfil.addDestiny(d)
		else throw new UsuarioNoTieneAsientoEnDestinoException
		perfilHome.updatePerfil(perfil, perfil)		
	}
	
	def void addComment(Usuario u, Destiny d, Comment c) {
		var perfil = getPerfil(u)
		perfil.addComment(d, c)
		perfilHome.updatePerfil(perfil, perfil)
	} 
	
	def void addlike(Usuario u, Destiny d) {
		var perfil = getPerfil(u)
		var like = new Like(perfil.username)
		if(d.puedoAgregarLikeODislike(u)) perfil.addLike(d, like, u)
		else throw new UsuarioNoTienePermisoParaMGoNMGException
		perfilHome.updatePerfil(perfil, perfil)
	}

	def void addDislike(Usuario u, Destiny d) {
		var perfil = getPerfil(u)
		var dislike = new Dislike(perfil.username)
		if(d.puedoAgregarLikeODislike(u)) perfil.addDislike(d, dislike, u)
		else throw new UsuarioNoTienePermisoParaMGoNMGException
		perfilHome.updatePerfil(perfil, perfil)
	}
	  
	def void addVisibility(Usuario u, Destiny d, Visibility visibility) {
		var perfil = getPerfil(u)
		perfil.addVisibility(d, visibility)
		perfilHome.updatePerfil(perfil, perfil)
	}
	 
	def void addVisibility(Usuario u, Destiny d, Comment c, Visibility visibility) {
		var perfil = getPerfil(u)
		perfil.addVisibility(d, c, visibility)
		perfilHome.updatePerfil(perfil, perfil)
	}

	

	def stalkear(Usuario miUsuario, Usuario aStalkear){
		//Revisar si no está en la cache
		var PerfilCacheService pcs = new PerfilCacheService
		var Perfil perfilEnCache
		
		
		if(miUsuario.nombreDeUsuario == aStalkear.nombreDeUsuario){
			this.buscarPerfilPropio(miUsuario)
		}else
		//Si son amigos
		if(networkService.theyAreFriends(miUsuario, aStalkear)){
			this.buscarPerfilDeAmigo(miUsuario, aStalkear)
					}
					else
					this.buscarPerfilDeNoAmigo(miUsuario, aStalkear)
				}
		
		
		
			def Perfil buscarPerfilPropio(Usuario miUsuario){
						var result =  pcs.get(miUsuario.nombreDeUsuario)
			var Perfil perfilEnCache
				if(result == null){
				perfilEnCache = this.perfilHome.getPerfil(miUsuario)
				println("No se encontro perfil propio en la caché. Se procede a guardarlo")
				pcs.savePerfil(perfilEnCache)
				return perfilEnCache
				}
				else
				println("Se busco info de la cache. Busqueda reciente de mi propio perfil encontrada")
				//return result.asPerfil()
				perfilEnCache = result
				return perfilEnCache
			
		}
		
		def buscarPerfilDeAmigo(Usuario miUsuario, Usuario aStalkear){
			
			var perfilEnCache = pcs.getPerfilAmigo(aStalkear.nombreDeUsuario)
			if(perfilEnCache != null){
				 println("Se busco info de la cache. Busqueda reciente de amigo encontrada")
				 return perfilEnCache
				 }
				 else
				perfilEnCache = this.perfilHome.stalkearAmigo(aStalkear)
				if(perfilEnCache != null){	
				pcs.savePerfilAmigo(perfilEnCache)
				return perfilEnCache
		}
		
		
	}
	
	def buscarPerfilDeNoAmigo(Usuario miUsuario, Usuario aStalkear){
		//O sea, es un desconocido el que consulta
		var perfilEnCache = pcs.getPerfilNoAmigo(aStalkear.nombreDeUsuario)
						if(perfilEnCache == null){
		println("No se encontro info en la cache. Se procede a buscar en mongo y guardar en la cache...")
				perfilEnCache = this.perfilHome.stalkearNoAmigo(aStalkear) 
				pcs.savePerfilNoAmigo(perfilEnCache)
				return perfilEnCache
				}
	else
		{
		  println("Se busco info de la cache. Busqueda reciente de no amigo encontrada")
          return perfilEnCache
	
		}
	}

}