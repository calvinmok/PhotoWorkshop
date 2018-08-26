






#define STRUCT_REFERENCE_COUNT_EMPTY_TEMPLATE(TYPE) \
    NS_INLINE TYPE TYPE##_retain(TYPE value) { return value; } \
    NS_INLINE TYPE TYPE##_release(TYPE value) { return value; } \
    NS_INLINE TYPE TYPE##_autorelease(TYPE value) { return value; } \






@class StructList;
@class StructStableList;
@class StructMutableList;
@class StructListEnumerator;





@interface StructList : ListBase
    
	@property (readonly) Int dataSize;
	
    - (void) at :(Int)index :(void*)buffer;
	
/*
    - (NubleBool) isSmaller :(ConstPntr_IsSmallerTarget)isSmaller :(Int)index;
	- (NubleBool) isSmaller :(ConstPntr_IsSmallerXY)isSmaller :(Int)xIndex :(Int)yIndex;
*/	
	- (StructStableList*) toStable;
    
@end


@interface StructList (_)

	- (void) at:(Int)index or:(void*)def :(void*)buffer;
	
	@property (readonly) StructListEnumerator* each;
	@property (readonly) StructListEnumerator* reversedEach;


/*
    - (Bool) findValue:(ConstPntr)value;

    - (Int) findFirstIndexOfValue:(ConstPntr)value;
	- (Int) findFirstIndexOfValue:(ConstPntr)value :(Int)defIndex;
	- (NubleInt) findFirstIndexOfValue_:(ConstPntr)value;
*/	
    
    - (void) first:(Pntr)buffer;
    - (void) first:(ConstPntr)def :(Pntr)buffer;

    - (void) last:(Pntr)buffer;	
    - (void) last:(ConstPntr)def :(Pntr)buffer;
	
    
    
    - (Bool) anyOf:(ConstPntr_Confirm)confirm;
    - (Bool) allOf:(ConstPntr_Confirm)confirm;    
	

@end






@interface StructStableList : StructList

	+ (StructStableList*) createEmpty:(Int)size;

@end





@interface StructMutableList : StructList

    + (StructMutableList*) create:(Int)dataSize;
	+ (StructMutableList*) create:(Int)dataSize :(Int)capacity;
	
	
	- (StructStableList*) seal;
	
	
	@property (readonly) void* mutableBytes;
	
	
	- (void) insertZeroAt :(Int)index;
	
	- (void) insertAt :(Int)index :(const void*)value;
    
    - (void) modifyAt :(Int)index :(const void*)value;


	- (void) removeAll;

	- (void) removeAt:(Int)index;
	
	
	
	- (void) appendFrom :(StructList*)fromList :(Int)fromIndex;
	- (void) insertAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex;
	- (void) modifyAtFrom :(Int)atIndex :(StructList*)fromList :(Int)fromIndex;
	
@end


