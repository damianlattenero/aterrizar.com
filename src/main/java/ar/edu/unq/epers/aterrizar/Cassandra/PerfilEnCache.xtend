package ar.edu.unq.epers.aterrizar.Cassandra

import ar.edu.unq.epers.aterrizar.model.Perfil
import com.datastax.driver.mapping.annotations.Column
import com.datastax.driver.mapping.annotations.Frozen
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Table
import org.eclipse.xtend.lib.annotations.Accessors

@Table(keyspace = "persistenciaPerfiles", name = "perfilesUsuarios")
@Accessors
class PerfilEnCache {
	@PartitionKey(0)
	@Column (name="userName")
	String userName
	@PartitionKey(1)
	@Column (name="visibility")
	String visibility
	@Frozen
	Perfil perfil 
	
	
	new(){}
	
	
	new(Perfil p, String visibility) {
		this.userName = p.username
		this.visibility = visibility
		this.perfil = p
	}
	
	def asPerfil(){
		perfil
	}
	
}
