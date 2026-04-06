package connexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnexionDB {

    private static final String URL = "jdbc:mysql://localhost:3306/pharmavet";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // vide par défaut avec WAMP

    public static Connection getConnexion() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Connexion réussie à la base de données !");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Driver MySQL introuvable : " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("❌ Erreur de connexion : " + e.getMessage());
        }
        return conn;
    }
}