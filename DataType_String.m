




#import "DataType.h"








@interface StableStringImpl : StableString
    {
    @public 
		NSString* my_subject;
		Int my_start;
		Int my_length;
    }
        
		
    + (StableStringImpl*) _create :(NSString*)str :(Int)start :(Int)length;
	
	+ (StableStringImpl*) seal:(NSMutableString*)str;
	

@end



@implementation StableStringImpl

    - (void) dealloc 
    {
        [my_subject release];
        [super dealloc];
    }
    
	
        
    + (StableStringImpl*) _create :(NSString*)str :(Int)start :(Int)length
    {		
		StableStringImpl* result = [[[StableStringImpl alloc] init] autorelease];
        
        if ([str isKindOfClass:[NSMutableString class]])
            result->my_subject = [[NSString alloc] initWithString:str];
        else
            result->my_subject = [str retain];

        result->my_start = start;
        result->my_length = length;
		        
        return result;
    }
    

		
	
	+ (StableStringImpl*) seal:(NSMutableString*)str
	{	
        StableStringImpl* result = [[[StableStringImpl alloc] init] autorelease];
		result->my_subject = [str retain];
        result->my_start = 0;
        result->my_length = toInt([result->my_subject length]);
        return result;
	}
    
    
    
    - (NSString*) ns
    {
		if (toUInt(my_start) == 0 && toUInt(my_length) == my_subject.length)
			return my_subject;
	
        NSRange range = NSMakeRange(toUInt(my_start), toUInt(my_length));
        return [my_subject substringWithRange:range];
    }
    
    - (Int) length
    {
        return my_length;
    }
    
    - (Char) charAt:(Int)index
    {
        return [my_subject characterAtIndex:toUInt(index + my_start)];
    }

    
    
    
    - (StableString*) substring:(Int)start :(Int)length
    {
        ASSERT([self isValidRange :start :length]);
        return [StableStringImpl _create :my_subject :(start + my_start) :length];
    }
    
    
    
	
	- (StableString*) replacement :(Int)start :(Int)length :(String*)value
	{
		SELFTEST_START
			[[STR(@"abc") replacement :0 :0 :STR(@"123")] assert:@"123abc"];
			[[STR(@"abc") replacement :0 :1 :STR(@"123")] assert:@"123bc"];
			[[STR(@"abc") replacement :0 :3 :STR(@"123")] assert:@"123"];
		
			[[STR(@"abc") replacement :1 :0 :STR(@"123")] assert:@"a123bc"];
			[[STR(@"abc") replacement :1 :1 :STR(@"123")] assert:@"a123c"];
			[[STR(@"abc") replacement :1 :2 :STR(@"123")] assert:@"a123"];

			[[STR(@"abc") replacement :2 :0 :STR(@"123")] assert:@"ab123c"];
			[[STR(@"abc") replacement :2 :1 :STR(@"123")] assert:@"ab123"];
		SELFTEST_END
		
		
		ASSERT([self isValidRange :(start + my_start) :length]);
		
        NSRange range = NSMakeRange(toUInt(start + my_start), toUInt(length));
		
		NSString* result = [my_subject stringByReplacingCharactersInRange:range withString:value.ns];
		return [StableString create:result];
	}
		
    

@end












@interface MutableStringImpl : MutableString
    {
    @public 
         NSMutableString* my_subject;
    }

    + (MutableStringImpl*) createWithCapacity:(Int)capacity;

@end



