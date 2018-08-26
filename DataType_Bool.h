












NS_INLINE Bool Bool_(Bool value) { return value; }

NS_INLINE NubleBool nubleYes(void) { return Bool_toNuble(YES); }
NS_INLINE NubleBool nubleNo(void) { return Bool_toNuble(NO); }



NS_INLINE Int Bool_compare(Bool x, Bool y) { if (x == y) return 0; else return (x == NO) ? -1 : 1; }
	
	

NS_INLINE Int Bool_toCompare(NubleBool v) { return (v.hasVar) ? (v.vd ? 1 : -1) : 0; }
    



NS_INLINE Bool varOrYes(NubleBool v) { return (v.hasVar) ? v.vd : YES; }
NS_INLINE Bool varOrNo(NubleBool v) { return (v.hasVar) ? v.vd : NO; }


NS_INLINE Bool isNubleYes(NubleBool me) { return (me.hasVar && me.vd == YES); }
NS_INLINE Bool isNubleNo(NubleBool me) { return (me.hasVar && me.vd == NO); }

NS_INLINE Bool isNotNubleYes(NubleBool me) { return (isNubleYes(me) == NO); }
NS_INLINE Bool isNotNubleNo(NubleBool me) { return (isNubleNo(me) == NO); }


NubleBool nubleNot(NubleBool value);
NubleBool nubleAnd(NubleBool x, NubleBool y);
NubleBool nubleOr(NubleBool x, NubleBool y);
NubleBool nubleXor(NubleBool x, NubleBool y);





String* Bool_print(Bool value);
NubleBool Bool_parse(String* value);

StableString* Bool_representation(Bool value);



NubleBool Bool_parseTrueFalse(String* str);






void Bool_assert(NubleBool self, Char value);




void Bool_selfTest(void);







NS_INLINE Bool3 not(Bool3 b) { return -b; }

NS_INLINE Bool3 and(Bool3 a, Bool3 b) 
{ 
    if (a == No  || b == No ) return No;
    if (a == Yes && b == Yes) return Yes;
    return Unknown; 
}

NS_INLINE Bool3 or(Bool3 a, Bool3 b) 
{ 
    if (a == Yes || b == Yes) return Yes;
    if (a == No  && b == No ) return No;
    return Unknown;    
}




NS_INLINE BOOL anyYes2(Bool3 a, Bool3 b)                   { return (a == Yes || b == Yes); }
NS_INLINE BOOL anyYes3(Bool3 a, Bool3 b, Bool3 c)          { return (a == Yes || b == Yes || c == Yes); }
NS_INLINE BOOL anyYes4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == Yes || b == Yes || c == Yes || d == Yes); }

NS_INLINE BOOL anyUnknown2(Bool3 a, Bool3 b)                   { return (a == Unknown || b == Unknown); }
NS_INLINE BOOL anyUnknown3(Bool3 a, Bool3 b, Bool3 c)          { return (a == Unknown || b == Unknown || c == Unknown); }
NS_INLINE BOOL anyUnknown4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == Unknown || b == Unknown || c == Unknown || d == Unknown); }

NS_INLINE BOOL anyNo2(Bool3 a, Bool3 b)                   { return (a == No || b == No); }
NS_INLINE BOOL anyNo3(Bool3 a, Bool3 b, Bool3 c)          { return (a == No || b == No || c == No); }
NS_INLINE BOOL anyNo4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == No || b == No || c == No || d == No); }


NS_INLINE BOOL allYes2(Bool3 a, Bool3 b)                   { return (a == Yes && b == Yes); }
NS_INLINE BOOL allYes3(Bool3 a, Bool3 b, Bool3 c)          { return (a == Yes && b == Yes && c == Yes); }
NS_INLINE BOOL allYes4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == Yes && b == Yes && c == Yes && d == Yes); }

NS_INLINE BOOL allUnknown2(Bool3 a, Bool3 b)                   { return (a == Unknown && b == Unknown); }
NS_INLINE BOOL allUnknown3(Bool3 a, Bool3 b, Bool3 c)          { return (a == Unknown && b == Unknown && c == Unknown); }
NS_INLINE BOOL allUnknown4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == Unknown && b == Unknown && c == Unknown && d == Unknown); }

NS_INLINE BOOL allNo2(Bool3 a, Bool3 b)                   { return (a == No && b == No); }
NS_INLINE BOOL allNo3(Bool3 a, Bool3 b, Bool3 c)          { return (a == No && b == No && c == No); }
NS_INLINE BOOL allNo4(Bool3 a, Bool3 b, Bool3 c, Bool3 d) { return (a == No && b == No && c == No && d == No); }











/*



STRUCT_NUBLE_TEMPLATE(BOOL)


@interface Bool3 :ObjectBase


    + (Bool3*) from:(NubleBOOL)value;
    
    - (Bool3*) Not;        
    - (Bool3*) And: (Bool3*)other;
    - (Bool3*) Or: (Bool3*)other;
    
    
    
@end




@interface Bool2 : Bool3

    + (Bool2*) from:(BOOL)value;

//    @property(readonly) BOOL b;

@end


#define Unknown [Bool3 from:BOOL_nuble()]

#define Yes [Bool2 from:YES]
#define No  [Bool2 from:NO]




NS_INLINE Bool2* anyIsYes3(Bool3* a, Bool3* b, Bool3* c)
{
    if (a == Yes) return Yes;
    if (b == Yes) return Yes;
    if (c == Yes) return Yes;
    return No;
}


*/
 
















