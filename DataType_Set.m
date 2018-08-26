




#import "DataType.h"



@class ObjectSetItem;
OBJECT_NUBLE_TEMPLATE(ObjectSetItem)

@interface ObjectSetItem : ObjectBase
    {
        ObjectKeyValue my_keyValue;
        Int my_hash;
        NubleObjectSetItem my_next;
    }
    
    + (ObjectSetItem*) create :(ObjectKeyValue)keyValue :(Int)hash;
	
            
    @property(readonly) ObjectKeyValue keyValue;
    @property(readonly) Int hash;
    @property(readonly) NubleObjectSetItem next;
    
    - (void) setNext :(NubleObjectSetItem)next;
        
    
	@property(readonly) ObjectSetItem* lastSibling;
    
    - (void) removeLastSibling;
    
@end

OBJECT_LIST_INTERFACE_TEMPLATE(ObjectSetItem, NSObject)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(ObjectSetItem, NSObject)


STRUCT_NUBLE_TEMPLATE(NubleObjectSetItem)
STRUCT_LIST_INTERFACE_TEMPLATE(NubleObjectSetItem)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(NubleObjectSetItem)


@implementation ObjectSetItem

    + (ObjectSetItem*) create :(ObjectKeyValue)keyValue :(Int)hash
    {
        ObjectSetItem* result = [[[ObjectSetItem alloc] init] autorelease];
        result->my_keyValue = ObjectKeyValue_retain(keyValue);
        result->my_hash = hash;
        result->my_next = ObjectSetItem_nuble();
        return result;
    }
    
    - (void) dealloc
    {
        ObjectKeyValue_release(my_keyValue);
        [super dealloc];
    }	
    
            
    - (ObjectKeyValue) keyValue { return my_keyValue; }
    - (Int) hash { return my_hash; }
    - (NubleObjectSetItem) next { return my_next; }
    
    - (void) setNext :(NubleObjectSetItem)next
    {
        my_next = next;
    }
            
            

	- (ObjectSetItem*) lastSibling 
    {
        return (my_next.hasVar) ? my_next.vd.lastSibling : self;
    }
    
    - (void) removeLastSibling
    {
        if (my_next.hasVar)
        {
            if (my_next.vd.next.hasVar)
                [my_next.vd removeLastSibling];
            else
                [self setNext :ObjectSetItem_nuble()];
        }        
    }
    
                            
@end





STRUCT_LIST_IMPLEMENTATION_TEMPLATE(ObjectKeyValue)



@interface ObjectMutableSetImpl : ObjectMutableSet 
	{
	@private
        
		Int my_count;
		NubleObjectSetItemMutableList* my_allEntry;
	}	
    
    + (ObjectMutableSetImpl*) create :(Int)capacity;
    
@end



