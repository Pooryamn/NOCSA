function O=chaos(index,max_iter,Value)

O=zeros(1,max_iter);
x(1)=0.7;
a=0;
b=0;
switch index
%Chebyshev map
    case 1
for i=1:max_iter
    x(i+1)=cos(i*acos(x(i)));
    G(i)=((x(i)+1)*Value)/2;
end
    case 2
%Circle map
a=0.5;
b=0.2;
for i=1:max_iter
    x(i+1)=mod(x(i)+b-(a/(2*pi))*sin(2*pi*x(i)),1);
    G(i)=x(i)*Value;
end
    case 3
%Gauss/mouse map
for i=1:max_iter
    if x(i)==0
        x(i+1)=0;
    else
        x(i+1)=mod(1/x(i),1);
    end
    G(i)=x(i)*Value;
end

    case 4
%Iterative map
a=0.7;
for i=1:max_iter
    x(i+1)=sin((a*pi)/x(i));
    G(i)=((x(i)+1)*Value)/2;
end

    case 5
%Logistic map
a=4;
for i=1:max_iter
    x(i+1)=a*x(i)*(1-x(i));
    G(i)=x(i)*Value;
end
    case 6
%Piecewise map
P=0.4;
for i=1:max_iter
    if x(i)>=0 && x(i)<P
        x(i+1)=x(i)/P;
    end
    if x(i)>=P && x(i)<0.5
        x(i+1)=(x(i)-P)/(0.5-P);
    end
    if x(i)>=0.5 && x(i)<1-P
        x(i+1)=(1-P-x(i))/(0.5-P);
    end
    if x(i)>=1-P && x(i)<1
        x(i+1)=(1-x(i))/P;
    end    
    G(i)=x(i)*Value;
end

    case 7
%Sine map
for i=1:max_iter
     x(i+1) = sin(pi*x(i));
     G(i)=(x(i))*Value;
 end
    case 8
 %Singer map 
 u=1.07;
 for i=1:max_iter
     x(i+1) = u*(7.86*x(i)-23.31*(x(i)^2)+28.75*(x(i)^3)-13.302875*(x(i)^4));
     G(i)=(x(i))*Value;
 end
    case 9
%Sinusoidal map
 for i=1:max_iter
     x(i+1) = 2.3*x(i)^2*sin(pi*x(i));
     G(i)=(x(i))*Value;
 end
 
    case 10
 %Tent map
 x(1)=0.1;
 for i=1:max_iter
     if x(i)<0.7
         x(i+1)=x(i)/0.7;
     end
     if x(i)>=0.7
         x(i+1)=(10/3)*(1-x(i));
     end
     G(i)=(x(i))*Value;
 end
 
 case 11
 %new map
 x(1)=0.1;
 for i=1:max_iter
     if x(i)<0.7
         x(i+1)=(x(i)/0.7)*sin(pi*rand);
     end
     if x(i)>=0.7
         x(i+1)=((10/3)*(1-x(i)))*sin(pi*rand);
     end
     G(i)=(x(i))*Value;
 end
 
 
 case 12
 %chirp log map
 ch_t = 0:0.2:1.8;
 ch_y = chirp(ch_t,10,10,400,'logarithmic');
 for i=1:max_iter
     x(i) = ch_y(i);
     G(i)=(x(i))*Value;
 end
 
 case 13
 %chirp quad map
 ch_t = 0:0.2:1.8;
 ch_y = chirp(ch_t,0,1,250,'quadratic');
 for i=1:max_iter
     x(i) = ch_y(i);
     G(i)=(x(i))*Value;
 end
 
 case 14
 %new map
 x(1)=0.1;
 for i=1:max_iter
     if x(i)<0.8
         x(i+1)=(x(i)/0.8)*sin(pi*rand);
     end
     if x(i)>=0.8
         x(i+1)=((10/2)*(1-x(i)))*sin(pi*rand);
     end
     G(i)=(x(i))*Value;
 end

end
O=G;