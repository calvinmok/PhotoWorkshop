






#import <Foundation/Foundation.h>

#import <objc/runtime.h>



#define IF if
#define EF else if
#define EL else


#define ABSTRACT_METHOD_VOID  { ASSERT(NO); }
#define ABSTRACT_METHOD_NIL   { ASSERT(NO); return nil; }
#define ABSTRACT_METHOD(TYPE) { ASSERT(NO); TYPE r; memset(&r,0,sizeof(TYPE)); return r; }

#define STATIC_OBJECT(TYPE, NAME, INIT) static TYPE* NAME = nil; if (NAME == nil) NAME = [INIT retain];

#define STATIC_O(Type, Name, INIT) static Type* Name = nil; if (Name == nil) Name = [INIT retain];

#define RETURN_STATIC_OBJECT(TYPE, INIT) static TYPE* v = nil; if (v == nil) v = [INIT retain]; return v;

#define SELFTEST_START { static BOOL selfTestCompleted = NO; if (selfTestCompleted == NO) { selfTestCompleted = YES;
#define SELFTEST_END   } }







typedef id ID;

typedef void* Pntr;
typedef const void* ConstPntr;



typedef BOOL Bool ;

//#define Yes YES
//#define No  NO

typedef int8_t Bool3 ;

#define Yes       1
#define Unknown   0
#define No       -1

#define MbYes    != -1
#define IsKnown  != 0
#define MbNo     != 1



typedef int8_t Int8;



typedef u_int8_t Byte;

#define Byte_Min  0
#define Byte_Max  255




typedef unichar Char;

#define Char_Null '\0'
#define Char_Min   0
#define Char_Max   USHRT_MAX




typedef NSInteger Int;

#define Int_Min NSIntegerMin
#define Int_Max NSIntegerMax





typedef NSUInteger UInt;
#define UInt_Min 0
#define UInt_Max NSUIntegerMax




typedef double Double;
#define Double_Min     DBL_MIN
#define Double_Max     DBL_MAX
#define Double_Epsilon DBL_EPSILON


typedef float Single;
#define Single_Min     FLT_MIN
#define Single_Max     FLT_MAX
#define Single_Epsilon FLT_EPSILON


@class String;
@class StableString;
@class MutableString;




void ASSERT(Bool value);

Int BREAK(void);
Int BREAK_IF(Bool);




#import "DataType_Nuble.h"




STRUCT_NUBLE_TEMPLATE(Bool)


STRUCT_NUBLE_TEMPLATE(ID)
STRUCT_NUBLE_TEMPLATE(NubleID)

NS_INLINE NubleID ID_as(Class c, ID me) { ASSERT(me != nil); return [me isKindOfClass:c] ? ID_toNuble(me) : ID_nuble(); }
#define AS(TYPE, VALUE)   (TYPE##_unsafeFromNubleID(ID_as([TYPE class], VALUE)))   
#define CAST(TYPE, VALUE) ((TYPE*)ID_var(ID_as([TYPE class], VALUE)))

NS_INLINE NubleID NubleID_as(Class c, NubleID me) { return (me.hasVar && [me.vd isKindOfClass:c]) ? ID_toNuble(me.vd) : ID_nuble(); }
#define NubleID_AS(TYPE, VALUE)   (TYPE##_unsafeFromNubleID(NubleID_as([TYPE class], VALUE)))
#define NubleID_CAST(TYPE, VALUE) ((TYPE*)ID_var(NubleID_as([TYPE class], VALUE)))



STRUCT_NUBLE_TEMPLATE(Pntr)
STRUCT_NUBLE_TEMPLATE(ConstPntr)


STRUCT_NUBLE_TEMPLATE(Int)
STRUCT_NUBLE_TEMPLATE(UInt)
STRUCT_NUBLE_TEMPLATE(Byte)
STRUCT_NUBLE_TEMPLATE(Char)
STRUCT_NUBLE_TEMPLATE(Single)
STRUCT_NUBLE_TEMPLATE(Double)


OBJECT_NUBLE_TEMPLATE(String) 
OBJECT_NUBLE_TEMPLATE(StableString) 
OBJECT_NUBLE_TEMPLATE(MutableString) 


#import "DataType_ObjectBase.h"

#import "DataType_List.h"
#import "DataType_StructList.h"
#import "DataType_ObjectList.h"
#import "DataType_List_Enum.h"
#import "DataType_List_Algorithm.h"




STRUCT_LIST_INTERFACE_TEMPLATE(NubleID)	
STRUCT_LIST_INTERFACE_TEMPLATE(Bool)

STRUCT_LIST_INTERFACE_TEMPLATE(Byte)
STRUCT_LIST_INTERFACE_TEMPLATE(Char)

STRUCT_LIST_INTERFACE_TEMPLATE(Int)
STRUCT_LIST_INTERFACE_TEMPLATE(UInt)
STRUCT_LIST_INTERFACE_TEMPLATE(Single)
STRUCT_LIST_INTERFACE_TEMPLATE(Double)


OBJECT_LIST_INTERFACE_TEMPLATE(String, NSObject)
OBJECT_LIST_INTERFACE_TEMPLATE(StableString, String)
OBJECT_LIST_INTERFACE_TEMPLATE(MutableString, String)




#import "DataType_Bool.h"
#import "DataType_Char.h"
#import "DataType_Byte.h"

#import "DataType_Int.h"
#import "DataType_Double.h"
#import "DataType_DecDouble.h"

#import "DataType_StringList.h"
#import "DataType_String.h"
#import "DataType_StringExtension.h"
#import "DataType_String_ExcelPattern.h"
#import "DataType_String_Base64.h"


















#import "DataType_DT2001.h"

#import "DataType_Flow.h"

#import "DataType_Set.h"










