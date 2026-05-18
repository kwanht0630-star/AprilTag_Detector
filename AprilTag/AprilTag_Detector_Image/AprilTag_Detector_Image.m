% =========================================================================
% MATLAB AprilTag Detector 
% =========================================================================

% 1. Open a native MATLAB file dialog to visually select the image
disp('Waiting for you to select an image...');
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.heic', 'Image Files (*.jpg, *.png, *.heic)'}, ...
                         'Select an Image with an AprilTag');

% Exit if you hit "Cancel" in the popup window
if isequal(file, 0)
    disp('Canceled image selection. Exiting script.');
    return;
end

% 2. Read the selected image securely using MATLAB's fullfile function
fullFilePath = fullfile(path, file);
img = imread(fullFilePath);

% 3. Pre-process the image for your custom black-on-cardboard tag
grayImg = im2gray(img);
adjustedImg = imadjust(grayImg);

% 4. Detect the tag (Using standard tag36h11)
tagFamily = 'tag36h11';
disp('Analyzing image...');
[id, loc] = readAprilTag(adjustedImg, tagFamily);

% 5. Create a polished popup window to show the results
figure('Name', 'AprilTag Detector Results', 'NumberTitle', 'off');
imshow(img);
hold on;

if isempty(id)
    disp('No tags detected. Try adjusting the lighting and taking another photo.');
    % Display a fail title right on the image with the original size
    figure('Name', 'AprilTag Detector Results', 'NumberTitle', 'off');
    imshow(img);
    title('No tags detected. Try using flash or brighter lights!', ...
          'Color', 'red', 'FontSize', 16, 'FontWeight', 'bold');
else
    % Success state
    figure('Name', 'AprilTag Detector Results', 'NumberTitle', 'off');
    imshow(img);
    hold on;

    % Get image dimensions (height x width) so we know exactly where the top and bottom are
    [imgHeight, imgWidth, ~] = size(img);

    % 1. Green words stamped inside the image at the VERY TOP
    text(imgWidth / 2, imgHeight * 0.05, ...
         sprintf('Success! Found %d Tag(s)', numel(id)), ...
         'Color', 'green', 'FontSize', 36, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center');
      
    for i = 1:numel(id)
        % Tell you what it is in the console
        fprintf('Detected Tag ID: %d \n', id(i));
        
        % Extract the 4 corners for the current tag
        corners = loc(:,:,i);
        
        % Draw a thick green bounding box around the tag
        plot([corners(:,1); corners(1,1)], [corners(:,2); corners(1,2)], ...
             'g-', 'LineWidth', 4);
    end
    
    % 2. Blue words stamped inside the image at the BOTTOM
    text(imgWidth / 2, imgHeight * 0.95, ...
         sprintf('Detected Tag ID: %d', id(1)), ...
         'Color', 'blue', 'FontSize', 24, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center');
end