




typedef struct
{
	Int width;
	Int height;
}
IntSize;

typedef struct
{
	const UInt width;
	const UInt height;
}
UIntSize;


STRUCT_NUBLE_TEMPLATE(IntSize)
STRUCT_NUBLE_TEMPLATE(UIntSize)


NS_INLINE IntSize IntSize_create(Int x, Int y) { IntSize result = { x, y }; return result; }
NS_INLINE UIntSize UIntSize_create(UInt x, UInt y) { UIntSize result = { x, y }; return result; }


NS_INLINE NubleIntSize IntSize_createAsNuble(Int x, Int y) { return IntSize_toNuble(IntSize_create(x, y)); }
NS_INLINE NubleUIntSize UIntSize_createAsNuble(UInt x, UInt y) { return UIntSize_toNuble(UIntSize_create(x, y)); }


NS_INLINE void IntSize_assert(IntSize self, Int w, Int h) { ASSERT(self.width == w && self.height == h); }
NS_INLINE void UIntSize_assert(UIntSize self, UInt w, UInt h) { ASSERT(self.width == w && self.height == h); }



























