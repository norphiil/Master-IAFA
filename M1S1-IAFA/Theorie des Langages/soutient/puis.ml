let rec puis x n = 
  if n == 0 then
    1
  else
    if n > 1 then
      x * puis x (n-1)
    else
      x
;;