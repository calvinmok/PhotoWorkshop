






#import "DataType.h"









@implementation StringList (_)


	- (Bool) containString:(String*)value
	{
		FOR_EACH_INDEX(i, self)
		{
			if ([value eq:[self at:i]])
				return YES;			
		}
		
		return NO;
	}
	
	- (NubleInt) firstIndexOfString:(String*)value
	{
		FOR_EACH_INDEX(i, self)
		{
			if ([value eq:[self at:i]])
				return Int_toNuble(i);			
		}
		
		return Int_nuble();
	}
	
	- (NubleInt) lastIndexOfString:(String*)value
	{
		FOR_EACH_INDEX_IN_REV(i, self)
		{
			if ([value eq:[self at:i]])
				return Int_toNuble(i);			
		}
		
		return Int_nuble();	
	}
	
	
	- (String*) debugInfo
	{
		MutableString* result = [MutableString create:10];
		
		FOR_EACH_INDEX(i, self)
		{
			if (result.length > 0)
				[result append:STR(@",")];
			
			[result append:[self at:i]];
		}
		
		return result;
	}


	- (void) assert:(String*)stringList
	{
		StringList* list = [stringList split:STR(@",")];		
		
		ASSERT(list.count == self.count);
		
		FOR_EACH_INDEX(i, list)
		{
			ASSERT([[self at:i] eq:[list at:i]]);
		}
	}

@end




StringMutableList* StringMutableList_fromStringList(String* stringList)
{
    if (stringList.length == 0)
        return [StringMutableList create:0];
        
	return [stringList split:STR(@",")];
}













