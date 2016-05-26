package ar.edu.unq.epers.aterrizar.model

import com.fasterxml.jackson.annotation.JsonProperty
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import java.util.ArrayList

@Accessors
class Destiny {
	@ObjectId
	@JsonProperty("_id")
	String id
	String nombre;
	int mg;
	int nMg;
	ArrayList<Comment> comments;
	Visibility visibility;
	
	new() {
	}
	
}