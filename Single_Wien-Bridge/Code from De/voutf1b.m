function [vout,dvout,pinA]=voutf1b(yv,b,R10,R20,Rm,Num,ni)

%It calculates the valus of vout(i)=Vout_i and dvout(i)=Vout_i'
%it can also export the matrix A of the manuscript under the name pinA

%u is the voltage values u(i)=Vi
%du  is its dervatives du(i)=Vi'

u=yv(1:Num);
du=yv(Num+1:2*Num);

%this just to take the u,p always as row vectors
if(size(u,1)>1)
    
u1=yv(1:Num);
du1=yv(Num+1:2*Num);
    u=transpose(u1);
    du=transpose(du1);
end

%the case of finite R-
if (ni==0)

%values of r1=R1 and r2=R2 as well as their derivatives 
%dr1=dR1/dVi and dr2=dR2/dVi

[r1,dr1]=r1fb(u,R10 );
[r2,dr2]=r2fb(u,b,R20 );

%values of gamma and c (here c1)
gam=r1./Rm;
c1=1+r1./r2+2.*gam;

%initializing a zero matrix A of dimensions NxN
pinA=zeros(Num,Num);


%constructing the matrix A (here pinA) as in manuscript
for i=1:Num
    pinA(i,i)=1;
    if(Num>1)
    if(i==1)
         pinA(i,Num)=gam(i);
         pinA(i,i+1)=gam(i);

    else
        
        if(i==Num)
            
         pinA(i,i-1)=gam(i);
         pinA(i,1)=gam(i);
         
        else
            
         pinA(i,i-1)=gam(i);
         pinA(i,i+1)=gam(i);
         
        end
        
     end
    end
end

%calculation of vout(i), inv(pinA) takes the inverse of matrix A
%transpose(u) is the column vector of voltages 
%transpose(c1) is the column vector c
%note that the symbol * does matrix multiplication
%   (A*B)_{ik}=A_{ij}B_{jk}, sum at j
%whereas .* does a multiplication element by element 
%   (A.*B)_{ik}=A_{ik}B_{ik}
%equation (4) of manuscript
vout=transpose(c1).*((inv(pinA)*transpose(u)));

%dc1 is the derivative of c in time
dc1=-(r1./(r2.^2)).*dr2.*du;

%calculation of Vout_i'=dvout(i), eq. (6)  manuscript
dvout=transpose(c1).*((inv(pinA)*transpose(du)))+transpose(dc1).*((inv(pinA)*transpose(u)));


%the case of  R-=infty
else
    %A is an identity matrix
    pinA=eye(Num,Num);
    
    %values of R1,R2 and their derivatives 
    [r1,dr1]=r1fb(u,R10 );
    [r2,dr2]=r2fb(u,b,R20 );
    
    %value of c (here c1)
    c1=1+r1./r2;
    %calculation of vout(i)=Vout_i
    vout=transpose(c1).*((inv(pinA)*transpose(u)));
    %calculation of dc/dt
    dc1=-(r1./(r2.^2)).*dr2.*du;
    %calculation of dvout(i)=Vout_i'
    dvout=transpose(c1).*((inv(pinA)*transpose(du)))+transpose(dc1).*((inv(pinA)*transpose(u)));

end
end
