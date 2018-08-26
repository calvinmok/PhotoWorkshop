









@class ObjectList;
@class ObjectStableList;
@class ObjectMutableList;
@class ObjectListEnumerator;




@interface ObjectList : ListBase

	- (id) at:(Int)index;
	
	- (ObjectStableList*) toStable;
	- (ObjectMutableList*) toMutable;
	
	
@end


@interface ObjectList (_)

	- (id) at:(Int)index :(id)def;
    
    @property (readonly) id first;
	@property (readonly) id second;
	@property (readonly) id third;
	@property (readonly) id fourth;
	
    @property (readonly) id last;

		
    @property (readonly) id firstOrNil;
    @property (readonly) id lastOrNil;
    

	- (Bool) anyOfValue:(id)value;
	- (Int) countOfValue:(id)value;
    - (NubleInt) firstIndexOfValue_:(id)value;    
    - (NubleInt) lastIndexOfValue_:(id)value;    
    


    - (Bool) anyOf:(ID_Confirm)confirm;
    - (Bool) allOf:(ID_Confirm)confirm;
    - (Int) countOf:(ID_Confirm)confirm;

    - (ID) firstOf:(ID_Confirm)confirm;    
    - (ID) lastOf:(ID_Confirm)confirm;

    - (NubleID) firstOf_:(ID_Confirm)confirm;    
    - (NubleID) lastOf_:(ID_Confirm)confirm;
    
    - (NubleInt) firstIndexOf_:(ID_Confirm)confirm;
    - (NubleInt) lastIndexOf_:(ID_Confirm)confirm;
    
    
    
    
	@property (readonly) ObjectListEnumerator* each;
	@property (readonly) ObjectListEnumerator* reversedEach;
    
    - (ObjectMutableList*) listOf:(ID_Confirm)confirm;	
	- (ObjectListEnumerator*) enumOf:(ID_Confirm)confirm;

    
@end



@interface ObjectStableList : ObjectList

	+ (ObjectStableList*) empty;
	
@end



@interface ObjectMutableList : ObjectList
	
    + (ObjectMutableList*) create;
	+ (ObjectMutableList*) create:(Int)capacity;
	
	- (ObjectStableList*) seal;
	
	- (void) insertAt :(Int)index :(id)item;
	- (void) append:(id)item;
	
	- (void) modifyAt :(Int)index :(id)item;
	
	- (void) swap :(Int)x :(Int)y;
	
	
	- (void) removeAll;
	
	
	- (void) removeAt:(Int)index;
	
	- (void) removeEvery:(id)item;
	
	
	
@end

@interface ObjectMutableList (_)

	- (void) insert:(id)item;

	- (void) removeFirst;
	- (void) removeLast;
	
	- (void) removeDuplication:(ID_IsEqual)isEqual;

	- (void) removeMatch:(ID_Confirm)confirm;
	
	
	- (void) replaceAll :(ObjectList*)allItem;
	
	
    - (void) moveToFirst :(Int)index;
    - (void) moveToLast :(Int)index;
    

@end













@interface  NSObject_ListBase : ListBase

    @property(readonly) Class type; 

    - (NSObject*) NSObject_at:(Int)index;

@end






@protocol ObjectListTemplate_
    
    @property(readonly) ObjectList* subject;
    
@end

typedef NSObject_ListBase<ObjectListTemplate_> ObjectListTemplate;


@protocol ObjectStableListTemplate_ <ObjectListTemplate_>

    @property(readonly) ObjectStableList* stableSubject;

@end

typedef NSObject_ListBase<ObjectStableListTemplate_> ObjectStableListTemplate;


@protocol ObjectMutableListTemplate_ <ObjectListTemplate_>

    @property(readonly) ObjectMutableList* mutableSubject;

@end

typedef NSObject_ListBase<ObjectMutableListTemplate_> ObjectMutableListTemplate;








#define OBJECT_LIST_INTERFACE_TEMPLATE(TYPE, BASE) \
\
	@class TYPE##List; \
	@class TYPE##StableList; \
	@class TYPE##MutableList; \
	@class TYPE##ListEnumerator; \
\
\
    @interface TYPE##_ListBase : BASE##_ListBase <ObjectListTemplate_> \
        @property(readonly) Class type; \
        @property(readonly) ObjectList* subject; \
        - (BASE*) BASE##_at:(Int)index; \
        - (TYPE*) TYPE##_at:(Int)index; \
    @end \
\
\
\
	@interface TYPE##List : TYPE##_ListBase \
		{ \
        @public \
			ObjectList* my_subject; \
		} \
\
        @property(readonly) Class type; \
        @property(readonly) ObjectList* subject; \
