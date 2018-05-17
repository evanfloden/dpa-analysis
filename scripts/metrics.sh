#! /bin/sh
NAME=`echo "$1" | cut -d'.' -f1`

#echo "## GENERATION TREE\n KernelMode\tUserMode\tRSS"
/usr/bin/time -f "%S %U %M" -o $NAME.tree.txt clustalo -i $1 --guidetree-out $NAME.CLUSTALO.dnd --force >/dev/null
#cat $NAME.tree.txt

echo "\n## STD ALIGNMENT\n KernelMode\tUserMode\tRSS"
/usr/bin/time -f "%S %U %M" -o $NAME.std.txt clustalo --infile=$1 --guidetree-in=$NAME.CLUSTALO.dnd --outfmt=fa --force -o $NAME.std.CLUSTALO.with.CLUSTALO.tree.aln
cat $NAME.std.txt

#echo "\n## DFT ALIGNMEN\n KernelMode\tUserMode\tRSS"
#/usr/bin/time -f "%S %U %M" -o $NAME.dft.txt clustalo --infile=$1 --outfmt=fa --force -o $NAME.default.CLUSTALO.aln
#cat $NAME.dft.txt

echo "\n## DPA 1000\n KernelMode\tUserMode\tRSS"
/usr/bin/time -f "%S %U %M" -o $NAME.dpa1000.txt t_coffee -dpa -dpa_method clustalo_msa -seq $1 -dpa_tree$NAME.CLUSTALO.dnd -dpa_nseq 1000 -outfile $NAME.dpa_1000.CLUSTALO.with.$TREE.tree.aln -dpa_thread=1 2> /dev/null
cat $NAME.dpa1000.txt


## MAN PAGE for /usr/bin/time 
##  http://man7.org/linux/man-pages/man1/time.1.html

## %S           Total number of CPU-seconds that the process spent in kernel mode
## %U           Total number of CPU-seconds that the process spent in user mode.
## %M           Maximum resident set size of the process during its lifetime,in Kbytes.

