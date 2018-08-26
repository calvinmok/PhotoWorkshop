











#import "UI_AlertView.h"




@implementation AlertView

    + (void) showMessage :(String*)message
    {
        [AlertView showTitleAndMessage :STR(@"") :message];
    }
    
    + (void) showTitleAndMessage :(String*)title :(String*)message
    {
        UIAlertView* alert = [[[UIAlertView alloc] 
            initWithTitle:			title.ns
            message:				message.ns
            delegate:				nil 
            cancelButtonTitle:		@"OK" 
            otherButtonTitles:		nil] autorelease];
				
        [alert show];
    }

@end



@implementation OkCancelAlertView

    + (OkCancelAlertView*) create :(OkCancelAlertView_Owner*)owner;
    {
        OkCancelAlertView* result = [[[OkCancelAlertView alloc] init] autorelease];
        
        result->my_owner = owner;
        
        result->my_uiAlertView = [[UIAlertView alloc] 
            initWithTitle:@"" message:@"" delegate:result 
            cancelButtonTitle:@"Cancel" 
            otherButtonTitles:@"OK", nil];
        
        return result;
    }
    
    - (void) dealloc
    {
        [my_uiAlertView release];
        [super dealloc];
    }



    
    - (void) setTitle :(String*)title
    {
        my_uiAlertView.title = title.ns;
    }
    
    - (void) setMessage :(String*)message
    {
        my_uiAlertView.message = message.ns;
    }
    
    
    
    - (void) show
    {
        [my_uiAlertView show];
    }
    
    

	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
	{
		if (alertView == my_uiAlertView)
		{
			if (buttonIndex != alertView.cancelButtonIndex)
				[my_owner OkCancelAlertView_ok :self];
            else
				[my_owner OkCancelAlertView_cancel :self];
		}
	}
	
	    

@end















@implementation InputBoxViewController


    + (InputBoxViewController*) create :(InputBoxViewController_Owner*)owner
    {
        InputBoxViewController* result = [[[InputBoxViewController alloc] init] autorelease];
        [result _create:owner];
        return result;
    }
    
    - (void) _create :(InputBoxViewController_Owner*)owner
    {
        my_owner = owner;
        
		NSNotificationCenter* dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];			
		[dnc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
                
        my_rootView = [[UIView alloc] init];      
        my_rootView.autoresizingMask = UIViewAutoresizingFlexibleWidthAndHeight;  
        my_rootView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        my_label = [[UILabel alloc] init];
        
        my_textField = [[UITextField alloc] init];
        my_textField.delegate = self;
        
        
        [my_rootView addSubview:my_label];
        [my_rootView addSubview:my_textField];
    }
    
    - (void) dealloc
    {
        [my_rootView release];
        [my_label release];
        [my_textField release];
        
        [super dealloc];
    }
    
    
    
    - (void) _layout
    {
        my_label.autoresizingMask = UIViewAutoresizingFlexibleTopAndBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        my_textField.autoresizingMask = UIViewAutoresizingFlexibleTopAndBottomMargin;

    
        
		CGSize labelSize = [my_label.text sizeWithFont:UIFont_systemLabel()];
        CGFloat margin = labelSize.height;
        
        
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        CGPoint midPoint = CGPointMake(appFrame.size.width / 2, appFrame.size.height / 2);
        
    
        my_rootView.frame = appFrame;
        
        
        CGRect labelFrame = CGPoint_expandToRect(midPoint, labelSize.width, labelSize.height);
        labelFrame.origin.x = margin;
        my_label.frame = labelFrame;
        
        CGFloat textFieldWidth = appFrame.size.width - labelSize.width - (margin * 2);
        CGRect textFieldFrame = CGPoint_expandToRect(midPoint, textFieldWidth, labelSize.height);
        textFieldFrame = CGRect_moveRightTo(textFieldFrame, appFrame.size.width - margin);
        my_textField.frame = textFieldFrame;
        
        
        
        
        
        
    
    }
    
        
        
	- (void) loadView
	{
        [self _layout];
        self.view = my_rootView;
    }
    
    
	- (void)keyboardDidShow:(NSNotification*)notification
	{
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
                
		NSDictionary* info = [notification userInfo];
		CGSize keybroadSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        my_rootView.frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height - keybroadSize.height);
	}
	
	- (void)keyboardDidHide:(NSNotification*)notification
	{
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        
        my_rootView.frame = appFrame;
	}
			
    
    
    		
	- (BOOL)textFieldShouldReturn:(UITextField *)textField
	{
		[my_textField resignFirstResponder];
        
        [my_owner InputBoxViewController_submit];
        
		return YES;
	}	
	



    - (void) setLabel :(String*)label
    {
        my_label.text = label.ns;
    }


    - (void) prepare :(String*)text
    {
        [my_textField setText:text.ns];
        [my_textField becomeFirstResponder];        
    }


@end













@implementation UITableView(_)

    - (UITableViewCell*)cellForRow:(NSInteger)row inSection:(NSInteger)section
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];    
        return [self cellForRowAtIndexPath:indexPath];
    }

@end















