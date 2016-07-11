package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.home.CassandraConector
import ar.edu.unq.epers.aterrizar.model.Perfil

class PerfilCacheService {

	CassandraConector dao

	new() {
		dao = new CassandraConector
	}

	def clean() {
		dao.clean
	}

}
