






#import "MaskableImage.h"





@implementation Layout

    + (Layout*) create :(id)view :(CGSize)size
    {
        Layout* result = [[[Layout alloc] init] autorelease];
        result->my_view = view;
        result->my_size = size;
        result->my_buttonSize = CGSizeMake(40.0, 40.0);
        result->my_margin = 8.0;
        return result;
    }
    
    - (UIButton*) createButton :(Int)row :(Int)column :(UIImage*)image :(SEL)selector
    {
        ASSERT(row != 0 && column != 0);
        
        
        UIViewAutoresizing autoresizing = UIViewAutoresizingNone;
        
        if (row > 0) autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
        else autoresizing |= UIViewAutoresizingFlexibleTopMargin;
            
        if (column > 0) autoresizing |= UIViewAutoresizingFlexibleRightMargin;
        else autoresizing |= UIViewAutoresizingFlexibleLeftMargin;


        Int r = row;
        Int c = column;
    
        CGFloat x = (c > 0) ? my_margin : my_size.width;                
        for ( ; c > 1; --c) x += (my_buttonSize.width + my_margin);
        for ( ; c < 0; c++) x -= (my_buttonSize.width + my_margin);
                
        CGFloat y = (r > 0) ? my_margin : my_size.height;
        for ( ; r > 1; --r) y += (my_buttonSize.height + my_margin);
        for ( ; r < 0; r++) y -= (my_buttonSize.height + my_margin);

        
        UIButton* result = [[[UIButton alloc] init] autorelease];
        result.autoresizingMask = autoresizing;
        result.frame = CGRectMake(x, y, my_buttonSize.width, my_buttonSize.height);
        
        [result setImage:image forState:UIControlStateNormal];
        [result addTarget:my_view action:selector forControlEvents:UIControlEventTouchUpInside];
                
        return result;
    }



@end






@implementation OriginalImage : ObjectBase
    
    + (OriginalImage*) createWithImage:(UIImage*)image
    {
        OriginalImage* result = [[[OriginalImage alloc] init] autorelease];
        result->my_image = [image retain];
        result->my_data = nil;
        return result;
    }
    
    + (OriginalImage*) createWithData:(NSData*)data
    {
        OriginalImage* result = [[[OriginalImage alloc] init] autorelease];
        result->my_image = nil;
        result->my_data = [data retain];
        return result;
    }
    
    - (void) dealloc
    {
        if (my_image != nil) [my_image release];
        if (my_data != nil) [my_data release];

        [super dealloc];
    }
    
    - (UIImage*) image
    {
        [self prepare];
        return my_image;
    }
    
    - (NSData*) data
    {
        [self prepare];
        return my_data;
    }
        
    - (void) prepare
    {
        if (my_image == nil)
            my_image = [[UIImage imageWithData:my_data] retain];
                
        if (my_data == nil)
            my_data = [UIImageJPEGRepresentation(my_image, 1.0f) retain];
    }
    
    
@end






OBJECT_LIST_IMPLEMENTATION_TEMPLATE(ImageMask, NSObject)