@implementation ObjectMutableSetImpl 


	
    + (ObjectMutableSetImpl*) create :(Int)capacity
    {
        ObjectMutableSetImpl* result = [[[ObjectMutableSetImpl alloc] init] autorelease];
        result->my_count = 0;
        result->my_allEntry = [NubleObjectSetItemMutableList create:capacity];
        
        for (Int i = 0; i < capacity; i++)
            [result->my_allEntry append:ObjectSetItem_nuble()];
        
        return result;
    }
    
    - (void) dealloc
    {
        while ([my_allEntry anyOf:^(NubleObjectSetItem i) { return i.hasVar; }])
        {
            FOR_EACH_INDEX(i, my_allEntry)
            {
                NubleObjectSetItem root = [my_allEntry at:i];
                
                if (root.hasVar)
                {                
                    ObjectSetItem* item = root.vd.lastSibling;
                    
                    if (item == root.vd)
                        [my_allEntry modifyAt :i :ObjectSetItem_nuble()];
                    else
                        [root.vd removeLastSibling];
                    
                    [item release];
                }
            }
        }
    
        [my_allEntry release];

        [super dealloc];
    }
    
    
    
	- (void) rehash
	{
		Int newCapacity = my_allEntry.count * 2 + 1;
		
		NubleObjectSetItemMutableList* newAllEntry = [NubleObjectSetItemMutableList create:newCapacity];
		for (Int i = 0; i < newCapacity; i++)
			[newAllEntry append :ObjectSetItem_nuble()];
            
        while ([my_allEntry anyOf:^(NubleObjectSetItem i) { return i.hasVar; }])
        {
            FOR_EACH_INDEX(i, my_allEntry)
            {
                NubleObjectSetItem oldRoot = [my_allEntry at:i];
                
                if (oldRoot.hasVar)
                {
                    ObjectSetItem* item = oldRoot.vd.lastSibling;
                    
                    if (item == oldRoot.vd)
                        [my_allEntry modifyAt :i :ObjectSetItem_nuble()];
                    else
                        [oldRoot.vd removeLastSibling];
                    
                    Int entryIndex = Int_mod(item.hash, newAllEntry.count);
                    NubleObjectSetItem newRoot = [newAllEntry at:entryIndex];
                    
                    if (newRoot.hasVar)
                        [newRoot.vd.lastSibling setNext:ObjectSetItem_toNuble(item)];
                    else
                        [newAllEntry modifyAt :entryIndex :ObjectSetItem_toNuble(item)];
                }
            }
        }
        
        [my_allEntry release];
        my_allEntry = [newAllEntry retain];
	}
	
    
    - (Int) count { return my_count; }

    
    - (ObjectKeyValue) at :(Int)hash :(ID_Confirm)confirmKey
    {
        SELFTEST_START
            ObjectMutableSet* set = [ObjectMutableSet create:10];
            [set appendString :STR(@"A") :STR(@"1")];
            [set appendString :STR(@"B") :STR(@"2")];
            
            [[set stringValueWithStringKey:STR(@"A")] assert:@"1"];
            [[set stringValueWithStringKey:STR(@"B")] assert:@"2"];
            
            [set rehash];  
            [[set stringValueWithStringKey:STR(@"A")] assert:@"1"];
            [[set stringValueWithStringKey:STR(@"B")] assert:@"2"];
            
            [set appendString :STR(@"C") :STR(@"3")];
            
            [set rehash];  
            [[set stringValueWithStringKey:STR(@"A")] assert:@"1"];
            [[set stringValueWithStringKey:STR(@"B")] assert:@"2"];
            [[set stringValueWithStringKey:STR(@"C")] assert:@"3"];
        SELFTEST_END
    
        hash = Int_abs(hash);
    
    
        Int entryIndex = Int_mod(hash, my_allEntry.count);
        
        for (NubleObjectSetItem item = [my_allEntry at:entryIndex]; item.hasVar; item = item.vd.next)
        {
            if (confirmKey(item.vd.keyValue.key))
                return item.vd.keyValue;
        }
        
        ASSERT(NO); return ObjectKeyValue_create(nil, nil);
    } 
    
    
    
    - (ObjectKeyValueMutableList*) list
    {
        ObjectKeyValueMutableList* result = [ObjectKeyValueMutableList create:self.count];
        
        FOR_EACH_INDEX(i, my_allEntry)
            for (NubleObjectSetItem item = [my_allEntry at:i]; item.hasVar; item = item.vd.next)
                [result append:item.vd.keyValue];

        return result;
    }
    
    
    - (Bool) anyOf:(ObjectKeyValue_Confirm)confirm
    {    
        SELFTEST_START
            ObjectMutableSet* set = [ObjectMutableSet create:10];
            [set appendString :STR(@"A") :STR(@"1")];
            [set appendString :STR(@"B") :STR(@"2")];
            
            ASSERT([set anyOfStringKey:STR(@"A")]);
            ASSERT([set anyOfStringKey:STR(@"B")]);
            ASSERT([set anyOfStringKey:STR(@"Z")] == NO);
            [set selfAssert];
            
            [set rehash];        
            ASSERT([set anyOfStringKey:STR(@"A")]);
            ASSERT([set anyOfStringKey:STR(@"B")]);
            ASSERT([set anyOfStringKey:STR(@"Z")] == NO);
            [set selfAssert];

        SELFTEST_END
        
                
        FOR_EACH_INDEX(i, my_allEntry)
            for (NubleObjectSetItem item = [my_allEntry at:i]; item.hasVar; item = item.vd.next)
                if (confirm(item.vd.keyValue))
                    return YES;
		
		return NO;	        
    }
   

	- (void) append :(Int)hash :(ObjectKeyValue)keyValue
    {
        SELFTEST_START
            ObjectMutableSet* set = [ObjectMutableSet create:10];

            [set appendString :STR(@"A") :STR(@"1")];
            [set assertStringSet:STR(@"A,1")];

            [set appendString :STR(@"B") :STR(@"2")];
            [set assertStringSet:STR(@"A,1,B,2")];
            
            [set appendString :STR(@"C") :STR(@"3")];
            [set rehash];        
            [set assertStringSet:STR(@"A,1,B,2,C,3")];
        SELFTEST_END
        
        
    
        hash = Int_abs(hash);
        

        ObjectSetItem* newItem = [[ObjectSetItem create :keyValue :hash] retain];
        
        Int entryIndex = Int_mod(newItem.hash, my_allEntry.count);
        
        NubleObjectSetItem rootItem = [my_allEntry at:entryIndex];
        
        if (rootItem.hasVar)
            [rootItem.vd.lastSibling setNext :ObjectSetItem_toNuble(newItem)];
        else
            [my_allEntry modifyAt :entryIndex :ObjectSetItem_toNuble(newItem)];
            
        my_count++;
        
        
        if (my_count > (my_allEntry.count / 3) * 4)
            [self rehash];
    }
    
    
    - (void) selfAssert
    {
        SELFTEST_START
            ObjectMutableSet* set = [ObjectMutableSet create:10];
            [set appendString :STR(@"A") :STR(@"1")];
            [set anyOfStringKey:STR(@"A")];
            [set stringValueWithStringKey:STR(@"A")];
        SELFTEST_END
        
        
        Int count = 0;
        
        FOR_EACH_INDEX(entryIdx, my_allEntry)
        {            
            for (NubleObjectSetItem item = [my_allEntry at:entryIdx]; item.hasVar; item = item.vd.next)
            {
                ASSERT(Int_mod(item.vd.hash, my_allEntry.count) == entryIdx);
                count++;
            }
        }
        
        ASSERT(count == my_count);
    }    
	
