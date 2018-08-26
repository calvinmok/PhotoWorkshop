











#import "DataType.h"








@implementation ObjectList (Algorithm)


	


	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller
	{
		SELFTEST_START
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"a,c,e"));
			
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], YES, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"b")); }], NO, 1);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"c")); }], YES, 1);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"d")); }], NO, 2);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"e")); }], YES, 2);
		}
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"b"));
			
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], NO, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"b")); }], YES, 0);
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"c")); }], NO, 1);
		}
		{
			StringMutableList* list = [StringMutableList create:0];
			BinarySearchResult_assert(
				[list binarySearch:^(String* s) { return String_isSmallerXY(s, STR(@"a")); }], NO, 0);
		}		
		
		SELFTEST_END
	
			
		if (self.count == 0) 
			return BinarySearchResult_create(NO, 0);
			
		return [self binarySearch :isSmaller :self.firstIndex :self.lastIndex];		
	}
	
	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller :(Int)start :(Int)end
	{	
		ASSERT([self isValidIndex:start] && [self isValidIndex:end]);

		while (start <= end)
		{		
			Int position = start + ((end - start) / 2); 
			
			Bool3 b = isSmaller([self at:position]);
			
			if (b == Unknown)
			{
				return BinarySearchResult_create(YES, position);
			}
			else
			{
				if (b == Yes)
					start = position + 1;
				else
					end = position - 1;
			} 
		} 
			
		return BinarySearchResult_create(NO, start);
	}



    - (NubleID) max:(ID_IsSmallerXY)isSmaller
    {
        SELFTEST_START
        
        StringMutableList* list = [StringMutableList create:10];
        ASSERT([list max:^(id x, id y) { return String_isSmallerXY(x, y); }].hasVar == NO);
        
        [list append:STR(@"F")];
        [String_var([list max:^(id x, id y) { return String_isSmallerXY(x, y); }]) assert:@"F"];
        
        [list append:STR(@"A")];
        [String_var([list max:^(id x, id y) { return String_isSmallerXY(x, y); }]) assert:@"F"];

        [list append:STR(@"G")];
        [String_var([list max:^(id x, id y) { return String_isSmallerXY(x, y); }]) assert:@"G"];
        
                
        SELFTEST_END
        
        NubleID result = ID_nuble();
        
        FOR_EACH_INDEX(i, self)
        {
            ID v = [self at:i];
            
            if (result.hasVar)            
            {
                if (isSmaller(result.vd, v) == Yes)
                    result = ID_toNuble(v);
            }
            else
            {
                result = ID_toNuble(v);
            }
        }
        
        return result;        
    }
    
    - (NubleID) min:(ID_IsSmallerXY)isSmaller
    {
        NubleID result = ID_nuble();
        
        FOR_EACH_INDEX(i, self)
        {
            ID v = [self at:i];
            
            if (result.hasVar)
            {
                if (isSmaller(v, result.vd) == Yes)
                    result = ID_toNuble(v);
            }
            else
            {
                result = ID_toNuble(v);
            }
        }
        
        return result;        
    }


@end








