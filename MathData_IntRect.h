






#define IntRect_Max (Int_Max/2)
#define IntRect_Min (IntRect_Max - Int_Max)



typedef struct
{
	IntPoint point; // IntRect_MIN <= value <= IntRect_MAX
	IntSize size;   // 1 <= value <= Int_MAX
}
IntRect;

STRUCT_NUBLE_TEMPLATE(IntRect)





NS_INLINE IntPoint IntRect_validatePoint(IntPoint p) { ASSERT(IntRect_Min <= p.x && p.x <= IntRect_Max); ASSERT(IntRect_Min <= p.y && p.y <= IntRect_Max); return p; }

NS_INLINE IntSize IntRect_validateSize(IntSize z) { ASSERT(1 <= z.width && 1 <= z.height); return z; }

NS_INLINE IntRect IntRect_validate(IntRect self) { IntRect_validatePoint(self.point); IntRect_validateSize(self.size); return self; }





NS_INLINE IntRect IntRect_create(Int x, Int y, Int width, Int height) {
	IntRect result = { IntPoint_create(x, y), IntSize_create(width, height) }; return IntRect_validate(result); }







NS_INLINE NubleIntRect IntRect_createAsNuble(Int x, Int y, Int width, Int height) {
   return IntRect_toNuble(IntRect_create(x, y, width, height)); }







NS_INLINE IntPoint IntRect_leftTop(IntRect self) {
	IntRect_validate(self); return (self.point); }
	
NS_INLINE IntPoint IntRect_leftBottom(IntRect self) {
	IntRect_validate(self); return IntPoint_create(self.point.x, self.point.y + self.size.height - 1); }
	
NS_INLINE IntPoint IntRect_rightTop(IntRect self){
	IntRect_validate(self); return IntPoint_create(self.point.x + self.size.width - 1, self.point.y); }
	
NS_INLINE IntPoint IntRect_rightBottom(IntRect self) {
	IntRect_validate(self); return IntPoint_create(self.point.x + self.size.width - 1, self.point.y + self.size.height - 1); }




Bool IntRect_isInside(IntRect self, IntPoint value);
Bool IntRect_isIntersected(IntRect alpha, IntRect beta);




IntRect IntRect_union(IntRect alpha, IntRect beta);
NubleIntRect IntRect_intersect(IntRect alpha, IntRect beta);




IntRect IntRect_transpose(IntRect self, IntPoint pivot);

NS_INLINE IntRect IntRect_transposeXY(IntRect self, Int pivotX, Int pivotY) {
	return IntRect_transpose(self, IntPoint_create(pivotX, pivotY)); }




IntRect IntRect_range(IntPoint alpha, IntPoint beta);





NS_INLINE IntRect IntRect_createHorizontal(Int y, Int height) {
	return IntRect_create(IntRect_Min, y, Int_Max, height); }
	
NS_INLINE IntRect IntRect_createVertical(Int x, Int width) {
	return IntRect_create(x, IntRect_Min, width, Int_Max); }
	


	
NS_INLINE Bool IntRect_isHorizontal(IntRect self) {
	IntRect_validate(self); return (self.point.x == IntRect_Min && self.size.width == Int_Max); }
	
NS_INLINE Bool IntRect_isVertical(IntRect self) {
	IntRect_validate(self); return (self.point.y == IntRect_Min && self.size.height == Int_Max); }

NS_INLINE Bool IntRect_isDimensional(IntRect self) {
	IntRect_validate(self); return IntRect_isHorizontal(self) || IntRect_isVertical(self); }







NS_INLINE void IntRect_assert(IntRect self, Int x, Int y, Int w, Int h) {
	ASSERT(self.point.x == x && self.point.y == y && self.size.width == w && self.size.height == h); }

NS_INLINE void IntRect_assertHorizontal(IntRect self, Int y, Int height) {
	ASSERT(IntRect_isHorizontal(self) && self.point.y == y && self.size.height == height); }

NS_INLINE void IntRect_assertVertical(IntRect self, Int x, Int width) {
	ASSERT(IntRect_isVertical(self) && self.point.x == x && self.size.width == width); }







void IntRect_selftest(void);








