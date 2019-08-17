%Radial Movie Function will accept an NxT vector of phases and 
%generate a movie of these phases plotted radially

function matrix_movie(thetas)
%print('Make sure input vector is N x T where N is number of oscillators and T is number of timesteps!!')


%Movie Generation
writerObj = VideoWriter('2D Lattice Simulation.avi');
writerObj.FrameRate = 60;
open(writerObj)
count = 1;
%for a given amount of time
    figure(1)
step_number = numel(thetas(1,1,:));
for i = 1:15:step_number
    imagesc(sin(thetas(:,:,i)));
    M(count) = getframe;    %get frame for movie
    writeVideo(writerObj,M(count))
    count = count + 1;
end
close(writerObj);