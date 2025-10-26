#!/usr/bin/env python3
import csv, math, statistics, random

# Fichiers d'entrée et sortie
input_file = "script/sim_results.csv"
# Fichiers de sortie .dat pour Gnuplot (graphiques essentiels + nouveaux)
W_lambda_file = "script/W_vs_lambda.dat"
L_lambda_file = "script/L_vs_lambda.dat"
rho_p0_file = "script/rho_vs_p0.dat"
rho_w_file = "script/rho_vs_w.dat"
rho_l_file = "script/rho_vs_lambda.dat"

# Nouveaux fichiers pour les graphiques avancés
error_analysis_file = "script/error_analysis.dat"
confidence_width_file = "script/confidence_width.dat"
waiting_proportion_file = "script/waiting_proportion.dat"
performance_overview_file = "script/performance_overview.dat"

# Nouveaux graphiques spécialisés
sensitivity_analysis_file = "script/sensitivity_analysis.dat"
performance_flow_file = "script/performance_flow.dat"
robustness_analysis_file = "script/robustness_analysis.dat"

# Nouveaux graphiques statistiques
variance_analysis_file = "script/variance_analysis.dat"
stddev_analysis_file = "script/stddev_analysis.dat"
variance_comparison_file = "script/variance_comparison.dat"

# Nouveaux graphiques avancés
distribution_analysis_file = "script/distribution_analysis.dat"
median_vs_mean_file = "script/median_vs_mean.dat"
range_analysis_file = "script/range_analysis.dat"
correlation_matrix_file = "script/correlation_matrix.dat"
precision_analysis_file = "script/precision_analysis.dat"
normality_tests_file = "script/normality_tests.dat"

#definition des constantes
mu = 6;


# Structures pour stocker les données par scénario
lambda_groups = {}  # dict: clé = valeur de λ, valeur = liste de métriques pour toutes réplications
n_groups = {}       # dict: clé = valeur de n, valeur = liste de métriques pour toutes réplications
n_groups_by_lambda = {}  # dict: clé = (n, lambda), valeur = liste de métriques

# Indices des champs dans le CSV (pour rappel):
# 0:type, 1:param, 2:seed, 3:P0_sim, 4:W_sim, 5:L_sim, 6:throughput_sim, 7:time, 8:P0_th, 9:W_th, 10:L_th, 11:thr_th
with open(input_file, newline='') as csvfile:
    reader = csv.reader(csvfile)
    header = next(reader)  # lecture de l'en-tête
    for row in reader:
        scenario = row[0]
        param_val = float(row[1])
        # Convertir les mesures simulées en float
        P0_sim = float(row[3]);  W_sim = float(row[4])
        L_sim = float(row[5]);  throughput_sim = float(row[6])
        # Valeurs théoriques correspondantes
        P0_th = float(row[8]);  W_th = float(row[9])
        L_th = float(row[10]); throughput_th = float(row[11])
        if scenario == "lambda":
            # Si nouvelle valeur de lambda, initialiser listes
            if param_val not in lambda_groups:
                lambda_groups[param_val] = {"P0":[],"W":[],"L":[],"throughput":[], "theory": {"P0":P0_th, "W":W_th, "L":L_th, "throughput": throughput_th}}
            lambda_groups[param_val]["P0"].append(P0_sim)
            lambda_groups[param_val]["W"].append(W_sim)
            lambda_groups[param_val]["L"].append(L_sim)
            lambda_groups[param_val]["throughput"].append(throughput_sim)
        elif scenario == "n":
            # Calculer lambda à partir de P0_th: rho = 1 - P0, donc lambda = rho * mu
            rho = 1 - P0_th
            lambda_val = rho * mu
            # Arrondir à 1 décimale pour grouper correctement (1.0, 3.0, 5.0, 5.9)
            lambda_val = round(lambda_val, 1)
            
            if param_val not in n_groups:
                n_groups[param_val] = {"P0":[], "time":[], "theory": {"P0": P0_th}}
            n_groups[param_val]["P0"].append(P0_sim)
            n_groups[param_val]["time"].append(float(row[7]))  # temps d'exécution
            
            # Grouper aussi par (n, lambda)
            key = (param_val, lambda_val)
            if key not in n_groups_by_lambda:
                n_groups_by_lambda[key] = {"time": [], "lambda": lambda_val}
            n_groups_by_lambda[key]["time"].append(float(row[7]))
        # (On ignore les champs 'time' ici, mais on pourrait également calculer temps moyen par scénario si désiré)

# Fonction utilitaire pour calculer l'intervalle de confiance 95% (retourne delta = marge d'erreur)
def confidence_interval(data, confidence=0.95):
    n = len(data)
    if n <= 1:
        return 0.0
    # Ecart-type échantillon
    s = statistics.pstdev(data) if n > 1 else 0.0  # ou statistics.stdev (non biaisé), différence minime sur n=100
    # Quantile 97.5% de la loi Normale approx (on utilise 1.96 pour 95%)
    z = 1.96
    margin = z * (s / math.sqrt(n))
    return margin

