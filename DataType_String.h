









#define STR(value)  [String create:value]










@interface String : ListBase 

    + (StableString*) create:(NSString*)str;
		
	+ (StableString*) createChar:(Char)ch;
	

    - (StableString*) toStable;

    
    @property (readonly) NSString* ns;
    @property (readonly) Int length;

    - (Char) charAt:(Int)index;
    
    - (StableString*) substring :(Int)start :(Int)length;
	
	- (StableString*) replacement :(Int)start :(Int)length :(String*)value;
	
    

@end








@interface StableString : String

    + (StableString*) create:(NSString*)str;
	
	+ (StableString*) createChar:(Char)ch;
	
@end





@interface MutableString : String

    + (MutableString*) create:(Int)capacity;
    + (MutableString*) createWithString:(String*)capacity;
	+ (MutableString*) createNSString:(NSString*)value;
	


    - (StableString*) seal;
		


    - (void) setCharAt :(Int)index :(Char)value;
    
    - (void) appendNS:(NSString*)value;
    
    - (void) insertAtNS :(Int)index :(NSString*)value;
    
	- (void) removeRange:(Int)index :(Int)length;
	
	- (Int) replaceNS :(NSString*)target :(NSString*)substitution;
		
    		
	- (void) replace :(Int)start :(Int)length :(String*)substitution;
		
		
@end
























