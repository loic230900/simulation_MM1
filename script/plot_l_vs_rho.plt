set terminal pngcairo enhanced font "Arial,12"
set output "../graphes/l_vs_rho.png"
set title "L - Nombre moyen de clients (T=10M, μ=6)" font ",16"
set xlabel "Facteur d'utilisation ρ = λ/μ" font ",14"
set x2label "Taux d'arrivées λ" font ",14"
set ylabel "Nombre moyen de clients dans le système" font ",14"
set grid ytics
set key top left

# Échelle linéaire avec valeurs non-overlap
set yrange [0:65]
set ytics (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65)

set xrange [0:1]
set x2range [0:6]
set x2tics 1
set xtics 0.1

plot "rho_vs_lambda.dat" using 1:2:3:4 with yerrorbars pt 7 ps 1.5 lw 2 lc rgb "blue" title "Simulation (IC 95%)", \
     "" using 1:5 with lines lw 3 lc rgb "red" title "Théorique L = ρ/(1-ρ)"
