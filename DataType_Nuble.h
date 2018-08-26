










#define OBJECT_NUBLE_TEMPLATE(TYPE) \
\
	typedef struct \
	{ \
		Bool hasVar; \
		TYPE* vd; \
	} \
	Nuble##TYPE; \
\
\
	NS_INLINE Nuble##TYPE TYPE##_nuble() \
	{ \
		Nuble##TYPE result = { NO, nil }; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_toNuble(TYPE* vd) \
	{ \
		if (vd == nil) return TYPE##_nuble(); \
		\
		Nuble##TYPE result = { YES, vd }; \
		return result; \
	} \
\
    NS_INLINE Nuble##TYPE TYPE##_unsafeFromNubleID(NubleID n) \
    { \
        if (n.hasVar) ASSERT(n.vd != nil); \
        Nuble##TYPE result = { n.hasVar, n.vd };  \
        return result; \
    } \
\
	NS_INLINE TYPE* TYPE##_varOr(Nuble##TYPE n, TYPE* def) \
	{ \
		return (n.hasVar) ? n.vd : def; \
	} \
\
	NS_INLINE TYPE* TYPE##_var(Nuble##TYPE n) \
	{ \
		ASSERT(n.hasVar); return n.vd; \
	} \
\
\
	NS_INLINE Nuble##TYPE TYPE##_retain(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd retain]; \
		return n; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_release(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd release]; \
		return n; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_autorelease(Nuble##TYPE n) \
	{ \
		if (n.hasVar) [n.vd autorelease]; \
		return n; \
	} \
\
\
\
	typedef Bool (^TYPE##_Confirm)(TYPE*); \
	typedef Bool (^TYPE##_IsEqual)(TYPE* x, TYPE* y); \
	typedef Int (^TYPE##_GetHash)(TYPE*); \
	typedef Bool3 (^TYPE##_IsSmallerXY)(TYPE* x, TYPE* y); \
	typedef Bool3 (^TYPE##_IsSmallerTarget)(TYPE* item); \
\
\
\






	
#define STRUCT_NUBLE_TEMPLATE(TYPE) \
\
	typedef struct \
	{ \
		Bool hasVar; \
		TYPE vd; \
	} \
	Nuble##TYPE; \
\
\
	NS_INLINE Nuble##TYPE TYPE##_nuble() \
	{ \
		Nuble##TYPE result; \
		memset(&result, 0, sizeof(Nuble##TYPE)); \
		result.hasVar = NO; \
		return result; \
	} \
\
	NS_INLINE Nuble##TYPE TYPE##_toNuble(TYPE vd) \
	{ \
		Nuble##TYPE result = { YES, vd }; \
		return result; \
	} \
\
\
	NS_INLINE TYPE TYPE##_varOr(Nuble##TYPE n, TYPE def) \
	{ \
		return (n.hasVar) ? n.vd : def; \
	} \
\
	NS_INLINE TYPE TYPE##_var(Nuble##TYPE n) \
	{ \
		ASSERT(n.hasVar); return n.vd; \
	} \
\
\
\
	typedef Bool (^TYPE##_Confirm)(TYPE); \
	typedef Bool (^TYPE##_IsEqual)(TYPE x, TYPE y); \
	typedef Int (^TYPE##_GetHash)(TYPE); \
	typedef Bool3 (^TYPE##_IsSmallerXY)(TYPE x, TYPE y); \
	typedef Bool3 (^TYPE##_IsSmallerTarget)(TYPE item); \
\
\
\



















