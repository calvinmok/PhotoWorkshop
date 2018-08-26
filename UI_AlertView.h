








#import "Apple.h"

#import "DataType.h"






#define UIViewAutoresizingFlexibleWidthAndHeight \
    UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight


#define UIViewAutoresizingFlexibleLeftAndRightMargin \
    UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin

#define UIViewAutoresizingFlexibleTopAndBottomMargin \
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin


#define UIViewAutoresizingFlexibleLeftAndTopMargin \
    UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin

#define UIViewAutoresizingFlexibleLeftAndBottomMargin \
    UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin


#define UIViewAutoresizingFlexibleRightAndTopMargin \
    UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin

#define UIViewAutoresizingFlexibleRightAndBottomMargin \
    UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin












@interface AlertView : ObjectBase

    + (void) showMessage :(String*)message;
    + (void) showTitleAndMessage :(String*)title :(String*)message;

@end





@class OkCancelAlertView;

@protocol OkCancelAlertView_Owner_

    - (void) OkCancelAlertView_ok :(OkCancelAlertView*)ownee;
    - (void) OkCancelAlertView_cancel :(OkCancelAlertView*)ownee;
	
@end

typedef NSObject<OkCancelAlertView_Owner_> OkCancelAlertView_Owner;


@interface OkCancelAlertView : ObjectBase<UIAlertViewDelegate>
    {
        OkCancelAlertView_Owner* my_owner;
        UIAlertView* my_uiAlertView;
    }
    
    + (OkCancelAlertView*) create :(OkCancelAlertView_Owner*)owner;
    
    
    - (void) setTitle :(String*)title;
    - (void) setMessage :(String*)message;
    
    - (void) show;    

@end












@protocol InputBoxViewController_Owner_

    - (void) InputBoxViewController_submit;
	
@end

typedef NSObject<InputBoxViewController_Owner_> InputBoxViewController_Owner;




@interface InputBoxViewController : UIViewController<UITextFieldDelegate>
    {
        InputBoxViewController_Owner* my_owner;
        

        UIView* my_rootView;
        
        UILabel* my_label;
        
        UITextField* my_textField;
    }
    

    + (InputBoxViewController*) create :(InputBoxViewController_Owner*)owner;
    
    - (void) _create :(InputBoxViewController_Owner*)owner;
    
    - (void) _layout;
    
    
	- (void)keyboardDidShow:(NSNotification*)notification;
	- (void)keyboardDidHide:(NSNotification*)notification;
    
        
    
    - (void) setLabel :(String*)label;


    
    - (void) prepare :(String*)text;
    

@end






NS_INLINE UIFont* UIFont_systemLabel(void) { return [UIFont systemFontOfSize:[UIFont labelFontSize]]; }





OBJECT_NUBLE_TEMPLATE(UITableView)
OBJECT_NUBLE_TEMPLATE(UITableViewCell)

@interface UITableView(_)

    - (UITableViewCell*)cellForRow:(NSInteger)row inSection:(NSInteger)section;

@end












