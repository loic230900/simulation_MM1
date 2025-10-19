/*classe des évenements: arrivées et départs */

import java.util.LinkedList;

public class Evt{
    //types d'évènements
    public static final int ARRIVEE = 1; 
    public static final int DEPART = 2;
    
    private double date; //date de l'évènement
    private int type; //type de l'évènement 
    private static LinkedList<Evt> recyclage = new LinkedList<Evt>(); //liste statique pour le recyclage des évènements
    private static final int TAILLE_MAX_RECYCLAGE = 100; //taille maximale de la liste de recyclage

    //constructeur
    /**
     * Constructeur privé de la classe Evt
    */
    private Evt(){ }

    /**
     * Méthode statique pour obtenir une instance d'Evt (recyclage si possible)
     * @param date date de l'évènement
     * @param type type de l'évènement (ARRIVEE ou DEPART)
     * @return instance d'Evt
     */
    public static Evt getInstance(double date, int type){
        Evt e;
        if(!recyclage.isEmpty()){
            e = recyclage.poll();
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
     * Ajoute l'instance courante à la liste de recyclage
     */
    public void recycle(){
        if(recyclage.size() < TAILLE_MAX_RECYCLAGE){
            recyclage.add(this);
        }
    }
}