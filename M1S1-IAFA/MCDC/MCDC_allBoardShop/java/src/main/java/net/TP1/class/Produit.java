// This is a class that represents a product. It contains
// the name of the product and the price.

public class Produit {

    private String nom;
    private String description;
    private String photo;
    private Float prixBase;
    private Float prixVente;

    public Produit(String nom, String description, String photo, Float prixBase, Float prixVente) {
        this.setNom(nom);
        this.setDescription(description);
        this.setPhoto(photo);
        this.setPrixBase(prixBase);
        this.setPrixVente(prixVente);
    }

    public void setNom(String nom) {
        if (nom == null) {
            throw new IllegalArgumentException("nom is null");
        }
        this.nom = nom;
    }

    public String getNom() {
        return this.nom;
    }

    public void setDescription(String description) {
        if (description == null) {
            throw new IllegalArgumentException("description is null");
        }
        this.description = description;
    }

    public String getDescription() {
        return this.description;
    }

    public void setPhoto(String photo) {
        if (photo == null) {
            throw new IllegalArgumentException("photo is null");
        }
        this.photo = photo;
    }

    public String getPhoto() {
        return this.photo;
    }

    public void setPrixBase(Float prixBase) {
        if (prixBase == null) {
            throw new IllegalArgumentException("prixBase is null");
        }
        this.prixBase = prixBase;
    }

    public Float getPrixBase() {
        return this.prixBase;
    }

    public void setPrixVente(Float prixVente) {
        if (prixVente == null) {
            throw new IllegalArgumentException("prixVente is null");
        }
        this.prixVente = prixVente;
    }

    public Float getPrixVente() {
        return this.prixVente;
    }
}