%Radial Movie Function will accept an NxT vector of phases and 
%generate a movie of these phases plotted radially

function matrix_movie(thetas)
%print('Make sure input vector is N x T where N is number of oscillators and T is number of timesteps!!')
step_size = 10; %data points per frame

%Movie Generation
writerObj = VideoWriter('2animation.avi');
writerObj.FrameRate = 60;
open(writerObj)
count = 1;

%for a given amount of time
    figure(1)
if ndims(thetas) == 2
        step_number = numel(thetas(1,:));
        N = numel(thetas(:,1));
        for i = 1:step_size:step_number
            imagesc(1,[1:N],sin(thetas(:,i)));
            colorbar;
            caxis([-1, 1]);
            M(count) = getframe;    %get frame for movie
            writeVideo(writerObj,M(count))
            count = count + 1;
        end
else

    step_number = numel(thetas(1,1,:));
    for i = 1:5:step_number
        imagesc(sin(thetas(:,:,i)));
        colorbar;
        caxis([-1, 1]);
        M(count) = getframe;    %get frame for movie
        writeVideo(writerObj,M(count))
        count = count + 1;
    end
end
close(writerObj);
end
