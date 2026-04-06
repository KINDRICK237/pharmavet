package dao;

import connexion.ConnexionDB;
import model.Utilisateur;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    // Lister tous les utilisateurs
    public List<Utilisateur> listerTous() {
        List<Utilisateur> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM utilisateurs ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Utilisateur u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setLogin(rs.getString("login"));
                u.setRole(rs.getString("role"));
                u.setDateCreation(rs.getTimestamp("date_creation"));
                liste.add(u);
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return liste;
    }

    // Trouver par ID
    public Utilisateur trouverParId(int id) {
        Utilisateur u = null;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM utilisateurs WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setLogin(rs.getString("login"));
                u.setMotDePasse(rs.getString("mot_de_passe"));
                u.setRole(rs.getString("role"));
                u.setDateCreation(rs.getTimestamp("date_creation"));
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    // Ajouter un utilisateur
    public boolean ajouter(Utilisateur u) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "INSERT INTO utilisateurs (nom, prenom, login, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getLogin());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getRole());
            ps.executeUpdate();
            ps.close(); conn.close();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Modifier un utilisateur
    public boolean modifier(Utilisateur u) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE utilisateurs SET nom=?, prenom=?, login=?, role=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getLogin());
            ps.setString(4, u.getRole());
            ps.setInt(5, u.getId());
            ps.executeUpdate();
            ps.close(); conn.close();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Supprimer un utilisateur
    public boolean supprimer(int id) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "DELETE FROM utilisateurs WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close(); conn.close();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Réinitialiser mot de passe
    public boolean reinitialiserMotDePasse(int id, String nouveauMotDePasse) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE utilisateurs SET mot_de_passe = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nouveauMotDePasse);
            ps.setInt(2, id);
            ps.executeUpdate();
            ps.close(); conn.close();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Vérifier si login existe déjà
    public boolean loginExiste(String login, int idExclu) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM utilisateurs WHERE login = ? AND id != ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, login);
            ps.setInt(2, idExclu);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}