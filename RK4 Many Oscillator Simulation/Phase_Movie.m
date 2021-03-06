%Movie Function will accept an TxN vector of phases and 
%generate a movie of these phases plotted in time

function Phase_Movie(thetas)
%print('Make sure input vector is N x T where N is number of oscillators and T is number of timesteps!!')

%Movie Generation
writerObj = VideoWriter('animation.avi');
writerObj.FrameRate = 60;
open(writerObj)
count = 1;

N = numel(thetas(1,:));
%for a given amount of time
for i = 1:5:numel(thetas(:,1))
     %graph each oscillator on a radial plot  
     figure(1)
     %subplot(1,2,1);
     plot(thetas(i,:),'.')
     xlim([0 N]);
     ylim([-4 4]);
     M(count) = getframe;    %get frame for movie
     writeVideo(writerObj,M(count))
     count = count + 1;
end
close(writerObj);