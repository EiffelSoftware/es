#ifndef EWG_CALLBACK_CARBON___
#define EWG_CALLBACK_CARBON___

#include <Carbon/Carbon.h>

typedef void (*cgdata_provider_release_data_callback_eiffel_feature) (void *a_class, void *info, void const *data, size_t size);

void* get_cgdata_provider_release_data_callback_stub ();

struct cgdata_provider_release_data_callback_entry_struct
{
	void* a_class;
	cgdata_provider_release_data_callback_eiffel_feature feature;
};

void set_cgdata_provider_release_data_callback_entry (void* a_class, void* a_feature);

void call_cgdata_provider_release_data_callback (void *a_function, void *info, void const *data, size_t size);


#include <Carbon/Carbon.h>

typedef void (*aeremote_process_resolver_callback_eiffel_feature) (void *a_class, AERemoteProcessResolverRef ref, void *info);

void* get_aeremote_process_resolver_callback_stub ();

struct aeremote_process_resolver_callback_entry_struct
{
	void* a_class;
	aeremote_process_resolver_callback_eiffel_feature feature;
};

void set_aeremote_process_resolver_callback_entry (void* a_class, void* a_feature);

void call_aeremote_process_resolver_callback (void *a_function, AERemoteProcessResolverRef ref, void *info);


#include <Carbon/Carbon.h>

typedef void (*qdtext_proc_ptr_eiffel_feature) (void *a_class, short byteCount, void const *textBuf, Point numer, Point denom);

void* get_qdtext_proc_ptr_stub ();

struct qdtext_proc_ptr_entry_struct
{
	void* a_class;
	qdtext_proc_ptr_eiffel_feature feature;
};

void set_qdtext_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdtext_proc_ptr (void *a_function, short byteCount, void const *textBuf, Point numer, Point denom);


#include <Carbon/Carbon.h>

typedef void (*qdline_proc_ptr_eiffel_feature) (void *a_class, Point newPt);

void* get_qdline_proc_ptr_stub ();

struct qdline_proc_ptr_entry_struct
{
	void* a_class;
	qdline_proc_ptr_eiffel_feature feature;
};

void set_qdline_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdline_proc_ptr (void *a_function, Point newPt);


#include <Carbon/Carbon.h>

typedef void (*qdrect_proc_ptr_eiffel_feature) (void *a_class, GrafVerb verb, Rect const *r);

void* get_qdrect_proc_ptr_stub ();

struct qdrect_proc_ptr_entry_struct
{
	void* a_class;
	qdrect_proc_ptr_eiffel_feature feature;
};

void set_qdrect_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdrect_proc_ptr (void *a_function, GrafVerb verb, Rect const *r);


#include <Carbon/Carbon.h>

typedef void (*qdrrect_proc_ptr_eiffel_feature) (void *a_class, GrafVerb verb, Rect const *r, short ovalWidth, short ovalHeight);

void* get_qdrrect_proc_ptr_stub ();

struct qdrrect_proc_ptr_entry_struct
{
	void* a_class;
	qdrrect_proc_ptr_eiffel_feature feature;
};

void set_qdrrect_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdrrect_proc_ptr (void *a_function, GrafVerb verb, Rect const *r, short ovalWidth, short ovalHeight);


#include <Carbon/Carbon.h>

typedef void (*qdarc_proc_ptr_eiffel_feature) (void *a_class, GrafVerb verb, Rect const *r, short startAngle, short arcAngle);

void* get_qdarc_proc_ptr_stub ();

struct qdarc_proc_ptr_entry_struct
{
	void* a_class;
	qdarc_proc_ptr_eiffel_feature feature;
};

void set_qdarc_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdarc_proc_ptr (void *a_function, GrafVerb verb, Rect const *r, short startAngle, short arcAngle);


#include <Carbon/Carbon.h>

typedef void (*qdpoly_proc_ptr_eiffel_feature) (void *a_class, GrafVerb verb, PolyHandle poly);

void* get_qdpoly_proc_ptr_stub ();

struct qdpoly_proc_ptr_entry_struct
{
	void* a_class;
	qdpoly_proc_ptr_eiffel_feature feature;
};

void set_qdpoly_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdpoly_proc_ptr (void *a_function, GrafVerb verb, PolyHandle poly);


#include <Carbon/Carbon.h>

typedef void (*qdrgn_proc_ptr_eiffel_feature) (void *a_class, GrafVerb verb, RgnHandle rgn);

void* get_qdrgn_proc_ptr_stub ();

struct qdrgn_proc_ptr_entry_struct
{
	void* a_class;
	qdrgn_proc_ptr_eiffel_feature feature;
};

void set_qdrgn_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdrgn_proc_ptr (void *a_function, GrafVerb verb, RgnHandle rgn);


#include <Carbon/Carbon.h>

typedef void (*qdbits_proc_ptr_eiffel_feature) (void *a_class, BitMap const *srcBits, Rect const *srcRect, Rect const *dstRect, short mode, RgnHandle maskRgn);

void* get_qdbits_proc_ptr_stub ();

struct qdbits_proc_ptr_entry_struct
{
	void* a_class;
	qdbits_proc_ptr_eiffel_feature feature;
};

void set_qdbits_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdbits_proc_ptr (void *a_function, BitMap const *srcBits, Rect const *srcRect, Rect const *dstRect, short mode, RgnHandle maskRgn);


#include <Carbon/Carbon.h>

typedef void (*qdcomment_proc_ptr_eiffel_feature) (void *a_class, short kind, short dataSize, Handle dataHandle);

void* get_qdcomment_proc_ptr_stub ();

struct qdcomment_proc_ptr_entry_struct
{
	void* a_class;
	qdcomment_proc_ptr_eiffel_feature feature;
};

void set_qdcomment_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdcomment_proc_ptr (void *a_function, short kind, short dataSize, Handle dataHandle);


#include <Carbon/Carbon.h>

typedef short (*qdtx_meas_proc_ptr_eiffel_feature) (void *a_class, short byteCount, void const *textAddr, Point *numer, Point *denom, FontInfo *info);

void* get_qdtx_meas_proc_ptr_stub ();

struct qdtx_meas_proc_ptr_entry_struct
{
	void* a_class;
	qdtx_meas_proc_ptr_eiffel_feature feature;
};

void set_qdtx_meas_proc_ptr_entry (void* a_class, void* a_feature);

short call_qdtx_meas_proc_ptr (void *a_function, short byteCount, void const *textAddr, Point *numer, Point *denom, FontInfo *info);


