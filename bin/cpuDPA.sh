mkdir -p $2;
echo ' ### CPU ###';
echo '----- DPA -----';
grep 'dpa_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,12 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > dpa_cpu_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > dpa_seqs_sorted.csv
join dpa_cpu_sorted.csv dpa_seqs_sorted.csv > dpa_cpu_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n dpa_cpu_and_numseqs.csv > dpa_cpu_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat dpa_cpu_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") dpa_cpu_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > dpa_cpu_to_transpose.csv
tr , '\n' < dpa_cpu_to_transpose.csv > $2/dpaCpu.$1.csv
sed 's/^ *//' $2/dpaCpu.$1.csv

echo '----- STD -----';
grep 'std_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,12 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > std_cpu_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > std_seqs_sorted.csv
join std_cpu_sorted.csv std_seqs_sorted.csv > std_cpu_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n std_cpu_and_numseqs.csv > std_cpu_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat std_cpu_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") std_cpu_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > std_cpu_to_transpose.csv
tr , '\n' < std_cpu_to_transpose.csv > $2/stdCpu.$1.csv
sed 's/^ *//' $2/stdCpu.$1.csv

echo '----- DEFAULT -----';
grep 'default_alignment' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,12 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > dft_cpu_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > dft_seqs_sorted.csv
join dft_cpu_sorted.csv dft_seqs_sorted.csv > dft_cpu_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n dft_cpu_and_numseqs.csv > dft_cpu_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat dft_cpu_sorted.csv | cut -f 2,3,4,5 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") dft_cpu_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > dft_cpu_to_transpose.csv
tr , '\n' < dft_cpu_to_transpose.csv > $2/dftCpu.$1.csv
sed 's/^ *//' $2/dftCpu.$1.csv

echo '----- GUIDE TREE -----';
grep 'guide_trees' trace.txt | \
grep 'COMPLETED\|CACHED' | cut -f 4,5,12 | awk -F "." '{print $1,$2,$3,$4,$5,$6}' | \
sed s/\(//g | sed s/\)//g | awk -F " " '{print $2,$3,$4,$5,$6,$8}' | \
sort -k1,1 > tree_cpu_sorted.csv

sort -k1,1 ./bin/num_seqs.csv > tree_seqs_sorted.csv
join tree_cpu_sorted.csv tree_seqs_sorted.csv > tree_cpu_and_numseqs.csv
sort -k7,7n -k2,2 -k3,3 -k4,4 -k5,5n -k7,7n tree_cpu_and_numseqs.csv > tree_cpu_sorted.csv

echo $(IFS=$'\n'; 
    for i in `cat tree_cpu_sorted.csv | cut -f 2,4 -d " " | sort -u | sort -k3,3n`;
    do
        echo $(echo $i; grep $(echo "$i ") tree_cpu_sorted.csv | cut -f6 -d " "; echo ",") ; 
    done) > tree_cpu_to_transpose.csv
tr , '\n' < tree_cpu_to_transpose.csv > $2/treeCpu.$1.csv
sed 's/^ *//' $2/treeCpu.$1.csv

rm dpa_seqs_sorted.csv dpa_cpu_and_numseqs.csv dpa_cpu_sorted.csv dpa_cpu_to_transpose.csv

rm std_seqs_sorted.csv std_cpu_and_numseqs.csv std_cpu_sorted.csv std_cpu_to_transpose.csv

rm dft_seqs_sorted.csv dft_cpu_and_numseqs.csv dft_cpu_sorted.csv dft_cpu_to_transpose.csv

rm tree_seqs_sorted.csv tree_cpu_and_numseqs.csv tree_cpu_sorted.csv tree_cpu_to_transpose.csv

