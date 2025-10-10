/*class regroupant totues les méthodes statiques utile(tirage aléatoire, loi eponentielle, etc) */

public class Utile{
    
    private static double R; //variable aléatoire uniforme entre 0 et 1
    private static double lambda; //paramètre de la loi exponentielle inter-arrivées
    private static double X; //variable aléatoire suivant la loi exponentielle

    /*
     * constructeur privé pour éviter l'instanciation de la classe
     * toutes les méthodes sont statiques
     */
    private Utile(){
    }

    /**
     * Génère un tirage aléatoire suivant une loi exponentielle de paramètre lambda
     * @param lambda paramètre de la loi exponentielle
     * @return tirage aléatoire suivant la loi exponentielle
     */
    public static double tirageU(){
        R = Math.random(); //Math.random() génère un nombre aléatoire entre 0 et 1
        return R;
    }
    
    /**
     * Génère un tirage aléatoire suivant une loi exponentielle de paramètre lambda
     * @param lambda paramètre de la loi exponentielle
     * @return tirage aléatoire suivant la loi exponentielle
     */
    public static double loiExp(double lambda){
        Utile.lambda = lambda;
        R = tirageU();
        X = -Math.log(1 - R) / Utile.lambda; //loi exponentielle
        return X;
    }

}