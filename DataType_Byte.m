





#import "DataType.h"






static Byte LOOKUP_7[256] = 
{ 
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

static Byte LOOKUP_6[256] = 
{ 
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

static Byte LOOKUP_5[256] = 
{ 
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

static Byte LOOKUP_4[256] = 
{ 
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

static Byte LOOKUP_3[256] = 
{ 
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
};

static Byte LOOKUP_2[256] = 
{ 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 
	1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0
};	

static Byte LOOKUP_1[256] = 
{ 
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0,
	1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0
};	

static Byte LOOKUP_0[256] = 
{ 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 
	1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0
};	







Byte Byte_range(Byte value, Int start, Int length)
{
	SELFTEST_START
		
		ASSERT(Byte_range(255, 0, 8) == 255);
		ASSERT(Byte_range(255, 0, 7) == 127);
		ASSERT(Byte_range(255, 0, 6) == 63);
		ASSERT(Byte_range(255, 0, 5) == 31);
		ASSERT(Byte_range(255, 0, 4) == 15);
		ASSERT(Byte_range(255, 0, 3) == 7);
		ASSERT(Byte_range(255, 0, 2) == 3);
		ASSERT(Byte_range(255, 0, 1) == 1);
		ASSERT(Byte_range(255, 0, 0) == 0);

		ASSERT(Byte_range(255, 5, 2) == 3);
		ASSERT(Byte_range(255, 5, 1) == 1);
		
	SELFTEST_END

	ASSERT(0 <= start && start < 8);
	ASSERT(0 <= length && length <= 8);
	
	Byte result = 0;
	
	switch (start)
	{
		case 0:
			if (length > 0) result += LOOKUP_0[value] * 1;
			if (length > 1) result += LOOKUP_1[value] * 2;
			if (length > 2) result += LOOKUP_2[value] * 4;
			if (length > 3) result += LOOKUP_3[value] * 8;
			if (length > 4) result += LOOKUP_4[value] * 16;
			if (length > 5) result += LOOKUP_5[value] * 32;
			if (length > 6) result += LOOKUP_6[value] * 64;
			if (length > 7) result += LOOKUP_7[value] * 128;
			break;
		case 1:
			if (length > 0) result += LOOKUP_1[value] * 1;
			if (length > 1) result += LOOKUP_2[value] * 2;
			if (length > 2) result += LOOKUP_3[value] * 4;
			if (length > 3) result += LOOKUP_4[value] * 8;
			if (length > 4) result += LOOKUP_5[value] * 16;
			if (length > 5) result += LOOKUP_6[value] * 32;
			if (length > 6) result += LOOKUP_7[value] * 64;
			break;		
		case 2:
			if (length > 0) result += LOOKUP_2[value] * 1;
			if (length > 1) result += LOOKUP_3[value] * 2;
			if (length > 2) result += LOOKUP_4[value] * 4;
			if (length > 3) result += LOOKUP_5[value] * 8;
			if (length > 4) result += LOOKUP_6[value] * 16;
			if (length > 5) result += LOOKUP_7[value] * 32;
			break;					
		case 3:
			if (length > 0) result += LOOKUP_3[value] * 1;
			if (length > 1) result += LOOKUP_4[value] * 2;
			if (length > 2) result += LOOKUP_5[value] * 4;
			if (length > 3) result += LOOKUP_6[value] * 8;
			if (length > 4) result += LOOKUP_7[value] * 16;
			break;					
		case 4:
			if (length > 0) result += LOOKUP_4[value] * 1;
			if (length > 1) result += LOOKUP_5[value] * 2;
			if (length > 2) result += LOOKUP_6[value] * 4;
			if (length > 3) result += LOOKUP_7[value] * 8;
			break;					
		case 5:
			if (length > 0) result += LOOKUP_5[value] * 1;
			if (length > 1) result += LOOKUP_6[value] * 2;
			if (length > 2) result += LOOKUP_7[value] * 4;
			break;					
		case 6:
			if (length > 0) result += LOOKUP_6[value] * 1;
			if (length > 1) result += LOOKUP_7[value] * 2;
			break;					
		case 7:
			if (length > 0) result += LOOKUP_7[value] * 1;
			break;					
	}
	
	return result;
}

Byte Byte_shift(Byte value, Int offset)
{
	SELFTEST_START
		
		ASSERT(Byte_shift(1, 1) == 2);
		ASSERT(Byte_shift(1, 2) == 4);
		ASSERT(Byte_shift(1, 3) == 8);
		ASSERT(Byte_shift(1, 4) == 16);
		ASSERT(Byte_shift(1, 5) == 32);
		ASSERT(Byte_shift(1, 6) == 64);
		ASSERT(Byte_shift(1, 7) == 128);
		ASSERT(Byte_shift(1, 8) == 0);
		
		ASSERT(Byte_shift(4+8, 1) == 8+16);

	SELFTEST_END
	
	Byte result = 0;
	
	switch (offset)
	{
		case 1:	
			result += LOOKUP_1[value] * 1;
			result += LOOKUP_2[value] * 2;
			result += LOOKUP_3[value] * 4;
			result += LOOKUP_4[value] * 8;
			result += LOOKUP_5[value] * 16;
			result += LOOKUP_6[value] * 32;
			result += LOOKUP_7[value] * 64;
			break;
		case 2:
			result += LOOKUP_2[value] * 1;
			result += LOOKUP_3[value] * 2;
			result += LOOKUP_4[value] * 4;
			result += LOOKUP_5[value] * 8;
			result += LOOKUP_6[value] * 16;
			result += LOOKUP_7[value] * 32;
			break;
		case 3:
			result += LOOKUP_3[value] * 1;
			result += LOOKUP_4[value] * 2;
			result += LOOKUP_5[value] * 4;
			result += LOOKUP_6[value] * 8;
			result += LOOKUP_7[value] * 16;
			break;
		case 4:
			result += LOOKUP_4[value] * 1;
			result += LOOKUP_5[value] * 2;
			result += LOOKUP_6[value] * 4;
			result += LOOKUP_7[value] * 8;
			break;
		case 5:
			result += LOOKUP_5[value] * 1;
			result += LOOKUP_6[value] * 2;
			result += LOOKUP_7[value] * 4;
			break;
		case 6:
			result += LOOKUP_6[value] * 1;
			result += LOOKUP_7[value] * 2;
			break;
		case 7:
			result += LOOKUP_7[value] * 1;
			break;
	}
	
	return result;	
}





Char Byte2_toChar(Byte2 me)
{
    SELFTEST_START
        Byte2_fromChar(CHAR(A));
    SELFTEST_END
    
    Char result = 0;
    
    Byte* ptr = (Byte*)&result;    
    ptr[0] = me.a;
    ptr[1] = me.b;
    
    return result; 
}
Byte2 Byte2_fromChar(Char value)
{
    SELFTEST_START
        ASSERT(Byte2_toChar(Byte2_fromChar(Char_Null)) == Char_Null); 
        ASSERT(Byte2_toChar(Byte2_fromChar(CHAR(A))) == CHAR(A)); 
    SELFTEST_END
    
    Byte* ptr = (Byte*)&value;    
    return Byte2_create(ptr[0], ptr[1]);  
}

void Byte2_appendToData(Byte2 me, NSMutableData* output)
{
    Byte bs[2];
    bs[0] = me.a;
    bs[1] = me.b;
    
    [output appendBytes:&me length:2];
}

Byte2 Byte2_fromData(NSData* data, Int offset)
{
    NSRange range = NSMakeRange(toUInt(offset), 2);
    
    Byte bs[2];
    [data getBytes:&bs range:range];
    
    return Byte2_create(bs[0], bs[1]);
}








Int Byte4_toInt(Byte4 me)
{
    Int result = 0;
    
    Byte* ptr = (Byte*)&result;    
    ptr[0] = me.a;
    ptr[1] = me.b;
    ptr[2] = me.c;
    ptr[3] = me.d;
    
    return result;    
}

Byte4 Byte4_fromInt(Int value)
{
    Byte* ptr = (Byte*)&value;    
    return Byte4_create(ptr[0], ptr[1], ptr[2], ptr[3]); 
}


UInt Byte4_toUInt(Byte4 me)
{
    SELFTEST_START
        Byte4_fromUInt(0);
    SELFTEST_END

    UInt result = 0;
    
    Byte* ptr = (Byte*)&result;    
    ptr[0] = me.a;
    ptr[1] = me.b;
    ptr[2] = me.c;
    ptr[3] = me.d;
    
    return result;    
}

Byte4 Byte4_fromUInt(UInt value)
{
    SELFTEST_START
        ASSERT(Byte4_toUInt(Byte4_fromUInt(0)) == 0); 
        ASSERT(Byte4_toUInt(Byte4_fromUInt(1)) == 1); 
        ASSERT(Byte4_toUInt(Byte4_fromUInt(100000)) == 100000); 
        ASSERT(Byte4_toUInt(Byte4_fromUInt(UINT_MAX)) == UINT_MAX); 
    SELFTEST_END

    Byte* ptr = (Byte*)&value;    
    return Byte4_create(ptr[0], ptr[1], ptr[2], ptr[3]);    
}

void Byte4_appendToData(Byte4 me, NSMutableData* output)
{
    Byte bs[4];
    bs[0] = me.a;
    bs[1] = me.b;
    bs[2] = me.c;
    bs[3] = me.d;
    [output appendBytes:&me length:4];
}

Byte4 Byte4_fromData(NSData* data, Int offset)
{
    NSRange range = NSMakeRange(toUInt(offset), 4);
    
    Byte bs[4];
    [data getBytes:&bs range:range];    
    
    return Byte4_create(bs[0], bs[1], bs[2], bs[3]);
}










Double Byte8_toDouble(Byte8 me)
{
    Double result = 0;
    
    Byte* ptr = (Byte*)&result;    
    ptr[0] = me.a;
    ptr[1] = me.b;
    ptr[2] = me.c;
    ptr[3] = me.d;
    ptr[4] = me.e;
    ptr[5] = me.f;
    ptr[6] = me.g;
    ptr[7] = me.h;
    
    return result;    
}

Byte8 Byte8_fromDouble(Double value)
{
    Byte* p = (Byte*)&value;    
    return Byte8_create(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);    
}

void Byte8_appendToData(Byte8 me, NSMutableData* output)
{
    Byte bs[8];
    bs[0] = me.a;
    bs[1] = me.b;
    bs[2] = me.c;
    bs[3] = me.d;
    bs[4] = me.e;
    bs[5] = me.f;
    bs[6] = me.g;
    bs[7] = me.h;
    [output appendBytes:&me length:8];
}

Byte8 Byte8_fromData(NSData* data, Int offset)
{
    NSRange range = NSMakeRange(toUInt(offset), 8);
    
    Byte bs[8];
    [data getBytes:&bs range:range];    
    
    return Byte8_create(bs[0], bs[1], bs[2], bs[3], bs[4], bs[5], bs[6], bs[7]);
}











