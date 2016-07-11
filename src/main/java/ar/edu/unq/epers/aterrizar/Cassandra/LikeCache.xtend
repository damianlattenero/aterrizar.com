package ar.edu.unq.epers.aterrizar.Cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Column
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import ar.edu.unq.epers.aterrizar.model.Like

@Accessors
@UDT(keyspace="persistenciaPerfiles", name="likeCache")
class LikeCache {

	@Field(name="userName")
	String userName

	new() {
	}

	new(Like l) {
		this.userName = l.username

	}

	def asLike() {
		new Like(this.userName)
	}

}
