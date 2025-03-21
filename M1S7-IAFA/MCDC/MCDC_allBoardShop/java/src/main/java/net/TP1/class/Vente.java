//This code is used to create a new Vente object, which contains information about a sale.
//The Vente object has a name, a start date, an end date, a description, the list of activities associated with the sale, and the Vente_Produit object associated with the sale.
//The Vente_Produit object contains information about the products that are sold during the sale.
//The Vente_Produit object has a list of Produit objects, which contains information about the products that are sold.
//The Produit object has a name, a price, a category, and a description.

class Vente {
    private String nom;
    private Date date_debut;
    private Date date_fin;
    private String description;
    private ArrayList<Activite> activites;
    private ArrayList<Vente_Produit> venteProduit;

    public Vente(String nom, Date date_debut, Date date_fin, String description, ArrayList<Vente_Produit> venteProduit,
            ArrayList<Activite> activites) {
        if (nom == null) {
            throw new IllegalArgumentException("nom cannot be null");
        }
        if (date_debut == null) {
            throw new IllegalArgumentException("date_debut cannot be null");
        }
        if (date_fin == null) {
            throw new IllegalArgumentException("date_fin cannot be null");
        }
        if (description == null) {
            throw new IllegalArgumentException("description cannot be null");
        }
        if (activites == null) {
            throw new IllegalArgumentException("activites cannot be null");
        }
        if (venteProduit == null) {
            throw new IllegalArgumentException("venteProduit cannot be null");
        }
        this.nom = nom;
        this.date_debut = date_debut;
        this.date_fin = date_fin;
        this.description = description;
        this.activites = activites;
        this.venteProduit = venteProduit;
    }

    public void setNom(String nom) {
        if (nom == null) {
            throw new IllegalArgumentException("nom cannot be null");
        }
        this.nom = nom;
    }

    public String getNom() {
        return this.nom;
    }

    public void setDate_debut(Date date_debut) {
        if (date_debut == null) {
            throw new IllegalArgumentException("date_debut cannot be null");
        }
        this.date_debut = date_debut;
    }

    public Date getDate_debut() {
        return this.date_debut;
    }

    public void setDate_fin(Date date_fin) {
        if (date_fin == null) {
            throw new IllegalArgumentException("date_fin cannot be null");
        }
        this.date_fin = date_fin;
    }

    public Date getDate_fin() {
        return this.date_fin;
    }

    public void setDescription(String description) {
        if (description == null) {
            throw new IllegalArgumentException("description cannot be null");
        }
        this.description = description;
    }

    public String getDescription() {
        return this.description;
    }

    public void setActivites(ArrayList<Activite> activites) {
        if (activites == null) {
            throw new IllegalArgumentException("activites cannot be null");
        }
        this.activites = activites;
    }

    public ArrayList<Activite> getActivites() {
        return this.activites;
    }

    public void setVenteProduit(ArrayList<Vente_Produit> venteProduit) {
        if (venteProduit == null) {
            throw new IllegalArgumentException("venteProduit cannot be null");
        }
        this.venteProduit = venteProduit;
    }

    public ArrayList<Vente_Produit> getVenteProduit() {
        return this.venteProduit;
    }
}