\
		- (TYPE##StableList*) toStable; \
		- (TYPE##MutableList*) toMutable; \
\
		- (TYPE*) at:(Int)index; \
		- (TYPE*) at:(Int)index :(TYPE*)def; \
\
		@property (readonly) TYPE* first; \
		@property (readonly) TYPE* second; \
		@property (readonly) TYPE* third; \
		@property (readonly) TYPE* fourth; \
		@property (readonly) TYPE* last; \
\
		- (TYPE*) firstOr:(TYPE*)def; \
		- (TYPE*) lastOr:(TYPE*)def; \
\
        - (Bool) anyOfValue:(TYPE*)value;  \
        - (Int) countOfValue:(TYPE*)value;  \
        - (Int) firstIndexOfValue:(TYPE*)value;  \
        - (Int) lastIndexOfValue:(TYPE*)value;  \
        - (NubleInt) firstIndexOfValue_:(TYPE*)value;  \
        - (NubleInt) lastIndexOfValue_:(TYPE*)value;  \
\
        - (Bool) anyOf:(TYPE##_Confirm)confirm;  \
        - (Bool) allOf:(TYPE##_Confirm)confirm;  \
        - (Int) countOf:(TYPE##_Confirm)confirm;  \
\
        - (TYPE*) firstOf:(TYPE##_Confirm)confirm;  \
        - (TYPE*) lastOf:(TYPE##_Confirm)confirm;  \
        - (Nuble##TYPE) firstOf_:(TYPE##_Confirm)confirm;  \
        - (Nuble##TYPE) lastOf_:(TYPE##_Confirm)confirm;  \
        - (Int) firstIndexOf:(TYPE##_Confirm)confirm;  \
        - (Int) lastIndexOf:(TYPE##_Confirm)confirm;  \
        - (NubleInt) firstIndexOf_:(TYPE##_Confirm)confirm;  \
        - (NubleInt) lastIndexOf_:(TYPE##_Confirm)confirm;  \
\
		@property (readonly) TYPE##ListEnumerator* each; \
		@property (readonly) TYPE##ListEnumerator* reversedEach; \
\
		- (TYPE##MutableList*) listOf:(TYPE##_Confirm)confirm; \
		- (TYPE##ListEnumerator*) enumOf:(TYPE##_Confirm)confirm; \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller; \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end;  \
		- (Nuble##TYPE) max :(TYPE##_IsSmallerXY)isSmaller; \
		- (Nuble##TYPE) min :(TYPE##_IsSmallerXY)isSmaller; \
\
	@end \
\
\
	@interface TYPE##StableList : TYPE##List <ObjectStableListTemplate_> \
		{ \
        @public \
			ObjectStableList* my_stableSubject; \
		} \
\
		+ (TYPE##StableList*) empty; \
\
	@end \
\
\
	@interface TYPE##MutableList : TYPE##List <ObjectMutableListTemplate_> \
		{ \
        @public \
			ObjectMutableList* my_mutableSubject; \
		} \
\
		+ (TYPE##MutableList*) createWithSubject:(ObjectMutableList*)subject; \
\
		+ (TYPE##MutableList*) create; \
		+ (TYPE##MutableList*) create:(Int)capacity; \
\
\
		- (TYPE##StableList*) seal; \
\
		- (void) insert :(TYPE*)value; \
		- (void) insertAt :(Int)index :(TYPE*)value; \
\
		- (void) modifyAt :(Int)index :(TYPE*)value; \
\
		- (void) append:(TYPE*)value; \
\
		- (void) removeAll;\
		- (void) removeAt:(Int)index; \
		- (void) removeFirst; \
		- (void) removeLast; \
		- (void) removeEvery:(TYPE*)value; \
\
		- (void) removeDuplication :(TYPE##_IsEqual)isEqual; \
		- (void) removeMatch :(TYPE##_Confirm)confirm; \
\
		- (void) replaceAll :(TYPE##List*)allItem; \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller; \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end; \
\
        - (void) moveToFirst :(Int)index; \
        - (void) moveToLast :(Int)index; \
\
	@end \
\
\
	@interface TYPE##ListEnumerator : ObjectBase \
		{ \
		@public \
			ObjectListEnumerator* my_subject; \
		} \
\
		+ (TYPE##ListEnumerator*) create:(ObjectListEnumerator*)subject; \
\
		- (Bool) next; \
		@property (readonly) Int index; \
		@property (readonly) TYPE* var; \
\
	@end \
\
\







 


#define OBJECT_LIST_IMPLEMENTATION_TEMPLATE(TYPE, BASE) \
\
\
    @implementation TYPE##_ListBase  \
\
        - (ObjectList*) subject { ASSERT(NO); return nil; } \
        - (Class) type { return [TYPE class]; } \
\
        - (BASE*) BASE##_at:(Int)index { return [self TYPE##_at:index]; } \
        - (TYPE*) TYPE##_at:(Int)index { return nil; } \
\
    @end \
\
\
	@implementation TYPE##List \
\
		- (void) dealloc \
		{ \
			[my_subject release]; \
			[super dealloc]; \
		} \
\
        - (ObjectList*) subject { return my_subject; } \
        - (Class) type { return [TYPE class]; } \
        - (TYPE*) TYPE##_at:(Int)index { return [self at:index]; } \
\
		- (TYPE##StableList*) toStable \
		{ \
			TYPE##StableList* result = [[[TYPE##StableList alloc] init] autorelease]; \
			result->my_stableSubject = [[my_subject toStable] retain]; \
			result->my_subject = result->my_stableSubject; \
			return result; \
		} \
		- (TYPE##MutableList*) toMutable \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [[my_subject toMutable] retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		- (Int) count { return my_subject.count; } \
\
        - (TYPE*) at:(Int)index             { return [my_subject at:index]; } \
		- (TYPE*) at:(Int)index :(TYPE*)def { return [my_subject at:index :def]; } \
\
		- (TYPE*) first { return my_subject.first; } \
		- (TYPE*) second { return my_subject.second; } \
		- (TYPE*) third { return my_subject.third; } \
		- (TYPE*) fourth { return my_subject.fourth; } \
		- (TYPE*) last { return my_subject.last; } \
\
		- (TYPE*) firstOrNil { return my_subject.firstOrNil; } \
		- (TYPE*) lastOrNil { return my_subject.lastOrNil; } \
\
		- (TYPE*) firstOr:(TYPE*)def { return [self at:0 :def]; } \
		- (TYPE*) lastOr:(TYPE*)def { return [self at:self.lastIndex :def]; } \
\
        - (Bool) anyOfValue:(TYPE*)value { return [my_subject anyOfValue :value]; } \
        - (Int) countOfValue:(TYPE*)value { return [my_subject countOfValue :value]; }  \
        - (Int) firstIndexOfValue:(TYPE*)value { return Int_var([my_subject firstIndexOfValue_ :value]); }  \
        - (Int) lastIndexOfValue:(TYPE*)value  { return Int_var([my_subject lastIndexOfValue_ :value]); }  \
        - (NubleInt) firstIndexOfValue_:(TYPE*)value { return [my_subject firstIndexOfValue_:value]; }  \
        - (NubleInt) lastIndexOfValue_:(TYPE*)value  { return [my_subject lastIndexOfValue_:value]; }  \
\
        - (Bool) anyOf:(TYPE##_Confirm)confirm { return [my_subject anyOf:^(id value) { return confirm(value); }]; } \
        - (Bool) allOf:(TYPE##_Confirm)confirm { return [my_subject allOf:^(id value) { return confirm(value); }]; } \
        - (Int) countOf:(TYPE##_Confirm)confirm { return [my_subject countOf:^(id value) { return confirm(value); }]; } \
\
        - (TYPE*) firstOf:(TYPE##_Confirm)confirm { return [my_subject firstOf:^(id value) { return confirm(value); }]; }  \
        - (TYPE*) lastOf:(TYPE##_Confirm)confirm  { return [my_subject lastOf:^(id value) { return confirm(value); }]; }  \
        - (Nuble##TYPE) firstOf_:(TYPE##_Confirm)confirm { return TYPE##_unsafeFromNubleID([my_subject firstOf_:^(id value) { return confirm(value); }]); }  \
        - (Nuble##TYPE) lastOf_:(TYPE##_Confirm)confirm  { return TYPE##_unsafeFromNubleID([my_subject lastOf_:^(id value) { return confirm(value); }]); }  \
        - (Int) firstIndexOf:(TYPE##_Confirm)confirm { return Int_var([self firstIndexOf_:confirm]); }  \
        - (Int) lastIndexOf:(TYPE##_Confirm)confirm  { return Int_var([self lastIndexOf_:confirm]); }  \
        - (NubleInt) firstIndexOf_:(TYPE##_Confirm)confirm { return [my_subject firstIndexOf_:^(id value) { return confirm(value); }]; }  \
        - (NubleInt) lastIndexOf_:(TYPE##_Confirm)confirm  { return [my_subject lastIndexOf_:^(id value) { return confirm(value); }]; }   \
\
		- (TYPE##ListEnumerator*) each { return [TYPE##ListEnumerator create:my_subject.each]; } \
		- (TYPE##ListEnumerator*) reversedEach { return [TYPE##ListEnumerator create:my_subject.reversedEach]; } \
\
		- (TYPE##MutableList*) listOf:(TYPE##_Confirm)confirm { return [TYPE##MutableList createWithSubject:[my_subject listOf:^(id value) { return confirm(value); } ] ]; } \
		- (TYPE##ListEnumerator*) enumOf:(TYPE##_Confirm)confirm { return [TYPE##ListEnumerator create: [my_subject enumOf :^(id value) { return confirm(value); } ]];  } \
\
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller                       { return [my_subject binarySearch:^(id i) { return isSmaller(i); }]; } \
		- (BinarySearchResult) binarySearch :(TYPE##_IsSmallerTarget)isSmaller :(Int)start :(Int)end { return [my_subject binarySearch:^(id i) { return isSmaller(i); } :start :end]; } \
		- (Nuble##TYPE) max :(TYPE##_IsSmallerXY)isSmaller; { return TYPE##_unsafeFromNubleID([my_subject max:^(id x, id y) { return isSmaller(x, y); }]); }  \
		- (Nuble##TYPE) min :(TYPE##_IsSmallerXY)isSmaller; { return TYPE##_unsafeFromNubleID([my_subject min:^(id x, id y) { return isSmaller(x, y); }]); }  \
\
	@end \
\
	@implementation TYPE##StableList \
\
        - (ObjectStableList*) stableSubject { return my_stableSubject; } \
\
		+ (TYPE##StableList*) empty \
		{ \
			static TYPE##StableList* result = nil; \
\
			if (result == nil) \
			{ \
				result = [[TYPE##StableList alloc] init]; \
				result->my_subject = [ObjectStableList empty]; \
			} \
\
			return result; \
		} \
\
	@end \
\
	@implementation TYPE##MutableList \
\
		+ (TYPE##MutableList*) createWithSubject:(ObjectMutableList*)subject \
		{ \
			TYPE##MutableList* result = [[[TYPE##MutableList alloc] init] autorelease]; \
			result->my_mutableSubject = [subject retain]; \
			result->my_subject = result->my_mutableSubject; \
			return result; \
		} \
\
		+ (TYPE##MutableList*) create \
		{ \
			return [TYPE##MutableList createWithSubject:[ObjectMutableList create]]; \
		} \
\
		+ (TYPE##MutableList*) create:(Int)capacity \
		{ \
			return [TYPE##MutableList createWithSubject:[ObjectMutableList create:capacity]]; \
		} \
\
        - (ObjectMutableList*) mutableSubject { return my_mutableSubject; } \
\
		- (TYPE##StableList*) seal \
		{ \
			TYPE##StableList* result = [[[TYPE##StableList alloc] init] autorelease]; \
			result->my_stableSubject = [[my_mutableSubject seal] retain]; \
			result->my_subject = result->my_stableSubject; \
			return result; \
		} \
\
		- (void) append:(TYPE*)item { [my_mutableSubject append:item]; } \
\
		- (void) insert :(TYPE*)item { [my_mutableSubject insert :item]; } \
		- (void) insertAt :(Int)index :(TYPE*)item { [my_mutableSubject insertAt :index :item]; } \
		- (void) modifyAt :(Int)index :(TYPE*)item { [my_mutableSubject modifyAt :index :item]; } \
\
		- (void) removeAll { [my_mutableSubject removeAll]; }  \
		- (void) removeAt:(Int)index { [my_mutableSubject removeAt:index]; } \
		- (void) removeFirst { [my_mutableSubject removeFirst]; } \
		- (void) removeLast { [my_mutableSubject removeLast]; } \
		- (void) removeEvery:(TYPE*)value { [my_mutableSubject removeEvery:value]; } \
\
		- (void) removeDuplication:(TYPE##_IsEqual)isEqual { [my_mutableSubject removeDuplication:^(id x, id y) { return isEqual(x, y); } ]; } \
		- (void) removeMatch :(TYPE##_Confirm)confirm  { [my_mutableSubject removeMatch:^(id value) { return confirm(value); } ]; } \
\
		- (void) replaceAll :(TYPE##List*)allItem { [my_mutableSubject replaceAll:allItem->my_subject]; } \
\
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller                       { [my_mutableSubject mergeSort :^(id x, id y) { return isSmaller(x, y); }]; } \
		- (void) mergeSort :(TYPE##_IsSmallerXY)isSmaller :(Int)start :(Int)end { [my_mutableSubject mergeSort :^(id x, id y) { return isSmaller(x, y); } :start :end]; } \
\
        - (void) moveToFirst :(Int)index { [my_mutableSubject moveToFirst:index]; } \
        - (void) moveToLast :(Int)index { [my_mutableSubject moveToLast:index]; } \
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
		+ (TYPE##ListEnumerator*) create:(ObjectListEnumerator*)subject \
		{ \
			TYPE##ListEnumerator* result = [[[TYPE##ListEnumerator alloc] init] autorelease]; \
			result->my_subject = [subject retain]; \
			return result; \
		} \
\
		- (Bool) next { return [my_subject next]; } \
		- (Int) index { return my_subject.index; } \
		- (TYPE*) var { return (TYPE*)my_subject.var; } \
\
	@end \
\
\











void ObjectList_selfTest(void);





















