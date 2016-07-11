package ar.edu.unq.epers.aterrizar.Cassandra

import com.datastax.driver.mapping.annotations.PartitionKey
import javax.persistence.Column
import java.util.List
import ar.edu.unq.epers.aterrizar.model.Destiny
import ar.edu.unq.epers.aterrizar.model.Perfil
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.Frozen
import ar.edu.unq.epers.aterrizar.model.Like
import ar.edu.unq.epers.aterrizar.model.Dislike
import ar.edu.unq.epers.aterrizar.model.Comment
import ar.edu.unq.epers.aterrizar.model.Visibility
import java.util.ArrayList

@Accessors
@Table(keyspace="persistenciaPerfiles", name="perfilesUsuarios")
class PerfilCache {
	@PartitionKey(0)
	@Column(name="userName")
	String userName
	@Column(name="destinies")
	@FrozenValue 
	List<DestinoCache> destinies
	@Column(name="visibility")
	String visibility

	new(Perfil p) {
		this.userName = p.username
		destinies = new ArrayList<DestinoCache>
	}

	new() {
	}

	new(Perfil p, Visibility visibility) {
		this.userName = p.username
		this.destinies = new ArrayList<DestinoCache>
		for (Destiny d : p.destinations) {
			destinies.add(new DestinoCache(d))
		}
		visibility = visibility.toString
	}

	def asPerfil() {
		var Perfil p = new Perfil(this.userName)

		for (DestinoCache each : destinies) {
			p.destinations.add(each.asDestiny)
			p.destinations = newArrayList()
		}

		return p
	}

}
