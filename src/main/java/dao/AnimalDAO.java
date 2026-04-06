package dao;

import connexion.ConnexionDB;
import model.Animal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnimalDAO {

    // Lister tous les animaux
    public List<Animal> listerTous() {
        List<Animal> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT a.*, c.nom as nom_client, c.prenom as prenom_client " +
                         "FROM animaux a JOIN clients c ON a.client_id = c.id ORDER BY a.nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Animal a = new Animal();
                a.setId(rs.getInt("id"));
                a.setClientId(rs.getInt("client_id"));
                a.setNom(rs.getString("nom"));
                a.setEspece(rs.getString("espece"));
                a.setRace(rs.getString("race"));
                a.setSexe(rs.getString("sexe"));
                a.setDateNaissance(rs.getDate("date_naissance"));
                a.setPoids(rs.getDouble("poids"));
                a.setObservations(rs.getString("observations"));
                a.setNomClient(rs.getString("nom_client"));
                a.setPrenomClient(rs.getString("prenom_client"));
                liste.add(a);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }

    // Lister les animaux d'un client
    public List<Animal> listerParClient(int clientId) {
        List<Animal> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM animaux WHERE client_id = ? ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Animal a = new Animal();
                a.setId(rs.getInt("id"));
                a.setClientId(rs.getInt("client_id"));
                a.setNom(rs.getString("nom"));
                a.setEspece(rs.getString("espece"));
                a.setRace(rs.getString("race"));
                a.setSexe(rs.getString("sexe"));
                a.setDateNaissance(rs.getDate("date_naissance"));
                a.setPoids(rs.getDouble("poids"));
                a.setObservations(rs.getString("observations"));
                liste.add(a);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }

    // Ajouter un animal
    public boolean ajouter(Animal a) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "INSERT INTO animaux (client_id, nom, espece, race, sexe, date_naissance, poids, observations) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, a.getClientId());
            ps.setString(2, a.getNom());
            ps.setString(3, a.getEspece());
            ps.setString(4, a.getRace());
            ps.setString(5, a.getSexe());
            ps.setDate(6, a.getDateNaissance());
            ps.setDouble(7, a.getPoids());
            ps.setString(8, a.getObservations());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trouver un animal par ID
    public Animal trouverParId(int id) {
        Animal a = null;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM animaux WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = new Animal();
                a.setId(rs.getInt("id"));
                a.setClientId(rs.getInt("client_id"));
                a.setNom(rs.getString("nom"));
                a.setEspece(rs.getString("espece"));
                a.setRace(rs.getString("race"));
                a.setSexe(rs.getString("sexe"));
                a.setDateNaissance(rs.getDate("date_naissance"));
                a.setPoids(rs.getDouble("poids"));
                a.setObservations(rs.getString("observations"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return a;
    }

    // Modifier un animal
    public boolean modifier(Animal a) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE animaux SET client_id=?, nom=?, espece=?, race=?, sexe=?, date_naissance=?, poids=?, observations=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, a.getClientId());
            ps.setString(2, a.getNom());
            ps.setString(3, a.getEspece());
            ps.setString(4, a.getRace());
            ps.setString(5, a.getSexe());
            ps.setDate(6, a.getDateNaissance());
            ps.setDouble(7, a.getPoids());
            ps.setString(8, a.getObservations());
            ps.setInt(9, a.getId());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Supprimer un animal
    public boolean supprimer(int id) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "DELETE FROM animaux WHERE id = ?";
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
}