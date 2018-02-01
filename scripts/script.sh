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

echo $(IFS=$'\n'; 
    for i in `cat spResults.csv | cut -f 2,3,4,5 -d " " | sort -u`;
    do
        echo $(echo $i; grep $(echo "$i ") spResults.csv | cut -f6 -d " "; echo ",") ; 
    done) > spResultsOrdered.csv
tr , '\n' < spResultsOrdered.csv > spResultsOrderedTranspose.csv
sed -i 's/^ *//' spResultsOrderedTranspose.csv
rm spResultsOrdered.csv

echo $(IFS=$'\n'; 
    for i in `cat tcResults.csv | cut -f 2,3,4,5 -d " " | sort -u`;
    do
        echo $(echo $i; grep $(echo "$i ") tcResults.csv | cut -f6 -d " "; echo ",") ; 
    done) > tcResultsOrdered.csv
tr , '\n' < tcResultsOrdered.csv > tcResultsOrderedTranspose.csv
sed -i 's/^ *//' tcResultsOrderedTranspose.csv
rm tcResultsOrdered.csv

echo $(IFS=$'\n'; 
    for i in `cat colResults.csv | cut -f 2,3,4,5 -d " " | sort -u`;
    do
        echo $(echo $i; grep $(echo "$i ") colResults.csv | cut -f6 -d " "; echo ",") ; 
    done) > colResultsOrdered.csv
tr , '\n' < colResultsOrdered.csv > colResultsOrderedTranspose.csv
sed -i 's/^ *//' colResultsOrderedTranspose.csv
rm colResultsOrdered.csv

