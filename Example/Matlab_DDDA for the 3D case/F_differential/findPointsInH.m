function [rn] = findPointsInH(rij_one,h)

n = length(rij_one);
j = 1;
for i=1:n
    
    if rij_one(i) <= h
        rn(j) = i;
        j = j+1;
    end
    
end

if  j == 1
    rn = 0;
end
