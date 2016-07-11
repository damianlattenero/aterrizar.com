package ar.edu.unq.epers.aterrizar.Cassandra

import ar.edu.unq.epers.aterrizar.model.Comment
import ar.edu.unq.epers.aterrizar.model.Destiny
import ar.edu.unq.epers.aterrizar.model.Like
import ar.edu.unq.epers.aterrizar.model.Visibility
import com.datastax.driver.mapping.annotations.Field
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.UDT
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@UDT(keyspace="persistenciaPerfiles", name="destinyCache")
class DestinoCache {

	@Field(name="destinyName")
	String destinyName
	@Field(name="visibility")
	String visibility
	@Field(name="comments")
	/*
	 * @FrozenValue //("List< frozen<DestinyCache>>")
	 * List<DestinyCache> destinies
	 */
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
			var comm = new ComentarioCache(c)
			comments.add(comm)
		}

		likes = newArrayList
		for (Like l : destino.likes) {
			var like = new LikeCache(l)
			likes.add(like)
		}

		dislikes = newArrayList
		for (ar.edu.unq.epers.aterrizar.model.Dislike d : destino.dislikes) {
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
