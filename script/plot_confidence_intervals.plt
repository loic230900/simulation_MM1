set terminal pngcairo enhanced font "Arial,10"
set output "../graphes/confidence_intervals.png"
set title "Largeur des intervalles de confiance 95%" font ",14"
set xlabel "Facteur d'utilisation ρ = λ/μ" font ",12"
set ylabel "Largeur IC 95%" font ",12"
set grid ytics
set key top left
set xrange [0:1]
set xtics 0.1
set logscale y

plot "confidence_width.dat" using 1:2 with linespoints pt 7 ps 1 lc rgb "blue" title "P₀", \
     "" using 1:3 with linespoints pt 7 ps 1 lc rgb "red" title "W", \
     "" using 1:4 with linespoints pt 7 ps 1 lc rgb "green" title "L"
