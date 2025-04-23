create schema if not exists gs_session_action_ledger;

create table if not exists gs_session_action_ledger.sessions (
  id bigserial primary key,
  session_date date not null,
  session_type text not null,
  mentor text,
  scholar text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists gs_session_action_ledger.action_items (
  id bigserial primary key,
  session_id bigint not null references gs_session_action_ledger.sessions(id) on delete cascade,
  owner text not null,
  due_date date,
  status text not null default 'open',
  description text not null,
  created_at timestamptz not null default now()
);

create index if not exists action_items_status_idx
  on gs_session_action_ledger.action_items(status);

create index if not exists action_items_due_date_idx
  on gs_session_action_ledger.action_items(due_date);

insert into gs_session_action_ledger.sessions (session_date, session_type, mentor, scholar, notes)
values
  ('2026-02-02', 'career coaching', 'Alicia Barnes', 'Jordan Lee', 'Discussed internship priorities and networking outreach.'),
  ('2026-02-05', 'check-in', 'Mina Patel', 'Sofia Cruz', 'Reviewed scholarship deadlines and application checklist.'),
  ('2026-02-06', 'academic planning', 'Noah Kim', 'Andre White', 'Mapped spring course plan and tutoring support.');

insert into gs_session_action_ledger.action_items (session_id, owner, due_date, status, description)
values
  (1, 'Jordan Lee', '2026-02-12', 'open', 'Draft outreach email to three alumni contacts.'),
  (1, 'Alicia Barnes', '2026-02-09', 'open', 'Send internship tracker template.'),
  (2, 'Sofia Cruz', '2026-02-15', 'open', 'Complete scholarship personal statement draft.'),
  (2, 'Mina Patel', '2026-02-10', 'closed', 'Share list of recommended essay reviewers.'),
  (3, 'Andre White', '2026-02-18', 'open', 'Book tutoring sessions for calculus support.');
