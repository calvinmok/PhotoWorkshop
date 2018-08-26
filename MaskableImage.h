


#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>


#import <QuartzCore/QuartzCore.h>

#import <CoreGraphics/CoreGraphics.h>


#import <MobileCoreServices/UTCoreTypes.h>


#import "MathData.h"
#import "Apple.h"
#import "UI_AlertView.h"




NS_INLINE String* DataKey_transform() { return STR(@"transform"); }
NS_INLINE String* DataKey_selectedImageIndex() { return STR(@"selectedImageIndex"); }

NS_INLINE String* DataKey_imageSet() { return STR(@"imageSet"); }


NS_INLINE String* DataKey_originalImage() { return STR(@"originalImage"); }
NS_INLINE String* DataKey_midQualityMask() { return STR(@"midQualityMask"); }
NS_INLINE String* DataKey_lowQualityMask() { return STR(@"lowQualityMask"); }
NS_INLINE String* DataKey_end() { return STR(@"</end/>"); }







@interface Layout : ObjectBase
    {
        id my_view;
        CGSize my_size;
        
        CGSize my_buttonSize;
        CGFloat my_margin;
    }

    + (Layout*) create :(id)view :(CGSize)size;
    
    - (UIButton*) createButton :(Int)row :(Int)column :(UIImage*)image :(SEL)selector;

@end





@interface OriginalImage : ObjectBase
    {
        UIImage* my_image;
        NSData* my_data;
    }
    
    + (OriginalImage*) createWithImage:(UIImage*)image;
    + (OriginalImage*) createWithData:(NSData*)data;
    
    @property(readonly) UIImage* image;
    @property(readonly) NSData* data;
    
    
    - (void) prepare;
    
@end






typedef enum 
{
    ImageMaskTool_Eraser,
    ImageMaskTool_Pencil
}
ImageMaskTool;




typedef struct
{
    UInt8 max;
    UInt8 min;
    UInt8 avg;
}
AggPixelResult;

STRUCT_NUBLE_TEMPLATE(AggPixelResult)


@interface ImageMask : ObjectBase
    {
        ImageMaskTool my_tool;
        
        size_t my_width;
        size_t my_height;
        
        CGContextRef my_context;
    }
    
    + (ImageMask*) create :(CGSize)size ;
    

    @property(readonly) CGSize size;

    - (UIImage*) makeUIImage;

    - (UInt8) get9x9MaxPixel :(CGPoint)point;
    
    - (AggPixelResult) getAggPixel :(CGPoint)point :(CGFloat)penSize;
    	        

    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize;
    
    - (void) replace :(UIImage*)image;
    
    
    
    - (void) setImageMaskTool:(ImageMaskTool)tool;
    
    

@end

OBJECT_NUBLE_TEMPLATE(ImageMask)
OBJECT_LIST_INTERFACE_TEMPLATE(ImageMask, NSObject)









@interface MaskableImage : ObjectBase
    {
        Bool3 my_cacheImageIsSelected;
        NubleUIImage my_cacheImage;
    }
    
    @property(readonly) OriginalImage* originalImage;
    @property(readonly) UIImage* workingImage;
    
    - (UIImage*) makeMaskImage;
        
    - (UIImage*) generateImage :(Bool)selected;
    
    - (void) removeCache;
            
@end

OBJECT_NUBLE_TEMPLATE(MaskableImage)
OBJECT_LIST_INTERFACE_TEMPLATE(MaskableImage, NSObject)


@interface StableMaskableImage : MaskableImage
    {
        OriginalImage* my_originalImage;
        UIImage* my_mask;
    }
    
    + (StableMaskableImage*) create :(OriginalImage*)originalImage :(UIImage*)mask;
    
    - (void) _create :(OriginalImage*)originalImage :(UIImage*)mask;
    
@end


OBJECT_NUBLE_TEMPLATE(StableMaskableImage)
OBJECT_LIST_INTERFACE_TEMPLATE(StableMaskableImage, MaskableImage)


@interface MutableMaskableImage : MaskableImage
    {
        OriginalImage* my_originalImage;
        
        UIImage* my_workingImage;        
        
        ImageMask* my_mask;
        
        Bool my_insideSession;

        UIImageMutableList* my_allUndoLog;        
        UIImageMutableList* my_allRedoLog;  
    }
    

    + (MutableMaskableImage*) create :(OriginalImage*)originalImage :(CGSize)size;
    
    - (void) _create :(OriginalImage*)originalImage :(CGSize)size;
        
        
    - (void) startSession;
         
    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize;
    - (void) setImageMaskTool :(ImageMaskTool)tool;
    
    - (void) endSession;
    
    
    - (void) undo;
    - (void) redo;
    
    - (UInt8) get9x9MaxMaskPixel :(CGPoint)point;
    - (AggPixelResult) getAggMaskPixel :(CGPoint)point :(CGFloat)penSize;
    	                
    
    - (void) replaceMaskImage :(UIImage*)image;
    

@end


OBJECT_NUBLE_TEMPLATE(MutableMaskableImage)
OBJECT_LIST_INTERFACE_TEMPLATE(MutableMaskableImage, MaskableImage)





typedef enum 
{
    ImageQuality_High,
    ImageQuality_Mid,
    ImageQuality_Low
}
ImageQuality;


@interface MaskableImageSet : ObjectBase
    {
        CGAffineTransform my_transform;
    }

    @property(readonly) CGAffineTransform transform;
    
    
    @property(readonly) OriginalImage* originalImage;
    
    - (UIImage*) generateImage :(ImageQuality)quality :(Bool)selected;
    
    - (UIImage*) createMaskImage :(ImageQuality)quality;
                
@end

OBJECT_NUBLE_TEMPLATE(MaskableImageSet)
OBJECT_LIST_INTERFACE_TEMPLATE(MaskableImageSet, NSObject)


@interface StableMaskableImageSet : MaskableImageSet
    {
        StableMaskableImage* my_image;
    }

    + (StableMaskableImageSet*) create :(MaskableImageSet*)imageSet;

@end

OBJECT_NUBLE_TEMPLATE(StableMaskableImageSet)
OBJECT_LIST_INTERFACE_TEMPLATE(StableMaskableImageSet, MaskableImageSet)


@class MutableMaskableImageSet;

OBJECT_NUBLE_TEMPLATE(MutableMaskableImageSet)
OBJECT_LIST_INTERFACE_TEMPLATE(MutableMaskableImageSet, MaskableImageSet)

@interface MutableMaskableImageSet : MaskableImageSet
    {
        MutableMaskableImage* my_midQuality;
        MutableMaskableImage* my_lowQuality;
    }
    
    + (MutableMaskableImageSet*) create :(OriginalImage*)originalImage;
    
    - (void) _create:(OriginalImage*)originalImage;
    
    
    - (void) setTransform:(CGAffineTransform)transform;
    
            
    - (UInt8) get9x9MaxMaskPixel :(CGPoint)point;
    - (AggPixelResult) getAggMaskPixel :(CGPoint)point :(CGFloat)penSize;
    	            	            
    
    - (void) startSession;
         
    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize;
    - (void) setImageMaskTool :(ImageMaskTool)tool;
    
    - (void) endSession;
        
    
    - (void) undo;
    - (void) redo;
    

    + (NubleMutableMaskableImageSet) createFromFlow :(ReadingFlow*)flow;
    - (void) writeToFlow:(WritingFlow*)flow;
    
@end








UIImage* createBackgroundImage(CGSize size);




