package ar.edu.unq.epers.aterrizar.Cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Column
import ar.edu.unq.epers.aterrizar.model.Visibility
import ar.edu.unq.epers.aterrizar.model.Foto

@Accessors
@Table(keyspace="persistenciaFotos", name="fotosUsuarios")
class FotoCache {

	@PartitionKey(0)
	@Column(name="idFoto")
	String idFoto
	@PartitionKey(1)
	@Column(name="userName")
	String userName
	@Column(name="visibility")
	String visibility
	@Column(name="description")
	String description

	new() {
	}

	new(Foto foto) {
		this.idFoto = foto.idFoto
		this.userName = foto.userName
		this.visibility = foto.visibility.toString
		this.description = foto.description

	}

}
