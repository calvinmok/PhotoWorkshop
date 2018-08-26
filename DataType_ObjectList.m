





#import "DataType.h"
























@interface ObjectStableListImpl : ObjectStableList
	{
	@public
		NSArray* my_subject;
	}
    
    + (ObjectStableListImpl*) create:(NSArray*)data;

    + (ObjectStableListImpl*) seal:(NSMutableArray*)data;
	
@end




@interface ObjectMutableListImpl : ObjectMutableList
	{
	@public
		NSMutableArray* my_subject;
	}

    + (ObjectMutableListImpl*) create:(Int)capacity;

@end
















@implementation ObjectStableListImpl 

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    + (ObjectStableListImpl*) create:(NSArray*)data;
    {
        ObjectStableListImpl* result = [[[ObjectStableListImpl alloc] init] autorelease];
        result->my_subject = [[NSArray alloc] initWithArray:data];
        return result;
    }
	
	
    + (ObjectStableListImpl*) seal:(NSMutableArray*)data
	{
        ObjectStableListImpl* result = [[[ObjectStableListImpl alloc] init] autorelease];
        result->my_subject = [data retain];
        return result;
	}
	
	



	- (Int) count
	{
		return toInt([my_subject count]);
	}
	
	- (id) at:(Int)index
	{
		return [my_subject objectAtIndex:toUInt(index)];
	}

	
	
	- (ObjectStableList*) toStable
	{
		return self;
	}

@end










@implementation ObjectMutableListImpl 

    - (void) dealloc
    {
        [my_subject release];
        [super dealloc];
    }
    
    
    
    
    
    + (ObjectMutableListImpl*) create:(Int)capacity
    {     
        ObjectMutableListImpl* result = [[[ObjectMutableListImpl alloc] init] autorelease];
        result->my_subject = [[NSMutableArray alloc] initWithCapacity:toUInt(capacity)];
        return result;
    }


	- (ObjectStableList*) seal
	{
        ObjectStableList* result = [ObjectStableListImpl seal:[my_subject autorelease]];
        my_subject = nil;
        return result;
	}
	
	- (ObjectStableList*) toStable
	{
		return [ObjectStableListImpl create:my_subject];
	}


	- (Int) count
	{
		return toInt([my_subject count]);
	}
	
	- (id) at:(Int)index
	{
		ASSERT([my_subject count] > 0); 
		ASSERT(toUInt(index) <= [my_subject count] - 1);
		return [my_subject objectAtIndex:toUInt(index)];
	}
		
	
	
	

	- (void) insertAt :(Int)index :(id)item 
	{
		[my_subject insertObject:item atIndex:toUInt(index)];
	}
	- (void) append:(id)item
	{
		[my_subject addObject:item];
	}
	
	
	- (void) modifyAt :(Int)index :(id)item 
	{
		[[[self at:index] retain] autorelease];
		[my_subject replaceObjectAtIndex:toUInt(index) withObject:item];
	}
	
	- (void) swap :(Int)x :(Int)y
	{
		[my_subject exchangeObjectAtIndex:toUInt(x) withObjectAtIndex:toUInt(y)];
	}
	
	
		
	- (void) removeAll 
	{ 
		FOR_EACH_INDEX(i, self)
			[[[self at:i] retain] autorelease];
		
		[my_subject removeAllObjects];
	}
	
	- (void) removeAt:(Int)index
	{
		[[[self at:index] retain] autorelease];

		[my_subject removeObjectAtIndex:toUInt(index)];
	}
	
	- (void) removeEvery:(id)item
	{
		for (Int i = self.count; i > 0; --i)
		{
			if ([self at:i - 1] == item)
				[self removeAt:i - 1];
		}
	}

	

@end














@implementation ObjectList

	- (Int) count { ABSTRACT_METHOD(Int) }
	
	- (id) at:(Int)index          { ABSTRACT_METHOD_NIL }
	- (id) at:(Int)index :(id)def { ABSTRACT_METHOD_NIL }

	- (ObjectStableList*) toStable { ABSTRACT_METHOD_NIL }
	- (ObjectMutableList*) toMutable 
    {
        ObjectMutableList* result = [ObjectMutableList create:self.count];
        
        FOR_EACH_INDEX(i, self)
            [result append:[self at:i]];
            
        return result;        
    }


@end
	
    
    
    
@implementation ObjectStableList
 
	+ (ObjectStableList*) empty
	{
		static ObjectStableList* result = nil;
		
		if (result == nil)
			result = [[ObjectStableListImpl create:[NSArray array]] retain];

		return result;
	}

@end




