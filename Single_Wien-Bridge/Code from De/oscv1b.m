%main program performing the integration 
%the built-in routine ode23 of matlab is used 
%since this is a time-varying step-size method for reasons of greater
%accuracy arising from other systems I have integrated  numerically
%the time [ti tend] is partitioned in smaller intervals tv=ti:dti:tend and the 
%integraton is  performed sequantially in each of them

%parameter values: Num=Number of oscillators, Rp=R+,Rm=R-
Num=32;
R=4.7e3;
Rp=62e3;
Rm=136e3;
R02=2.7e3;
R01=9e3;
b=5;


% this initiallizes an array of zeros
x6=zeros(1,Num);


%choosing random initial conditions Vi in [-1,1], here u(i)=Vi
rr1=(ones(size(x6,1),size(x6,2))-2*rand(size(x6,1),size(x6,2)))*1;
u=x6+rr1;
%The Vi' are zero: here p(i)=Vi'
p=zeros(1,Num);

%partition of time form ti to tend
ti=0;
dti=0.05;
tend=600;
tv=ti:dti:tend;

%yv is the solution vector for the voltage.
%Its row length is the number of time steps and its column length is 2*Num
%The first Num columns conatin the values of the voltage Vi
%and the latter Num the values of its derivative Vi'
%i.e. if we would like to plot the V1 we plot 
%yv(:,1)=the first column of yv.
%This is initialized to 0
yv=zeros(length(tv),2*Num);



ti1=dti;


%vv are the the initial conditions u=Vi(0), p=Vi'(0)
vv=[u,p];
yv(1,:)=vv;



%options controlling integrator accuracy
options = odeset('RelTol', 1e-8,'AbsTol', 1e-8,'NormControl', 'on');%,'InitialStep',10^(-4) ); 
for i=1:length(tv)-1
    %the integration routine of matlab running for each partition of time
    %the equations to be integrated are contained in the function Foscv13
    %which apart from the initial conditions yv(i,:) takes also the
    %parameter values
    %there is an option to run the system with R-=infty if the last
    %argument is non-zero. If it is zero like here it considers the value
    %of R- given.
    [T1,Y1] = ode23(@(t,V) Foscv13(t, V,Num,R,Rp,Rm,R02,R01,b,0),[ti ti1], yv(i,:));
    ti=ti+dti;
    ti1=ti1+dti;
    yv(i+1,:)=Y1(end,:);
    
end

%Saving the parameters and the results tv=time, yv=voltage solution (see above)

savefile = ['BOscV3','N', num2str(Num),'Rm', num2str(Rm),'Rp',num2str(Rp),'dti',num2str(dti),'b',num2str(b),'.mat'];
save(savefile,'Num','vv','R','Rp','Rm','R02','R01','b','yv','tv','dti');
 A = yv(:,1:32)';
imagesc(A)
 
