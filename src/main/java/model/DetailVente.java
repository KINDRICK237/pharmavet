package model;

public class DetailVente {
    private int id;
    private int venteId;
    private int medicamentId;
    private int quantite;
    private double prixUnitaire;
    private double sousTotal;

 // Informations supplémentaires pour affichage
    private String nomMedicament;
    private String uniteMedicament;
    private String nomMedicamentLibre;

    // Constructeur vide
    public DetailVente() {}

    // Getters et Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getVenteId() { return venteId; }
    public void setVenteId(int venteId) { this.venteId = venteId; }

    public int getMedicamentId() { return medicamentId; }
    public void setMedicamentId(int medicamentId) { this.medicamentId = medicamentId; }

    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }

    public double getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(double prixUnitaire) { this.prixUnitaire = prixUnitaire; }

    public double getSousTotal() { return sousTotal; }
    public void setSousTotal(double sousTotal) { this.sousTotal = sousTotal; }

    public String getNomMedicament() { return nomMedicament; }
    public void setNomMedicament(String nomMedicament) { this.nomMedicament = nomMedicament; }

    public String getUniteMedicament() { return uniteMedicament; }
    public void setUniteMedicament(String uniteMedicament) { this.uniteMedicament = uniteMedicament; }
    public String getNomMedicamentLibre() { return nomMedicamentLibre; }
    public void setNomMedicamentLibre(String nomMedicamentLibre) { this.nomMedicamentLibre = nomMedicamentLibre; }
}