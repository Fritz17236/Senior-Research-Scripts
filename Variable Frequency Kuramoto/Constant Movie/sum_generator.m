function [ sum_vec ] = sum_generator( thetas )
%The summer function receives an NxN matrix of vector phases and returns an
% NxN matrix of sums containing the sum of the phase coupling term for each
% nearest-neighbor oscillator.  

N = numel(thetas(1,:));
sum_vec = zeros(N,N);

        for i = 1:N
            sum = 0;
            for j = 1:N
                %see if desired location is on edge
                 onLeftEdge   = false;    if (j == 1 )  onLeftEdge= true;    end
                 onRightEdge  = false;    if (j == N )  onRightEdge = true;  end
                 onTopEdge    = false;    if (i == 1 )  onTopEdge = true;    end
                 onBottomEdge = false;    if (i == N )  onBottomEdge = true; end

                 %count oscillator to right
                 if (~onRightEdge) sum = sum + sin( thetas(i,j+1) - thetas(i,j) ); end

                 % count oscillator to left
                 if (~onLeftEdge) sum = sum + sin( thetas(i,j-1) - thetas(i,j) ); end

                %count oscillator on top
                if (~onTopEdge) sum = sum + sin( thetas(i-1,j) - thetas(i,j) ); end

                %count oscillator on bottom
                if (~onBottomEdge) sum = sum + sin( thetas(i+1,j) - thetas(i,j) ); end

                %count oscillator on top left
                if (~onTopEdge && ~onLeftEdge) sum = sum + sin( thetas(i-1,j-1) - thetas(i,j) ); end

                %count Oscillator on top right
                if (~onTopEdge && ~onRightEdge) sum = sum + sin( thetas(i-1,j+1) - thetas(i,j) ); end

                %count oscillator on bottom left%
                if (~onBottomEdge && ~onLeftEdge) sum = sum + sin( thetas(i+1,j-1) - thetas(i,j) ); end

                %count oscillator on bottom right
                if (~onBottomEdge && ~onRightEdge) sum = sum + sin( thetas(i+1,j+1) - thetas(i,j) ); end
                
                %%insert periodic boundary conditions, lattice should wrap
                %%AROUND
                %if on top edge, wrap to bottom
                if (onTopEdge) sum = sum + sin( thetas(N,j) - thetas(i,j) ); end
                %if on bottom edge wrap to top
                if (onBottomEdge) sum = sum + sin( thetas(1,j) - thetas(i,j) ); end
                %if on left edge wrap to right
                if (onLeftEdge) sum = sum + sin( thetas(i,N) - thetas(i,j) ); end
                %if on right edge wrap to left
                if (onRightEdge) sum = sum + sin( thetas(i,1) - thetas(i,j) ); end
                
                            sum_vec(i,j) = sum;

            end
                
        end
    
    


end


