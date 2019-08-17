function [ mean_winding ] = windings( xa )
%Windings sums the phase differences over a 10x10 square loop perimeter and
%calculates the winding number (via mod 2pi);
%Assumes a 100x100 Lattice of Oscillators
a = xa;
T = numel(xa(1,1,:));


for t = 1:T
    
    topdiff = 0;
    rightdiff= 0;
    botdiff = 0;
    leftdiff = 0;
    for i=59:-1:51
        %top side
        topdiff = topdiff + ( xa(50,i,t)-xa(50,i-1,t) );
        
        %right
        rightdiff = rightdiff+ ( xa(i,59,t) - xa(i-1,59,t) );
    end
    
    
    for i = 50:58
        %left
        leftdiff = leftdiff + ( xa(i+1,50,t) - xa(i,50,t) );
        
        %bottom
        botdiff = botdiff + ( xa(59,i+1,t)-xa(59,i,t) );
    end
    
    
    
    totalDiff(1,t) = (leftdiff-topdiff)+(botdiff-leftdiff)+(rightdiff-botdiff)+(topdiff - rightdiff);
end

mean_winding = round((mean(totalDiff))/2*pi);

end