#include <Carbon/Carbon.h>

typedef void (*qdget_pic_proc_ptr_eiffel_feature) (void *a_class, void *dataPtr, short byteCount);

void* get_qdget_pic_proc_ptr_stub ();

struct qdget_pic_proc_ptr_entry_struct
{
	void* a_class;
	qdget_pic_proc_ptr_eiffel_feature feature;
};

void set_qdget_pic_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdget_pic_proc_ptr (void *a_function, void *dataPtr, short byteCount);


#include <Carbon/Carbon.h>

typedef void (*qdput_pic_proc_ptr_eiffel_feature) (void *a_class, void const *dataPtr, short byteCount);

void* get_qdput_pic_proc_ptr_stub ();

struct qdput_pic_proc_ptr_entry_struct
{
	void* a_class;
	qdput_pic_proc_ptr_eiffel_feature feature;
};

void set_qdput_pic_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdput_pic_proc_ptr (void *a_function, void const *dataPtr, short byteCount);


#include <Carbon/Carbon.h>

typedef void (*qdopcode_proc_ptr_eiffel_feature) (void *a_class, Rect const *fromRect, Rect const *toRect, UInt16 opcode, SInt16 version);

void* get_qdopcode_proc_ptr_stub ();

struct qdopcode_proc_ptr_entry_struct
{
	void* a_class;
	qdopcode_proc_ptr_eiffel_feature feature;
};

void set_qdopcode_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdopcode_proc_ptr (void *a_function, Rect const *fromRect, Rect const *toRect, UInt16 opcode, SInt16 version);


#include <Carbon/Carbon.h>

typedef OSStatus (*qdstd_glyphs_proc_ptr_eiffel_feature) (void *a_class, void *dataStream, ByteCount size);

void* get_qdstd_glyphs_proc_ptr_stub ();

struct qdstd_glyphs_proc_ptr_entry_struct
{
	void* a_class;
	qdstd_glyphs_proc_ptr_eiffel_feature feature;
};

void set_qdstd_glyphs_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_qdstd_glyphs_proc_ptr (void *a_function, void *dataStream, ByteCount size);


#include <Carbon/Carbon.h>

typedef void (*qdjshield_cursor_proc_ptr_eiffel_feature) (void *a_class, short left, short top, short right, short bottom);

void* get_qdjshield_cursor_proc_ptr_stub ();

struct qdjshield_cursor_proc_ptr_entry_struct
{
	void* a_class;
	qdjshield_cursor_proc_ptr_eiffel_feature feature;
};

void set_qdjshield_cursor_proc_ptr_entry (void* a_class, void* a_feature);

void call_qdjshield_cursor_proc_ptr (void *a_function, short left, short top, short right, short bottom);


#include <Carbon/Carbon.h>

typedef void (*cfrag_term_procedure_eiffel_feature) (void *a_class);

void* get_cfrag_term_procedure_stub ();

struct cfrag_term_procedure_entry_struct
{
	void* a_class;
	cfrag_term_procedure_eiffel_feature feature;
};

void set_cfrag_term_procedure_entry (void* a_class, void* a_feature);

void call_cfrag_term_procedure (void *a_function);


#include <Carbon/Carbon.h>

typedef Boolean (*color_search_proc_ptr_eiffel_feature) (void *a_class, RGBColor *rgb, long *position);

void* get_color_search_proc_ptr_stub ();

struct color_search_proc_ptr_entry_struct
{
	void* a_class;
	color_search_proc_ptr_eiffel_feature feature;
};

void set_color_search_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_color_search_proc_ptr (void *a_function, RGBColor *rgb, long *position);


#include <Carbon/Carbon.h>

typedef Boolean (*color_complement_proc_ptr_eiffel_feature) (void *a_class, RGBColor *rgb);

void* get_color_complement_proc_ptr_stub ();

struct color_complement_proc_ptr_entry_struct
{
	void* a_class;
	color_complement_proc_ptr_eiffel_feature feature;
};

void set_color_complement_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_color_complement_proc_ptr (void *a_function, RGBColor *rgb);


#include <Carbon/Carbon.h>

typedef void (*device_loop_drawing_proc_ptr_eiffel_feature) (void *a_class, short depth, short deviceFlags, GDHandle targetDevice, long userData);

void* get_device_loop_drawing_proc_ptr_stub ();

struct device_loop_drawing_proc_ptr_entry_struct
{
	void* a_class;
	device_loop_drawing_proc_ptr_eiffel_feature feature;
};

void set_device_loop_drawing_proc_ptr_entry (void* a_class, void* a_feature);

void call_device_loop_drawing_proc_ptr (void *a_function, short depth, short deviceFlags, GDHandle targetDevice, long userData);


#include <Carbon/Carbon.h>

typedef OSStatus (*region_to_rects_proc_ptr_eiffel_feature) (void *a_class, UInt16 message, RgnHandle rgn, Rect const *rect, void *refCon);

void* get_region_to_rects_proc_ptr_stub ();

struct region_to_rects_proc_ptr_entry_struct
{
	void* a_class;
	region_to_rects_proc_ptr_eiffel_feature feature;
};

void set_region_to_rects_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_region_to_rects_proc_ptr (void *a_function, UInt16 message, RgnHandle rgn, Rect const *rect, void *refCon);


#include <Carbon/Carbon.h>

typedef void (*custom_xfer_proc_ptr_eiffel_feature) (void *a_class, CustomXFerRecPtr info);

void* get_custom_xfer_proc_ptr_stub ();

struct custom_xfer_proc_ptr_entry_struct
{
	void* a_class;
	custom_xfer_proc_ptr_eiffel_feature feature;
};

void set_custom_xfer_proc_ptr_entry (void* a_class, void* a_feature);

void call_custom_xfer_proc_ptr (void *a_function, CustomXFerRecPtr info);


#include <Carbon/Carbon.h>

typedef Boolean (*event_comparator_proc_ptr_eiffel_feature) (void *a_class, EventRef inEvent, void *inCompareData);

void* get_event_comparator_proc_ptr_stub ();

struct event_comparator_proc_ptr_entry_struct
{
	void* a_class;
	event_comparator_proc_ptr_eiffel_feature feature;
};

void set_event_comparator_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_event_comparator_proc_ptr (void *a_function, EventRef inEvent, void *inCompareData);


#include <Carbon/Carbon.h>

typedef void (*event_loop_timer_proc_ptr_eiffel_feature) (void *a_class, EventLoopTimerRef inTimer, void *inUserData);

