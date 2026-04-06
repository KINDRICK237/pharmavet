package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Animal {
    private int id;
    private int clientId;
    private String nom;
    private String espece;
    private String race;
    private String sexe;
    private Date dateNaissance;
    private double poids;
    private String observations;
    private Timestamp dateAjout;

    // Nom du propriétaire (pour affichage)
    private String nomClient;
    private String prenomClient;

    // Constructeur vide
    public Animal() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getEspece() { return espece; }
    public void setEspece(String espece) { this.espece = espece; }

    public String getRace() { return race; }
    public void setRace(String race) { this.race = race; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public Date getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(Date dateNaissance) { this.dateNaissance = dateNaissance; }

    public double getPoids() { return poids; }
    public void setPoids(double poids) { this.poids = poids; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public Timestamp getDateAjout() { return dateAjout; }
    public void setDateAjout(Timestamp dateAjout) { this.dateAjout = dateAjout; }

    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }

    public String getPrenomClient() { return prenomClient; }
    public void setPrenomClient(String prenomClient) { this.prenomClient = prenomClient; }
}