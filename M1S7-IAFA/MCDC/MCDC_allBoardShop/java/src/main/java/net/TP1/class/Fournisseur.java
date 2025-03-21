// This class represents a supplier.
// It is a subclass of Utilisateur (User).

public class Fournisseur extends Utilisateur {
    private Materiel materiel;
    private int quantite;
    private ArrayList<Vente> ventes;

    public Fournisseur(Materiel materiel, int quantite, ArrayList<Vente> ventes) {
        if (materiel == null || quantite <= 0) {
            throw new IllegalArgumentException();
        }

        this.materiel = materiel;
        this.quantite = quantite;
        this.ventes = ventes;
    }

    public void setMateriel(Materiel materiel) {
        if (materiel == null) {
            throw new IllegalArgumentException();
        }

        this.materiel = materiel;
    }

    public Materiel getMateriel() {
        return this.materiel;
    }

    public void setQuantite(int quantite) {
        if (quantite <= 0) {
            throw new IllegalArgumentException();
        }

        this.quantite = quantite;
    }

    public int getQuantite() {
        return this.quantite;
    }

    public void setVentes(ArrayList<Vente> ventes) {
        this.ventes = ventes;
    }

    public ArrayList<Vente> getVentes() {
        return this.ventes;
    }
}