void* get_event_loop_timer_proc_ptr_stub ();

struct event_loop_timer_proc_ptr_entry_struct
{
	void* a_class;
	event_loop_timer_proc_ptr_eiffel_feature feature;
};

void set_event_loop_timer_proc_ptr_entry (void* a_class, void* a_feature);

void call_event_loop_timer_proc_ptr (void *a_function, EventLoopTimerRef inTimer, void *inUserData);


#include <Carbon/Carbon.h>

typedef void (*event_loop_idle_timer_proc_ptr_eiffel_feature) (void *a_class, EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *inUserData);

void* get_event_loop_idle_timer_proc_ptr_stub ();

struct event_loop_idle_timer_proc_ptr_entry_struct
{
	void* a_class;
	event_loop_idle_timer_proc_ptr_eiffel_feature feature;
};

void set_event_loop_idle_timer_proc_ptr_entry (void* a_class, void* a_feature);

void call_event_loop_idle_timer_proc_ptr (void *a_function, EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *inUserData);


#include <Carbon/Carbon.h>

typedef OSStatus (*event_handler_proc_ptr_eiffel_feature) (void *a_class, EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData);

void* get_event_handler_proc_ptr_stub ();

struct event_handler_proc_ptr_entry_struct
{
	void* a_class;
	event_handler_proc_ptr_eiffel_feature feature;
};

void set_event_handler_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_event_handler_proc_ptr (void *a_function, EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData);


#include <Carbon/Carbon.h>

typedef void (*menu_def_proc_ptr_eiffel_feature) (void *a_class, short message, MenuRef theMenu, Rect *menuRect, Point hitPt, short *whichItem);

void* get_menu_def_proc_ptr_stub ();

struct menu_def_proc_ptr_entry_struct
{
	void* a_class;
	menu_def_proc_ptr_eiffel_feature feature;
};

void set_menu_def_proc_ptr_entry (void* a_class, void* a_feature);

void call_menu_def_proc_ptr (void *a_function, short message, MenuRef theMenu, Rect *menuRect, Point hitPt, short *whichItem);


#include <Carbon/Carbon.h>

typedef void (*control_action_proc_ptr_eiffel_feature) (void *a_class, ControlRef theControl, ControlPartCode partCode);

void* get_control_action_proc_ptr_stub ();

struct control_action_proc_ptr_entry_struct
{
	void* a_class;
	control_action_proc_ptr_eiffel_feature feature;
};

void set_control_action_proc_ptr_entry (void* a_class, void* a_feature);

void call_control_action_proc_ptr (void *a_function, ControlRef theControl, ControlPartCode partCode);


#include <Carbon/Carbon.h>

typedef SInt32 (*control_def_proc_ptr_eiffel_feature) (void *a_class, SInt16 varCode, ControlRef theControl, ControlDefProcMessage message, SInt32 param);

void* get_control_def_proc_ptr_stub ();

struct control_def_proc_ptr_entry_struct
{
	void* a_class;
	control_def_proc_ptr_eiffel_feature feature;
};

void set_control_def_proc_ptr_entry (void* a_class, void* a_feature);

SInt32 call_control_def_proc_ptr (void *a_function, SInt16 varCode, ControlRef theControl, ControlDefProcMessage message, SInt32 param);


#include <Carbon/Carbon.h>

typedef ControlKeyFilterResult (*control_key_filter_proc_ptr_eiffel_feature) (void *a_class, ControlRef theControl, SInt16 *keyCode, SInt16 *charCode, EventModifiers *modifiers);

void* get_control_key_filter_proc_ptr_stub ();

struct control_key_filter_proc_ptr_entry_struct
{
	void* a_class;
	control_key_filter_proc_ptr_eiffel_feature feature;
};

void set_control_key_filter_proc_ptr_entry (void* a_class, void* a_feature);

ControlKeyFilterResult call_control_key_filter_proc_ptr (void *a_function, ControlRef theControl, SInt16 *keyCode, SInt16 *charCode, EventModifiers *modifiers);


#include <Carbon/Carbon.h>

typedef OSStatus (*control_cntlto_collection_proc_ptr_eiffel_feature) (void *a_class, Rect const *bounds, SInt16 value, Boolean visible, SInt16 max, SInt16 min, SInt16 procID, SInt32 refCon, ConstStr255Param title, Collection collection);

void* get_control_cntlto_collection_proc_ptr_stub ();

struct control_cntlto_collection_proc_ptr_entry_struct
{
	void* a_class;
	control_cntlto_collection_proc_ptr_eiffel_feature feature;
};

void set_control_cntlto_collection_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_control_cntlto_collection_proc_ptr (void *a_function, Rect const *bounds, SInt16 value, Boolean visible, SInt16 max, SInt16 min, SInt16 procID, SInt32 refCon, ConstStr255Param title, Collection collection);


#include <Carbon/Carbon.h>

typedef OSStatus (*control_color_proc_ptr_eiffel_feature) (void *a_class, ControlRef inControl, SInt16 inMessage, SInt16 inDrawDepth, Boolean inDrawInColor);

void* get_control_color_proc_ptr_stub ();

struct control_color_proc_ptr_entry_struct
{
	void* a_class;
	control_color_proc_ptr_eiffel_feature feature;
};

void set_control_color_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_control_color_proc_ptr (void *a_function, ControlRef inControl, SInt16 inMessage, SInt16 inDrawDepth, Boolean inDrawInColor);


#include <Carbon/Carbon.h>

typedef long (*window_def_proc_ptr_eiffel_feature) (void *a_class, short varCode, WindowRef window, short message, long param);

void* get_window_def_proc_ptr_stub ();

struct window_def_proc_ptr_entry_struct
{
	void* a_class;
	window_def_proc_ptr_eiffel_feature feature;
};

void set_window_def_proc_ptr_entry (void* a_class, void* a_feature);

long call_window_def_proc_ptr (void *a_function, short varCode, WindowRef window, short message, long param);


#include <Carbon/Carbon.h>

typedef OSStatus (*window_paint_proc_ptr_eiffel_feature) (void *a_class, GDHandle device, GrafPtr qdContext, WindowRef window, RgnHandle inClientPaintRgn, RgnHandle outSystemPaintRgn, void *refCon);

void* get_window_paint_proc_ptr_stub ();

struct window_paint_proc_ptr_entry_struct
{
	void* a_class;
	window_paint_proc_ptr_eiffel_feature feature;
};

