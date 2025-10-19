# Makefile pour le simulateur de file M/M/1

# Variables par défaut
LAMBDA ?= 5
MU ?= 6
DUREE ?= 1000000
DEBUG ?= 0

# Compilation de tous les fichiers Java
compile:
	javac *.java

# Exécution du simulateur avec les paramètres
run: compile
	java MM1 $(LAMBDA) $(MU) $(DUREE) $(DEBUG)

# Création d'un fichier JAR exécutable
jar: compile
	@echo "Main-Class: MM1" > manifest.txt
	jar cfm MM1.jar manifest.txt *.class
	@rm -f manifest.txt
	@echo "Fichier MM1.jar créé avec succès!"
	@echo "Utilisation: java -jar MM1.jar <lambda> <mu> <duree> <debug>"

# Nettoyage des fichiers compilés
clean:
	rm -f *.class
	rm -f MM1.jar manifest.txt

# Cibles factices
.PHONY: compile run jar clean