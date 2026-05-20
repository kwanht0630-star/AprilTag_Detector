% =========================================================================
% MATLAB AprilTag AR Chess Tracker
% =========================================================================

%% --- 1. SYSTEM INITIALIZATION ---

tag13SizeInSquares = 1.5; 

% --- NEW: PARALLAX (TALL PIECE) CORRECTION ---
% This pulls the mathematical point towards the center of the lens 
% to compensate for the height of the pieces. 
% Increase to 0.20 if edge pieces still show up outside their squares!
parallaxCorrection = 0.15; 
% ---------------------------------------------

pieceMap = containers.Map('KeyType', 'double', 'ValueType', 'char');

pieceMap(1) = char(hex2dec('265F')); % White Pawns (Physical Black)
pieceMap(2) = char(hex2dec('265C')); % White Rooks
pieceMap(3) = char(hex2dec('265E')); % White Knights
pieceMap(4) = char(hex2dec('265D')); % White Bishops
pieceMap(5) = char(hex2dec('265B')); % White Queen
pieceMap(6) = char(hex2dec('265A')); % White King

pieceMap(7) = char(hex2dec('265F')); % Black Pawns (Physical White)
pieceMap(8) = char(hex2dec('265C')); % Black Rooks
pieceMap(9) = char(hex2dec('265E')); % Black Knights
pieceMap(10)= char(hex2dec('265D')); % Black Bishops
pieceMap(11)= char(hex2dec('265B')); % Black Queen
pieceMap(12)= char(hex2dec('265A')); % Black King
unknownSymbol = '•';

files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']; 
ranks = ['8', '7', '6', '5', '4', '3', '2', '1']; 

%% --- 2. CAMERA CONNECTION ---
try cam = webcam('USB攝影機'); catch, error('Webcam not found.'); end
disp('Camera connected!');

tempImg = snapshot(cam);
[imgH, imgW, ~] = size(tempImg);

isBoardLocked = false; 
lockStartTime = []; 
tform = []; 

%% --- 3. GUI SETUP ---
fig = figure('Name', 'Dual Vision Chess Tracker', 'Position', [100, 100, 1500, 700], 'Color', 'white');

% Panel 1: Live Camera Feed 
ax1 = subplot(1, 3, [1 2]); 
hImg = imshow(tempImg, 'Parent', ax1);
hold(ax1, 'on');
xlim(ax1, [1 imgW]); ylim(ax1, [1 imgH]); 
hTitle = title(ax1, 'AWAITING CALIBRATION: Place Tag 13 dead center!', 'FontSize', 16, 'Color', 'red', 'FontWeight', 'bold');
text(ax1, imgW/2, imgH-30, 'WARNING: Tag 13 Bottom MUST face White Pieces!', 'Color', 'magenta', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'BackgroundColor', 'black');

% Panel 2: Digital Board
ax2 = subplot(1, 3, 3);
title(ax2, 'Digital Twin (Updates on Move)', 'FontSize', 16);
hold(ax2, 'on'); axis(ax2, 'off'); axis(ax2, 'equal');
xlim(ax2, [-1 9]); ylim(ax2, [-1 9]);

for r = 1:8
    for c = 1:8
        if mod(r+c, 2) == 0, color = [0.93 0.93 0.82]; else, color = [0.46 0.59 0.34]; end
        patch(ax2, [c-1 c c c-1], [8-r 8-r 8-r+1 8-r+1], color, 'EdgeColor', 'none');
    end
