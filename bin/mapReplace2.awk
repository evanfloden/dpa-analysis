NR == FNR {
  rep[$2] = $1
  next
} 

{
  for (key in rep)
    gsub(key, rep[key])
  print
}
