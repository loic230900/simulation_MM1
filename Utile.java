/*class regroupant totues les méthodes statiques utile(tirage aléatoire, loi eponentielle, etc) */

public class Utile {
    private static double R;      // variable aléatoire uniforme entre 0 et 1
    private static double X;      // variable aléatoire suivant la loi exponentielle

    // Constructeur privé pour empêcher l'instanciation de cette classe utilitaire
    private Utile() { }

    /**
     * Génère un tirage aléatoire uniforme dans [0,1[.
     * @return une valeur aléatoire uniforme entre 0.0 (inclus) et 1.0 (exclus).
     */
    public static double tirageU() {
        R = Math.random();  // Math.random() génère un nombre aléatoire entre 0 et 1
        return R;
    }
    
    /**
     * Génère un tirage aléatoire suivant une loi exponentielle de paramètre lambda.
     * @param lambda paramètre λ de la loi exponentielle (taux moyen d'événement par unité de temps)
     * @return une durée aléatoire suivant la loi exponentielle de paramètre lambda.
     */
    public static double loiExp(double lambda) {
    // Optimisation 13 : inlining de tirageU
    R = Math.random();
    // Application de la formule inverse : X = -(1/λ) * ln(1 - R)
    X = -Math.log(1 - R) / lambda;
    return X;
    }
}
