# TF_hESC
This repository contains scripts used for traction force analysis of human embryonic stem cell colonies. 
- 'TF_batch-analysis.ijm' is a Fiji macro script for large batch analysis of traction force microscopy data
- 'TF_display.m' is a Matlab script for displaying the resulting traction force microscopy data 
- 'TF_98percentile_value.m' is a Matlab script that was used to determine the 98th percentile traction stress value for multiple traction stress maps

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
Prior to using these scripts you will need the raw data. This consists of paired images of fluorescent microspheres within hydrogels with cells adhered to the surface ("stressed images") and of the fluorescent microspheres from the same ROIs folllowing lysing of these cells ("unstressed images"), as well as brightfield images of the cells prior to lysing. Prior to using the Fiji 'TF_batch-analysis.ijm' macro, the stressed and unstressed images from each ROI should be combined into stacks with the stressed images first. If ultimately generating average plots, the user should have calculated alignment shifts and crop values based on BF images such that all colonies contributing to the average will overlap, these values should be saved for input while running the script. The ultimate FTTC.txt files generated from the Fiji macro will be the inputs for the Matlab 'TF_display.m' and 'TF_98percentile_value.m' scripts. 

Sample Workflow:
------------------
All files referenced in this sample workflow are contained in the 'sample files' subfolder of this repository. Steps 1-4 provide an example for working with 'TF_batch-analysis.ijm'. Steps 5-8 provide an example for working with 'TF_display.m'. Steps 9-12 provide an example for working with 'TF_98percentile_value.m'.

1) Download 'pm001_stressed.tif' and 'pm001_unstressed.tif'. Using Fiji, create a stack consisting of 'pm001_stressed.tif' followed by 'pm001_unstressed.tif'. Confirm that the resulting stack matches 'pm001.tif'. 
      - 'pm001_brightfield.tif' is a brightfield image of an hESC colony for which we will measure traction forces
      - 'pm001_stressed.tif' is an image of "stressed" microspheres 
      - 'pm001_unstressed.tif' is an image of the same microspheres afer the cells have been lysed, "unstressed"
      - 'pm001_lysed.tif' is a brightfield image demonstrating the cells were successfully lysed
      - 'pm001.tif' is the resulting stressed-unstressed image stack created from 'pm001_stressed.tif' and 'pm001_unstressed.tif'

      - NOTE: The user would manually create stacks such as 'pm001.tif' for all the raw data to be analyzed. These stacks should all be         placed in the same folder prior to running 'TF_batch-analysis.ijm'. For this sample workflow I have uploaded five sample stacks         ('pm001.tif' - 'pm005.tif') that will be used in the subsequent steps. 
      - NOTE: If ultimately planning to generate average plots of the traction force data, the user must also calculate translation,            crop, and rotate values prior to running 'TF_batch-analysis.ijm'. In this example, this was done by first determining the angle           needed to rotate the mouth of pacman colonies to the right side of the image for each stack to be analyzed. Then, we chose to             crop the images to 1800x1800 pixels, and found the x and y values (corresponding to the top-left corner of the 1800x1800                  selction area) that were needed to place the center of the pacman colony at the center of the new cropped image. 'crop-and-               rotate_values.xlsx' containes the values to be entered as 'TF_batch-analysis.ijm' is run on the sample data. 