@end



@implementation ObjectMutableSet

    + (ObjectMutableSet*) create :(Int)capacity
    {
        return [ObjectMutableSetImpl create :capacity];
    }
    
    
    
	- (void) rehash { ABSTRACT_METHOD_VOID }
        

    - (Int) count { ABSTRACT_METHOD(Int) }

    - (ObjectKeyValue) at :(Int)hash :(ID_Confirm)confirmKey { ABSTRACT_METHOD(ObjectKeyValue) }
    
    - (ObjectKeyValueMutableList*) list { ABSTRACT_METHOD_NIL }

    - (Bool) anyOf:(ObjectKeyValue_Confirm)confirm { ABSTRACT_METHOD(Bool) }
    
    
	- (void) append :(Int)hash :(ObjectKeyValue)keyValue { ABSTRACT_METHOD_VOID }
	    
        
        
    - (void) selfAssert { ABSTRACT_METHOD_VOID }	
    

@end







@implementation ObjectMutableSet (String)

    
    - (StringMutableList*) stringKeyValueList
    {
        StringMutableList* result = [StringMutableList create:self.count];
        
        ObjectKeyValueList* list = [self list];
        FOR_EACH_INDEX(i, list)
        {
            [result append :[list at:i].key];
            [result append :[list at:i].value.vd];
        }
        
        return result;
    }
    
	- (void) appendString :(String*)key :(String*)value
    {
        ObjectKeyValue keyValue = ObjectKeyValue_create(key, value);
        [self append :String_getHash(key) :keyValue];
    }


    - (Bool) anyOfStringKey:(String*)key
    {
        return [self anyOf:^(ObjectKeyValue kv) { return [(String*)kv.key eq:key]; } ];
    }
    
    - (Bool) anyStringKeyOf:(String_Confirm)confirmKey
    {
        return [self anyOf:^(ObjectKeyValue kv) { return confirmKey(kv.key); } ];
    }
    
    - (String*) stringValueWithStringKey:(String*)key
    {
        ObjectKeyValue kv = [self at :String_getHash(key) :^(id k) { return [(String*)k eq:key]; } ];
        return (String*)kv.value.vd;
    }
    
    
    
    - (void) assertStringSet :(String*)stringKeyValueList
    {
        [self selfAssert];
        [self.stringKeyValueList assert:stringKeyValueList];
    }
    
	
