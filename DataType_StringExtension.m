




#import "DataType.h"







StableString* String_empty(void)
{
	static StableString* value = nil;
	if (value == nil) value = [[StableString create:@""] retain];
	return value;
}



StableString* String_concat(String* x, String* y)
{
	SELFTEST_START
	
	[String_concat(STR(@""), STR(@"bbb")) assert:@"bbb"];
	[String_concat(STR(@"aaa"), STR(@"")) assert:@"aaa"];
	[String_concat(STR(@"aaa"), STR(@"bbb")) assert:@"aaabbb"];
	
	SELFTEST_END
	
	
	MutableString* result = [MutableString create:10];
	[result append:x];
	[result append:y];
	return [result seal];
}

StableString* String_concat3(String* s1, String* s2, String* s3)
{
	MutableString* result = [MutableString create:10];
	[result append:s1];
	[result append:s2];
	[result append:s3];
	return [result seal];
}


Int String_getHash(String* value)
{
    UInt result = 31;

    FOR_EACH_INDEX(i, value)
    {
        while (result >= UInt_Max / 31)
            result /= 2;
        
        result = (result * 31);
        
        UInt c = Char_toUInt([value charAt:i]);

        while (result >= UInt_Max - c)
            result /= 2;
            
        result += c;
    }

    if (result > toUInt(Int_Max))
        return toInt(result - toUInt(Int_Max));
    else
        return toInt(result);    
}



Bool3 String_isSmallerXY(String* x, String* y)
{
	for (Int i = 0; i < Int_min(x.length, y.length); i++)
	{
		Bool3 b = Char_isSmallerXY([x charAt:i], [y charAt:i]);
		if (b IsKnown)
			return b;
	}
	
	return Int_isSmallerXY(x.length, y.length);	
}






