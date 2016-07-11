package ar.edu.unq.epers.aterrizar.persistencia

import ar.edu.unq.epers.aterrizar.model.Usuario
import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet

/**
 * Created by damian on 4/2/16.
 */
class Repositorio {

    def void guardarUsuario(Usuario usuario){

        excecute[conn|

            val ps = conn.prepareStatement("INSERT INTO usuario (nombreDeUsuario, nombreYApellido, email, contrasenia, nacimiento, validado) VALUES (?,?,?,?,?,?)")


            ps.setString(1, usuario.nombreDeUsuario)
            ps.setString(2, usuario.nombreYApellido)
            ps.setString(3, usuario.email)
            ps.setString(4, usuario.contrasenia)
            ps.setDate(5, usuario.nacimiento)
            ps.setBoolean(6, usuario.validado)

            ps.execute()



            ps.close()
            null
        ]
    }

    def void validarUsuario(String nombreDeUsuario){
        excecute[ conn |
            val ps = conn.prepareStatement("UPDATE usuario SET validado=TRUE WHERE nombreDeUsuario=?;")
            ps.setString(1, nombreDeUsuario)
            ps.execute()
        ]
    }

    def void cambiarContrasenia(String nombDeUs, String password){
        excecute[ conn |
            val ps = conn.prepareStatement("UPDATE usuario SET contrasenia=? WHERE nombreDeUsuario=?;")
            ps.setString(1, password)
            ps.setString(2, nombDeUs)
            ps.execute()
        ]
    }

    def void borrarTodosLosUsuario(){
        excecute[ conn |
            val ps = conn.prepareStatement("DELETE FROM usuario;")
            ps.execute()
        ]
    }

    def void borrarUsuario(String nombreDeUsuario){

        excecute[conn|
            val ps = conn.prepareStatement("DELETE FROM usuario WHERE nombreDeUsuario = ?")
            ps.setString(1, nombreDeUsuario)

            ps.execute()

            ps.close

            null

        ]

    }



    def Usuario obtenerUsuarioPorNombreDeUsuario(String nomDeUsuario){
        excecute[conn|
            val ps = conn.prepareStatement("SELECT * FROM usuario WHERE nombreDeUsuario=?")
            ps.setString(1, nomDeUsuario)

            val ResultSet rs = ps.executeQuery


            if(rs.next()) {
                val nDeUs = rs.getString("nombreDeUsuario")
                if(nDeUs == nomDeUsuario )
                    new Usuario => [
                        setNombreDeUsuario = rs.getString("nombreDeUsuario")
                        nombreYApellido = rs.getString("nombreYApellido")
                        email = rs.getString("email")
                        contrasenia = rs.getString("contrasenia")
                        nacimiento = rs.getDate("nacimiento")
                        validado = rs.getBoolean("validado")
                    ]
            }else{
                ps.close();
                return null
            }

        ]




    }

    def <A> excecute(Functions.Function1<Connection, A> closure){
        var Connection conn = null
        try{
            conn = getConnection()
            return closure.apply(conn)
        }finally{
            if(conn != null)
                conn.close()
        }
    }

    def getConnection() {
        Class.forName("com.mysql.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/aterrizar?user=root&password=root")
    }





}