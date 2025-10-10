/*classe de l'échéancier */
import java.util.LinkedList;

public class Ech{
    private LinkedList<Evt> ech; //liste des évènements

    /*
     * constructeur initialisant l'échéancier avec un évènement d'arrivée à t=0
     */
    public Ech(){
        ech = new LinkedList<Evt>();
        ech.add(new Evt(0.0, Evt.ARRIVEE)); //à t=0, un évènement d'arrivée est programmé
    }

    /**
     * Insère un évènement dans l'échéancier de manière triée par date
     * @param e évènement à insérer
     */
    public void insertion(Evt e){
        int i = 0;
        //insertion triée par date
        while(i < ech.size() && ech.get(i).getDate() <= e.getDate()){
            i++;
        }
        ech.add(i, e);
    }

    /**
     * Extrait et retourne le premier évènement de l'échéancier
     * @return premier évènement de l'échéancier
     */
    public Evt extraction(){
        return ech.poll();  //retourne et supprime le premier élément de la liste
    }

    /**
     * Vérifie si l'échéancier est vide
     * @return true si l'échéancier est vide, false sinon
     */
    public boolean estVide(){
        return ech.isEmpty();
    }
}