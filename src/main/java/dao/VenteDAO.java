package dao;

import connexion.ConnexionDB;
import model.DetailVente;
import model.Vente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VenteDAO {

    // Générer un numéro de facture automatique
    public String genererNumeroFacture() {
        String numero = "";
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT COUNT(*) FROM ventes";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1) + 1;
                numero = "FACT-" + String.format("%04d", count);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return numero;
    }

    // Ajouter une vente avec ses détails
    public boolean ajouter(Vente v, List<DetailVente> details) {
        Connection conn = null;
        try {
            conn = ConnexionDB.getConnexion();
            conn.setAutoCommit(false);

            // Créer nouveau client si nécessaire
            if (v.getClientId() == 0 && v.getNomClient() != null && !v.getNomClient().isEmpty()) {
                String sqlClient = "INSERT INTO clients (nom, prenom, telephone) VALUES (?, ?, ?)";
                PreparedStatement psClient = conn.prepareStatement(sqlClient, Statement.RETURN_GENERATED_KEYS);
                psClient.setString(1, v.getNomClient());
                psClient.setString(2, v.getPrenomClient() != null ? v.getPrenomClient() : "");
                psClient.setString(3, v.getTelephoneClient() != null ? v.getTelephoneClient() : "");
                psClient.executeUpdate();
                ResultSet rsClient = psClient.getGeneratedKeys();
                if (rsClient.next()) v.setClientId(rsClient.getInt(1));
                rsClient.close();
                psClient.close();
            }

            // Insérer la vente
            String sqlVente = "INSERT INTO ventes (numero_facture, client_id, animal_id, utilisateur_id, mode_paiement, montant_total, statut, observations) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psVente = conn.prepareStatement(sqlVente, Statement.RETURN_GENERATED_KEYS);
            psVente.setString(1, v.getNumeroFacture());
            if (v.getClientId() == 0) {
                psVente.setNull(2, java.sql.Types.INTEGER);
            } else {
                psVente.setInt(2, v.getClientId());
            }
            if (v.getAnimalId() == 0) {
                psVente.setNull(3, java.sql.Types.INTEGER);
            } else {
                psVente.setInt(3, v.getAnimalId());
            }
            psVente.setNull(4, java.sql.Types.INTEGER);
            psVente.setString(5, v.getModePaiement());
            psVente.setDouble(6, v.getMontantTotal());
            psVente.setString(7, v.getStatut());
            psVente.setString(8, v.getObservations());
            psVente.executeUpdate();

            ResultSet rs = psVente.getGeneratedKeys();
            int venteId = 0;
            if (rs.next()) venteId = rs.getInt(1);

            // Insérer les détails et mettre à jour le stock
            for (DetailVente d : details) {
                String sqlDetail = "INSERT INTO details_vente (vente_id, medicament_id, nom_medicament_libre, quantite, prix_unitaire, sous_total) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                psDetail.setInt(1, venteId);
                if (d.getMedicamentId() == 0) {
                    psDetail.setNull(2, java.sql.Types.INTEGER);
                } else {
                    psDetail.setInt(2, d.getMedicamentId());
                }
                psDetail.setString(3, d.getNomMedicamentLibre() != null ? d.getNomMedicamentLibre() : "");
                psDetail.setInt(4, d.getQuantite());
                psDetail.setDouble(5, d.getPrixUnitaire());
                psDetail.setDouble(6, d.getSousTotal());
                psDetail.executeUpdate();
                psDetail.close();

                // Mettre à jour le stock seulement si médicament existant
                if (d.getMedicamentId() != 0) {
                    String sqlStock = "UPDATE medicaments SET quantite_stock = quantite_stock - ? WHERE id = ?";
                    PreparedStatement psStock = conn.prepareStatement(sqlStock);
                    psStock.setInt(1, d.getQuantite());
                    psStock.setInt(2, d.getMedicamentId());
                    psStock.executeUpdate();
                    psStock.close();
                }
            }

            conn.commit();
            psVente.close();
            conn.close();
            return true;

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        }
    }

    // Lister toutes les ventes
    public List<Vente> listerTous() {
        List<Vente> liste = new ArrayList<>();
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT v.*, c.nom as nom_client, c.prenom as prenom_client, " +
                         "a.nom as nom_animal, u.nom as nom_utilisateur " +
                         "FROM ventes v " +
                         "LEFT JOIN clients c ON v.client_id = c.id " +
                         "LEFT JOIN animaux a ON v.animal_id = a.id " +
                         "LEFT JOIN utilisateurs u ON v.utilisateur_id = u.id " +
                         "ORDER BY v.date_vente DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vente v = new Vente();
                v.setId(rs.getInt("id"));
                v.setNumeroFacture(rs.getString("numero_facture"));
                v.setClientId(rs.getInt("client_id"));
                v.setAnimalId(rs.getInt("animal_id"));
                v.setModePaiement(rs.getString("mode_paiement"));
                v.setMontantTotal(rs.getDouble("montant_total"));
                v.setStatut(rs.getString("statut"));
                v.setDateVente(rs.getTimestamp("date_vente"));
                v.setNomClient(rs.getString("nom_client"));
                v.setPrenomClient(rs.getString("prenom_client"));
                v.setNomAnimal(rs.getString("nom_animal"));
                v.setNomUtilisateur(rs.getString("nom_utilisateur"));
                liste.add(v);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return liste;
    }

    // Trouver une vente par ID avec ses détails
    public Vente trouverParId(int id) {
        Vente v = null;
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "SELECT v.*, c.nom as nom_client, c.prenom as prenom_client, " +
                         "a.nom as nom_animal, u.nom as nom_utilisateur " +
                         "FROM ventes v " +
                         "LEFT JOIN clients c ON v.client_id = c.id " +
                         "LEFT JOIN animaux a ON v.animal_id = a.id " +
                         "LEFT JOIN utilisateurs u ON v.utilisateur_id = u.id " +
                         "WHERE v.id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                v = new Vente();
                v.setId(rs.getInt("id"));
                v.setNumeroFacture(rs.getString("numero_facture"));
                v.setClientId(rs.getInt("client_id"));
                v.setAnimalId(rs.getInt("animal_id"));
                v.setModePaiement(rs.getString("mode_paiement"));
                v.setMontantTotal(rs.getDouble("montant_total"));
                v.setStatut(rs.getString("statut"));
                v.setObservations(rs.getString("observations"));
                v.setDateVente(rs.getTimestamp("date_vente"));
                v.setNomClient(rs.getString("nom_client"));
                v.setPrenomClient(rs.getString("prenom_client"));
                v.setNomAnimal(rs.getString("nom_animal"));
                v.setNomUtilisateur(rs.getString("nom_utilisateur"));
            }
            rs.close();
            ps.close();

            // Récupérer les détails
            if (v != null) {
                String sqlDetail = "SELECT d.*, " +
                                   "COALESCE(m.nom, d.nom_medicament_libre) as nom_medicament, " +
                                   "COALESCE(m.unite, '') as unite_medicament " +
                                   "FROM details_vente d " +
                                   "LEFT JOIN medicaments m ON d.medicament_id = m.id " +
                                   "WHERE d.vente_id = ?";
                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                psDetail.setInt(1, id);
                ResultSet rsDetail = psDetail.executeQuery();
                List<DetailVente> details = new ArrayList<>();
                while (rsDetail.next()) {
                    DetailVente d = new DetailVente();
                    d.setId(rsDetail.getInt("id"));
                    d.setVenteId(rsDetail.getInt("vente_id"));
                    d.setMedicamentId(rsDetail.getInt("medicament_id"));
                    d.setQuantite(rsDetail.getInt("quantite"));
                    d.setPrixUnitaire(rsDetail.getDouble("prix_unitaire"));
                    d.setSousTotal(rsDetail.getDouble("sous_total"));
                    d.setNomMedicament(rsDetail.getString("nom_medicament"));
                    d.setUniteMedicament(rsDetail.getString("unite_medicament"));
                    details.add(d);
                }
                v.setDetails(details);
                rsDetail.close();
                psDetail.close();
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    // Annuler une vente
    public boolean annuler(int id) {
        try {
            Connection conn = ConnexionDB.getConnexion();
            String sql = "UPDATE ventes SET statut = 'Annulée' WHERE id = ?";
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