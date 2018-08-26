





typedef struct
{
	Int x;
	Int y;
}
IntPoint;

typedef struct
{
	UInt x;
	UInt y;
}
UIntPoint;


STRUCT_NUBLE_TEMPLATE(IntPoint)
STRUCT_NUBLE_TEMPLATE(UIntPoint)

STRUCT_LIST_INTERFACE_TEMPLATE(IntPoint)
STRUCT_LIST_INTERFACE_TEMPLATE(UIntPoint)


NS_INLINE IntPoint IntPoint_create(Int x, Int y) { IntPoint result = { x, y }; return result; }
NS_INLINE UIntPoint UIntPoint_create(UInt x, UInt y) { UIntPoint result = { x, y }; return result; }


NS_INLINE NubleIntPoint IntPoint_createAsNuble(Int x, Int y) { return IntPoint_toNuble(IntPoint_create(x, y)); }
NS_INLINE NubleUIntPoint UIntPoint_createAsNuble(UInt x, UInt y) { return UIntPoint_toNuble(UIntPoint_create(x, y)); }


NS_INLINE void IntPoint_assert(IntPoint self, Int x, Int y) { ASSERT(self.x == x && self.y == y); }
NS_INLINE void UIntPoint_assert(UIntPoint self, UInt x, UInt y) { ASSERT(self.x == x && self.y == y); }































