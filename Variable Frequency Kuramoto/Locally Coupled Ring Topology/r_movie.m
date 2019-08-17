%Radial Movie Function will accept an NxT vector of phases and 
%generate a movie of these phases plotted radially

function r_movie(thetas)
%print('Make sure input vector is N x T where N is number of oscillators and T is number of timesteps!!')
rho = thetas(:,1) ./ thetas(:,1);                  %creates rho vector for graphing 
N = numel( thetas(:,1) );

%Movie Generation
writerObj = VideoWriter('animation.avi');
writerObj.FrameRate = 60;
open(writerObj)
count = 1;
%for a given amount of time
figure(1)
for i = 1:40:numel(thetas(1,:))
     %graph each oscillator on a radial plot  
     
     plot( (1:N), sin( thetas(:,i) ),'.' );
     %plot(rho.*cos(thetas(:,i)),rho.*sin(thetas(:,i)),'.')
     axis([1 N -1.1 1.1 ]);
     M(count) = getframe;    %get frame for movie
     writeVideo(writerObj,M(count))
     count = count + 1;
end
close(writerObj);