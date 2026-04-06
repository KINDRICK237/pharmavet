package dao;

import connexion.ConnexionDB;
import model.Vente;

import java.sql.*;
import java.util.*;

public class StatistiqueDAO {

    // Chiffre d'affaires du jour
    public double chiffreAffairesJour() {
        double total = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes " +
                         "WHERE DATE(date_vente) = CURDATE() AND statut = 'Payée'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getDouble(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    // Chiffre d'affaires du mois
    public double chiffreAffairesMois() {
        double total = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes " +
                         "WHERE MONTH(date_vente) = MONTH(CURDATE()) " +
                         "AND YEAR(date_vente) = YEAR(CURDATE()) AND statut = 'Payée'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getDouble(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    // Chiffre d'affaires total
    public double chiffreAffairesTotal() {
        double total = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes WHERE statut = 'Payée'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total = rs.getDouble(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    // Nombre de ventes du jour
    public int nombreVentesJour() {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM ventes WHERE DATE(date_vente) = CURDATE() AND statut = 'Payée'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // Nombre de ventes du mois
    public int nombreVentesMois() {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM ventes WHERE MONTH(date_vente) = MONTH(CURDATE()) " +
                         "AND YEAR(date_vente) = YEAR(CURDATE()) AND statut = 'Payée'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // Nombre total de clients
    public int nombreClients() {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM clients";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // Nombre de médicaments en stock faible
    public int nombreStockFaible() {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM medicaments WHERE quantite_stock <= seuil_alerte";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // Nombre total de médicaments
    public int nombreMedicaments() {
        int count = 0;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM medicaments";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // Ventes des 7 derniers jours (pour graphique)
    public Map<String, Double> ventesParJour() {
        Map<String, Double> data = new LinkedHashMap<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT DATE(date_vente) as jour, COALESCE(SUM(montant_total), 0) as total " +
                         "FROM ventes WHERE date_vente >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                         "AND statut = 'Payée' GROUP BY DATE(date_vente) ORDER BY jour ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("jour"), rs.getDouble("total"));
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return data;
    }

    // Top 5 médicaments les plus vendus
    public List<Map<String, Object>> topMedicaments() {
        List<Map<String, Object>> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COALESCE(m.nom, d.nom_medicament_libre) as nom, " +
                         "SUM(d.quantite) as total_quantite, " +
                         "SUM(d.sous_total) as total_montant " +
                         "FROM details_vente d " +
                         "LEFT JOIN medicaments m ON d.medicament_id = m.id " +
                         "JOIN ventes v ON d.vente_id = v.id " +
                         "WHERE v.statut = 'Payée' " +
                         "GROUP BY COALESCE(m.nom, d.nom_medicament_libre) " +
                         "ORDER BY total_quantite DESC LIMIT 5";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("nom", rs.getString("nom"));
                item.put("quantite", rs.getInt("total_quantite"));
                item.put("montant", rs.getDouble("total_montant"));
                liste.add(item);
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return liste;
    }

    // Dernières ventes
    public List<Vente> dernieresVentes(int limite) {
        List<Vente> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT v.*, c.nom as nom_client, c.prenom as prenom_client " +
                         "FROM ventes v LEFT JOIN clients c ON v.client_id = c.id " +
                         "ORDER BY v.date_vente DESC LIMIT ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vente v = new Vente();
                v.setId(rs.getInt("id"));
                v.setNumeroFacture(rs.getString("numero_facture"));
                v.setMontantTotal(rs.getDouble("montant_total"));
                v.setModePaiement(rs.getString("mode_paiement"));
                v.setStatut(rs.getString("statut"));
                v.setDateVente(rs.getTimestamp("date_vente"));
                v.setNomClient(rs.getString("nom_client"));
                v.setPrenomClient(rs.getString("prenom_client"));
                liste.add(v);
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return liste;
    }

    // Répartition paiements
    public Map<String, Integer> repartitionPaiements() {
        Map<String, Integer> data = new LinkedHashMap<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT mode_paiement, COUNT(*) as total FROM ventes " +
                         "WHERE statut = 'Payée' GROUP BY mode_paiement";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("mode_paiement"), rs.getInt("total"));
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        return data;
    }
}