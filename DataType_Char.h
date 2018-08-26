












#define CHAR(value) [@#value characterAtIndex:0]

#define CHAR_0     [@"\0" characterAtIndex:0]
#define CHAR_T     [@"\t" characterAtIndex:0]
#define CHAR_N     [@"\n" characterAtIndex:0]
#define CHAR_R     [@"\r" characterAtIndex:0]


#define CHAR_CM     [@"," characterAtIndex:0]
#define CHAR_DQ     [@"\"" characterAtIndex:0]
#define CHAR_LP     [@"(" characterAtIndex:0]
#define CHAR_RP     [@")" characterAtIndex:0]
#define CHAR_SP     [@" " characterAtIndex:0]







Int Char_toInt(Char value);
UInt Char_toUInt(Char value);


Bool Char_isInsideNS(Char value, NSString* str);


Char Char_lower(Char value);
Char Char_upper(Char value);


Bool Char_isDigit(Char value);
Bool Char_isAlphabet(Char value);



Char Char_decimalSeparator(void);


NS_INLINE Bool3 Char_isSmallerXY(Char x, Char y) { return (x == y) ? Unknown : (x < y ? Yes : No); }
	
	
	

void Char_selfTest(void);









