%This script is used to open multiple TF data plots and determine number of
%pixels in the plot greater than a certain value

%This was specifically used in JMM et al. 2020 to compare the effect of
%shCDH1 KD on traction forces. Using the avg map of TF for shCDH1 control,
%we determined the 95 percentile of TF values corresponding to colony area = 21 Pa, and confirmed that
%thresholding at this value appropriately masks the corners. Thus, we used
%this program to iterate through all control and KD maps and determine the
%number of pixels, later converted to area, that demonstrate greater than
%21 Pa stresses

%count and import files
files = dir('*.txt');
numfiles = length(files);
output = zeros(numfiles,1);

%If masking, need to already have a varialbe 'mask' defined so that the text file
%doesn't have to be in the same folder. See the next two lines of annotated
%code for how to do this for a file named 'mask_sq.txt' that is 126x126
%pixels

%FID = fopen("Mask_sq_border3.txt");
%mask = fscanf(FID,"%f", [126 126]);

for k = 1:numfiles
    FID = fopen(files(k).name);
    map = fscanf(FID, "%f", [5 inf]);
    mag = map (5, :);
    plot = reshape(mag, [126 126]);
    raw = plot.';
    masked = raw.*mask;
    imagesc(masked);
    saveas(gcf,['TFplot_shCDH1_kd_n' num2str(k)], 'fig');
    count = sum(sum(masked>21));
    output(k,1) = count;
end
    


