



#import "MaskableImage.h"




@interface MaskableImageView : UIView<UIGestureRecognizerDelegate>
    {    
        UIImageView* my_imageView;
                                
        Bool my_isEditing;
        ImageMaskTool my_imageMaskTool;
        
        NubleCGPoint my_lastToPoint;
        
        NubleMutableMaskableImageSet my_maskableImageSet;
        
    }

    + (MaskableImageView*) create :(CGSize)size;
    
    - (void) _create :(CGSize)size;
    
    @property(readonly) ImageMaskTool imageMaskTool;
    - (void) setImageMaskTool :(ImageMaskTool)tool;
    
    
    - (void) setMaskableImageSet :(NubleMutableMaskableImageSet)maskableImageSet;
    @property(readonly) NubleMutableMaskableImageSet maskableImageSet;
    
    
    - (void) initImageView;    
    - (void) reloadImageView;
    
    - (void) undo;
    - (void) redo;
    

@end













@protocol MaskableImageViewControllerOwner_

	- (void) MaskableImageViewController_close;

	
@end

typedef NSObject<MaskableImageViewControllerOwner_> MaskableImageViewControllerOwner;




@interface MaskableImageViewController : UIViewController
    {
        MaskableImageViewControllerOwner* my_owner;
        
                        
        UIView* my_rootView;
        
        UIImageView* my_backgroundImageView;

        MaskableImageView* my_maskableImageView;
        
        UIButton* my_closeButton;
        
        UIButton* my_undoButton;
        UIButton* my_redoButton;
        
        UIButton* my_eraserButton;
        UIButton* my_pencilButton;
        
    }


    + (MaskableImageViewController*) create :(MaskableImageViewControllerOwner*)owner :(CGSize)size;
    
    - (void) _create :(MaskableImageViewControllerOwner*)owner :(CGSize)size;
    
    
    
    - (void) _close;
    

    @property(readonly) NubleMutableMaskableImageSet maskableImageSet;
    - (void) setMaskableImageSet :(NubleMutableMaskableImageSet)maskableImageSet;
    
            
    - (void) undo;
    - (void) redo;
    
    - (void) _eraser;
    - (void) _pencil;
    
    @property(readonly) CGAffineTransform _eraserButtonTransform;
    @property(readonly) CGAffineTransform _pencilButtonTransform;
    
    
    
@end













