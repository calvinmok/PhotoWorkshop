








@interface StringList (_)

	- (Bool) containString:(String*)value;
	
	- (NubleInt) firstIndexOfString:(String*)value;
	- (NubleInt) lastIndexOfString:(String*)value;


	@property(readonly) String* debugInfo;
	
	- (void) assert:(String*)stringList;

@end





StringMutableList* StringMutableList_fromStringList(String* stringList);