@implementation String (_)
    
			
	- (Char) firstChar { return [self charAt:self.firstIndex]; }
	- (Char) lastChar { return [self charAt:self.lastIndex]; }
	
	- (NubleChar) firstChar_ { NubleInt i = self.firstIndex_; return (i.hasVar) ? [self charAt_:i.vd] : Char_nuble(); }
	- (NubleChar) lastChar_ { NubleInt i = self.lastIndex_; return (i.hasVar) ? [self charAt_:i.vd] : Char_nuble(); }
	

	- (NubleChar) charAt_:(Int)index { return [self isValidIndex:index] ? Char_toNuble([self charAt:index]) : Char_nuble(); }
        
	- (void) getAllChar:(Char*)buffer
	{
		for (Int i = 0; i < self.length; i++)
			buffer[i] = [self charAt:i];
	}
			
		

	- (Bool) eq :(String*)other
	{
		if (other.length != self.length)
			return NO;
		
		for (Int i = 0; i < self.length; i++)
			if ([self charAt:i] != [other charAt:i])
				return NO;
		
		return YES;	
	}
    
	- (Bool) eqNS :(NSString*)other;
    {
		if ([other length] != toUInt(self.length))
			return NO;
		
		for (Int i = 0; i < self.length; i++)
			if ([self charAt:i] != [other characterAtIndex:toUInt(i)])
				return NO;
		
		return YES;	    
    }
    	    
	
	- (Bool3) localizedIsSmallerThan:(String*)other
	{
		NSComparisonResult result = [self.ns localizedCompare:other.ns];
		if (result == NSOrderedAscending) return Yes;
		if (result == NSOrderedDescending) return No;
		return Unknown;
	}
	
	
	
	
    

	- (Bool) startWith:(String*)value
	{		
		if (value.length > self.length)
			return NO;
	
		for (Int i = 0; i < value.length; i++)
			if ([self charAt:i] != [value charAt:i])
				return NO;
	
		return YES;
	}
	
	
	- (Bool) endWith:(String*)value
	{
		if (value.length > self.length)
			return NO;
	
		for (Int i = 0; i < value.length; i++)
			if ([self charAt:self.lastIndex - i] != [value charAt:value.lastIndex - i])
				return NO;
	
		return YES;
	}
	
	
	
	
	
	
	- (StableString*) front:(Int)length { return [self substring :0 :length]; }
	- (StableString*) back:(Int)length { return [self startAt :self.lastIndex - length + 1]; }
	
	- (StableString*) cutFront:(Int)length { return [self back :self.length - length]; }
	- (StableString*) cutBack:(Int)length { return [self front :self.length - length]; }


	- (StableString*) startEndAt :(Int)start :(Int)end 
    { 
        ASSERT(start <= end); 
        return [self substring :start :end - start + 1];
	}

	- (StableString*) startAt:(Int)index { return [self substring :index :self.lastIndex - index + 1]; }
	- (StableString*) endAt:(Int)index { return [self substring :0 :index + 1]; }

    
	
	

	
   
    
    	
	- (StableString*) replacement:(String*)target :(String*)substitution
	{
		MutableString* result = [MutableString createWithString:self];
		[result replace :target :substitution];
		return [result seal];
	}
    
    
    
    
    
	- (NubleInt) indexOfChar :(Char)value
	{
		SELFTEST_START
			ASSERT([STR(@"abcdef") indexOfChar:CHAR(b)].vd == 1);
			ASSERT([STR(@"abcdef") indexOfChar:CHAR(z)].hasVar == NO);
		SELFTEST_END
		
		return [self indexOfChar:value from:0];
	}
	- (NubleInt) indexOfChar :(Char)value from:(Int)begin
	{
		for (Int i = begin; i < self.length; i++)
			if ([self charAt:i] == value)
				return Int_toNuble(i);
		
		return Int_nuble();
	}




	- (NubleInt) indexOf :(String*)value
	{
		return [self indexOf :value :0];
	}
	- (NubleInt) indexOf :(String*)value :(Int)begin
	{
		SELFTEST_START
			//ASSERT([STR(@"") indexOf :STR(@"") :3].vd == 3);

			//ASSERT([STR(@"abcabc") indexOf :STR(@"") :0].vd == 0);
			//ASSERT([STR(@"abcabc") indexOf :STR(@"") :3].vd == 3);

			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :0].vd == 0);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :0].vd == 0);		
			ASSERT([STR(@"abcabc") indexOf :STR(@"c") :0].vd == 2);
			ASSERT([STR(@"abcabc") indexOf :STR(@"cabc") :0].vd == 2);
			
			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :1].vd == 3);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :1].vd == 3);		

			ASSERT([STR(@"abcabc") indexOf :STR(@"a") :3].vd == 3);
			ASSERT([STR(@"abcabc") indexOf :STR(@"abc") :3].vd == 3);		
		SELFTEST_END
            
        ASSERT(value.length > 0);
		ASSERT([self isValidRange :begin :value.length]);
		
		Int index = 0;
		
		for (Int i = begin; i < self.length; i++)
		{
			if ([self charAt:i] == [value charAt:index])
			{
				if (index == value.lastIndex)
					return Int_toNuble(i - index);
					
				index++;
			}
		}
		
		return Int_nuble();
	}
    
    
    
    

	- (Bool) contain :(String*)value
	{
		return [self indexOf:value].hasVar;
	}



	- (Int) countChar:(Char)value
	{
		Int result = 0;
		
		FOR_EACH_INDEX(i, self)
		{
			if ([self charAt:i] == value)
				result += 1;
		}
		
		return result;		
	}



	
	- (StableString*) lower
    {
		SELFTEST_START
			[[[String create:@"aBc"] lower] assert:@"abc"];
		SELFTEST_END

        MutableString* result = nil;
        
        for (Int i = 0; i < self.length; i++)
        {
            Char ch = [self charAt:i];
            Char lower = Char_lower(ch);
            
            if (lower != ch)
            {
                if (result == nil)
                    result = [MutableString createWithString:self];
                    
                [result setCharAt :i :lower];
            }
        }
        
        return (result != nil) ? [result seal] : [self toStable];
    }
    
	- (StableString*) upper
    {
		SELFTEST_START
			[[[String create:@"aBc"] upper] assert:@"ABC"];
		SELFTEST_END
			
        MutableString* result = nil;
        
        for (Int i = 0; i < [self length]; i++)
        {
            Char ch = [self charAt:i];
            Char upper = Char_upper(ch);
            
            if (upper != ch)
            {
                if (result == nil)
                    result = [MutableString createWithString:self];

                [result setCharAt :i :upper];
            }
        }		

        return (result != nil) ? [result seal] : [self toStable];
    }
    
    

	- (StringMutableList*) split:(String*)separator
	{
		ASSERT(separator.length > 0);
				
		StringMutableList* result = [StringMutableList create];
		
		StableString* s = [self toStable];
		
		while (YES)
		{
			NubleInt i = [s indexOf:separator];
			
			if (i.hasVar == NO) 
			{
				[result append:s];
				break;
			}
				
			[result append:[[s endAt:i.vd] cutBack:1]];
			
			s = [[s startAt:i.vd] cutFront:separator.length];
			
			if (s.length < separator.length)
			{
				[result append:s];
				break;
			}
		}
				
		return result;
	}
	

    
		
	


	+ (StableString*) createFromData :(NSData*)data :(Int)offset :(Int)length
    {
        MutableString* result = [MutableString create:10];
        
        for (Int i = 0; i <= length - 2; i += 2)
        {
            Char c = Byte2_toChar(Byte2_fromData(data, i + offset));            
            [result appendChar:c];
        }
        
        return [result seal];
    }
    
    - (void) appendToData:(NSMutableData*)output
    {
        for (Int i = 0; i < self.count; i++)
        {
            Byte2 b = Byte2_fromChar([self charAt:i]);            
            Byte2_appendToData(b, output);            
        }        
    }
    
	
	
		
	
	- (void) assert:(NSString*)value
	{
		NSString* str = self.ns;
		ASSERT([str isEqualToString:value]);
	}
	


