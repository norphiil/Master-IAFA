// This code initializes the client class
// The client class inherits from the Utilisateur class
// The client class is used to store information about a client
public class Client extends Utilisateur {
    private boolean privileged;
    private ArrayList<Activite> activities;

    public Client(String nom, String prenom, String adresse, String mail, ArrayList<Activite> activites) {
        this(nom, prenom, adresse, mail, null, false, activites);
    }

    public Client(String nom, String prenom, String adresse, String mail, String tel, ArrayList<Activite> activites) {
        this(nom, prenom, adresse, mail, tel, false, activites);
    }

    public Client(String nom, String prenom, String adresse, String mail, ArrayList<Activite> activites,
            boolean privilegie) {
        this(nom, prenom, adresse, mail, null, privilegie, activites);
    }

    public Client(String nom, String prenom, String adresse, String mail, String tel, ArrayList<Activite> activites,
            boolean privilegie) {
        super(nom, prenom, adresse, mail, tel);
        this.privileged = privilegie;
        this.activities = activites;
    }

    public void setPrivilegie(boolean privilegie) {
        this.privileged = privilegie;
    }

    public boolean getPrivilegie() {
        return this.privileged;
    }

    public void setActivites(ArrayList<Activite> activites) {
        this.activities = activites;
    }

    public ArrayList<Activite> getActivites() {
        return this.activities;
    }
}