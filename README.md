# Simulation Discrète d'une File M/M/1

TP - Master 1 SIRIS - Évaluation de Performances

## Structure du projet

```
├── *.java                 # Sources Java (MM1, Evt, Ech, Stats, Utile)
├── Makefile               # Compilation et exécution
├── README.md              # Ce fichier
├── rapport/               # Rapport LaTeX
│   ├── rapport.tex        # Source du rapport
│   ├── rapport.pdf        # Rapport compilé
│   └── ressources/        # Images
├── script/                # Scripts de simulation
│   ├── run_simulations.sh
│   ├── aggregate_results.py
│   ├── parse_results.awk
│   ├── generate_graphs.sh
│   ├── sim_results.csv    # Données brutes (régénérables)
│   ├── run_all.sh         # Lancement du pipeline complet
│   └── *.plt             # Scripts Gnuplot
└── graphes/              # Graphiques générés
```

## Installation des prérequis

```bash
# Ubuntu/Debian
sudo apt-get install python3 gnuplot make

# Vérification
which java python3 gnuplot make
```

## Utilisation

### Compilation

```bash
make compile
```

### Exécution d'une simulation simple

```bash
# Paramètres par défaut (λ=5, μ=6, T=10⁷)
make run

# Paramètres personnalisés
make run LAMBDA=3 MU=5 DUREE=1000000
```

### Pipeline complet (3100 simulations)

```bash
# Tout générer (plusieurs heures)
make run_all

# Ou étape par étape
make run_sim    # Simulations
make aggregate  # Agrégation
make graphs     # Graphiques
```

### Nettoyage

```bash
make clean      # Fichiers compilés et générés
make clean_all  # Tout (incluant CSV)
```

## Paramètres de simulation

**Balayage en λ** (μ=6 fixe, T=10⁷) :
- Faible charge : λ ∈ {0.06, 0.5, 1.0, 2.0}
- Charge moyenne : λ ∈ {3.0, 4.0, 4.5}
- Forte charge : λ ∈ {5.0, 5.5}
- Charge critique : λ ∈ {5.7, 5.9}

**Balayage en T** (λ ∈ {1, 3, 5, 5.9}) :
- T ∈ {1 000, 10 000, 100 000, 1 000 000, 10 000 000}

**Réplications** : 100 par configuration  
**Total** : 3100 simulations

## Graphiques générés

12 graphiques dans `graphes/` :

**Validation** : l_vs_rho, w_vs_rho, p0_vs_rho, synthesis  
**Erreurs** : error_analysis, precision_analysis  
**Statistique** : confidence_intervals, normality_tests, sensitivity_analysis  
**Performance** : execution_time_vs_n, time_per_event, execution_time_lambda_comparison

## Compilation du rapport

```bash
cd rapport
pdflatex rapport.tex
pdflatex rapport.tex  # 2 fois pour les références
```

## Métriques calculées

**Théoriques** : P₀ = 1-ρ, L = ρ/(1-ρ), W = 1/(μ(1-ρ))  
**Statistiques** : Moyennes, IC 95%, erreurs relatives, écarts-types

---

**Auteur** : Loïc WALTZING - **Année** : 2025-2026
