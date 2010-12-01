/* Analyze fault: ARRAY.force */

SELECT q.feature, q.content, q.qry_id, q.uuid, q.fault_signature, q.exception_tag, q.hit_breakpoints, p1.value as "a.lower", p2.value as "a.upper", i.value as "i", i.value < p1.value, v.value as "v"
FROM
Queryables q, PropertyBindings1 a, PropertyBindings1 i, PropertyBindings1 v, PropertyBindings1 p1, PropertyBindings1 p2
WHERE

/* ARRAY.force */
q.feature = "force" AND
q.class = "ARRAY" AND
q.exception_tag = "inserted"

/*AND q.exception_tag = "inserted"*/

/* Target a */
AND
a.qry_id = q.qry_id AND
a.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
a.prop_kind = 2 AND
a.position = 0

/* Argument i */
AND
i.qry_id = q.qry_id AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
i.prop_kind = 2 AND
i.position = 2

/* Argument v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v.prop_kind = 2 AND
v.position = 1

/* Property p1: pre a.lower */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.lower") AND
p1.prop_kind = 2 AND
p1.var1 = a.var1

/* Property p2: pre a.upper */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.upper") AND
p2.prop_kind = 2 AND
p2.var1 = a.var1

/* Property p3: by: a.occurrences (v) */
/*
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.occurrences ($)") AND
p3.prop_kind = 5 AND
p3.var1 = a.var1 AND
p3.var2 = v.var1
*/