(in-package #:gs-session-action-ledger)

(defun db-spec ()
  (list :database (required-env "GS_SAL_DB_NAME")
        :user (required-env "GS_SAL_DB_USER")
        :password (required-env "GS_SAL_DB_PASSWORD")
        :host (env-or-default "GS_SAL_DB_HOST" "db-acupinir.groupscholar.com")
        :port (parse-int (env-or-default "GS_SAL_DB_PORT" "23947") :default 23947)
        :sslmode (env-or-default "GS_SAL_DB_SSLMODE" "require")))

(defmacro with-db (() &body body)
  `(postmodern:with-connection (db-spec)
     ,@body))

(defun add-session (session-date session-type mentor scholar notes)
  (with-db ()
    (postmodern:query
     "insert into gs_session_action_ledger.sessions (session_date, session_type, mentor, scholar, notes)
      values ($1, $2, $3, $4, $5) returning id"
     (list session-date session-type mentor scholar notes)
     :single)))

(defun add-action (session-id owner due-date status description)
  (with-db ()
    (postmodern:query
     "insert into gs_session_action_ledger.action_items
      (session_id, owner, due_date, status, description)
      values ($1, $2, $3, $4, $5) returning id"
     (list session-id owner due-date status description)
     :single)))

(defun close-action (action-id)
  (with-db ()
    (postmodern:execute
     "update gs_session_action_ledger.action_items set status = 'closed' where id = $1"
     (list action-id))))

(defun list-actions (&optional status)
  (with-db ()
    (if status
        (postmodern:query
         "select ai.id, ai.status, ai.due_date, ai.owner, ai.description,
                 s.session_date, s.session_type, s.mentor, s.scholar
            from gs_session_action_ledger.action_items ai
            join gs_session_action_ledger.sessions s on s.id = ai.session_id
           where ai.status = $1
        order by ai.due_date nulls last, ai.id"
         (list status))
        (postmodern:query
         "select ai.id, ai.status, ai.due_date, ai.owner, ai.description,
                 s.session_date, s.session_type, s.mentor, s.scholar
            from gs_session_action_ledger.action_items ai
            join gs_session_action_ledger.sessions s on s.id = ai.session_id
        order by ai.due_date nulls last, ai.id"))))

(defun summary ()
  (with-db ()
    (let ((by-status (postmodern:query
                      "select status, count(*) from gs_session_action_ledger.action_items group by status"))
          (due-soon (postmodern:query
                     "select count(*) from gs_session_action_ledger.action_items
                       where status = 'open' and due_date <= (current_date + interval '14 days')")))
      (list by-status due-soon))))
