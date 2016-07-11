package ar.edu.unq.epers.aterrizar.Cassandra


import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import ar.edu.unq.epers.aterrizar.model.Dislike

@UDT(name = "dislike", keyspace = "persistenciaPerfiles")
@Accessors
class DislikeCache {
	
	
	@Field(name="userName")
	String userName
	
	
	new() {}
	
	new(String username) {
		this.userName = username
	}
	
	def asDislike() {
		var Dislike l = new Dislike(this.userName)
		l
	}
	
}