#!/usr/bin/gnuplot

# Graphique de tests de normalité
set terminal png size 1200, 800
set output "../graphes/normality_tests.png"

set title "Tests de normalité - Coefficient d'asymétrie"
set xlabel "Facteur d'utilisation ρ"
set ylabel "|Skewness|"

# Configuration des couleurs
set style line 1 lc rgb "red" lw 2 pt 7
set style line 2 lc rgb "blue" lw 2 pt 7
set style line 3 lc rgb "green" lw 2 pt 7
set style line 4 lc rgb "black" lw 1 dt 2

# Ligne de référence pour la normalité (skewness = 0)
set arrow from graph 0,0 to graph 1,0 nohead ls 4

# Échelle adaptative
set yrange [*:*]
set ytics auto

# Légende
set key top right

# Grille
set grid

# Plot des coefficients d'asymétrie
plot "normality_tests.dat" using 1:2 with linespoints ls 1 title "P0 Skewness", \
     "normality_tests.dat" using 1:3 with linespoints ls 2 title "W Skewness", \
     "normality_tests.dat" using 1:4 with linespoints ls 3 title "L Skewness"

# Note explicative
set label "Test de normalité par coefficient d'asymétrie\nSkewness = 0: distribution symétrique (normale)\nSkewness > 0: distribution étalée vers la droite\nSkewness < 0: distribution étalée vers la gauche" at screen 0.1, 0.05
