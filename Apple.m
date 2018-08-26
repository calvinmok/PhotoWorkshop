


#import "Apple.h"












STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGFloat)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGAffineTransform)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGPoint)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGSize)
STRUCT_LIST_IMPLEMENTATION_TEMPLATE(CGRect)

OBJECT_LIST_IMPLEMENTATION_TEMPLATE(UIImage, NSObject)




BOOL CGPoint_isInside(CGPoint me, CGRect rect)
{
    CGPoint lt = CGRect_leftTop(rect);
    CGPoint rb = CGRect_rightBottom(rect);
	return (me.x >= lt.x && me.y >= lt.y && rb.x >= me.x && rb.y >= me.y);
}




    
NubleCGFloat CGSize_ratio_(CGSize size) 
{ 
    SELFTEST_START
    
        ASSERT(CGSize_ratio_(CGSizeMake(6.0, 3.0)).vd == 2.0);
        ASSERT(CGSize_ratio_(CGSizeMake(3.0, 6.0)).vd == 0.5);
            
    SELFTEST_END
    
    
    if (CGFloat_aEqualZero(size.height))
        return (CGFloat_aEqualZero(size.width)) ? CGFloat_nuble() : CGFloat_toNuble(CGFloat_zero());
    
    if (CGFloat_aEqualZero(size.width))
        return CGFloat_toNuble(CGFloat_max());

    return CGFloat_toNuble(size.width / size.height);
}



CGSize CGSize_expandRatio(CGSize size, CGFloat ratio)
{
    SELFTEST_START
        CGSize_shrinkRatio(CGSizeZero, 1.0);
    
        CGSize_assert(CGSize_expandRatio(CGSizeMake(6.0, 3.0), 1.0), 6.0, 6.0);
        CGSize_assert(CGSize_expandRatio(CGSizeMake(3.0, 6.0), 1.0), 6.0, 6.0);
            
        CGSize_assert(CGSize_expandRatio(CGSizeMake(6.0, 3.0), 0.5), 6.0, 12.0);
        CGSize_assert(CGSize_expandRatio(CGSizeMake(3.0, 6.0), 2.0), 12.0, 6.0);

    SELFTEST_END

    if (CGSize_isAnyZero(size) || CGFloat_aEqualZero(ratio) || ratio == CGFloat_max()) 
        return CGSizeZero;
        
        
    CGSize s1 = CGSizeMake(size.width, size.width / ratio);
    CGSize s2 = CGSizeMake(size.height * ratio, size.height);    
    return (CGSize_area(s1) > CGSize_area(s2)) ? s1 : s2;
}  


CGSize CGSize_shrinkRatio(CGSize size, CGFloat ratio)
{
    SELFTEST_START
        CGSize_expandRatio(CGSizeZero, 1.0);
    
        CGSize_assert(CGSize_shrinkRatio(CGSizeMake(6.0, 3.0), 1.0), 3.0, 3.0);
        CGSize_assert(CGSize_shrinkRatio(CGSizeMake(3.0, 6.0), 1.0), 3.0, 3.0);
            
        CGSize_assert(CGSize_shrinkRatio(CGSizeMake(6.0, 3.0), 0.5), 1.5, 3.0);
        CGSize_assert(CGSize_shrinkRatio(CGSizeMake(3.0, 6.0), 2.0), 3.0, 1.5);

    SELFTEST_END
    
    
    if (CGSize_isAnyZero(size) || CGFloat_aEqualZero(ratio) || ratio == CGFloat_max()) 
        return CGSizeZero;
    
    CGSize s1 = CGSizeMake(size.width, size.width / ratio);
    CGSize s2 = CGSizeMake(size.height * ratio, size.height);    
    return (CGSize_area(s1) < CGSize_area(s2)) ? s1 : s2;
}  


CGSize CGSize_changeWidth(CGSize size, CGFloat width)
{
    SELFTEST_START
    
        CGSize_assert(CGSize_changeWidth(CGSizeMake(6.0, 3.0), 12.0), 12.0, 6.0);
        CGSize_assert(CGSize_changeWidth(CGSizeMake(3.0, 6.0), 12.0), 12.0, 24.0);

        CGSize_assert(CGSize_changeWidth(CGSizeMake(12.0, 24.0), 6.0), 6.0, 12.0);
        CGSize_assert(CGSize_changeWidth(CGSizeMake(24.0, 12.0), 6.0), 6.0, 3.0);
        
    SELFTEST_END
    
    
    if (CGSize_isAnyZero(size) || CGFloat_aEqualZero(width)) 
        return CGSizeZero;
        
    return CGSizeMake(width, width / (size.width / size.height));
}


CGSize CGSize_changeHeight(CGSize size, CGFloat height)
{
    SELFTEST_START
    
        CGSize_assert(CGSize_changeHeight(CGSizeMake(6.0, 3.0), 12.0), 12.0, 24.0);
        CGSize_assert(CGSize_changeHeight(CGSizeMake(3.0, 6.0), 12.0), 12.0, 6.0);

        CGSize_assert(CGSize_changeHeight(CGSizeMake(12.0, 24.0), 6.0), 3.0, 6.0);
        CGSize_assert(CGSize_changeHeight(CGSizeMake(24.0, 12.0), 6.0), 12.0, 6.0);

    SELFTEST_END
    
    
    if (CGSize_isAnyZero(size) || CGFloat_aEqualZero(height)) 
        return CGSizeZero;

    return CGSizeMake(height / (size.height / size.width), height);
}

CGSize CGSize_changeMax(CGSize size, CGFloat max)
{
    if (size.width <= max && size.height <= max)
        return size;
                
    NubleCGFloat ratio = CGSize_ratio_(size);
    
    if (ratio.hasVar == NO)
        return size;
    
    if (size.width > size.height)
        return CGSizeMake(max, max / ratio.vd);
    else
        return CGSizeMake(ratio.vd * max, max);
}





