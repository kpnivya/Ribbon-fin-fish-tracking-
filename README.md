# Ribbon fin tracking of a glassknife fish 

## Using code 
- Use convVideo2Frame.m to extract frames from a video 
	- Input needed - a folder pointing to a video
	- Output - gives out frames and stores it in desired location
- Use videoRefFrameShift.m to shift the head position to a fixed reference point (in the file it is the head position of the first frame), 
  to orient the the angle between head and body center and to draw lines at fixed pixel points (x- coordinates) on the given set of frames.
	- Input needed - a folder containing all the frames and DataSet containing the tracked head, bodycenter data points for the frames
				(Note that the dataset should correspond to the frames being used) 
	- Output - Modified frames with appropriate oreintation and lines drawn
	- Dependencies - rotateAround.m
- Use videoRefFrameShift.m to convert frames back to a video 
	- Input needed - A folder containing frames and desired location for the video
	- Output - Video generated from these frames
- Use Test_fin to check the graphs and wave features for the Dataset
	- Input needed - Datasets (One for the fin points and the other one for the body line)
	- Output - wave features and graphs 
	- Dependencies - makefinData_x.m, makefinData_y.m, makebodyData_x.m, makebodyData_x.m, SplineArg.m, GetAvg.m


NOTE:
- Recommended order of execution - convVideo2Frame.m - videoRefFrameShift.m - videoRefFrameShift.m - Test_fin
- Use videos from Videos folder 
- Use frames from EverythingFrames folder
