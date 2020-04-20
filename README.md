# TF_hESC
This repository contains two scripts used for traction force analysis of human embryonic stem cell colonies. The first is a Fiji macro script for large batch analysis of traction force microscopy data ('TF_batch-analysis.imj'). The second is a Matlab script for displaying the resulting traction force microscopy data ('TF_display.m'). 

Requirements:
--------------
1) Download/install Fiji (ImageJ 1.52a or later runnning on Java 1.8.0_172 or later): https://fiji.sc/ 
2) Install PIV and FTTC plugins:
      - Download PIV.jar and FTTC.jar files here: https://github.com/qztseng/imagej_plugins/tree/master/current  
      - Detailed descriptions here: https://sites.google.com/site/qingzongtseng/tfm
      - Place PIV.jar and FTTC.jar files in your FIJI/ImageJ 'plugins' folder
3) Install Matlab R2018b or later: https://www.mathworks.com/products/matlab.html

Usage:
---------
Prior to using these scripts you will need the raw data. This consists of paired images of fluorescent microspheres within hydrogels with cells adhered to the surface ("stressed images") and of the fluorescent microspheres from the same ROIs folllowing lysing of these cells ("unstressed images"), as well as brightfield images of the cells prior to lysing. Prior to using the Fiji "TF_batch-analysis" macro, the stressed and unstressed images from each ROI should be combined into stacks with the stressed images first. If ultimately generating average plots, the user should have calculated alignment shifts and crop values based on BF images such that all colonies contributing to the average will overlap, these values should be saved for input while running the script. The ultimate FTTC.txt files generated from the Fiji macro will be the inputs for the Matlab "TF_display" script. 

Sample Workflow:
------------------
All files referenced in this sample workflow are contained in the 'sample files' subfolder of this repository

1) Download 'pm001_stressed.tif' and 'pm001_unstressed.tif'. Using Fiji, create a stack consisting of 'pm001_stressed.tif' followed by 'pm001_unstressed.tif'. Confirm that the resulting stack matches 'pm001.tif'. 
      - 'pm001_brightfield.tif' is a brightfield image of an hESC colony for which we will measure traction forces
      - 'pm001_stressed.tif' is an image of "stressed" microspheres 
      - 'pm001_unstressed.tif' is an image of the same microspheres afer the cells have been lysed, "unstressed"
      - 'pm001_lysed.tif' is a brightfield image demonstrating the cells were successfully lysed
      - 'pm001.tif' is the resulting stressed-unstressed image stack created from 'pm001_stressed.tif' and 'pm001_unstressed.tif'

      - NOTE: The user would manually create stacks such as 'pm001.tif' for all the raw data to be analyzed. These stacks should all be         placed in the same folder prior to running 'TF_batch-analysis.imj'. For this sample workflow I have uploaded five sample stacks         ('pm001.tif' - 'pm005.tif') that will be used in the subsequent steps. 
      - NOTE: If ultimately planning to generate average plots of the traction force data, the user must also calculate translation,            crop, and rotate values prior to running 'TF_batch-analysis.imj'. In this example, this was done by first determining the angle           needed to rotate the mouth of pacman colonies to the right side of the image for each stack to be analyzed. Then, we chose to             crop the images to 1800x1800 pixels, and found the x and y values (corresponding to the top-left corner of the 1800x1800                  selction area) that were needed to place the center of the pacman colony at the center of the new cropped image. 'crop-and-               rotate_values.xlsx' containes the values to be entered as 'TF_batch-analysis.imj' is run on the sample data. 
2) Download 'pm001.tif' - 'pm005.tif' and place these five files in a folder. Create two separate folders: i) for saving processed stacks, and ii) for saving the PIV and FTTC data.
3) Download 'TF_batch-analysis.imj'. 
4) Run 'TF_batch-analysis.imj' in FIJI. 
      - Select the folder containing 'pm001.tif' - 'pm005.tif' when prompted to "choose folder with stacks to process" 
      - Select the folder where you want to save processed stacks when prompted to "choose folder you want to save processed stacks"
      - Enter a base file name that the macro will use when saving the processed stacks
      - The macro will now iterate through 'pm001.tif' - 'pm005.tif' and align the stacked images using the 'Linear Stack Alignment with SIFT' plugin that is included in FIJI
      - After alignment of each image, the macro will prompt the user to enter the translate/crop/rotate values. For the sample data set, enter the values as listed in 'crop-and-rotate_values.xlsx'
      - The macro will crop, rotate, and translate (translation not performed in this example) the stack and then reverse the stack such that the "unstressed" bead image will be the first image in the stack
      - The macro will then prompt you to select the folder where you want to save the PIV and FTTC data. The macro will then automatically calculate PIV (bead displacement) vector plots for the data
      - The macro will then prompt you to select the magnification of images, the Young's modulus of the hydrogel, and the regularization factor - all needed to convert the PIV data to FTTC data (traction stresses). For this sample data set, the default values were used for each parameter. 
      - The macro will then automatically calculate the FTTC data from the PIV data
      - Confirm that the resulting stacks match 'processed_pm001.tif' - 'processed_pm005.tif'
      - Confirm that the resutling PIV data match 'cPIV_processed_pm001.txt' - 'cPIV_processed_pm005.txt'
      - Confirm that the resulting FTTC data match 'Traction_cPIV_processed_pm001.txt' - 'Traction_cPIV_processed_pm005.txt'
5) Download 'TF_display.m'
6) Ensure 'TF_display.m' and 
   
      
    


Contact and Help:
------------------
If you need help using the code, please contact Jonathon Muncie: muncie@berkeley.edu

Copyright and License Information:
-------------------------------------
Copyright (C) 2020 University of California, San Francisco (UCSF) Jonathon Muncie and Josette Northcott

Authors: Jonathon Muncie and Josette Northcott

This program is licensed with GNU General Public License v3.0. Please see the attached license.txt file for details.
