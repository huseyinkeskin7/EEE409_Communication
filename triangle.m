function [s] = triangle(t,T)
for i = 1 : length(t)
if  0 < t(i) && t(i)<= T
        s(i) = -t(i) + T;
    else
        s(i) = 0;
    end
end
end