






#import "MaskableCanvas.h"


#import "MaskableImageView.h"








@protocol MaskableCanvasViewOwner_

	
    - (void) MaskableCanvasView_selectedImageChanged:(NubleInt)index;

	
@end

typedef NSObject<MaskableCanvasViewOwner_> MaskableCanvasViewOwner;



@interface MaskableCanvasView : UIView<UIGestureRecognizerDelegate, MutableMaskableCanvasOwner_>
    {
        MaskableCanvasViewOwner* my_owner;
        
        NubleMutableMaskableCanvas my_maskableCanvas;
        
        UIImageView* my_imageView;
        
        
        NubleInt my_gestureImageIndex;
        
        
    }
    
    + (MaskableCanvasView*) create :(MaskableCanvasViewOwner*)owner :(CGSize)size;
    
    - (void) _create :(MaskableCanvasViewOwner*)owner :(CGSize)size;
    
    
    - (NubleInt) _findMaskableImageIndex:(UIGestureRecognizer*)gestureRecognizer;
    
    
    @property(readonly) NubleMutableMaskableCanvas maskableCanvas;
    - (void) setMaskableCanvas:(NubleMutableMaskableCanvas)maskableCanvas;
    
    
    
    - (void) reload:(ImageQuality)imageQuality;
        
    - (void) setCanvasEnabled:(Bool)enabled;
    
    
    - (StableMaskableCanvas*) createStableCanvas;
        
        
    - (void) up;
    - (void) down;
    - (void) deleteImage;
        

@end








@protocol MaskableCanvasViewControllerOwner_

    
    - (void) MaskableCanvasViewController_openProjectMenu;
    
	
@end

typedef NSObject<MaskableCanvasViewControllerOwner_> MaskableCanvasViewControllerOwner;




#define MaskableCanvasViewController_PROTOCOL \
    \
    UINavigationControllerDelegate, \
    UIImagePickerControllerDelegate, \
    UIActionSheetDelegate, \
    \
    MaskableCanvasViewOwner_, \
    MaskableImageViewControllerOwner_, \
    \
    OkCancelAlertView_Owner_


@interface MaskableCanvasViewController : UIViewController<MaskableCanvasViewController_PROTOCOL>
    {
        MaskableCanvasViewControllerOwner* my_owner;
        
        UIImagePickerController* my_imagePicker;
        UIPopoverController* my_popoverOrNil;
        
		UIActionSheet* my_cameraActionSheet;
        OkCancelAlertView* my_deleteAlertView;
        OkCancelAlertView* my_exportAlertView;
        

        UIView* my_rootView;
        
        MaskableCanvasView* my_maskableCanvasView;
        
        UIImageView* my_backgroundImageView;
        
        
        MaskableImageViewController* my_maskableImageVC;
        

        UIButton* my_openProjectMenuButton;
        
        UIButton* my_upButton;
        UIButton* my_downButton;
        
        UIButton* my_importButton;
        UIButton* my_exportButton;
        UIButton* my_deleteButton;
        
        UIButton* my_editButton;

        
        
        UIActivityIndicatorView* my_activityIndicator;
        
    }


    + (MaskableCanvasViewController*) create :(MaskableCanvasViewControllerOwner*)owner :(CGRect)rootFrame;
    
    - (void) _create :(MaskableCanvasViewControllerOwner*)owner :(CGRect)rootFrame;
    
    
    - (void) _import;
    - (void) _export;
    
    - (void) _exporting:(StableMaskableCanvas*)canvas;
    - (void) image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
    - (void) _exportCompleted;    
    

    - (void) _up;
    - (void) _down;
    - (void) _delete;
    
    - (void) _edit;

    
    - (void) reload;
    
    - (void) undo;
    
    
    
    - (void) setEnabled:(Bool)enabled;
    
    
    
    - (void) newCanvas;
        
    - (Bool) saveCanvasToFlow :(WritingFlow*)flow;
    - (void) loadCanvasFromFlow:(ReadingFlow*)flow;   
    
    - (UIImage*) createThumbnailWithBackground :(CGSize)outputSize;

    
    - (void) _showTakePicture;
    - (void) _showSelectPicture;

@end










