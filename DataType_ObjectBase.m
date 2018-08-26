





#import "DataType.h"







@implementation ObjectBase

	- (id) init
	{
		self = [super init];
		if (self) 
		{
			[self ObjectBase_init];
		}
		
		return self;
	}
	
	- (void) ObjectBase_init
	{
	}
	
	
	
	
	- (void) dealloc
	{
		[self ObjectBase_dealloc];
		[super dealloc];
	}
	
	- (void) ObjectBase_dealloc;
	{
	}	
    
    
    
    - (void) doesNotRecognizeSelector:(SEL)aSelector
    {
        BREAK();
        [super doesNotRecognizeSelector:aSelector];
    }
	
	
@end






@implementation ObjectBase (_) 




@end






void Exception_raise(void)
{
    NSException* exception = [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    [exception raise];
}





Bool3 Class_isSubClassOf(Class me, Class cLass)
{
    SELFTEST_START
        ASSERT(Class_isSubClassOf([String class], [String class]) == Unknown);
        ASSERT(Class_isSubClassOf([String class], [StableString superclass]) == Unknown);
        
        ASSERT(Class_isSubClassOf([StableString class], [MutableString class]) == No);

        ASSERT(Class_isSubClassOf([StableString class], [String class]) == Yes);
    
    SELFTEST_END
    
    if (me == cLass)
        return Unknown;
        
    for (Class c = me; c != nil; )
    {
        c = Class_superClass(c);
        
        if (c == cLass)
            return Yes;            
    }
    
    return No;
}

Bool Class_isKindOf(Class me, Class cLass) 
{ 
    return (Class_isSubClassOf(me, cLass) MbYes); 
}








