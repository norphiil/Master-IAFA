let rec fib n = 
  if n == 0 then n
  else
    if n == 1 then n
    else
      fib (n-1) + fib (n-2)
;;