void set_window_paint_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_window_paint_proc_ptr (void *a_function, GDHandle device, GrafPtr qdContext, WindowRef window, RgnHandle inClientPaintRgn, RgnHandle outSystemPaintRgn, void *refCon);


#include <Carbon/Carbon.h>

typedef OSStatus (*txnfind_proc_ptr_eiffel_feature) (void *a_class, TXNMatchTextRecord const *matchData, TXNDataType iDataType, TXNMatchOptions iMatchOptions, void const *iSearchTextPtr, TextEncoding encoding, TXNOffset absStartOffset, ByteCount searchTextLength, TXNOffset *oStartMatch, TXNOffset *oEndMatch, Boolean *ofound, UInt32 refCon);

void* get_txnfind_proc_ptr_stub ();

struct txnfind_proc_ptr_entry_struct
{
	void* a_class;
	txnfind_proc_ptr_eiffel_feature feature;
};

void set_txnfind_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_txnfind_proc_ptr (void *a_function, TXNMatchTextRecord const *matchData, TXNDataType iDataType, TXNMatchOptions iMatchOptions, void const *iSearchTextPtr, TextEncoding encoding, TXNOffset absStartOffset, ByteCount searchTextLength, TXNOffset *oStartMatch, TXNOffset *oEndMatch, Boolean *ofound, UInt32 refCon);


#include <Carbon/Carbon.h>

typedef CFStringRef (*txnaction_name_mapper_proc_ptr_eiffel_feature) (void *a_class, CFStringRef actionName, UInt32 commandID, void *inUserData);

void* get_txnaction_name_mapper_proc_ptr_stub ();

struct txnaction_name_mapper_proc_ptr_entry_struct
{
	void* a_class;
	txnaction_name_mapper_proc_ptr_eiffel_feature feature;
};

void set_txnaction_name_mapper_proc_ptr_entry (void* a_class, void* a_feature);

CFStringRef call_txnaction_name_mapper_proc_ptr (void *a_function, CFStringRef actionName, UInt32 commandID, void *inUserData);


#include <Carbon/Carbon.h>

typedef void (*txncontextual_menu_setup_proc_ptr_eiffel_feature) (void *a_class, MenuRef iContextualMenu, TXNObject object, void *inUserData);

void* get_txncontextual_menu_setup_proc_ptr_stub ();

struct txncontextual_menu_setup_proc_ptr_entry_struct
{
	void* a_class;
	txncontextual_menu_setup_proc_ptr_eiffel_feature feature;
};

void set_txncontextual_menu_setup_proc_ptr_entry (void* a_class, void* a_feature);

void call_txncontextual_menu_setup_proc_ptr (void *a_function, MenuRef iContextualMenu, TXNObject object, void *inUserData);


#include <Carbon/Carbon.h>

typedef void (*txnscroll_info_proc_ptr_eiffel_feature) (void *a_class, SInt32 iValue, SInt32 iMaximumValue, TXNScrollBarOrientation iScrollBarOrientation, SInt32 iRefCon);

void* get_txnscroll_info_proc_ptr_stub ();

struct txnscroll_info_proc_ptr_entry_struct
{
	void* a_class;
	txnscroll_info_proc_ptr_eiffel_feature feature;
};

void set_txnscroll_info_proc_ptr_entry (void* a_class, void* a_feature);

void call_txnscroll_info_proc_ptr (void *a_function, SInt32 iValue, SInt32 iMaximumValue, TXNScrollBarOrientation iScrollBarOrientation, SInt32 iRefCon);


#include <Carbon/Carbon.h>

typedef CFStringRef (*txnaction_key_mapper_proc_ptr_eiffel_feature) (void *a_class, TXNActionKey actionKey, UInt32 commandID);

void* get_txnaction_key_mapper_proc_ptr_stub ();

struct txnaction_key_mapper_proc_ptr_entry_struct
{
	void* a_class;
	txnaction_key_mapper_proc_ptr_eiffel_feature feature;
};

void set_txnaction_key_mapper_proc_ptr_entry (void* a_class, void* a_feature);

CFStringRef call_txnaction_key_mapper_proc_ptr (void *a_function, TXNActionKey actionKey, UInt32 commandID);


#include <Carbon/Carbon.h>

typedef OSStatus (*hmcontrol_content_proc_ptr_eiffel_feature) (void *a_class, ControlRef inControl, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);

void* get_hmcontrol_content_proc_ptr_stub ();

struct hmcontrol_content_proc_ptr_entry_struct
{
	void* a_class;
	hmcontrol_content_proc_ptr_eiffel_feature feature;
};

void set_hmcontrol_content_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_hmcontrol_content_proc_ptr (void *a_function, ControlRef inControl, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);


#include <Carbon/Carbon.h>

typedef OSStatus (*hmwindow_content_proc_ptr_eiffel_feature) (void *a_class, WindowRef inWindow, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);

void* get_hmwindow_content_proc_ptr_stub ();

struct hmwindow_content_proc_ptr_entry_struct
{
	void* a_class;
	hmwindow_content_proc_ptr_eiffel_feature feature;
};

void set_hmwindow_content_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_hmwindow_content_proc_ptr (void *a_function, WindowRef inWindow, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);


#include <Carbon/Carbon.h>

typedef OSStatus (*hmmenu_title_content_proc_ptr_eiffel_feature) (void *a_class, MenuRef inMenu, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);

void* get_hmmenu_title_content_proc_ptr_stub ();

struct hmmenu_title_content_proc_ptr_entry_struct
{
	void* a_class;
	hmmenu_title_content_proc_ptr_eiffel_feature feature;
};

void set_hmmenu_title_content_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_hmmenu_title_content_proc_ptr (void *a_function, MenuRef inMenu, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);


#include <Carbon/Carbon.h>

typedef OSStatus (*hmmenu_item_content_proc_ptr_eiffel_feature) (void *a_class, MenuTrackingData const *inTrackingData, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);

void* get_hmmenu_item_content_proc_ptr_stub ();

struct hmmenu_item_content_proc_ptr_entry_struct
{
	void* a_class;
	hmmenu_item_content_proc_ptr_eiffel_feature feature;
};

void set_hmmenu_item_content_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_hmmenu_item_content_proc_ptr (void *a_function, MenuTrackingData const *inTrackingData, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);


#include <Carbon/Carbon.h>

typedef void (*control_user_pane_draw_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, SInt16 part);

void* get_control_user_pane_draw_proc_ptr_stub ();

struct control_user_pane_draw_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_draw_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_draw_proc_ptr_entry (void* a_class, void* a_feature);

