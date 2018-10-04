cat trace.txt | grep "regressive_alignment" | grep "COMPLETED\|CACHED" | cut -f 4,7 |sed 's/[()]//g' |awk -F " " '{print $1"--"$2"--"$3}'| awk -F "." '{print $1"--"$2"--"$3"--"$4"--"$5}'|\
awk -F "--" '{print $7 > $2".dpa_align."$5"."$3"."$6".cpu"}'

cat trace.txt | grep "standard_alignment" | grep "COMPLETED\|CACHED" | cut -f 4,7 |sed 's/[()]//g' |awk -F " " '{print $1"--"$2"--"$3}'| awk -F "." '{print $1"--"$2"--"$3"--"$4"--"$5}'|\
awk -F "--" '{print $7 > $2".std_align."$5"."$3"."$6".cpu"}'

cat trace.txt | grep "default_alignment" | grep "COMPLETED\|CACHED" | cut -f 4,7 |sed 's/[()]//g' |awk -F " " '{print $1"--"$2"--"$3}'| awk -F "." '{print $1"--"$2"--"$3"--"$4"--"$5}'|\
awk -F "--" '{print $7 > $2".default_align."$5"."$3"."$6".cpu"}'
