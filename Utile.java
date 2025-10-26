/*class regroupant totues les méthodes statiques utile(tirage aléatoire, loi eponentielle, etc) */

import java.util.Random;

public class Utile {
    private static double R;      // variable aléatoire uniforme entre 0 et 1
    private static Random random = new Random(); // Générateur aléatoire avec seed contrôlable

    /**
     * Constructeur privé pour empêcher l'instanciation de cette classe utilitaire
     */
    private Utile() { }

    /**
     * Définit la graine (seed) du générateur aléatoire pour la reproductibilité
     * @param seed graine pour le générateur pseudo-aléatoire
     */
    public static void setSeed(long seed) {
        random = new Random(seed);
    }

    /**
     * Génère un tirage aléatoire uniforme dans [0,1[.
     * @return une valeur aléatoire uniforme entre 0.0 (inclus) et 1.0 (exclus).
     */
    public static double tirageU() {
        R = random.nextDouble();  // Utilise le générateur Random avec seed contrôlable
        return R;
    }
    
    /**
     * Génère un tirage aléatoire suivant une loi exponentielle de paramètre lambda.
     * @param lambda paramètre λ de la loi exponentielle (taux moyen d'événement par unité de temps)
     * @return une durée aléatoire suivant la loi exponentielle de paramètre lambda.
     */
    public static double loiExp(double lambda) {
        double r = random.nextDouble();
        // Application de la formule inverse : X = -(1/λ) * ln(1 - R)
        // Éviter ln(0) en utilisant ln(R) au lieu de ln(1-R) quand R est proche de 1
        return -Math.log(r) / lambda;
    }
}
