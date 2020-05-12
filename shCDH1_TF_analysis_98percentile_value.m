%This script is used to open multiple TF data plots and determine the 95th
%percentile value for each map

%This was specifically used in JMM et al. 2020 to compare the effect of
%shCDH1 KD on traction forces. We quantify the 98th percentile value in
%control and KD colonies to measure how reduction of CDH1 abrogates the
%ability to generate high traction stresses. The output is a vector where
%each value corresponds to the Pa measurement of the 98th percentile for
%the corresponding map

%count and import files
files = dir('*.txt');
numfiles = length(files);
output = zeros(numfiles,1);
%need to have inferno colormap function in matlab path
%https://www.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps
%Ander Biguri (2020). Perceptually uniform colormaps (https://www.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps), MATLAB Central File Exchange. Retrieved April 24, 2020.
inferno = inferno();

%If masking, need to already have a varialbe 'mask' defined so that the text file
%doesn't have to be in the same folder. See the next two lines of annotated
%code for how to do this for a file named 'Mask_sq_border3.txt' that is 126x126
%pixels

%this mask removes values at a depth of 3 pixels from the edge of the map,
%corresponding to artifacts that typically occur at the edges 
%FID = fopen("Mask_sq_border3.txt");
%mask = fscanf(FID,"%f", [126 126]);

for k = 1:numfiles
    FID = fopen(files(k).name);
    map = fscanf(FID, "%f", [5 inf]);
    mag = map (5, :);
    plot = reshape(mag, [126 126]);
    raw = plot.';
    masked = raw.*mask;
    %imshow(masked, 'DisplayRange', [0 50], 'Colormap', inferno, 'InitialMagnification', 'fit');
    %saveas(gcf,['TFplot_shCDH1_kd_n' num2str(k)], 'fig');
    output(k,1) = prctile(masked,98,'all');
end
    


