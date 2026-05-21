## AprilTag Detector

Welcome to the **AprilTag Detector** repository! This is an internship project focused on the robust detection and localization of AprilTags using **MATLAB**.

## 📌 Overview

This MATLAB script is designed to efficiently recognize AprilTags and process their positions from images or video streams. It is specifically built to handle a customized board configuration: a grid layout where the central tag (**Tag 13**) is scaled to a **2x2** size, while all other surrounding tags maintain a standard **1x1** size. 

## ✨ Features

* **MATLAB Implementation:**

  Fully scripted in MATLAB for easy integration with other engineering, simulation, and analysis workflows.
  
* **Custom Grid Logic:**
  
  Native handling for unique board layouts, accurately differentiating the 2x2 central Tag 13 from the standard 1x1 tags.
  
* **Accurate Detection:**
  
  Reliable discovery and localization of AprilTag fiducial markers.

## 🛠️ Prerequisites

To run this script, you will need:

* **MATLAB** (R2021a or newer recommended)

* **Computer Vision Toolbox** (Typically required for image processing and camera calibration features in MATLAB)

## 💻 Usage

To run the detector, execute the main script within the MATLAB environment:

Ensure your camera is connected (if using a live feed) or verify that your test images are placed in the correct directory.

Run the script via the MATLAB Command Window or by clicking "Run" in the editor:

```
% Example command to run the script
main_detector_script
```

(Note: Be sure to update `main_detector_script` above to the actual name of your `.m` file!)

## 🤝 Acknowledgements

Developed as an internship project.

Based on the AprilTag robotics visual fiducial system.
