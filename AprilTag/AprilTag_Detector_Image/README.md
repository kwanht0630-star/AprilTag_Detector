# MATLAB AprilTag Image Detector

A straightforward MATLAB script designed to detect and visualize AprilTags, specifically optimized for custom 3D-printed tags with cardboard backing. 

Because non-traditional materials (like black plastic and brown cardboard) lack the stark contrast of standard black-and-white printed tags, this project implements image pre-processing techniques to ensure reliable detection.

## 🚀 Features

* **Interactive File Selection:** Uses a native UI dialog box so users can easily browse and select their target images without hardcoding file paths.
* **Low-Contrast Optimization:** Automatically converts images to grayscale and utilizes `imadjust` to stretch the contrast, making it highly effective for custom, low-contrast materials.
* **Visual Feedback:** Generates a clean, annotated popup window displaying:
    * A thick green bounding box around all detected tags.
    * Dynamic text overlays indicating success/failure states.
    * A list of all detected Tag IDs directly on the image.
* **Multi-Tag Support:** Capable of detecting and highlighting multiple tags within a single image.

## 🛠 Prerequisites

To run this script, you will need:
* **MATLAB:** (R2020b or newer is recommended for the latest image processing functions).
* **Computer Vision Toolbox:** Required for the `readAprilTag` function.
* **Image Processing Toolbox:** Required for the `im2gray` and `imadjust` functions.

## 📦 Usage

1. Clone or download this repository to your local machine.
2. Open MATLAB and navigate to the folder containing the script.
3. Run the script in the MATLAB command window or editor.
4. A file dialog will prompt you to select an image (`.jpg`, `.png`, or `.heic`).
5. The script will analyze the image and generate a new figure window with the detection results.

## 📸 Sample Image

The repository includes a sample image (`AprilTag_Sample.jpg`) demonstrating a custom 3D-printed tag over a cardboard box. You can use this image to test the script's contrast-adjustment capabilities immediately.

## ⚙️ Configuration

By default, the script looks for the standard **tag36h11** family. If you are using a different family of AprilTags, you can easily change this on line 26 of the script:

```matlab
% Change 'tag36h11' to your specific tag family if needed
tagFamily = 'tag36h11';
```

Note: If the script fails to detect your tag, ensure your workspace has adequate lighting or try adjusting the parameters within the `imadjust` function to further manipulate the contrast thresholds.
