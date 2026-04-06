package dao;

import connexion.ConnexionDB;
import model.Medicament;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicamentDAO {

    // Lister tous les médicaments
    public List<Medicament> listerTous() {
        List<Medicament> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM medicaments ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Medicament m = new Medicament();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setDescription(rs.getString("description"));
                m.setCategorie(rs.getString("categorie"));
                m.setUnite(rs.getString("unite"));
                m.setPrixAchat(rs.getDouble("prix_achat"));
                m.setPrixVente(rs.getDouble("prix_vente"));
                m.setQuantiteStock(rs.getInt("quantite_stock"));
                m.setSeuilAlerte(rs.getInt("seuil_alerte"));
                m.setDateExpiration(rs.getDate("date_expiration"));
                m.setFournisseur(rs.getString("fournisseur"));
                liste.add(m);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }

    // Ajouter un médicament
    public boolean ajouter(Medicament m) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "INSERT INTO medicaments (nom, description, categorie, unite, prix_achat, prix_vente, quantite_stock, seuil_alerte, date_expiration, fournisseur) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, m.getNom());
            ps.setString(2, m.getDescription());
            ps.setString(3, m.getCategorie());
            ps.setString(4, m.getUnite());
            ps.setDouble(5, m.getPrixAchat());
            ps.setDouble(6, m.getPrixVente());
            ps.setInt(7, m.getQuantiteStock());
            ps.setInt(8, m.getSeuilAlerte());
            ps.setDate(9, m.getDateExpiration());
            ps.setString(10, m.getFournisseur());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trouver un médicament par ID
    public Medicament trouverParId(int id) {
        Medicament m = null;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM medicaments WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                m = new Medicament();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setDescription(rs.getString("description"));
                m.setCategorie(rs.getString("categorie"));
                m.setUnite(rs.getString("unite"));
                m.setPrixAchat(rs.getDouble("prix_achat"));
                m.setPrixVente(rs.getDouble("prix_vente"));
                m.setQuantiteStock(rs.getInt("quantite_stock"));
                m.setSeuilAlerte(rs.getInt("seuil_alerte"));
                m.setDateExpiration(rs.getDate("date_expiration"));
                m.setFournisseur(rs.getString("fournisseur"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    // Modifier un médicament
    public boolean modifier(Medicament m) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE medicaments SET nom=?, description=?, categorie=?, unite=?, prix_achat=?, prix_vente=?, quantite_stock=?, seuil_alerte=?, date_expiration=?, fournisseur=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, m.getNom());
            ps.setString(2, m.getDescription());
            ps.setString(3, m.getCategorie());
            ps.setString(4, m.getUnite());
            ps.setDouble(5, m.getPrixAchat());
            ps.setDouble(6, m.getPrixVente());
            ps.setInt(7, m.getQuantiteStock());
            ps.setInt(8, m.getSeuilAlerte());
            ps.setDate(9, m.getDateExpiration());
            ps.setString(10, m.getFournisseur());
            ps.setInt(11, m.getId());
            ps.executeUpdate();
            ps.close();
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Supprimer un médicament
    public boolean supprimer(int id) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "DELETE FROM medicaments WHERE id = ?";
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

    // Médicaments en stock faible
    public List<Medicament> stockFaible() {
        List<Medicament> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT * FROM medicaments WHERE quantite_stock <= seuil_alerte";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Medicament m = new Medicament();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setQuantiteStock(rs.getInt("quantite_stock"));
                m.setSeuilAlerte(rs.getInt("seuil_alerte"));
                liste.add(m);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }
}