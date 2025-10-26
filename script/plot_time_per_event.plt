set terminal pngcairo enhanced font "Arial,15" size 1400,800
set output "../graphes/time_per_event.png"
set title "Efficacité du traitement d'événements (λ=5, μ=6)" font ",20"
set xlabel "T (durée de simulation)" font ",16"
set ylabel "Temps moyen par événement (μs)" font ",16"

# Échelle logarithmique sur x seulement
set logscale x 10
unset logscale y

# Grille élégante
set grid xtics ytics
set style line 12 lc rgb "#e0e0e0" lt 1 lw 1
set grid back ls 12

# Tics personnalisés
set xtics ("10³" 1000, "10⁴" 10000, "10⁵" 100000, "10⁶" 1000000, "10⁷" 10000000) font ",14"
set ytics 0.5 font ",14"
set format y "%.1f"

# Légende
set key top right font ",14" box

# Plages
set xrange [700:15000000]
set yrange [0:5]

# Échelle linéaire pour rendre les IC visibles
unset logscale y

# Style principal
set style line 1 lc rgb "#0060ad" lt 1 lw 4 pt 7 ps 2.5

# Annotations simplifiées
set label 1 "4.56 μs" at 1000,3.5 center font ",12" textcolor rgb "#0060ad"
set label 2 "0.54 μs" at 10000,0.6 center font ",12" textcolor rgb "#0060ad"
set label 3 "0.10 μs" at 100000,0.12 center font ",12" textcolor rgb "#0060ad"
set label 4 "0.05 μs" at 1000000,0.06 center font ",12" textcolor rgb "#0060ad"
set label 5 "0.04 μs" at 10000000,0.05 left font ",12" textcolor rgb "#0060ad"

# Tracer avec barres d'erreur (colonne 7 = std_dev)
plot "execution_time_vs_n.dat" using 1:($2/(11*$1)*1000000):($7/(11*$1)*1000000) with yerrorbars pt 7 ps 2.5 lw 3 lc rgb "#0060ad" title "Temps mesuré par événement (IC 95%)", \
     "" using 1:($2/(11*$1)*1000000) with lines ls 1 lw 3 notitle

