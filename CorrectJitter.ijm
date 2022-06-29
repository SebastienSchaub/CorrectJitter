OrgID=getImageID();
TitleName=getTitle();
MyBitDepth=bitDepth();
k=selectionType();
if (k==-1) {
	run("Enhance Contrast", "saturated=0");
	setTool("rectangle");
	run("Z Project...", "projection=[Min Intensity]");
	TmpID=getImageID();
	waitForUser("Draw a ROI of the background\n Then [RETURN]");
	roiManager("Add");
	close();
}

else{
	roiManager("Add");	
}
nROI=roiManager("count");
run("Select None");
getRawStatistics(nPixels, mean, CMin, CMax, std, histogram);
run("Duplicate...", "duplicate");
rename(TitleName+"_Norm");
run("32-bit");
n=nSlices();
LBgd=newArray(n);
for (i=1;i<=n;i++){
	roiManager("Select", nROI-1);
	setSlice(i);
	getRawStatistics(nPixels, mean);
	LBgd[i-1]=mean;
	run("Select All");
	k=LBgd[0]/LBgd[i-1];
	run("Multiply...", "value="+k+" slice");
}
setSlice(1);
if (MyBitDepth==8){
	setMinAndMax(0, 255);
	run("8-bit");
}
if (MyBitDepth==16){
	setMinAndMax(0, 65535);
	run("16-bit");
}
setMinAndMax(CMin, CMax);
run("Select None");
//run("16-bit");