@implementation ImageMask 

    
    + (ImageMask*) create :(CGSize)size 
    {
        ImageMask* result = [[[ImageMask alloc] init] autorelease];
        
        result->my_width = (size_t)size.width;
        result->my_height = (size_t)size.height;

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        result->my_context = CGBitmapContextCreate(NULL, result->my_width, result->my_height, 8, 0, colorSpace, kCGImageAlphaNone);
        CGColorSpaceRelease(colorSpace);

        CGContextSetGrayFillColor(result->my_context, 1.0, 1.0);

        CGContextFillRect(result->my_context, CGRectMake(0, 0, result->my_width, result->my_height));
        
        CGContextSetLineCap(result->my_context, kCGLineCapRound); 
        
        return result;
    }
    
    - (void) dealloc 
    {
        CGContextRelease(my_context);
        
        [super dealloc];
    }
    
        
    - (CGSize) size 
    {
        return CGSizeMake(my_width, my_height);
    }
    
    - (UIImage*) makeUIImage
    {
        return CGContext_makeUIImage(my_context);
    }
    
    
    - (UInt8) get9x9MaxPixel :(CGPoint)point
    {
        size_t x = (size_t)point.x;
        size_t y = my_height - (size_t)point.y;
        
        UIImage* image = [self makeUIImage];

        size_t width = CGImageGetWidth(image.CGImage);
        size_t height = CGImageGetHeight(image.CGImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(image.CGImage);

        CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
        CFDataRef data = CGDataProviderCopyData(provider);
                
                                                
        UInt8 result = CFDataGetBytePtr(data)[(bytesPerRow * (y)) + (x)];
        if (y > 0) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y - 1)) + (x)]);
        if (y < height - 1) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y + 1)) + (x)]);            
        
        if (x > 0)
        {
            result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y)) + (x - 1)]);
            if (y > 0) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y - 1)) + (x - 1)]);
            if (y < height - 1) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y + 1)) + (x - 1)]);            
        }
        
        if (x < width - 1)
        {
            result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y)) + (x + 1)]);
            if (y > 0) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y - 1)) + (x + 1)]);
            if (y < height - 1) result = UInt8_max2(result, CFDataGetBytePtr(data)[(bytesPerRow * (y + 1)) + (x + 1)]);            
        }

                        
        CFRelease(data);        
        
        return result;
    }
    
    - (AggPixelResult) getAggPixel :(CGPoint)point :(CGFloat)penSize
    {
        UIImage* image = [self makeUIImage]; 
        CGFloat width = (CGFloat)CGImageGetWidth(image.CGImage);
        CGFloat height = (CGFloat)CGImageGetHeight(image.CGImage);
        CGFloat bytesPerRow = (CGFloat)CGImageGetBytesPerRow(image.CGImage);
        
        Int penRadius = (Int)(penSize / 2);
        if (penRadius <= 2)
            penRadius = 3;
        
        CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
        CFDataRef data = CGDataProviderCopyData(provider);
        
        UInt8 max = 0;
        UInt8 min = 255;
        Int total = 0;
        Int count = 0;
                        
        for (Int i = -penRadius; i <= penRadius; i += 1)
        {
            Int x = point.x + i;
                        
            for (Int j = -penRadius; j <= penRadius; j += 1)
            {
                Int y = height - point.y + j;
                
                if (i*i + j*j <= penRadius * penRadius)
                {
                    UInt8 pixel = 0;
                    
                    if (0 <= x && x <= width - 1 && 0 <= y && y <= height - 1)
                        pixel = CFDataGetBytePtr(data)[(size_t)((bytesPerRow * y) + x)];
                    
                    max = UInt8_max2(pixel, max);
                    min = UInt8_min2(pixel, min);
                    total += pixel;
                    count += 1;
                }
            }
        }
        
        CFRelease(data);
        
        AggPixelResult result;
        result.max = max;
        result.min = min;
        result.avg = (UInt8)((Double)total / (Double)count);
        return result;        
    }
    
    
    
    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize
    {                        
        CGBlendMode mode = (my_tool == ImageMaskTool_Eraser) ? kCGBlendModeDarken : kCGBlendModeLighten;
        CGFloat gray = (my_tool == ImageMaskTool_Eraser) ? 0 : 1;
                    
        CGContextSetBlendMode(my_context, mode);
    
        CGContextSetGrayStrokeColor(my_context, (gray + 1) / 2, 1);
        CGContextSetLineWidth(my_context, penSize + 1);	
        CGContextMoveToPoint(my_context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(my_context, toPoint.x, toPoint.y);
        CGContextStrokePath(my_context);      

        CGContextSetGrayStrokeColor(my_context, gray, 1);
        CGContextSetLineWidth(my_context, penSize);	
        CGContextMoveToPoint(my_context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(my_context, toPoint.x, toPoint.y);
        CGContextStrokePath(my_context);      
    }

    - (void) replace :(UIImage*)image
    {
        CGContextSetBlendMode(my_context, kCGBlendModeNormal);
        
        CGRect rect = CGRectMake(0.0, 0.0, my_width, my_height);
    
        CGContextDrawImage(my_context, rect, image.CGImage);                
    }
    
    
    
    - (void) setImageMaskTool:(ImageMaskTool)tool
    {
    
        my_tool = tool;
        
        UIImage* image = [self makeUIImage]; 
        size_t width = CGImageGetWidth(image.CGImage);
        size_t height = CGImageGetHeight(image.CGImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
                
        CGDataProviderRef oldProvider = CGImageGetDataProvider(image.CGImage);
        CFDataRef oldCFData = CGDataProviderCopyData(oldProvider);
        
        NSMutableData* mutableData = [NSMutableData dataWithData:(NSData*)oldCFData];
        UInt8* mutableBytes = [mutableData mutableBytes];
        
        for (size_t x = 0; x < width; x += 1)
        {
            for (size_t y = 0; y < height; y += 1)
            {
                if (mutableBytes[(bytesPerRow * y) + x] <= 64)
                {
                    UInt8 p = (tool == ImageMaskTool_Eraser) ? 0 : 64;
                    mutableBytes[(bytesPerRow * y) + x] = p;
                }
            }
        }
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData((CFDataRef)mutableData);
        
        
        CGImageRef newImage = CGImageCreate(
            width, 
            height, 
            CGImageGetBitsPerComponent(image.CGImage),
            CGImageGetBitsPerPixel(image.CGImage),
            bytesPerRow,
            CGImageGetColorSpace(image.CGImage),
            CGImageGetBitmapInfo(image.CGImage),
            newProvider,
            CGImageGetDecode(image.CGImage),
            CGImageGetShouldInterpolate(image.CGImage),
            CGImageGetRenderingIntent(image.CGImage));
            
        CGContextSetBlendMode(my_context, kCGBlendModeNormal);
        CGContextDrawImage(my_context, CGRectMake(0, 0, width, height), newImage);
        
        CGDataProviderRelease(newProvider);
        CGImageRelease(newImage);
        CFRelease(oldCFData);
    }
        
    
    
@end






OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MaskableImage, NSObject)

@implementation MaskableImage 

    - (void) dealloc
    {
        UIImage_release(my_cacheImage);
        
        [super dealloc];
    }

    - (UIImage*) originalImage { ABSTRACT_METHOD_NIL }
    
    - (UIImage*) workingImage { ABSTRACT_METHOD_NIL }
    - (ImageMask*) makeMaskImage { ABSTRACT_METHOD_NIL }


    
    - (UIImage*) generateImage :(Bool)selected
    {    
        if (my_cacheImageIsSelected != Unknown && my_cacheImage.hasVar)
            if ((my_cacheImageIsSelected == Yes) == selected)
                return my_cacheImage.vd;        
    
    
        UIImage* workingImage = self.workingImage;
                
        CGSize size = workingImage.size;
        CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
        
        CGImageRef unmaskedImage = workingImage.CGImage;
        
        
        if (selected)
        {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
            CGColorSpaceRelease(colorSpace);

            CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextFillRect(context, rect);
            
            CGContextSetBlendMode(context, kCGBlendModeScreen);
                    
            CGContextDrawImage(context, rect, unmaskedImage);
            
            unmaskedImage = CGBitmapContextCreateImage(context);
            
            CGContextRelease(context);
        }
                        
        UIImage* maskImage = [self makeMaskImage];
            
        CGImageRef imageWithMask = CGImageCreateWithMask(unmaskedImage, maskImage.CGImage);
        
        UIImage* result = [UIImage imageWithCGImage:imageWithMask];
        
        CGImageRelease(imageWithMask);
        
        if (selected)
        {
            CGImageRelease(unmaskedImage);
        }
        
        
        my_cacheImageIsSelected = (selected) ? Yes : No;
        
        UIImage_autorelease(my_cacheImage);
        my_cacheImage = UIImage_toNuble([result retain]);
        
        return result;
    }
    

    - (void) removeCache
    {
        my_cacheImageIsSelected = Unknown;
        
        UIImage_autorelease(my_cacheImage);
        my_cacheImage = UIImage_nuble();
    }

@end




OBJECT_LIST_IMPLEMENTATION_TEMPLATE(StableMaskableImage, MaskableImage)

@implementation StableMaskableImage

    + (StableMaskableImage*) create :(OriginalImage*)originalImage :(UIImage*)mask
    {
        StableMaskableImage* result = [[[StableMaskableImage alloc] init] autorelease];
        [result _create :originalImage :mask];        
        return result;
    }
    
    - (void) _create :(OriginalImage*)originalImage :(UIImage*)mask
    {
        [self removeCache];
        
        my_originalImage = [originalImage retain];
        my_mask = [mask retain];
    }
    
    - (void) dealloc 
    {
        [my_originalImage release];
        [my_mask release];
        [super dealloc];
    }
    
    - (OriginalImage*) originalImage { return my_originalImage; }
    
    - (UIImage*) workingImage { return my_originalImage.image; }
    
    - (UIImage*) makeMaskImage { return my_mask; }
    
    
@end





OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MutableMaskableImage, MaskableImage)

@implementation MutableMaskableImage 

    + (MutableMaskableImage*) create :(OriginalImage*)originalImage :(CGSize)size;
    {
        MutableMaskableImage* result = [[[MutableMaskableImage alloc] init] autorelease];        
        [result _create :originalImage :size];
        return result;
    }
        
    - (void) _create :(OriginalImage*)originalImage :(CGSize)size;
    {
        [self removeCache];
        
        my_originalImage = [originalImage retain];
        
        my_workingImage = [UIImage_scaleSize(my_originalImage.image, size) retain];
        
        my_mask = [[ImageMask create :size] retain];
        
        my_allUndoLog = [[UIImageMutableList create] retain];
        my_allRedoLog = [[UIImageMutableList create] retain];
    }
    
    - (void) dealloc
    {
        [my_originalImage release];
        
        [my_workingImage release];
        
        [my_mask release];
        
        [my_allUndoLog release];
        [my_allRedoLog release];
        
        [super dealloc];
    }
    
    
    - (OriginalImage*) originalImage { return my_originalImage; }
    
    - (UIImage*) workingImage { return my_workingImage; }
    
    - (UIImage*) makeMaskImage { return [my_mask makeUIImage]; }
    
    
    - (UInt8) get9x9MaxMaskPixel :(CGPoint)point
    {
        return [my_mask get9x9MaxPixel:point];
    }        
    
    - (AggPixelResult) getAggMaskPixel :(CGPoint)point :(CGFloat)penSize
    {
        return [my_mask getAggPixel :point :penSize];
    }
    	            

    
    - (void) startSession
    {        
        while (my_allUndoLog.count > 20)
            [my_allUndoLog removeFirst];
            
        [my_allRedoLog removeAll];
        
        UIImage* maskImage = [my_mask makeUIImage];
        [my_allUndoLog append:maskImage];
           
        my_insideSession = YES;
    }
    
    
    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize
    {
        if (my_insideSession == NO)
            [self startSession];
        
        [my_mask edit :fromPoint :toPoint :penSize];   
        
        [self removeCache];
    }
    
    - (void) setImageMaskTool :(ImageMaskTool)tool
    {
        [my_mask setImageMaskTool:tool];
        
        [self removeCache];
    }
    
    
    - (void) endSession
    {
        my_insideSession = NO;
    }
    
    - (void) undo
    {
        if (my_allUndoLog.count == 0)
            return;
            
        UIImage* maskImage = [my_mask makeUIImage];
        [my_allRedoLog insert:maskImage];            
 
        [my_mask replace:my_allUndoLog.last];
        [my_allUndoLog removeLast];
        
        my_insideSession = NO;
        
        [self removeCache];
    }
    
    - (void) redo
    {
        if (my_allRedoLog.count == 0)
            return;    

        UIImage* maskImage = [my_mask makeUIImage];
        [my_allUndoLog append:maskImage];            
            
        [my_mask replace:my_allRedoLog.first];
        [my_allRedoLog removeFirst];
        
        my_insideSession = NO;
        
        [self removeCache];
    }
    

    - (void) replaceMaskImage :(UIImage*)image
    {
        [my_mask replace:image];
    }
            
    

@end








OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MaskableImageSet, NSObject)

