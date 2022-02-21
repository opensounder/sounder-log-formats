# Format 2/SL2 Block/Frame
There might be variations to this depending on the header version.
## Notes
THE DOCUMENTATION IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

## Block/Frame header
|offset| bytes | type  | description
| ---: |  ---: | :---: | ---
|    0 |     4 | uint  | frame offset in file
|    4 |     4 | uint  | last primary channel frame offset in file
|    8 |     4 | uint  | last secondary channel frame offset in file
|   12 |     4 | uint  | last downscan channel frame offset in file
|   16 |     4 | uint  | last left sidescan channel frame offset in file
|   20 |     4 | uint  | last right sidescan channel frame offset in file
|   24 |     4 | uint  | last composite sidescan channel frame offset in file
|   28 |     2 | short | blockSize[1], size of current block in bytes
|   30 |     2 | short | lastBlockSize, size of previous block (frameIndex -1) in bytes.
|   32 |     2 | short | channel[2], gets translated to channelName
|   34 |     2 | short | packetSize. Size of soundeing/bounce data.
|   36 |     4 | uint  | frameIndex. Starts at 0. Used ot match frames/block on different channels.
|   40 |     4 | float | upperLimit
|   44 |     4 | float | lowerLimit
|   48 |     2 | ?     | unknown / not verified
|   50 |     1 | byte  | frequency[3]
|   51 |    13 | ?     | unknown / not verified
|   64 |     4 | float | waterDepth in feet
|   68 |     4 | float | keelDepth in feet
|   72 |    28 | ?     | unknown / not verified
|  100 |     4 | float | speedGps, Speed from gps in knots
|  104 |     4 | float | temperature, in Celcius
|  108 |     4 | int   | lowrance encoded longitude
|  112 |     4 | int   | lowrance encoded latitude
|  116 |     4 | float | speedWater, in knots. Should be actual water speed or GPS if sensor not present.
|  120 |     4 | float | courseOverGround in radians,
|  124 |     4 | float | altitude in feet
|  128 |     4 | float | heading, in radians
|  132 |     2 | flags | flags[4] bit coded.
|  134 |     6 | ?     | unkown / not verified
|  140 |     4 | uint  | time1, Unknown resolution, unknown epoch.
|  144 |     ? | ?     | unknown / not verified. Contains sounding/bounce data and get size from packetSize

__blockSize[1]__ The last block in the file doesn't always follow this pattern and I don't know why.

__channel[2]__
* 0 = Primary (Tranditional Sonar)
* 1 = Secondary (Traditional Sonar)
* 2 = DSI (DownScan Imaging)
* 3 = Left (Sidescan)
* 4 = Right (Sidescan)
* 5 = Composite (Sidescan)
* Any other value is treated as invalid


__frequency[3]__
* 0 = 200 KHz
* 1 = 50 KHz
* 2 = 83 KHz 
* 3 = 455 KHz
* 4 = 800 KHz
* 5 = 38 KHz
* 6 = 28 KHz
* 7 = 130 - 210 KHz
* 8 = 90 - 150 KHz
* 9 = 40 - 60 KHz
* 10 = 25 - 45 KHz
* Any other value is treated like 200 KHz

__flags[4]__
offset from rightmost bit, value if read as UInt16LE

|bit offset | value |meaning
|     ---: |    ---: | -------
|       15 |  0x0080 | trackValid
|       14 |  0x0040 | waterSpeedValid
|       13 |  0x0020 | ?
|       12 |  0x0010 | positionValid
|       11 |  0x0008 | ? set on packages with strange size
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
