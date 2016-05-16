package ar.edu.unq.epers.aterrizar.home

import ar.edu.unq.epers.aterrizar.model.Message
import ar.edu.unq.epers.aterrizar.model.TipoDeRelaciones
import ar.edu.unq.epers.aterrizar.model.Usuario
import java.sql.Date
import java.util.ArrayList
import org.neo4j.cypher.ExecutionEngine
import org.neo4j.cypher.ExecutionResult
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import java.util.Set
import java.util.Map
import java.util.HashMap
import java.util.Arrays
import org.neo4j.graphdb.Result
import org.neo4j.graphdb.traversal.Evaluators

class SocialNetworkingHome {

	GraphDatabaseService graph
	
	new(GraphDatabaseService graph) {
		this.graph = graph
	}
	
	private def userLabel() {
		DynamicLabel.label("User")
	}
	
	def eliminarNodo(Usuario usuario) {
		val nodo = this.getNodo(usuario)
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def crearNodo(Usuario usuario) {
		val node = this.graph.createNode(userLabel)
		node.setProperty("nombreDeUsuario", usuario.nombreDeUsuario)
		node.setProperty("nombreYApellido", usuario.nombreYApellido)
		node.setProperty("email", usuario.email)
		node.setProperty("contrasenia", usuario.contrasenia)
		node.setProperty("nacimiento", usuario.nacimiento)
		node.setProperty("validado", usuario.validado)
	}
	
	def getNodo(Usuario usuario) {
		this.getNodo(usuario.nombreDeUsuario)
	}
	
	def getNodo(String nombreUsuario) {
		this.graph.findNodes(userLabel, "nombreUsuario", nombreUsuario).head
	}
	
	def relacionar(Usuario usuario0, Usuario usuario1, TipoDeRelaciones relacion) {
		/*
		 * Si no estan relacionados
		 */
		val nodo1 = this.getNodo(usuario0);
		val nodo2 = this.getNodo(usuario1);
		nodo1.createRelationshipTo(nodo2, relacion);
	}
	
	// Total
	def getFriends(Usuario usuario) {
		val nodoUsuario = this.getNodo(usuario)
		val nodoAmigos = this.nodosRelacionados(nodoUsuario, TipoDeRelaciones.AMIGO, Direction.OUTGOING)
		//INCOMING
		return nodoAmigos.map[toUsuario].toSet
	}
	/* 
	 // Algo asi, hay problemas con los tipos
	def getAllFriends(Usuario usuario) {
		val myFriends = getFriends(usuario)
		val otherFriends = Set
		for(Usuario friend : myFriends) {
			otherFriends.addAll(getFriends(friend).toArray) 
		}
			otherFriends.addAll(myFriends)
	}
	*/
	private def toUsuario(Node nodo) {
		new Usuario => [
			nombreDeUsuario = nodo.getProperty("nombreDeUsuario") as String
			nombreYApellido = nodo.getProperty("nombreYApellido") as String
			email = nodo.getProperty("email") as String
			contrasenia = nodo.getProperty("contrasenia") as String
			nacimiento = nodo.getProperty("nacimiento") as Date
			validado = nodo.getProperty("validado") as Boolean
		]
	}
	
	protected def nodosRelacionados(Node nodo, RelationshipType tipo, Direction direccion) {
		nodo.getRelationships(tipo, direccion).map[it.getOtherNode(nodo)]
	}
	
	// Modificar, si existe relacion entonces solo agrego el mensaje, si no creo la relacion e envio el mensaje
	// solucion provisoria
	// la idea es que la relacion tenga una propiedad llamada msjs que sea un array de msjs
	def sendMsj(Usuario sender, Usuario receiver, Message msj) {
		/*
		 * if no existe la relacion la creo, indistintamente se agrega el mensaje
		 */
		val nodo1 = this.getNodo(sender);
		val nodo2 = this.getNodo(receiver);
		var relationship = nodo1.createRelationshipTo(nodo2, TipoDeRelaciones.SENDERMSJ)
		relationship.setProperty("msjs", "un nuevo mensaje de sender")
		return null
	}	
	
	def getAllFriends(Usuario usuario){
		var Node n = this.getNodo(usuario)
		graph.traversalDescription()
	        .breadthFirst()
	        .relationships(TipoDeRelaciones.AMIGO)
            .evaluator(Evaluators.excludeStartPosition)
            .traverse(n)
            .nodes()
	        .map[it.getProperty("nombreDeUsuario") as String].toSet
	}
		
}
	
	
	
