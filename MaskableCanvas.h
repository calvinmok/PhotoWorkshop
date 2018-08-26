






#import "MaskableImage.h"




typedef enum
{
    IsThumbnail_Yes,
    IsThumbnail_No
}
IsThumbnail;






@interface MaskableCanvas : ObjectBase


    @property(readonly) CGAffineTransform transform;
    
    
    @property(readonly) Int count;
	@property(readonly) NubleInt firstIndex_;
	@property(readonly) NubleInt lastIndex_;
    
    
    
    - (MaskableImageSet*) imageSetAt :(Int)index;
    
    
    @property(readonly) NubleMaskableImageSet selectedImageSet;
    @property(readonly) NubleInt selectedImageSetIndex;
        

    - (UIImage*) generateImage :(CGSize)frameSize :(ImageQuality)imageQuality :(IsThumbnail)isThumbnail;
    
    
    - (UIImage*) createThumbnailWithBackground :(CGSize)viewSize :(CGSize)outputSize;
    

@end

OBJECT_NUBLE_TEMPLATE(MaskableCanvas)
OBJECT_LIST_INTERFACE_TEMPLATE(MaskableCanvas, NSObject)




@interface StableMaskableCanvas : MaskableCanvas
    {
        CGSize my_size;
        
        CGAffineTransform my_transform;
        
        StableMaskableImageSetStableList* my_allImageSet;
    }
    
    + (StableMaskableCanvas*) create :(CGSize)size :(CGFloat)scale :(MaskableCanvas*)canvas;
        
    - (UIImage*) generateImage;

@end

OBJECT_NUBLE_TEMPLATE(StableMaskableCanvas)
OBJECT_LIST_INTERFACE_TEMPLATE(StableMaskableCanvas, MaskableCanvas)





@class MutableMaskableCanvas;
OBJECT_NUBLE_TEMPLATE(MutableMaskableCanvas)
OBJECT_LIST_INTERFACE_TEMPLATE(MutableMaskableCanvas, MaskableCanvas)

@protocol MutableMaskableCanvasOwner_

    - (void) MutableMaskableCanvas_selectedImageChanged:(NubleInt)index;

@end

typedef NSObject<MutableMaskableCanvasOwner_> MutableMaskableCanvasOwner;


@interface MutableMaskableCanvas : MaskableCanvas
    {
    @public 
        MutableMaskableCanvasOwner* my_owner;
    
        NubleInt my_selectedImageSetIndex;
    
        CGAffineTransform my_transform;
    
        MutableMaskableImageSetMutableList* my_allImageSet;
    }
    
    
    + (MutableMaskableCanvas*) create :(MutableMaskableCanvasOwner*)owner;
    
            
    - (NubleInt) findMaskableImageIndex:(CGPoint)location;
    
    
    @property(readonly) CGAffineTransform transform;
    - (void) setTransform :(CGAffineTransform)transform;
    
    
    - (MutableMaskableImageSet*) imageSetAt_ :(Int)index;
    - (Int) appendMaskableImageSet :(MutableMaskableImageSet*)maskableImageSet;

    

    - (void) setSelectedImageSetIndex:(NubleInt)index;
    

    - (void) up;
    - (void) down;
    - (void) deleteImage;
    
    + (NubleMutableMaskableCanvas) createFromFlow :(MutableMaskableCanvasOwner*)owner :(ReadingFlow*)flow;
    - (void) writeToFlow:(WritingFlow*)flow;    
    

@end
















