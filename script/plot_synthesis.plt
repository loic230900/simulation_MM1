set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/synthesis_multi_panel.png"

# Configuration multi-panneaux avec espacement amélioré
set multiplot layout 1,3 margins 0.1,0.95,0.15,0.85 spacing 0.08

# Panneau 1: L vs ρ
set title "L" font ",14"
set xlabel "Facteur d'utilisation ρ" font ",10"
set ylabel "Nombre de clients" font ",10"
set yrange [0:65]
set xrange [0:1]
set grid ytics
set key off
set xtics 0.2
set ytics 10

plot "rho_vs_lambda.dat" using 1:2 with points pt 7 ps 1.0 lc rgb "blue" title "Simulation", \
     "" using 1:5 with lines lw 2 lc rgb "red" title "Théorique"

# Panneau 2: W vs ρ
set title "W" font ",14"
set xlabel "Facteur d'utilisation ρ" font ",10"
set ylabel "Temps de séjour" font ",10"
set yrange [0:12]
set xrange [0:1]
set grid ytics
set key off
set xtics 0.2
set ytics 2

plot "rho_vs_w.dat" using 1:2 with points pt 7 ps 1.0 lc rgb "blue" title "Simulation", \
     "" using 1:5 with lines lw 2 lc rgb "red" title "Théorique"

# Panneau 3: P₀ vs ρ
set title "P₀" font ",14"
set xlabel "Facteur d'utilisation ρ" font ",10"
set ylabel "Probabilité" font ",10"
set yrange [0:1]
set xrange [0:1]
set grid ytics
set key off
set xtics 0.2
set ytics 0.2

plot "rho_vs_p0.dat" using 1:2 with points pt 7 ps 1.0 lc rgb "blue" title "Simulation", \
     "" using 1:5 with lines lw 2 lc rgb "red" title "Théorique"

unset multiplot