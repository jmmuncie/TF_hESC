# TF_hESC
This repository contains two scripts used for traction force analysis of human embryonic stem cell colonies. The first is a Fiji macro script for large batch analysis of traction force microscopy data ("TF_batch-analysis"). The second is a Matlab script for displaying the resulting traction force microscopy data ("TF_display"). 

Requirements:
--------------
1) Install Fiji: https://fiji.sc/ 
2) Install PIV and FTTC plugins: https://sites.google.com/site/qingzongtseng/tfm
3) Install Matlab R2018b or more recent: https://www.mathworks.com/products/matlab.html

Usage:
---------
Prior to using these scripts you will need the raw data. This consists of paired images of fluorescent microspheres within hydrogels with cells adhered to the surface ("stressed images") and of the fluorescent microspheres from the same ROIs folllowing lysing of these cells ("unstressed images"), as well as brightfield images of the cells prior to lysing. Prior to using the Fiji "TF_batch-analysis" macro, the stressed and unstressed images from each ROI should be combined into stacks with the stressed images first. If ultimately generating average plots, the user should have calculated alignment shifts and crop values based on BF images such that all colonies contributing to the average will overlap, these values should be saved for input while running the script. The ultimate FTTC.txt files generated from the Fiji macro will be the inputs for the Matlab "TF_display" script. 

Contact and Help:
------------------
If you need help using the code, please contact Jonathon Muncie: muncie@berkeley.edu

Copyright and License Information:
-------------------------------------
Copyright (C) 2020 University of California, San Francisco (UCSF) Jonathon Muncie and Josette Northcott

Authors: Jonathon Muncie and Josette Northcott

This program is licensed with GNU General Public License v3.0. Please see the attached license.txt file for details.
