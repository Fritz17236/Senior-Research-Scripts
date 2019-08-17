function [r1,dr1]=r1fb(u,R10 )
%it returns the value of R1_i=r1(i) and its derivative dri=dRi/dV
r1=R10.*ones(size(u,1),size(u,2));
dr1=zeros(size(u,1),size(u,2));
end