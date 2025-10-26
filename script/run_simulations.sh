#!/bin/bash
# Script Bash pour exécuter les simulations M/M/1 sur les plages de paramètres demandées

# Vérifier que le programme Java est compilé
if [ ! -f "../MM1.class" ]; then
    echo "Erreur: MM1.class introuvable. Veuillez compiler le programme Java avec 'make compile'"
    exit 1
fi

# Constantes
MU=6                   # taux de service fixé
FIXED_LAMBDA=5         # lambda fixé pour le balayage en T
FIXED_T=10000000       # T (durée de simulation) pour le balayage en lambda

# Listes de valeurs à tester (utilise les variables d'environnement si définies)
# Balayage de lambda : valeurs stratégiques pour couvrir différentes charges
if [ ${#LAMBDA_VALUES[@]} -eq 0 ]; then
    # Faible charge (ρ < 0.5): 0.06, 0.5, 1.0, 2.0
    # Charge moyenne (0.5 ≤ ρ < 0.8): 3.0, 4.0, 4.5
    # Forte charge (0.8 ≤ ρ < 0.95): 5.0, 5.5
    # Charge critique (ρ ≥ 0.95): 5.7, 5.9
    LAMBDA_VALUES=(0.06 0.5 1.0 2.0 3.0 4.0 4.5 5.0 5.5 5.7 5.9)
fi

# Balayage de T : valeurs stratégiques pour analyser la convergence
if [ ${#T_VALUES[@]} -eq 0 ]; then
    # Petites simulations: 1000, 10000
    # Moyennes simulations: 100000, 1000000
    # Grandes simulations: 10000000
    T_VALUES=(1000 10000 100000 1000000 10000000)
fi

# Valeurs de lambda pour le balayage de T : charges représentatives
if [ ${#LAMBDA_FOR_T_VALUES[@]} -eq 0 ]; then
    # Faible charge: λ=1 (ρ=0.167)
    # Charge moyenne: λ=3 (ρ=0.5)
    # Forte charge: λ=5 (ρ=0.833)
    # Charge critique: λ=5.9 (ρ=0.983)
    LAMBDA_FOR_T_VALUES=(1 3 5 5.9)
fi

# Nombre de réplications : 100 pour avoir des intervalles de confiance fiables
if [ -z "$REPLICATIONS" ]; then
    REPLICATIONS=100
fi

# Fichier de sortie
RAW_CSV="sim_results.csv"
> "$RAW_CSV"  # vider/créer le fichier de résultats brut

# Ajouter l'en-tête CSV
echo "type,param,seed,P0_sim,W_sim,L_sim,throughput_sim,time,P0_th,W_th,L_th,thr_th" > "$RAW_CSV"

echo "=== Simulation M/M/1 avec programme Java ==="
echo "Total simulations: $(( ${#LAMBDA_VALUES[@]} * REPLICATIONS + ${#LAMBDA_FOR_N_VALUES[@]} * ${#N_VALUES[@]} * REPLICATIONS ))"
echo "Fichier de résultats: $RAW_CSV"
echo ""

current_sim=0
total_sims=$(( ${#LAMBDA_VALUES[@]} * REPLICATIONS + ${#LAMBDA_FOR_N_VALUES[@]} * ${#N_VALUES[@]} * REPLICATIONS ))

# Boucle sur les valeurs de lambda
for lam in "${LAMBDA_VALUES[@]}"; do
    echo "Configuration: λ=$lam μ=$MU n=$FIXED_N"
    for seed in $(seq 1 $REPLICATIONS); do
        current_sim=$((current_sim + 1))
        printf "\r[%3d%%] Simulation %d/%d (λ=%s, seed=%d)" $((current_sim * 100 / total_sims)) "$current_sim" "$total_sims" "$lam" "$seed"
        
        # Exécuter le programme Java et mesurer le temps
        exec_time=$(cd .. && /usr/bin/time -f "%e" java MM1 "$lam" "$MU" "$FIXED_N" 0 "$seed" 2>&1 | tail -n1)
        output=$(cd .. && java MM1 "$lam" "$MU" "$FIXED_N" 0 "$seed" 2>&1)
        
        # Extraire les métriques avec des expressions régulières plus robustes
        p0_sim=$(echo "$output" | grep "Proportion clients sans attente" | sed 's/.*= \([0-9.]*\).*/\1/')
        w_sim=$(echo "$output" | grep "Temps moyen de sejour" | tail -n1 | sed 's/.*= \([0-9.]*\).*/\1/')
        l_sim=$(echo "$output" | grep "Nb moyen de clients dans systeme" | sed 's/.*= \([0-9.]*\).*/\1/')
        thr_sim=$(echo "$output" | grep "Debit =" | sed 's/.*= \([0-9.]*\).*/\1/')
        
        p0_th=$(echo "$output" | grep "Prob de service sans attente" | sed 's/.*= \([0-9.]*\).*/\1/')
        w_th=$(echo "$output" | grep "Temps moyen de sejour" | head -n1 | sed 's/.*= \([0-9.]*\).*/\1/')
        l_th=$(echo "$output" | grep "Esp nb clients" | sed 's/.*= \([0-9.]*\).*/\1/')
        thr_th=$(echo "$output" | grep "Debit (lambda)" | sed 's/.*= \([0-9.]*\).*/\1/')
        
        # Afficher le temps d'exécution dans la sortie
        printf " (%.2fs)" "$exec_time"
        
        # Afficher en format CSV avec le temps d'exécution réel
        echo "lambda,$lam,$seed,$p0_sim,$w_sim,$l_sim,$thr_sim,$exec_time,$p0_th,$w_th,$l_th,$thr_th" >> "$RAW_CSV"
    done
    echo ""
done

# Boucle sur les valeurs de n
for lam_n in "${LAMBDA_FOR_N_VALUES[@]}"; do
    echo "Balayage de n pour λ=$lam_n μ=$MU"
    for n in "${N_VALUES[@]}"; do
        echo "Configuration: λ=$lam_n μ=$MU n=$n"
        for seed in $(seq 1 $REPLICATIONS); do
            current_sim=$((current_sim + 1))
            printf "\r[%3d%%] Simulation %d/%d (λ=%s, n=%d, seed=%d)" $((current_sim * 100 / total_sims)) "$current_sim" "$total_sims" "$lam_n" "$n" "$seed"
            
            # Exécuter le programme Java et mesurer le temps
            exec_time=$(cd .. && /usr/bin/time -f "%e" java MM1 "$lam_n" "$MU" "$n" 0 "$seed" 2>&1 | tail -n1)
            output=$(cd .. && java MM1 "$lam_n" "$MU" "$n" 0 "$seed" 2>&1)
            
            # Extraire les métriques
            p0_sim=$(echo "$output" | grep "Proportion clients sans attente" | sed 's/.*= \([0-9.]*\).*/\1/')
            w_sim=$(echo "$output" | grep "Temps moyen de sejour" | tail -n1 | sed 's/.*= \([0-9.]*\).*/\1/')
            l_sim=$(echo "$output" | grep "Nb moyen de clients dans systeme" | sed 's/.*= \([0-9.]*\).*/\1/')
            thr_sim=$(echo "$output" | grep "Debit =" | sed 's/.*= \([0-9.]*\).*/\1/')
            
            p0_th=$(echo "$output" | grep "Prob de service sans attente" | sed 's/.*= \([0-9.]*\).*/\1/')
            w_th=$(echo "$output" | grep "Temps moyen de sejour" | head -n1 | sed 's/.*= \([0-9.]*\).*/\1/')
            l_th=$(echo "$output" | grep "Esp nb clients" | sed 's/.*= \([0-9.]*\).*/\1/')
            thr_th=$(echo "$output" | grep "Debit (lambda)" | sed 's/.*= \([0-9.]*\).*/\1/')
            
            # Afficher le temps d'exécution dans la sortie
            printf " (%.2fs)" "$exec_time"
            
            # Afficher en format CSV avec le temps d'exécution réel
            echo "n,$n,$seed,$p0_sim,$w_sim,$l_sim,$thr_sim,$exec_time,$p0_th,$w_th,$l_th,$thr_th" >> "$RAW_CSV"
        done
        echo ""
    done
done

echo ""
echo "=== Simulation terminée ==="
echo "Résultats sauvegardés dans: $RAW_CSV"
echo "Nombre total de simulations: $current_sim"