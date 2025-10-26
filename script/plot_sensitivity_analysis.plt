#!/usr/bin/gnuplot

# Graphique d'analyse de sensibilité amélioré
set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/sensitivity_analysis.png"

set title "Sensibilité des métriques aux variations de ρ" font ",14"
set xlabel "Facteur d'utilisation ρ" font ",12"
set ylabel "Taux de variation (dérivée)" font ",12"

# Configuration des couleurs
set style line 1 lc rgb "red" lw 3 pt 7
set style line 2 lc rgb "green" lw 3 pt 7

# Échelle logarithmique pour mieux voir les variations
set logscale y
set yrange [0.1:10000]

# Grille et légende
set grid ytics
set key top left

# Focus sur W et L seulement (P₀ constant n'est pas informatif)
plot "sensitivity_analysis.dat" using 1:3 with lines ls 1 title "∂W/∂ρ (temps de séjour)", \
     "" using 1:4 with lines ls 2 title "∂L/∂ρ (nombre de clients)"

# Note explicative
set label "Cette figure explique pourquoi W et L 'explosent' près de ρ=1\nPlus la dérivée est élevée, plus la métrique est sensible aux variations de ρ" at screen 0.1, 0.05
