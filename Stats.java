/*classe  regroupant la collecte et l'affichage des résultats */

// (plus besoin d'import ArrayList)

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
    private double[] listeTempsArrivees;
    private int capacite = 1000000; // Augmenter la capacité initiale pour éviter les redimensionnements
    private int taille = 0;


    /**
     * Constructeur de la classe Stats
     * @param debug mode debug (true pour afficher les détails, false pour un résumé)
     */
    public Stats(boolean debug){
        this.debug = debug;
    this.listeTempsArrivees = new double[capacite];
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
        // Optimisation : redimensionnement plus efficace avec croissance exponentielle
        if(taille >= capacite){
            capacite = capacite + (capacite >> 1); // Croissance de 50% au lieu de doubler
            double[] nouveau = new double[capacite];
            System.arraycopy(listeTempsArrivees, 0, nouveau, 0, taille);
            listeTempsArrivees = nouveau;
        }
        listeTempsArrivees[taille++] = dateArrivee;
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
    // Ajouter une méthode plus directe

    /**
     * Affiche les résultats théoriques
     * @param lambda taux d'arrivée
     * @param mu taux de service
     * @param duree durée de la simulation
     * @return void
     */
    public void afficherResultatsTheoriques(double lambda, double mu, double duree) {
        double ro = lambda / mu;
        double unMoinsRo = 1 - ro;
        double roSurUnMoinsRo = ro / unMoinsRo;
        double tempsMoyenSejour = 1 / (mu * unMoinsRo);
        System.out.println("--------------------");
        System.out.println("RESULTATS THEORIQUES");
        System.out.println("--------------------");
        System.out.println("lambda<mu : file stable");
        System.out.println("ro (lambda/mu) = " + ro);
        System.out.println("nombre de clients attendus (lambda x duree) = " + (lambda * duree));
        System.out.println("Prob de service sans attente (1 - ro) = " + unMoinsRo);
        System.out.println("Prob file occupee (ro) = " + ro);
        System.out.println("Debit (lambda) = " + lambda);
        System.out.println("Esp nb clients (ro/1-ro) = " + roSurUnMoinsRo);
        System.out.println("Temps moyen de sejour (1/mu(1-ro)) = " + tempsMoyenSejour);
    }

    /**
     * Enregistre le départ d'un client
     * @param dateDepart date de départ du client
     * @return date d'arrivée du client
     */
    public double getEtEnregistrerDepart(double dateDepart) {
        double dateArrivee = listeTempsArrivees[totalDepart];
        totalDepart++;
        double dureeSejour = dateDepart - dateArrivee;
        sommeDureesSejour += dureeSejour;
        if (debug) {
            System.out.println("Date=" + dateDepart + " Depart client #" + (totalDepart - 1) + "  arrive a t=" + dateArrivee);
        }
        return dateArrivee;
    }
    /**
     * Affiche les résultats de simulation
     * @param dureeSimulation durée de la simulation
     * @return void
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
    return listeTempsArrivees[index];
    }

    /**
     * Retourne le nombre total de départs traités
     * @return nombre total de départs
     */
    public int getTotalDepart() {
        return totalDepart;
    }

}