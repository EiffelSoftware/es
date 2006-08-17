#include <ewg_eiffel.h>
#include <ewg_carbon_callback_c_glue_code.h>

#ifdef _MSC_VER
#pragma warning (disable:4715) // Not all control paths return a value
#endif
struct cgdata_provider_release_data_callback_entry_struct cgdata_provider_release_data_callback_entry = {NULL, NULL};

void cgdata_provider_release_data_callback_stub (void *info, void const *data, size_t size)
{
	if (cgdata_provider_release_data_callback_entry.a_class != NULL && cgdata_provider_release_data_callback_entry.feature != NULL)
	{
		cgdata_provider_release_data_callback_entry.feature (eif_access(cgdata_provider_release_data_callback_entry.a_class), info, data, size);
	}
}

void set_cgdata_provider_release_data_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_release_data_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_release_data_callback_entry.feature = (cgdata_provider_release_data_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_release_data_callback_stub ()
{
	return (void*) cgdata_provider_release_data_callback_stub;
}

void call_cgdata_provider_release_data_callback (void *a_function, void *info, void const *data, size_t size)
{
	((void (*) (void *info, void const *data, size_t size))a_function) (info, data, size);
}

struct aeremote_process_resolver_callback_entry_struct aeremote_process_resolver_callback_entry = {NULL, NULL};

void aeremote_process_resolver_callback_stub (AERemoteProcessResolverRef ref, void *info)
{
	if (aeremote_process_resolver_callback_entry.a_class != NULL && aeremote_process_resolver_callback_entry.feature != NULL)
	{
		aeremote_process_resolver_callback_entry.feature (eif_access(aeremote_process_resolver_callback_entry.a_class), ref, info);
	}
}

void set_aeremote_process_resolver_callback_entry (void* a_class, void* a_feature)
{
	aeremote_process_resolver_callback_entry.a_class = eif_adopt(a_class);
	aeremote_process_resolver_callback_entry.feature = (aeremote_process_resolver_callback_eiffel_feature) a_feature;
}

void* get_aeremote_process_resolver_callback_stub ()
{
	return (void*) aeremote_process_resolver_callback_stub;
}

void call_aeremote_process_resolver_callback (void *a_function, AERemoteProcessResolverRef ref, void *info)
{
	((void (*) (AERemoteProcessResolverRef ref, void *info))a_function) (ref, info);
}

struct qdtext_proc_ptr_entry_struct qdtext_proc_ptr_entry = {NULL, NULL};

void qdtext_proc_ptr_stub (short byteCount, void const *textBuf, Point numer, Point denom)
{
	if (qdtext_proc_ptr_entry.a_class != NULL && qdtext_proc_ptr_entry.feature != NULL)
	{
		qdtext_proc_ptr_entry.feature (eif_access(qdtext_proc_ptr_entry.a_class), byteCount, textBuf, numer, denom);
	}
}

void set_qdtext_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdtext_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdtext_proc_ptr_entry.feature = (qdtext_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdtext_proc_ptr_stub ()
{
	return (void*) qdtext_proc_ptr_stub;
}

void call_qdtext_proc_ptr (void *a_function, short byteCount, void const *textBuf, Point numer, Point denom)
{
	((void (*) (short byteCount, void const *textBuf, Point numer, Point denom))a_function) (byteCount, textBuf, numer, denom);
}

struct qdline_proc_ptr_entry_struct qdline_proc_ptr_entry = {NULL, NULL};

void qdline_proc_ptr_stub (Point newPt)
{
	if (qdline_proc_ptr_entry.a_class != NULL && qdline_proc_ptr_entry.feature != NULL)
	{
		qdline_proc_ptr_entry.feature (eif_access(qdline_proc_ptr_entry.a_class), newPt);
	}
}

void set_qdline_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdline_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdline_proc_ptr_entry.feature = (qdline_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdline_proc_ptr_stub ()
{
	return (void*) qdline_proc_ptr_stub;
}

void call_qdline_proc_ptr (void *a_function, Point newPt)
{
	((void (*) (Point newPt))a_function) (newPt);
}

struct qdrect_proc_ptr_entry_struct qdrect_proc_ptr_entry = {NULL, NULL};

void qdrect_proc_ptr_stub (GrafVerb verb, Rect const *r)
{
	if (qdrect_proc_ptr_entry.a_class != NULL && qdrect_proc_ptr_entry.feature != NULL)
	{
		qdrect_proc_ptr_entry.feature (eif_access(qdrect_proc_ptr_entry.a_class), verb, r);
	}
}

void set_qdrect_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdrect_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdrect_proc_ptr_entry.feature = (qdrect_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdrect_proc_ptr_stub ()
{
	return (void*) qdrect_proc_ptr_stub;
}

void call_qdrect_proc_ptr (void *a_function, GrafVerb verb, Rect const *r)
{
	((void (*) (GrafVerb verb, Rect const *r))a_function) (verb, r);
}

struct qdrrect_proc_ptr_entry_struct qdrrect_proc_ptr_entry = {NULL, NULL};

void qdrrect_proc_ptr_stub (GrafVerb verb, Rect const *r, short ovalWidth, short ovalHeight)
{
	if (qdrrect_proc_ptr_entry.a_class != NULL && qdrrect_proc_ptr_entry.feature != NULL)
	{
		qdrrect_proc_ptr_entry.feature (eif_access(qdrrect_proc_ptr_entry.a_class), verb, r, ovalWidth, ovalHeight);
	}
}

void set_qdrrect_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdrrect_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdrrect_proc_ptr_entry.feature = (qdrrect_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdrrect_proc_ptr_stub ()
{
	return (void*) qdrrect_proc_ptr_stub;
}

void call_qdrrect_proc_ptr (void *a_function, GrafVerb verb, Rect const *r, short ovalWidth, short ovalHeight)
{
	((void (*) (GrafVerb verb, Rect const *r, short ovalWidth, short ovalHeight))a_function) (verb, r, ovalWidth, ovalHeight);
}

struct qdarc_proc_ptr_entry_struct qdarc_proc_ptr_entry = {NULL, NULL};

void qdarc_proc_ptr_stub (GrafVerb verb, Rect const *r, short startAngle, short arcAngle)
{
	if (qdarc_proc_ptr_entry.a_class != NULL && qdarc_proc_ptr_entry.feature != NULL)
	{
		qdarc_proc_ptr_entry.feature (eif_access(qdarc_proc_ptr_entry.a_class), verb, r, startAngle, arcAngle);
	}
}

void set_qdarc_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdarc_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdarc_proc_ptr_entry.feature = (qdarc_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdarc_proc_ptr_stub ()
{
	return (void*) qdarc_proc_ptr_stub;
}

void call_qdarc_proc_ptr (void *a_function, GrafVerb verb, Rect const *r, short startAngle, short arcAngle)
{
	((void (*) (GrafVerb verb, Rect const *r, short startAngle, short arcAngle))a_function) (verb, r, startAngle, arcAngle);
}

struct qdpoly_proc_ptr_entry_struct qdpoly_proc_ptr_entry = {NULL, NULL};

void qdpoly_proc_ptr_stub (GrafVerb verb, PolyHandle poly)
{
	if (qdpoly_proc_ptr_entry.a_class != NULL && qdpoly_proc_ptr_entry.feature != NULL)
	{
		qdpoly_proc_ptr_entry.feature (eif_access(qdpoly_proc_ptr_entry.a_class), verb, poly);
	}
}

void set_qdpoly_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdpoly_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdpoly_proc_ptr_entry.feature = (qdpoly_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdpoly_proc_ptr_stub ()
{
	return (void*) qdpoly_proc_ptr_stub;
}

void call_qdpoly_proc_ptr (void *a_function, GrafVerb verb, PolyHandle poly)
{
	((void (*) (GrafVerb verb, PolyHandle poly))a_function) (verb, poly);
}

struct qdrgn_proc_ptr_entry_struct qdrgn_proc_ptr_entry = {NULL, NULL};

void qdrgn_proc_ptr_stub (GrafVerb verb, RgnHandle rgn)
{
	if (qdrgn_proc_ptr_entry.a_class != NULL && qdrgn_proc_ptr_entry.feature != NULL)
	{
		qdrgn_proc_ptr_entry.feature (eif_access(qdrgn_proc_ptr_entry.a_class), verb, rgn);
	}
}

void set_qdrgn_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdrgn_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdrgn_proc_ptr_entry.feature = (qdrgn_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdrgn_proc_ptr_stub ()
{
	return (void*) qdrgn_proc_ptr_stub;
}

void call_qdrgn_proc_ptr (void *a_function, GrafVerb verb, RgnHandle rgn)
{
	((void (*) (GrafVerb verb, RgnHandle rgn))a_function) (verb, rgn);
}

struct qdbits_proc_ptr_entry_struct qdbits_proc_ptr_entry = {NULL, NULL};

void qdbits_proc_ptr_stub (BitMap const *srcBits, Rect const *srcRect, Rect const *dstRect, short mode, RgnHandle maskRgn)
{
	if (qdbits_proc_ptr_entry.a_class != NULL && qdbits_proc_ptr_entry.feature != NULL)
	{
		qdbits_proc_ptr_entry.feature (eif_access(qdbits_proc_ptr_entry.a_class), srcBits, srcRect, dstRect, mode, maskRgn);
	}
}

void set_qdbits_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdbits_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdbits_proc_ptr_entry.feature = (qdbits_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdbits_proc_ptr_stub ()
{
	return (void*) qdbits_proc_ptr_stub;
}

void call_qdbits_proc_ptr (void *a_function, BitMap const *srcBits, Rect const *srcRect, Rect const *dstRect, short mode, RgnHandle maskRgn)
{
	((void (*) (BitMap const *srcBits, Rect const *srcRect, Rect const *dstRect, short mode, RgnHandle maskRgn))a_function) (srcBits, srcRect, dstRect, mode, maskRgn);
}

struct qdcomment_proc_ptr_entry_struct qdcomment_proc_ptr_entry = {NULL, NULL};

void qdcomment_proc_ptr_stub (short kind, short dataSize, Handle dataHandle)
{
	if (qdcomment_proc_ptr_entry.a_class != NULL && qdcomment_proc_ptr_entry.feature != NULL)
	{
		qdcomment_proc_ptr_entry.feature (eif_access(qdcomment_proc_ptr_entry.a_class), kind, dataSize, dataHandle);
	}
}

void set_qdcomment_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdcomment_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdcomment_proc_ptr_entry.feature = (qdcomment_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdcomment_proc_ptr_stub ()
{
	return (void*) qdcomment_proc_ptr_stub;
}

void call_qdcomment_proc_ptr (void *a_function, short kind, short dataSize, Handle dataHandle)
{
	((void (*) (short kind, short dataSize, Handle dataHandle))a_function) (kind, dataSize, dataHandle);
}

struct qdtx_meas_proc_ptr_entry_struct qdtx_meas_proc_ptr_entry = {NULL, NULL};

short qdtx_meas_proc_ptr_stub (short byteCount, void const *textAddr, Point *numer, Point *denom, FontInfo *info)
{
	if (qdtx_meas_proc_ptr_entry.a_class != NULL && qdtx_meas_proc_ptr_entry.feature != NULL)
	{
		return qdtx_meas_proc_ptr_entry.feature (eif_access(qdtx_meas_proc_ptr_entry.a_class), byteCount, textAddr, numer, denom, info);
	}
}

void set_qdtx_meas_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdtx_meas_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdtx_meas_proc_ptr_entry.feature = (qdtx_meas_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdtx_meas_proc_ptr_stub ()
{
	return (void*) qdtx_meas_proc_ptr_stub;
}

short call_qdtx_meas_proc_ptr (void *a_function, short byteCount, void const *textAddr, Point *numer, Point *denom, FontInfo *info)
{
	return ((short (*) (short byteCount, void const *textAddr, Point *numer, Point *denom, FontInfo *info))a_function) (byteCount, textAddr, numer, denom, info);
}

struct qdget_pic_proc_ptr_entry_struct qdget_pic_proc_ptr_entry = {NULL, NULL};

void qdget_pic_proc_ptr_stub (void *dataPtr, short byteCount)
{
	if (qdget_pic_proc_ptr_entry.a_class != NULL && qdget_pic_proc_ptr_entry.feature != NULL)
	{
		qdget_pic_proc_ptr_entry.feature (eif_access(qdget_pic_proc_ptr_entry.a_class), dataPtr, byteCount);
	}
}

void set_qdget_pic_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdget_pic_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdget_pic_proc_ptr_entry.feature = (qdget_pic_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdget_pic_proc_ptr_stub ()
{
	return (void*) qdget_pic_proc_ptr_stub;
}

void call_qdget_pic_proc_ptr (void *a_function, void *dataPtr, short byteCount)
{
	((void (*) (void *dataPtr, short byteCount))a_function) (dataPtr, byteCount);
}

struct qdput_pic_proc_ptr_entry_struct qdput_pic_proc_ptr_entry = {NULL, NULL};

void qdput_pic_proc_ptr_stub (void const *dataPtr, short byteCount)
{
	if (qdput_pic_proc_ptr_entry.a_class != NULL && qdput_pic_proc_ptr_entry.feature != NULL)
	{
		qdput_pic_proc_ptr_entry.feature (eif_access(qdput_pic_proc_ptr_entry.a_class), dataPtr, byteCount);
	}
}

void set_qdput_pic_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdput_pic_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdput_pic_proc_ptr_entry.feature = (qdput_pic_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdput_pic_proc_ptr_stub ()
{
	return (void*) qdput_pic_proc_ptr_stub;
}

void call_qdput_pic_proc_ptr (void *a_function, void const *dataPtr, short byteCount)
{
	((void (*) (void const *dataPtr, short byteCount))a_function) (dataPtr, byteCount);
}

struct qdopcode_proc_ptr_entry_struct qdopcode_proc_ptr_entry = {NULL, NULL};

void qdopcode_proc_ptr_stub (Rect const *fromRect, Rect const *toRect, UInt16 opcode, SInt16 version)
{
	if (qdopcode_proc_ptr_entry.a_class != NULL && qdopcode_proc_ptr_entry.feature != NULL)
	{
		qdopcode_proc_ptr_entry.feature (eif_access(qdopcode_proc_ptr_entry.a_class), fromRect, toRect, opcode, version);
	}
}

void set_qdopcode_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdopcode_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdopcode_proc_ptr_entry.feature = (qdopcode_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdopcode_proc_ptr_stub ()
{
	return (void*) qdopcode_proc_ptr_stub;
}

void call_qdopcode_proc_ptr (void *a_function, Rect const *fromRect, Rect const *toRect, UInt16 opcode, SInt16 version)
{
	((void (*) (Rect const *fromRect, Rect const *toRect, UInt16 opcode, SInt16 version))a_function) (fromRect, toRect, opcode, version);
}

struct qdstd_glyphs_proc_ptr_entry_struct qdstd_glyphs_proc_ptr_entry = {NULL, NULL};

OSStatus qdstd_glyphs_proc_ptr_stub (void *dataStream, ByteCount size)
{
	if (qdstd_glyphs_proc_ptr_entry.a_class != NULL && qdstd_glyphs_proc_ptr_entry.feature != NULL)
	{
		return qdstd_glyphs_proc_ptr_entry.feature (eif_access(qdstd_glyphs_proc_ptr_entry.a_class), dataStream, size);
	}
}

void set_qdstd_glyphs_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdstd_glyphs_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdstd_glyphs_proc_ptr_entry.feature = (qdstd_glyphs_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdstd_glyphs_proc_ptr_stub ()
{
	return (void*) qdstd_glyphs_proc_ptr_stub;
}

OSStatus call_qdstd_glyphs_proc_ptr (void *a_function, void *dataStream, ByteCount size)
{
	return ((OSStatus (*) (void *dataStream, ByteCount size))a_function) (dataStream, size);
}

struct qdjshield_cursor_proc_ptr_entry_struct qdjshield_cursor_proc_ptr_entry = {NULL, NULL};

void qdjshield_cursor_proc_ptr_stub (short left, short top, short right, short bottom)
{
	if (qdjshield_cursor_proc_ptr_entry.a_class != NULL && qdjshield_cursor_proc_ptr_entry.feature != NULL)
	{
		qdjshield_cursor_proc_ptr_entry.feature (eif_access(qdjshield_cursor_proc_ptr_entry.a_class), left, top, right, bottom);
	}
}

void set_qdjshield_cursor_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdjshield_cursor_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdjshield_cursor_proc_ptr_entry.feature = (qdjshield_cursor_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdjshield_cursor_proc_ptr_stub ()
{
	return (void*) qdjshield_cursor_proc_ptr_stub;
}

void call_qdjshield_cursor_proc_ptr (void *a_function, short left, short top, short right, short bottom)
{
	((void (*) (short left, short top, short right, short bottom))a_function) (left, top, right, bottom);
}

struct cfrag_term_procedure_entry_struct cfrag_term_procedure_entry = {NULL, NULL};

void cfrag_term_procedure_stub (void)
{
	if (cfrag_term_procedure_entry.a_class != NULL && cfrag_term_procedure_entry.feature != NULL)
	{
		cfrag_term_procedure_entry.feature (eif_access(cfrag_term_procedure_entry.a_class));
	}
}

void set_cfrag_term_procedure_entry (void* a_class, void* a_feature)
{
	cfrag_term_procedure_entry.a_class = eif_adopt(a_class);
	cfrag_term_procedure_entry.feature = (cfrag_term_procedure_eiffel_feature) a_feature;
}

void* get_cfrag_term_procedure_stub ()
{
	return (void*) cfrag_term_procedure_stub;
}

void call_cfrag_term_procedure (void *a_function)
{
	((void (*) (void))a_function) ();
}

struct color_search_proc_ptr_entry_struct color_search_proc_ptr_entry = {NULL, NULL};

Boolean color_search_proc_ptr_stub (RGBColor *rgb, long *position)
{
	if (color_search_proc_ptr_entry.a_class != NULL && color_search_proc_ptr_entry.feature != NULL)
	{
		return color_search_proc_ptr_entry.feature (eif_access(color_search_proc_ptr_entry.a_class), rgb, position);
	}
}

void set_color_search_proc_ptr_entry (void* a_class, void* a_feature)
{
	color_search_proc_ptr_entry.a_class = eif_adopt(a_class);
	color_search_proc_ptr_entry.feature = (color_search_proc_ptr_eiffel_feature) a_feature;
}

void* get_color_search_proc_ptr_stub ()
{
	return (void*) color_search_proc_ptr_stub;
}

Boolean call_color_search_proc_ptr (void *a_function, RGBColor *rgb, long *position)
{
	return ((Boolean (*) (RGBColor *rgb, long *position))a_function) (rgb, position);
}

struct color_complement_proc_ptr_entry_struct color_complement_proc_ptr_entry = {NULL, NULL};

Boolean color_complement_proc_ptr_stub (RGBColor *rgb)
{
	if (color_complement_proc_ptr_entry.a_class != NULL && color_complement_proc_ptr_entry.feature != NULL)
	{
		return color_complement_proc_ptr_entry.feature (eif_access(color_complement_proc_ptr_entry.a_class), rgb);
	}
}

void set_color_complement_proc_ptr_entry (void* a_class, void* a_feature)
{
	color_complement_proc_ptr_entry.a_class = eif_adopt(a_class);
	color_complement_proc_ptr_entry.feature = (color_complement_proc_ptr_eiffel_feature) a_feature;
}

void* get_color_complement_proc_ptr_stub ()
{
	return (void*) color_complement_proc_ptr_stub;
}

Boolean call_color_complement_proc_ptr (void *a_function, RGBColor *rgb)
{
	return ((Boolean (*) (RGBColor *rgb))a_function) (rgb);
}

struct device_loop_drawing_proc_ptr_entry_struct device_loop_drawing_proc_ptr_entry = {NULL, NULL};

void device_loop_drawing_proc_ptr_stub (short depth, short deviceFlags, GDHandle targetDevice, long userData)
{
	if (device_loop_drawing_proc_ptr_entry.a_class != NULL && device_loop_drawing_proc_ptr_entry.feature != NULL)
	{
		device_loop_drawing_proc_ptr_entry.feature (eif_access(device_loop_drawing_proc_ptr_entry.a_class), depth, deviceFlags, targetDevice, userData);
	}
}

void set_device_loop_drawing_proc_ptr_entry (void* a_class, void* a_feature)
{
	device_loop_drawing_proc_ptr_entry.a_class = eif_adopt(a_class);
	device_loop_drawing_proc_ptr_entry.feature = (device_loop_drawing_proc_ptr_eiffel_feature) a_feature;
}

void* get_device_loop_drawing_proc_ptr_stub ()
{
	return (void*) device_loop_drawing_proc_ptr_stub;
}

void call_device_loop_drawing_proc_ptr (void *a_function, short depth, short deviceFlags, GDHandle targetDevice, long userData)
{
	((void (*) (short depth, short deviceFlags, GDHandle targetDevice, long userData))a_function) (depth, deviceFlags, targetDevice, userData);
}

struct region_to_rects_proc_ptr_entry_struct region_to_rects_proc_ptr_entry = {NULL, NULL};

OSStatus region_to_rects_proc_ptr_stub (UInt16 message, RgnHandle rgn, Rect const *rect, void *refCon)
{
	if (region_to_rects_proc_ptr_entry.a_class != NULL && region_to_rects_proc_ptr_entry.feature != NULL)
	{
		return region_to_rects_proc_ptr_entry.feature (eif_access(region_to_rects_proc_ptr_entry.a_class), message, rgn, rect, refCon);
	}
}

void set_region_to_rects_proc_ptr_entry (void* a_class, void* a_feature)
{
	region_to_rects_proc_ptr_entry.a_class = eif_adopt(a_class);
	region_to_rects_proc_ptr_entry.feature = (region_to_rects_proc_ptr_eiffel_feature) a_feature;
}

void* get_region_to_rects_proc_ptr_stub ()
{
	return (void*) region_to_rects_proc_ptr_stub;
}

OSStatus call_region_to_rects_proc_ptr (void *a_function, UInt16 message, RgnHandle rgn, Rect const *rect, void *refCon)
{
	return ((OSStatus (*) (UInt16 message, RgnHandle rgn, Rect const *rect, void *refCon))a_function) (message, rgn, rect, refCon);
}

struct custom_xfer_proc_ptr_entry_struct custom_xfer_proc_ptr_entry = {NULL, NULL};

void custom_xfer_proc_ptr_stub (CustomXFerRecPtr info)
{
	if (custom_xfer_proc_ptr_entry.a_class != NULL && custom_xfer_proc_ptr_entry.feature != NULL)
	{
		custom_xfer_proc_ptr_entry.feature (eif_access(custom_xfer_proc_ptr_entry.a_class), info);
	}
}

void set_custom_xfer_proc_ptr_entry (void* a_class, void* a_feature)
{
	custom_xfer_proc_ptr_entry.a_class = eif_adopt(a_class);
	custom_xfer_proc_ptr_entry.feature = (custom_xfer_proc_ptr_eiffel_feature) a_feature;
}

void* get_custom_xfer_proc_ptr_stub ()
{
	return (void*) custom_xfer_proc_ptr_stub;
}

void call_custom_xfer_proc_ptr (void *a_function, CustomXFerRecPtr info)
{
	((void (*) (CustomXFerRecPtr info))a_function) (info);
}

struct event_comparator_proc_ptr_entry_struct event_comparator_proc_ptr_entry = {NULL, NULL};

Boolean event_comparator_proc_ptr_stub (EventRef inEvent, void *inCompareData)
{
	if (event_comparator_proc_ptr_entry.a_class != NULL && event_comparator_proc_ptr_entry.feature != NULL)
	{
		return event_comparator_proc_ptr_entry.feature (eif_access(event_comparator_proc_ptr_entry.a_class), inEvent, inCompareData);
	}
}

void set_event_comparator_proc_ptr_entry (void* a_class, void* a_feature)
{
	event_comparator_proc_ptr_entry.a_class = eif_adopt(a_class);
	event_comparator_proc_ptr_entry.feature = (event_comparator_proc_ptr_eiffel_feature) a_feature;
}

void* get_event_comparator_proc_ptr_stub ()
{
	return (void*) event_comparator_proc_ptr_stub;
}

Boolean call_event_comparator_proc_ptr (void *a_function, EventRef inEvent, void *inCompareData)
{
	return ((Boolean (*) (EventRef inEvent, void *inCompareData))a_function) (inEvent, inCompareData);
}

struct event_loop_timer_proc_ptr_entry_struct event_loop_timer_proc_ptr_entry = {NULL, NULL};

void event_loop_timer_proc_ptr_stub (EventLoopTimerRef inTimer, void *inUserData)
{
	if (event_loop_timer_proc_ptr_entry.a_class != NULL && event_loop_timer_proc_ptr_entry.feature != NULL)
	{
		event_loop_timer_proc_ptr_entry.feature (eif_access(event_loop_timer_proc_ptr_entry.a_class), inTimer, inUserData);
	}
}

void set_event_loop_timer_proc_ptr_entry (void* a_class, void* a_feature)
{
	event_loop_timer_proc_ptr_entry.a_class = eif_adopt(a_class);
	event_loop_timer_proc_ptr_entry.feature = (event_loop_timer_proc_ptr_eiffel_feature) a_feature;
}

void* get_event_loop_timer_proc_ptr_stub ()
{
	return (void*) event_loop_timer_proc_ptr_stub;
}

void call_event_loop_timer_proc_ptr (void *a_function, EventLoopTimerRef inTimer, void *inUserData)
{
	((void (*) (EventLoopTimerRef inTimer, void *inUserData))a_function) (inTimer, inUserData);
}

struct event_loop_idle_timer_proc_ptr_entry_struct event_loop_idle_timer_proc_ptr_entry = {NULL, NULL};

void event_loop_idle_timer_proc_ptr_stub (EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *inUserData)
{
	if (event_loop_idle_timer_proc_ptr_entry.a_class != NULL && event_loop_idle_timer_proc_ptr_entry.feature != NULL)
	{
		event_loop_idle_timer_proc_ptr_entry.feature (eif_access(event_loop_idle_timer_proc_ptr_entry.a_class), inTimer, inState, inUserData);
	}
}

void set_event_loop_idle_timer_proc_ptr_entry (void* a_class, void* a_feature)
{
	event_loop_idle_timer_proc_ptr_entry.a_class = eif_adopt(a_class);
	event_loop_idle_timer_proc_ptr_entry.feature = (event_loop_idle_timer_proc_ptr_eiffel_feature) a_feature;
}

void* get_event_loop_idle_timer_proc_ptr_stub ()
{
	return (void*) event_loop_idle_timer_proc_ptr_stub;
}

void call_event_loop_idle_timer_proc_ptr (void *a_function, EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *inUserData)
{
	((void (*) (EventLoopTimerRef inTimer, EventLoopIdleTimerMessage inState, void *inUserData))a_function) (inTimer, inState, inUserData);
}

struct event_handler_proc_ptr_entry_struct event_handler_proc_ptr_entry = {NULL, NULL};

OSStatus event_handler_proc_ptr_stub (EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData)
{
	if (event_handler_proc_ptr_entry.a_class != NULL && event_handler_proc_ptr_entry.feature != NULL)
	{
		return event_handler_proc_ptr_entry.feature (eif_access(event_handler_proc_ptr_entry.a_class), inHandlerCallRef, inEvent, inUserData);
	}
}

void set_event_handler_proc_ptr_entry (void* a_class, void* a_feature)
{
	event_handler_proc_ptr_entry.a_class = eif_adopt(a_class);
	event_handler_proc_ptr_entry.feature = (event_handler_proc_ptr_eiffel_feature) a_feature;
}

void* get_event_handler_proc_ptr_stub ()
{
	return (void*) event_handler_proc_ptr_stub;
}

OSStatus call_event_handler_proc_ptr (void *a_function, EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData)
{
	return ((OSStatus (*) (EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData))a_function) (inHandlerCallRef, inEvent, inUserData);
}

struct menu_def_proc_ptr_entry_struct menu_def_proc_ptr_entry = {NULL, NULL};

void menu_def_proc_ptr_stub (short message, MenuRef theMenu, Rect *menuRect, Point hitPt, short *whichItem)
{
	if (menu_def_proc_ptr_entry.a_class != NULL && menu_def_proc_ptr_entry.feature != NULL)
	{
		menu_def_proc_ptr_entry.feature (eif_access(menu_def_proc_ptr_entry.a_class), message, theMenu, menuRect, hitPt, whichItem);
	}
}

void set_menu_def_proc_ptr_entry (void* a_class, void* a_feature)
{
	menu_def_proc_ptr_entry.a_class = eif_adopt(a_class);
	menu_def_proc_ptr_entry.feature = (menu_def_proc_ptr_eiffel_feature) a_feature;
}

void* get_menu_def_proc_ptr_stub ()
{
	return (void*) menu_def_proc_ptr_stub;
}

void call_menu_def_proc_ptr (void *a_function, short message, MenuRef theMenu, Rect *menuRect, Point hitPt, short *whichItem)
{
	((void (*) (short message, MenuRef theMenu, Rect *menuRect, Point hitPt, short *whichItem))a_function) (message, theMenu, menuRect, hitPt, whichItem);
}

struct control_action_proc_ptr_entry_struct control_action_proc_ptr_entry = {NULL, NULL};

void control_action_proc_ptr_stub (ControlRef theControl, ControlPartCode partCode)
{
	if (control_action_proc_ptr_entry.a_class != NULL && control_action_proc_ptr_entry.feature != NULL)
	{
		control_action_proc_ptr_entry.feature (eif_access(control_action_proc_ptr_entry.a_class), theControl, partCode);
	}
}

void set_control_action_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_action_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_action_proc_ptr_entry.feature = (control_action_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_action_proc_ptr_stub ()
{
	return (void*) control_action_proc_ptr_stub;
}

void call_control_action_proc_ptr (void *a_function, ControlRef theControl, ControlPartCode partCode)
{
	((void (*) (ControlRef theControl, ControlPartCode partCode))a_function) (theControl, partCode);
}

struct control_def_proc_ptr_entry_struct control_def_proc_ptr_entry = {NULL, NULL};

SInt32 control_def_proc_ptr_stub (SInt16 varCode, ControlRef theControl, ControlDefProcMessage message, SInt32 param)
{
	if (control_def_proc_ptr_entry.a_class != NULL && control_def_proc_ptr_entry.feature != NULL)
	{
		return control_def_proc_ptr_entry.feature (eif_access(control_def_proc_ptr_entry.a_class), varCode, theControl, message, param);
	}
}

void set_control_def_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_def_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_def_proc_ptr_entry.feature = (control_def_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_def_proc_ptr_stub ()
{
	return (void*) control_def_proc_ptr_stub;
}

SInt32 call_control_def_proc_ptr (void *a_function, SInt16 varCode, ControlRef theControl, ControlDefProcMessage message, SInt32 param)
{
	return ((SInt32 (*) (SInt16 varCode, ControlRef theControl, ControlDefProcMessage message, SInt32 param))a_function) (varCode, theControl, message, param);
}

struct control_key_filter_proc_ptr_entry_struct control_key_filter_proc_ptr_entry = {NULL, NULL};

ControlKeyFilterResult control_key_filter_proc_ptr_stub (ControlRef theControl, SInt16 *keyCode, SInt16 *charCode, EventModifiers *modifiers)
{
	if (control_key_filter_proc_ptr_entry.a_class != NULL && control_key_filter_proc_ptr_entry.feature != NULL)
	{
		return control_key_filter_proc_ptr_entry.feature (eif_access(control_key_filter_proc_ptr_entry.a_class), theControl, keyCode, charCode, modifiers);
	}
}

void set_control_key_filter_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_key_filter_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_key_filter_proc_ptr_entry.feature = (control_key_filter_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_key_filter_proc_ptr_stub ()
{
	return (void*) control_key_filter_proc_ptr_stub;
}

ControlKeyFilterResult call_control_key_filter_proc_ptr (void *a_function, ControlRef theControl, SInt16 *keyCode, SInt16 *charCode, EventModifiers *modifiers)
{
	return ((ControlKeyFilterResult (*) (ControlRef theControl, SInt16 *keyCode, SInt16 *charCode, EventModifiers *modifiers))a_function) (theControl, keyCode, charCode, modifiers);
}

struct control_cntlto_collection_proc_ptr_entry_struct control_cntlto_collection_proc_ptr_entry = {NULL, NULL};

OSStatus control_cntlto_collection_proc_ptr_stub (Rect const *bounds, SInt16 value, Boolean visible, SInt16 max, SInt16 min, SInt16 procID, SInt32 refCon, ConstStr255Param title, Collection collection)
{
	if (control_cntlto_collection_proc_ptr_entry.a_class != NULL && control_cntlto_collection_proc_ptr_entry.feature != NULL)
	{
		return control_cntlto_collection_proc_ptr_entry.feature (eif_access(control_cntlto_collection_proc_ptr_entry.a_class), bounds, value, visible, max, min, procID, refCon, title, collection);
	}
}

void set_control_cntlto_collection_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_cntlto_collection_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_cntlto_collection_proc_ptr_entry.feature = (control_cntlto_collection_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_cntlto_collection_proc_ptr_stub ()
{
	return (void*) control_cntlto_collection_proc_ptr_stub;
}

OSStatus call_control_cntlto_collection_proc_ptr (void *a_function, Rect const *bounds, SInt16 value, Boolean visible, SInt16 max, SInt16 min, SInt16 procID, SInt32 refCon, ConstStr255Param title, Collection collection)
{
	return ((OSStatus (*) (Rect const *bounds, SInt16 value, Boolean visible, SInt16 max, SInt16 min, SInt16 procID, SInt32 refCon, ConstStr255Param title, Collection collection))a_function) (bounds, value, visible, max, min, procID, refCon, title, collection);
}

struct control_color_proc_ptr_entry_struct control_color_proc_ptr_entry = {NULL, NULL};

OSStatus control_color_proc_ptr_stub (ControlRef inControl, SInt16 inMessage, SInt16 inDrawDepth, Boolean inDrawInColor)
{
	if (control_color_proc_ptr_entry.a_class != NULL && control_color_proc_ptr_entry.feature != NULL)
	{
		return control_color_proc_ptr_entry.feature (eif_access(control_color_proc_ptr_entry.a_class), inControl, inMessage, inDrawDepth, inDrawInColor);
	}
}

void set_control_color_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_color_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_color_proc_ptr_entry.feature = (control_color_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_color_proc_ptr_stub ()
{
	return (void*) control_color_proc_ptr_stub;
}

OSStatus call_control_color_proc_ptr (void *a_function, ControlRef inControl, SInt16 inMessage, SInt16 inDrawDepth, Boolean inDrawInColor)
{
	return ((OSStatus (*) (ControlRef inControl, SInt16 inMessage, SInt16 inDrawDepth, Boolean inDrawInColor))a_function) (inControl, inMessage, inDrawDepth, inDrawInColor);
}

struct window_def_proc_ptr_entry_struct window_def_proc_ptr_entry = {NULL, NULL};

long window_def_proc_ptr_stub (short varCode, WindowRef window, short message, long param)
{
	if (window_def_proc_ptr_entry.a_class != NULL && window_def_proc_ptr_entry.feature != NULL)
	{
		return window_def_proc_ptr_entry.feature (eif_access(window_def_proc_ptr_entry.a_class), varCode, window, message, param);
	}
}

void set_window_def_proc_ptr_entry (void* a_class, void* a_feature)
{
	window_def_proc_ptr_entry.a_class = eif_adopt(a_class);
	window_def_proc_ptr_entry.feature = (window_def_proc_ptr_eiffel_feature) a_feature;
}

void* get_window_def_proc_ptr_stub ()
{
	return (void*) window_def_proc_ptr_stub;
}

long call_window_def_proc_ptr (void *a_function, short varCode, WindowRef window, short message, long param)
{
	return ((long (*) (short varCode, WindowRef window, short message, long param))a_function) (varCode, window, message, param);
}

struct window_paint_proc_ptr_entry_struct window_paint_proc_ptr_entry = {NULL, NULL};

OSStatus window_paint_proc_ptr_stub (GDHandle device, GrafPtr qdContext, WindowRef window, RgnHandle inClientPaintRgn, RgnHandle outSystemPaintRgn, void *refCon)
{
	if (window_paint_proc_ptr_entry.a_class != NULL && window_paint_proc_ptr_entry.feature != NULL)
	{
		return window_paint_proc_ptr_entry.feature (eif_access(window_paint_proc_ptr_entry.a_class), device, qdContext, window, inClientPaintRgn, outSystemPaintRgn, refCon);
	}
}

void set_window_paint_proc_ptr_entry (void* a_class, void* a_feature)
{
	window_paint_proc_ptr_entry.a_class = eif_adopt(a_class);
	window_paint_proc_ptr_entry.feature = (window_paint_proc_ptr_eiffel_feature) a_feature;
}

void* get_window_paint_proc_ptr_stub ()
{
	return (void*) window_paint_proc_ptr_stub;
}

OSStatus call_window_paint_proc_ptr (void *a_function, GDHandle device, GrafPtr qdContext, WindowRef window, RgnHandle inClientPaintRgn, RgnHandle outSystemPaintRgn, void *refCon)
{
	return ((OSStatus (*) (GDHandle device, GrafPtr qdContext, WindowRef window, RgnHandle inClientPaintRgn, RgnHandle outSystemPaintRgn, void *refCon))a_function) (device, qdContext, window, inClientPaintRgn, outSystemPaintRgn, refCon);
}

struct hmcontrol_content_proc_ptr_entry_struct hmcontrol_content_proc_ptr_entry = {NULL, NULL};

OSStatus hmcontrol_content_proc_ptr_stub (ControlRef inControl, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	if (hmcontrol_content_proc_ptr_entry.a_class != NULL && hmcontrol_content_proc_ptr_entry.feature != NULL)
	{
		return hmcontrol_content_proc_ptr_entry.feature (eif_access(hmcontrol_content_proc_ptr_entry.a_class), inControl, inGlobalMouse, inRequest, outContentProvided, ioHelpContent);
	}
}

void set_hmcontrol_content_proc_ptr_entry (void* a_class, void* a_feature)
{
	hmcontrol_content_proc_ptr_entry.a_class = eif_adopt(a_class);
	hmcontrol_content_proc_ptr_entry.feature = (hmcontrol_content_proc_ptr_eiffel_feature) a_feature;
}

void* get_hmcontrol_content_proc_ptr_stub ()
{
	return (void*) hmcontrol_content_proc_ptr_stub;
}

OSStatus call_hmcontrol_content_proc_ptr (void *a_function, ControlRef inControl, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	return ((OSStatus (*) (ControlRef inControl, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent))a_function) (inControl, inGlobalMouse, inRequest, outContentProvided, ioHelpContent);
}

struct hmwindow_content_proc_ptr_entry_struct hmwindow_content_proc_ptr_entry = {NULL, NULL};

OSStatus hmwindow_content_proc_ptr_stub (WindowRef inWindow, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	if (hmwindow_content_proc_ptr_entry.a_class != NULL && hmwindow_content_proc_ptr_entry.feature != NULL)
	{
		return hmwindow_content_proc_ptr_entry.feature (eif_access(hmwindow_content_proc_ptr_entry.a_class), inWindow, inGlobalMouse, inRequest, outContentProvided, ioHelpContent);
	}
}

void set_hmwindow_content_proc_ptr_entry (void* a_class, void* a_feature)
{
	hmwindow_content_proc_ptr_entry.a_class = eif_adopt(a_class);
	hmwindow_content_proc_ptr_entry.feature = (hmwindow_content_proc_ptr_eiffel_feature) a_feature;
}

void* get_hmwindow_content_proc_ptr_stub ()
{
	return (void*) hmwindow_content_proc_ptr_stub;
}

OSStatus call_hmwindow_content_proc_ptr (void *a_function, WindowRef inWindow, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	return ((OSStatus (*) (WindowRef inWindow, Point inGlobalMouse, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent))a_function) (inWindow, inGlobalMouse, inRequest, outContentProvided, ioHelpContent);
}

struct hmmenu_title_content_proc_ptr_entry_struct hmmenu_title_content_proc_ptr_entry = {NULL, NULL};

OSStatus hmmenu_title_content_proc_ptr_stub (MenuRef inMenu, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	if (hmmenu_title_content_proc_ptr_entry.a_class != NULL && hmmenu_title_content_proc_ptr_entry.feature != NULL)
	{
		return hmmenu_title_content_proc_ptr_entry.feature (eif_access(hmmenu_title_content_proc_ptr_entry.a_class), inMenu, inRequest, outContentProvided, ioHelpContent);
	}
}

void set_hmmenu_title_content_proc_ptr_entry (void* a_class, void* a_feature)
{
	hmmenu_title_content_proc_ptr_entry.a_class = eif_adopt(a_class);
	hmmenu_title_content_proc_ptr_entry.feature = (hmmenu_title_content_proc_ptr_eiffel_feature) a_feature;
}

void* get_hmmenu_title_content_proc_ptr_stub ()
{
	return (void*) hmmenu_title_content_proc_ptr_stub;
}

OSStatus call_hmmenu_title_content_proc_ptr (void *a_function, MenuRef inMenu, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	return ((OSStatus (*) (MenuRef inMenu, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent))a_function) (inMenu, inRequest, outContentProvided, ioHelpContent);
}

struct hmmenu_item_content_proc_ptr_entry_struct hmmenu_item_content_proc_ptr_entry = {NULL, NULL};

OSStatus hmmenu_item_content_proc_ptr_stub (MenuTrackingData const *inTrackingData, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	if (hmmenu_item_content_proc_ptr_entry.a_class != NULL && hmmenu_item_content_proc_ptr_entry.feature != NULL)
	{
		return hmmenu_item_content_proc_ptr_entry.feature (eif_access(hmmenu_item_content_proc_ptr_entry.a_class), inTrackingData, inRequest, outContentProvided, ioHelpContent);
	}
}

void set_hmmenu_item_content_proc_ptr_entry (void* a_class, void* a_feature)
{
	hmmenu_item_content_proc_ptr_entry.a_class = eif_adopt(a_class);
	hmmenu_item_content_proc_ptr_entry.feature = (hmmenu_item_content_proc_ptr_eiffel_feature) a_feature;
}

void* get_hmmenu_item_content_proc_ptr_stub ()
{
	return (void*) hmmenu_item_content_proc_ptr_stub;
}

OSStatus call_hmmenu_item_content_proc_ptr (void *a_function, MenuTrackingData const *inTrackingData, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	return ((OSStatus (*) (MenuTrackingData const *inTrackingData, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent))a_function) (inTrackingData, inRequest, outContentProvided, ioHelpContent);
}

struct control_user_pane_draw_proc_ptr_entry_struct control_user_pane_draw_proc_ptr_entry = {NULL, NULL};

void control_user_pane_draw_proc_ptr_stub (ControlRef control, SInt16 part)
{
	if (control_user_pane_draw_proc_ptr_entry.a_class != NULL && control_user_pane_draw_proc_ptr_entry.feature != NULL)
	{
		control_user_pane_draw_proc_ptr_entry.feature (eif_access(control_user_pane_draw_proc_ptr_entry.a_class), control, part);
	}
}

void set_control_user_pane_draw_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_draw_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_draw_proc_ptr_entry.feature = (control_user_pane_draw_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_draw_proc_ptr_stub ()
{
	return (void*) control_user_pane_draw_proc_ptr_stub;
}

void call_control_user_pane_draw_proc_ptr (void *a_function, ControlRef control, SInt16 part)
{
	((void (*) (ControlRef control, SInt16 part))a_function) (control, part);
}

struct control_user_pane_hit_test_proc_ptr_entry_struct control_user_pane_hit_test_proc_ptr_entry = {NULL, NULL};

ControlPartCode control_user_pane_hit_test_proc_ptr_stub (ControlRef control, Point where)
{
	if (control_user_pane_hit_test_proc_ptr_entry.a_class != NULL && control_user_pane_hit_test_proc_ptr_entry.feature != NULL)
	{
		return control_user_pane_hit_test_proc_ptr_entry.feature (eif_access(control_user_pane_hit_test_proc_ptr_entry.a_class), control, where);
	}
}

void set_control_user_pane_hit_test_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_hit_test_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_hit_test_proc_ptr_entry.feature = (control_user_pane_hit_test_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_hit_test_proc_ptr_stub ()
{
	return (void*) control_user_pane_hit_test_proc_ptr_stub;
}

ControlPartCode call_control_user_pane_hit_test_proc_ptr (void *a_function, ControlRef control, Point where)
{
	return ((ControlPartCode (*) (ControlRef control, Point where))a_function) (control, where);
}

struct control_user_pane_tracking_proc_ptr_entry_struct control_user_pane_tracking_proc_ptr_entry = {NULL, NULL};

ControlPartCode control_user_pane_tracking_proc_ptr_stub (ControlRef control, Point startPt, ControlActionUPP actionProc)
{
	if (control_user_pane_tracking_proc_ptr_entry.a_class != NULL && control_user_pane_tracking_proc_ptr_entry.feature != NULL)
	{
		return control_user_pane_tracking_proc_ptr_entry.feature (eif_access(control_user_pane_tracking_proc_ptr_entry.a_class), control, startPt, actionProc);
	}
}

void set_control_user_pane_tracking_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_tracking_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_tracking_proc_ptr_entry.feature = (control_user_pane_tracking_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_tracking_proc_ptr_stub ()
{
	return (void*) control_user_pane_tracking_proc_ptr_stub;
}

ControlPartCode call_control_user_pane_tracking_proc_ptr (void *a_function, ControlRef control, Point startPt, ControlActionUPP actionProc)
{
	return ((ControlPartCode (*) (ControlRef control, Point startPt, ControlActionUPP actionProc))a_function) (control, startPt, actionProc);
}

struct control_user_pane_idle_proc_ptr_entry_struct control_user_pane_idle_proc_ptr_entry = {NULL, NULL};

void control_user_pane_idle_proc_ptr_stub (ControlRef control)
{
	if (control_user_pane_idle_proc_ptr_entry.a_class != NULL && control_user_pane_idle_proc_ptr_entry.feature != NULL)
	{
		control_user_pane_idle_proc_ptr_entry.feature (eif_access(control_user_pane_idle_proc_ptr_entry.a_class), control);
	}
}

void set_control_user_pane_idle_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_idle_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_idle_proc_ptr_entry.feature = (control_user_pane_idle_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_idle_proc_ptr_stub ()
{
	return (void*) control_user_pane_idle_proc_ptr_stub;
}

void call_control_user_pane_idle_proc_ptr (void *a_function, ControlRef control)
{
	((void (*) (ControlRef control))a_function) (control);
}

struct control_user_pane_key_down_proc_ptr_entry_struct control_user_pane_key_down_proc_ptr_entry = {NULL, NULL};

ControlPartCode control_user_pane_key_down_proc_ptr_stub (ControlRef control, SInt16 keyCode, SInt16 charCode, SInt16 modifiers)
{
	if (control_user_pane_key_down_proc_ptr_entry.a_class != NULL && control_user_pane_key_down_proc_ptr_entry.feature != NULL)
	{
		return control_user_pane_key_down_proc_ptr_entry.feature (eif_access(control_user_pane_key_down_proc_ptr_entry.a_class), control, keyCode, charCode, modifiers);
	}
}

void set_control_user_pane_key_down_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_key_down_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_key_down_proc_ptr_entry.feature = (control_user_pane_key_down_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_key_down_proc_ptr_stub ()
{
	return (void*) control_user_pane_key_down_proc_ptr_stub;
}

ControlPartCode call_control_user_pane_key_down_proc_ptr (void *a_function, ControlRef control, SInt16 keyCode, SInt16 charCode, SInt16 modifiers)
{
	return ((ControlPartCode (*) (ControlRef control, SInt16 keyCode, SInt16 charCode, SInt16 modifiers))a_function) (control, keyCode, charCode, modifiers);
}

struct control_user_pane_activate_proc_ptr_entry_struct control_user_pane_activate_proc_ptr_entry = {NULL, NULL};

void control_user_pane_activate_proc_ptr_stub (ControlRef control, Boolean activating)
{
	if (control_user_pane_activate_proc_ptr_entry.a_class != NULL && control_user_pane_activate_proc_ptr_entry.feature != NULL)
	{
		control_user_pane_activate_proc_ptr_entry.feature (eif_access(control_user_pane_activate_proc_ptr_entry.a_class), control, activating);
	}
}

void set_control_user_pane_activate_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_activate_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_activate_proc_ptr_entry.feature = (control_user_pane_activate_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_activate_proc_ptr_stub ()
{
	return (void*) control_user_pane_activate_proc_ptr_stub;
}

void call_control_user_pane_activate_proc_ptr (void *a_function, ControlRef control, Boolean activating)
{
	((void (*) (ControlRef control, Boolean activating))a_function) (control, activating);
}

struct control_user_pane_focus_proc_ptr_entry_struct control_user_pane_focus_proc_ptr_entry = {NULL, NULL};

ControlPartCode control_user_pane_focus_proc_ptr_stub (ControlRef control, ControlFocusPart action)
{
	if (control_user_pane_focus_proc_ptr_entry.a_class != NULL && control_user_pane_focus_proc_ptr_entry.feature != NULL)
	{
		return control_user_pane_focus_proc_ptr_entry.feature (eif_access(control_user_pane_focus_proc_ptr_entry.a_class), control, action);
	}
}

void set_control_user_pane_focus_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_focus_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_focus_proc_ptr_entry.feature = (control_user_pane_focus_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_focus_proc_ptr_stub ()
{
	return (void*) control_user_pane_focus_proc_ptr_stub;
}

ControlPartCode call_control_user_pane_focus_proc_ptr (void *a_function, ControlRef control, ControlFocusPart action)
{
	return ((ControlPartCode (*) (ControlRef control, ControlFocusPart action))a_function) (control, action);
}

struct control_user_pane_background_proc_ptr_entry_struct control_user_pane_background_proc_ptr_entry = {NULL, NULL};

void control_user_pane_background_proc_ptr_stub (ControlRef control, ControlBackgroundPtr info)
{
	if (control_user_pane_background_proc_ptr_entry.a_class != NULL && control_user_pane_background_proc_ptr_entry.feature != NULL)
	{
		control_user_pane_background_proc_ptr_entry.feature (eif_access(control_user_pane_background_proc_ptr_entry.a_class), control, info);
	}
}

void set_control_user_pane_background_proc_ptr_entry (void* a_class, void* a_feature)
{
	control_user_pane_background_proc_ptr_entry.a_class = eif_adopt(a_class);
	control_user_pane_background_proc_ptr_entry.feature = (control_user_pane_background_proc_ptr_eiffel_feature) a_feature;
}

void* get_control_user_pane_background_proc_ptr_stub ()
{
	return (void*) control_user_pane_background_proc_ptr_stub;
}

void call_control_user_pane_background_proc_ptr (void *a_function, ControlRef control, ControlBackgroundPtr info)
{
	((void (*) (ControlRef control, ControlBackgroundPtr info))a_function) (control, info);
}

struct data_browser_item_proc_ptr_entry_struct data_browser_item_proc_ptr_entry = {NULL, NULL};

void data_browser_item_proc_ptr_stub (DataBrowserItemID item, DataBrowserItemState state, void *clientData)
{
	if (data_browser_item_proc_ptr_entry.a_class != NULL && data_browser_item_proc_ptr_entry.feature != NULL)
	{
		data_browser_item_proc_ptr_entry.feature (eif_access(data_browser_item_proc_ptr_entry.a_class), item, state, clientData);
	}
}

void set_data_browser_item_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_proc_ptr_entry.feature = (data_browser_item_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_proc_ptr_stub ()
{
	return (void*) data_browser_item_proc_ptr_stub;
}

void call_data_browser_item_proc_ptr (void *a_function, DataBrowserItemID item, DataBrowserItemState state, void *clientData)
{
	((void (*) (DataBrowserItemID item, DataBrowserItemState state, void *clientData))a_function) (item, state, clientData);
}

struct data_browser_item_data_proc_ptr_entry_struct data_browser_item_data_proc_ptr_entry = {NULL, NULL};

OSStatus data_browser_item_data_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemDataRef itemData, Boolean setValue)
{
	if (data_browser_item_data_proc_ptr_entry.a_class != NULL && data_browser_item_data_proc_ptr_entry.feature != NULL)
	{
		return data_browser_item_data_proc_ptr_entry.feature (eif_access(data_browser_item_data_proc_ptr_entry.a_class), browser, item, property, itemData, setValue);
	}
}

void set_data_browser_item_data_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_data_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_data_proc_ptr_entry.feature = (data_browser_item_data_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_data_proc_ptr_stub ()
{
	return (void*) data_browser_item_data_proc_ptr_stub;
}

OSStatus call_data_browser_item_data_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemDataRef itemData, Boolean setValue)
{
	return ((OSStatus (*) (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemDataRef itemData, Boolean setValue))a_function) (browser, item, property, itemData, setValue);
}

struct data_browser_item_compare_proc_ptr_entry_struct data_browser_item_compare_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_item_compare_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemOne, DataBrowserItemID itemTwo, DataBrowserPropertyID sortProperty)
{
	if (data_browser_item_compare_proc_ptr_entry.a_class != NULL && data_browser_item_compare_proc_ptr_entry.feature != NULL)
	{
		return data_browser_item_compare_proc_ptr_entry.feature (eif_access(data_browser_item_compare_proc_ptr_entry.a_class), browser, itemOne, itemTwo, sortProperty);
	}
}

void set_data_browser_item_compare_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_compare_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_compare_proc_ptr_entry.feature = (data_browser_item_compare_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_compare_proc_ptr_stub ()
{
	return (void*) data_browser_item_compare_proc_ptr_stub;
}

Boolean call_data_browser_item_compare_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemOne, DataBrowserItemID itemTwo, DataBrowserPropertyID sortProperty)
{
	return ((Boolean (*) (ControlRef browser, DataBrowserItemID itemOne, DataBrowserItemID itemTwo, DataBrowserPropertyID sortProperty))a_function) (browser, itemOne, itemTwo, sortProperty);
}

struct data_browser_item_notification_with_item_proc_ptr_entry_struct data_browser_item_notification_with_item_proc_ptr_entry = {NULL, NULL};

void data_browser_item_notification_with_item_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message, DataBrowserItemDataRef itemData)
{
	if (data_browser_item_notification_with_item_proc_ptr_entry.a_class != NULL && data_browser_item_notification_with_item_proc_ptr_entry.feature != NULL)
	{
		data_browser_item_notification_with_item_proc_ptr_entry.feature (eif_access(data_browser_item_notification_with_item_proc_ptr_entry.a_class), browser, item, message, itemData);
	}
}

void set_data_browser_item_notification_with_item_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_notification_with_item_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_notification_with_item_proc_ptr_entry.feature = (data_browser_item_notification_with_item_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_notification_with_item_proc_ptr_stub ()
{
	return (void*) data_browser_item_notification_with_item_proc_ptr_stub;
}

void call_data_browser_item_notification_with_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message, DataBrowserItemDataRef itemData)
{
	((void (*) (ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message, DataBrowserItemDataRef itemData))a_function) (browser, item, message, itemData);
}

struct data_browser_item_notification_proc_ptr_entry_struct data_browser_item_notification_proc_ptr_entry = {NULL, NULL};

void data_browser_item_notification_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message)
{
	if (data_browser_item_notification_proc_ptr_entry.a_class != NULL && data_browser_item_notification_proc_ptr_entry.feature != NULL)
	{
		data_browser_item_notification_proc_ptr_entry.feature (eif_access(data_browser_item_notification_proc_ptr_entry.a_class), browser, item, message);
	}
}

void set_data_browser_item_notification_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_notification_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_notification_proc_ptr_entry.feature = (data_browser_item_notification_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_notification_proc_ptr_stub ()
{
	return (void*) data_browser_item_notification_proc_ptr_stub;
}

void call_data_browser_item_notification_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message)
{
	((void (*) (ControlRef browser, DataBrowserItemID item, DataBrowserItemNotification message))a_function) (browser, item, message);
}

struct data_browser_add_drag_item_proc_ptr_entry_struct data_browser_add_drag_item_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_add_drag_item_proc_ptr_stub (ControlRef browser, DragReference theDrag, DataBrowserItemID item, ItemReference *itemRef)
{
	if (data_browser_add_drag_item_proc_ptr_entry.a_class != NULL && data_browser_add_drag_item_proc_ptr_entry.feature != NULL)
	{
		return data_browser_add_drag_item_proc_ptr_entry.feature (eif_access(data_browser_add_drag_item_proc_ptr_entry.a_class), browser, theDrag, item, itemRef);
	}
}

void set_data_browser_add_drag_item_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_add_drag_item_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_add_drag_item_proc_ptr_entry.feature = (data_browser_add_drag_item_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_add_drag_item_proc_ptr_stub ()
{
	return (void*) data_browser_add_drag_item_proc_ptr_stub;
}

Boolean call_data_browser_add_drag_item_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, DataBrowserItemID item, ItemReference *itemRef)
{
	return ((Boolean (*) (ControlRef browser, DragReference theDrag, DataBrowserItemID item, ItemReference *itemRef))a_function) (browser, theDrag, item, itemRef);
}

struct data_browser_accept_drag_proc_ptr_entry_struct data_browser_accept_drag_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_accept_drag_proc_ptr_stub (ControlRef browser, DragReference theDrag, DataBrowserItemID item)
{
	if (data_browser_accept_drag_proc_ptr_entry.a_class != NULL && data_browser_accept_drag_proc_ptr_entry.feature != NULL)
	{
		return data_browser_accept_drag_proc_ptr_entry.feature (eif_access(data_browser_accept_drag_proc_ptr_entry.a_class), browser, theDrag, item);
	}
}

void set_data_browser_accept_drag_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_accept_drag_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_accept_drag_proc_ptr_entry.feature = (data_browser_accept_drag_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_accept_drag_proc_ptr_stub ()
{
	return (void*) data_browser_accept_drag_proc_ptr_stub;
}

Boolean call_data_browser_accept_drag_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, DataBrowserItemID item)
{
	return ((Boolean (*) (ControlRef browser, DragReference theDrag, DataBrowserItemID item))a_function) (browser, theDrag, item);
}

struct data_browser_post_process_drag_proc_ptr_entry_struct data_browser_post_process_drag_proc_ptr_entry = {NULL, NULL};

void data_browser_post_process_drag_proc_ptr_stub (ControlRef browser, DragReference theDrag, OSStatus trackDragResult)
{
	if (data_browser_post_process_drag_proc_ptr_entry.a_class != NULL && data_browser_post_process_drag_proc_ptr_entry.feature != NULL)
	{
		data_browser_post_process_drag_proc_ptr_entry.feature (eif_access(data_browser_post_process_drag_proc_ptr_entry.a_class), browser, theDrag, trackDragResult);
	}
}

void set_data_browser_post_process_drag_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_post_process_drag_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_post_process_drag_proc_ptr_entry.feature = (data_browser_post_process_drag_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_post_process_drag_proc_ptr_stub ()
{
	return (void*) data_browser_post_process_drag_proc_ptr_stub;
}

void call_data_browser_post_process_drag_proc_ptr (void *a_function, ControlRef browser, DragReference theDrag, OSStatus trackDragResult)
{
	((void (*) (ControlRef browser, DragReference theDrag, OSStatus trackDragResult))a_function) (browser, theDrag, trackDragResult);
}

struct data_browser_get_contextual_menu_proc_ptr_entry_struct data_browser_get_contextual_menu_proc_ptr_entry = {NULL, NULL};

void data_browser_get_contextual_menu_proc_ptr_stub (ControlRef browser, MenuRef *menu, UInt32 *helpType, CFStringRef *helpItemString, AEDesc *selection)
{
	if (data_browser_get_contextual_menu_proc_ptr_entry.a_class != NULL && data_browser_get_contextual_menu_proc_ptr_entry.feature != NULL)
	{
		data_browser_get_contextual_menu_proc_ptr_entry.feature (eif_access(data_browser_get_contextual_menu_proc_ptr_entry.a_class), browser, menu, helpType, helpItemString, selection);
	}
}

void set_data_browser_get_contextual_menu_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_get_contextual_menu_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_get_contextual_menu_proc_ptr_entry.feature = (data_browser_get_contextual_menu_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_get_contextual_menu_proc_ptr_stub ()
{
	return (void*) data_browser_get_contextual_menu_proc_ptr_stub;
}

void call_data_browser_get_contextual_menu_proc_ptr (void *a_function, ControlRef browser, MenuRef *menu, UInt32 *helpType, CFStringRef *helpItemString, AEDesc *selection)
{
	((void (*) (ControlRef browser, MenuRef *menu, UInt32 *helpType, CFStringRef *helpItemString, AEDesc *selection))a_function) (browser, menu, helpType, helpItemString, selection);
}

struct data_browser_select_contextual_menu_proc_ptr_entry_struct data_browser_select_contextual_menu_proc_ptr_entry = {NULL, NULL};

void data_browser_select_contextual_menu_proc_ptr_stub (ControlRef browser, MenuRef menu, UInt32 selectionType, SInt16 menuID, MenuItemIndex menuItem)
{
	if (data_browser_select_contextual_menu_proc_ptr_entry.a_class != NULL && data_browser_select_contextual_menu_proc_ptr_entry.feature != NULL)
	{
		data_browser_select_contextual_menu_proc_ptr_entry.feature (eif_access(data_browser_select_contextual_menu_proc_ptr_entry.a_class), browser, menu, selectionType, menuID, menuItem);
	}
}

void set_data_browser_select_contextual_menu_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_select_contextual_menu_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_select_contextual_menu_proc_ptr_entry.feature = (data_browser_select_contextual_menu_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_select_contextual_menu_proc_ptr_stub ()
{
	return (void*) data_browser_select_contextual_menu_proc_ptr_stub;
}

void call_data_browser_select_contextual_menu_proc_ptr (void *a_function, ControlRef browser, MenuRef menu, UInt32 selectionType, SInt16 menuID, MenuItemIndex menuItem)
{
	((void (*) (ControlRef browser, MenuRef menu, UInt32 selectionType, SInt16 menuID, MenuItemIndex menuItem))a_function) (browser, menu, selectionType, menuID, menuItem);
}

struct data_browser_item_help_content_proc_ptr_entry_struct data_browser_item_help_content_proc_ptr_entry = {NULL, NULL};

void data_browser_item_help_content_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	if (data_browser_item_help_content_proc_ptr_entry.a_class != NULL && data_browser_item_help_content_proc_ptr_entry.feature != NULL)
	{
		data_browser_item_help_content_proc_ptr_entry.feature (eif_access(data_browser_item_help_content_proc_ptr_entry.a_class), browser, item, property, inRequest, outContentProvided, ioHelpContent);
	}
}

void set_data_browser_item_help_content_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_help_content_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_help_content_proc_ptr_entry.feature = (data_browser_item_help_content_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_help_content_proc_ptr_stub ()
{
	return (void*) data_browser_item_help_content_proc_ptr_stub;
}

void call_data_browser_item_help_content_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent)
{
	((void (*) (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, HMContentRequest inRequest, HMContentProvidedType *outContentProvided, HMHelpContentPtr ioHelpContent))a_function) (browser, item, property, inRequest, outContentProvided, ioHelpContent);
}

struct data_browser_draw_item_proc_ptr_entry_struct data_browser_draw_item_proc_ptr_entry = {NULL, NULL};

void data_browser_draw_item_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemState itemState, Rect const *theRect, SInt16 gdDepth, Boolean colorDevice)
{
	if (data_browser_draw_item_proc_ptr_entry.a_class != NULL && data_browser_draw_item_proc_ptr_entry.feature != NULL)
	{
		data_browser_draw_item_proc_ptr_entry.feature (eif_access(data_browser_draw_item_proc_ptr_entry.a_class), browser, item, property, itemState, theRect, gdDepth, colorDevice);
	}
}

void set_data_browser_draw_item_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_draw_item_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_draw_item_proc_ptr_entry.feature = (data_browser_draw_item_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_draw_item_proc_ptr_stub ()
{
	return (void*) data_browser_draw_item_proc_ptr_stub;
}

void call_data_browser_draw_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemState itemState, Rect const *theRect, SInt16 gdDepth, Boolean colorDevice)
{
	((void (*) (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, DataBrowserItemState itemState, Rect const *theRect, SInt16 gdDepth, Boolean colorDevice))a_function) (browser, item, property, itemState, theRect, gdDepth, colorDevice);
}

struct data_browser_edit_item_proc_ptr_entry_struct data_browser_edit_item_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_edit_item_proc_ptr_stub (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, CFStringRef theString, Rect *maxEditTextRect, Boolean *shrinkToFit)
{
	if (data_browser_edit_item_proc_ptr_entry.a_class != NULL && data_browser_edit_item_proc_ptr_entry.feature != NULL)
	{
		return data_browser_edit_item_proc_ptr_entry.feature (eif_access(data_browser_edit_item_proc_ptr_entry.a_class), browser, item, property, theString, maxEditTextRect, shrinkToFit);
	}
}

void set_data_browser_edit_item_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_edit_item_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_edit_item_proc_ptr_entry.feature = (data_browser_edit_item_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_edit_item_proc_ptr_stub ()
{
	return (void*) data_browser_edit_item_proc_ptr_stub;
}

Boolean call_data_browser_edit_item_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, CFStringRef theString, Rect *maxEditTextRect, Boolean *shrinkToFit)
{
	return ((Boolean (*) (ControlRef browser, DataBrowserItemID item, DataBrowserPropertyID property, CFStringRef theString, Rect *maxEditTextRect, Boolean *shrinkToFit))a_function) (browser, item, property, theString, maxEditTextRect, shrinkToFit);
}

struct data_browser_hit_test_proc_ptr_entry_struct data_browser_hit_test_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_hit_test_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Rect const *mouseRect)
{
	if (data_browser_hit_test_proc_ptr_entry.a_class != NULL && data_browser_hit_test_proc_ptr_entry.feature != NULL)
	{
		return data_browser_hit_test_proc_ptr_entry.feature (eif_access(data_browser_hit_test_proc_ptr_entry.a_class), browser, itemID, property, theRect, mouseRect);
	}
}

void set_data_browser_hit_test_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_hit_test_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_hit_test_proc_ptr_entry.feature = (data_browser_hit_test_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_hit_test_proc_ptr_stub ()
{
	return (void*) data_browser_hit_test_proc_ptr_stub;
}

Boolean call_data_browser_hit_test_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Rect const *mouseRect)
{
	return ((Boolean (*) (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Rect const *mouseRect))a_function) (browser, itemID, property, theRect, mouseRect);
}

struct data_browser_tracking_proc_ptr_entry_struct data_browser_tracking_proc_ptr_entry = {NULL, NULL};

DataBrowserTrackingResult data_browser_tracking_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Point startPt, EventModifiers modifiers)
{
	if (data_browser_tracking_proc_ptr_entry.a_class != NULL && data_browser_tracking_proc_ptr_entry.feature != NULL)
	{
		return data_browser_tracking_proc_ptr_entry.feature (eif_access(data_browser_tracking_proc_ptr_entry.a_class), browser, itemID, property, theRect, startPt, modifiers);
	}
}

void set_data_browser_tracking_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_tracking_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_tracking_proc_ptr_entry.feature = (data_browser_tracking_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_tracking_proc_ptr_stub ()
{
	return (void*) data_browser_tracking_proc_ptr_stub;
}

DataBrowserTrackingResult call_data_browser_tracking_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Point startPt, EventModifiers modifiers)
{
	return ((DataBrowserTrackingResult (*) (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, Point startPt, EventModifiers modifiers))a_function) (browser, itemID, property, theRect, startPt, modifiers);
}

struct data_browser_item_drag_rgn_proc_ptr_entry_struct data_browser_item_drag_rgn_proc_ptr_entry = {NULL, NULL};

void data_browser_item_drag_rgn_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, RgnHandle dragRgn)
{
	if (data_browser_item_drag_rgn_proc_ptr_entry.a_class != NULL && data_browser_item_drag_rgn_proc_ptr_entry.feature != NULL)
	{
		data_browser_item_drag_rgn_proc_ptr_entry.feature (eif_access(data_browser_item_drag_rgn_proc_ptr_entry.a_class), browser, itemID, property, theRect, dragRgn);
	}
}

void set_data_browser_item_drag_rgn_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_drag_rgn_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_drag_rgn_proc_ptr_entry.feature = (data_browser_item_drag_rgn_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_drag_rgn_proc_ptr_stub ()
{
	return (void*) data_browser_item_drag_rgn_proc_ptr_stub;
}

void call_data_browser_item_drag_rgn_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, RgnHandle dragRgn)
{
	((void (*) (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, RgnHandle dragRgn))a_function) (browser, itemID, property, theRect, dragRgn);
}

struct data_browser_item_accept_drag_proc_ptr_entry_struct data_browser_item_accept_drag_proc_ptr_entry = {NULL, NULL};

DataBrowserDragFlags data_browser_item_accept_drag_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, DragReference theDrag)
{
	if (data_browser_item_accept_drag_proc_ptr_entry.a_class != NULL && data_browser_item_accept_drag_proc_ptr_entry.feature != NULL)
	{
		return data_browser_item_accept_drag_proc_ptr_entry.feature (eif_access(data_browser_item_accept_drag_proc_ptr_entry.a_class), browser, itemID, property, theRect, theDrag);
	}
}

void set_data_browser_item_accept_drag_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_accept_drag_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_accept_drag_proc_ptr_entry.feature = (data_browser_item_accept_drag_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_accept_drag_proc_ptr_stub ()
{
	return (void*) data_browser_item_accept_drag_proc_ptr_stub;
}

DataBrowserDragFlags call_data_browser_item_accept_drag_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, DragReference theDrag)
{
	return ((DataBrowserDragFlags (*) (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, Rect const *theRect, DragReference theDrag))a_function) (browser, itemID, property, theRect, theDrag);
}

struct data_browser_item_receive_drag_proc_ptr_entry_struct data_browser_item_receive_drag_proc_ptr_entry = {NULL, NULL};

Boolean data_browser_item_receive_drag_proc_ptr_stub (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, DataBrowserDragFlags dragFlags, DragReference theDrag)
{
	if (data_browser_item_receive_drag_proc_ptr_entry.a_class != NULL && data_browser_item_receive_drag_proc_ptr_entry.feature != NULL)
	{
		return data_browser_item_receive_drag_proc_ptr_entry.feature (eif_access(data_browser_item_receive_drag_proc_ptr_entry.a_class), browser, itemID, property, dragFlags, theDrag);
	}
}

void set_data_browser_item_receive_drag_proc_ptr_entry (void* a_class, void* a_feature)
{
	data_browser_item_receive_drag_proc_ptr_entry.a_class = eif_adopt(a_class);
	data_browser_item_receive_drag_proc_ptr_entry.feature = (data_browser_item_receive_drag_proc_ptr_eiffel_feature) a_feature;
}

void* get_data_browser_item_receive_drag_proc_ptr_stub ()
{
	return (void*) data_browser_item_receive_drag_proc_ptr_stub;
}

Boolean call_data_browser_item_receive_drag_proc_ptr (void *a_function, ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, DataBrowserDragFlags dragFlags, DragReference theDrag)
{
	return ((Boolean (*) (ControlRef browser, DataBrowserItemID itemID, DataBrowserPropertyID property, DataBrowserDragFlags dragFlags, DragReference theDrag))a_function) (browser, itemID, property, dragFlags, theDrag);
}

struct edit_unicode_post_update_proc_ptr_entry_struct edit_unicode_post_update_proc_ptr_entry = {NULL, NULL};

Boolean edit_unicode_post_update_proc_ptr_stub (UniCharArrayHandle uniText, UniCharCount uniTextLength, UniCharArrayOffset iStartOffset, UniCharArrayOffset iEndOffset, void *refcon)
{
	if (edit_unicode_post_update_proc_ptr_entry.a_class != NULL && edit_unicode_post_update_proc_ptr_entry.feature != NULL)
	{
		return edit_unicode_post_update_proc_ptr_entry.feature (eif_access(edit_unicode_post_update_proc_ptr_entry.a_class), uniText, uniTextLength, iStartOffset, iEndOffset, refcon);
	}
}

void set_edit_unicode_post_update_proc_ptr_entry (void* a_class, void* a_feature)
{
	edit_unicode_post_update_proc_ptr_entry.a_class = eif_adopt(a_class);
	edit_unicode_post_update_proc_ptr_entry.feature = (edit_unicode_post_update_proc_ptr_eiffel_feature) a_feature;
}

void* get_edit_unicode_post_update_proc_ptr_stub ()
{
	return (void*) edit_unicode_post_update_proc_ptr_stub;
}

Boolean call_edit_unicode_post_update_proc_ptr (void *a_function, UniCharArrayHandle uniText, UniCharCount uniTextLength, UniCharArrayOffset iStartOffset, UniCharArrayOffset iEndOffset, void *refcon)
{
	return ((Boolean (*) (UniCharArrayHandle uniText, UniCharCount uniTextLength, UniCharArrayOffset iStartOffset, UniCharArrayOffset iEndOffset, void *refcon))a_function) (uniText, uniTextLength, iStartOffset, iEndOffset, refcon);
}

struct cfcomparator_function_entry_struct cfcomparator_function_entry = {NULL, NULL};

CFComparisonResult cfcomparator_function_stub (void const *val1, void const *val2, void *context)
{
	if (cfcomparator_function_entry.a_class != NULL && cfcomparator_function_entry.feature != NULL)
	{
		return cfcomparator_function_entry.feature (eif_access(cfcomparator_function_entry.a_class), val1, val2, context);
	}
}

void set_cfcomparator_function_entry (void* a_class, void* a_feature)
{
	cfcomparator_function_entry.a_class = eif_adopt(a_class);
	cfcomparator_function_entry.feature = (cfcomparator_function_eiffel_feature) a_feature;
}

void* get_cfcomparator_function_stub ()
{
	return (void*) cfcomparator_function_stub;
}

CFComparisonResult call_cfcomparator_function (void *a_function, void const *val1, void const *val2, void *context)
{
	return ((CFComparisonResult (*) (void const *val1, void const *val2, void *context))a_function) (val1, val2, context);
}

struct cfallocator_retain_call_back_entry_struct cfallocator_retain_call_back_entry = {NULL, NULL};

void const *cfallocator_retain_call_back_stub (void const *info)
{
	if (cfallocator_retain_call_back_entry.a_class != NULL && cfallocator_retain_call_back_entry.feature != NULL)
	{
		return cfallocator_retain_call_back_entry.feature (eif_access(cfallocator_retain_call_back_entry.a_class), info);
	}
}

void set_cfallocator_retain_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_retain_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_retain_call_back_entry.feature = (cfallocator_retain_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_retain_call_back_stub ()
{
	return (void*) cfallocator_retain_call_back_stub;
}

void const *call_cfallocator_retain_call_back (void *a_function, void const *info)
{
	return ((void const *(*) (void const *info))a_function) (info);
}

struct cfallocator_release_call_back_entry_struct cfallocator_release_call_back_entry = {NULL, NULL};

void cfallocator_release_call_back_stub (void const *info)
{
	if (cfallocator_release_call_back_entry.a_class != NULL && cfallocator_release_call_back_entry.feature != NULL)
	{
		cfallocator_release_call_back_entry.feature (eif_access(cfallocator_release_call_back_entry.a_class), info);
	}
}

void set_cfallocator_release_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_release_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_release_call_back_entry.feature = (cfallocator_release_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_release_call_back_stub ()
{
	return (void*) cfallocator_release_call_back_stub;
}

void call_cfallocator_release_call_back (void *a_function, void const *info)
{
	((void (*) (void const *info))a_function) (info);
}

struct cfallocator_copy_description_call_back_entry_struct cfallocator_copy_description_call_back_entry = {NULL, NULL};

CFStringRef cfallocator_copy_description_call_back_stub (void const *info)
{
	if (cfallocator_copy_description_call_back_entry.a_class != NULL && cfallocator_copy_description_call_back_entry.feature != NULL)
	{
		return cfallocator_copy_description_call_back_entry.feature (eif_access(cfallocator_copy_description_call_back_entry.a_class), info);
	}
}

void set_cfallocator_copy_description_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_copy_description_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_copy_description_call_back_entry.feature = (cfallocator_copy_description_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_copy_description_call_back_stub ()
{
	return (void*) cfallocator_copy_description_call_back_stub;
}

CFStringRef call_cfallocator_copy_description_call_back (void *a_function, void const *info)
{
	return ((CFStringRef (*) (void const *info))a_function) (info);
}

struct cfallocator_allocate_call_back_entry_struct cfallocator_allocate_call_back_entry = {NULL, NULL};

void *cfallocator_allocate_call_back_stub (CFIndex allocSize, CFOptionFlags hint, void *info)
{
	if (cfallocator_allocate_call_back_entry.a_class != NULL && cfallocator_allocate_call_back_entry.feature != NULL)
	{
		return cfallocator_allocate_call_back_entry.feature (eif_access(cfallocator_allocate_call_back_entry.a_class), allocSize, hint, info);
	}
}

void set_cfallocator_allocate_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_allocate_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_allocate_call_back_entry.feature = (cfallocator_allocate_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_allocate_call_back_stub ()
{
	return (void*) cfallocator_allocate_call_back_stub;
}

void *call_cfallocator_allocate_call_back (void *a_function, CFIndex allocSize, CFOptionFlags hint, void *info)
{
	return ((void *(*) (CFIndex allocSize, CFOptionFlags hint, void *info))a_function) (allocSize, hint, info);
}

struct cfallocator_reallocate_call_back_entry_struct cfallocator_reallocate_call_back_entry = {NULL, NULL};

void *cfallocator_reallocate_call_back_stub (void *ptr, CFIndex newsize, CFOptionFlags hint, void *info)
{
	if (cfallocator_reallocate_call_back_entry.a_class != NULL && cfallocator_reallocate_call_back_entry.feature != NULL)
	{
		return cfallocator_reallocate_call_back_entry.feature (eif_access(cfallocator_reallocate_call_back_entry.a_class), ptr, newsize, hint, info);
	}
}

void set_cfallocator_reallocate_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_reallocate_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_reallocate_call_back_entry.feature = (cfallocator_reallocate_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_reallocate_call_back_stub ()
{
	return (void*) cfallocator_reallocate_call_back_stub;
}

void *call_cfallocator_reallocate_call_back (void *a_function, void *ptr, CFIndex newsize, CFOptionFlags hint, void *info)
{
	return ((void *(*) (void *ptr, CFIndex newsize, CFOptionFlags hint, void *info))a_function) (ptr, newsize, hint, info);
}

struct cfallocator_deallocate_call_back_entry_struct cfallocator_deallocate_call_back_entry = {NULL, NULL};

void cfallocator_deallocate_call_back_stub (void *ptr, void *info)
{
	if (cfallocator_deallocate_call_back_entry.a_class != NULL && cfallocator_deallocate_call_back_entry.feature != NULL)
	{
		cfallocator_deallocate_call_back_entry.feature (eif_access(cfallocator_deallocate_call_back_entry.a_class), ptr, info);
	}
}

void set_cfallocator_deallocate_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_deallocate_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_deallocate_call_back_entry.feature = (cfallocator_deallocate_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_deallocate_call_back_stub ()
{
	return (void*) cfallocator_deallocate_call_back_stub;
}

void call_cfallocator_deallocate_call_back (void *a_function, void *ptr, void *info)
{
	((void (*) (void *ptr, void *info))a_function) (ptr, info);
}

struct cfallocator_preferred_size_call_back_entry_struct cfallocator_preferred_size_call_back_entry = {NULL, NULL};

CFIndex cfallocator_preferred_size_call_back_stub (CFIndex size, CFOptionFlags hint, void *info)
{
	if (cfallocator_preferred_size_call_back_entry.a_class != NULL && cfallocator_preferred_size_call_back_entry.feature != NULL)
	{
		return cfallocator_preferred_size_call_back_entry.feature (eif_access(cfallocator_preferred_size_call_back_entry.a_class), size, hint, info);
	}
}

void set_cfallocator_preferred_size_call_back_entry (void* a_class, void* a_feature)
{
	cfallocator_preferred_size_call_back_entry.a_class = eif_adopt(a_class);
	cfallocator_preferred_size_call_back_entry.feature = (cfallocator_preferred_size_call_back_eiffel_feature) a_feature;
}

void* get_cfallocator_preferred_size_call_back_stub ()
{
	return (void*) cfallocator_preferred_size_call_back_stub;
}

CFIndex call_cfallocator_preferred_size_call_back (void *a_function, CFIndex size, CFOptionFlags hint, void *info)
{
	return ((CFIndex (*) (CFIndex size, CFOptionFlags hint, void *info))a_function) (size, hint, info);
}

struct cgdata_provider_get_bytes_callback_entry_struct cgdata_provider_get_bytes_callback_entry = {NULL, NULL};

size_t cgdata_provider_get_bytes_callback_stub (void *info, void *buffer, size_t count)
{
	if (cgdata_provider_get_bytes_callback_entry.a_class != NULL && cgdata_provider_get_bytes_callback_entry.feature != NULL)
	{
		return cgdata_provider_get_bytes_callback_entry.feature (eif_access(cgdata_provider_get_bytes_callback_entry.a_class), info, buffer, count);
	}
}

void set_cgdata_provider_get_bytes_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_get_bytes_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_get_bytes_callback_entry.feature = (cgdata_provider_get_bytes_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_get_bytes_callback_stub ()
{
	return (void*) cgdata_provider_get_bytes_callback_stub;
}

size_t call_cgdata_provider_get_bytes_callback (void *a_function, void *info, void *buffer, size_t count)
{
	return ((size_t (*) (void *info, void *buffer, size_t count))a_function) (info, buffer, count);
}

struct cgdata_provider_skip_bytes_callback_entry_struct cgdata_provider_skip_bytes_callback_entry = {NULL, NULL};

void cgdata_provider_skip_bytes_callback_stub (void *info, size_t count)
{
	if (cgdata_provider_skip_bytes_callback_entry.a_class != NULL && cgdata_provider_skip_bytes_callback_entry.feature != NULL)
	{
		cgdata_provider_skip_bytes_callback_entry.feature (eif_access(cgdata_provider_skip_bytes_callback_entry.a_class), info, count);
	}
}

void set_cgdata_provider_skip_bytes_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_skip_bytes_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_skip_bytes_callback_entry.feature = (cgdata_provider_skip_bytes_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_skip_bytes_callback_stub ()
{
	return (void*) cgdata_provider_skip_bytes_callback_stub;
}

void call_cgdata_provider_skip_bytes_callback (void *a_function, void *info, size_t count)
{
	((void (*) (void *info, size_t count))a_function) (info, count);
}

struct wsclient_context_release_call_back_proc_ptr_entry_struct wsclient_context_release_call_back_proc_ptr_entry = {NULL, NULL};

void wsclient_context_release_call_back_proc_ptr_stub (void *info)
{
	if (wsclient_context_release_call_back_proc_ptr_entry.a_class != NULL && wsclient_context_release_call_back_proc_ptr_entry.feature != NULL)
	{
		wsclient_context_release_call_back_proc_ptr_entry.feature (eif_access(wsclient_context_release_call_back_proc_ptr_entry.a_class), info);
	}
}

void set_wsclient_context_release_call_back_proc_ptr_entry (void* a_class, void* a_feature)
{
	wsclient_context_release_call_back_proc_ptr_entry.a_class = eif_adopt(a_class);
	wsclient_context_release_call_back_proc_ptr_entry.feature = (wsclient_context_release_call_back_proc_ptr_eiffel_feature) a_feature;
}

void* get_wsclient_context_release_call_back_proc_ptr_stub ()
{
	return (void*) wsclient_context_release_call_back_proc_ptr_stub;
}

void call_wsclient_context_release_call_back_proc_ptr (void *a_function, void *info)
{
	((void (*) (void *info))a_function) (info);
}

struct cgdata_provider_get_byte_pointer_callback_entry_struct cgdata_provider_get_byte_pointer_callback_entry = {NULL, NULL};

void const *cgdata_provider_get_byte_pointer_callback_stub (void *info)
{
	if (cgdata_provider_get_byte_pointer_callback_entry.a_class != NULL && cgdata_provider_get_byte_pointer_callback_entry.feature != NULL)
	{
		return cgdata_provider_get_byte_pointer_callback_entry.feature (eif_access(cgdata_provider_get_byte_pointer_callback_entry.a_class), info);
	}
}

void set_cgdata_provider_get_byte_pointer_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_get_byte_pointer_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_get_byte_pointer_callback_entry.feature = (cgdata_provider_get_byte_pointer_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_get_byte_pointer_callback_stub ()
{
	return (void*) cgdata_provider_get_byte_pointer_callback_stub;
}

void const *call_cgdata_provider_get_byte_pointer_callback (void *a_function, void *info)
{
	return ((void const *(*) (void *info))a_function) (info);
}

struct cgdata_provider_release_byte_pointer_callback_entry_struct cgdata_provider_release_byte_pointer_callback_entry = {NULL, NULL};

void cgdata_provider_release_byte_pointer_callback_stub (void *info, void const *pointer)
{
	if (cgdata_provider_release_byte_pointer_callback_entry.a_class != NULL && cgdata_provider_release_byte_pointer_callback_entry.feature != NULL)
	{
		cgdata_provider_release_byte_pointer_callback_entry.feature (eif_access(cgdata_provider_release_byte_pointer_callback_entry.a_class), info, pointer);
	}
}

void set_cgdata_provider_release_byte_pointer_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_release_byte_pointer_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_release_byte_pointer_callback_entry.feature = (cgdata_provider_release_byte_pointer_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_release_byte_pointer_callback_stub ()
{
	return (void*) cgdata_provider_release_byte_pointer_callback_stub;
}

void call_cgdata_provider_release_byte_pointer_callback (void *a_function, void *info, void const *pointer)
{
	((void (*) (void *info, void const *pointer))a_function) (info, pointer);
}

struct cgdata_provider_get_bytes_at_offset_callback_entry_struct cgdata_provider_get_bytes_at_offset_callback_entry = {NULL, NULL};

size_t cgdata_provider_get_bytes_at_offset_callback_stub (void *info, void *buffer, size_t offset, size_t count)
{
	if (cgdata_provider_get_bytes_at_offset_callback_entry.a_class != NULL && cgdata_provider_get_bytes_at_offset_callback_entry.feature != NULL)
	{
		return cgdata_provider_get_bytes_at_offset_callback_entry.feature (eif_access(cgdata_provider_get_bytes_at_offset_callback_entry.a_class), info, buffer, offset, count);
	}
}

void set_cgdata_provider_get_bytes_at_offset_callback_entry (void* a_class, void* a_feature)
{
	cgdata_provider_get_bytes_at_offset_callback_entry.a_class = eif_adopt(a_class);
	cgdata_provider_get_bytes_at_offset_callback_entry.feature = (cgdata_provider_get_bytes_at_offset_callback_eiffel_feature) a_feature;
}

void* get_cgdata_provider_get_bytes_at_offset_callback_stub ()
{
	return (void*) cgdata_provider_get_bytes_at_offset_callback_stub;
}

size_t call_cgdata_provider_get_bytes_at_offset_callback (void *a_function, void *info, void *buffer, size_t offset, size_t count)
{
	return ((size_t (*) (void *info, void *buffer, size_t offset, size_t count))a_function) (info, buffer, offset, count);
}

struct qdprinter_status_proc_ptr_entry_struct qdprinter_status_proc_ptr_entry = {NULL, NULL};

OSStatus qdprinter_status_proc_ptr_stub (PrinterStatusOpcode opcode, CGrafPtr currentPort, void *printerStatus)
{
	if (qdprinter_status_proc_ptr_entry.a_class != NULL && qdprinter_status_proc_ptr_entry.feature != NULL)
	{
		return qdprinter_status_proc_ptr_entry.feature (eif_access(qdprinter_status_proc_ptr_entry.a_class), opcode, currentPort, printerStatus);
	}
}

void set_qdprinter_status_proc_ptr_entry (void* a_class, void* a_feature)
{
	qdprinter_status_proc_ptr_entry.a_class = eif_adopt(a_class);
	qdprinter_status_proc_ptr_entry.feature = (qdprinter_status_proc_ptr_eiffel_feature) a_feature;
}

void* get_qdprinter_status_proc_ptr_stub ()
{
	return (void*) qdprinter_status_proc_ptr_stub;
}

OSStatus call_qdprinter_status_proc_ptr (void *a_function, PrinterStatusOpcode opcode, CGrafPtr currentPort, void *printerStatus)
{
	return ((OSStatus (*) (PrinterStatusOpcode opcode, CGrafPtr currentPort, void *printerStatus))a_function) (opcode, currentPort, printerStatus);
}

struct get_next_event_filter_proc_ptr_entry_struct get_next_event_filter_proc_ptr_entry = {NULL, NULL};

void get_next_event_filter_proc_ptr_stub (EventRecord *theEvent, Boolean *result)
{
	if (get_next_event_filter_proc_ptr_entry.a_class != NULL && get_next_event_filter_proc_ptr_entry.feature != NULL)
	{
		get_next_event_filter_proc_ptr_entry.feature (eif_access(get_next_event_filter_proc_ptr_entry.a_class), theEvent, result);
	}
}

void set_get_next_event_filter_proc_ptr_entry (void* a_class, void* a_feature)
{
	get_next_event_filter_proc_ptr_entry.a_class = eif_adopt(a_class);
	get_next_event_filter_proc_ptr_entry.feature = (get_next_event_filter_proc_ptr_eiffel_feature) a_feature;
}

void* get_get_next_event_filter_proc_ptr_stub ()
{
	return (void*) get_next_event_filter_proc_ptr_stub;
}

void call_get_next_event_filter_proc_ptr (void *a_function, EventRecord *theEvent, Boolean *result)
{
	((void (*) (EventRecord *theEvent, Boolean *result))a_function) (theEvent, result);
}

struct menu_bar_def_proc_ptr_entry_struct menu_bar_def_proc_ptr_entry = {NULL, NULL};

long menu_bar_def_proc_ptr_stub (short selector, short message, short parameter1, long parameter2)
{
	if (menu_bar_def_proc_ptr_entry.a_class != NULL && menu_bar_def_proc_ptr_entry.feature != NULL)
	{
		return menu_bar_def_proc_ptr_entry.feature (eif_access(menu_bar_def_proc_ptr_entry.a_class), selector, message, parameter1, parameter2);
	}
}

void set_menu_bar_def_proc_ptr_entry (void* a_class, void* a_feature)
{
	menu_bar_def_proc_ptr_entry.a_class = eif_adopt(a_class);
	menu_bar_def_proc_ptr_entry.feature = (menu_bar_def_proc_ptr_eiffel_feature) a_feature;
}

void* get_menu_bar_def_proc_ptr_stub ()
{
	return (void*) menu_bar_def_proc_ptr_stub;
}

long call_menu_bar_def_proc_ptr (void *a_function, short selector, short message, short parameter1, long parameter2)
{
	return ((long (*) (short selector, short message, short parameter1, long parameter2))a_function) (selector, message, parameter1, parameter2);
}

struct mbar_hook_proc_ptr_entry_struct mbar_hook_proc_ptr_entry = {NULL, NULL};

short mbar_hook_proc_ptr_stub (Rect *menuRect)
{
	if (mbar_hook_proc_ptr_entry.a_class != NULL && mbar_hook_proc_ptr_entry.feature != NULL)
	{
		return mbar_hook_proc_ptr_entry.feature (eif_access(mbar_hook_proc_ptr_entry.a_class), menuRect);
	}
}

void set_mbar_hook_proc_ptr_entry (void* a_class, void* a_feature)
{
	mbar_hook_proc_ptr_entry.a_class = eif_adopt(a_class);
	mbar_hook_proc_ptr_entry.feature = (mbar_hook_proc_ptr_eiffel_feature) a_feature;
}

void* get_mbar_hook_proc_ptr_stub ()
{
	return (void*) mbar_hook_proc_ptr_stub;
}

short call_mbar_hook_proc_ptr (void *a_function, Rect *menuRect)
{
	return ((short (*) (Rect *menuRect))a_function) (menuRect);
}

struct sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry_struct sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry = {NULL, NULL};

SInt32 sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_stub (void *thisPointer, CFUUIDBytes iid, void **ppv)
{
	if (sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.a_class != NULL && sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.feature != NULL)
	{
		return sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.feature (eif_access(sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.a_class), thisPointer, iid, ppv);
	}
}

void set_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry (void* a_class, void* a_feature)
{
	sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.a_class = eif_adopt(a_class);
	sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_entry.feature = (sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_eiffel_feature) a_feature;
}

void* get_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_stub ()
{
	return (void*) sint32_voidp_cfuuidbytes_voidpp_anonymous_callback_stub;
}

SInt32 call_sint32_voidp_cfuuidbytes_voidpp_anonymous_callback (void *a_function, void *thisPointer, CFUUIDBytes iid, void **ppv)
{
	return ((SInt32 (*) (void *thisPointer, CFUUIDBytes iid, void **ppv))a_function) (thisPointer, iid, ppv);
}

struct uint32_voidp_anonymous_callback_entry_struct uint32_voidp_anonymous_callback_entry = {NULL, NULL};

UInt32 uint32_voidp_anonymous_callback_stub (void *thisPointer)
{
	if (uint32_voidp_anonymous_callback_entry.a_class != NULL && uint32_voidp_anonymous_callback_entry.feature != NULL)
	{
		return uint32_voidp_anonymous_callback_entry.feature (eif_access(uint32_voidp_anonymous_callback_entry.a_class), thisPointer);
	}
}

void set_uint32_voidp_anonymous_callback_entry (void* a_class, void* a_feature)
{
	uint32_voidp_anonymous_callback_entry.a_class = eif_adopt(a_class);
	uint32_voidp_anonymous_callback_entry.feature = (uint32_voidp_anonymous_callback_eiffel_feature) a_feature;
}

void* get_uint32_voidp_anonymous_callback_stub ()
{
	return (void*) uint32_voidp_anonymous_callback_stub;
}

UInt32 call_uint32_voidp_anonymous_callback (void *a_function, void *thisPointer)
{
	return ((UInt32 (*) (void *thisPointer))a_function) (thisPointer);
}

struct osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry_struct osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry = {NULL, NULL};

OSStatus osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_stub (void *thisInstance, AEDesc const *inContext, AEDescList *outCommandPairs)
{
	if (osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.a_class != NULL && osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.feature != NULL)
	{
		return osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.feature (eif_access(osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.a_class), thisInstance, inContext, outCommandPairs);
	}
}

void set_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry (void* a_class, void* a_feature)
{
	osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.a_class = eif_adopt(a_class);
	osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_entry.feature = (osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_eiffel_feature) a_feature;
}

void* get_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_stub ()
{
	return (void*) osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback_stub;
}

OSStatus call_osstatus_voidp_aedescconstp_aedesclistp_anonymous_callback (void *a_function, void *thisInstance, AEDesc const *inContext, AEDescList *outCommandPairs)
{
	return ((OSStatus (*) (void *thisInstance, AEDesc const *inContext, AEDescList *outCommandPairs))a_function) (thisInstance, inContext, outCommandPairs);
}

struct osstatus_voidp_aedescp_sint32_anonymous_callback_entry_struct osstatus_voidp_aedescp_sint32_anonymous_callback_entry = {NULL, NULL};

OSStatus osstatus_voidp_aedescp_sint32_anonymous_callback_stub (void *thisInstance, AEDesc *inContext, SInt32 inCommandID)
{
	if (osstatus_voidp_aedescp_sint32_anonymous_callback_entry.a_class != NULL && osstatus_voidp_aedescp_sint32_anonymous_callback_entry.feature != NULL)
	{
		return osstatus_voidp_aedescp_sint32_anonymous_callback_entry.feature (eif_access(osstatus_voidp_aedescp_sint32_anonymous_callback_entry.a_class), thisInstance, inContext, inCommandID);
	}
}

void set_osstatus_voidp_aedescp_sint32_anonymous_callback_entry (void* a_class, void* a_feature)
{
	osstatus_voidp_aedescp_sint32_anonymous_callback_entry.a_class = eif_adopt(a_class);
	osstatus_voidp_aedescp_sint32_anonymous_callback_entry.feature = (osstatus_voidp_aedescp_sint32_anonymous_callback_eiffel_feature) a_feature;
}

void* get_osstatus_voidp_aedescp_sint32_anonymous_callback_stub ()
{
	return (void*) osstatus_voidp_aedescp_sint32_anonymous_callback_stub;
}

OSStatus call_osstatus_voidp_aedescp_sint32_anonymous_callback (void *a_function, void *thisInstance, AEDesc *inContext, SInt32 inCommandID)
{
	return ((OSStatus (*) (void *thisInstance, AEDesc *inContext, SInt32 inCommandID))a_function) (thisInstance, inContext, inCommandID);
}

struct void_voidp_anonymous_callback_entry_struct void_voidp_anonymous_callback_entry = {NULL, NULL};

void void_voidp_anonymous_callback_stub (void *thisInstance)
{
	if (void_voidp_anonymous_callback_entry.a_class != NULL && void_voidp_anonymous_callback_entry.feature != NULL)
	{
		void_voidp_anonymous_callback_entry.feature (eif_access(void_voidp_anonymous_callback_entry.a_class), thisInstance);
	}
}

void set_void_voidp_anonymous_callback_entry (void* a_class, void* a_feature)
{
	void_voidp_anonymous_callback_entry.a_class = eif_adopt(a_class);
	void_voidp_anonymous_callback_entry.feature = (void_voidp_anonymous_callback_eiffel_feature) a_feature;
}

void* get_void_voidp_anonymous_callback_stub ()
{
	return (void*) void_voidp_anonymous_callback_stub;
}

void call_void_voidp_anonymous_callback (void *a_function, void *thisInstance)
{
	((void (*) (void *thisInstance))a_function) (thisInstance);
}

struct desk_hook_proc_ptr_entry_struct desk_hook_proc_ptr_entry = {NULL, NULL};

void desk_hook_proc_ptr_stub (Boolean mouseClick, EventRecord *theEvent)
{
	if (desk_hook_proc_ptr_entry.a_class != NULL && desk_hook_proc_ptr_entry.feature != NULL)
	{
		desk_hook_proc_ptr_entry.feature (eif_access(desk_hook_proc_ptr_entry.a_class), mouseClick, theEvent);
	}
}

void set_desk_hook_proc_ptr_entry (void* a_class, void* a_feature)
{
	desk_hook_proc_ptr_entry.a_class = eif_adopt(a_class);
	desk_hook_proc_ptr_entry.feature = (desk_hook_proc_ptr_eiffel_feature) a_feature;
}

void* get_desk_hook_proc_ptr_stub ()
{
	return (void*) desk_hook_proc_ptr_stub;
}

void call_desk_hook_proc_ptr (void *a_function, Boolean mouseClick, EventRecord *theEvent)
{
	((void (*) (Boolean mouseClick, EventRecord *theEvent))a_function) (mouseClick, theEvent);
}

