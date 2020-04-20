//This script is used to display plots of magnitude values for traction force microscopy data in Matlab 
//Inputs for this script are FTTC.txt files generated by the FTTC plugin for Fiji (see "TF_batch-analysis" script)

//open and extract values from the FTTC.txt file you are trying to display. Make sure the file is in your Matlab working directory
FID = fopen("FTTC.txt");
map = fscanf(FID, "%f", [5 inf]);

//extract the magnitude values from the FTTC data. Note: the original FTTC.txt file is a table containing five columns: the first two columns are the x and y pixel positions of the data, the third and fourth columns are the x and y components of the traction force vector at that position, and the fifth column is the magnitude of the traction force vector at that position
mag = map (5,:);

//turn the vector of magnitude values into an array 
//use the original FTTC.txt file to determine the number of X and Y positions, which will dictate the dimensions of the array
array = reshape(mag, [X Y]); 

//transpose the array to get the correct orientation relative to the original data 
plot = array.';

//display using imagesc. Use Matlab help to adjust colormap, scaling, etc.
imagesc(plot);