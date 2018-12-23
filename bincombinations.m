function [allsequences] = bincombinations(n)
%%n is the number of bits in the binary number
%%generates all the n digit binary numbers
allsequences=strings(1,2^n);
for i=0:2^n-1
    allsequences(i+1)=string(dec2bin(i,n));
end
end

