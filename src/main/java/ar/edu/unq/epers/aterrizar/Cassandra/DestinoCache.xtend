package ar.edu.unq.epers.aterrizar.Cassandra

import org.eclipse.xtend.lib.annotations.Accessors
import com.datastax.driver.mapping.annotations.Table
import com.datastax.driver.mapping.annotations.PartitionKey
import com.datastax.driver.mapping.annotations.Column
import ar.edu.unq.epers.aterrizar.model.Destiny
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.Field
import java.util.List
import ar.edu.unq.epers.aterrizar.model.Comment
import ar.edu.unq.epers.aterrizar.model.Like
import ar.edu.unq.epers.aterrizar.model.Dislike
import ar.edu.unq.epers.aterrizar.model.Visibility
import com.datastax.driver.mapping.annotations.FrozenValue

@Accessors
@UDT(keyspace="persistenciaPerfiles", name="destinyCache")
class DestinoCache {

	@Field(name="destinyName")
	String destinyName
	@Field(name="visibility")
	String visibility
	@Field(name="comments")
	@FrozenValue
	List<ComentarioCache> comments
	@Field(name="likes")
	@FrozenValue
	List<LikeCache> likes
	@Field(name="dislikes")
	@FrozenValue
	List<DislikeCache> dislikes

	new() {
		comments = newArrayList
		likes = newArrayList
		dislikes = newArrayList
	}

	new(Destiny destino) {
		this.destinyName = destino.nombre
		this.visibility = destino.visibility.toString
		comments = newArrayList
		for (Comment c : destino.comments) {
			comments.add(new ComentarioCache(c))
		}

		likes = newArrayList
		for (Like l : destino.likes) {
			likes.add(new LikeCache(l))
		}

		dislikes = newArrayList
		for (Dislike d : destino.dislikes) {
			dislikes.add(new DislikeCache(d.username))
		}
	}

	def asDestiny() {

		var Destiny d = new Destiny()

		for (LikeCache lk : this.likes) {
			d.likes.add(lk.asLike())
		}

		for (DislikeCache lk : this.dislikes) {
			d.dislikes.add(lk.asDislike())
		}

		for (ComentarioCache c : this.comments) {
			d.comments.add(c.asComment())
		}

		d.nombre = this.destinyName

		if (this.visibility == "PUBLICO")
			d.visibility = Visibility.PUBLICO
		else if (this.visibility == "AMIGOS")
			d.visibility = Visibility.AMIGOS
		else
			d.visibility = Visibility.PRIVADO

		return d

	}

}