@implementation ObjectMutableList 
	
    + (ObjectMutableList*) create
    {
        return [ObjectMutableListImpl create:10];
    }
    
	+ (ObjectMutableList*) create:(Int)capacity
    {
        return [ObjectMutableListImpl create:capacity];
    }
    
    
	- (ObjectStableList*) seal { ABSTRACT_METHOD_NIL; }
	
    
    - (void) insertAt :(Int)index :(id)item { ABSTRACT_METHOD_VOID; }
	
	- (void) append:(id)item { ABSTRACT_METHOD_VOID; }
    
    
    - (void) modifyAt :(Int)index :(id)item { ABSTRACT_METHOD_VOID; }
    
	- (void) swap :(Int)x :(Int)y { ABSTRACT_METHOD_VOID; }
		
	
	- (void) removeAll { ABSTRACT_METHOD_VOID; }
		
	- (void) removeAt:(Int)index { ABSTRACT_METHOD_VOID; }
		
	- (void) removeEvery:(id)item { ABSTRACT_METHOD_VOID; }
	
	
@end












@implementation ObjectList (_)

	- (id) at:(Int)index :(id)def
	{
		return [self isValidIndex:index] ? [self at:index] : def;
	}
    
    
	- (Bool) anyOfValue:(id)value
    {    
		FOR_EACH_INDEX(i, self)
			if ([self at:i] == value)
				return YES;
		
		return NO;	
    }

    - (Int) countOfValue:(id)value
    {
		Int result = 0;
		FOR_EACH_INDEX(i, self)
			result += ([self at:i] == value) ? 1 : 0;
			
		return result;    
    }
    
    - (NubleInt) firstIndexOfValue_:(id)value
    {
		FOR_EACH_INDEX(i, self)
			if ([self at:i] == value)
				return Int_toNuble(i);
		
		return Int_nuble();	    
    }
     
    - (NubleInt) lastIndexOfValue_:(id)value
    {
		FOR_EACH_INDEX_IN_REV(i, self)
			if ([self at:i] == value)
				return Int_toNuble(i);
		
		return Int_nuble();	        
    }
    
    
    

    - (Bool) anyOf:(ID_Confirm)confirm
    {
        SELFTEST_START
            StringMutableList* list = StringMutableList_fromStringList(STR(@"J,K,L"));
		
            ASSERT([list anyOf:^(String* s) { return [s eq:STR(@"J")]; }]);
            ASSERT([list anyOf:^(String* s) { return [s eq:STR(@"K")]; }]);
            ASSERT([list anyOf:^(String* s) { return [s eq:STR(@"L")]; }]);
            ASSERT([list anyOf:^(String* s) { return [s eq:STR(@"382095")];}] == NO);

        SELFTEST_END
    
		FOR_EACH_INDEX(i, self)
			if (confirm([self at:i]))
				return YES;
		
		return NO;	    
    }
    
    - (Bool) allOf:(ID_Confirm)confirm
    {
		FOR_EACH_INDEX(i, self)
			if (confirm([self at:i]) == NO)
				return NO;
		
		return YES;
    }

    - (Int) countOf:(ID_Confirm)confirm
    {
		Int result = 0;
		FOR_EACH_INDEX(i, self)
			result += confirm([self at:i]) ? 1 : 0;
			
		return result;    
    }    

    
    - (ID) firstOf:(ID_Confirm)confirm { return ID_var([self firstOf_:confirm]); }
    - (NubleID) firstOf_:(ID_Confirm)confirm
    {
		FOR_EACH_INDEX(i, self)
        {
            id value = [self at:i];
			if (confirm(value))
				return ID_toNuble(value);
		}
        
		return ID_nuble();    
    }
    
    - (ID) lastOf:(ID_Confirm)confirm { return ID_var([self lastOf_:confirm]); }
    - (NubleID) lastOf_:(ID_Confirm)confirm
    {
		FOR_EACH_INDEX_IN_REV(i, self)
        {
            id value = [self at:i];
			if (confirm(value))
				return ID_toNuble(value);
		}
        
		return ID_nuble();        
    }
    
    - (NubleInt) firstIndexOf_:(ID_Confirm)confirm
    {
		FOR_EACH_INDEX(i, self)
			if (confirm([self at:i]))
				return Int_toNuble(i);
		
		return Int_nuble();        
    }

    - (NubleInt) lastIndexOf_:(ID_Confirm)confirm
    {
		FOR_EACH_INDEX_IN_REV(i, self)
			if (confirm([self at:i]))
				return Int_toNuble(i);
		
		return Int_nuble();      
    }
        
    
    
	
    
    - (ObjectMutableList*) listOf:(ID_Confirm)confirm
    {
		ObjectMutableList* result = [ObjectMutableList create:4];
		
		FOR_EACH_INDEX(i, self)
		{
			id item = [self at:i];
			if (confirm(item))
				[result append:item];
		}
		
		return result;
    }
    
    
    
	- (ObjectListEnumerator*) enumOf:(ID_Confirm)confirm
	{
		return [ObjectListFilteredEnumerator create :self :NO :confirm];
	}
	
	
    
	
	

	- (ObjectListEnumerator*) each
	{
		SELFTEST_START
		
		{
			StringMutableList* allItem = [StringMutableList create];
			[allItem append:STR(@"a")];
			[allItem append:STR(@"b")];
			[allItem append:STR(@"c")];
			
			Int count = 0;
			FOR_EACH(StringList, item, allItem.each)
			{
				if (count == 0) ASSERT(item.index == 0 && [item.var eq:STR(@"a")]);
				if (count == 1) ASSERT(item.index == 1 && [item.var eq:STR(@"b")]);
				if (count == 2) ASSERT(item.index == 2 && [item.var eq:STR(@"c")]);
				count++;
			}
		}
		
		{
			StringMutableList* allItem = [StringMutableList create];

			FOR_EACH(StringList, item, allItem.each)
				ASSERT(NO);
		}			
		
		SELFTEST_END
	
		return [ObjectListEnumerator create :self :NO];
	}

	- (ObjectListEnumerator*) reversedEach
	{
		return [ObjectListEnumerator create :self :YES];
	}

	




		
    - (id) first  { ASSERT(self.count >= 1); return [self at:0]; }
	- (id) second { ASSERT(self.count >= 2); return [self at:1]; }
	- (id) third  { ASSERT(self.count >= 3); return [self at:2]; }
	- (id) fourth { ASSERT(self.count >= 4); return [self at:3]; }
	
    - (id) last { ASSERT(self.count >= 1); return [self at:self.lastIndex]; }
	
        	
    - (id) firstOrNil
    {
        return (self.count > 0) ? [self at:0] : nil;
    }
    
    - (id) lastOrNil
    {
        return (self.count > 0) ? [self at:self.lastIndex] : nil;
    }

		