end
for i = 1:8
    text(ax2, i-0.5, -0.3, files(i), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    text(ax2, -0.3, 8-i+0.5, ranks(i), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end

%% --- 4. PRE-LOAD THE DIGITAL BOARD ---
displayedBoard = zeros(8,8);
displayedBoard(1,:) = [2, 3, 4, 5, 6, 4, 3, 2]; 
displayedBoard(2,:) = repmat(1, 1, 8);              
displayedBoard(7,:) = repmat(7, 1, 8);              
displayedBoard(8,:) = [8, 9, 10, 11, 12, 10, 9, 8];     

hDigitalPieces = [];
for r = 1:8
    for c = 1:8
        id = displayedBoard(r, c);
        if id > 0 && isKey(pieceMap, id)
            if id <= 6, pColor = 'black'; else, pColor = 'white'; end
            xPos = c - 0.5; yPos = 8 - r + 0.5;
            tOut = text(ax2, xPos, yPos-0.02, pieceMap(id), 'Color', 'black', 'FontSize', 50, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
            tMain = text(ax2, xPos, yPos, pieceMap(id), 'Color', pColor, 'FontSize', 50, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
            hDigitalPieces = [hDigitalPieces; tOut; tMain];
        end
    end
end

%% --- 5. THE LIVE LOOP ---
hCamGraphics = [];

try
    while ishandle(fig)
        img = snapshot(cam);
        if ~isgraphics(hImg), break; end
        set(hImg, 'CData', img); 
        
        grayImg = im2gray(img);
        adjImg = imadjust(grayImg);
        [ids, locs] = readAprilTag(adjImg, 'tag36h11');
        
        delete(hCamGraphics); 
        hCamGraphics = []; 
        
        % =================================================================
        % PHASE 1: SEARCHING FOR TAG 13 (PERSPECTIVE CALIBRATION)
        % =================================================================
        if ~isBoardLocked
            idx13 = find(ids == 13, 1);
            
            if isempty(idx13)
                lockStartTime = []; 
                hTitle.String = 'AWAITING CALIBRATION: Place Tag 13 dead center!';
                hTitle.Color = 'red';
            else
                if isempty(lockStartTime)
                    lockStartTime = tic; 
                end
                
                elapsed = toc(lockStartTime);
                timeLeft = max(0, 5 - elapsed);
                
                corners13 = locs(:,:,idx13);
                
                tL = 4 - (tag13SizeInSquares / 2);
                tR = 4 + (tag13SizeInSquares / 2);
                
                idealCorners = [
                    tL, tR; % Bottom-Left
                    tR, tR; % Bottom-Right
                    tR, tL; % Top-Right
                    tL, tL; % Top-Left
                ];
                
                tform_temp = fitgeotrans(idealCorners, corners13, 'projective');
                
                hTitle.String = sprintf('Locking Perspective in %.1f sec... Keep it upright!', timeLeft);
                hTitle.Color = [1 0.5 0]; 
                
                for i = 0:8
                    [px, py] = transformPointsForward(tform_temp, [i i], [0 8]);
                    l1 = plot(ax1, px, py, 'y--', 'LineWidth', 2);
                    [px, py] = transformPointsForward(tform_temp, [0 8], [i i]);
                    l2 = plot(ax1, px, py, 'y--', 'LineWidth', 2);
                    hCamGraphics = [hCamGraphics; l1; l2];
                end
                
                if elapsed >= 5
                    tform = tform_temp;
                    isBoardLocked = true;
                    hTitle.String = 'Board Perspective Locked! (You may remove Tag 13)';
                    hTitle.Color = 'black';
                    disp('Calibration Complete. 3D Perspective locked.');
                end
            end
            
            drawnow limitrate; 
            continue; 
        end
        
        % =================================================================
        % PHASE 2: PLAYING CHESS (BOARD IS LOCKED)
        % =================================================================
        
        for i = 0:8
            [px, py] = transformPointsForward(tform, [i i], [0 8]);
            l1 = plot(ax1, px, py, 'r-', 'LineWidth', 1);
            [px, py] = transformPointsForward(tform, [0 8], [i i]);
            l2 = plot(ax1, px, py, 'r-', 'LineWidth', 1);
            hCamGraphics = [hCamGraphics; l1; l2];
        end
        
        currentBoard = zeros(8, 8);
        
        if ~isempty(ids)
             for i = 1:numel(ids)
                 currentID = ids(i);
                 if currentID == 13, continue; end 
                 
                 corners = locs(:,:,i);
                 center = mean(corners);
                 
                 if isKey(pieceMap, currentID)
                     chessSymbol = pieceMap(currentID);
                     if currentID <= 6 
                         pieceColor = 'black'; outlineColor = 'white'; 
                     else 
                         pieceColor = 'white'; outlineColor = 'black'; 
                     end
                 else
                     chessSymbol = unknownSymbol; pieceColor = 'red'; outlineColor = 'yellow';
                 end
                 
                 % Draw AR Overlay (Stays perfectly on top of the physical tag)
                 offset = 2; tX = center(1); tY = center(2);
                 t1 = text(ax1, tX-offset, tY-offset, chessSymbol, 'Color', outlineColor, 'FontSize', 40, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                 t2 = text(ax1, tX+offset, tY-offset, chessSymbol, 'Color', outlineColor, 'FontSize', 40, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                 t3 = text(ax1, tX-offset, tY+offset, chessSymbol, 'Color', outlineColor, 'FontSize', 40, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                 t4 = text(ax1, tX+offset, tY+offset, chessSymbol, 'Color', outlineColor, 'FontSize', 40, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                 tMain = text(ax1, tX, tY, chessSymbol, 'Color', pieceColor, 'FontSize', 40, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                 hCamGraphics = [hCamGraphics; t1; t2; t3; t4; tMain];
                 
                 % --- INVERSE GRID SNAPPING WITH PARALLAX CORRECTION ---
                 % Find the center of the camera lens
                 camCenterX = imgW / 2;
                 camCenterY = imgH / 2;
                 
                 % Pull the X/Y coordinates slightly towards the center of the lens
                 % to estimate where the BASE of the piece is touching the board
                 baseX = center(1) - parallaxCorrection * (center(1) - camCenterX);
                 baseY = center(2) - parallaxCorrection * (center(2) - camCenterY);
                 
                 % Now run the Un-warp math on the BASE coordinate, not the TAG coordinate
                 [idealX, idealY] = transformPointsInverse(tform, baseX, baseY);
                 
                 colIdx = floor(idealX) + 1;
                 rowIdx = floor(idealY) + 1;
                 
                 if colIdx >= 1 && colIdx <= 8 && rowIdx >= 1 && rowIdx <= 8
                     currentBoard(rowIdx, colIdx) = currentID;
                 end
             end
        end
        
        if sum(currentBoard(:) > 0) > 5 && ~isequal(currentBoard, displayedBoard)
            displayedBoard = currentBoard; 
            
            delete(hDigitalPieces); 
            hDigitalPieces = [];
            
            for r = 1:8
                for c = 1:8
                    id = displayedBoard(r, c);
                    if id > 0 && isKey(pieceMap, id)
                        if id <= 6, pColor = 'black'; else, pColor = 'white'; end
                        xPos = c - 0.5; yPos = 8 - r + 0.5;
                        tOut = text(ax2, xPos, yPos-0.02, pieceMap(id), 'Color', 'black', 'FontSize', 50, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                        tMain = text(ax2, xPos, yPos, pieceMap(id), 'Color', pColor, 'FontSize', 50, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
                        hDigitalPieces = [hDigitalPieces; tOut; tMain];
                    end
                end
            end
            disp('Digital Board Updated.');
        end
        
        drawnow limitrate; 
    end
catch
end

clear cam; 
disp('System closed.');