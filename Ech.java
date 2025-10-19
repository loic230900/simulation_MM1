/*classe de l'échéancier */
import java.util.LinkedList;
import java.util.ListIterator;

public class Ech{
    private LinkedList<Evt> ech; //liste des évènements

    /*
     * constructeur initialisant l'échéancier avec un évènement d'arrivée à t=0
     */
    public Ech(){
        ech = new LinkedList<Evt>();
        ech.add(Evt.getInstance(0.0,Evt.ARRIVEE)); //à t=0, un évènement d'arrivée est programmé
    }

    /**
     * Insère un évènement dans l'échéancier de manière triée par date
     * @param e évènement à insérer
     */
    public void insertion(Evt e){
        //cas rapide: insererer a la fin si date plus grande que la dernière
        if(ech.isEmpty() || e.getDate() >= ech.getLast().getDate()){
            ech.addLast(e);
            return;
        }
        //cas rapide: insererer au début si date plus petite que la première
        if(e.getDate() < ech.getFirst().getDate()){
            ech.addFirst(e);
            return;
        }
        //utilisation d'un itérateur pour parcourir la liste
        ListIterator<Evt> it = ech.listIterator();
        int index = 0;
        while(it.hasNext()){
            if(it.next().getDate() > e.getDate()){
                break;
            }
            index++;
        }
        ech.add(index, e);
    }
    /** fonction alternative utilisant une boucle
    public void insertion(Evt e){
        int i = 0;
        //insertion triée par date
        while(i < ech.size() && ech.get(i).getDate() <= e.getDate()){
            i++;
        }
        ech.add(i, e);
    }*/

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