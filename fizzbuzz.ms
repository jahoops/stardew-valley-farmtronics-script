
for i in range(1, 100)
    print [i,"","","Fizz","","Buzz","","","FizzBuzz"][(i%3==0)*3 + (i%5==0)*5]
end for
