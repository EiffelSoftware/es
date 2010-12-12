SELECT q.qry_id, q.class, q.feature, q.fault_signature, v.position as "v", u.position as "u"

FROM
Queryables q, PropertyBindings1 v, PropertyBindings1 u, PropertyBindings1 p1, PropertyBindings1 p2

WHERE
q.class = "DS_LINKED_LIST" AND
q.transition_status = 2

/* v in pre-state */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v.prop_kind = 2 AND
v.position = 0 /* If I don't put this constraint, the query becomes very very long. */

/* in pre-state, p1: v.is_empty = True */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_empty") AND
p1.prop_kind = 2 AND
p1.value = 1 AND
p1.var1 = v.var1

/* u in post-state */
AND
u.qry_id = q.qry_id AND
u.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
u.prop_kind = 3 AND
u.position = v.position /* u = v */

/* in post-state, p2: u.is_empty = False */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_empty") AND
p2.prop_kind = 3 AND
p2.value = 0 AND
p2.var1 = u.var1

GROUP BY q.feature




