





#import "DataType.h"









NS_INLINE NSRange StructList_makeNSRange(Int i, Int s) { return NSMakeRange(toUInt(i * s), toUInt(s)); }






@implementation StructList (_)

    

    - (void) at:(Int)index or:(void*)def :(void*)buffer
    {
        if ([self isValidIndex:index])
            [self at:index :buffer];
        else
            memmove(buffer, def, self.dataSize);
    }


    - (StructListEnumerator*) each
    {
        return [StructListEnumerator create :self :NO];
    }

    - (StructListEnumerator*) reversedEach
    {
        return [StructListEnumerator create :self :YES];
    }



    /*
     - (Int) findFirstIndexOfValue:(ConstPntr)value
     {
     return Int_var([self findFirstIndexOfValue_:value]);
     }
     - (Int) findFirstIndexOfValue:(ConstPntr)value :(Int)defIndex
     {
     return Int_varOr([self findFirstIndexOfValue_:value], defIndex);
     }
     - (NubleInt) findFirstIndexOfValue_:(ConstPntr)value
     {
     for (Int i = 0; i < self.count; i++)
     if ([self isSmaller:^(ConstPntr p) { return Bool_toNuble(memcmp(p, value, self.size) == 0); } :i])
     return Int_toNuble(i);
     
     return Int_nuble();
     }
     
     - (Bool) findValue:(ConstPntr)value
     {
     return [self findFirstIndexOfValue_:value].hasVar;
     }
     */



    - (void) first:(Pntr)buffer
    {
        ASSERT(self.count > 0);
        [self at:0 :buffer];
    }

    - (void) first:(ConstPntr)def :(Pntr)buffer
    {
        if (self.count > 0)
            [self at:0 :buffer];
        else
            memmove(buffer, def, self.dataSize);
    }


    - (void) last:(Pntr)buffer
    {
        ASSERT(self.count > 0);
        [self at:self.lastIndex :buffer];
    }

    - (void) last:(ConstPntr)def :(Pntr)buffer
    {
        if (self.count > 0)
            [self at:self.lastIndex :buffer];
        else
            memmove(buffer, def, self.dataSize);
    }



    - (Bool) anyOf:(ConstPntr_Confirm)confirm
    {
        NSMutableData* data = [NSMutableData dataWithLength:toUInt(self.dataSize)];
    
		FOR_EACH_INDEX(i, self)
        {
            [self at :i :[data mutableBytes]];
			if (confirm([data mutableBytes]))
				return YES;
		}
        
		return NO;	           
    }
    
    - (Bool) allOf:(ConstPntr_Confirm)confirm
    {
        NSMutableData* data = [NSMutableData dataWithLength:toUInt(self.dataSize)];
    
		FOR_EACH_INDEX(i, self)
        {
            [self at :i :[data mutableBytes]];
			if (confirm([data mutableBytes]) == NO)
				return NO;
		}
        
		return YES;	    
    }




@end




