package ar.edu.unq.epers.aterrizar.home

import ar.edu.unq.epers.aterrizar.Cassandra.PerfilEnCache
import ar.edu.unq.epers.aterrizar.Cassandra.Visibilidad
import ar.edu.unq.epers.aterrizar.model.Perfil
import ar.edu.unq.epers.aterrizar.model.Visibility
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.mapping.Mapper
import com.datastax.driver.mapping.MappingManager
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CassandraConector {

	Cluster cluster
	Session session
	Mapper<PerfilEnCache> mapperPerfil
	
	
	
		
	
	new(){
		connect
		//createSession()
		//createCacheSchema()
	}

	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build()
		session = cluster.connect()
		//val metadata = cluster.getMetadata();
		//System.out.printf("Connected to cluster: %s\n", metadata.getClusterName());
		//for (Host host : metadata.getAllHosts()) {
			//System.out.printf("Datatacenter: %s; Host: %s; Rack: %s\n", host.getDatacenter(), host.getAddress(),
			//	host.getRack());
		//}
		createCacheSchema
		
		
		
		
	}
	

	def close() {
		cluster.close()
	}
	
	def createCacheSchema(){
		
		
		 
		session.execute("CREATE KEYSPACE IF NOT EXISTS persistenciaPerfiles
			WITH replication = {'class':'SimpleStrategy','replication_factor':3}")
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.like (" +
			"username text ); "
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.dislike (" +
			"username text ); "
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.comment (" +
			"id text, " +
			"description text, " +
			"visibility text ); "
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.destiny (" +
			"id text, " +
			"nombre text, " +
			"visibility text , " +
			"comments list<frozen<comment>> , " +
			"likes list<frozen<like>> , " +
			"dislikes list<frozen<dislike>> ); "  
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.perfil (
			username text, "
         + "destinations list  <frozen<destiny>>, "
         + "id text );  ")
		
		

		
		
		
		session.execute("CREATE TABLE IF NOT EXISTS persistenciaPerfiles.perfilesUsuarios (" + 
				"username text, " +
					"perfil frozen <perfil> ,  " +
				//	"destinies list< frozen<Destino> >," +
				"visibility text, " +  
				"PRIMARY KEY (userName, visibility));" 
				
		)
		
		
		
		
		mapperPerfil = new MappingManager(session).mapper(PerfilEnCache)
		
		}	
		
		
		
		
		
		
	def getSession() {

		if (session == null) {
			session = createSession()
		}
		return session
	}

	def static Session createSession() {

		val cluster = Cluster.builder().addContactPoint("localhost").build()
		return cluster.connect()
	}
	
	def eliminarTablas(){
		session.execute("DROP KEYSPACE IF EXISTS simplex");
		cluster.close();
	}

	
	
  
	
	
def savePerfil(Perfil p){
		var perfil = new PerfilEnCache(p, Visibilidad.PRIVADO)
		mapperPerfil.save(perfil)
		
	}
	
	def getPerfil(String userName){
		var Perfil perfil
		try{
		 perfil = mapperPerfil.get(userName, Visibility.PRIVADO.toString).asPerfil
		 }
		 catch(Exception e){
		 perfil = null	
		 return perfil
		 }
		 return perfil
		 
		 
		//var unPerfilEnCache = mapperPerfil.get(userName, Visibility.PRIVADO.toString)
					
		//var ResultSet results
		//results = session.execute("SELECT * FROM perfilesUsuarios WHERE userName='cristian'");
		//var results = unPerfilEnCache
		//if( results == null)
		//return null
		//else
		
		//ResultSet results
		//var result2 = session.execute("SELECT * FROM perfilesUsuarios WHERE userName='cristian'");
		//result2.findFirst[] as PerfilCache
		//return unPerfilEnCache.asPerfil()
	}
	
	def deletePerfil(String userName){
		var unPerfil = getPerfil(userName)
		if(unPerfil != null && unPerfil.username == userName ){
			
			mapperPerfil.delete(unPerfil)
			//saveReserva(ubicacion,fecha,patentes)
			}
	
	
	}
	
	    	
	def clean(){
			session.execute("DROP TABLE persistenciaPerfiles.perfilesUsuarios")
			session.execute("DROP KEYSPACE persistenciaPerfiles")
	}
	
	def getPerfilAmigo(String username){
		
		var Perfil unPerfilCache
		try{
		 unPerfilCache = mapperPerfil.get(username, Visibility.AMIGOS.toString).asPerfil
		 }
		 catch(Exception e){
		 unPerfilCache = null	
		 return unPerfilCache
		 }
		 return unPerfilCache
	}
	
	def getPerfilNoAmigo(String username){
			
		var Perfil unPerfilCache
		try{
		 unPerfilCache = mapperPerfil.get(username, Visibility.PUBLICO.toString).asPerfil
		 }
		 catch(Exception e){
		 unPerfilCache = null	
		 return unPerfilCache
		 }
		 return unPerfilCache
	}
	
	def savePerfilAmigo(Perfil p){
		var perfilCache = new PerfilEnCache(p, Visibilidad.AMIGOS)
		mapperPerfil.save(perfilCache)
	}
	
	def savePerfilNoAmigo(Perfil p){
		var perfil = new PerfilEnCache(p, Visibilidad.PUBLICO)
		mapperPerfil.save(perfil)
	}
	
	}