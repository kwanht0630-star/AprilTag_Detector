# ♟️ MATLAB AprilTag AR Chess Tracker

A live, augmented reality (AR) chess tracking system built entirely in MATLAB. This project uses a single USB camera and AprilTags to track physical chess pieces, automatically correct for 3D perspective distortion, and map physical moves to a real-time digital twin dashboard.

## ✨ Features

* **Dual-Panel Dashboard:**

View the raw camera feed with AR Unicode piece overlays alongside a clean, "Chess.com-style" 2D digital twin that updates automatically when pieces move.

* **Dynamic 3D Perspective Calibration:**

Place a single calibration tag (Tag 13) in the center of the board. The system mathematically calculates a Projective Transformation Matrix (`fitgeotrans`) to instantly warp the digital tracking grid to match your physical board, regardless of camera tilt or angle.

* **Parallax Error Correction:**

Chess pieces are tall, causing them to visually "lean" into the wrong squares at the edges of the camera's view. A custom mathematical "center-pull" algorithm corrects this optical illusion without requiring complex 3D ray-tracing.

* **12-Tag Optimization:**

Instead of needing 32 unique tags, this system uses 12 Tag IDs mapped by piece *type* (e.g., all 8 White Pawns share Tag 7), relying on grid-snapping state memory to track individual moves.

## 🛠️ Requirements

### Software
* **MATLAB** (R2021a or newer recommended)
* **Image Processing Toolbox**
* **Computer Vision Toolbox**
* **MATLAB Support Package for USB Webcams**

### Hardware
* Standard USB Webcam (mounted above the board on a tripod or robotic arm).
* Physical chessboard and pieces.
* Printed AprilTags from the **`tag36h11`** family.



## 🏷️ AprilTag Physical Setup

You will need to print and attach specific AprilTag IDs to the tops of your physical pieces. 

**Black Pieces (IDs 1-6)**
* `ID 1`: All Black Pawns (x8)
* `ID 2`: Black Rooks (x2)
* `ID 3`: Black Knights (x2)
* `ID 4`: Black Bishops (x2)
* `ID 5`: Black Queen (x1)
* `ID 6`: Black King (x1)

**White Pieces (IDs 7-12)**
* `ID 7`: All White Pawns (x8)
* `ID 8`: White Rooks (x2)
* `ID 9`: White Knights (x2)
* `ID 10`: White Bishops (x2)
* `ID 11`: White Queen (x1)
* `ID 12`: White King (x1)

**The Calibration Tag (ID 13)**
* `ID 13`: Print this tag so the black square pattern covers a **1.5 x 1.5 square area** on your chessboard. 



## 🚀 How to Run and Calibrate

* **Connect Camera:**

Ensure your USB camera is plugged in. Check lines 36-37 in the script to ensure the camera name matches your OS (e.g., `'USB攝影機'`, `'USB Camera'`, or index `1`).

* **Start the Script:** 

Run `Chess_Controller.m`. A dual-panel GUI will open showing your live camera feed. 

* **Phase 1: 5-Second Calibration:** *

Place **Tag 13** exactly in the center of your board (intersecting squares d4, e4, d5, e5).
   
⚠️ **CRITICAL:** The bottom edge of Tag 13 *must* face the White pieces. If it is rotated, your tracking grid will be rotated!
   
Hold the tag still for 5 seconds. A yellow dashed preview grid will appear.

* **Phase 2: Play Chess!**

Once the title says "Board Perspective Locked!", you can remove Tag 13. 
    
The system will draw a permanent red tracking grid. As you move physical pieces, the AR text will follow them, and the digital twin on the right will update when a piece settles in a new square.


## 🎯 Expected Results (Based on Live Demo)

https://github.com/user-attachments/assets/3fa91c82-ea90-4897-9422-3cfd6c4d1cc0

When running the system successfully, you should observe the following sequence of events:

* **Awaiting Calibration:**

The GUI opens. The left panel shows the raw camera feed with a prompt to place Tag 13. The right panel displays the digital board in its starting position.

* **Perspective Lock (0:04 - 0:15):** 

Upon placing Tag 13 in the center, a 5-second countdown begins. A yellow dashed grid appears, instantly warping in 3D space to match the perspective of the physical board. Once locked, the grid turns red and Tag 13 can be removed.

* **Smooth AR Tracking (0:16 - 0:40):** 

As you pick up and move a physical piece (e.g., a Pawn to e4), the corresponding AR Unicode symbol (♟️) tracks the physical tag smoothly across the screen. 

* **Digital Twin Sync:** 

The moment a piece is set down on a new square, the Digital Twin on the right panel instantly updates to reflect the new board state.

* **Perspective Robustness (0:45+):** 

If the camera is bumped or moved significantly to a new angle, the red 3D grid remains perfectly "glued" to the physical squares on the table, proving the projective transformation matrix is functioning correctly.


## 🔧 Troubleshooting

### The Red Grid looks completely shattered or wildly stretched
You placed Tag 13 sideways during the 5-second calibration phase. The math assumes the camera is tilted sideways. Restart the script and ensure the bottom of Tag 13 faces the White pieces.

### Edge pieces are showing up in the wrong squares or disappeared
This is a **Parallax Error** caused by the camera angle and the height of your physical pieces. Ideally, the camera should place on top of the whole system.
* **Fix:** Open the script and find `parallaxCorrection = 0.15;` (around Line 11). Increase this to `0.20` or `0.25` to pull the mathematical tracking point closer to the base of the piece.


### The script crashes on startup saying "Webcam not found"
Run `webcamlist` in your MATLAB command window to see the exact string name your operating system is using for your camera. Update the `cam = webcam('YOUR_CAMERA_NAME');` line in the script with that exact text.
