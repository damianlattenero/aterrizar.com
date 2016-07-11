package ar.edu.unq.epers.aterrizar.model

import com.fasterxml.jackson.annotation.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import java.util.ArrayList
import com.datastax.driver.mapping.annotations.UDT
import com.datastax.driver.mapping.annotations.FrozenValue
import com.datastax.driver.mapping.annotations.Frozen
import java.util.List
import com.datastax.driver.mapping.annotations.Field

@UDT(name = "destiny", keyspace = "persistenciaPerfiles")
@Accessors
class Destiny {
	@ObjectId
	@JsonProperty("_id")
	
	String id
	
	String nombre;
	
	@Frozen("List< frozen<Like>>")
	List<Like> likes
	@Frozen("List< frozen<Dislike>>")
	List<Dislike> dislikes
	@Frozen("List< frozen<Comment>>")
	List<Comment> comments
	
	
	Visibility visibility
	
	new() {
		comments = new ArrayList
		likes = new ArrayList
		dislikes = new ArrayList
	}
	
	def add(Comment c){
		comments.add(c)
	}
	
	def addLike(Usuario u, Like like) {
		if(puedoAgregarLikeODislike(u)) likes.add(like)
	}
	
	def addDisLike(Usuario u, Dislike dislike) {
		if(puedoAgregarLikeODislike(u)) dislikes.add(dislike)
	}
	
	def puedoAgregarLikeODislike(Usuario u) {
		return this.likes_size(u) == 0 && this.dislikes_size(u) == 0
	}
	
	def likes_size(Usuario u) {
		var ret = 0
		for(Like like : this.likes) {
			if(like.username == u.nombreDeUsuario) ret++
		}
			return ret
	}
	
	def dislikes_size(Usuario u) {
		var ret = 0
		for(Dislike dislike : this.dislikes) {
			if(dislike.username == u.nombreDeUsuario) ret++
		}
			return ret
	}
	
	def getComment(Comment c) {
		for(Comment comment : comments) {
			if(comment.description == c.description) return comment
		}
	}
	
	def deleteComments(Visibility v) {
		for(Comment c : comments) {
			if(c.visibility.toString == v.toString) this.comments.remove(c)
		}
	}
	
	
}