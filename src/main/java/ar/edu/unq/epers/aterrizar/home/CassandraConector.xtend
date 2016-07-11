package ar.edu.unq.epers.aterrizar.home

import ar.edu.unq.epers.aterrizar.Cassandra.PerfilEnCache
import ar.edu.unq.epers.aterrizar.Cassandra.Visibilidad
import ar.edu.unq.epers.aterrizar.model.Perfil
import com.datastax.driver.core.Cluster
import com.datastax.driver.core.Session
import com.datastax.driver.extras.codecs.enums.EnumNameCodec
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
	
	}

	def connect() {
		cluster = Cluster.builder().addContactPoint("localhost").build()
		session = cluster.connect()
		
		
		createCacheSchema
		
		
		
		
	}
	

	def close() {
		cluster.close()
	}
	
	def createCacheSchema(){
		
		
		
								cluster.getConfiguration().getCodecRegistry()
        							.register(new EnumNameCodec<Visibilidad>(Visibilidad));
		 
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
						"visibilidad varchar ); "
		)
		
		session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.destiny (" +
			"id text, " +
			"nombre text, " +
						"visibilidad varchar , " +
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
				"visibilidad text, " +  
				"PRIMARY KEY (userName, visibilidad));" 
				
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

		val cluster = Cluster.builder().addContactPoint("127.0.0.1").build()
		return cluster.connect()
	}
	
	def eliminarTablas(){
		session.execute("DROP KEYSPACE IF EXISTS simplex");
		cluster.close();
	}

	
	
  
	
	
def savePerfil(Perfil p){
		var perfil = new PerfilEnCache(p, Visibilidad.PRIVADO.toString)
		mapperPerfil.save(perfil)
		
	}
	
	def getPerfil(String userName){
		var Perfil perfil
		try{
		 perfil = mapperPerfil.get(userName, Visibilidad.PRIVADO.toString).asPerfil
		 }
		 catch(Exception e){
		 perfil = null	
		 return perfil
		 }
		 return perfil
		 
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
		 unPerfilCache = mapperPerfil.get(username, Visibilidad.AMIGOS.toString).asPerfil
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
		 unPerfilCache = mapperPerfil.get(username, Visibilidad.PUBLICO.toString).asPerfil
		 }
		 catch(Exception e){
		 unPerfilCache = null	
		 return unPerfilCache
		 }
		 return unPerfilCache
	}
	
	def savePerfilAmigo(Perfil p){
		var perfilCache = new PerfilEnCache(p, Visibilidad.AMIGOS.toString)
		mapperPerfil.save(perfilCache)
	}
	
	def savePerfilNoAmigo(Perfil p){
		var perfil = new PerfilEnCache(p, Visibilidad.PUBLICO.toString)
		mapperPerfil.save(perfil)
	}
	
	}