void call_control_user_pane_draw_proc_ptr (void *a_function, ControlRef control, SInt16 part);


#include <Carbon/Carbon.h>

typedef ControlPartCode (*control_user_pane_hit_test_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, Point where);

void* get_control_user_pane_hit_test_proc_ptr_stub ();

struct control_user_pane_hit_test_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_hit_test_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_hit_test_proc_ptr_entry (void* a_class, void* a_feature);

ControlPartCode call_control_user_pane_hit_test_proc_ptr (void *a_function, ControlRef control, Point where);


#include <Carbon/Carbon.h>

typedef ControlPartCode (*control_user_pane_tracking_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, Point startPt, ControlActionUPP actionProc);

void* get_control_user_pane_tracking_proc_ptr_stub ();

struct control_user_pane_tracking_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_tracking_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_tracking_proc_ptr_entry (void* a_class, void* a_feature);

ControlPartCode call_control_user_pane_tracking_proc_ptr (void *a_function, ControlRef control, Point startPt, ControlActionUPP actionProc);


#include <Carbon/Carbon.h>

typedef void (*control_user_pane_idle_proc_ptr_eiffel_feature) (void *a_class, ControlRef control);

void* get_control_user_pane_idle_proc_ptr_stub ();

struct control_user_pane_idle_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_idle_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_idle_proc_ptr_entry (void* a_class, void* a_feature);

void call_control_user_pane_idle_proc_ptr (void *a_function, ControlRef control);


#include <Carbon/Carbon.h>

typedef ControlPartCode (*control_user_pane_key_down_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, SInt16 keyCode, SInt16 charCode, SInt16 modifiers);

void* get_control_user_pane_key_down_proc_ptr_stub ();

struct control_user_pane_key_down_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_key_down_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_key_down_proc_ptr_entry (void* a_class, void* a_feature);

ControlPartCode call_control_user_pane_key_down_proc_ptr (void *a_function, ControlRef control, SInt16 keyCode, SInt16 charCode, SInt16 modifiers);


#include <Carbon/Carbon.h>

typedef void (*control_user_pane_activate_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, Boolean activating);

void* get_control_user_pane_activate_proc_ptr_stub ();

struct control_user_pane_activate_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_activate_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_activate_proc_ptr_entry (void* a_class, void* a_feature);

void call_control_user_pane_activate_proc_ptr (void *a_function, ControlRef control, Boolean activating);


#include <Carbon/Carbon.h>

typedef ControlPartCode (*control_user_pane_focus_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, ControlFocusPart action);

void* get_control_user_pane_focus_proc_ptr_stub ();

struct control_user_pane_focus_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_focus_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_focus_proc_ptr_entry (void* a_class, void* a_feature);

ControlPartCode call_control_user_pane_focus_proc_ptr (void *a_function, ControlRef control, ControlFocusPart action);


#include <Carbon/Carbon.h>

typedef void (*control_user_pane_background_proc_ptr_eiffel_feature) (void *a_class, ControlRef control, ControlBackgroundPtr info);

void* get_control_user_pane_background_proc_ptr_stub ();

struct control_user_pane_background_proc_ptr_entry_struct
{
	void* a_class;
	control_user_pane_background_proc_ptr_eiffel_feature feature;
};

void set_control_user_pane_background_proc_ptr_entry (void* a_class, void* a_feature);

void call_control_user_pane_background_proc_ptr (void *a_function, ControlRef control, ControlBackgroundPtr info);


#include <Carbon/Carbon.h>

typedef void (*data_browser_item_proc_ptr_eiffel_feature) (void *a_class, DataBrowserItemID item, DataBrowserItemState state, void *clientData);

void* get_data_browser_item_proc_ptr_stub ();

struct data_browser_item_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_item_proc_ptr (void *a_function, DataBrowserItemID item, DataBrowserItemState state, void *clientData);


#include <Carbon/Carbon.h>

typedef OSStatus (*data_browser_item_data_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemDataRef itemData, Boolean setValue);

void* get_data_browser_item_data_proc_ptr_stub ();

struct data_browser_item_data_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_data_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_data_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_data_browser_item_data_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemDataRef itemData, Boolean setValue);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_item_compare_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemOne, DataBrowserItemID itemTwo, DataBrowserPropertyID sortProperty);

void* get_data_browser_item_compare_proc_ptr_stub ();

struct data_browser_item_compare_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_compare_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_compare_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_item_compare_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemOne, DataBrowserItemID itemTwo, DataBrowserPropertyID sortProperty);


#include <Carbon/Carbon.h>

typedef void (*data_browser_item_notification_with_item_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message, DataBrowserItemDataRef itemData);

void* get_data_browser_item_notification_with_item_proc_ptr_stub ();

struct data_browser_item_notification_with_item_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_notification_with_item_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_notification_with_item_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_item_notification_with_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message, DataBrowserItemDataRef itemData);


#include <Carbon/Carbon.h>

typedef void (*data_browser_item_notification_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message);

void* get_data_browser_item_notification_proc_ptr_stub ();

struct data_browser_item_notification_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_notification_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_notification_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_item_notification_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_add_drag_item_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DragReference theDrag, DataBrowserItemID item, ItemReference *itemRef);

void* get_data_browser_add_drag_item_proc_ptr_stub ();

struct data_browser_add_drag_item_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_add_drag_item_proc_ptr_eiffel_feature feature;
};

void set_data_browser_add_drag_item_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_add_drag_item_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, DataBrowserItemID item, ItemReference *itemRef);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_accept_drag_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DragReference theDrag, DataBrowserItemID item);

void* get_data_browser_accept_drag_proc_ptr_stub ();

struct data_browser_accept_drag_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_accept_drag_proc_ptr_eiffel_feature feature;
};

void set_data_browser_accept_drag_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_accept_drag_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, DataBrowserItemID item);


#include <Carbon/Carbon.h>

typedef void (*data_browser_post_process_drag_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DragReference theDrag, OSStatus trackDragResult);

void* get_data_browser_post_process_drag_proc_ptr_stub ();

struct data_browser_post_process_drag_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_post_process_drag_proc_ptr_eiffel_feature feature;
};

void set_data_browser_post_process_drag_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_post_process_drag_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, OSStatus trackDragResult);


#include <Carbon/Carbon.h>

typedef void (*data_browser_get_contextual_menu_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, MenuRef *menu, UInt32 *helpType, CFStringRef *helpItemString, AEDesc *selection);

