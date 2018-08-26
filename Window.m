






#import "Window.h"

@implementation Window







    + (Window*) create
    {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        Window* result =  [[[Window alloc] initWithFrame:bounds] autorelease];
        return result;
    }
	
	- (void) setObserver :(WindowObserver*)observer
	{
		my_observer = WindowObserver_toNuble(observer);
	}
		
        
        
        
        
	- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
	{
		if (motion == UIEventSubtypeMotionShake)
		{			
			if (my_observer.hasVar)
				[my_observer.vd Window_shake];
		}		
	}
        
@end
