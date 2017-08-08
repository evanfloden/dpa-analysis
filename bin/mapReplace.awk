NR==FNR { 
  a[$1]=$2; 
  next 
}

{
  for(i in a) { 
      for(x=1;x<=NF;x++) {
          $x=(i==$x)?a[i]:$x
          }
      }
}1


