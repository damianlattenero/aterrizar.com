package ar.edu.unq.epers.aterrizar.model

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Comment {
	String description
	Visibility visibility
	
	new() {}
	
	new(String desc) {
		this.description = desc
	}
}