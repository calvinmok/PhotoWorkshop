






UInt Byte_toUInt(Byte value);




Byte Byte_range(Byte value, Int start, Int length);

Byte Byte_shift(Byte value, Int offset);






typedef struct 
{
    Byte a, b;
}
Byte2;

NS_INLINE Byte2 Byte2_create(Byte a, Byte b) { Byte2 r = { a, b }; return r; }

Char Byte2_toChar(Byte2 me);
Byte2 Byte2_fromChar(Char value);

void Byte2_appendToData(Byte2 me, NSMutableData* output);
Byte2 Byte2_fromData(NSData* data, Int offset);




typedef struct 
{
    Byte a, b, c, d;
}
Byte4;

NS_INLINE Byte4 Byte4_create(Byte a, Byte b, Byte c, Byte d) { Byte4 r = { a, b, c, d }; return r; }

Int Byte4_toInt(Byte4 me);
Byte4 Byte4_fromInt(Int value);

UInt Byte4_toUInt(Byte4 me);
Byte4 Byte4_fromUInt(UInt value);

void Byte4_appendToData(Byte4 me, NSMutableData* output);
Byte4 Byte4_fromData(NSData* data, Int offset);







typedef struct 
{
    Byte a, b, c, d, e, f, g, h;
}
Byte8;

NS_INLINE Byte8 Byte8_create(Byte a, Byte b, Byte c, Byte d, Byte e, Byte f, Byte g, Byte h) { Byte8 r = { a, b, c, d, e, f, g, h }; return r; }

Double Byte8_toDouble(Byte8 me);
Byte8 Byte8_fromDouble(Double value);

void Byte8_appendToData(Byte8 me, NSMutableData* output);
Byte8 Byte8_fromData(NSData* data, Int offset);
















