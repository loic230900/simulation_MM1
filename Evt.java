/*classe des évenements: arrivées et départs */

public class Evt{
    //types d'évènements
    public static final int ARRIVEE = 1; 
    public static final int DEPART = 2;
    
    private double date; //date de l'évènement
    private int type; //type de l'évènement 
    
    //Pool de recyclage avec tableau circulaire (optimisation #6)
    private static final int TAILLE_MAX_RECYCLAGE = 10000; //taille maximale du pool de recyclage
    private static final Evt[] recyclage = new Evt[TAILLE_MAX_RECYCLAGE];
    private static int indexRecyclage = 0; //index du prochain emplacement disponible
        // Bloc d'initialisation statique : pré-allocation du pool
        static {
            for(int i = 0; i < TAILLE_MAX_RECYCLAGE; i++){
                recyclage[i] = new Evt();
            }
            indexRecyclage = TAILLE_MAX_RECYCLAGE; // pool plein au démarrage
        }

    /**
     * Constructeur privé de la classe Evt
    */
    private Evt(){ }

    /**
     * Méthode statique pour obtenir une instance d'Evt (recyclage si possible)
     * Utilise un tableau circulaire pour un recyclage ultra-rapide
     * @param date date de l'évènement
     * @param type type de l'évènement (ARRIVEE ou DEPART)
     * @return instance d'Evt
     */
    public static Evt getInstance(double date, int type){
        Evt e;
        if(indexRecyclage > 0){
            e = recyclage[--indexRecyclage]; //récupérer du pool (décrémenter puis accéder)
        } else {
            e = new Evt();
        }
        e.date = date;
        e.type = type;
        return e;
    }

    //getters et setters
    public double getDate() {
        return date;
    }
    public void setDate(double date) {
        this.date = date;
    }
    public int getType() {
        return type;
    }
    public void setType(int type) {
        this.type = type;
    }

    /*
     * Méthode pour recycler une instance d'Evt
     * Ajoute l'instance courante au tableau de recyclage (tableau circulaire)
     */
    public void recycle(){
        if(indexRecyclage < TAILLE_MAX_RECYCLAGE){
            recyclage[indexRecyclage++] = this; //stocker dans le pool (accéder puis incrémenter)
        }
    }
}