@implementation MaskableImageSet 
    
    - (CGAffineTransform) transform { return my_transform; }
    
    
    - (OriginalImage*) originalImage { ABSTRACT_METHOD_NIL }
    
    - (UIImage*) generateImage :(ImageQuality)quality :(Bool)selected { ABSTRACT_METHOD_NIL }

    - (UIImage*) originalImage :(ImageQuality)quality { ABSTRACT_METHOD_NIL }
    
    - (UIImage*) createMaskImage :(ImageQuality)quality { ABSTRACT_METHOD_NIL }
          
@end


OBJECT_LIST_IMPLEMENTATION_TEMPLATE(StableMaskableImageSet, MaskableImageSet)

@implementation StableMaskableImageSet

    + (StableMaskableImageSet*) create :(MaskableImageSet*)imageSet
    {
        OriginalImage* originalImage = imageSet.originalImage;
        UIImage* maskImage = [imageSet createMaskImage:ImageQuality_High];
            
        StableMaskableImageSet* result = [[[StableMaskableImageSet alloc] init] autorelease];        
        result->my_transform = imageSet.transform;
        result->my_image = [[StableMaskableImage create :originalImage :maskImage] retain];
        return result;
    }
    
    - (void) dealloc
    {
        [my_image release];
        [super dealloc];
    }

    
    - (OriginalImage*) originalImage 
    { 
        return my_image.originalImage; 
    }
    
    - (UIImage*) generateImage :(ImageQuality)quality :(Bool)selected 
    {
        return [my_image generateImage:selected];
    }
    
    - (UIImage*) createMaskImage :(ImageQuality)quality
    {
        return [my_image makeMaskImage];
    }
        