# Écrire les résultats agrégés pour λ
# Trier les valeurs de lambda par ordre croissant
lambda_values = sorted(lambda_groups.keys())
# Ouvrir les fichiers de base
with open(W_lambda_file, "w") as f_W, \
     open(L_lambda_file, "w") as f_L, \
     open(rho_p0_file, "w") as f_rho_p0, \
     open(rho_w_file, "w") as f_rho_w, \
     open(rho_l_file, "w") as f_rho_l, \
     open(error_analysis_file, "w") as f_error, \
     open(confidence_width_file, "w") as f_conf, \
     open(waiting_proportion_file, "w") as f_wait, \
     open(performance_overview_file, "w") as f_perf, \
     open(sensitivity_analysis_file, "w") as f_sens, \
     open(performance_flow_file, "w") as f_flow, \
     open(robustness_analysis_file, "w") as f_robust, \
     open(variance_analysis_file, "w") as f_var, \
     open(stddev_analysis_file, "w") as f_std, \
     open(variance_comparison_file, "w") as f_varcomp:
    # Écriture des données
    # En-têtes (facultatif pour .dat, souvent non utilisé donc on peut ne pas en mettre)
    # f_p0.write("# lambda P0_sim mean CI_low CI_high P0_theory\n")
    for lam in lambda_values:
        data = lambda_groups[lam]
        # Calcul des statistiques pour cette valeur de lambda
        P0_vals = data["P0"];  W_vals = data["W"]
        L_vals = data["L"];    thr_vals = data["throughput"]
        # Moyennes
        P0_mean = statistics.mean(P0_vals)
        W_mean = statistics.mean(W_vals)
        L_mean = statistics.mean(L_vals)
        thr_mean = statistics.mean(thr_vals)
        # IC 95% (demi-largeur)
        P0_margin = confidence_interval(P0_vals)
        W_margin  = confidence_interval(W_vals)
        L_margin  = confidence_interval(L_vals)
        thr_margin= confidence_interval(thr_vals)
        # Théoriques
        P0_th = data["theory"]["P0"]
        W_th  = data["theory"]["W"]
        L_th  = data["theory"]["L"]
        thr_th= data["theory"]["throughput"]
        # Écriture dans chaque fichier .dat correspondant
        f_W.write(f"{lam} {W_mean:.6f} {W_mean - W_margin:.6f} {W_mean + W_margin:.6f} {W_th:.6f}\n")
        f_L.write(f"{lam} {L_mean:.6f} {L_mean - L_margin:.6f} {L_mean + L_margin:.6f} {L_th:.6f}\n")
        rho = lam / mu;
        f_rho_p0.write(f"{rho:.6f} {P0_mean:.6f} {P0_mean - P0_margin:.6f} {P0_mean + P0_margin:.6f} {P0_th:.6f}\n")
        f_rho_w.write(f"{rho:.6f} {W_mean:.6f} {W_mean - W_margin:.6f} {W_mean + W_margin:.6f} {W_th:.6f}\n")
        f_rho_l.write(f"{rho:.6f} {L_mean:.6f} {L_mean - L_margin:.6f} {L_mean + L_margin:.6f} {L_th:.6f}\n")
        
        # Calculs pour les nouveaux graphiques
        # Erreur relative
        P0_error = abs(P0_mean - P0_th) / P0_th if P0_th != 0 else 0
        W_error = abs(W_mean - W_th) / W_th if W_th != 0 else 0
        L_error = abs(L_mean - L_th) / L_th if L_th != 0 else 0
        f_error.write(f"{rho:.6f} {P0_error:.6f} {W_error:.6f} {L_error:.6f}\n")
        
        # Largeur des intervalles de confiance
        f_conf.write(f"{rho:.6f} {2*P0_margin:.6f} {2*W_margin:.6f} {2*L_margin:.6f}\n")
        
        # Proportion de clients avec attente (P1 = 1 - P0)
        P1_mean = 1 - P0_mean
        P1_th = 1 - P0_th
        P1_margin = P0_margin  # Même marge d'erreur que P0
        f_wait.write(f"{rho:.6f} {P1_mean:.6f} {P1_mean - P1_margin:.6f} {P1_mean + P1_margin:.6f} {P1_th:.6f}\n")
        
        # Vue d'ensemble normalisée (W et L normalisés par leurs valeurs max théoriques)
        W_max_th = 1 / (mu * (1 - 0.95))  # W théorique max pour ρ=0.95
        L_max_th = 0.95 / (1 - 0.95)       # L théorique max pour ρ=0.95
        W_norm = W_mean / W_max_th
        L_norm = L_mean / L_max_th
        f_perf.write(f"{rho:.6f} {P0_mean:.6f} {W_norm:.6f} {L_norm:.6f}\n")
        
        # Analyse de sensibilité (dérivées théoriques)
        dP0_drho = -1.0  # ∂P₀/∂ρ = -1
        dW_drho = 1 / (mu * (1 - rho)**2)  # ∂W/∂ρ = 1/(μ(1-ρ)²)
        dL_drho = 1 / (1 - rho)**2  # ∂L/∂ρ = 1/(1-ρ)²
        f_sens.write(f"{rho:.6f} {dP0_drho:.6f} {dW_drho:.6f} {dL_drho:.6f}\n")
        
        # Diagramme de flux de performance
        P1_mean = 1 - P0_mean  # Probabilité système occupé
        f_flow.write(f"{rho:.6f} {lam:.6f} {mu:.6f} {P0_mean:.6f} {P1_mean:.6f} {W_mean:.6f} {L_mean:.6f}\n")
        
        # Analyse de robustesse (coefficient de variation)
        P0_cv = P0_margin / P0_mean if P0_mean != 0 else 0
        W_cv = W_margin / W_mean if W_mean != 0 else 0
        L_cv = L_margin / L_mean if L_mean != 0 else 0
        f_robust.write(f"{rho:.6f} {P0_cv:.6f} {W_cv:.6f} {L_cv:.6f}\n")
        
        # Calculs statistiques avancés
        # Variances (σ²)
        P0_var = statistics.variance(P0_vals) if len(P0_vals) > 1 else 0
        W_var = statistics.variance(W_vals) if len(W_vals) > 1 else 0
        L_var = statistics.variance(L_vals) if len(L_vals) > 1 else 0
        f_var.write(f"{rho:.6f} {P0_var:.6f} {W_var:.6f} {L_var:.6f}\n")
        
        # Écarts-types (σ)
        P0_std = math.sqrt(P0_var)
        W_std = math.sqrt(W_var)
        L_std = math.sqrt(L_var)
        f_std.write(f"{rho:.6f} {P0_std:.6f} {W_std:.6f} {L_std:.6f}\n")
        
        # Comparaison variance/écart-type
        f_varcomp.write(f"{rho:.6f} {P0_var:.6f} {P0_std:.6f} {W_var:.6f} {W_std:.6f} {L_var:.6f} {L_std:.6f}\n")
        

