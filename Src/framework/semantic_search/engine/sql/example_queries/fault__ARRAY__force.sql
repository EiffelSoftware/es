/* Analyze the fault in ARRAY.force */

SELECT q.qry_id, q.class, q.feature, q.fault_signature, q.exception_tag, q.exception_recipient, q.hit_breakpoints, i.value as "i", p1.value as "pre::a.lower", p2.value as "pre::a.upper", p3.value as "pre::a.count"

FROM
Queryables q, PropertyBindings1 a, PropertyBindings1 i, PropertyBindings1 p1, PropertyBindings1 p2, PropertyBindings1 p3

WHERE
q.class = "ARRAY" AND
q.feature = "force" AND
q.hit_breakpoints LIKE "%15%"
/* AND q.transition_status = 2 */

AND
a.qry_id = q.qry_id AND
a.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
a.prop_kind = 2 AND
a.position = 0

AND
i.qry_id = q.qry_id AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
i.prop_kind = 2 AND
i.position = 2

/* p1: pre: a.lower */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.lower") AND
p1.prop_kind = 2 AND
p1.var1 = a.var1

/* p2: pre: a.upper */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.upper") AND
p2.prop_kind = 2 AND
p2.var1 = a.var1

/* p3: pre: a.count */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p3.prop_kind = 2 AND
p3.var1 = a.var1

