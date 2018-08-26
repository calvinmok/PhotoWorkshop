






NS_INLINE Bool compareLastIndex(Int i, NubleInt lastIndex) { return (lastIndex.hasVar && i <= lastIndex.vd); }

NS_INLINE Bool compareFirstIndex(Int i, NubleInt firstIndex) { return (firstIndex.hasVar && i >= firstIndex.vd); }



#define FOR_EACH_INDEX(VAR, LIST) \
	for (Int VAR = Int_varOr(LIST.firstIndex_, Int_Max); VAR != Int_Max && compareLastIndex(VAR, LIST.lastIndex_); VAR++)

#define FOR_EACH_INDEX_IN_REV(VAR, LIST) \
	for (Int VAR = Int_varOr(LIST.lastIndex_, Int_Min); VAR != Int_Min && compareFirstIndex(VAR, LIST.firstIndex_); --VAR)




@class ListBase;
@class ListEnumeratorBase;
@class ListIndexEnumerator;




@interface ListBase : ObjectBase

	@property (readonly) Int count;

@end

@interface ListBase (_)

	@property (readonly) ListIndexEnumerator* eachIndex;
	@property (readonly) ListIndexEnumerator* reversedEachIndex;

	- (Bool) isValidIndex:(Int)index;
    
    - (Bool) isValidRange :(Int)start :(Int)length;

	@property (readonly) Int firstIndex;
	@property (readonly) Int lastIndex;
	@property (readonly) NubleInt firstIndex_;
	@property (readonly) NubleInt lastIndex_;

	@property (readonly) Int nextIndex;

@end














typedef struct 
{
	Bool found;
	Int  index;
}
BinarySearchResult;

NS_INLINE BinarySearchResult BinarySearchResult_create(Bool foundMatch, Int index) { 
	BinarySearchResult result = { foundMatch, index }; return result; }

NS_INLINE void BinarySearchResult_assert(BinarySearchResult value, Bool found, Int index)
	{ ASSERT(value.found == found && value.index == index); }




