void* get_data_browser_get_contextual_menu_proc_ptr_stub ();

struct data_browser_get_contextual_menu_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_get_contextual_menu_proc_ptr_eiffel_feature feature;
};

void set_data_browser_get_contextual_menu_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_get_contextual_menu_proc_ptr (void *a_function, ControlRef browser, MenuRef *menu, UInt32 *helpType, CFStringRef *helpItemString, AEDesc *selection);


#include <Carbon/Carbon.h>

typedef void (*data_browser_select_contextual_menu_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, MenuRef menu, UInt32 selectionType, SInt16 menuID, MenuItemIndex menuItem);

void* get_data_browser_select_contextual_menu_proc_ptr_stub ();

struct data_browser_select_contextual_menu_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_select_contextual_menu_proc_ptr_eiffel_feature feature;
};

void set_data_browser_select_contextual_menu_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_select_contextual_menu_proc_ptr (void *a_function, ControlRef browser, MenuRef menu, UInt32 selectionType, SInt16 menuID, MenuItemIndex menuItem);


#include <Carbon/Carbon.h>

typedef void (*data_browser_item_help_content_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);

void* get_data_browser_item_help_content_proc_ptr_stub ();

struct data_browser_item_help_content_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_help_content_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_help_content_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_item_help_content_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent);


#include <Carbon/Carbon.h>

typedef void (*data_browser_draw_item_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemState itemState, Rect const *theRect, SInt16 gdDepth, Boolean colorDevice);

void* get_data_browser_draw_item_proc_ptr_stub ();

struct data_browser_draw_item_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_draw_item_proc_ptr_eiffel_feature feature;
};

void set_data_browser_draw_item_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_draw_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemState itemState, Rect const *theRect, SInt16 gdDepth, Boolean colorDevice);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_edit_item_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, CFStringRef theString, Rect *maxEditTextRect, Boolean *shrinkToFit);

void* get_data_browser_edit_item_proc_ptr_stub ();

struct data_browser_edit_item_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_edit_item_proc_ptr_eiffel_feature feature;
};

void set_data_browser_edit_item_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_edit_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, CFStringRef theString, Rect *maxEditTextRect, Boolean *shrinkToFit);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_hit_test_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Rect const *mouseRect);

void* get_data_browser_hit_test_proc_ptr_stub ();

struct data_browser_hit_test_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_hit_test_proc_ptr_eiffel_feature feature;
};

void set_data_browser_hit_test_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_hit_test_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Rect const *mouseRect);


#include <Carbon/Carbon.h>

typedef DataBrowserTrackingResult (*data_browser_tracking_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Point startPt, EventModifiers modifiers);

void* get_data_browser_tracking_proc_ptr_stub ();

struct data_browser_tracking_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_tracking_proc_ptr_eiffel_feature feature;
};

void set_data_browser_tracking_proc_ptr_entry (void* a_class, void* a_feature);

DataBrowserTrackingResult call_data_browser_tracking_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Point startPt, EventModifiers modifiers);


#include <Carbon/Carbon.h>

typedef void (*data_browser_item_drag_rgn_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, RgnHandle dragRgn);

void* get_data_browser_item_drag_rgn_proc_ptr_stub ();

struct data_browser_item_drag_rgn_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_drag_rgn_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_drag_rgn_proc_ptr_entry (void* a_class, void* a_feature);

void call_data_browser_item_drag_rgn_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, RgnHandle dragRgn);


#include <Carbon/Carbon.h>

typedef DataBrowserDragFlags (*data_browser_item_accept_drag_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, DragReference theDrag);

void* get_data_browser_item_accept_drag_proc_ptr_stub ();

struct data_browser_item_accept_drag_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_accept_drag_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_accept_drag_proc_ptr_entry (void* a_class, void* a_feature);

DataBrowserDragFlags call_data_browser_item_accept_drag_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, DragReference theDrag);


#include <Carbon/Carbon.h>

typedef Boolean (*data_browser_item_receive_drag_proc_ptr_eiffel_feature) (void *a_class, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, DataBrowserDragFlags dragFlags, DragReference theDrag);

void* get_data_browser_item_receive_drag_proc_ptr_stub ();

struct data_browser_item_receive_drag_proc_ptr_entry_struct
{
	void* a_class;
	data_browser_item_receive_drag_proc_ptr_eiffel_feature feature;
};

void set_data_browser_item_receive_drag_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_data_browser_item_receive_drag_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, DataBrowserDragFlags dragFlags, DragReference theDrag);


#include <Carbon/Carbon.h>

typedef Boolean (*edit_unicode_post_update_proc_ptr_eiffel_feature) (void *a_class, UniCharArrayHandle uniText, UniCharCount uniTextLength, UniCharArrayOffset iStartOffset, UniCharArrayOffset iEndOffset, void *refcon);

void* get_edit_unicode_post_update_proc_ptr_stub ();

struct edit_unicode_post_update_proc_ptr_entry_struct
{
	void* a_class;
	edit_unicode_post_update_proc_ptr_eiffel_feature feature;
};

void set_edit_unicode_post_update_proc_ptr_entry (void* a_class, void* a_feature);

Boolean call_edit_unicode_post_update_proc_ptr (void *a_function, UniCharArrayHandle uniText, UniCharCount uniTextLength, UniCharArrayOffset iStartOffset, UniCharArrayOffset iEndOffset, void *refcon);


#include <Carbon/Carbon.h>

typedef CFComparisonResult (*cfcomparator_function_eiffel_feature) (void *a_class, void const *val1, void const *val2, void *context);

void* get_cfcomparator_function_stub ();

struct cfcomparator_function_entry_struct
{
	void* a_class;
	cfcomparator_function_eiffel_feature feature;
};

void set_cfcomparator_function_entry (void* a_class, void* a_feature);

CFComparisonResult call_cfcomparator_function (void *a_function, void const *val1, void const *val2, void *context);


#include <Carbon/Carbon.h>

typedef void const *(*cfallocator_retain_call_back_eiffel_feature) (void *a_class, void const *info);

void* get_cfallocator_retain_call_back_stub ();

struct cfallocator_retain_call_back_entry_struct
{
	void* a_class;
	cfallocator_retain_call_back_eiffel_feature feature;
};

void set_cfallocator_retain_call_back_entry (void* a_class, void* a_feature);

void const *call_cfallocator_retain_call_back (void *a_function, void const *info);


#include <Carbon/Carbon.h>

typedef void (*cfallocator_release_call_back_eiffel_feature) (void *a_class, void const *info);

