






#import "MaskableCanvas.h"


#import <MobileCoreServices/UTCoreTypes.h>






OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MaskableCanvas, NSObject)

@implementation MaskableCanvas

    - (CGAffineTransform) transform { ABSTRACT_METHOD(CGAffineTransform) }

    - (Int) count { ABSTRACT_METHOD(Int) }
    - (NubleInt) firstIndex_ { ABSTRACT_METHOD(NubleInt) }
    - (NubleInt) lastIndex_ { ABSTRACT_METHOD(NubleInt) }
        
    - (MaskableImageSet*) imageSetAt :(Int)index { ABSTRACT_METHOD_NIL }
  
  
    - (NubleMaskableImageSet) selectedImageSet
    {
        NubleInt i = self.selectedImageSetIndex;
        if (i.hasVar)  
            return MaskableImageSet_toNuble([self imageSetAt:i.vd]);
        else 
            return MaskableImageSet_nuble();
    }    
      
    - (NubleInt) selectedImageSetIndex { return Int_nuble(); }
    
    
    
    
    - (UIImage*) generateImage :(CGSize)frameSize :(ImageQuality)imageQuality  :(IsThumbnail)isThumbnail
    {
        CGPoint midPoint = CGPointMake(frameSize.width / 2, frameSize.height / 2);
                
                
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        CGContextRef context = CGBitmapContextCreate(NULL, frameSize.width, frameSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);

        CGColorSpaceRelease(colorSpace);
        
        FOR_EACH_INDEX(i, self)
        {
            CGContextSaveGState(context);

            Bool imageSelected = false;
            if (isThumbnail == IsThumbnail_No && self.selectedImageSetIndex.hasVar)
                imageSelected = (i == self.selectedImageSetIndex.vd);
            

            CGContextTranslateCTM(context, midPoint.x, midPoint.y);

            CGContextConcatCTM(context, self.transform);

            CGContextConcatCTM(context, [self imageSetAt :i].transform);

            CGSize size = [self imageSetAt :i].originalImage.image.size;            
            
            UIImage* uiImage = [[self imageSetAt :i] generateImage :imageQuality :imageSelected];
            
            CGFloat x = -(size.width / 2.f);
            CGFloat y = -(size.height / 2.f);
            
            CGContextDrawImage(context, CGRectMake(x, y, size.width, size.height), uiImage.CGImage);                 

            CGContextRestoreGState(context);
        }
        
        UIImage* result = CGContext_makeUIImage(context);
        
        CGContextRelease(context);
        
        return result;
    }
    

    - (UIImage*) createThumbnailWithBackground :(CGSize)viewSize :(CGSize)outputSize
    {
        CGRect rect = CGRect_shrinkRatio(CGSize_toRect(outputSize, 0, 0), CGSize_ratio_(viewSize).vd);        
        UIImage* image = [self generateImage :viewSize :ImageQuality_High :IsThumbnail_Yes];
        
                                    
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, outputSize.width, outputSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(colorSpace);
        
        
        CGContextDrawImage(context, CGSize_toRect(outputSize, 0, 0), createBackgroundImage(outputSize).CGImage);
        CGContextDrawImage(context, rect, image.CGImage);
        
        CGImageRef cgResult = CGBitmapContextCreateImage(context);    
        UIImage* result = [UIImage imageWithCGImage:cgResult];
        
        CGImageRelease(cgResult);
        CGContextRelease(context);
            
        return result;
    }


@end




OBJECT_LIST_IMPLEMENTATION_TEMPLATE(StableMaskableCanvas, MaskableCanvas)

