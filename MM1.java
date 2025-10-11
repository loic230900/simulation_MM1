/*classe principale */
public class MM1{
    private double lambda; //taux d'arrivée
    private double mu; //taux de service
    private double dureeSimulation; //durée de la simulation
    private boolean debug; //mode debug

    private Ech echancier;
    private Stats stats;
    private int numClientCourant = 0;
    private double dateDernierDepart = 0.0;
    private int nbClientsDansSysteme = 0; //nombre de clients dans le système

    /**
     * Constructeur de la classe MM1
     * @param lambda taux d'arrivée
     * @param mu taux de service  
     * @param duree durée de simulation
     * @param debug mode debug
     */
    public MM1(double lambda, double mu, double duree, boolean debug) {
        this.lambda = lambda;
        this.mu = mu;
        this.dureeSimulation = duree;
        this.debug = debug;
        
        this.echancier = new Ech();  // Initialise avec arrivée à t=0
        this.stats = new Stats(debug);
        this.numClientCourant = 0;
        this.dateDernierDepart = 0.0;
        this.nbClientsDansSysteme = 0;
    }

    /**
     * Méthode principale du programme
     * @param args arguments de la ligne de commande : lambda, mu, durée, debug
     */
    public static void main(String[] args){
        //verification et parsing des arguments
        if (args.length != 4) {
            System.err.println("Usage: java MM1 <lambda> <mu> <duree> <debug>");
            System.exit(1); 
        }
        double lambda = Double.parseDouble(args[0]);
        double mu = Double.parseDouble(args[1]);
        double duree = Double.parseDouble(args[2]);
        boolean debug = Integer.parseInt(args[3]) == 1; 
        
        //creation de l'instance MM1 et lancement de la simulation
        MM1 simulation = new MM1(lambda, mu, duree, debug);
        simulation.simuler();
    }

    /**
     * Lance la simulation de la file M/M/1
     * Boucle principale qui traite les événements jusqu'à la fin de la simulation
     */
    private void simuler(){
        //boucle principale
        while(!echancier.estVide()){
            Evt evt = echancier.extraction();
            double dateEvt = evt.getDate();

            // Vérifier si on dépasse la durée de simulation
            if(dateEvt > dureeSimulation){
                break;
            }

            //mettre à jour les statistiques temporelles
            stats.majStats(dateEvt, nbClientsDansSysteme);

            if(evt.getType() == Evt.ARRIVEE){
                traiterArrivee(dateEvt);
            } else if(evt.getType() == Evt.DEPART){
                traiterDepart(dateEvt);
            } else {
                System.err.println("Erreur: type d'évènement inconnu.");
            }
        }
        //affichage des statistiques finales
        stats.afficherResultatsTheoriques(lambda, mu, dureeSimulation);
        stats.afficherResultatsSimulation(dureeSimulation);
    }

    /**
     * Traite un événement d'arrivée d'un client
     * @param dateArrivee date de l'arrivée du client
     */
    private void traiterArrivee(double dateArrivee) {
        boolean fileVide = (nbClientsDansSysteme == 0);
        
        //statistiques d'arrivee 
        stats.enregistrerArrivee(dateArrivee, fileVide);
        
        //programmer la prochaine arrivée
        double prochaineArrivee = dateArrivee + Utile.loiExp(lambda);
        if(prochaineArrivee <= dureeSimulation){
            echancier.insertion(new Evt(prochaineArrivee, Evt.ARRIVEE));
        }

        //programmer depart du client courant
        double dateDepart;
        if(fileVide){
            //file vide, le client est servi immédiatement
            dateDepart = dateArrivee + Utile.loiExp(mu);
        } else {
            //file non vide, le client attend la fin du service du client courant
            dateDepart = dateDernierDepart + Utile.loiExp(mu);
        }

        echancier.insertion(new Evt(dateDepart, Evt.DEPART));
        dateDernierDepart = Math.max(dateDernierDepart, dateDepart);

        nbClientsDansSysteme++;
        numClientCourant++;
    }

    /**
     * Traite un événement de départ d'un client
     * @param dateDepart date du départ du client
     */
    private void traiterDepart(double dateDepart) {
        // Trouver la date d'arrivée correspondante (FIFO)
        double dateArrivee = stats.getTempsArrivee(stats.getTotalDepart());
        
        stats.enregistrerDepart(dateDepart, dateArrivee);
        nbClientsDansSysteme--;
    }

}