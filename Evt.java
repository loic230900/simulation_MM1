/*classe des évenements: arrivées et départs */

public class Evt{
    //types d'évènements
    public static final int ARRIVEE = 1; 
    public static final int DEPART = 2;
    
    private double date; //date de l'évènement
    private int type; //type de l'évènement 


    //constructeur
    /**
     * Constructeur d'un évènement
     * @param date date de l'évènement
     * @param type type de l'évènement (ARRIVEE ou DEPART)
     */
    public Evt(double date, int type){
        this.date = date;
        this.type = type;
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

}