










#import "MathData.h"







OBJECT_NUBLE_TEMPLATE(NSData) 
STRUCT_NUBLE_TEMPLATE(CGFloat) 

STRUCT_NUBLE_TEMPLATE(CGAffineTransform) 
STRUCT_NUBLE_TEMPLATE(CGPoint) 
STRUCT_NUBLE_TEMPLATE(CGSize) 
STRUCT_NUBLE_TEMPLATE(CGRect) 
OBJECT_NUBLE_TEMPLATE(UIImage) 







STRUCT_LIST_INTERFACE_TEMPLATE(CGFloat)
STRUCT_LIST_INTERFACE_TEMPLATE(CGAffineTransform)
STRUCT_LIST_INTERFACE_TEMPLATE(CGPoint)
STRUCT_LIST_INTERFACE_TEMPLATE(CGSize)
STRUCT_LIST_INTERFACE_TEMPLATE(CGRect)
OBJECT_LIST_INTERFACE_TEMPLATE(UIImage, NSObject)




NS_INLINE UInt8 UInt8_max2(UInt8 x, UInt8 y) { return (x > y) ? x : y; }
NS_INLINE UInt8 UInt8_min2(UInt8 x, UInt8 y) { return (x < y) ? x : y; }





NS_INLINE CGFloat CGFloat_zero(void) { return (CGFLOAT_IS_DOUBLE) ? (CGFloat)0.0 : (CGFloat)0.f; }
NS_INLINE CGFloat CGFloat_min(void) { return (CGFLOAT_IS_DOUBLE) ? (CGFloat)Double_Min : (CGFloat)Single_Min; }
NS_INLINE CGFloat CGFloat_max(void) { return (CGFLOAT_IS_DOUBLE) ? (CGFloat)Double_Max : (CGFloat)Double_Max; }


NS_INLINE Bool CGFloat_aEqual(CGFloat x, CGFloat y) 
    { return (CGFLOAT_IS_DOUBLE) ? Double_aEqual((Double)x, (Double)y) : Single_aEqual((Single)x, (Single)y); }
    
NS_INLINE Bool CGFloat_aEqualZero(CGFloat v) { return CGFloat_aEqual(v, CGFloat_zero()); }


NS_INLINE CGFloat CGFloat_max2(CGFloat x, CGFloat y) { return (x > y) ? x : y; }
NS_INLINE CGFloat CGFloat_min2(CGFloat x, CGFloat y) { return (x < y) ? x : y; }

NS_INLINE CGFloat CGFloat_abs(CGFloat x) { return (x < CGFloat_zero()) ? -x : x; }




NS_INLINE CGPoint CGPoint_add(CGPoint point, CGPoint other) { return CGPointMake(point.x + other.x, point.y + other.y); }

NS_INLINE CGPoint CGPoint_scale(CGPoint point, CGFloat scale) { return CGPointMake(point.x * scale, point.y * scale); }

NS_INLINE CGPoint CGPoint_scale2(CGPoint point, CGFloat xScale, CGFloat yScale) { return CGPointMake(point.x * xScale, point.y * yScale); }

BOOL CGPoint_isInside(CGPoint me, CGRect rect);


NS_INLINE CGRect CGPoint_toRect(CGPoint point, CGFloat w, CGFloat h) { return CGRectMake(point.x, point.y, w, h); }

NS_INLINE CGRect CGPoint_expandToRect(CGPoint point, CGFloat w, CGFloat h) { return CGRectMake(point.x - (w/2), point.y - (h/2), w, h); }




NS_INLINE Bool CGSize_isAnyZero(CGSize size) { return (CGFloat_aEqualZero(size.width) || CGFloat_aEqualZero(size.height)); }  
NS_INLINE CGFloat CGSize_area(CGSize size) { return size.width * size.height; }
  

NS_INLINE CGSize CGSize_abs(CGSize size) { return CGSizeMake(CGFloat_abs(size.width), CGFloat_abs(size.height)); }
    
NubleCGFloat CGSize_ratio_(CGSize size);

CGSize CGSize_expandRatio(CGSize size, CGFloat ratio);
CGSize CGSize_shrinkRatio(CGSize size, CGFloat ratio);

CGSize CGSize_changeWidth(CGSize size, CGFloat width);
CGSize CGSize_changeHeight(CGSize size, CGFloat height);

CGSize CGSize_changeMax(CGSize size, CGFloat max);

NS_INLINE CGRect CGSize_toRect(CGSize size, CGFloat x, CGFloat y) { return CGRectMake(x, y, size.width, size.height); }




CGPoint CGRect_midPoint(CGRect rect);

CGRect CGRect_expandRatio(CGRect rect, CGFloat ratio);
CGRect CGRect_shrinkRatio(CGRect rect, CGFloat ratio);

CGRect CGRect_changeWidth(CGRect rect, CGFloat width);
CGRect CGRect_changeHeight(CGRect rect, CGFloat height);

CGRect CGRect_changeMax(CGRect rect, CGFloat max);

NS_INLINE CGRect CGRect_moveLeftTo(CGRect me, CGFloat left) { me.origin.x = left; return me; }
NS_INLINE CGRect CGRect_moveRightTo(CGRect me, CGFloat right) { me.origin.x = right - me.size.width; return me; }
NS_INLINE CGRect CGRect_moveTopTo(CGRect me, CGFloat top) { me.origin.y = top; return me; }
NS_INLINE CGRect CGRect_moveBottomTo(CGRect me, CGFloat bottom) { me.origin.y = bottom - me.size.height; return me; }


NS_INLINE CGPoint CGRect_leftTop(CGRect me)     { return (me.origin); }
NS_INLINE CGPoint CGRect_leftBottom(CGRect me)  { return CGPointMake(me.origin.x,                 me.origin.y + me.size.height); }    
NS_INLINE CGPoint CGRect_rightTop(CGRect me)    { return CGPointMake(me.origin.x + me.size.width, me.origin.y); }
NS_INLINE CGPoint CGRect_rightBottom(CGRect me) { return CGPointMake(me.origin.x + me.size.width, me.origin.y + me.size.height); }
	








void CGPoint_assert(CGPoint point, CGFloat x, CGFloat y);
void CGSize_assert(CGSize size, CGFloat width, CGFloat height);
void CGRect_assert(CGRect rect, CGFloat x, CGFloat y, CGFloat width, CGFloat height);











String* CGAffineTransform_print(CGAffineTransform value);

Int CGAffineTransform_dataLength(void);
void CGAffineTransform_appendToData(CGAffineTransform me, NSMutableData* data);
CGAffineTransform CGAffineTransform_fromData(NSData* data, Int offset);






UIImage* UIImage_scaleSize(UIImage* original, CGSize size);

void UIImage_nsLog(UIImage* image);


UIImage* CGContext_makeUIImage(CGContextRef context);

void CGContext_DrawUIImage(CGContextRef context, CGFloat x, CGFloat y, UIImage* image);

void CGImage_getPixel(CGImageRef image);







/*


@class Context;
@class Image;


@interface Context : ObjectBase


    + (Context*) create :(IntSize)size; 
    
    
    - (void) drawImage :(Image*)image :(IntPoint)location;

@end


@interface Image : ObjectBase

    + (Image*) create :(UIImage*)subject; 
    
@end


*/






