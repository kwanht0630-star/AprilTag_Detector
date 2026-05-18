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

## 🖼️ The Expected Output Window

When you run the script, a single MATLAB figure window titled "Live AprilTag Scanner" will open. Here is exactly what you will see:

**The Background:**

https://github.com/user-attachments/assets/4ed5051c-0b01-4219-83f0-1b9417867718

  A live, continuous, full-color video feed from your default computer webcam.

**The Top Banner (Status Bar):**

  Hovering at the top center, there will be a dark grey text box with bright green text. It updates in real-time.

  If no tag is in the camera view: The box turns red and says: Scanning for tags...

  When you hold up a tag: The box turns green and says: Success! Found 1 Tag(s)

**The Bounding Box (Color Cycling):**

  As soon as a tag enters the frame, a thick, brightly colored box will snap to the borders of the tag and follow it as you move it around. If you hold up multiple tags, each one gets a different color (Orange, Magenta, Yellow, Blue, Green, or White).

**The Floating Label (The "Stroke" Hack):**

  Hovering just above the center of the bounding box will be a large, bold label. Because of your 8-way offset hack, the text will have a thick black outline around it, making it perfectly readable even if the background behind it is bright or messy.

**Standard Tag: Tag [ID]**

  Duplicate Tags (e.g., holding up two tags with ID "5"): Tag 5 (A) and Tag 5 (B)

**The Bottom Banner (Summary Bar):**

  Hovering at the bottom center, there is a light grey text box with dark blue text. It lists the raw IDs of everything currently in frame:

**Detected IDs: [ID Number]**
