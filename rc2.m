function y=rc2(x,alp) 
for i=1:length(x)
  if x(i)==-1/(2*alp)
     y(i)=pi/4;
  elseif x(i)==1/(2*alp)
     y(i)=pi/4;
  else
     y(i)=cos(pi*alp*x(i))/(1-4*alp*alp*x(i)*x(i));
  end
end