package ar.edu.unq.epers.aterrizar.model

import java.sql.Date
import org.eclipse.xtend.lib.annotations.Accessors

//import java.sql.Date

/**
 * Created by damian on 4/2/16.
 */
@Accessors
class Usuario {
    int id

    var String nombreDeUsuario
    var String nombreYApellido
    var String email
    var String contrasenia
    var Date nacimiento
    var boolean validado

    def getCodigoDeEmail(){
        nombreDeUsuario.hashCode
    }
}