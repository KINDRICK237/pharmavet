package dao;

import connexion.ConnexionDB;
import model.Client;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    // Lister tous les clients
    public List<Client> listerTous() {
        List<Client> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM clients ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Client c = new Client();
                c.setId(rs.getInt("id"));
                c.setNom(rs.getString("nom"));
                c.setPrenom(rs.getString("prenom"));
                c.setTelephone(rs.getString("telephone"));
                c.setEmail(rs.getString("email"));
                c.setAdresse(rs.getString("adresse"));
                c.setDateInscription(rs.getTimestamp("date_inscription"));
                liste.add(c);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }

    // Ajouter un client
    public boolean ajouter(Client c) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "INSERT INTO clients (nom, prenom, telephone, email, adresse) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getNom());
            ps.setString(2, c.getPrenom());
            ps.setString(3, c.getTelephone());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAdresse());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trouver un client par ID
    public Client trouverParId(int id) {
        Client c = null;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM clients WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = new Client();
                c.setId(rs.getInt("id"));
                c.setNom(rs.getString("nom"));
                c.setPrenom(rs.getString("prenom"));
                c.setTelephone(rs.getString("telephone"));
                c.setEmail(rs.getString("email"));
                c.setAdresse(rs.getString("adresse"));
                c.setDateInscription(rs.getTimestamp("date_inscription"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    // Modifier un client
    public boolean modifier(Client c) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE clients SET nom=?, prenom=?, telephone=?, email=?, adresse=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getNom());
            ps.setString(2, c.getPrenom());
            ps.setString(3, c.getTelephone());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAdresse());
            ps.setInt(6, c.getId());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Supprimer un client
    public boolean supprimer(int id) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "DELETE FROM clients WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Compter le nombre d'animaux d'un client
    public int compterAnimaux(int clientId) {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM animaux WHERE client_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}