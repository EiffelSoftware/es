SELECT q.qry_id, q.class, q.feature, q.fault_signature, q.exception_tag, q.exception_recipient

FROM
Queryables q

WHERE
q.transition_status = 1
GROUP BY q.fault_signature





