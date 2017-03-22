def fac(n)
  n == 1 ? 1 : n * fac(n-1)
end

t1 = Thread.new do 
  0.upto(50) do 
    fac(50)
    print("t1 \n")
  end
end

t2 = Thread.new do 
  0.upto(50) do 
    fac(50)
    print("t2 \n")
  end
end

t3 = Thread.new do 
  0.upto(50) do 
    fac(50)
    print("t3 \n")
  end
end

sleep 5