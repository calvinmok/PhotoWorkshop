





typedef struct 
{
    id key;
    NubleID value;
}
ObjectKeyValue;


STRUCT_NUBLE_TEMPLATE(ObjectKeyValue)
STRUCT_LIST_INTERFACE_TEMPLATE(ObjectKeyValue)


NS_INLINE ObjectKeyValue ObjectKeyValue_create(id key, id value)
    { ObjectKeyValue r; r.key = key; r.value = ID_toNuble(value); return r; }

NS_INLINE ObjectKeyValue ObjectKeyValue_createKey(id key)
    { ObjectKeyValue r; r.key = key; r.value = ID_nuble(); return r; }

NS_INLINE ObjectKeyValue ObjectKeyValue_retain(ObjectKeyValue keyValue)
    { [keyValue.key retain]; if (keyValue.value.hasVar) [keyValue.value.vd retain]; return keyValue; }

NS_INLINE void ObjectKeyValue_release(ObjectKeyValue keyValue)
    { [keyValue.key release]; if (keyValue.value.hasVar) [keyValue.value.vd release]; }

NS_INLINE ObjectKeyValue ObjectKeyValue_autorelease(ObjectKeyValue keyValue)
    { [keyValue.key autorelease]; if (keyValue.value.hasVar) [keyValue.value.vd autorelease]; return keyValue; }



@interface ObjectMutableSet : ObjectBase

    + (ObjectMutableSet*) create :(Int)capacity;

	- (void) rehash;
        
        
    @property(readonly) Int count;
        
    - (ObjectKeyValue) at :(Int)hash :(ID_Confirm)confirmKey;
    
    - (ObjectKeyValueMutableList*) list;
    
    
    - (Bool) anyOf:(ObjectKeyValue_Confirm)confirm;

    
	- (void) append :(Int)hash :(ObjectKeyValue)value;
	
    
    - (void) selfAssert;
    
@end




@interface ObjectMutableSet (String)

    
    @property(readonly) StringMutableList* stringKeyValueList;
    
	- (void) appendString :(String*)key :(String*)value;

    - (Bool) anyOfStringKey:(String*)key;
    
    - (Bool) anyStringKeyOf:(String_Confirm)confirmKey;
    
    
    - (String*) stringValueWithStringKey:(String*)key;
	
    
    
    - (void) assertStringSet :(String*)stringKeyValueList;
    
@end










/*


@interface ObjectSetItem : ObjectBase
	
	@property(readonly) id item;
	@property(readonly) Int hash;
	@property(readonly) ObjectSetItem* next;
	
	- (ObjectSetItem*) lastSibling;
	
@end

NUBLE_OBJECT_TEMPLATE(ObjectSetItem)





@interface Set : ObjectBase


	- (NubleID) at :(Int)hash :(Int)index;
	
	
	@property(readonly) Int lastEntryIndex;

	- (NubleObjectSetItem) entryAt:(Int)entryIndex;
	
@end


@interface SealedSet : ObjectSet

@end

@interface MutableSet : ObjectSet

	+ (ObjectMutableSet*) create :(Int)capacity;

	- (void) append :(Int)hash :(id)item;
	
@end









#define SET_INTERFACE_TEMPLATE(NAME, ITEM, KEY) \
\
	@class NAME##Set; \
	@class NAME##MutableSet; \
\
	typedef KEY (^NAME##Set_getKey)(ITEM*); \
\
	typedef Int (^NAME##Set_getHash)(KEY); \
\
	typedef Bool (^NAME##Set_isEqual)(KEY, KEY); \
\
\
	@interface NAME##Set : ObjectBase \
		{ \
        @public \
			ObjectHashSet* my_subject; \
\
			NAME##Set_getKey my_getKey;  \
			NAME##Set_getHash my_getHash;  \
			NAME##Set_isEqual my_isEqual;  \
		} \
\
		- (Bool) contain:(KEY)key; \
\
		- (ITEM*) at:(KEY)key; \
		- (Nuble##ITEM) at_:(KEY)key; \
\
		@property (readonly) Int count; \
\
	@end \
\
\
	@interface NAME##MutableSet : NAME##Set \
		{ \
        @public \
			ObjectMutableHashSet* my_mutableSubject; \
		} \
\
		- (void) append:(ITEM)item; \
\
\
	@end \





#define SET_IMPLEMENTATION_TEMPLATE(ITEM, KEY) \
\
	@implementation NAME##Set \
\
		- (Bool) contain:(KEY)key \
		{ \
			Int hash = my_getHash(key); \
			for (Int i = 0; ; i++) \
			{ \
				NubleID item = [my_subject at :hash :i]; \
				if (item.hasVar == NO) return NO; \
				if (my_isEqual(key, my_getKey(item)) return YES; \
			} \
		} \
\
		- (Nuble##ITEM) at_:(KEY)key \
		{ \
			Int hash = my_getHash(key); \
			Int count = [my_subject itemCount:hash]; \
\
			for (Int i = 0; i < count; i++) \
			{ \
				if (my_isEqual(key, my_getKey([my_subject at :hast :i]))) \
					return Nuble##ITEM_toNuble(item); \
			} \
\
			return ITEM##_nuble(); \
		} \
\
		@property (readonly) Int count; \
\
	@end \
\
\
	@implementation ITEM##MutableHashSet \
\
		- (void) append:(ITEM)item \
		{ \
		} \
\
		- (void) remove:(KEY)key \
		{ \
		} \
\
	@end \








*/





























