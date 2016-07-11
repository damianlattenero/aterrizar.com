package ar.edu.unq.epers.aterrizar.Cassandra

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Foto {
	String idFoto
	String userName
	Visibilidad visibility
	String description
}