This matlab code is for generating new INI parameter including:

	- number of AP
	- X and Y cood of each AP, ZC and Switch

How to:

1. Save AP parameter into Hefei.xls with same format.

	B column: X cood of AP
	C column: Y cood of AP
	D column: name of AP (not in use)
	F column: index of ZC 
	G column: enter and exit of a zone (1 means enter, 2 means exit)

2. Define mode of AP distribution you want to get at oddMode and evenMode;

3. run CBTCv3Hefei.m in MATLAB, the result will show in Workspace monitor

4. manually copy the generated parameter into OMNeT ini file.
