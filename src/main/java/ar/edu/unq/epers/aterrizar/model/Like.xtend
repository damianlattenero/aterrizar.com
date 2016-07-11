package ar.edu.unq.epers.aterrizar.model

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field

@UDT(name = "like", keyspace = "persistenciaPerfiles")
@Accessors
class Like {
	
	private String username
	
	
	new() {}
	
	new(String username) {
		this.username = username
	}
}