@implementation StableMaskableCanvas


    + (StableMaskableCanvas*) create :(CGSize)size :(CGFloat)scale :(MaskableCanvas*)canvas
    {
        StableMaskableImageSetMutableList* allImageSet = [StableMaskableImageSetMutableList create:canvas.count];
        
        FOR_EACH_INDEX(i, canvas)
        {
            MaskableImageSet* imageSet = [canvas imageSetAt:i];
            [allImageSet append:[StableMaskableImageSet create :imageSet]];
        }        
        
        CGAffineTransform transform = canvas.transform;
        //CGPoint t = CGPointMake(transform.tx, transform.ty);
                
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(scale, scale));
        /*
        transform = CGAffineTransformTranslate(transform, -t.x, -t.y);
        transform = CGAffineTransformScale(transform, scale, scale);
        transform = CGAffineTransformTranslate(transform, t.x, t.y);
        */
        
        StableMaskableCanvas* result = [[[StableMaskableCanvas alloc] init] autorelease];
        result->my_size = size;
        result->my_transform = transform;
        result->my_allImageSet = [[allImageSet seal] retain];
        return result;        
    }
    
    - (void) dealloc
    {
        [my_allImageSet release];
        [super dealloc];
    }
        

    - (CGAffineTransform) transform { return my_transform; }

    - (Int) count { return my_allImageSet.count; }
    - (NubleInt) firstIndex_ { return my_allImageSet.firstIndex_; }
    - (NubleInt) lastIndex_ { return my_allImageSet.lastIndex_; }
    
    - (MaskableImageSet*) imageSetAt :(Int)index { return [my_allImageSet at:index]; }


    - (UIImage*) generateImage
    {
        return [self generateImage :my_size :ImageQuality_High :IsThumbnail_No];
    }

@end




OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MutableMaskableCanvas, MaskableCanvas)

