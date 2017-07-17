NR == FNR {
  rep[$1] = $2
  next
} 

{
  for (key in rep)
    gsub(key, rep[key])
  print
}