void* get_cfallocator_release_call_back_stub ();

struct cfallocator_release_call_back_entry_struct
{
	void* a_class;
	cfallocator_release_call_back_eiffel_feature feature;
};

void set_cfallocator_release_call_back_entry (void* a_class, void* a_feature);

void call_cfallocator_release_call_back (void *a_function, void const *info);


#include <Carbon/Carbon.h>

typedef CFStringRef (*cfallocator_copy_description_call_back_eiffel_feature) (void *a_class, void const *info);

void* get_cfallocator_copy_description_call_back_stub ();

struct cfallocator_copy_description_call_back_entry_struct
{
	void* a_class;
	cfallocator_copy_description_call_back_eiffel_feature feature;
};

void set_cfallocator_copy_description_call_back_entry (void* a_class, void* a_feature);

CFStringRef call_cfallocator_copy_description_call_back (void *a_function, void const *info);


#include <Carbon/Carbon.h>

typedef void *(*cfallocator_allocate_call_back_eiffel_feature) (void *a_class, CFIndex allocSize, CFOptionFlags hint, void *info);

void* get_cfallocator_allocate_call_back_stub ();

struct cfallocator_allocate_call_back_entry_struct
{
	void* a_class;
	cfallocator_allocate_call_back_eiffel_feature feature;
};

void set_cfallocator_allocate_call_back_entry (void* a_class, void* a_feature);

void *call_cfallocator_allocate_call_back (void *a_function, CFIndex allocSize, CFOptionFlags hint, void *info);


#include <Carbon/Carbon.h>

typedef void *(*cfallocator_reallocate_call_back_eiffel_feature) (void *a_class, void *ptr, CFIndex newsize, CFOptionFlags hint, void *info);

void* get_cfallocator_reallocate_call_back_stub ();

struct cfallocator_reallocate_call_back_entry_struct
{
	void* a_class;
	cfallocator_reallocate_call_back_eiffel_feature feature;
};

void set_cfallocator_reallocate_call_back_entry (void* a_class, void* a_feature);

void *call_cfallocator_reallocate_call_back (void *a_function, void *ptr, CFIndex newsize, CFOptionFlags hint, void *info);


#include <Carbon/Carbon.h>

typedef void (*cfallocator_deallocate_call_back_eiffel_feature) (void *a_class, void *ptr, void *info);

void* get_cfallocator_deallocate_call_back_stub ();

struct cfallocator_deallocate_call_back_entry_struct
{
	void* a_class;
	cfallocator_deallocate_call_back_eiffel_feature feature;
};

void set_cfallocator_deallocate_call_back_entry (void* a_class, void* a_feature);

void call_cfallocator_deallocate_call_back (void *a_function, void *ptr, void *info);


#include <Carbon/Carbon.h>

typedef CFIndex (*cfallocator_preferred_size_call_back_eiffel_feature) (void *a_class, CFIndex size, CFOptionFlags hint, void *info);

void* get_cfallocator_preferred_size_call_back_stub ();

struct cfallocator_preferred_size_call_back_entry_struct
{
	void* a_class;
	cfallocator_preferred_size_call_back_eiffel_feature feature;
};

void set_cfallocator_preferred_size_call_back_entry (void* a_class, void* a_feature);

CFIndex call_cfallocator_preferred_size_call_back (void *a_function, CFIndex size, CFOptionFlags hint, void *info);


#include <Carbon/Carbon.h>

typedef size_t (*cgdata_provider_get_bytes_callback_eiffel_feature) (void *a_class, void *info, void *buffer, size_t count);

void* get_cgdata_provider_get_bytes_callback_stub ();

struct cgdata_provider_get_bytes_callback_entry_struct
{
	void* a_class;
	cgdata_provider_get_bytes_callback_eiffel_feature feature;
};

void set_cgdata_provider_get_bytes_callback_entry (void* a_class, void* a_feature);

size_t call_cgdata_provider_get_bytes_callback (void *a_function, void *info, void *buffer, size_t count);


#include <Carbon/Carbon.h>

typedef void (*cgdata_provider_skip_bytes_callback_eiffel_feature) (void *a_class, void *info, size_t count);

void* get_cgdata_provider_skip_bytes_callback_stub ();

struct cgdata_provider_skip_bytes_callback_entry_struct
{
	void* a_class;
	cgdata_provider_skip_bytes_callback_eiffel_feature feature;
};

void set_cgdata_provider_skip_bytes_callback_entry (void* a_class, void* a_feature);

void call_cgdata_provider_skip_bytes_callback (void *a_function, void *info, size_t count);


#include <Carbon/Carbon.h>

typedef void (*wsclient_context_release_call_back_proc_ptr_eiffel_feature) (void *a_class, void *info);

void* get_wsclient_context_release_call_back_proc_ptr_stub ();

struct wsclient_context_release_call_back_proc_ptr_entry_struct
{
	void* a_class;
	wsclient_context_release_call_back_proc_ptr_eiffel_feature feature;
};

void set_wsclient_context_release_call_back_proc_ptr_entry (void* a_class, void* a_feature);

void call_wsclient_context_release_call_back_proc_ptr (void *a_function, void *info);


#include <Carbon/Carbon.h>

typedef void const *(*cgdata_provider_get_byte_pointer_callback_eiffel_feature) (void *a_class, void *info);

void* get_cgdata_provider_get_byte_pointer_callback_stub ();

struct cgdata_provider_get_byte_pointer_callback_entry_struct
{
	void* a_class;
	cgdata_provider_get_byte_pointer_callback_eiffel_feature feature;
};

void set_cgdata_provider_get_byte_pointer_callback_entry (void* a_class, void* a_feature);

void const *call_cgdata_provider_get_byte_pointer_callback (void *a_function, void *info);


#include <Carbon/Carbon.h>

typedef void (*cgdata_provider_release_byte_pointer_callback_eiffel_feature) (void *a_class, void *info, void const *pointer);

void* get_cgdata_provider_release_byte_pointer_callback_stub ();

struct cgdata_provider_release_byte_pointer_callback_entry_struct
{
	void* a_class;
	cgdata_provider_release_byte_pointer_callback_eiffel_feature feature;
};

void set_cgdata_provider_release_byte_pointer_callback_entry (void* a_class, void* a_feature);

void call_cgdata_provider_release_byte_pointer_callback (void *a_function, void *info, void const *pointer);


#include <Carbon/Carbon.h>

