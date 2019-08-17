function ff = Foscv13(t, V,Num,R,Rp,Rm,R02,R01,b,ni)

%This file contains the equations of motion (EOM). 
%Because the integration is of Runge-Kutta type
%it uses a first order system of 2 equations instead of one
%second order 
%if ni different from 0 it runs the R-=infty case

%Num the number of oscillators

%u(i)=Vi values of voltage
u=zeros(1,Num);

%p(i)=Vi' values of derivatives
p=zeros(1,Num);

%taking the initial conditions
for i=1:Num
    
u(i)=V(i);
p(i)=V(i+Num);

end


%ff is the result of Foscv13
%The first Num rows contain the values of Vi'
%i.e. ff(1,1)=V1', ff(i,1)=Vi'
%The latter Num rows contain the values of Vi''
%i.e. ff(1+Num,1)=V1'', ff(i+Num,1)=Vi''
ff=zeros(2*Num,1);


%here it calculates the values of the resistance R1,R2
%which can be found in functions r1f.m,r2f.m respectively
r1=r1fb(u,R01 );
r2=r2fb(u,b,R02 );

%here the values of vout(i)=Vout_i and its derivatives dvout(i)=Vout_i'
%are calculated using the function voutf1b.m
[vout,dvout, A_inv]=voutf1b(V,b,R01,R02,Rm,Num,ni);

%here finally the equations are defined
for i=1:Num
 %the values of Vi'
ff(i,1)=p(i);

%the values of Vi''

%ni=0 ==> R-=finite
if (ni==0)
    
%for more than 2 oscillators (the case of the ring)    
if(Num>2)
    
%equations (2) of the manuscript Vi''=...
%Note that ff(i,1)=Vi' and u(i)=Vi by definition

%Periodic boundary conditions are used i.e. 

%V(1-1)=V(Num), 
if(i==1)
    ff(i+Num,1)=-(2-r1(i)./r2(i)-2*r1(i)/Rm+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(i+1)+vout(Num))-(r1(i)/Rm-R/Rp)*(dvout(i+1)+dvout(Num));

else
    %V(Num+1)=V(1)
    if(i==Num)
        ff(i+Num,1)=-(2-r1(i)./r2(i)-2*r1(i)/Rm+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(1)+vout(i-1))-(r1(i)/Rm-R/Rp)*(dvout(1)+dvout(i-1));
    else
         ff(i+Num,1)=-(2-r1(i)./r2(i)-2*r1(i)/Rm+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(i+1)+vout(i-1))-(r1(i)/Rm-R/Rp)*(dvout(i+1)+dvout(i-1));
    end
end

else
%for a single oscillator   the EOM  
    if(Num==1)
    ff(i+Num,1)=-(2-r1(i)./r2(i))*ff(i,1)-(1)*u(i);
    end
    
%the equations of motion for the oscillator pair    
    if(Num==2)
        if(i==1)
            %1st oscillator
    ff(i+Num,1)=-(2-r1(i)./r2(i))*ff(i,1)-(1)*u(i);
        else
            %2nd oscillator (equation without the factor of 2)
           ff(i+Num,1)=-(2-r1(i)./r2(i)-2*r1(i)/Rm+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(i-1))-(r1(i)/Rm-R/Rp)*(dvout(i-1));
           %if the factor of 2 was there they would be as follows
           %ff(i+Num,1)=-(2-r1(i)./r2(i)-2*r1(i)/Rm+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(1)+vout(i-1))-(r1(i)/Rm-R/Rp)*(dvout(1)+dvout(i-1));
        end
    end
end

%this is for ni \neq 0, i.e. for the case R-=\infty
%the equations of motion with periodic boundary conditions
else
   if(i==1)
    ff(i+Num,1)=-(2-r1(i)./r2(i)+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(i+1)+vout(Num))-(-R/Rp)*(dvout(i+1)+dvout(Num));

else
    if(i==Num)
        ff(i+Num,1)=-(2-r1(i)./r2(i)+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(1)+vout(i-1))-(-R/Rp)*(dvout(1)+dvout(i-1));
    else
         ff(i+Num,1)=-(2-r1(i)./r2(i)+2*R/Rp)*ff(i,1)-(1+2*R/Rp)*u(i)+(R/Rp)*(vout(i+1)+vout(i-1))-(-R/Rp)*(dvout(i+1)+dvout(i-1));
    end
end
end

end
