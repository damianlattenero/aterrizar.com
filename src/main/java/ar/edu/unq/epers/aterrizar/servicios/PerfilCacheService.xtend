package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.model.Perfil
import ar.edu.unq.epers.aterrizar.home.CassandraConector
import ar.edu.unq.epers.aterrizar.model.Visibility

class PerfilCacheService {

	CassandraConector dao

	new() {
		dao = new CassandraConector
	}

	def guardar(Perfil perfil) {
		dao.savePerfil(perfil)

	}

	def get(String username) {
		dao.getPerfil(username)
	}

	def getPerfilAmigo(String username) {
		dao.getPerfilAmigo(username)
	}

	def getPerfilNoAmigo(String username) {
		dao.getPerfilNoAmigo(username)
	}

	def get(String userName, String destName) {
	}

	def savePerfil(Perfil p) {
		dao.savePerfil(p)
		println("Se guardo el perifl en cache")

	}

	def savePerfilAmigo(Perfil p) {
		dao.savePerfilAmigo(p)
	}

	def savePerfilNoAmigo(Perfil p) {
		dao.savePerfilNoAmigo(p)
	}

	def cleanDB() {
		dao.clean()
	}

	def delete(String userName) {
		dao.deletePerfil(userName)
	}

	def clean() {
		dao.clean
	}

}
