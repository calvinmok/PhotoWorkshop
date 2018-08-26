




#import "DataType.h"





@implementation String (Base64)



	
	+ (String*) toBase64:(NSData*)data
	{
		String* base64Str = STR(@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
	
		MutableString* result = [MutableString create:toInt((data.length / 3) * 2)];
		
		for (NSUInteger i = 0; i < data.length; i+= 3)
		{
			Byte* bytes = (Byte*)data.bytes;
			NubleByte byte0 = Byte_nuble();
			NubleByte byte1 = Byte_nuble();
			NubleByte byte2 = Byte_nuble();
			
			if (i + 0 <= data.length - 1) byte0 = Byte_toNuble(bytes[i + 0]);
			if (i + 1 <= data.length - 1) byte1 = Byte_toNuble(bytes[i + 1]);
			if (i + 2 <= data.length - 1) byte2 = Byte_toNuble(bytes[i + 2]);
			
			if (byte0.hasVar)
			{
				Byte bR = Byte_range(byte0.vd, 2, 6);
				[result appendChar:[base64Str charAt:bR]];
			}
			
			if (byte0.hasVar && byte1.hasVar)
			{
				Byte b0 = Byte_range(byte0.vd, 0, 2);
				Byte b1 = Byte_range(byte1.vd, 4, 4);
				Byte bR = Byte_shift(b0, 4) + b1;
				[result appendChar:[base64Str charAt:bR]];
			}
			
			if (byte0.hasVar && byte1.hasVar && byte2.hasVar)
			{
				{
					Byte b0 = Byte_range(byte1.vd, 0, 4);
					Byte b1 = Byte_range(byte2.vd, 6, 2);
					Byte bR = Byte_shift(b0, 2) + b1;
					[result appendChar:[base64Str charAt:bR]];
				}
				{
					Byte bR = Byte_range(byte1.vd, 0, 6);
					[result appendChar:[base64Str charAt:bR]];
				}
			}
		}
		
		return [result seal];		
	}
	
	+ (NSData*) fromBase64:(String*)data
	{
		return nil;
		/*
		Int capacity = Double_toInt(data.length * (3.0 / 4.0)) + 1;
		
		NSMutableData* result = [NSMutableData dataWithCapacity:capacity];
		
		for (Int i = 0; i < data.length; i += 4)
		{
			[result appendData:
		}
	
	
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63, 
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx, 
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx, 
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
};	
unsigned char accumulated[BASE64_UNIT_SIZE];
size_t accumulateIndex = 0;
while (i < length)
{
    unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
    if (decode != xx)
    {
        accumulated[accumulateIndex] = decode;
        accumulateIndex++;
         
        if (accumulateIndex == BASE64_UNIT_SIZE)
        {
            break;
        }
    }
}	*/

	}
	
		


@end




