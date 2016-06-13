package ar.edu.unq.epers.aterrizar.exceptions

/**
 * Created by damian on 4/3/16.
 */

class YaExisteUsuarioConEseNombreException extends Exception{}
class NoExisteUsuarioConEseNombreException extends Exception{}
class ContraseniaIgualALaAnteriorException extends Exception{}
class ContraseniaIncorrectaException extends Exception{}
class EnviarMailException extends Exception{}
class NoHayAsientoConEsaIdException extends Exception{}
class UsuarioNoTieneAsientoEnDestinoException extends Exception{}
class UsuarioNoTienePermisoParaMGoNMGException extends Exception{}
class AsientoReservadoException extends RuntimeException{
	
    new(String message){
        super(message)
    }

}