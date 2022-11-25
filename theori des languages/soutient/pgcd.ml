let rec pgcd a b = 
  if a == 0 then b
  else
    if b == 0 then a
    else
      if a == b then a
      else
        if a > b then
          pgcd (a-b) b
        else
          pgcd a (b-a)
;;