@implementation StructMutableList (_)

    - (void) append:(const void*)value1
    {
        [self insertAt :self.nextIndex :value1];
    }

    - (void) append :(const void*)value1 :(const void*)value2
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
    }

    - (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
        [self insertAt :self.nextIndex :value3];
    }

    - (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3 :(const void*)value4
    {
        [self insertAt :self.nextIndex :value1];
        [self insertAt :self.nextIndex :value2];
        [self insertAt :self.nextIndex :value3];
        [self insertAt :self.nextIndex :value4];
    }


    - (void) removeFirst
    {
        ASSERT(self.count > 0);
        [self removeAt:0];
    }

    - (void) removeLast
    {
        ASSERT(self.count > 0);
        [self removeAt:self.lastIndex];
    }



@end











@interface StructStableListImpl : StructStableList
	{
	@public
		Int my_count;
		Int my_dataSize;
		NSData* my_subject;
	}
    
    + (StructStableListImpl*) create:(Int)count :(Int)dataSize :(NSData*)subject;
    
    + (StructStableListImpl*) seal:(Int)count :(Int)dataSize :(NSMutableData*)subject;
    
@end

@implementation StructStableListImpl

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (StructStableListImpl*) create:(Int)count :(Int)dataSize :(NSData*)subject
    {
        StructStableListImpl* result = [[[StructStableListImpl alloc] init] autorelease];
        result->my_count = count;
		result->my_dataSize = dataSize;
        result->my_subject = [[NSData alloc] initWithData:subject];
        return result;
    }
    
    + (StructStableListImpl*) seal:(Int)count :(Int)dataSize :(NSMutableData*)subject
    {
        StructStableListImpl* result = [[[StructStableListImpl alloc] init] autorelease];
        result->my_count = count;
		result->my_dataSize = dataSize;
        result->my_subject = [subject retain];
        return result;
    }
    
    
    
    - (Int) count { return my_count; }
    
	- (Int) dataSize { return my_dataSize; }

	
    - (StructStableList*) toStable
    {
        return self;
    }
    
	
    - (void) at:(Int)index :(void*)buffer
    {
        NSRange range = StructList_makeNSRange(index, my_dataSize);
		[my_subject getBytes:buffer range:range];
    }

/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index
    {
        ConstPntr p = [my_subject bytes] + StructList_makeNSRange(index, my_size).location;
        return isSmaller(p);
    }

    - (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex
	{
		ConstPntr x = [my_subject bytes] + StructList_makeNSRange(xIndex, my_size).location;
		ConstPntr y = [my_subject bytes] + StructList_makeNSRange(yIndex, my_size).location;
		return isSmaller(x, y);
	}
*/


@end







@interface StructMutableListImpl : StructMutableList
	{
	@public
		Int my_count;
        Int my_dataSize;
		NSMutableData* my_subject;
	}
    
    + (StructMutableListImpl*) create:(Int)dataSize :(Int)capacity;
	
@end

@implementation StructMutableListImpl

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (StructMutableListImpl*) create:(Int)dataSize :(Int)capacity
    {
        StructMutableListImpl* result = [[[StructMutableListImpl alloc] init] autorelease];
        result->my_count = 0;
		result->my_dataSize = dataSize;
        result->my_subject = [[NSMutableData alloc] initWithCapacity:toUInt(capacity * dataSize)];
        return result;
    }
    
    
    
    - (Int) count { return my_count; }
	
	- (Int) dataSize { return my_dataSize; }
	
    
    - (StructStableList*) toStable
    {
        return [StructStableListImpl create:my_count :my_dataSize :my_subject];
    }
    



    - (void) at:(Int)index :(void*)buffer
    {
		ASSERT(0 <= index && index <= self.lastIndex);
	
        NSRange range = StructList_makeNSRange(index, my_dataSize);
		[my_subject getBytes:buffer range:range];
    }
	
/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index
    {
        ConstPntr p = [my_subject bytes] + StructList_makeNSRange(index, my_size).location;
        return isSmaller(p);
    }
	
	- (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex
	{
		ConstPntr x = [my_subject bytes] + StructList_makeNSRange(xIndex, my_size).location;
		ConstPntr y = [my_subject bytes] + StructList_makeNSRange(yIndex, my_size).location;
		return isSmaller(x, y);
	}
*/

	- (StructStableList*) seal
    {
        StructStableList* result = [StructStableListImpl seal:my_count :my_dataSize :[my_subject autorelease]];
        my_count = 0;
        my_subject = nil;
        return result;
    }
    
	
	
	
	- (void*) mutableBytes
	{
		return [my_subject mutableBytes];
	}
	
	
	- (void) insertZeroAt :(Int)index
	{
		ASSERT(index <= self.nextIndex);
		
		UInt requiredLength = toUInt((my_count + 1) * self.dataSize);
        
        if ([my_subject length] == 0)
            [my_subject setLength:requiredLength * 2];
        else if ([my_subject length] < requiredLength)
            [my_subject setLength:[my_subject length] * 2];
        		
		NSRange range = StructList_makeNSRange(index, my_dataSize);
		
		void* ptr = [my_subject mutableBytes] + range.location;
        UInt s = [my_subject length] - (toUInt(index + 1) * range.length);
		memmove(ptr + range.length, ptr, s);
		
		memset(ptr, 0, range.length);
        
		my_count += 1;	
	}
	

	- (void) insertAt :(Int)index :(const void*)value 
	{
		ASSERT(index <= self.nextIndex);
		
		UInt requiredLength = toUInt((my_count + 1) * self.dataSize);
        
        if ([my_subject length] == 0)
            [my_subject setLength:requiredLength * 2];
        else if ([my_subject length] < requiredLength)
            [my_subject setLength:[my_subject length] * 2];
        		
		NSRange range = StructList_makeNSRange(index, my_dataSize);
		
		void* ptr = [my_subject mutableBytes] + range.location;
        UInt s = [my_subject length] - (toUInt(index + 1) * range.length);
		memmove(ptr + range.length, ptr, s);
		
		[my_subject replaceBytesInRange:range withBytes:value];
        
		my_count += 1;
	}
	
    
    - (void) modifyAt :(Int)index :(const void*)value 
    {
		NSRange range = StructList_makeNSRange(index, my_dataSize);
		[my_subject replaceBytesInRange:range withBytes:value];
    }    



	- (void) removeAll
	{
		[my_subject setLength:0];
	}


	- (void) removeAt:(Int)index 
    {
		NSRange range = StructList_makeNSRange(index, my_dataSize);
		void* ptr = [my_subject mutableBytes] + range.location;
        UInt s = [my_subject length] - (toUInt(index + 1) * range.length);
        
		memmove(ptr, ptr + range.length, s);
        
        my_count -= 1;
	}    



	- (void) appendFrom :(StructList*)fromList :(Int)fromIndex
	{
		[self insertAtFrom :self.nextIndex :fromList :fromIndex];
	}

	- (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex
	{
		ASSERT(self.dataSize == fromList.dataSize);
				
		[self insertZeroAt :atIndex];
		[self modifyAtFrom :atIndex :fromList :fromIndex];
	}
		    
	- (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex
	{
		ASSERT(self.dataSize == fromList.dataSize);
		
		NSRange range = StructList_makeNSRange(atIndex, my_dataSize);
		
		void* ptr = [my_subject mutableBytes] + range.location;
				
		[fromList at :fromIndex :ptr];		
	}
		    
    
@end































@implementation StructList

    - (Int) count { ABSTRACT_METHOD(Int) }

    - (Int) dataSize { ABSTRACT_METHOD(Int) }

    - (void) at:(Int)index :(void*)buffer { ABSTRACT_METHOD_VOID }


    // - (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex { ABSTRACT_METHOD(NubleBool) }

    - (StructStableList*) toStable { ABSTRACT_METHOD_NIL }

@end


@implementation StructStableList

    + (StructStableList*) createEmpty:(Int)dataSize
    {
        static StructStableList* result = nil;
        
        if (result == nil)
            result = [[StructStableListImpl create:0 :dataSize :[NSData data]] retain];
        
        return result;
    }

@end


@implementation StructMutableList 

    + (StructMutableList*) create:(Int)dataSize
    {
        return [StructMutableList create:dataSize :10];
    }

    + (StructMutableList*) create:(Int)dataSize :(Int)capacity 
    {
        return [StructMutableListImpl create:dataSize :capacity];
    }

    - (StructStableList*) seal { ABSTRACT_METHOD_NIL }

    - (void*) mutableBytes { ABSTRACT_METHOD_NIL; }


    - (void) insertZeroAt :(Int)index { ABSTRACT_METHOD_VOID }

    - (void) insertAt :(Int)index :(const void*)value { ABSTRACT_METHOD_VOID }

    - (void) modifyAt :(Int)index :(const void*)value { ABSTRACT_METHOD_VOID }


    - (void) removeAll { ABSTRACT_METHOD_VOID }

    - (void) removeAt:(Int)index { ABSTRACT_METHOD_VOID }    


    - (void) appendFrom :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }
    - (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }
    - (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex { ABSTRACT_METHOD_VOID }

@end













void UIntList_assertStringList(UIntList* self, NSString* value);
void UIntList_assertStringList(UIntList* self, NSString* value)
{
	ASSERT(Int_isSmallerXYU(self.count, [value length]) == Unknown);

	for (NSUInteger i = 0; i < [value length]; i++)
	{
		NubleUInt u = UInt_parseChar([value characterAtIndex:i]);
		ASSERT(u.hasVar && u.vd == [self at:toInt(i)]);
	}
}


	
	

void StructList_selfTest(void)
{
	{
		UIntMutableList* list = [UIntMutableList create];
		UIntList_assertStringList(list, @"");

		[list append:5];
		UIntList_assertStringList(list, @"5");

		[list append:6];
		[list append:7];
		UIntList_assertStringList(list, @"567");

		[list insertAt :0 :4];
		UIntList_assertStringList(list, @"4567");

		[list insertAt :4 :8];
		UIntList_assertStringList(list, @"45678");

		[list removeAt:2];
		UIntList_assertStringList(
		list, @"4578");

		[list removeAt:3];
		UIntList_assertStringList(list, @"457");

		[list removeAt:0];
		UIntList_assertStringList(list, @"57");
	}
	

	
	
	
}





