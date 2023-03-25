#include <std/mem.pat>
#include <std/io.pat>
#include <std/math.pat>

#pragma endian little

#define MAX_RECORDS 1024

#define POLAR_EARTH_RADIUS  6356752.3142

// 180/M_PI
#define RAD_CONVERSION 57.29577951308
#define PI_HALF 1.57079632679
// 1e-8
#define E8 0.00000001
#define KNOTS_KMH 1.85200
#define FEET_M 0.3048

fn exp(double x) {
    double result = 0;
    double term = 1;
    double i=0;
    while(std::math::abs(term) > E8) {
        result += term;
        i += 1;
        term = term * (x / i);
    }
    return result;
};



fn longitude(s32 easting) {
    return easting / POLAR_EARTH_RADIUS * RAD_CONVERSION;
};

fn latitude(s32 northing) {
    double tmp = northing / POLAR_EARTH_RADIUS;
    tmp = exp(tmp);
    tmp = 2 * std::math::atan(tmp);
    tmp = tmp - PI_HALF;
    return tmp * RAD_CONVERSION;
};

fn lon_fmt(s32 easting) {
    return std::format("{} ({})", longitude(easting), easting);
};

fn lat_fmt(s32 northing) {
    return std::format("{} ({})", latitude(northing), northing);
};

fn knots_fmt(float k) {
    return std::format("{:.2f} kph / {:.2f} knots", k * KNOTS_KMH, k);
};

fn feet_fmt(float f) {
   return std::format("{:.2f} m / {:.2f} f", f * FEET_M, f); 
};

fn rad_fmt(float f) {
    return std::format("{:.2f} deg / {:.2f} rad", f * RAD_CONVERSION, f);
};



fn chan_fmt(u16 c) {
    if (c == 0 ) 
        return "Primary (0)";
     else if (c==1)
        return "Secondary (1)";
     else if (c==2)
        return "Downscan (2)";
     else if (c==3)
        return "Sidescan Left (3)";
     else if (c==4)
        return "Sidescan Right (4)";
     else if (c==5)
        return "Sidescan Composite (5)"; 
     else
        return std::format("Unkown ({})", c);
};


fn freq_fmt(u8 f) {
    if (f== 0 || f > 10) 
        return std::format("200 KHz ({})", f);
     else if (f == 1)
        return "50 KHz (1)";
     else if (f == 8)
        return "90-150 KHz (8)";
     else 
        return std::format("Freq ({})", f);
};

struct Header {
    u16 format ;
    u16 version ;
    u16 blockSize;
    u16 spare;
};

namespace format2 {
    bitfield Flags {
        padding: 1;
        speedGPSValid: 1;
        temperatureValid: 1;
        strange: 1;
        positionValid: 1;
        padding: 1;
        speedWaterValid: 1; 
        trackValid: 1;
        //second byte

        validHeading: 1;
        validAltitude: 1;
        padding: 6;
    };
    
    

    struct FrameHeader {
        u32 offset;
        if (offset != ($-4)) {
            std::print("bad offset real:{} calc:{}", $-4, offset);
            break;
        }
        u32 lastPrimaryOffset;
        u32 lastSecondaryOffset;
        u32 lastDownScanOffset;
        u32 lastLeftOffset;
        u32 lastRightOffset;
        u32 lastCompositeOffset;
        u16 blockSize [[comment("frame header + data size in bytes")]];
        u16 lastBlockSize;

        u16 channel [[format("chan_fmt")]];
        u16 packetSize [[comment("data size in bytes")]]; 
        u32 frameIndex;
        float upperLimit;
        float lowerLimit;

        padding[2]; // unknown
        u8 frequency [[format("freq_fmt")]];
        padding[13]; // unknown

        float waterDepth [[format("feet_fmt")]];
        float keelDepth [[format("feet_fmt")]];

        padding[28]; // unkown
        float speedGPS [[format("knots_fmt")]];
        float temperature;
        s32 lonEnc [[format("lon_fmt")]];
        s32 latEnc [[format("lat_fmt")]];
        float speedWater [[format("knots_fmt")]];
        float courseOverGround [[format("rad_fmt")]];
        float altitude [[format("feet_fmt")]];
        float heading [[format("rad_fmt")]];
        Flags flags;

        padding[6]; // unkown
        u32 time1;
    };
    // char data[blockSize];
    
    struct Frame {
        FrameHeader header [[inline]];
        //std::print("h size= {}, diff={}", sizeof(header), sizeof(header)-140 );
        u8 data[header.packetSize];
    } [[format("frame_fmt")]];
    
}

fn frame_fmt(format2::Frame f) {
    return std::format("{:04d} {}", 
        f.header.frameIndex,
        chan_fmt(f.header.channel)
        );
};




Header header @0x00;

//if (header.format == 2) {
//    Frame2 entries[while(!std::mem::eof())] @0x08;
//format2::Header entries[while(!std::mem::eof())] @ 0x08;
    format2::Frame entries[std::math::min(MAX_RECORDS, sizeof($)/(header.blockSize+16))] @ 0x08;
//format2::Header frame @ 0x08;
//}