@end



        

OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MutableMaskableImageSet, MaskableImageSet)

@implementation MutableMaskableImageSet
    
    + (MutableMaskableImageSet*) create :(OriginalImage*)originalImage
    {
        MutableMaskableImageSet* result = [[[MutableMaskableImageSet alloc] init] autorelease];
        [result _create:originalImage];
        return result;
    }
    
    - (void) _create:(OriginalImage*)originalImage
    {        
        my_transform = CGAffineTransformIdentity;
        
        CGSize midQualitySize = CGSize_changeMax(originalImage.image.size, 512.0);
        my_midQuality = [[MutableMaskableImage create :originalImage :midQualitySize] retain];        
    
        CGSize lowQualitySize = CGSize_changeMax(originalImage.image.size, 64.0);
        my_lowQuality = [[MutableMaskableImage create :originalImage :lowQualitySize] retain];
    }
    
    
    - (void) dealloc
    {
        [my_midQuality release];
        [my_lowQuality release];
        [super dealloc];
    }


    - (OriginalImage*) originalImage
    {
        return my_lowQuality.originalImage;
    }
    
    - (UIImage*) generateImage :(ImageQuality)quality :(Bool)selected 
    {
        if (quality == ImageQuality_High) return [my_midQuality generateImage:selected];
        if (quality == ImageQuality_Mid) return [my_midQuality generateImage:selected];
        if (quality == ImageQuality_Low) return [my_lowQuality generateImage:selected];
        ASSERT(NO); return nil;
    }
    

    
    - (UIImage*) createMaskImage :(ImageQuality)quality
    {
        if (quality == ImageQuality_High) return [my_midQuality makeMaskImage];
        if (quality == ImageQuality_Mid) return [my_midQuality makeMaskImage];
        if (quality == ImageQuality_Low) return [my_lowQuality makeMaskImage];
        ASSERT(NO); return nil;
    }
    
    
    
    - (UInt8) get9x9MaxMaskPixel :(CGPoint)point
    {
        CGSize o = self.originalImage.image.size;   
        CGSize m = my_midQuality.workingImage.size;
        CGFloat x = m.width / o.width;
        CGFloat y = m.height / o.height;        
        return [my_midQuality get9x9MaxMaskPixel :CGPoint_scale2(point, x, y)];            
    }
    
    - (AggPixelResult) getAggMaskPixel :(CGPoint)point :(CGFloat)penSize
    {
        CGSize o = self.originalImage.image.size;   
        CGSize m = my_midQuality.workingImage.size;
        CGFloat x = m.width / o.width;
        CGFloat y = m.height / o.height;       
        
        CGFloat p = penSize * ((x + y) / 2);
          
        return [my_midQuality getAggMaskPixel :CGPoint_scale2(point, x, y) :p];            
    }
    
    	            
    
    - (void) startSession
    {
        [my_midQuality startSession];
        [my_lowQuality startSession];
    }


    - (void) edit :(CGPoint)fromPoint :(CGPoint)toPoint :(CGFloat)penSize;
    {
        CGSize o = self.originalImage.image.size;        
                
        {            
            CGSize m = my_midQuality.workingImage.size;
            CGFloat x = m.width / o.width;
            CGFloat y = m.height / o.height;
            CGPoint f = CGPoint_scale2(fromPoint, x, y);            
            CGPoint t = CGPoint_scale2(toPoint, x, y);            
            [my_midQuality edit :f :t :penSize * ((x + y) / 2.0)];
        }        
        {        
            CGSize l = my_lowQuality.workingImage.size;
            CGFloat x = l.width / o.width;
            CGFloat y = l.height / o.height;
            CGPoint f = CGPoint_scale2(fromPoint, x, y);            
            CGPoint t = CGPoint_scale2(toPoint, x, y);            
            [my_lowQuality edit :f :t :penSize * ((x + y) / 2.0)];
        }                
    }
    
    - (void) setImageMaskTool :(ImageMaskTool)tool
    {
        [my_midQuality setImageMaskTool:tool];
        [my_lowQuality setImageMaskTool:tool];
    }
        
    - (void) endSession
    {
        [my_midQuality endSession];
        [my_lowQuality endSession];
    }
        
    
    - (void) undo
    {
        [my_midQuality undo];
        [my_lowQuality undo];
    }
    
    - (void) redo
    {
        [my_midQuality redo];
        [my_lowQuality redo];
    }
    
    
    
    
    
    
    + (NubleMutableMaskableImageSet) createFromFlow :(ReadingFlow*)flow
    {
        CGAffineTransform transform = CGAffineTransformIdentity;
        OriginalImage* originalImage = nil;
        UIImage* midQualityMask = nil;
        UIImage* lowQualityMask = nil;
        
        while (flow.hasMoreData)
        {
            String* key = [flow readLengthAndString];
            
            if ([key eq:DataKey_transform()])
                transform = [flow readCGAffineTransform];
            
            if ([key eq:DataKey_originalImage()])
                originalImage = [OriginalImage createWithData:[flow readLengthAndData]];
            
            if ([key eq:DataKey_midQualityMask()])
                midQualityMask = [UIImage imageWithData:[flow readLengthAndData]];
        
            if ([key eq:DataKey_lowQualityMask()])
                lowQualityMask = [UIImage imageWithData:[flow readLengthAndData]];

            if ([key eq:DataKey_end()])
                break;
        }
        
        if (originalImage == nil || midQualityMask == nil || lowQualityMask == nil)
            return MutableMaskableImageSet_nuble();
            
        MutableMaskableImageSet* result = [MutableMaskableImageSet create:originalImage];
        [result setTransform:transform];
        [result->my_midQuality replaceMaskImage:midQualityMask];
        [result->my_lowQuality replaceMaskImage:lowQualityMask];
        
        return MutableMaskableImageSet_toNuble(result);                
    }
    
    
    - (void) writeToFlow:(WritingFlow*)flow
    {        
        [flow writeLengthAndString:DataKey_transform()];
        [flow writeCGAffineTransform:self.transform];
        
        [flow writeLengthAndString:DataKey_originalImage()];
        [flow writeLengthAndData:my_midQuality.originalImage.data];

        [flow writeLengthAndString:DataKey_midQualityMask()];
        [flow writeLengthAndData:UIImagePNGRepresentation([my_midQuality makeMaskImage])];

        [flow writeLengthAndString:DataKey_lowQualityMask()];
        [flow writeLengthAndData:UIImagePNGRepresentation([my_lowQuality makeMaskImage])];

        [flow writeLengthAndString:DataKey_end()];        
    }
    
    

    - (void) setTransform:(CGAffineTransform)transform
    {
        my_transform = transform;
    }
        

@end
















UIImage* createBackgroundImage(CGSize size)
{
    CGFloat gridSize = 16.0;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
            
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    
    CGContextSetGrayFillColor(context, 0.75, 1.0);
    
    Bool isFillingFirst = YES;
    for (CGFloat x = 0.0; x < size.width; x += gridSize)
    {
        Bool isFilling = isFillingFirst;
        for (CGFloat y = 0.0; y < size.height; y += gridSize)
        {
            isFilling = !isFilling;
            if (isFilling)
                CGContextFillRect(context, CGRectMake(x, y, gridSize, gridSize));
        }
        
        isFillingFirst = !isFillingFirst;
    }
        
    UIImage* result = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    
    return result;
}



