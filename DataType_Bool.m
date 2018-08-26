



#import "DataType.h"











NubleBool nubleNot(NubleBool value)
{
	if (value.hasVar) 
		return Bool_toNuble(value.vd == NO);

	return Bool_nuble();
}


NubleBool nubleAnd(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd && y.vd);
	if (x.hasVar) return (x.vd) ? Bool_nuble() : nubleNo();
	if (y.hasVar) return (y.vd) ? Bool_nuble() : nubleNo();
	return Bool_nuble();
}

NubleBool nubleOr(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd || y.vd);
	if (x.hasVar) return (x.vd) ? nubleYes() : Bool_nuble();
	if (y.hasVar) return (y.vd) ? nubleYes() : Bool_nuble();
	return Bool_nuble();
}

NubleBool nubleXor(NubleBool x, NubleBool y)
{
	if (x.hasVar && y.hasVar) return Bool_toNuble(x.vd ^ y.vd);
	return Bool_nuble();
}






String* Bool_print(Bool value)
{
	return (value) ? STR(@"Yes") : STR(@"No");
}

NubleBool Bool_parse(String* value)
{
	if (value.length > 0)
	{		
		Char c = [value charAt:0];
		if (c == CHAR(Y) || c == CHAR(y)) return nubleYes();
		if (c == CHAR(N) || c == CHAR(n)) return nubleNo();
	}
	
	return Bool_nuble();
}


StableString* Bool_representation(Bool self)
{
	STATIC_OBJECT(StableString, yesString, STR(@"YES"));
	STATIC_OBJECT(StableString, noString, STR(@"NO"));
	return self ? yesString : noString;
}





NubleBool Bool_parseTrueFalse(String* str) 
{
	String* l = str.lower; 
	if ([l eq:STR(@"true")]) return nubleYes(); 
	if ([l eq:STR(@"false")]) return nubleNo(); 
	return Bool_nuble(); 
}





void Bool_assert(NubleBool self, Char value) 
{
	value = Char_upper(value);
	
	if (self.hasVar)
	{
		if (self.vd)
			ASSERT(value == CHAR(Y));
		else
			ASSERT(value == CHAR(N));
	}
	else 
	{
		ASSERT(value == CHAR(?));
	}
}




void Bool_selfTest(void)
{
	NubleBool nuble = Bool_nuble();
	NubleBool nubleYes = Bool_toNuble(YES);
	NubleBool nubleNo = Bool_toNuble(NO);

	Bool_assert(nuble, CHAR(?));
	Bool_assert(nubleYes, CHAR(Y));
	Bool_assert(nubleNo, CHAR(N));

	Bool_assert(nubleNot(nuble), CHAR(?));
	Bool_assert(nubleNot(nubleNo), CHAR(Y));
	Bool_assert(nubleNot(nubleYes), CHAR(N));

	
	Bool_assert(nubleAnd(nuble, nuble), CHAR(?));

	Bool_assert(nubleAnd(nubleYes, nubleYes), CHAR(Y));
	Bool_assert(nubleAnd(nubleYes, nubleNo), CHAR(N));
	Bool_assert(nubleAnd(nubleNo, nubleYes), CHAR(N));
	Bool_assert(nubleAnd(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleAnd(nuble, nubleYes), CHAR(?));
	Bool_assert(nubleAnd(nuble, nubleNo), CHAR(N));
	Bool_assert(nubleAnd(nubleYes, nuble), CHAR(?));
	Bool_assert(nubleAnd(nubleNo, nuble), CHAR(N));


	Bool_assert(nubleOr(nuble, nuble), CHAR(?));

	Bool_assert(nubleOr(nubleYes, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nubleYes, nubleNo), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleOr(nuble, nubleYes), CHAR(Y));
	Bool_assert(nubleOr(nuble, nubleNo), CHAR(?));
	Bool_assert(nubleOr(nubleYes, nuble), CHAR(Y));
	Bool_assert(nubleOr(nubleNo, nuble), CHAR(?));

	
	Bool_assert(nubleXor(nuble, nuble), CHAR(?));	

	Bool_assert(nubleXor(nubleYes, nubleYes), CHAR(N));
	Bool_assert(nubleXor(nubleYes, nubleNo), CHAR(Y));
	Bool_assert(nubleXor(nubleNo, nubleYes), CHAR(Y));
	Bool_assert(nubleXor(nubleNo, nubleNo), CHAR(N));
	
	Bool_assert(nubleXor(nuble, nubleYes), CHAR(?));
	Bool_assert(nubleXor(nuble, nubleNo), CHAR(?));
	Bool_assert(nubleXor(nubleYes, nuble), CHAR(?));
	Bool_assert(nubleXor(nubleNo, nuble), CHAR(?));

}











/*

@implementation Bool3 :ObjectBase



    + (Bool3*) from:(NubleBOOL)value
    {        
        if (value.hasVar) 
            return [Bool2 from:value.vd];
                
        static Bool3* u = nil; 
        if (u == nil) 
            u = [[Bool3 alloc] init]; 

        return u;
    }


    - (Bool3*) And: (Bool3*)other
    {
        if (self == No || other == No)
            return No;
            
        if (self == Yes && other == Yes)
            return Yes;

        return Unknown;
    }
    
    - (Bool3*) Or: (Bool3*)other
    {
        if (self == Yes || other == Yes)
            return Yes;
            
        if (self == No && other == No)
            return No;

        return Unknown;    
    }
    
    
@end


@implementation Bool2 : Bool3


    + (Bool2*) from:(BOOL)value
    {
        static Bool2* y = nil; 
        if (y == nil) 
            y = [[Bool2 alloc] init]; 

        static Bool2* n = nil; 
        if (n == nil) 
            n = [[Bool2 alloc] init]; 
            
        return (value == YES) ? y : n;
    }

    
    

@end


*/

















