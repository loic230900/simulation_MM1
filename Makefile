# Makefile pour le simulateur de file M/M/1

# Variables par défaut pour les simulations
LAMBDA ?= 5
MU ?= 6
DUREE ?= 10000000
DEBUG ?= 0

# Compilation des fichiers Java
compile:
	@echo "Compilation des fichiers Java..."
	javac *.java
	@echo "Compilation terminée"

# Exécution simple du simulateur (cas test rapide)
run: compile
	@echo "Exécution du simulateur (λ=$(LAMBDA), μ=$(MU), T=$(DUREE))..."
	time java MM1 $(LAMBDA) $(MU) $(DUREE) $(DEBUG)

# Lancement des simulations complètes (run_simulations.sh)
run_sim: compile
	@echo "Lancement des simulations complètes..."
	@echo "Attention: Ceci peut prendre plusieurs heures..."
	(cd script && bash run_simulations.sh)

# Lancement de l'agrégation des résultats
aggregate:
	@echo "Agrégation des résultats..."
	python3 script/aggregate_results.py
	@echo "Agrégation terminée"

# Génération des graphiques
graphs:
	@echo "Génération des graphiques..."
	(cd script && bash generate_graphs.sh)
	@echo "Graphiques générés dans graphes/"

# Lancement du pipeline complet (simulations + agrégation + graphiques)
run_all: compile
	@echo "Lancement du pipeline complet M/M/1..."
	@echo "Attention: Ceci peut prendre plusieurs heures..."
	(cd script && bash run_all.sh)

# Nettoyage des fichiers générés
clean:
	@echo "Nettoyage des fichiers compilés et générés..."
	rm -f *.class
	rm -f MM1.jar manifest.txt
	rm -f script/*.dat
	rm -f graphes/*.png
	@echo "Nettoyage terminé"

# Nettoyage complet (incluant les résultats CSV)
clean_all: clean
	@echo "Nettoyage complet..."
	rm -f script/sim_results.csv
	@echo "Nettoyage complet terminé"

# Afficher l'aide
help:
	@echo "Makefile pour le simulateur M/M/1"
	@echo ""
	@echo "Cibles disponibles:"
	@echo "  make compile        - Compile les fichiers Java"
	@echo "  make run            - Lance une simulation simple (default: λ=5, μ=6, T=10⁷)"
	@echo "  make run_sim        - Lance toutes les simulations (3100 simulations)"
	@echo "  make aggregate      - Agrège les résultats CSV"
	@echo "  make graphs         - Génère tous les graphiques"
	@echo "  make run_all        - Pipeline complet (simulations + agrégation + graphiques)"
	@echo "  make clean          - Nettoie les fichiers compilés et générés"
	@echo "  make clean_all      - Nettoyage complet (incluant sim_results.csv)"
	@echo ""
	@echo "Variables optionnelles:"
	@echo "  make run LAMBDA=10 MU=12 DUREE=5000000  - Simulation avec paramètres personnalisés"
	@echo ""

# Cibles factices
.PHONY: compile run run_sim aggregate graphs run_all clean clean_all help