@implementation MutableStringImpl


    - (NSString*) description
    {
        return self.ns;
    }




    - (void) dealloc 
    {
        [my_subject release];
        [super dealloc];
    }

   
    + (MutableStringImpl*) createWithCapacity:(Int)capacity
    {
        MutableStringImpl* result = [[[MutableStringImpl alloc] init] autorelease];
        result->my_subject = [[NSMutableString alloc] initWithCapacity:toUInt(capacity)];
        return result;
    }
    




    - (NSString*) ns
    {
        return [NSString stringWithString:my_subject];
    }
    
    - (Int) length
    {
        return toInt([my_subject length]);
    }


	
	- (StableString*) toStable
    {
        return [StableString create:my_subject];;
    }

    - (StableString*) seal
    {
        StableString* result = [StableStringImpl seal:[my_subject autorelease]];
		my_subject = nil;
		return result;
    }
	
	
        
    - (Char) charAt:(Int)index
    {
        return [my_subject characterAtIndex:toUInt(index)];
    }
    
    - (StableString*) substring:(Int)start :(Int)length
    {
        StableString* str = [StableStringImpl _create:self.ns :0 :self.length];
		return [str substring:start :length];
    }
    
	- (StableString*) replacement :(Int)start :(Int)length :(String*)value
	{
		ASSERT([self isValidRange :start :length]);
		
        NSRange range = NSMakeRange(toUInt(start), toUInt(length));
		
		NSString* result = [my_subject stringByReplacingCharactersInRange:range withString:value.ns];
		return [StableString create:result];
	}
		
    
    
    
    
	
    - (void) setCharAt :(Int)index :(Char)value
    {
        NSString* str = [NSString stringWithCharacters:&value length:1];
        NSRange range = NSMakeRange(toUInt(index), 1);
        [my_subject replaceCharactersInRange:range withString:str];
    }
    

    - (void) appendNS:(NSString*)value
    {
        [my_subject appendString:value];
    }


    - (void) insertAtNS :(Int)index :(NSString*)value
	{
		[my_subject insertString:value atIndex:toUInt(index)];
	}
	
	
	- (void) removeRange:(Int)index :(Int)length
	{
		[my_subject deleteCharactersInRange:NSMakeRange(toUInt(index), toUInt(length))];
	}


	- (Int) replaceNS :(NSString*)target :(NSString*)substitute
	{
		NSUInteger result = [my_subject 
			replaceOccurrencesOfString:target 
			withString:substitute
			options:NSLiteralSearch
			range:NSMakeRange(0, toUInt(self.length))];
			
		return toInt(result);
	}

		
	- (void) replace :(Int)start :(Int)length :(String*)value
	{
		ASSERT([self isValidRange :start :length]);
		
		NSRange range = NSMakeRange(toUInt(start), toUInt(length));
		
		[my_subject replaceCharactersInRange:range withString:value.ns];
	}
	
			
@end














@implementation String


    - (NSString*) description
    {
        return self.ns;
    }

    
    
    + (StableString*) create:(NSString*)str
    {
		return (str != nil) ? [StableStringImpl _create:str :0 :toInt([str length])] : nil;
    }
	
    + (StableString*) createChar:(Char)ch
    {
        return [StableString createChar:ch];
    }
	
    
    
    
    - (StableString*) toStable { ABSTRACT_METHOD_NIL }

    - (NSString*) ns { ABSTRACT_METHOD_NIL }
        
    - (Int) length { ABSTRACT_METHOD(Int) }

    - (Int) count { return self.length; }


    - (Char) charAt:(Int)index { ABSTRACT_METHOD(Char) }

    - (StableString*) substring :(Int)start :(Int)length { ABSTRACT_METHOD_NIL }
 
	- (StableString*) replacement :(Int)start :(Int)length :(String*)value { ABSTRACT_METHOD_NIL }



@end
















@implementation StableString
 
    - (NSString*) description
    {
        return self.ns;
    }


    + (StableString*) create:(NSString*)str
    {
		return (str != nil) ? [StableStringImpl _create:str :0 :toInt([str length])] : nil;
    }

	+ (StableString*) createChar:(Char)ch
	{
		return [String create:[NSString stringWithCharacters :&ch length:1]];
	}
	
    - (StableString*) toStable
    {
        return self;
    }
    
@end






@implementation MutableString
 
    - (NSString*) description
    {
        return self.ns;
    }

 
    + (MutableString*) create:(Int)capacity
    {
        return [MutableStringImpl createWithCapacity:capacity];
    }

	+ (MutableString*) createWithString:(String*)value
	{
		MutableString* result = [MutableString create:[value length]];
		[result append:value];
		return result;
	}    

	+ (MutableString*) createNSString:(NSString*)value
	{
		MutableString* result = [MutableString create:toInt([value length])];
		[result appendNS:value];
		return result;
	}
	    
    
    
    - (void) setCharAt :(Int)index :(Char)value { ABSTRACT_METHOD_VOID }

    
    - (void) appendNS:(NSString*)value { ABSTRACT_METHOD_VOID }
    
    
    - (void) insertAtNS :(Int)index :(NSString*)value { ABSTRACT_METHOD_VOID }
    
	
    - (void) removeRange:(Int)index :(Int)length { ABSTRACT_METHOD_VOID }
	
	
    - (Int) replaceNS:(NSString*)target :(NSString*)substitute { ABSTRACT_METHOD(Int) }
    
 
	- (void) replace :(Int)start :(Int)length :(String*)value { ABSTRACT_METHOD_VOID }


    
    - (StableString*) seal { ABSTRACT_METHOD_NIL }
	
	
    
@end






