@implementation MutableMaskableCanvas

    + (MutableMaskableCanvas*) create :(MutableMaskableCanvasOwner*)owner
    {
        MutableMaskableCanvas* result = [[[MutableMaskableCanvas alloc] init] autorelease];
        
        result->my_owner = owner;
        
        result->my_selectedImageSetIndex = Int_nuble();
        
        result->my_transform = CGAffineTransformIdentity;                
        
        result->my_allImageSet = [[MutableMaskableImageSetMutableList create:10] retain];
        
        return result;
    }
    
    - (void) dealloc
    {
        [my_allImageSet release];
      
        [super dealloc];
    }
    
    
    - (CGAffineTransform) transform { return my_transform; }
    - (void) setTransform :(CGAffineTransform)transform {  my_transform = transform; }
        
    
    - (Int) count { return my_allImageSet.count; }
    - (NubleInt) firstIndex_ { return my_allImageSet.firstIndex_; }
    - (NubleInt) lastIndex_ { return my_allImageSet.lastIndex_; }
    
    
    - (MutableMaskableImageSet*) imageSetAt_ :(Int)index { return [my_allImageSet at:index]; }    
    - (MaskableImageSet*) imageSetAt:(Int)index { return [my_allImageSet at:index]; }

    - (Int) appendMaskableImageSet :(MutableMaskableImageSet*)maskableImageSet
    {        
        [my_allImageSet append:maskableImageSet];
        return my_allImageSet.lastIndex;
    }
    
    
    
    
    
    - (NubleMaskableImageSet) selectedImageSet
    {
        if (my_selectedImageSetIndex.hasVar)  
            return MaskableImageSet_toNuble([my_allImageSet at:my_selectedImageSetIndex.vd]);
        else 
            return MaskableImageSet_nuble();
    }    
      
    - (NubleInt) selectedImageSetIndex
    {
        return my_selectedImageSetIndex;
    }
    
    - (void) setSelectedImageSetIndex:(NubleInt)index
    {
        if (index.hasVar)
            ASSERT([my_allImageSet isValidIndex:index.vd]);
                
        my_selectedImageSetIndex = index;
        
        [my_owner MutableMaskableCanvas_selectedImageChanged:index];
    }
    
    
    
    - (void) up
    {
        if (my_selectedImageSetIndex.hasVar == NO || my_allImageSet.count == 0)
            return;
            
        if (my_selectedImageSetIndex.vd == my_allImageSet.lastIndex)
            return;
        
            
        MutableMaskableImageSet* oldImageSet = [my_allImageSet at:my_selectedImageSetIndex.vd];
        
        
        [my_allImageSet removeAt:my_selectedImageSetIndex.vd];
        
        my_selectedImageSetIndex = Int_toNuble(my_selectedImageSetIndex.vd + 1);

        [my_allImageSet insertAt:my_selectedImageSetIndex.vd :oldImageSet];
        
        [my_owner MutableMaskableCanvas_selectedImageChanged:my_selectedImageSetIndex];
    }
    - (void) down
    {
        if (my_selectedImageSetIndex.hasVar == NO || my_allImageSet.count == 0)
            return;
            
        if (my_selectedImageSetIndex.vd == my_allImageSet.firstIndex)
            return;
        
            
        MutableMaskableImageSet* oldImageSet = [my_allImageSet at:my_selectedImageSetIndex.vd];
        
        [my_allImageSet removeAt:my_selectedImageSetIndex.vd];
        
        my_selectedImageSetIndex = Int_toNuble(my_selectedImageSetIndex.vd - 1);

        [my_allImageSet insertAt:my_selectedImageSetIndex.vd :oldImageSet];
        
        [my_owner MutableMaskableCanvas_selectedImageChanged:my_selectedImageSetIndex];
    }
    
    - (void) deleteImage
    {
        if (my_selectedImageSetIndex.hasVar == NO || my_allImageSet.count == 0)
            return;
        
        [my_allImageSet removeAt:my_selectedImageSetIndex.vd];
        
        my_selectedImageSetIndex = Int_nuble();                
        
        [my_owner MutableMaskableCanvas_selectedImageChanged:my_selectedImageSetIndex];
    }
    
    
    
    
    + (NubleMutableMaskableCanvas) createFromFlow :(MutableMaskableCanvasOwner*)owner :(ReadingFlow*)flow
    {
        MutableMaskableCanvas* result = [MutableMaskableCanvas create:owner];
        
        NubleInt selectedImageIndex = Int_nuble();
        
        while (flow.hasMoreData)
        {
            String* key = [flow readLengthAndString];
            
            if ([key eq:DataKey_transform()])
                [result setTransform:[flow readCGAffineTransform]];
                        
            if ([key eq:DataKey_selectedImageIndex()])
                selectedImageIndex = [flow readNubleInt:Int_Max];
                
            if ([key eq:DataKey_imageSet()])
            {        
                NubleMutableMaskableImageSet imageSet =[MutableMaskableImageSet createFromFlow :flow];
                if (imageSet.hasVar == NO)
                    return MutableMaskableCanvas_nuble();
            
                [result appendMaskableImageSet:imageSet.vd];
            }
            
            if ([key eq:DataKey_end()])
                break;
        }        
        
        [result setSelectedImageSetIndex:selectedImageIndex];
        
        return MutableMaskableCanvas_toNuble(result);
    }
    
    - (void) writeToFlow:(WritingFlow*)flow
    {
        [flow writeLengthAndString:DataKey_transform()]; 
        [flow writeCGAffineTransform:self.transform];
        
        [flow writeLengthAndString:DataKey_selectedImageIndex()]; 
        [flow writeNubleInt :my_selectedImageSetIndex :Int_Max];
        
        FOR_EACH_INDEX(i, my_allImageSet)
        {
            MutableMaskableImageSet* imageSet = [my_allImageSet at:i];
            
            [flow writeLengthAndString:DataKey_imageSet()]; 
            [imageSet writeToFlow:flow];
        }        
        
        [flow writeLengthAndString:DataKey_end()];        
    }
    
    
    
    

    - (NubleInt) findMaskableImageIndex:(CGPoint)location
    {        
        FOR_EACH_INDEX_IN_REV(i, self)
        {
            MutableMaskableImageSet* imageSet = [my_allImageSet at:i];
            CGSize size = imageSet.originalImage.image.size;
        
            CGAffineTransform canvasTransform = CGAffineTransformInvert(self.transform);
            CGAffineTransform imageSetTransform = CGAffineTransformInvert([self imageSetAt:i].transform);
            CGAffineTransform transform = CGAffineTransformConcat(canvasTransform, imageSetTransform);
            
            CGPoint p = CGPointApplyAffineTransform(location, transform);            
            p = CGPoint_add(p, CGPointMake(size.width / 2.f, size.height / 2.f));
            
            if (p.x < 0.f || p.y < 0.f || p.x > size.width || p.y > size.height) 
                continue;
                
            if ([imageSet get9x9MaxMaskPixel:p] > 128)
                return Int_toNuble(i);            
        }

        return Int_nuble();
    }
        
    
            

    

@end
























