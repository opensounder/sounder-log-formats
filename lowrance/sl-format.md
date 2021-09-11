# Lowrance SL2/SL3/SLG

So far there are 3 different types of files from 
Lowrance, SL2, SL3 and SLG.
They are similar, bordering to identical.

## Credits
Much kudos to openstreetmap.org project and their SL2 documentation page
http://wiki.openstreetmap.org/wiki/SL2

Some hints and info about slg can be found at
http://www.geotech1.com/forums/showthread.php?11159-Lowrance-MCC-saved-data-structure

Some information found in
https://www.memotech.franken.de/FileFormats/Navico_SLG_Format.pdf

## Notes
THE DOCUMENTATION IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

## Projects with code using any of the Lowrance formats
- https://github.com/kmpm/node-sl2format
- https://github.com/Seva-coder/FindFish
- https://github.com/risty/SonarLogApi
- https://github.com/Chris78/sl2decode
- https://github.com/opensounder/python-sllib


# Definition

## Datatypes
type  | definition
------|-----------
byte  | UInt8
short | UInt16LE
int   | Int32LE
uint  | UInt32LE
float | FloatLE (32 bits IEEE 754 floating point number)
flags | UInt16LE

## Structure
### Header
8 byte header, then a series of blocks/frames as described below.

| offset | bytes | type  | description
|  ---: |   ---:|  ---  | --------------------
|     0 |     2 | short | format[1]
|     2 |     2 | short | version[2]
|     4 |     2 | short | blocksize[3]
|     6 |     2 | short | unknown/always 0


- __format[1]__ 1 = slg, 2 = sl2, 3 = sl3
- __version[2]__ 0= ex HDS 7, 1= ex. Elite 4 CHIP
- __blocksize[3]__ 1970=Downscan #b207, 3200=Sidescan #800c

- Format 1 [format-1.md](format-1.md)
- Format 2 [format-2.md](format-2.md)
- Format 3 [format-3.md](format-3.md)
