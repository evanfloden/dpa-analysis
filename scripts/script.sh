sort -k1,1 spScores.*.csv > sp_sorted.csv
sort -k1,1 num_seqs.csv > seqs_sorted.csv
join sp_sorted.csv seqs_sorted.csv > sp_and_numseqs.csv
sort -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n sp_and_numseqs.csv > spResults.csv

sort -k1,1 tcScores.*.csv > tc_sorted.csv
sort -k1,1 num_seqs.csv > seqs_sorted.csv
join tc_sorted.csv seqs_sorted.csv > tc_and_numseqs.csv
sort -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n tc_and_numseqs.csv > tcResults.csv

sort -k1,1 colScores.*.csv > col_sorted.csv
sort -k1,1 num_seqs.csv > seqs_sorted.csv
join col_sorted.csv seqs_sorted.csv > col_and_numseqs.csv
sort -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n col_and_numseqs.csv > colResults.csv

rm *_sorted.csv *_and_numseqs.csv
