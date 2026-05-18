% =========================================================================
% MATLAB Live AprilTag Scanner (With Outlined Text & Updated Labels)
% =========================================================================

% 1. Connect to the webcam
try
    cam = webcam();
catch
    error('Webcam not found. Please install the USB Webcam Add-On.');
end

disp('Camera connected! Close the image window to stop the scanner.');

% 2. Setup the UI Window
fig = figure('Name', 'Live AprilTag Scanner', 'NumberTitle', 'off');
ax = axes('Parent', fig);

% Grab a single test frame
img = snapshot(cam);
[imgHeight, imgWidth, ~] = size(img);

% Create an image object on the screen
hImg = imshow(img, 'Parent', ax);
hold(ax, 'on');

% Top status text (Using a Dark Grey background so the bright Green pops)
hTopText = text(ax, imgWidth / 2, imgHeight * 0.05, 'Scanning for tags...', ...
     'Color', 'green', 'FontSize', 36, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', ...
     'BackgroundColor', [0.3 0.3 0.3], ... 
     'Margin', 10); 
 
% Bottom status text (Using a Light Grey background so the dark Blue pops)
hBotText = text(ax, imgWidth / 2, imgHeight * 0.95, '', ...
     'Color', 'blue', 'FontSize', 24, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', ...
     'BackgroundColor', [0.8 0.8 0.8], ... 
     'Margin', 10);

hGraphics = [];

% Define dynamic color palette for the text fill
colors = {'#D95319', '#FF33F6', '#EDB120', '#4DBEEE', '#77AC30', '#FFFFFF'};

% 3. The Live Video Loop
try
    while ishandle(fig)
        
        img = snapshot(cam);
        if ~isgraphics(hImg)
            break;
        end
        
        set(hImg, 'CData', img); 
        
        grayImg = im2gray(img);
        adjImg = imadjust(grayImg);
        [id, loc] = readAprilTag(adjImg, 'tag36h11');
        
        delete(hGraphics); 
        hGraphics = []; 
        
        if isempty(id)
             hTopText.String = 'Scanning for tags...';
             hTopText.Color = 'red';
             hBotText.String = '';
        else
             hTopText.String = sprintf('Success! Found %d Tag(s)', numel(id));
             hTopText.Color = 'green';
             
             idStr = sprintf('%d, ', id);
             hBotText.String = sprintf('Detected IDs: %s', idStr(1:end-2));
             
             for i = 1:numel(id)
                 currentID = id(i);
                 corners = loc(:,:,i);
                 center = mean(corners);
                 
                 colorIdx = mod(i - 1, length(colors)) + 1;
                 currColor = colors{colorIdx};
                 
                 % --- UPDATED: Check for duplicate tags & format string ---
                 occurrence = sum(id(1:i) == currentID);
                 if sum(id == currentID) > 1
                     % Use 64 so occurrence 1 = 65 ('A'), 2 = 66 ('B'), etc.
                     suffix = char(64 + occurrence); 
                     labelText = sprintf('Tag %d (%s)', currentID, suffix);
                 else
                     labelText = sprintf('Tag %d', currentID);
                 end
                 % ---------------------------------------------------------
                 
                 % Draw the colored bounding box
                 hl = plot(ax, [corners(:,1); corners(1,1)], [corners(:,2); corners(1,2)], ...
                           'Color', currColor, 'LineWidth', 4);
                 
                 % --- THE TEXT OUTLINE EFFECT ---
                 offset = 3; 
                 outlineColor = 'black'; 
                 
                 tX = center(1);
                 tY = center(2) - 40;
                 
                 t1 = text(ax, tX-offset, tY-offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t2 = text(ax, tX+offset, tY-offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t3 = text(ax, tX-offset, tY+offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t4 = text(ax, tX+offset, tY+offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t5 = text(ax, tX, tY-offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t6 = text(ax, tX, tY+offset, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t7 = text(ax, tX-offset, tY, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 t8 = text(ax, tX+offset, tY, labelText, 'Color', outlineColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                 
                 tMain = text(ax, tX, tY, labelText, 'Color', currColor, 'FontSize', 28, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                     
                 hGraphics = [hGraphics; hl; t1; t2; t3; t4; t5; t6; t7; t8; tMain]; 
             end
        end
        
        drawnow limitrate; 
    end
catch
end

% 4. Clean up
clear cam; 
disp('Scanner closed and camera released.');