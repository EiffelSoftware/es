

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0361 */
/* at Fri Oct 07 11:52:16 2005
 */
/* Compiler settings for metadata_consumer.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data
    VC __declspec() decoration level:
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#if !defined(_M_IA64) && !defined(_M_AMD64)


#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, LIBID_EiffelSoftware_MetadataConsumer,0xD5714119,0x7213,0x34EF,0xA9,0x43,0x2E,0xD2,0xB0,0x5D,0xC6,0xF8);


MIDL_DEFINE_GUID(IID, IID_EiffelSoftware_MetadataConsumer_Interop_I_COM_CACHE_MANAGER,0xE1FFE13A,0x0683,0x44B2,0x98,0x56,0xD6,0x80,0x02,0x80,0xE5,0x06);


MIDL_DEFINE_GUID(IID, IID_EiffelSoftware_MetadataConsumer_Interop_I_COM_ASSEMBLY_INFORMATION,0xE1FFE18C,0x4185,0x4EB5,0x96,0x7F,0x51,0x2C,0x66,0xDA,0xA3,0xB5);


MIDL_DEFINE_GUID(CLSID, CLSID_EiffelSoftware_MetadataConsumer_Interop_Impl_COM_CACHE_MANAGER,0xE1FFE185,0x67CA,0x4EC0,0xB0,0x00,0x4D,0x73,0xC1,0xD2,0x97,0x7F);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



#endif /* !defined(_M_IA64) && !defined(_M_AMD64)*/



/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0361 */
/* at Fri Oct 07 11:52:16 2005
 */
/* Compiler settings for metadata_consumer.idl:
    Oicf, W1, Zp8, env=Win64 (32b run,appending)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data
    VC __declspec() decoration level:
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#if defined(_M_IA64) || defined(_M_AMD64)


#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, LIBID_EiffelSoftware_MetadataConsumer,0xD5714119,0x7213,0x34EF,0xA9,0x43,0x2E,0xD2,0xB0,0x5D,0xC6,0xF8);


MIDL_DEFINE_GUID(IID, IID_EiffelSoftware_MetadataConsumer_Interop_I_COM_CACHE_MANAGER,0xE1FFE13A,0x0683,0x44B2,0x98,0x56,0xD6,0x80,0x02,0x80,0xE5,0x06);


MIDL_DEFINE_GUID(IID, IID_EiffelSoftware_MetadataConsumer_Interop_I_COM_ASSEMBLY_INFORMATION,0xE1FFE18C,0x4185,0x4EB5,0x96,0x7F,0x51,0x2C,0x66,0xDA,0xA3,0xB5);


MIDL_DEFINE_GUID(CLSID, CLSID_EiffelSoftware_MetadataConsumer_Interop_Impl_COM_CACHE_MANAGER,0xE1FFE185,0x67CA,0x4EC0,0xB0,0x00,0x4D,0x73,0xC1,0xD2,0x97,0x7F);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



#endif /* defined(_M_IA64) || defined(_M_AMD64)*/

