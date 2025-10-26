#!/usr/bin/gnuplot

# Graphique d'analyse de précision des estimateurs
set terminal png size 1200, 800
set output "../graphes/precision_analysis.png"

set title "Précision des estimateurs en fonction du facteur d'utilisation ρ" font ",14"
set xlabel "Facteur d'utilisation ρ" font ",12"
set ylabel "Erreur standard (σ/√n)" font ",12"

# Configuration des couleurs
set style line 1 lc rgb "red" lw 2 pt 7
set style line 2 lc rgb "blue" lw 2 pt 7
set style line 3 lc rgb "green" lw 2 pt 7

# Échelle adaptative avec limites fixes
set xrange [0:1]
set yrange [0:0.1]
set xtics 0.2
set ytics 0.01
set format y "%.3f"

# Légende
set key top right

# Grille
set grid

# Plot des erreurs standard
plot "precision_analysis.dat" using 1:2 with linespoints ls 1 title "P₀ Erreur standard", \
     "precision_analysis.dat" using 1:3 with linespoints ls 2 title "W Erreur standard", \
     "precision_analysis.dat" using 1:4 with linespoints ls 3 title "L Erreur standard"

# Note explicative
set label "Précision des estimateurs: σ/√n\nPlus la valeur est faible, plus l'estimateur est précis" at screen 0.1, 0.05
