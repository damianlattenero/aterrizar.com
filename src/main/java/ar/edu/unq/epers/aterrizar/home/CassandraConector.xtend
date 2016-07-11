package ar.edu.unq.epers.aterrizar.home

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

	def close() {
		cluster.close()
	}

	def createCacheSchema() {
		
		session.execute("CREATE KEYSPACE IF NOT EXISTS persistenciaPerfiles
			WITH replication = {'class':'SimpleStrategy','replication_factor':3}")

		session.execute(
			"CREATE TYPE IF NOT EXISTS persistenciaPerfiles.like (" + "username text ); "
		)

		session.execute(
			"CREATE TYPE IF NOT EXISTS persistenciaPerfiles.dislike (" + "username text ); "
		)

		session.execute(
			"CREATE TYPE IF NOT EXISTS persistenciaPerfiles.comment (" + "id text, " + "description text, " +
				"visibility text ); "
		)

		session.execute(
			"CREATE TYPE IF NOT EXISTS persistenciaPerfiles.destiny (" + "id text, " + "nombre text, " +
				"visibility text , " + "comments list<frozen<comment>> , " + "likes list<frozen<like>> , " +
				"dislikes list<frozen<dislike>> ); "  
		)

				session.execute("CREATE TYPE IF NOT EXISTS persistenciaPerfiles.perfil (
			username text, " + "destinations list  <frozen<destiny>>, " + "id text );  ")

				session.execute(
					"CREATE TABLE IF NOT EXISTS persistenciaPerfiles.perfilesUsuarios (" + "username text, " +
						"perfil frozen <perfil> ,  " + // "destinies list< frozen<Destino> >," +
						"visibility text, " + "PRIMARY KEY (userName, visibility));"
				)
		
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

	def eliminarTablas() {
		session.execute("DROP KEYSPACE IF EXISTS simplex");
		cluster.close();
	}

	def clean() {
		session.execute("DROP TABLE persistenciaPerfiles.perfilesUsuarios")
		session.execute("DROP KEYSPACE persistenciaPerfiles")
	}
}
