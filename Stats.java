/*classe  regroupant la collecte et l'affichage des résultats */

import java.util.ArrayList;

public class Stats{
    private int totalArrivees = 0; //nombre total d'arrivées
    private int totalDepart =0; //nombre total de départs
    private int compteurSansAttente =0; //nombre de clients n'ayant pas attendu
    private double totalTempsOccupe =0.0; //temps total pendant lequel le serveur est occupé
    private double totalTempsVide =0.0; //temps total pendant lequel le serveur est inoccupé
    private double aireSousCourbe =0.0; //aire sous la courbe du nombre de clients dans le système
    private double tempsDernierEvt =0.0; //temps du dernier évènement traité
    private double sommeDureesSejour =0.0; //somme des durées de séjour de tous les clients
    private boolean debug;
    private ArrayList<Double> listeTempsArrivees; //liste des temps d'arrivée des clients


    /**
     * Constructeur de la classe Stats
     * @param debug mode debug (true pour afficher les détails, false pour un résumé)
     */
    public Stats(boolean debug){
        this.debug = debug;
        this.listeTempsArrivees = new ArrayList<Double>();
        this.tempsDernierEvt = 0.0;
    }

    /**
     * Met à jour les statistiques temporelles jusqu a la date courante
     * @param dateCourante date courante de l'évènement traité
     * @param nbClientsDansSysteme nombre de clients dans le système avant le traitement de l'évènement
     */
    public void majStats(double dateCoruante, int nbClientsDansSysteme){
        double diff = dateCoruante - tempsDernierEvt;
        if(diff < 0){
            System.err.println("Erreur: la date courante est inférieure à la date du dernier évènement.");
            return;
        }
        //aire sous la courbe du nombre de clients dans le système
        aireSousCourbe += nbClientsDansSysteme * diff;
        // difference temps occupé et temps vide
        if(nbClientsDansSysteme > 0){
            totalTempsOccupe += diff;
        } else {
            totalTempsVide += diff;
        }
        tempsDernierEvt = dateCoruante;
    }

    
}