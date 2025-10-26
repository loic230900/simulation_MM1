set terminal pngcairo enhanced font "Arial,14" size 1400,900
set output "../graphes/execution_time_vs_n.png"
set title "Temps d'exécution pour λ=5, μ=6 (ρ=0.83)" font ",18"
set xlabel "T (durée de simulation)" font ",16"
set ylabel "Temps (secondes)" font ",16"

# Grille
set grid xtics ytics
set style line 12 lc rgb "#d0d0d0" lt 1 lw 1
set grid back ls 12

# Échelle logarithmique uniquement sur x (pas ×10)
set logscale x 10
unset logscale y

# Valeurs x avec labels clairs
set xtics ("10^{3}" 1000, "10^{4}" 10000, "10^{5}" 100000, "10^{6}" 1000000, "10^{7}" 10000000) font ",14"

# Format y simple
set format y "%.1f"
set ytics font ",14"

# Légende
set key top left font ",14"

# Plages
set xrange [500:20000000]
set yrange [0:5.5]

# Style des points et lignes
set style line 1 lc rgb "#0060ad" lt 1 lw 3 pt 7 ps 2.5

# Annotations avec valeurs
set label 1 "0.050 s" at 1000,0.30 center font ",13" textcolor rgb "#0060ad"
set label 2 "0.060 s" at 10000,0.32 center font ",13" textcolor rgb "#0060ad"
set label 3 "0.109 s" at 100000,0.38 center font ",13" textcolor rgb "#0060ad"
set label 4 "0.505 s" at 1000000,0.78 center font ",13" textcolor rgb "#0060ad"
set label 5 "4.61 s" at 10000000,4.90 center font ",13" textcolor rgb "#0060ad"

# Tracer avec barres d'erreur épaisses pour visibilité
plot "execution_time_vs_n.dat" using 1:2:($2-$3):($4-$2) with yerrorbars pt 7 ps 3 lw 5 lc rgb "#0060ad" title "Temps mesuré (IC 95%)", \
     "" using 1:2 with lines ls 1 lw 3 notitle