package model;

import java.sql.Timestamp;
import java.util.List;

public class Vente {
    private int id;
    private String numeroFacture;
    private int clientId;
    private int animalId;
    private int utilisateurId;
    private String modePaiement;
    private double montantTotal;
    private String statut;
    private String observations;
    private Timestamp dateVente;

 // Nom du propriétaire (pour affichage)
    private String nomClient;
    private String prenomClient;
    private String nomAnimal;
    private String nomUtilisateur;
    private List<DetailVente> details;

    // Nouveau client (saisie manuelle)
    private String telephoneClient;
    // Constructeur vide
    public Vente() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNumeroFacture() { return numeroFacture; }
    public void setNumeroFacture(String numeroFacture) { this.numeroFacture = numeroFacture; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public int getAnimalId() { return animalId; }
    public void setAnimalId(int animalId) { this.animalId = animalId; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public String getModePaiement() { return modePaiement; }
    public void setModePaiement(String modePaiement) { this.modePaiement = modePaiement; }

    public double getMontantTotal() { return montantTotal; }
    public void setMontantTotal(double montantTotal) { this.montantTotal = montantTotal; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public Timestamp getDateVente() { return dateVente; }
    public void setDateVente(Timestamp dateVente) { this.dateVente = dateVente; }

    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }

    public String getPrenomClient() { return prenomClient; }
    public void setPrenomClient(String prenomClient) { this.prenomClient = prenomClient; }

    public String getNomAnimal() { return nomAnimal; }
    public void setNomAnimal(String nomAnimal) { this.nomAnimal = nomAnimal; }

    public String getNomUtilisateur() { return nomUtilisateur; }
    public void setNomUtilisateur(String nomUtilisateur) { this.nomUtilisateur = nomUtilisateur; }

    public List<DetailVente> getDetails() { return details; }
    public void setDetails(List<DetailVente> details) { this.details = details; }
    public String getTelephoneClient() { return telephoneClient; }
    public void setTelephoneClient(String telephoneClient) { this.telephoneClient = telephoneClient; }
}