set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/w_vs_rho.png"
set title "W - Temps moyen de séjour" font ",14"
set xlabel "Facteur d'utilisation ρ = λ/μ" font ",12"
set x2label "Taux d'arrivées λ" font ",12"
set ylabel "Temps moyen de séjour (unités de temps)" font ",12"
set grid ytics
set key top left
set xrange [0:1]
set x2range [0:6]
set x2tics 1
set xtics 0.1

plot "rho_vs_w.dat" using 1:2:3:4 with yerrorbars pt 7 ps 1 lc rgb "blue" title "Simulation (IC 95%)", \
     "" using 1:5 with lines lw 2 lc rgb "red" title "Théorique"
