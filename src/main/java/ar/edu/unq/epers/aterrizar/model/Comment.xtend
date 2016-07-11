package ar.edu.unq.epers.aterrizar.model

import ar.edu.unq.epers.aterrizar.Cassandra.Visibilidad
import com.datastax.driver.mapping.annotations.UDT
import com.fasterxml.jackson.annotation.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId

@UDT(name = "comment", keyspace = "persistenciaPerfiles")
@Accessors
class Comment {
	@ObjectId
	@JsonProperty("_id")
	
	String id
	
	String description
	
	Visibilidad visibility
	
	
	new() {}
	
	new(String desc) {
		this.description = desc
	}
}