CGPoint CGRect_midPoint(CGRect rect)
{
    CGFloat x = rect.origin.x + (rect.size.width / 2);
    CGFloat y = rect.origin.y + (rect.size.height / 2);    
    return CGPointMake(x, y);
}

CGRect CGRect_expandRatio(CGRect rect, CGFloat ratio)
{
    CGPoint point = CGRect_midPoint(rect);
    CGSize size = CGSize_expandRatio(rect.size, ratio);
    return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);    
}

CGRect CGRect_shrinkRatio(CGRect rect, CGFloat ratio)
{
    CGPoint point = CGRect_midPoint(rect);
    CGSize size = CGSize_shrinkRatio(rect.size, ratio);
    return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);    
}

CGRect CGRect_changeWidth(CGRect rect, CGFloat width)
{
    CGPoint point = CGRect_midPoint(rect);
    CGSize size = CGSize_changeWidth(rect.size, width);
    return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);    
}

CGRect CGRect_changeHeight(CGRect rect, CGFloat height)
{
    CGPoint point = CGRect_midPoint(rect);
    CGSize size = CGSize_changeHeight(rect.size, height);
    return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);    
}

CGRect CGRect_changeMax(CGRect rect, CGFloat max)
{
    CGPoint point = CGRect_midPoint(rect);
    CGSize size = CGSize_changeMax(rect.size, max);
    return CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);    
}








void CGPoint_assert(CGPoint point, CGFloat x, CGFloat y)     
{ 
    ASSERT(CGFloat_aEqual(point.x, x));
    ASSERT(CGFloat_aEqual(point.y, y)); 
}

void CGSize_assert(CGSize size, CGFloat width, CGFloat height) 
{ 
    ASSERT(CGFloat_aEqual(size.width, width)); 
    ASSERT(CGFloat_aEqual(size.height, height)); 
}
    
void CGRect_assert(CGRect rect, CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{ 
    CGPoint_assert(rect.origin, x, y); 
    CGSize_assert(rect.size, width, height); 
}













String* CGAffineTransform_print(CGAffineTransform value)
{
    MutableString* result = [MutableString create:20];
    
    [result append:STR(@"a:")];
    [result append:Double_printFloating(value.a, 4)];
    [result append:STR(@" ")];
    
    [result append:STR(@"b:")];
    [result append:Double_printFloating(value.b, 4)];
    [result append:STR(@" ")];

    [result append:STR(@"c:")];
    [result append:Double_printFloating(value.c, 4)];
    [result append:STR(@" ")];

    [result append:STR(@"d:")];
    [result append:Double_printFloating(value.d, 4)];
    [result append:STR(@" ")];

    [result append:STR(@"x:")];
    [result append:Double_printFloating(value.tx, 4)];
    [result append:STR(@" ")];

    [result append:STR(@"y:")];
    [result append:Double_printFloating(value.ty, 4)];

    return [result seal];
}

Int CGAffineTransform_dataLength(void)
{
    return 8 * 6;
}

void CGAffineTransform_appendToData(CGAffineTransform me, NSMutableData* data)
{
    Byte8_appendToData(Byte8_fromDouble(me.a), data);
    Byte8_appendToData(Byte8_fromDouble(me.b), data);
    Byte8_appendToData(Byte8_fromDouble(me.c), data);
    Byte8_appendToData(Byte8_fromDouble(me.d), data);
    Byte8_appendToData(Byte8_fromDouble(me.tx), data);
    Byte8_appendToData(Byte8_fromDouble(me.ty), data);
}

CGAffineTransform CGAffineTransform_fromData(NSData* data, Int offset)
{
    CGAffineTransform result;    
    result.a = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 0)));
    result.b = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 1)));
    result.c = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 2)));
    result.d = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 3)));
    result.tx = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 4)));
    result.ty = Byte8_toDouble(Byte8_fromData(data, offset + (8 * 5)));
    return result;
}








UIImage* UIImage_scaleSize(UIImage* original, CGSize size)
{    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), original.CGImage);
    
    CGImageRef cgResult = CGBitmapContextCreateImage(context);    
    UIImage* result = [UIImage imageWithCGImage:cgResult];
    
    CGImageRelease(cgResult);
    CGContextRelease(context);

    return result;
}



void UIImage_nsLog(UIImage* image)
{

    Int bytesPerRow = toInt(CGImageGetBytesPerRow(image.CGImage));

    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    CFDataRef data = CGDataProviderCopyData(provider);
    
    
    MutableString* result = [MutableString create:1000];
    for (Int y = 0; y < image.size.height; y++)
    {
        for (Int x = 0; x < image.size.width; x++)
        {
            UInt8 pixel = CFDataGetBytePtr(data)[(bytesPerRow * (y + 0)) + (x + 0)];
            [result appendChar: (pixel > 128) ? CHAR(1) : CHAR(0)];
        }
        
        [result appendChar: CHAR_N];
    }
    
    NSLog(@"%@", result.ns);
                    
    CFRelease(data);        
    
}





UIImage* CGContext_makeUIImage(CGContextRef context)
{
    CGImageRef image = CGBitmapContextCreateImage(context);
        
    UIImage* result = [UIImage imageWithCGImage:image];
    
    CGImageRelease(image);    
    
    return result;
}


void CGContext_DrawUIImage(CGContextRef context, CGFloat x, CGFloat y, UIImage* image)
{
    CGSize size = image.size;
    CGRect rect = CGRectMake(x, y, size.width, size.height);
    
    CGContextDrawImage(context, rect, image.CGImage);
}