2) Download 'pm001.tif' - 'pm005.tif' and place these five files in a folder. Create two additional folders: i) for saving processed stacks, and ii) for saving the PIV and FTTC data.
3) Download 'TF_batch-analysis.ijm'. 
4) Run 'TF_batch-analysis.ijm' in FIJI. 
      - Select the folder containing 'pm001.tif' - 'pm005.tif' when prompted to "choose folder with stacks to process" 
      - Select the folder where you want to save processed stacks when prompted to "choose folder you want to save processed stacks"
      - Enter a base file name that the macro will use when saving the processed stacks
      - The macro will now iterate through 'pm001.tif' - 'pm005.tif' and align the stacked images using the 'Linear Stack Alignment with SIFT' plugin that is included in FIJI
      - After alignment of each image, the macro will prompt the user to enter the translate/crop/rotate values. For the sample data set, enter the values as listed in 'crop-and-rotate_values.xlsx'
      - The macro will crop, rotate, and translate (translation not performed in this example) the stack and then reverse the stack such that the "unstressed" bead image will be the first image in the stack. This process will be repeated for each stack input
      - The macro will then prompt you to select the folder where you want to save the PIV and FTTC data 
      - Next, the macro will automatically calculate PIV (bead displacement) vector plots for each stack input
      - The macro will then prompt you to select the magnification of the images, the Young's modulus of the hydrogel, and the regularization factor - all needed to convert the PIV data to FTTC data (traction stresses). For this sample data set, the default values were used for each parameter. 
      - Next, the macro will automatically calculate the FTTC data from the PIV data
      - Confirm that the resulting stacks match 'processed_pm001.tif' - 'processed_pm005.tif'
      - Confirm that the resutling PIV data match 'cPIV_processed_pm001.txt' - 'cPIV_processed_pm005.txt'
      - Confirm that the resulting FTTC data match 'Traction_cPIV_processed_pm001.txt' - 'Traction_cPIV_processed_pm005.txt'
      
      - NOTE: The FTTC data contains five columns of information. Columns 1 and 2 are the X and Y coordinates of each data point in the traction force plot. Columns 3 and 4 are the X and Y components of the traction vector at each coordinate. Column 5 is the magnitude (sqrt(x^2+y^2)) of the traction vector at each coordinate. If attempting to generate average plots of traction force data, all plots must have the same dimensions. The user can then average the X and Y traction components at each coordinate across all the traction maps to be averaged.
      - For example: to compute the X vector components of the average traction plot, copy Column 3 from each of the individual plots you want to average into the first tab of a new spreadsheet. In this spreadsheet, each column represents the X vector components from an individual plot and each row represents the values at a single coordinate across all plots. Thus, average across each row to get the average X vector component for each coordinate. Repeat this process in a second tab to calculate the average Y vector component at each coordinate. Then, in a third tab, create the average vector plot. Columns 1 and 2 will be the X and Y coordinates that are the same in every indidividual traction map, and can be copied and pasted into this tab. Columns 3 and 4 will be the average X and Y vector components you calculated. Column 5 will be the magnitude of the average traction vectors - for each row compute column5 = sqrt(column3^2+column4^2). Save this third tab as a .txt file and plot it as you would any of the individual traction force plots. 
      - An example of this average traction force spreadsheet containing data from 20 individual plots, each with XxY = 110x110 is given in 'average_tractions.xlsx'
5) Download 'TF_display.m'. Duplicate 'Traction_cPIV_processed_pm001.txt', rename the duplicated file 'FTTC.txt', and save it in the same folder as 'TF_display.m'. 
6) Open 'TF_display.m' in Matlab. For this example, change the "X" and "Y" values in line 15 to "110" and "110". 
7) Run the script. The plot should display in a new Matlab window. 
8) Confirm that the resulting figure matches sample file 'pm001_FTTC_plot.tif' 
9) Download 'TF_98percentile_value.m'. Duplicate the five files: 'Traction_cPIV_processed_pm001.txt' - 'Traction_cPIV_processed_pm005.txt' into a new folder and save 'TF_98percentile_value.m' in this folder.
10) Open 'TF_98percentile_value.m' in Matlab. Change the X/Y values of "126" and "126" in line 34 to "110" and "110". For this example we will not be masking, so use the "%" character to commment-out line 36, change the variable to be plotted in line 38 from "masked" to "raw", and the variable for which the 98th percentile value will be determined in line 40 from "masked" to "raw". 
11) Run the script. The 'Traction_cPIV_processed_pm001-5.txt' data will be plotted as matlab figs and saved. The variable "output" will be created and each row (1-5) will contain a value that corresponds to the 98th percentile traction stress value (in Pascals) for the corresponding input traction file (001-005). 
12) Confirm that the values in output are: [52.3; 47.4; 34.7; 47.5; 38.5]

Contact and Help:
------------------
If you need help using the code, please contact Jonathon Muncie: muncie@berkeley.edu

Copyright and License Information:
-------------------------------------
Copyright (C) 2020 University of California, San Francisco (UCSF) Jonathon Muncie and Josette Northcott

Authors: Jonathon Muncie and Josette Northcott

This program is licensed with GNU General Public License v3.0. Please see the attached license.txt file for details.
