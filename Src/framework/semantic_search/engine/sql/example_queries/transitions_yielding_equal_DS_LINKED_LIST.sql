SELECT q.qry_id, q.class, q.feature, q.fault_signature, v1.position as "v1", v2.position as "v2", u1.position as "u1", u2.position as "u2", v1.equal_value "v1.obj", v2.equal_value as "v2.obj", u1.equal_value as "u1.obj", u2.equal_value as "u2.obj",v1.value "v1.ref", v2.value as "v2.ref", u1.value as "u1.ref", u2.value as "u2.ref"
FROM
Queryables q, PropertyBindings1 v1, PropertyBindings1 v2, PropertyBindings1 u1, PropertyBindings1 u2, PropertyBindings1 p1

WHERE
q.class = "DS_LINKED_LIST" AND
q.transition_status = 2

/* One operand1 in prestate */
AND
v1.qry_id = q.qry_id AND
v1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v1.prop_kind = 2 AND
v1.position BETWEEN 0 AND q.operand_count - 1

/* One operand2 in prestate */
AND
v2.qry_id = q.qry_id AND
v2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
v2.prop_kind = 2 AND
v2.position BETWEEN 0 AND q.operand_count - 1 AND
v2.position != v1.position

/* In pre-state v1 is not object-equal to v2 */
AND
v1.equal_value != v2.equal_value

/* One operand1 in poststate */
AND
u1.qry_id = q.qry_id AND
u1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
u1.prop_kind = 3 AND
u1.position = v1.position

/* One operand2 in poststate */
AND
u2.qry_id = q.qry_id AND
u2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
u2.prop_kind = 3 AND
u2.position = v2.position

/* In post-state u1 is object-equal to u2 */
AND
u1.equal_value = u2.equal_value

/* Property p1: post:: not v1.is_empty */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.is_empty") AND
p1.prop_kind = 2 AND
p1.var1 = u1.var1 AND
p1.value = 0 AND

v1.value != v2.value AND
v1.value_type_kind = 0 AND
v2.value_type_kind = 0 

GROUP BY q.feature




