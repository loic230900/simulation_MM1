set terminal pngcairo enhanced font "Arial,14" size 1400,1400
set output "../graphes/execution_time_lambda_comparison.png"

# Multi-panel: 2 graphiques empilés
set multiplot layout 2,1 spacing 0.15

# Styles pour chaque lambda
set style line 1 lc rgb "#0060ad" lt 1 lw 4 pt 7 ps 3    # lambda=1.0 (bleu)
set style line 2 lc rgb "#00aa00" lt 1 lw 4 pt 9 ps 3    # lambda=3.0 (vert)
set style line 3 lc rgb "#dd8800" lt 1 lw 4 pt 5 ps 3    # lambda=5.0 (orange)
set style line 4 lc rgb "#dd181f" lt 1 lw 4 pt 11 ps 3   # lambda=5.9 (rouge)

# Grille
set grid xtics ytics
set style line 12 lc rgb "#d0d0d0" lt 1 lw 1
set grid back ls 12

# === Panel 1 (haut): Graphe initial complet avec échelle logarithmique ===
set title "Temps d'exécution pour différentes valeurs de λ (μ=6)" font ",18"
set xlabel "" font ",16"  # Pas de label X pour le panel du haut
set ylabel "Temps d'exécution (secondes)" font ",16"

# Échelle logarithmique sur x seulement
set logscale x 10
unset logscale y

# Tics
set xtics ("10³" 1000, "10⁴" 10000, "10⁵" 100000, "10⁶" 1000000, "10⁷" 10000000) font ",14"
set ytics font ",14"
set format y "%.2f"

set key top left font ",14" spacing 1.5
set xrange [500:20000000]
set yrange [0:6.5]

# Tracer toutes les valeurs avec IC (symboles minimaux pour visibilité des whiskers)
plot "lambda_full_data.dat" using 1:2:($3*1.96) with yerrorbars pt 7 ps 1 lw 2 lc rgb "#0060ad" notitle, \
     "" using 1:2 with linespoints ls 1 title "λ=1.0 (ρ=0.17)", \
     "" using 1:4:($5*1.96) with yerrorbars pt 9 ps 1 lw 2 lc rgb "#00aa00" notitle, \
     "" using 1:4 with linespoints ls 2 title "λ=3.0 (ρ=0.50)", \
     "" using 1:6:($7*1.96) with yerrorbars pt 5 ps 1 lw 2 lc rgb "#dd8800" notitle, \
     "" using 1:6 with linespoints ls 3 title "λ=5.0 (ρ=0.83)", \
     "" using 1:8:($9*1.96) with yerrorbars pt 11 ps 1 lw 2 lc rgb "#dd181f" notitle, \
     "" using 1:8 with linespoints ls 4 title "λ=5.9 (ρ=0.98)"

# === Panel 2 (bas): Zoom sur grandes valeurs ===
set title "" font ",18"  # Pas de titre pour le panel du bas
set xlabel "T (durée de simulation)" font ",16"
set ylabel "Temps d'exécution (secondes)" font ",16"

# Échelle log pour X, linéaire pour Y
set logscale x 10
unset logscale y

set xtics ("10⁶" 1000000, "10⁷" 10000000) font ",14"
set format y "%.1f"
set ytics font ",14"

set key top left font ",14" spacing 1.5
set xrange [500000:25000000]
set yrange [0:6.5]

# Annoter "Zoom sur grandes simulations"
set label "Zoom sur grandes simulations" at 3000000,6.0 left font ",16" textcolor rgb "#666666"

# Tracer seulement les 2 dernières valeurs (N=1000000, 10000000) avec IC
replot

unset label
unset multiplot
