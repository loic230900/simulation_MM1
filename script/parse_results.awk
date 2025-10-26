#!/usr/bin/awk -f
BEGIN {
    FS=","; OFS=",";
    # Imprimer l'en-tête CSV avec colonnes théoriques ajoutées
    print "type,param,seed,P0_sim,W_sim,L_sim,throughput_sim,time,P0_theory,W_theory,L_theory,throughput_theory";
}
{
    # Récupérer champs existants
    scenario = $1;
    param = $2;
    seed = $3;
    P0_sim = $4;
    W_sim = $5;
    L_sim = $6;
    throughput_sim = $7;
    time = $8;
    # Calculer valeurs théoriques en fonction du scénario
    # Pour scenario "lambda", param = lambda, mu = 6
    # Pour scenario "n", param = n, on utilise lambda fixe = 5, mu = 6
    if(scenario == "lambda") {
        lam = param; mu = 6;
    } else if(scenario == "n") {
        lam = 5; mu = 6;
    }
    rho = lam / mu;
    P0_theory = 1 - rho;
    # Si λ >= μ (instable), on peut définir théorique = 0 ou infini. Ici λ<=5.95<μ donc stable.
    W_theory = 1 / (mu - lam);
    L_theory = lam / (mu - lam);
    throughput_theory = lam;   # débit effectif = lambda (pas de perte)
    # Impression de la ligne avec valeurs théoriques
    printf "%s,%s,%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n", \
        scenario, param, seed, P0_sim, W_sim, L_sim, throughput_sim, time, \
        P0_theory, W_theory, L_theory, throughput_theory;
}
