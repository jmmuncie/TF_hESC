//this macro is used to process large batches of traction force microscopy data for patterned colonies of hESCs
//this macro should be run on Fiji (https://fiji.sc/) and utilizes PIV and FTTC plugins available here: (https://sites.google.com/site/qingzongtseng/tfm)

//should start with a folder of stacked bead images, with "stressed" (images taken with cells) beads first
//if ultimately generating average plots, should have calculated alignment shifts based on BF images such that all colonies contributing to the average will overlap and saved translation values to enter as macro runs

run("Close All");
dirIn1 = getDirectory("Choose folder with stacks to process");
dirOut1 = getDirectory("Choose the folder you want to save the processed stacks");
list1 = getFileList(dirIn1);
preface = getString("Base file name for saving processed stacks", "processed_");
for (i=0; i<(list1.length); i = i+1){
	open(dirIn1+list1[i]);
	run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
	Dialog.create("Enter x and y values to translate");
	Dialog.addNumber("Translate X",0);
	Dialog.addNumber("Translate Y",0);
	Dialog.addNumber("Image number",i+1);
	Dialog.addNumber("Crop width", 1800);
	Dialog.addNumber("Crop height", 1800);
	Dialog.addNumber("Crop x coord", 0);
	Dialog.addNumber("Crop y coord", 0);
	Dialog.addNumber("Rotate", 0);
	Dialog.show();
	transx = Dialog.getNumber();
	transy = Dialog.getNumber();
	image = Dialog.getNumber();
	cropwidth = Dialog.getNumber();
	cropheight = Dialog.getNumber();
	cropx = Dialog.getNumber();
	cropy = Dialog.getNumber();
	rotate = Dialog.getNumber();
	run("Translate...", "x=transx y=transy interpolation=None stack");
	run("Reverse");
	run("Rotate... ", "angle=rotate grid=1 interpolation=Bilinear stack");
	run("Specify...", "width=cropwidth height=cropheight x=cropx y=cropy slice=1");
	run("Crop");
	saveAs("Tiff", dirOut1 + preface + image);
	run("Close All");}

//images have now been registered, translated so they are all aligned, and unstressed bead image is first - ready for PIV

dirOut2 = getDirectory("Choose folder where you want to save PIV outputs - FTTC outputs will also be saved here");
list2 = getFileList(dirOut1);
for (i=0; i<(list2.length); i = i+1){
	open(dirOut1+list2[i]);
	FileName = getTitle();
	PivName=replace(FileName,".tif","");
	run("iterative PIV(Cross-correlation)...", "piv1=128 piv2=64 piv3=32 what=[Accept this PIV and output] noise=0.20 threshold=5 c1=3 c2=1 save=["+dirOut2+"cPIV_"+PivName+".txt]");
	window = FileName+"_PIV3";
	selectWindow(window);
	saveAs("Tiff", dirOut2 + "PIV-map_"+PivName);
	selectWindow("Scale Graph");
	saveAs("Tiff", dirOut2 + "PIV-scale_"+PivName);
	run("Close All");}

list3 = getFileList(dirOut2);

//PIV complete, ready for FTTC

Dialog.create("FTTC");
	Dialog.addChoice("Magnification:", newArray("10X objective + 1.0X relay", "10X objective + 1.5X relay", "20X objective + 1.0X relay", "20X objective + 1.5X relay"));
	Dialog.addNumber("Young's modulus (Pascals):", 2700);
	Dialog.addNumber("Regularization factor:", 0.000000010, 9, 11, "(defaut is 0.000000000)");
	Dialog.show();
	mag = Dialog.getChoice();
	if (mag=="10X objective + 1.0X relay") umpx=0.645;
	if (mag=="10X objective + 1.5X relay") umpx=0.430;
	if (mag=="20X objective + 1.0X relay") umpx=0.322;
	if (mag=="20X objective + 1.5X relay") umpx=0.215;
	gelPa = Dialog.getNumber();
	reg = Dialog.getNumber();;
for (i=0; i<(list3.length/3); i = i+1){
	FileName2 = list3[i];
	run("FTTC ", "pixel=["+umpx+"] poisson=0.5 young's=["+gelPa+"] regularization=["+reg+"] select=["+dirOut2+list3[i]+"]");
	run("plot FTTC", "select=["+dirOut2+"Traction_"+list3[i]+"] autoscale vector_scale=1 max=500 plot_width=0 plot_height=0 show lut=S_Pet");
	selectWindow("Vector plot_Traction_"+FileName2);
	newname = replace(replace(FileName2,"cPIV","Traction-map"),".txt","");
	saveAs("Tiff", dirOut2+newname);	
	selectWindow("Scale Graph");
	scalename = replace(newname,"Traction-map","Traction-scale");
	saveAs("Tiff", dirOut2+scalename);
	run("Close All");}
