1 REM  Bubble Display Toolbox for RC2014's bubble display module and BASIC
2 REM  S Dixon https://peacockmedia.software
3 REM
4 REM  we have the concept of a screen buffer [buf()] containing the raw data
5 REM
6 REM  routines are provided for converting an ascii code to segment data (1500)
7 REM  and for copying a string into the buffer, handling the ascii conversion (1400)
8 REM  a simple  example is below at lines 50 & 60
9 REM
10 REM line 100 calls flush (GOSUB 1100) which sends the buffer to the display 
11 REM as efficiently as possible in a loop
12 REM
13 REM lower-level usage: 	DIGIT=1 : C$="H" : GOSUB 1030  
14 REM
15 REM or more efficient: 	OUT DSP,1 : OUT SEGDP,255  
16 REM				(digit select port - raw port number; 1,2,4,8,16 etc)
17 REM 			 	(segment data port - raw segment data) 
18 REM 
19 REM NB initialise (GOSUB 1700) must be called before any of the above

20 REM ==================================================================

30 GOSUB 1700 : REM some initialisation


50 M$ = "hello w"  : REM the W looks like a smiley face
55 REM not enough characters for "hello world" without scrolling. 
56 REM See the asm examples for that.
60 GOSUB 1400 : REM copy string into buffer, converting ascii 


99 REM main loop - simply loops calling flush.
100 FOR ML=1 TO 500 : GOSUB 1100 : NEXT ML


999 END

1000 REM selectDigit - 0 to 7
1005 RAWD=pow(DIGIT)
1010 OUT DSP,RAWD
1020 RETURN

1030 REM sendChr - set C$ and DIGIT
1040 GOSUB 1000
1050 GOSUB 1500	
1060 REM sendData
1070 OUT SEGDP,C 
1080 RETURN

1100 REM flush
1105 REM optimised. 
1110 OUT 2,0:OUT 0,1:OUT 2,BUF(0):GOSUB 1360
1111 OUT 2,0:OUT 0,2:OUT 2,BUF(1):GOSUB 1360
1112 OUT 2,0:OUT 0,4:OUT 2,BUF(2):GOSUB 1360
1113 OUT 2,0:OUT 0,8:OUT 2,BUF(3):GOSUB 1360
1114 OUT 2,0:OUT 0,16:OUT 2,BUF(4):GOSUB 1360
1115 OUT 2,0:OUT 0,32:OUT 2,BUF(5):GOSUB 1360
1116 OUT 2,0:OUT 0,64:OUT 2,BUF(6):GOSUB 1360
1117 OUT 2,0:OUT 0,128:OUT 2,BUF(7)

1120 RETURN

1200 REM clear buffer
1210 FOR I=0TO7                                                         
1220 BUF(I)=0  
1230 NEXT I 
1240 RETURN

1250 REM set up power
1260 DIM POW(8)
1270 FOR I=0TO7
1280 POW(I)=2^I
1290 NEXT I
1295 RETURN

1300 REM set up 'font'
1310 DIM F(42)
1320 FOR I=0 TO 40
1330 READ D : F(I)=D
1340 NEXT I
1350 RETURN

1360 REM 'on time' pause
1370 FOR P=0TO5:NEXTP
1380 RETURN

1400 REM message to buffer
1410 FOR I=1 TO 8
1415 C$=" "
1420 IF I<=LEN(M$) THEN C$=MID$(M$,I,1)
1425 GOSUB 1500 
1430 BUF(I-1)=C
1440 NEXT I
1450 RETURN

1500 REM ASCII to segment data
1510 C=ASC(C$)
1530 IF C=45 THEN C=C+78
1540 IF C=63 THEN C=C+61
1550 IF C=39 THEN C=C+86
1560 IF C=44 THEN C=C+2
1570 IF C>96 THEN C=C-32
1580 IF C>64 THEN C=C-7
1590 IF C=46 THEN C=C+1
1600 IF C=32 THEN C=C+14
1610 C=C-46
1620 IF C>40 THEN C=0
1630 IF C<0 THEN C=0
1640 C=F(C)
1650 RETURN

1700 REM initialise
1710 DIM BUF(8)
1720 DSP=0 : SEGDP=2
1730 GOSUB 1250 : REM set up power array
1740 GOSUB 1300 : REM set up 'font'
1750 GOSUB 1200 : REM  clearBuffer
1760 RETURN


9990 DATA 0				: REM space
9991 DATA 128				: REM dp
9992 DATA 63,6,91,79,102 		: REM digits, 0 - 9
9993 DATA 109,125,7,127,111
9994 DATA 95,124,57,94,121 	: REM a/A - z/Z
9995 DATA 113,111,116,48,30 	: REM -j
9996 DATA 117,56,21,55,63 		: REM -o
9997 DATA 115,103,49,109,120	: REM -t
9998 DATA 62,62,42,118,110,91 	: REM -z
9999 DATA 64,83,2 			: REM a few symbols: - ? '


