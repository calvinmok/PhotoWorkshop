










#define FOR_EACH(TYPE, NAME, EXPR) \
	for (TYPE##Enumerator* NAME = EXPR; [NAME next];  )




typedef struct
{	
	BOOL isReversed;		
	Int pointer;
}
ListIndexData;


NS_INLINE ListIndexData ListIndexData_create(BOOL isReversed)
{
	ListIndexData result = { isReversed, 0 };
	return result;
};

NS_INLINE Bool ListIndexData_next(ListIndexData* data, NubleInt lastIndex)
{
	if (lastIndex.hasVar && data->pointer <= lastIndex.vd)
	{
		data->pointer += 1;
		return YES;
	}
	
	return NO;
};

NS_INLINE Int ListIndexData_index(const ListIndexData data, NubleInt lastIndex)
{
	ASSERT(lastIndex.hasVar && (data.pointer - 1) <= lastIndex.vd);
	
	return (data.isReversed) ? lastIndex.vd - (data.pointer - 1) : (data.pointer - 1);
};









@interface ListEnumeratorBase : ObjectBase

	- (Bool) next;

	@property (readonly) Int index;

@end


@interface ListIndexEnumerator : ListEnumeratorBase

	+ (ListIndexEnumerator*) create:(ListBase*)list;
	+ (ListIndexEnumerator*) createReversed:(ListBase*)list;

@end






@interface ObjectListEnumerator : ListEnumeratorBase

    + (ObjectListEnumerator*) create :(ObjectList*)list :(Bool)reversed;
    
	@property (readonly) id var;
	@property (readonly) Int listCount;
		
	- (ObjectMutableList*) getAll;
    
@end


@interface ObjectListFilteredEnumerator : ObjectListEnumerator

    + (ObjectListFilteredEnumerator*) create :(ObjectList*)list :(Bool)reversed :(ID_Confirm)confirm;
    
@end








@interface StructListEnumerator : ListEnumeratorBase

    + (StructListEnumerator*) create :(StructList*)list :(Bool)reversed;
    
    - (void) var :(Pntr)buffer;

@end


















