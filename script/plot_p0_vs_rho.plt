set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/p0_vs_rho.png"
set title "P₀ - Proportion sans attente" font ",14"
set xlabel "Facteur d'utilisation ρ = λ/μ" font ",12"
set x2label "Taux d'arrivées λ" font ",12"
set ylabel "Proportion de clients sans attente" font ",12"
set grid ytics
set key top right
set xrange [0:1]
set x2range [0:6]
set x2tics 1
set xtics 0.1

plot "rho_vs_p0.dat" using 1:2:3:4 with yerrorbars pt 7 ps 1 lc rgb "blue" title "Simulation (IC 95%)", \
     "" using 1:5 with lines lw 2 lc rgb "red" title "Théorique"
