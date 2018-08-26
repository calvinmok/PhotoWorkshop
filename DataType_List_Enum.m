

#import "DataType.h"










@interface ListIndexEnumeratorImpl : ListIndexEnumerator
	{
	@public
		ListBase* my_list;
		ListIndexData my_data;
	}

	+ (ListIndexEnumeratorImpl*) create :(ListBase*)list :(Bool)isReversed;

@end

@implementation ListIndexEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	+ (ListIndexEnumeratorImpl*) create :(ListBase*)list :(Bool)isReversed
	{
        ListIndexEnumeratorImpl* result = [[[ListIndexEnumeratorImpl alloc] init] autorelease];
        result->my_list = [list retain];
        result->my_data = ListIndexData_create(isReversed);
		return result;
	}


	- (Bool) next
	{
		return ListIndexData_next(&my_data, my_list.lastIndex_);
	}

	- (Int) index
	{
		return ListIndexData_index(my_data, my_list.lastIndex_);
	}

@end






@implementation ListIndexEnumerator

	+ (ListIndexEnumerator*) create:(ListBase*)list
	{
		return [ListIndexEnumeratorImpl create :list :NO];
	}

	+ (ListIndexEnumerator*) createReversed:(ListBase*)list
	{
		return [ListIndexEnumeratorImpl create :list :YES];
	}
	
@end















@implementation ListEnumeratorBase

	- (Bool) next { ABSTRACT_METHOD(Bool) }

	- (Int) index { ABSTRACT_METHOD(Int) }

@end





@interface ObjectListEnumeratorImpl : ObjectListEnumerator
	{
	@public
		ObjectList* my_list;
		ListIndexData my_data;
	}

	+ (ObjectListEnumeratorImpl*) create :(ObjectList*)list :(Bool)isReversed;

@end


@implementation ObjectListEnumeratorImpl

	+ (ObjectListEnumeratorImpl*) create:(ObjectList*)list :(Bool)reversed
	{
        ObjectListEnumeratorImpl* result = [[[ObjectListEnumeratorImpl alloc] init] autorelease];
		result->my_list = [list retain];
		result->my_data = ListIndexData_create(reversed);
		return result;
	}
	
    - (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}
    

	- (Bool) next { return ListIndexData_next(&my_data, my_list.lastIndex_); }

	- (Int) index { return ListIndexData_index(my_data, my_list.lastIndex_); }

	- (id) var { return [my_list at:self.index]; }

	- (Int) listCount { return my_list.count; }

@end



@implementation ObjectListEnumerator


	+ (ObjectListEnumerator*) create :(ObjectList*)list :(Bool)reversed
	{
        return [ObjectListEnumeratorImpl create :list :reversed];
    }


	- (id) var { ABSTRACT_METHOD_NIL; }
	- (Int) listCount { ABSTRACT_METHOD(Int); }


	- (ObjectMutableList*) getAll
	{	
		ObjectMutableList* result = [ObjectMutableList create:self.listCount];
		
		while ([self next])
			[result append:self.var];
		
		return result;
	}

@end













@interface ObjectListFilteredEnumeratorImpl : ObjectListFilteredEnumerator
	{
	@public
		ObjectList* my_list;
		ListIndexData my_data;
		
		ID_Confirm my_confirm;
		Int my_count;
	}
	
	+ (ObjectListFilteredEnumeratorImpl*) create :(ObjectList*)list :(Bool)reversed :(ID_Confirm)confirm;

@end


@implementation ObjectListFilteredEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	+ (ObjectListFilteredEnumeratorImpl*) create :(ObjectList*)list :(Bool)reversed :(ID_Confirm)confirm
	{
        ObjectListFilteredEnumeratorImpl* result = [[[ObjectListFilteredEnumeratorImpl alloc] init] autorelease];
		result->my_list = [list retain];
		result->my_data = ListIndexData_create(reversed);
		result->my_confirm = confirm;
		result->my_count = 0;
		return result;
	}


	- (Bool) next 
	{ 
		while (ListIndexData_next(&my_data, my_list.lastIndex_))
		{
			if (my_confirm(self.var))
			{
				my_count += 1;
				return YES;
			}
		} 
		
		return NO;
	}

	- (Int) index { return ListIndexData_index(my_data, my_list.lastIndex_); }

	- (id) var { return [my_list at:self.index]; }
	
	- (Int) i { return my_count; }

@end

@implementation ObjectListFilteredEnumerator

	+ (ObjectListFilteredEnumerator*) create :(ObjectList*)list :(Bool)reversed :(ID_Confirm)confirm
	{
        return [ObjectListFilteredEnumeratorImpl create :list :reversed :confirm];
    }

@end

















@interface StructListEnumeratorImpl : StructListEnumerator
	{
	@public
		StructList* my_list;
		ListIndexData my_data;
	}

	+ (StructListEnumeratorImpl*) create :(StructList*)list :(Bool)reversed;

@end


@implementation StructListEnumeratorImpl

	- (void) dealloc
	{
		[my_list release];
		[super dealloc];
	}


	+ (StructListEnumeratorImpl*) create :(StructList*)list :(Bool)reversed
    {
        StructListEnumeratorImpl* result = [[[StructListEnumeratorImpl alloc] init] autorelease];
		result->my_list = [list retain];
		result->my_data = ListIndexData_create(reversed);
		return result;
	}


	- (Bool) next 
    { 
        return ListIndexData_next(&my_data, my_list.lastIndex_); 
    }

	- (Int) index 
    {
		return ListIndexData_index(my_data, my_list.lastIndex_);
	}

	- (void) var:(void*)buffer
	{
		[my_list at :self.index :buffer];
	}

@end





@implementation StructListEnumerator

    + (StructListEnumerator*) create :(StructList*)list :(Bool)reversed
    {
        return [StructListEnumeratorImpl create :list :reversed];
    }

	- (void) var :(Pntr)buffer { ABSTRACT_METHOD_VOID }

@end

