@end



@implementation ObjectMutableList (_)


	- (void) insert:(id)item
	{
		[self insertAt :0 :item];
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
	
	
	- (void) removeDuplication:(ID_IsEqual)isEqual
	{
		SELFTEST_START
		
		StringMutableList* list;
		
		list = StringMutableList_fromStringList(STR(@"J,K,L"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		list = StringMutableList_fromStringList(STR(@"J,K,L,J"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		list = StringMutableList_fromStringList(STR(@"J,K,J,J,L,L,L,K"));
		[list removeDuplication:^(String* x, String* y) { return [x eq:y]; } ];
		[list assert:STR(@"J,K,L")];

		SELFTEST_END
		
		
		FOR_EACH_INDEX(i, self)
		{
			id x = [self at:i];
			
			FOR_EACH_INDEX_IN_REV(j, self)
			{
				if (j <= i) break;
				
				if (isEqual(x, [self at:j]))
					[self removeAt:j];
			}
		}
	}
	
	- (void) removeMatch:(ID_Confirm)confirm
	{
		FOR_EACH_INDEX(i, self)
		{
			if (confirm([self at:i]))
			{
				[self removeAt:i];
				i--;
			}
		}
	}
	
	
	- (void) replaceAll :(ObjectList*)allItem
	{
		[self removeAll];
		
		FOR_EACH_INDEX(i, allItem)
			[self append:[allItem at:i]];
	}
	
	
	
    - (void) moveToFirst :(Int)index
    {
        if (self.count <= 1)
            return;
            
        id item = [self at:index];        
        [self removeAt:index];
        [self insertAt :0 :item];
    }
    
    - (void) moveToLast :(Int)index
    {
        if (self.count <= 1)
            return;
            
        id item = [self at:index];
        [self removeAt:index];
        [self append :item];
    }
	
		
@end

















void ObjectList_selfTest(void)
{
	{
		StringMutableList* list = [StringMutableList create];

		[list append:STR(@"J")];
		[list assert:STR(@"J")];
				
		[list append:STR(@"K")];
		[list append:STR(@"L")];
		[list assert:STR(@"J,K,L")];
		
		[list insertAt :0 :STR(@"I")];
		[list assert:STR(@"I,J,K,L")];
		
		[list insertAt :0 :STR(@"H")];
		[list assert:STR(@"H,I,J,K,L")];
		
		[list removeFirst];
		[list assert:STR(@"I,J,K,L")];

		[list removeLast];
		[list assert:STR(@"I,J,K")];
		
		[list removeAt:1];
		[list assert:STR(@"I,K")];
		
		[list seal];
	}
	
	
	
	
	
}






@implementation  NSObject_ListBase : ListBase

    - (Class) type { return [NSObject class]; } 

    - (NSObject*) NSObject_at:(Int)index { ABSTRACT_METHOD_NIL }

@end













