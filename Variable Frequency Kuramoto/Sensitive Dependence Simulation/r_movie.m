%Radial Movie Function will accept an NxT vector of phases and 
%generate a movie of these phases plotted radially

function r_movie(thetas)
%print('Make sure input vector is N x T where N is number of oscillators and T is number of timesteps!!')
rho = thetas(:,1) ./ thetas(:,1);                  %creates rho vector for graphing 


%Movie Generation
writerObj = VideoWriter('animation.avi');
writerObj.FrameRate = 60;
open(writerObj)
count = 1;
%for a given amount of time
for i = 1:numel(thetas(1,:))
     %graph each oscillator on a radial plot  
     figure(1)
     %subplot(1,2,1);
     plot(rho.*cos(thetas(:,i)),rho.*sin(thetas(:,i)),'.')
     axis([-1.2 1.2 -1.2 1.2 ]);
     M(count) = getframe;    %get frame for movie
     writeVideo(writerObj,M(count))
     count = count + 1;
end
close(writerObj);