@implementation StructList (Algorithm)



    - (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller
    {
        SELFTEST_START
        {
            IntMutableList* list = [IntMutableList create:5];
            [list append :1 :3 :5];
        
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], YES, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 2); }], NO, 1);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 3); }], YES, 1);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 4); }], NO, 2);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 5); }], YES, 2);
        }
        {
            IntMutableList* list = [IntMutableList create:1];
            [list append :2];
        
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], NO, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 2); }], YES, 0);
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 3); }], NO, 1);			
        }
        {
            IntMutableList* list = [IntMutableList create:0];
            BinarySearchResult_assert([list binarySearch:^(Int i) { return Int_isSmallerXY(i, 1); }], NO, 0);
        }		
        
        SELFTEST_END
        
        
        if (self.count == 0) 
            return BinarySearchResult_create(NO, 0);
        
        return [self binarySearch :isSmaller :self.firstIndex :self.lastIndex];		
    }

    - (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller :(Int)start :(Int)end
    {	
        ASSERT([self isValidIndex:start] && [self isValidIndex:end]);
        
        NSMutableData* data = [NSMutableData dataWithLength:toUInt(self.dataSize)];
        
        while (start <= end)
        {		
            Int position = start + ((end - start) / 2); 
            
            [self at :position :[data mutableBytes]];
            
            Bool3 b = isSmaller([data mutableBytes]);
            
            if (b == Unknown)
            {
                return BinarySearchResult_create(YES, position);
            }
            else
            {
                if (b == Yes)
                    start = position + 1;
                else
                    end = position - 1;
            } 
        } 
        
        return BinarySearchResult_create(NO, start);
    }


@end












@implementation ObjectMutableList (Algorithm)


	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY
	{
		SELFTEST_START
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@""));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@""];
		}
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"b,a"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b"];
		}	
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"d,b,c,a"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b,c,d"];
		}	
		{
			StringMutableList* list = StringMutableList_fromStringList(STR(@"a,b,c,d"));
			[list mergeSort:^(String* x, String* y) { return Char_isSmallerXY(x.firstChar, y.firstChar); }];
			[list.debugInfo assert:@"a,b,c,d"];
		}	
		
		SELFTEST_END
		
	
		if (self.count > 1) 
			[self mergeSort :isSmallerXY :self.firstIndex :self.lastIndex]; 
	}
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end
	{
		if (self.count <= 1) 
			return; 

		ASSERT([self isValidIndex:start] && [self isValidIndex:end]); 
		
		ObjectMutableList* helper = [ObjectMutableList create:self.count]; 
		FOR_EACH_INDEX(i, self)
			[helper append:[self at:i]]; 
				
		[self mergeSort :isSmallerXY :start :end :helper]; 
	}
	
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(ObjectMutableList*)helper
	{
		if (start >= end) 
			return;

		Int middle = (start + end) / 2;

		[self mergeSort :isSmallerXY :start :middle :helper];
		[self mergeSort :isSmallerXY :middle + 1 :end :helper];

		for (Int i = start; i <= end; i++)
			[helper modifyAt :i :[self at:i]];

		Int left = start;
		Int right = middle + 1;
		Int index = start;
			
		while (left <= middle && right <= end)
		{
			if (isSmallerXY([helper at:left], [helper at:right]) MbYes)
				[self modifyAt :index++ :[helper at:left++]];
			else
				[self modifyAt :index++ :[helper at:right++]];
		}
	
		for ( ; left <= middle; left++)
			[self modifyAt :index++ :[helper at:left]];

		for ( ; right <= end; right++)
			[self modifyAt :index++ :[helper at:right]];
	}
    
@end



@implementation StructMutableList (Algorithm)



    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY
    {
        SELFTEST_START		
        {
            DoubleMutableList* list = Double_parseList(STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"3.1, 3.2, 3.3, 1.1, 1.2, 1.3, 2.1, 2.2, 2.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"2.1, 2.2, 2.3, 1.1, 1.2, 1.3, 3.1, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"1.1, 1.2, 2.1, 1.3, 2.2, 3.1, 2.3, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"3.1, 3.2, 1.1, 3.3, 1.2, 2.1, 1.3, 2.2, 2.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }
        {
            DoubleMutableList* list = Double_parseList(STR(@"2.1, 2.2, 1.1, 2.3, 1.2, 3.1, 1.3, 3.2, 3.3"));
            [list mergeSort:^(Double x, Double y) { return Double_isSmaller(x, y); } ];	
            [STR(@"1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3") assert:Double_printList(list, 1).ns];	
        }		
        SELFTEST_END
        
        
        if (self.count > 1) 
            [self mergeSort :isSmallerXY :self.firstIndex :self.lastIndex]; 
    }

    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end
    {
        if (self.count <= 1) 
            return; 
        
        ASSERT([self isValidIndex:start] && [self isValidIndex:end]); 
        
        StructMutableList* helper = [StructMutableList create:self.dataSize]; 
        FOR_EACH_INDEX(i, self)
            [helper appendFrom :self :i];
        
        [self mergeSort :isSmallerXY :start :end :helper]; 
    }

    - (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(StructMutableList*)helper
    {
        if (start >= end) 
            return;
        
        NSMutableData* leftData = [NSMutableData dataWithLength:toUInt(self.dataSize)];
        NSMutableData* rightData = [NSMutableData dataWithLength:toUInt(self.dataSize)];
        
        Int middle = (start + end) / 2;
        
        [self mergeSort :isSmallerXY :start :middle :helper];
        [self mergeSort :isSmallerXY :middle + 1 :end :helper];
        
        for (Int i = start; i <= end; i++)
            [helper modifyAtFrom :i :self :i];
        
        Int left = start;
        Int right = middle + 1;
        Int index = start;
        
        while (left <= middle && right <= end)
        {
            [helper at :left :[leftData mutableBytes]];
            [helper at :right :[rightData mutableBytes]];
            
            if (isSmallerXY([leftData mutableBytes], [rightData mutableBytes]) MbYes)
                [self modifyAtFrom :index++ :helper :left++];
            else
                [self modifyAtFrom :index++ :helper :right++];
        }
        
        for ( ; left <= middle; left++)
            [self modifyAtFrom :index++ :helper :left];
        
        for ( ; right <= end; right++)
            [self modifyAtFrom :index++ :helper :right];
    }


@end












