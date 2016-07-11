package ar.edu.unq.epers.aterrizar.model

import ar.edu.unq.epers.aterrizar.Cassandra.Visibilidad
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.UDT
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId

@UDT(name = "perfil", keyspace = "persistenciaPerfiles")
@Accessors
class Perfil {
	
	private String username
	@FrozenValue
	private List<Destiny> destinations	
	@ObjectId
	@JsonProperty("_id")
	String id
	
	new() {
		this.destinations = new ArrayList<Destiny>
	}
	

	new(String username) {
		this.username = username
		this.destinations = new ArrayList<Destiny>()
	}
	
	
	def addDestiny(Destiny d) {
		this.destinations.add(d)
	}
	
	def exist(Destiny d) {
		var bool_ret = false
		for(Destiny dest : this.destinations) {
			bool_ret = bool_ret || dest.nombre == d.nombre
		}
			bool_ret
	}
	
	def update(Destiny d, Comment c) {
		for(Destiny dest : this.destinations) {
			if(d.nombre == dest.nombre) dest.addComment(c)
		}
	}
	
	def addComment(Destiny d, Comment c) {
		for(Destiny dest : destinations) {
			if(dest.nombre == d.nombre) dest.add(c)
		}
	}
	
	def addLike(Destiny d, Like l, Usuario u) {
		for(Destiny dest : destinations) {
			if(dest.nombre == d.nombre) dest.addLike(u, l)
		}
	}
	
	def addDislike(Destiny d, Dislike dislike, Usuario u) {
		for(Destiny dest : destinations) {
			if(dest.nombre == d.nombre) dest.addDisLike(u, dislike)
		}
	}
	
	def addVisibility(Destiny d, Visibilidad visibility) {
		for(Destiny dest : destinations) {
			if(dest.nombre == d.nombre) dest.setVisibility(visibility)
		}
	}
	
	def addVisibility(Destiny d,Comment c, Visibilidad v) {
		for(Destiny dest : destinations) {
			if(dest.nombre == d.nombre) dest.getComment(c).setVisibility(v)
		}
	}
	
	def deleteComments(Visibilidad v) {
		for(Destiny dest : destinations) dest.deleteComments(v)
			
	}
	
	def deleteDestinations(Visibilidad v) {
		var destinationsAux = new ArrayList<Destiny>
		for(Destiny d : destinations) {
			if(!(d.visibility.toString == v.toString)) destinationsAux.add(d)
		}
			destinations = destinationsAux
			null
	}	
	
}