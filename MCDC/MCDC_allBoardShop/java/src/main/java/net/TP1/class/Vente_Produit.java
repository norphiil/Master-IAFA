class Vente_Produit {
    private Integer quantite;
    private Taille taille;
    private Produit produit;

    public Vente_Produit(Integer quantite, Taille taille, Produit produit){
        this.quantite = quantite;
        this.taille = taille;
        this.produit = produit;
    }
    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }
    public Integer getQuantite() {
        return this.quantite;
    }
    public void setTaille(Taille taille) {
        this.taille = taille;
    }
    public Taille getTaille() {
        return this.taille;
    }
    public void setProduit(Produit produit) {
        this.produit = produit;
    }
    public Produit getProduit() {
        return this.produits;
    }
}