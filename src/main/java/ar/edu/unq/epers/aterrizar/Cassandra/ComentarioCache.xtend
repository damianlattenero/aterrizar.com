package ar.edu.unq.epers.aterrizar.Cassandra

/**
 * Created by damian on 11/07/16.
 */
import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Column
import ar.edu.unq.epers.aterrizar.model.Comment
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field

@Accessors
@UDT(keyspace="persistenciaPerfiles", name="comentarioCache")
class ComentarioCache {

	@Field(name="visibility")
	String visibilidad
	@Field(name="description")
	String description

	new() {
	}

	new(Comment comment) {
		this.description = comment.description

	}

	def asComment() {
		new Comment(description)
	}

}
