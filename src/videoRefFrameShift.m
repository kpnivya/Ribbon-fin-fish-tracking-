% To translate head position to fixed point & to orient the angle between
% head and body center to 0 degrees

clc 
clear
close all
% Load the data with Head, Body center and tail tracked
DataSet = load('D:\Nivya\code\Head_BC_Tail_ChangedBackground.mat'); 
HeadX = DataSet.head_x;
HeadY = DataSet.head_y;
BodyCX = DataSet.bc_x;
BodyCY = DataSet.bc_y;

% Reference head position
HeadRef = [HeadX(1), HeadY(1)];
BodyCRef = [BodyCX(1), BodyCY(1)];
len = length(BodyCY);

% Whereever you want to save the modified frames
ImageFolder = 'D:/Nivya/EverythingFrames/frames_for_body';
diff_origin = zeros(len, 2);

% To crop excessive part in the frames
crop_index1 = 227;
crop_index2 = 811;
HeadY = HeadY-crop_index1;
BodyCY = BodyCY-crop_index1;

HeadRef = zeros(len,2);
BodyCRef = zeros(len, 2);
ChangeInAngle = zeros(len, 1);
ChangeInOriginX = zeros(len, 1);
ChangeInOriginY = zeros(len, 1);
NewOrigin = zeros(len, 2);
HeadBodyCenter_Distance = zeros(len, 1);
BodyCNew = zeros(len, 2);

% Matrix to draw lines
B = zeros(61, 4);

for i = 1:len
    s_i = num2str(i);
    str_start = strcat(s_i,'.tif');
    Im = imread(str_start);

    HeadRef(i, :) = [HeadX(i), HeadY(i)];
    BodyCRef(i, :) = [BodyCX(i), BodyCY(i)];
    ChangeInAngle(i) = atan2((HeadY(i) - BodyCY(i)), (HeadX(i) - BodyCX(i)))*(180/pi);
    ChangeInOriginX(i) = HeadX(1) - HeadX(i);
    ChangeInOriginY(i) = HeadY(1) - HeadY(i);
    HeadBodyCenter_Distance(i) = norm(HeadRef(i, :) - BodyCRef(i, :));
    if (ChangeInAngle < 0)
        BodyCNew(i, :) = [(BodyCX(i) + ChangeInOriginX(i)), (BodyCY(i) + ChangeInOriginY(i) + HeadBodyCenter_Distance(i)*sin(ChangeInAngle(i)))];
    else
        BodyCNew(i, :) = [(BodyCX(i) + ChangeInOriginX(i)), (BodyCY(i) + ChangeInOriginY(i) - HeadBodyCenter_Distance(i)*sin(ChangeInAngle(i)))];
    end
    NewOrigin(i, :) = [HeadX(i) + ChangeInOriginX(i), HeadY(i) + ChangeInOriginY(i)]; 
    
    [rows, columns, numberOfColorChannels] = size(Im);
    origin = [HeadX(1), HeadY(1)];  % Assume x, y, NOT row, column
    xdata = -origin(1) : columns - origin(1);
    ydata = -origin(2) : columns - origin(2);
    imshow(Im, 'XData', xdata, 'YData', ydata);

    Im_modified_trans = imtranslate(Im, [ChangeInOriginX(i) ChangeInOriginY(i)]);
    Im_modified_rot = rotateAround(Im_modified_trans, NewOrigin(i, 2), NewOrigin(i, 1), ChangeInAngle(i));
    
    k = 0;  
    B(1, :) = [(NewOrigin(i, 1)-200) 0 (NewOrigin(i, 1)-200) 1250];    
    
    % Change j based on the number of lines you want to draw
    for j = 2:60
        B(j, :) = [(NewOrigin(i, 1) - 200 - k*20) 0 (NewOrigin(i, 1) - 200 - k*20) 1250]; 
        k = k + 1;
    end
    
    Im_modified = insertShape(Im_modified_rot,"line",B, "Color",'red',"LineWidth",2);

    diff_origin((i), 1) = HeadX(1) - HeadX(i);
    diff_origin((i), 2) = HeadY(1) - HeadY(i);
    defaultFileName = strcat(s_i,'_modified_video1.tif');
    fullFileName = fullfile(ImageFolder,defaultFileName);
    imwrite(Im_modified, fullFileName);
    close all
end

% DataCheck_Head_Actual = [HeadX(1), HeadY(1);
%     HeadX(500), HeadY(500);
%     HeadX(1000), HeadY(1000);
%     HeadX(1500), HeadY(1500);
%     HeadX(2000), HeadY(2000);
%     HeadX(2500), HeadY(2500);
%     HeadX(3000), HeadY(3000);
%     HeadX(3600), HeadY(3600);];
% 
% DataCheck_bc_actual = [BodyCX(1), BodyCY(1);
%     BodyCX(500), BodyCY(500);
%     BodyCX(1000), BodyCY(1000);
%     BodyCX(1500), BodyCY(1500);
%     BodyCX(2000), BodyCY(2000);
%     BodyCX(2500), BodyCY(2500);
%     BodyCX(3000), BodyCY(3000);
%     BodyCX(3600), BodyCY(3600);];

return