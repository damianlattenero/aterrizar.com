package ar.edu.unq.epers.aterrizar.model

import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Created by damian on 4/18/16.
 */
@Accessors
class Busqueda {

    Criterio criterio
    Orden orden

    def getHQL(){
        var res = "select vuelo from Aerolinea aerolinea left join aerolinea.vuelosOfertados as vuelo " + criterio.getHQL + " where " + criterio.whereClause
        if (orden != null){
            return res + orden.getOrderStatament
        }else{
            res
        }
    }



}