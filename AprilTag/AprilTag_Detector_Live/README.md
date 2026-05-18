# MATLAB Live AprilTag Scanner 📷

A high-performance, real-time AprilTag detection script for MATLAB. This tool connects to your computer's webcam to continuously scan for, identify, and track AprilTags in a live video feed.

This project is specifically optimized for smooth UI performance and high readability, featuring dynamic colored bounding boxes and custom text-stroking techniques to ensure labels pop against cluttered backgrounds.

## ✨ Key Features

* **Real-Time Video Processing:** Leverages `set(hImg, 'CData', img)` instead of redrawing figures, ensuring high frame rates and efficient memory management during live loops.
* **Smart Duplicate Handling:** Automatically detects if multiple tags share the same ID and appends alphabetical suffixes to differentiate them (e.g., `Tag 1 (A)`, `Tag 1 (B)`).
* **High-Visibility Text Outlines:** Implements a custom 8-way offset rendering technique to create a black "stroke" outline around colored text, ensuring labels are completely readable regardless of the background lighting or colors.
* **Dynamic UI Overlays:** Features clean, color-coded status banners at the top and bottom of the video feed to display current scanning states and a summary of detected IDs.

## 🛠 Prerequisites

To run this script, you will need the following installed in your MATLAB environment:
* **MATLAB** (R2020b or newer recommended)
* **MATLAB Support Package for USB Webcams:** Required to use the `webcam()` function. (Install via the Add-On Explorer).
* **Computer Vision Toolbox:** Required for the `readAprilTag` function.
* **Image Processing Toolbox:** Required for `im2gray` and `imadjust` functions.

## 🚀 Usage

1. Clone or download this repository to your local machine.
2. Ensure your webcam is plugged in and recognized by your computer.
3. Open MATLAB and run the script.
4. A new window will pop up displaying your live webcam feed. 
5. Hold any **tag36h11** AprilTag up to the camera. The script will automatically draw a bounding box and label it.
6. **To Stop:** Simply close the video window. The script is designed to catch the window closure, break the loop, and safely release the camera.

## ⚙️ Configuration & Tweaks

**Changing the Tag Family:**
By default, the scanner looks for the standard `tag36h11` family. If you need to scan a different family (like `tag16h5`), update the string in the detection function:
```matlab
[id, loc] = readAprilTag(adjImg, 'tag16h5');
```
**Customizing Colors:**
The bounding boxes and text labels cycle through a predefined set of HEX colors. You can easily add or modify these colors in the `colors` array near the top of the script:
```
colors = {'#D95319', '#FF33F6', '#EDB120', '#4DBEEE', '#77AC30', '#FFFFFF'};
```
