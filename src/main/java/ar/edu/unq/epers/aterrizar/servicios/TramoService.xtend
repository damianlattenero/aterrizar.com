package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.home.SessionManager
import ar.edu.unq.epers.aterrizar.home.TramoHome
import ar.edu.unq.epers.aterrizar.model.Tramo
import ar.edu.unq.epers.aterrizar.model.VueloOfertado
import java.util.List
import ar.edu.unq.epers.aterrizar.model.Usuario
import ar.edu.unq.epers.aterrizar.model.Destiny
import ar.edu.unq.epers.aterrizar.home.BaseHome
import org.hibernate.Session
import org.hibernate.SessionFactory
import ar.edu.unq.epers.aterrizar.model.Asiento

/**
 * Created by damian on 4/16/16.
 */
class TramoService extends BaseService{

	
	 
	 
	 
	 


    def guardarTramosEnVuelo(VueloOfertado vuelo, Tramo... listaTramos){
        guardarVueloConTramos(vuelo, listaTramos.toList)
    }

    def guardarVueloConTramos(VueloOfertado vuelo, List<Tramo> listaTramos){

        SessionManager.runInSession([
            val tramoHome = new TramoHome()
            listaTramos.forEach[tramo|
                vuelo.guardarTramo(tramo)
                tramoHome.guardar(vuelo)
            ]
            null
        ])

    }


    def asientosDisponibles(Tramo tramo){

        SessionManager.runInSession([
            new TramoHome().asientosDisponiblesEnTramo(tramo)
        ]);
    }
	
	def tieneReservadoAsiento(Usuario usuario, Destiny destiny) {
		SessionManager.runInSession([
            val tramoHome = new TramoHome()
            var listaAsientos = tramoHome.getTramosConDestino(usuario.nombreDeUsuario, destiny.nombre)
            listaAsientos.size > 0
            
        ])
		
	}



}