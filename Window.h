






#import <Foundation/Foundation.h>

#import "MathData.h"






@protocol WindowObserver_

	- (void) Window_shake;
	
@end

typedef NSObject<WindowObserver_> WindowObserver;

OBJECT_NUBLE_TEMPLATE(WindowObserver)






@interface Window : UIWindow
	{
		NubleWindowObserver my_observer;
		
        
        
	}
	
    
    + (Window*) create;
    
	
	- (void) setObserver :(WindowObserver*)observer;
	
@end
