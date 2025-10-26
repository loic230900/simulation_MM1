set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/error_analysis.png"
set title "Analyse d'erreur - Simulation vs Théorie" font ",14"
set xlabel "Facteur d'utilisation ρ = λ/μ" font ",12"
set ylabel "Erreur relative (%)" font ",12"
set grid ytics
set key top left
set xrange [0:1]
set xtics 0.1
set yrange [0:0.1]
set ytics 0.01
set format y "%.2f"

plot "error_analysis.dat" using 1:($2*100) with linespoints pt 7 ps 1 lc rgb "blue" title "P₀", \
     "" using 1:($3*100) with linespoints pt 7 ps 1 lc rgb "red" title "W", \
     "" using 1:($4*100) with linespoints pt 7 ps 1 lc rgb "green" title "L"
