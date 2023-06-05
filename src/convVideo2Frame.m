% Extracts frames from video
clc
clear all

% import the video file
obj = VideoReader('D:Nivya\Stationary_Tracking_Try2\Stationary_Tracking-Nivya-2022-10-31\videos\ChangedBackground\Video1DLC_resnet50_Stationary_TrackingOct31shuffle1_25000_labeled.mp4');
vid = read(obj);

% read the total number of frames
Frames = obj.NumFrames;

% file format of the frames to be saved in
ST ='.tif';

% reading and writing the frames
for x = 1 : Frames

	% converting integer to string
	Sx = num2str(x);

	% concatenating 2 strings
	Strc = strcat(Sx, ST);
	Vid = vid(:, :, :, x);
    iptsetpref("ImshowAxesVisible","on")
	cd frames_1\

	% exporting the frames
	imwrite(Vid, Strc);
	cd ..
end
