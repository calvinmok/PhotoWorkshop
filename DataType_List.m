









#import "DataType.h"















@implementation ListBase 
    

	- (Int) count
	{
		ABSTRACT_METHOD(Int)
	}
	
	
@end

@implementation ListBase (_)


	- (ListIndexEnumerator*) eachIndex
	{
		return [ListIndexEnumerator create:self];
	}

	- (ListIndexEnumerator*) reversedEachIndex
	{
		return [ListIndexEnumerator createReversed:self];
	}



	- (Bool) isValidIndex:(Int)index
	{
		return (0 <= index && index <= self.count - 1);
	}
	
    - (Bool) isValidRange :(Int)start :(Int)length
    {
        SELFTEST_START
        
            String* empty = String_empty();
            String* str3 = STR(@"abc");
            
            ASSERT([str3 isValidRange :-1 :0] == NO);
            ASSERT([str3 isValidRange :0 :-1] == NO);

            ASSERT([empty isValidRange :0 :0]);
            ASSERT([empty isValidRange :1 :0] == NO);
            ASSERT([empty isValidRange :0 :1] == NO);

            ASSERT([str3 isValidRange :0 :3]);
            ASSERT([str3 isValidRange :1 :2]);
            ASSERT([str3 isValidRange :2 :1]);
            ASSERT([str3 isValidRange :3 :0]);
            
            ASSERT([str3 isValidRange :0 :4] == NO);
            ASSERT([str3 isValidRange :1 :3] == NO);
            ASSERT([str3 isValidRange :2 :2] == NO);
            ASSERT([str3 isValidRange :3 :1] == NO);
            ASSERT([str3 isValidRange :4 :0] == NO);
            
        SELFTEST_END    
        
        
        if (start < 0 || length < 0) 
            return NO;
		
        NubleInt selfLastIndex = self.lastIndex_;
        
        if (selfLastIndex.hasVar == NO)
            return (start == 0 && length == 0);
			
        if (start == selfLastIndex.vd + 1)
            return (length == 0);

        if (start > selfLastIndex.vd + 1)
            return NO;
			
        if (length == 0)
            return (start <= selfLastIndex.vd);
			
        return (start + length - 1 <= selfLastIndex.vd);    
    }
    
    
    
	
    - (Int) firstIndex
	{
		return Int_var(self.firstIndex_);
	}

    - (Int) lastIndex
	{
		return Int_var(self.lastIndex_);
	}
	
    - (NubleInt) firstIndex_
	{
        return (self.count > 0) ? Int_toNuble(0) : Int_nuble();
	}
	
    - (NubleInt) lastIndex_
	{
		Int c = self.count;
        return (c > 0) ? Int_toNuble(c - 1) : Int_nuble();
	}
	
	
	
	- (Int) nextIndex
	{
		return self.count;
	}

    
@end














