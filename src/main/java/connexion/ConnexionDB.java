package connexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnexionDB {

    private static final String URL = System.getenv("DATABASE_URL") != null ?
        System.getenv("DATABASE_URL") :
        "jdbc:mysql://localhost:3306/pharmavet";

    private static final String USER = System.getenv("DATABASE_USER") != null ?
        System.getenv("DATABASE_USER") : "root";

    private static final String PASSWORD = System.getenv("DATABASE_PASSWORD") != null ?
        System.getenv("DATABASE_PASSWORD") : "";

    public static Connection getConnexion() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Driver MySQL introuvable : " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Erreur de connexion : " + e.getMessage());
        }
        return conn;
    }
}