@end










@implementation StableString (_)


	
@end






@implementation MutableString (_)

    
    

    - (void) append:(String*)value
    {
		NSString* v = value.ns;
		
		
        [self appendNS:v];
    }
	- (void) appendChar:(unichar)value
    {
        [self appendNS:[NSString stringWithCharacters:&value length:1]];
    }


    - (void) insert:(String*)value
    {
        [self insertAtNS :0 :value.ns];
    }
    - (void) insertAt :(Int)index :(String*)value
    {
        [self insertAtNS :index :value.ns];
    }
    
    - (void) insertChar:(Char)value 
    {
        [self insertAtNS :0 :[NSString stringWithCharacters:&value length:1]];
    }
    - (void) insertCharAt :(Int)index :(Char)value
    {
        [self insertAtNS :index :[NSString stringWithCharacters:&value length:1]];
    }
    
	
	- (void) removeAt:(Int)index
	{
		[self removeRange:index :1];
	}


	- (void) replace:(String*)target :(String*)substitution
	{
		[self replaceNS :target.ns :substitution.ns];
	}

    
@end











void MutableString_selfTest(void)
{
	MutableString* str = [MutableString createWithString:STR(@"")];
	[str assert:@""];
	
	[str append:[String create:@"111"]];
	[str assert:@"111"];
	
	[str appendNS:@"222"];
	[str assert:@"111222"];
	
	[str insertAtNS :3 :@"abc"];
	[str assert:@"111abc222"];
	
	[str removeAt:3];
	[str assert:@"111bc222"];
	
	[str removeRange:3 :2];
	[str assert:@"111222"];
	
	[str replaceNS:@"222" :@"555"];
	[str assert:@"111555"];
	
	[str setCharAt :1 :CHAR(2)];
	[str assert:@"121555"];
}



void String_selfTest(void)
{

	String* testingStr = [String create:@"testing"];
	
	ASSERT([String create:@""].length == 0);
	ASSERT([String create:@"-"].length == 1);
	ASSERT([String create:@"-"].length == 1);

	ASSERT(String_empty().length == 0);

	[[testingStr startAt:1] assert:@"esting"];
	[[testingStr substring:1 :3] assert:@"est"];
	[[testingStr startEndAt :1 :5] assert:@"estin"];
	


	[STR(@"   ") indexOf:STR(@" ")];
	[STR(@"   ") replacement :0 :0 :STR(@" ")];
	
	[STR(@"   ") matchExcelPattern :STR(@" ")];
	
		

	MutableString_selfTest();
}








