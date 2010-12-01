SELECT 
q.qry_id, q.class, q.feature, q.exception_recipient as "recipient", q.exception_tag as "tag", q.fault_signature, 
l.value as "l", o.value as "o", p3.value as "pre::l.count", p2.value as "pre::o.count", p4.value "pre::c.index", p6.value as "pre::c.after", 
p7.value as "pre::c.is_first"

FROM
Queryables q, PropertyBindings1 l, PropertyBindings1 o, PropertyBindings1 c, PropertyBindings1 p1, PropertyBindings1 p2, PropertyBindings1 p3, PropertyBindings1 p4, PropertyBindings1 p6,
PropertyBindings1 p7

WHERE
q.class = "DS_LINKED_LIST" AND
q.feature = "extend_left_cursor" AND
q.exception_recipient = "extend_first"

/* Target list l */
AND
l.qry_id = q.qry_id AND
l.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
l.prop_kind = 2 AND
l.position = 0

/* First argument o */
AND
o.qry_id = q.qry_id AND
o.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
o.prop_kind = 2 AND
o.position = 1

/* second argument c */
AND
c.qry_id = q.qry_id AND
c.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
c.prop_kind = 2 AND
c.position = 2

/* Property p1: pre:: o.is_empty */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_empty") AND
p1.prop_kind = 2 AND
p1.var1 = o.var1 AND
(p1.value = 0 or p1.value = 1)

/* Property p2: pre:: o.count */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p2.prop_kind = 2 AND
p2.var1 = o.var1

/* Property p3: pre:: l.count */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p3.prop_kind = 2 AND
p3.var1 = l.var1

/* Property: pre: l = o */
/*AND
l.value = o.value
*/
/* Property p4: pre:: c.index */
AND
p4.qry_id = q.qry_id AND
p4.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND
p4.prop_kind = 2 AND
p4.var1 = c.var1



/* Property p6: pre:: c.after */
AND
p6.qry_id = q.qry_id AND
p6.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.after") AND
p6.prop_kind = 2 AND
p6.var1 = c.var1

/* Property p7: pre:: c.is_first */
AND
p7.qry_id = q.qry_id AND
p7.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_first") AND
p7.prop_kind = 2 AND
p7.var1 = c.var1