# Makefile pour le simulateur de file M/M/1

# Variables par défaut
LAMBDA ?= 5
MU ?= 6
DUREE ?= 1000
DEBUG ?= 1

# Compilation de tous les fichiers Java
compile:
	javac *.java

# Exécution du simulateur avec les paramètres
run: compile
	java MM1 $(LAMBDA) $(MU) $(DUREE) $(DEBUG)

# Nettoyage des fichiers compilés
clean:
	rm -f *.class

# Cibles factices
.PHONY: compile run clean