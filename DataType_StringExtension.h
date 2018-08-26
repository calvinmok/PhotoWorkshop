





StableString* String_empty(void);

StableString* String_concat(String* x, String* y);
StableString* String_concat3(String* s1, String* s2, String* s3);


Int String_getHash(String* value);

Bool3 String_isSmallerXY(String* x, String* y);









@interface String (_)

	- (Char) firstChar;	
	- (Char) lastChar;	
	
	- (NubleChar) firstChar_;		
	- (NubleChar) lastChar_;	
	
	
	- (NubleChar) charAt_:(Int)index;
    
	- (void) getAllChar:(Char*)buffer;
    

	
	
	- (Bool) eq :(String*)other;
	- (Bool) eqNS :(NSString*)other;
    	
	- (Bool3) localizedIsSmallerThan:(String*)other;


	- (Bool) startWith:(String*)value;	
	- (Bool) endWith:(String*)value;
	
	
    


	

	- (StableString*) front:(Int)length;
	- (StableString*) back:(Int)length;
	
	- (StableString*) cutFront:(Int)length;	
	- (StableString*) cutBack:(Int)length;	
	
	
	- (StableString*) startAt:(Int)index;
	- (StableString*) endAt:(Int)index;
	
    - (StableString*) startEndAt :(Int)start :(Int)end;



	
	
	
	
    
    
    - (StableString*) replacement:(String*)target :(String*)substitution;

	
	
    - (NubleInt) indexOfChar :(Char)value;
	- (NubleInt) indexOfChar :(Char)value from:(Int)begin;
		
	- (NubleInt) indexOf :(String*)value;
	- (NubleInt) indexOf :(String*)value :(Int)begin;
	
	
	
	
	- (Int) countChar:(Char)value;
	
	
	
	
	- (StableString*) lower;
	- (StableString*) upper;


	- (StringMutableList*) split:(String*)separator;
	 

	+ (StableString*) createFromData :(NSData*)data :(Int)offset :(Int)length;
    - (void) appendToData:(NSMutableData*)output;
    
	
	- (void) assert:(NSString*)value;

    
@end




@interface StableString (_)

@end




@interface MutableString (_)


	- (void) append:(String*)value;
    - (void) appendChar:(Char)value;

    - (void) insert:(String*)value;
    - (void) insertAt :(Int)index :(String*)value;
    
    - (void) insertChar:(Char)value;
    - (void) insertCharAt :(Int)index :(Char)value;
    

	- (void) removeAt:(Int)index;

	- (void) replace :(String*)target :(String*)substitution;

	
@end





void MutableString_selfTest(void);

void String_selfTest(void);






