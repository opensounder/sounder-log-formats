# Format 3/SL3 Block/Frame
There might be variations to this depending on the header version.
Observe that this is an unofficial and not 100% tested.
Things will be incorrect!

## Notes
THE DOCUMENTATION IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

## Block/Frame header
SL3 is very much like SL2 but
SL3 offsets is partially implemented in
https://github.com/risty/SonarLogApi/blob/master/SonarLogAPI/Lowrance/Frame.cs and
https://github.com/KennethTM/sonaR/blob/master/src/read_slx.cpp .

This table is created with that as a base but is not verified.

|offset| bytes | type  | description
| ---: |  ---: | :---: | ---
|    0 |     4 | uint  | frame offset in file
|    4 |     4 | ?     | 
|    8 |     2 | short | blocksize - bytes to next block start. NOTE! not allways correct. Is almost always packet size + header.
|   10 |     2 | short | previous blocksize - bytes to previous block start from current block start
|   12 |     2 | short | channel type
|   16 |     4 | uint  | block/frame index
|   20 |     4 | float | upper limit
|   24 |     4 | float | lower limit
|   28 |    12 | ?     | unknown
|   40 |     4 | uint  | creation data time - value at fist frame = Unix time stamp of file creation. If GPS cant find position value will be "-1". Other frames - time in milliseconds from device boot.
|   44 |     2 | short | packet size. Size of sounding/bounce/ping data.
|   48 |     4 | float | depth
|   52 |     1 | byte  | frequency
|   84 |     4 | float | Speed from gps in knots
|   88 |     4 | float | temperature, in Celcius
|   92 |     4 | int   | lowrance encoded longitude
|   96 |     4 | int   | lowrance encoded latitude
|  100 |     4 | float | speedWater, in knots. Should be actual water speed or GPS if sensor not present.
|  104 |     4 | float | course over ground in radians
|  108 |     4 | float | altitude in feet
|  112 |     4 | float | heading, in radians
|  116 |     2 | flags | flags[4] bit coded.
|  124 |     4 | uint  | time in milliseconds from file creation
|  128 |     4 | uint  | last primary channel frame offset in file
|  132 |     4 | uint  | last secondary channel frame offset in file
|  136 |     4 | uint  | last downscan channel frame offset in file
|  140 |     4 | uint  | last left sidescan channel frame offset in file
|  144 |     4 | uint  | last right sidescan channel frame offset in file
|  148 |     4 | uint  | last composite sidescan channel frame offset in file
|  152 |    12 | ?     | unknown
|  164 |     4 | uint  | last three DC channel frame offset
|  168 |     ? | ?     | sounded data

## Probably
|offset| bytes | type  | description
| ---: |  ---: | :---: | ---
|   28 |     2 | short | blockSize[1], size of current block in bytes
|   30 |     2 | short | lastBlockSize, size of previous block (frameIndex -1) in bytes.
|   32 |     2 | short | channel[2], gets translated to channelName
|   36 |     4 | uint   | frameIndex. Starts at 0. Used ot match frames/block on different channels.
|   64 |     4 | float | waterDepth in feet
|   68 |     4 | float | keelDepth in feet
|  140 |     4 | uint   | time1, Unknown resolution, unknown epoch.
|  144 |     ? | ?     | unknown / not verified. Contains sounding/bounce data


__flags[4]__
offset from rightmost bit, value if read as UInt16LE

|bit offset | value |meaning
|     ---: |    ---: | -------
|       15 |  0x0080 | trackValid
|       14 |  0x0040 | waterSpeedValid
|       13 |  0x0020 | ?
|       12 |  0x0010 | positionValid
|       11 |  0x0008 | ? packetValid.  Set on packages with strange size. packetsize does not match blocksize
|       10 |  0x0004 | waterTempValid
|        9 |  0x0002 | gpsSpeedValid
|        8 |  0x0001 | ?
|        7 |  0x8000 | ?
|        6 |  0x4000 | ?
|        5 |  0x2000 | ?
|        4 |  0x1000 | ?
|        3 |  0x0800 | ?
|        2 |  0x0400 | ?
|        1 |  0x0200 | altitudeValid
|        0 |  0x0100 | headingValid

0xBE02 in the file (10111110 00000010) should translate to
```javascript
{
    trackValid: true,
    waterSpeedValid: false,
    positionValid: true,
    waterTempValid: true,
    gpsSpeedValid: true,
    altitudeValid: true,
    headingValid: false
}
```