@end





































/*


@interface ObjectSetItemImpl : ObjectSetItem
	{
	@private	
		id my_item;
		Int my_hash;

		ObjectSetItemImpl* my_next;
	}


	+ (ObjectSetItemImpl*) create :(id)item :(Int)hash;

	
	@property(readonly) ObjectSetItemImpl* next_;	
	- (void) setNext :(ObjectSetItemImpl*)next;
		
	- (ObjectSetItemImpl*) lastSibling_;
	
@end


NUBLE_OBJECT_TEMPLATE(ObjectSetItemImpl)

OBJECT_LIST_INTERFACE_TEMPLATE(ObjectSetItemImpl)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(ObjectSetItemImpl)


ObjectSetItemImpl* ObjectSetItem_nullEntry(void);
ObjectSetItemImpl* ObjectSetItem_nullEntry(void)
{
	static ObjectSetItemImpl* result = nil; 
	
	if (result == nil) 
		result = [[ObjectSetItemImpl alloc] init];
		
	return result;
}


@implementation ObjectSetItemImpl

	+ (ObjectSetItemImpl*) create :(id)item :(Int)hash
	{
		ObjectSetItemImpl* result = [[[ObjectSetItemImpl alloc] init] autorelease];
		result->my_item = [item retain];
		result->my_hash = hash;
		result->my_next = [ObjectSetItem_nullEntry() retain];
		return result;
	}
	
	- (void) dealloc
	{
		[my_item release];
		[my_next release];
		[super dealloc];
	}	
	
	
	- (id) item { return my_item; }
	- (Int) hash { return my_hash; }
	- (ObjectSetItem*) next { return my_next; }
	
	
	- (ObjectSetItemImpl*) next_ { return my_next; }
	
	- (void) setNext :(ObjectSetItemImpl*)next
	{
		[my_next autorelease];
		my_next = [next retain];
	}
	
	
	- (ObjectSetItem*) lastSibling
	{
		return (self.next == ObjectSetItem_nullEntry()) ? self : self.next.lastSibling;
	}
	
	- (ObjectSetItemImpl*) lastSibling_
	{
		return (self.next_ == ObjectSetItem_nullEntry()) ? self : self.next_.lastSibling_;
	}
			
@end




@implementation ObjectSetItem

	
	- (id) item { ABSTRACT_METHOD_AS_NIL }
	- (Int) hash { ABSTRACT_METHOD_AS(Int) }
	- (ObjectSetItem*) next { ABSTRACT_METHOD_AS_NIL }
	
	- (ObjectSetItem*) lastSibling  { ABSTRACT_METHOD_AS_NIL }
	
@end






void ObjectSetItemImplMutableList_addEntry(ObjectSetItemImplMutableList* list, ObjectSetItemImpl* item);
void ObjectSetItemImplMutableList_addEntry(ObjectSetItemImplMutableList* list, ObjectSetItemImpl* item)
{
	if (item.next_ != ObjectSetItem_nullEntry())
	{
		ObjectSetItemImplMutableList_addEntry(list, item.next_);
		[item setNext :ObjectSetItem_nullEntry()];
	}	

	Int entryIndex = Int_mod(item.hash, list.count);
	
	ObjectSetItemImpl* entry = [list at:entryIndex];
		
	if (entry != ObjectSetItem_nullEntry())
		[entry.lastSibling_ setNext :item];
	else 
		[list modifyAt :entryIndex :item];	
}







@interface ObjectMutableSetImpl : ObjectMutableSet
	{
	@private
		Int my_count;
		ObjectSetItemImplMutableList* my_allEntry;
	}	


	+ (ObjectMutableSetImpl*) create :(Int)capacity;


	- (void) rehash;

@end



@implementation ObjectMutableSetImpl


	+ (ObjectMutableSetImpl*) create :(Int)capacity 
	{
		ObjectMutableSetImpl* result = [[[ObjectMutableSetImpl alloc] init] autorelease];
		result->my_count = 0;
		result->my_allEntry = [[ObjectSetItemImplMutableList create:capacity] retain];
		
		for (Int i = 0; i < capacity; i++)
			[result->my_allEntry append :ObjectSetItem_nullEntry()];
		
		return result;		
	}

	- (void) dealloc
	{
		[my_allEntry release];
		[super dealloc];
	}
	
	
	

	- (id) atOrNil :(Int)hash :(Int)index
	{
		Int entryIndex = Int_mod(hash, my_allEntry.count);
		
		ObjectSetItemImpl* setItem = [my_allEntry at:entryIndex];	
		
		Int count = 0;
		
		while (setItem != ObjectSetItem_nullEntry())
		{
			if (setItem.hash == hash)
			{
				if (count == index)
					return setItem.item;
					
				count += 1;
			}
		}
		
		return nil;
	}
	
	- (Int) lastEntryIndex
	{
		return my_allEntry.lastIndex;
	}
	
	- (NubleObjectSetItem) entryAt:(Int)entryIndex
	{
		ObjectSetItemImpl* setItem = [my_allEntry at:entryIndex];	
		
		if (setItem != ObjectSetItem_nullEntry())
			return ObjectSetItem_nuble();
		else 
			return ObjectSetItem_toNuble(setItem);
	}
	
			
	
	
	- (void) rehash
	{
		Int newCapacity = my_allEntry.count * 2 + 1;
		
		ObjectSetItemImplMutableList* newAllEntry = [ObjectSetItemImplMutableList create:newCapacity];
		for (Int i = 0; i < newCapacity; i++)
			[newAllEntry append :ObjectSetItem_nullEntry()];
		
		ForEachIndex(i, my_allEntry)
		{
			ObjectSetItemImpl* setItem = [my_allEntry at:i];		
					
			ObjectSetItemImplMutableList_addEntry(newAllEntry, setItem);
			[my_allEntry modifyAt :i :ObjectSetItem_nullEntry()];
		}
		
		[my_allEntry release];		
		my_allEntry = [newAllEntry retain];
	}
	

	- (void) append :(Int)hash :(id)item;
	{
		ObjectSetItemImpl* setItem = [ObjectSetItemImpl create :item :hash];
		ObjectSetItemImplMutableList_addEntry(my_allEntry, setItem);
		
		my_count += 1;
		
		if (my_count >= my_allEntry.count / 4 * 3)
			[self rehash];
	}
	
	

@end









@implementation ObjectSet 

	- (id) atOrNil :(Int)hash :(Int)index { ABSTRACT_METHOD_AS_NIL }
	
	- (Int) lastEntryIndex { ABSTRACT_METHOD_AS(Int) }

	- (NubleObjectSetItem) entryAt:(Int)entryIndex { ABSTRACT_METHOD_AS(NubleObjectSetItem) }
	
@end


@implementation SealedSet 

@end


@implementation ObjectMutableSet 

	
	+ (ObjectMutableSet*) create :(Int)capacity
	{
		return [ObjectMutableSetImpl create:capacity]; 
	}


	- (void) append :(Int)hash :(id)item { ABSTRACT_METHOD }
	
@end




*/











