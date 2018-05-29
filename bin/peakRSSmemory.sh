mkdir -p $2;

echo ' ### RSS MEMORY ###';
echo '----- DPA -----';
grep 'dpa_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,11 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > dpa_mem_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > dpa_seqs_sorted.csv
join dpa_mem_sorted.csv dpa_seqs_sorted.csv > dpa_mem_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n dpa_mem_and_numseqs.csv > dpa_mem_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat dpa_mem_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") dpa_mem_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > dpa_mem_to_transpose.csv
tr , '\n' < dpa_mem_to_transpose.csv > $2/dpaMemory.$1.csv
sed 's/^ *//' $2/dpaMemory.$1.csv

echo '----- STD -----';
grep 'std_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,11 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > std_mem_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > std_seqs_sorted.csv
join std_mem_sorted.csv std_seqs_sorted.csv > std_mem_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n std_mem_and_numseqs.csv > std_mem_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat std_mem_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") std_mem_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > std_mem_to_transpose.csv
tr , '\n' < std_mem_to_transpose.csv > $2/stdMemory.$1.csv
sed 's/^ *//' $2/stdMemory.$1.csv

echo '----- DEFAULT -----';
grep 'default_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,11 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > dft_mem_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > dft_seqs_sorted.csv
join dft_mem_sorted.csv dft_seqs_sorted.csv > dft_mem_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n dft_mem_and_numseqs.csv > dft_mem_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat dft_mem_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") dft_mem_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > dft_mem_to_transpose.csv
tr , '\n' < dft_mem_to_transpose.csv > $2/dftMemory.$1.csv
sed 's/^ *//' $2/dftMemory.$1.csv

echo '----- GUIDE TREE -----';
grep 'guide_trees' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,11 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > tree_mem_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > tree_seqs_sorted.csv
join tree_mem_sorted.csv tree_seqs_sorted.csv > tree_mem_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n tree_mem_and_numseqs.csv > tree_mem_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat tree_mem_sorted.csv | cut -f 1,2,4,6 -d " " | sort -u | sort -k4,4n`;
    do
        echo $(echo $i; grep $(echo "$i ") tree_mem_sorted.csv | cut -f1 -d " "; echo ",") ; 
    done) > tree_mem_to_transpose.csv
tr , '\n' < tree_mem_to_transpose.csv > $2/treeMemory.$1.csv
sed 's/^ *//' $2/treeMemory.$1.csv


rm dpa_seqs_sorted.csv dpa_mem_and_numseqs.csv dpa_mem_sorted.csv dpa_mem_to_transpose.csv

rm std_seqs_sorted.csv std_mem_and_numseqs.csv std_mem_sorted.csv std_mem_to_transpose.csv

rm dft_seqs_sorted.csv dft_mem_and_numseqs.csv dft_mem_sorted.csv dft_mem_to_transpose.csv

rm tree_seqs_sorted.csv tree_mem_and_numseqs.csv tree_mem_sorted.csv tree_mem_to_transpose.csv

