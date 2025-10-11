/*classe  regroupant la collecte et l'affichage des résultats */

import java.util.ArrayList;

public class Stats{
    private int totalArrivees = 0; //nombre total d'arrivées
    public int totalDepart =0; //nombre total de départs
    private int compteurSansAttente =0; //nombre de clients n'ayant pas attendu
    private double totalTempsOccupe =0.0; //temps total pendant lequel le serveur est occupé
    private double totalTempsVide =0.0; //temps total pendant lequel le serveur est inoccupé
    private double aireSousCourbe =0.0; //aire sous la courbe du nombre de clients dans le système
    private double tempsDernierEvt =0.0; //temps du dernier évènement traité
    private double sommeDureesSejour =0.0; //somme des durées de séjour de tous les clients
    private boolean debug;
    public ArrayList<Double> listeTempsArrivees; //liste des temps d'arrivée des clients


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
    public void majStats(double dateCourante, int nbClientsDansSysteme){
        double diff = dateCourante - tempsDernierEvt;
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
        tempsDernierEvt = dateCourante;
    }

    /**
     * Enregistre l'arrivée d'un client
     * @param dateArrivee date d'arrivée du client
     * @param filVide true si le serveur était libre à l'arrivée, false sinon
     */
    public void enregistrerArrivee(double dateArrivee, boolean fileVide){
        totalArrivees++;
        listeTempsArrivees.add(dateArrivee);
        if(fileVide){
            compteurSansAttente++;
        }
        if(debug){
            System.out.println("Date=" + dateArrivee + " Arrivee client #" + (totalArrivees - 1));
        }
    }

    /**
     * Enregistre le départ d'un client
     * @param dateDepart date de départ du client
     * @param dateArrivee date d'arrivée du client
     */
    public void enregistrerDepart(double dateDepart, double dateArrivee){
        totalDepart++;
        double dureeSejour = dateDepart - dateArrivee;
        sommeDureesSejour += dureeSejour;
        if (debug) {
            System.out.println("Date=" + dateDepart + " Depart client #" + (totalDepart - 1) + "  arrive a t=" + dateArrivee);
        }
    }

    /**
     * Affiche les résultats théoriques
     */
    public void afficherResultatsTheoriques(double lambda, double mu, double duree) {
        double ro = lambda / mu;
        System.out.println("--------------------");
        System.out.println("RESULTATS THEORIQUES");
        System.out.println("--------------------");
        System.out.println("lambda<mu : file stable");
        System.out.println("ro (lambda/mu) = " + ro);
        System.out.println("nombre de clients attendus (lambda x duree) = " + (lambda * duree));
        System.out.println("Prob de service sans attente (1 - ro) = " + (1 - ro));
        System.out.println("Prob file occupee (ro) = " + ro);
        System.out.println("Debit (lambda) = " + lambda);
        System.out.println("Esp nb clients (ro/1-ro) = " + (ro / (1 - ro)));
        System.out.println("Temps moyen de sejour (1/mu(1-ro)) = " + (1 / (mu * (1 - ro))));
    }

    /**
     * Affiche les résultats de simulation
     */
    public void afficherResultatsSimulation(double dureeSimulation) {
        System.out.println("--------------------");
        System.out.println("RESULTATS SIMULATION");
        System.out.println("--------------------");
        System.out.println("Nombre total de clients = " + totalArrivees);
        System.out.println("Proportion clients sans attente = " + 
                        (double) compteurSansAttente / totalArrivees);
        System.out.println("Proportion clients avec attente = " + 
                        (double) (totalArrivees - compteurSansAttente) / totalArrivees);
        System.out.println("Debit = " + (double) totalArrivees / dureeSimulation);
        System.out.println("Nb moyen de clients dans systeme = " + 
                        aireSousCourbe / dureeSimulation);
        System.out.println("Temps moyen de sejour = " + 
                        sommeDureesSejour / totalDepart);
    }

    /**
     * Retourne la date d'arrivée d'un client donné (pour respecter l'ordre FIFO)
     * @param index index du client dans la liste des arrivées
     * @return date d'arrivée du client
     */
    public double getTempsArrivee(int index) {
        return listeTempsArrivees.get(index);
    }

    /**
     * Retourne le nombre total de départs traités
     * @return nombre total de départs
     */
    public int getTotalDepart() {
        return totalDepart;
    }

}