typedef size_t (*cgdata_provider_get_bytes_at_offset_callback_eiffel_feature) (void *a_class, void *info, void *buffer, size_t offset, size_t count);

void* get_cgdata_provider_get_bytes_at_offset_callback_stub ();

struct cgdata_provider_get_bytes_at_offset_callback_entry_struct
{
	void* a_class;
	cgdata_provider_get_bytes_at_offset_callback_eiffel_feature feature;
};

void set_cgdata_provider_get_bytes_at_offset_callback_entry (void* a_class, void* a_feature);

size_t call_cgdata_provider_get_bytes_at_offset_callback (void *a_function, void *info, void *buffer, size_t offset, size_t count);


#include <Carbon/Carbon.h>

typedef OSStatus (*qdprinter_status_proc_ptr_eiffel_feature) (void *a_class, PrinterStatusOpcode opcode, CGrafPtr currentPort, void *printerStatus);

void* get_qdprinter_status_proc_ptr_stub ();

struct qdprinter_status_proc_ptr_entry_struct
{
	void* a_class;
	qdprinter_status_proc_ptr_eiffel_feature feature;
};

void set_qdprinter_status_proc_ptr_entry (void* a_class, void* a_feature);

OSStatus call_qdprinter_status_proc_ptr (void *a_function, PrinterStatusOpcode opcode, CGrafPtr currentPort, void *printerStatus);


#include <Carbon/Carbon.h>

typedef void (*get_next_event_filter_proc_ptr_eiffel_feature) (void *a_class, EventRecord *theEvent, Boolean *result);

void* get_get_next_event_filter_proc_ptr_stub ();

struct get_next_event_filter_proc_ptr_entry_struct
{
	void* a_class;
	get_next_event_filter_proc_ptr_eiffel_feature feature;
};

void set_get_next_event_filter_proc_ptr_entry (void* a_class, void* a_feature);

void call_get_next_event_filter_proc_ptr (void *a_function, EventRecord *theEvent, Boolean *result);


#include <Carbon/Carbon.h>

typedef long (*menu_bar_def_proc_ptr_eiffel_feature) (void *a_class, short selector, short message, short parameter1, long parameter2);

void* get_menu_bar_def_proc_ptr_stub ();

struct menu_bar_def_proc_ptr_entry_struct
{
	void* a_class;
	menu_bar_def_proc_ptr_eiffel_feature feature;
};

void set_menu_bar_def_proc_ptr_entry (void* a_class, void* a_feature);

long call_menu_bar_def_proc_ptr (void *a_function, short selector, short message, short parameter1, long parameter2);


#include <Carbon/Carbon.h>

typedef short (*mbar_hook_proc_ptr_eiffel_feature) (void *a_class, Rect *menuRect);

void* get_mbar_hook_proc_ptr_stub ();

struct mbar_hook_proc_ptr_entry_struct
{
	void* a_class;
	mbar_hook_proc_ptr_eiffel_feature feature;
};

void set_mbar_hook_proc_ptr_entry (void* a_class, void* a_feature);

short call_mbar_hook_proc_ptr (void *a_function, Rect *menuRect);


#include <Carbon/Carbon.h>

typedef SInt32 (*sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_eiffel_feature) (void *a_class, void *thisPointer, CFUUIDBytes iid, void **ppv);

void* get_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_stub ();

struct sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry_struct
{
	void* a_class;
	sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_eiffel_feature feature;
};

void set_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry (void* a_class, void* a_feature);

SInt32 call_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback (void *a_function, void *thisPointer, CFUUIDBytes iid, void **ppv);


#include <Carbon/Carbon.h>

typedef UInt32 (*uint32_voidp_anonymous_callback_eiffel_feature) (void *a_class, void *thisPointer);

void* get_uint32_voidp_anonymous_callback_stub ();

struct uint32_voidp_anonymous_callback_entry_struct
{
	void* a_class;
	uint32_voidp_anonymous_callback_eiffel_feature feature;
};

void set_uint32_voidp_anonymous_callback_entry (void* a_class, void* a_feature);

UInt32 call_uint32_voidp_anonymous_callback (void *a_function, void *thisPointer);


#include <Carbon/Carbon.h>

typedef OSStatus (*osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_eiffel_feature) (void *a_class, void *thisInstance, AEDesc const *inContext, AEDescList *outCommandPairs);

void* get_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_stub ();

struct osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry_struct
{
	void* a_class;
	osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_eiffel_feature feature;
};

void set_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry (void* a_class, void* a_feature);

OSStatus call_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback (void *a_function, void *thisInstance, AEDesc const *inContext, AEDescList *outCommandPairs);


#include <Carbon/Carbon.h>

typedef OSStatus (*osstatus_voidp_aedescp_sint32_anonymous_callback_eiffel_feature) (void *a_class, void *thisInstance, AEDesc *inContext, SInt32 inCommandID);

void* get_osstatus_voidp_aedescp_sint32_anonymous_callback_stub ();

struct osstatus_voidp_aedescp_sint32_anonymous_callback_entry_struct
{
	void* a_class;
	osstatus_voidp_aedescp_sint32_anonymous_callback_eiffel_feature feature;
};

void set_osstatus_voidp_aedescp_sint32_anonymous_callback_entry (void* a_class, void* a_feature);

OSStatus call_osstatus_voidp_aedescp_sint32_anonymous_callback (void *a_function, void *thisInstance, AEDesc *inContext, SInt32 inCommandID);


#include <Carbon/Carbon.h>

typedef void (*void_voidp_anonymous_callback_eiffel_feature) (void *a_class, void *thisInstance);

void* get_void_voidp_anonymous_callback_stub ();

struct void_voidp_anonymous_callback_entry_struct
{
	void* a_class;
	void_voidp_anonymous_callback_eiffel_feature feature;
};

void set_void_voidp_anonymous_callback_entry (void* a_class, void* a_feature);

void call_void_voidp_anonymous_callback (void *a_function, void *thisInstance);


#include <Carbon/Carbon.h>

typedef void (*desk_hook_proc_ptr_eiffel_feature) (void *a_class, Boolean mouseClick, EventRecord *theEvent);

void* get_desk_hook_proc_ptr_stub ();

struct desk_hook_proc_ptr_entry_struct
{
	void* a_class;
	desk_hook_proc_ptr_eiffel_feature feature;
};

void set_desk_hook_proc_ptr_entry (void* a_class, void* a_feature);

void call_desk_hook_proc_ptr (void *a_function, Boolean mouseClick, EventRecord *theEvent);


#endif
