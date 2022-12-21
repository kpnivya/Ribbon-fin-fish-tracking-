% Converting frames back to video 
close all

output_movie_filename = 'Body_Approx.avi';
% output_video = VideoWriter(output_movie_filename,);
nFrames = 3605;
%Frames = movein(nFrames);
output_video = VideoWriter('Body_Approx','Motion JPEG AVI');
output_video.FrameRate = 60;
output_video.Quality = 100;
%output_video.VideoCompressionMethod = 'H.264';
open(output_video);

fig1 = figure('color','white');

hold on
%size_min = [1248; 2009; 3];
for frame_idx = 1:4822
    s_frame_idx = num2str(frame_idx);
    defaultFileName = strcat(s_frame_idx,'_modified_video1.tif');
    I = imread(defaultFileName); % read the image 
%     if (norm(size(I) - size_min) ~= 0)
%         I = I(1:1248, 1:2009, :);
%     end
    imshow(I);
    %rect = [0, 1200, 1700, 1200];
    frame = getframe(gcf);
    writeVideo(output_video,frame);
    clf 
end
close(output_video);