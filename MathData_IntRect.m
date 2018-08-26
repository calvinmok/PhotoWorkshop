

#import "MathData.h"













Bool IntRect_isInside(IntRect self, IntPoint value)
{
	IntRect_validate(self); 
	if (value.x < IntRect_leftTop(self).x) return NO;
	if (value.y < IntRect_leftTop(self).y) return NO;
    if (value.x > IntRect_rightBottom(self).x) return NO;
    if (value.y > IntRect_rightBottom(self).y) return NO;
	return YES;
}


Bool IntRect_isIntersected(IntRect alpha, IntRect beta)
{
	IntRect_validate(alpha); 
	IntRect_validate(beta); 
    
	if (IntRect_isInside(alpha, IntRect_leftTop(beta))) return YES;
	if (IntRect_isInside(alpha, IntRect_leftBottom(beta))) return YES;
	if (IntRect_isInside(alpha, IntRect_rightTop(beta))) return YES;
	if (IntRect_isInside(alpha, IntRect_rightBottom(beta))) return YES;
	if (IntRect_isInside(beta, IntRect_leftTop(alpha))) return YES;
	if (IntRect_isInside(beta, IntRect_leftBottom(alpha))) return YES;
	if (IntRect_isInside(beta, IntRect_rightTop(alpha))) return YES;
	if (IntRect_isInside(beta, IntRect_rightBottom(alpha))) return YES;

	return NO;
}




IntRect IntRect_union(IntRect alpha, IntRect beta)
{
	IntRect_validate(alpha); 
	IntRect_validate(beta); 

    Int left = Int_min(alpha.point.x, beta.point.x);
    Int top = Int_min(alpha.point.y, beta.point.y);
	Int right = Int_max(alpha.point.x + alpha.size.width - 1, beta.point.x + beta.size.width - 1);
	Int bottom = Int_max(alpha.point.y + alpha.size.height - 1, beta.point.y + beta.size.height - 1);
	return IntRect_create(left, top, right - left + 1, bottom - top + 1);
}

NubleIntRect IntRect_intersect(IntRect alpha, IntRect beta)
{
	IntRect_validate(alpha); 
	IntRect_validate(beta); 
	
	if (IntRect_isIntersected(alpha, beta) == NO)
		return IntRect_nuble();

    Int left = Int_max(alpha.point.x, beta.point.x);
    Int top = Int_max(alpha.point.y, beta.point.y);
	Int right = Int_min(alpha.point.x + alpha.size.width - 1, beta.point.x + beta.size.width - 1);
	Int bottom = Int_min(alpha.point.y + alpha.size.height - 1, beta.point.y + beta.size.height - 1);
	return IntRect_createAsNuble(left, top, right - left + 1, bottom - top + 1);
}







IntRect IntRect_transpose(IntRect self, IntPoint pivot)
{
	IntRect_validatePoint(pivot); 

	Int x = self.point.y + pivot.x - pivot.y;
	Int y = self.point.x + pivot.y - pivot.x;
	
	if (IntRect_isVertical(self)) 
		return IntRect_createHorizontal(y, self.size.width);
	
	if (IntRect_isHorizontal(self)) 
		return IntRect_createVertical(x, self.size.height);
	
	return IntRect_create(x, y, self.size.height, self.size.width);
}






IntRect IntRect_range(IntPoint alpha, IntPoint beta)
{
	IntRect_validatePoint(alpha); 
	IntRect_validatePoint(beta); 

    Int left = Int_min(alpha.x, beta.x);
    Int top = Int_min(alpha.y, beta.y);
	Int right = Int_max(alpha.x, beta.x);
	Int bottom = Int_max(alpha.y, beta.y);
	return IntRect_create(left, top, right - left + 1, bottom - top + 1);
}








void IntRect_selftest(void)
{
	SELFTEST_START

		IntRect rect = IntRect_create(4, 5, 6, 7);
		IntPoint_assert(rect.point, 4, 5);
		IntSize_assert(rect.size, 6, 7);

		IntPoint_assert(IntRect_leftTop(rect), 4, 5);
		IntPoint_assert(IntRect_leftBottom(rect), 4, 11);
		IntPoint_assert(IntRect_rightTop(rect), 9, 5);
		IntPoint_assert(IntRect_rightBottom(rect), 9, 11);
				
		ASSERT(IntRect_isInside(rect, IntPoint_create(4, 5)));
		ASSERT(IntRect_isInside(rect, IntPoint_create(4, 11)));
		ASSERT(IntRect_isInside(rect, IntPoint_create(7, 8)));
		ASSERT(IntRect_isInside(rect, IntPoint_create(9, 5)));
		ASSERT(IntRect_isInside(rect, IntPoint_create(9, 11)));
		
		ASSERT(IntRect_isIntersected(IntRect_create(1, 1, 1, 1), IntRect_create(4, 5, 6, 7)) == NO);
		ASSERT(IntRect_isIntersected(IntRect_create(4, 5, 6, 7), IntRect_create(1, 1, 1, 1)) == NO);
		ASSERT(IntRect_isIntersected(IntRect_create(3, 3, 3, 3), IntRect_create(5, 5, 1, 1)) );
		ASSERT(IntRect_isIntersected(IntRect_create(3, 3, 3, 3), IntRect_create(2, 2, 2, 2)) );
		
		IntRect_assert(IntRect_union(IntRect_create(3, 3, 3, 3), IntRect_create(5, 5, 4, 4)), 3, 3, 6, 6);
		
		IntRect_assertHorizontal(IntRect_union(IntRect_createHorizontal(3, 5), IntRect_create(7, 7, 2, 2)), 3, 6);
		
		IntRect_assert(IntRect_intersect(IntRect_create(3, 3, 3, 3), IntRect_create(5, 5, 4, 4)).vd, 5, 5, 1, 1);
		IntRect_assert(IntRect_intersect(IntRect_create(3, 3, 4, 4), IntRect_create(5, 5, 4, 4)).vd, 5, 5, 2, 2);
		
		IntRect_assert(IntRect_range(IntPoint_create(3, 3), IntPoint_create(5, 5)), 3, 3, 3, 3);
		IntRect_assert(IntRect_range(IntPoint_create(3, 3), IntPoint_create(8, 8)), 3, 3, 6, 6);
		
	SELFTEST_END
}














