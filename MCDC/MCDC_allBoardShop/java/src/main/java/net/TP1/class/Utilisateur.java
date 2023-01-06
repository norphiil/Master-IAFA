class Utilisateur {
    private String nom;
    private String prenom;
    private String adresse;
    private String mail;
    private String tel;

    // This constructor takes 4 arguments
    public Utilisateur(String nom, String prenom, String adresse, String mail) {
        this(nom, prenom, adresse, mail, null);
    }

    // This constructor takes 5 arguments
    public Utilisateur(String nom, String prenom, String adresse, String mail, String tel) {
        if (nom == null || nom.isEmpty()) {
            throw new IllegalArgumentException("Le nom ne doit pas être vide");
        }
        if (prenom == null || prenom.isEmpty()) {
            throw new IllegalArgumentException("Le prénom ne doit pas être vide");
        }
        if (adresse == null || adresse.isEmpty()) {
            throw new IllegalArgumentException("L'adresse ne doit pas être vide");
        }
        if (mail == null || mail.isEmpty()) {
            throw new IllegalArgumentException("L'adresse mail ne doit pas être vide");
        }
        if (tel != null && !tel.matches("\\d{10}")) {
            throw new IllegalArgumentException("Le numéro de téléphone doit contenir 10 chiffres");
        }
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.mail = mail;
        this.tel = tel;
    }

    // This is the setter for the nom property
    public void setNom(String nom) {
        if (nom == null || nom.isEmpty()) {
            throw new IllegalArgumentException("Le nom ne doit pas être vide");
        }
        this.nom = nom;
    }

    // This is the getter for the nom property
    public String getNom() {
        return this.nom;
    }

    // This is the setter for the prenom property
    public void setPrenom(String prenom) {
        if (prenom == null || prenom.isEmpty()) {
            throw new IllegalArgumentException("Le prénom ne doit pas être vide");
        }
        this.prenom = prenom;
    }

    // This is the getter for the prenom property
    public String getPrenom() {
        return this.prenom;
    }

    // This is the setter for the adresse property
    public void setAdresse(String adresse) {
        if (adresse == null || adresse.isEmpty()) {
            throw new IllegalArgumentException("L'adresse ne doit pas être vide");
        }
        this.adresse = adresse;
    }

    // This is the getter for the adresse property
    public String getAdresse() {
        return this.adresse;
    }

    // This is the setter for the mail property
    public void setMail(String mail) {
        if (mail == null || mail.isEmpty()) {
            throw new IllegalArgumentException("L'adresse mail ne doit pas être vide");
        }
        this.mail = mail;
    }

    // This is the getter for the mail property
    public String getMail() {
        return this.mail;
    }

    // This is the setter for the tel property
    public void setTel(String tel) {
        if (tel != null && !tel.matches("\\d{10}")) {
            throw new IllegalArgumentException("Le numéro de téléphone doit contenir 10 chiffres");
        }
        this.tel = tel;
    }

    // This is the getter for the tel property
    public String getTel() {
        return this.tel;
    }
}