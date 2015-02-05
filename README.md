# Digital/Analog Sensors(Arduino) + Visualizations(Processing)
=====
This project explores the basic of Arduino and visualization of analog and digtal signals from various sensors.
The repository consists of 3 programs following. 

* Arduino Project : /arduino.ino
* Processing project 1 : /processing/visualization1_graph
* Processing project 2 : /processing/visualization2_representation

Environment
-----
	Build and Test on Windows 8/64bit

How to Run
-----
Once you have downloaded all project files, you can simply open files with their applications and run.

	Arduino 
	- open /arduino.ino/arduino.ino with Arduino and upload it to your Arduino Board.
	- tested with Uno R3

	Processing 1 
	- open /processing/visualization1_graph/visualization1_graph.pde with Processing and run.
	- make sure your Arduino is connected to your PC

	Processing 2 
	- open /processing/visualization2_representation/visualization2_representation.pde with Processing and run.
	- make sure your Arduino is connected to your PC


Data Format
-----
	The communication between Arduino and Processing is done by Serial communication. 

	The format is following
	
	 "CMSC838IA2  numberofAnalogData  numberofDigitalData  Analog0  Analog1  ...  Digital0  Digital1..." 
	 (double-spaced)