# Ouvrir les fichiers avancés
with open(distribution_analysis_file, "w") as f_dist, \
     open(median_vs_mean_file, "w") as f_median, \
     open(range_analysis_file, "w") as f_range, \
     open(precision_analysis_file, "w") as f_prec, \
     open(normality_tests_file, "w") as f_norm:
    
    for lam in lambda_values:
        data = lambda_groups[lam]
        rho = lam / mu
        
        P0_vals = data["P0"]
        W_vals = data["W"]
        L_vals = data["L"]
        
        # Calculs des métriques avancées
        P0_mean = statistics.mean(P0_vals)
        W_mean = statistics.mean(W_vals)
        L_mean = statistics.mean(L_vals)
        
        P0_std = statistics.stdev(P0_vals) if len(P0_vals) > 1 else 0
        W_std = statistics.stdev(W_vals) if len(W_vals) > 1 else 0
        L_std = statistics.stdev(L_vals) if len(L_vals) > 1 else 0
        
        # Médianes
        P0_median = statistics.median(P0_vals)
        W_median = statistics.median(W_vals)
        L_median = statistics.median(L_vals)
        f_median.write(f"{rho:.6f} {P0_mean:.6f} {P0_median:.6f} {W_mean:.6f} {W_median:.6f} {L_mean:.6f} {L_median:.6f}\n")
        
        # Étendue et quartiles
        P0_min, P0_max = min(P0_vals), max(P0_vals)
        W_min, W_max = min(W_vals), max(W_vals)
        L_min, L_max = min(L_vals), max(L_vals)
        
        P0_q1 = statistics.quantiles(P0_vals, n=4)[0]
        P0_q3 = statistics.quantiles(P0_vals, n=4)[2]
        W_q1 = statistics.quantiles(W_vals, n=4)[0]
        W_q3 = statistics.quantiles(W_vals, n=4)[2]
        L_q1 = statistics.quantiles(L_vals, n=4)[0]
        L_q3 = statistics.quantiles(L_vals, n=4)[2]
        
        f_range.write(f"{rho:.6f} {P0_min:.6f} {P0_max:.6f} {P0_q1:.6f} {P0_q3:.6f} {W_min:.6f} {W_max:.6f} {W_q1:.6f} {W_q3:.6f} {L_min:.6f} {L_max:.6f} {L_q1:.6f} {L_q3:.6f}\n")
        
        # Précision (erreur standard)
        n_simulations = len(P0_vals)
        P0_precision = P0_std / math.sqrt(n_simulations)
        W_precision = W_std / math.sqrt(n_simulations)
        L_precision = L_std / math.sqrt(n_simulations)
        f_prec.write(f"{rho:.6f} {P0_precision:.6f} {W_precision:.6f} {L_precision:.6f} {n_simulations}\n")
        
        # Distribution analysis - échantillonnage pour histogrammes
        if len(W_vals) >= 10:  # Seulement si assez de données
            sample_size = min(100, len(W_vals))
            W_sample = random.sample(W_vals, sample_size)
            for w_val in W_sample:
                f_dist.write(f"{rho:.6f} {w_val:.6f}\n")
        
        # Tests de normalité (approximation)
        if len(P0_vals) > 3:
            P0_skew = statistics.mean([(x - P0_mean)**3 for x in P0_vals]) / (P0_std**3) if P0_std > 0 else 0
            W_skew = statistics.mean([(x - W_mean)**3 for x in W_vals]) / (W_std**3) if W_std > 0 else 0
            L_skew = statistics.mean([(x - L_mean)**3 for x in L_vals]) / (L_std**3) if L_std > 0 else 0
            
            f_norm.write(f"{rho:.6f} {P0_skew:.6f} {W_skew:.6f} {L_skew:.6f} {P0_mean:.6f} {W_mean:.6f} {L_mean:.6f}\n")

