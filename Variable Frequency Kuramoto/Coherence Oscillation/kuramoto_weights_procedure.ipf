#pragma rtGlobals=1		// Use modern global access method.
function kuramotoweights()

// Variable Declaration
variable N, dt, tmax, s2,c2,r,i,j,t,s, K

// Simulation Parameters
dt=0.1;		// Timestep
N=100;		// Number of Oscillators
tmax=4000;     // Length of Simulation
K = .75;            // Global Coupling Strength

// Wave initialization
Make/o/n=(N,tmax/dt) phi           // Wave containing Phase Values 
Make/o/n=(N,tmax/dt) omega    // Wave containing  Frequency Values
Make/o/n=(tmax/dt) op               // Wave to store order parameter
Make/o/n=(tmax/dt) sqop           // Wave to store order parameter
Make/o/n =(tmax/dt) ts		    //  Wave to store time

// Wave declaration
wave phi,omega, op, sqop, ts


// Set initial Conditions
omega=gnoise(0.1)+1;   //  Initial Frequency follows a gaussian distribution
phi=gnoise(0.1)+1;         // Initial Phase follows a gaussian distribution
s2=0;                                // sine squared starts at 0		
c2=0; 			 	// cosine squared starts at 0
s=0;					// sum variable starts at 0
r=0;					// order parameter starts at 0

for(t=0;t<tmax;t=t+1)  // for loop to runs from time = 0 to t max




for(i=1;i<N;i=i+1)  //for loop iterates through each oscillator and...

// Sums over sine and cosine of the ith oscillator phase
s2=s2+sin(phi[i][t]); 
c2=c2+cos(phi[i][t]);
	
	//Calculates the sum of the total weight/impact from every other oscillator, and 
	for(j=0;j<N;j=j+1)
	s=s+K*sin(phi[j][t]-phi[i][t])
	endfor

// Order Parameter
r=sqrt(c2^2+s2^2)/N  // calculate the order paremeter by summing squares of sine and cosine sums of each oscillator phase
op[t]=r			    // store order paramter in op wave
sqop[t]=r^2		    // store sqare of order paramer in sqop wave
s2=0;c2=0;                  // reset sine square and cosine squared to zero for next iteration


phi[i][t]=phi[i-1][t]+(omega[i][t]+(s/N))*dt   // Calculates the next phase point and stores it in the phi wave
s=0
endfor

ts[t] = t

endfor

end