@interface StructMutableList (_)

    - (void) append :(const void*)value1;
	- (void) append :(const void*)value1 :(const void*)value2;
	- (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3;
	- (void) append :(const void*)value1 :(const void*)value2 :(const void*)value3 :(const void*)value4;

	- (void) removeFirst;
	- (void) removeLast;

@end



@interface StructList (selfTest)

	+ (void) selfTest;

@end








#define STRUCT_LIST_INTERFACE_TEMPLATE(TYPE) \
\
	NS_INLINE TYPE TYPE##_fromPntr(ConstPntr ptr) { TYPE result; result = *((const TYPE*)ptr); return result; } \
\
	@class TYPE##List; \
	@class TYPE##StableList; \
	@class TYPE##MutableList; \
	@class TYPE##ListEnumerator; \
\
\
	@interface TYPE##List : ListBase \
		{ \
        @public \
			StructList* my_subject; \
		} \
\
		- (TYPE##StableList*) toStable; \
\
		- (TYPE) at:(Int)index; \
		- (TYPE) at:(Int)index or:(TYPE)def; \
\
		@property (readonly) TYPE first; \
		@property (readonly) TYPE last; \
\
		- (TYPE) first:(TYPE)def; \
		- (TYPE) last:(TYPE)def; \
\
		@property (readonly) TYPE##ListEnumerator* each; \
		@property (readonly) TYPE##ListEnumerator* reversedEach; \
\
        - (Bool) anyOf :(TYPE##_Confirm)confirm; \
        - (Bool) anyOf :(TYPE##_Confirm)confirm; \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller; \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end;  \
\
	@end \
\
\
	@interface TYPE##StableList : TYPE##List \
		{ \
        @public \
			StructStableList* my_stableSubject; \
		} \
\
		+ (TYPE##StableList*) empty; \
\
	@end \
\
\
	@interface TYPE##MutableList : TYPE##List \
		{ \
        @public \
			StructMutableList* my_mutableSubject; \
		} \
\
		+ (TYPE##MutableList*) create; \
		+ (TYPE##MutableList*) create:(Int)capacity; \
\
\
		- (TYPE##StableList*) seal; \
\
		@property (readonly) void* mutableBytes; \
\
		- (void) insertAt :(Int)index :(TYPE)value; \
\
		- (void) modifyAt :(Int)index :(TYPE)value; \
\
		- (void) append :(TYPE)value1; \
		- (void) append :(TYPE)value1 :(TYPE)value2; \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3; \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3 :(TYPE)value4; \
\
\
		- (void) removeAll; \
		- (void) removeAt:(Int)index; \
		- (void) removeFirst; \
		- (void) removeLast; \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller; \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end; \
\
	@end \
\
\
	@interface TYPE##ListEnumerator : ObjectBase \
		{ \
			@public \
				StructListEnumerator* my_subject; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(StructListEnumerator*)subject; \
\
		- (Bool) next; \
		@property (readonly) Int index; \
		@property (readonly) TYPE var; \
\
	@end \
\
\



 


#define STRUCT_LIST_IMPLEMENTATION_TEMPLATE(TYPE) \
\
	@implementation TYPE##List \
\
		- (void) dealloc \
		{ \
			[my_subject release]; \
			[super dealloc]; \
		} \
\
		- (TYPE##StableList*) toStable \
		{ \
			TYPE##StableList* result = [[[TYPE##StableList alloc] init] autorelease]; \
			result->my_stableSubject = [[my_subject toStable] retain]; \
			result->my_subject = result->my_stableSubject; \
			return result; \
		} \
\
		- (Int) count { return my_subject.count; } \
\
        - (TYPE) at:(Int)index \
		{ \
			TYPE result; \
			[my_subject at:index :&result]; \
			return result; \
		} \
\
		- (TYPE) at:(Int)index or:(TYPE)def \
		{ \
			TYPE result; \
			[my_subject at:index or:&def :&result];  \
			return result; \
		} \
\
		- (TYPE) first { return [self at:0]; } \
		- (TYPE) last { return [self at:self.lastIndex]; } \
\
		- (TYPE) first:(TYPE)def { return [self at:0 or:def]; } \
		- (TYPE) last:(TYPE)def { return [self at:self.lastIndex or:def]; } \
\
        - (Bool) anyOf :(TYPE##_Confirm)confirm { return [my_subject anyOf:^(ConstPntr p) { return confirm(TYPE##_fromPntr(p));  }]; } \
        - (Bool) allOf :(TYPE##_Confirm)confirm { return [my_subject allOf:^(ConstPntr p) { return confirm(TYPE##_fromPntr(p));  }]; } \
\
		- (TYPE##ListEnumerator*) each { return [TYPE##ListEnumerator create:my_subject.each]; } \
		- (TYPE##ListEnumerator*) reversedEach { return [TYPE##ListEnumerator create:my_subject.reversedEach]; } \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller                       { return [my_subject binarySearch:^(ConstPntr p) { return isSmaller(TYPE##_fromPntr(p)); }]; } \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end { return [my_subject binarySearch:^(ConstPntr p) { return isSmaller(TYPE##_fromPntr(p)); } :start :end]; } \
\
	@end \
\
	@implementation TYPE##StableList \
\
		+ (TYPE##StableList*) empty \
		{ \
			static TYPE##StableList* result = nil;\
\
			if (result == nil) \
			{ \
				result = [[TYPE##StableList alloc] init]; \
				result->my_subject = [StructStableList createEmpty:toInt(sizeof(TYPE))]; \
			} \
\
			return result;\
		} \
\
	@end \
\
	@implementation TYPE##MutableList \
\
		+ (TYPE##MutableList*) create \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [[StructMutableList create:toInt(sizeof(TYPE))] retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		+ (TYPE##MutableList*) create:(Int)capacity \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [[StructMutableList create:toInt(sizeof(TYPE)) :capacity] retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		- (TYPE##StableList*) seal \
		{ \
			TYPE##StableList* result = [[[TYPE##StableList alloc] init] autorelease]; \
			result->my_stableSubject = [[my_mutableSubject seal] retain]; \
			result->my_subject = result->my_stableSubject; \
			return result; \
		} \
\
		- (void*) mutableBytes { return my_mutableSubject.mutableBytes; } \
\
		- (void) append :(TYPE)value1                                           { [my_mutableSubject append :&value1]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2                             { [my_mutableSubject append :&value1 :&value2]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3               { [my_mutableSubject append :&value1 :&value2 :&value3]; } \
		- (void) append :(TYPE)value1 :(TYPE)value2 :(TYPE)value3 :(TYPE)value4 { [my_mutableSubject append :&value1 :&value2 :&value3 :&value4]; } \
\
		- (void) insertAt :(Int)index :(TYPE)value { [my_mutableSubject insertAt :index :&value]; } \
		- (void) modifyAt :(Int)index :(TYPE)value { [my_mutableSubject modifyAt :index :&value]; } \
\
		- (void) removeAll { [my_mutableSubject removeAll]; } \
		- (void) removeAt:(Int)index { [my_mutableSubject removeAt:index]; } \
		- (void) removeFirst { [my_mutableSubject removeFirst]; } \
		- (void) removeLast { [my_mutableSubject removeLast]; } \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller                       { [my_mutableSubject mergeSort :^(ConstPntr x, ConstPntr y) { return isSmaller(TYPE##_fromPntr(x), TYPE##_fromPntr(y)); } ]; } \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end { [my_mutableSubject mergeSort :^(ConstPntr x, ConstPntr y) { return isSmaller(TYPE##_fromPntr(x), TYPE##_fromPntr(y)); } :start :end]; } \
\
	@end \
\
\
	@implementation TYPE##ListEnumerator \
\
		- (void) dealloc \
		{ \
			[my_subject release]; \
			[super dealloc]; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(StructListEnumerator*)subject \
		{ \
			TYPE##ListEnumerator* result = [[[TYPE##ListEnumerator alloc] init] autorelease]; \
			result->my_subject = [subject retain]; \
			return result; \
		} \
\
		- (Bool) next { return [my_subject next]; } \
		- (Int) index { return my_subject.index; } \
\
		- (TYPE) var \
		{ \
			TYPE result; \
			[my_subject var:&result];  \
			return result; \
		} \
\
	@end \
\
\



	

	



void StructList_selfTest(void);








/*
public class Mergesort {
	private int[] numbers;

	private int number;

	public void sort(int[] values) {
		this.numbers = values;
		number = values.length;

		mergesort(0, number - 1);
	}

	private void mergesort(int low, int high) {
		// Check if low is smaller then high, if not then the array is sorted
		if (low < high) {
			// Get the index of the element which is in the middle
			int middle = (low + high) / 2;
			// Sort the left side of the array
			mergesort(low, middle);
			// Sort the right side of the array
			mergesort(middle + 1, high);
			// Combine them both
			merge(low, middle, high);
		}
	}

	private void merge(int low, int middle, int high) {

		// Helperarray
		int[] helper = new int[number];

		// Copy both parts into the helper array
		for (int i = low; i <= high; i++) {
			helper[i] = numbers[i];
		}

		int i = low;
		int j = middle + 1;
		int k = low;
		// Copy the smallest values from either the left or the right side back
		// to the original array
		while (i <= middle && j <= high) {
			if (helper[i] <= helper[j]) {
				numbers[k] = helper[i];
				i++;
			} else {
				numbers[k] = helper[j];
				j++;
			}
			k++;
		}
		// Copy the rest of the left side of the array into the target array
		while (i <= middle) {
			numbers[k] = helper[i];
			k++;
			i++;
		}
		helper = null;

	}
}
*/

	
	