# Générer fichier temps d'exécution vs n (graphique essentiel conservé)
# Filtrer uniquement pour lambda=5 (charge élevée représentative)
exec_time_file = "script/execution_time_vs_n.dat"
target_lambda = 5.0

# Filtrer pour lambda=5.0
n_lambda_pairs = [(n, lam) for (n, lam) in n_groups_by_lambda.keys() if abs(lam - target_lambda) < 0.1]

with open(exec_time_file, "w") as f_time:
    for (n, lam) in sorted(n_lambda_pairs):
        key = (n, lam)
        if key in n_groups_by_lambda:
            time_data = n_groups_by_lambda[key]["time"]
            time_mean = statistics.mean(time_data)
            time_margin = confidence_interval(time_data)
            time_min = min(time_data)
            time_max = max(time_data)
            time_std = statistics.stdev(time_data) if len(time_data) > 1 else 0.0
            f_time.write(f"{int(n)} {time_mean:.6f} {time_mean - time_margin:.6f} {time_mean + time_margin:.6f} {time_min:.6f} {time_max:.6f} {time_std:.6f}\n")

# Générer matrice de corrélation
print("Génération de la matrice de corrélation...")
all_rho_values = []
all_p0_values = []
all_w_values = []
all_l_values = []

for lam in lambda_values:
    data = lambda_groups[lam]
    rho = lam / mu
    
    P0_vals = data["P0"]
    W_vals = data["W"]
    L_vals = data["L"]
    
    # Prendre la moyenne pour chaque rho
    all_rho_values.append(rho)
    all_p0_values.append(statistics.mean(P0_vals))
    all_w_values.append(statistics.mean(W_vals))
    all_l_values.append(statistics.mean(L_vals))

# Calculer les corrélations
def correlation(x, y):
    n = len(x)
    if n < 2:
        return 0
    mean_x = statistics.mean(x)
    mean_y = statistics.mean(y)
    
    numerator = sum((x[i] - mean_x) * (y[i] - mean_y) for i in range(n))
    denominator = math.sqrt(sum((x[i] - mean_x)**2 for i in range(n)) * sum((y[i] - mean_y)**2 for i in range(n)))
    
    return numerator / denominator if denominator != 0 else 0

# Corrélations entre métriques
corr_p0_w = correlation(all_p0_values, all_w_values)
corr_p0_l = correlation(all_p0_values, all_l_values)
corr_w_l = correlation(all_w_values, all_l_values)
corr_rho_p0 = correlation(all_rho_values, all_p0_values)
corr_rho_w = correlation(all_rho_values, all_w_values)
corr_rho_l = correlation(all_rho_values, all_l_values)

# Écrire la matrice de corrélation
with open(correlation_matrix_file, "w") as f_corr:
    f_corr.write("# Matrice de corrélation entre métriques\n")
    f_corr.write("# Format: métrique1 métrique2 corrélation\n")
    f_corr.write(f"P0 W {corr_p0_w:.6f}\n")
    f_corr.write(f"P0 L {corr_p0_l:.6f}\n")
    f_corr.write(f"W L {corr_w_l:.6f}\n")
    f_corr.write(f"rho P0 {corr_rho_p0:.6f}\n")
    f_corr.write(f"rho W {corr_rho_w:.6f}\n")
    f_corr.write(f"rho L {corr_rho_l:.6f}\n")

print("Aggregation completed. .dat files generated for Gnuplot.")
