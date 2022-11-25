#use "puis.ml";;
let rec puis_rap x n = 
  if n == 0 then
    1
  else
    if n mod 2 == 0 then
      let result = puis x (n/2) in 
      result * result
    else
      puis x n
;;