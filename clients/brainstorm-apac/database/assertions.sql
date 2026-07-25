SET search_path TO public;

DO $$
DECLARE
  failures text[] := ARRAY[]::text[];
BEGIN
  IF (SELECT count(*) FROM companies) <> 6 THEN failures := array_append(failures, 'companies != 6'); END IF;
  IF (SELECT count(*) FROM company_snapshots) <> 78 THEN failures := array_append(failures, 'company_snapshots != 78'); END IF;
  IF (SELECT count(*) FROM users) <> 108 THEN failures := array_append(failures, 'users != 108'); END IF;
  IF (SELECT count(*) FROM case_managers) <> 6 THEN failures := array_append(failures, 'case_managers != 6'); END IF;
  IF (SELECT count(*) FROM speakup_managers) <> 6 THEN failures := array_append(failures, 'speakup_managers != 6'); END IF;
  IF EXISTS (SELECT 1 FROM companies c LEFT JOIN company_snapshots s ON s.company_id = c.id GROUP BY c.id HAVING count(s.*) <> 13) THEN failures := array_append(failures, 'snapshots per company != 13'); END IF;
  IF (SELECT count(*) FROM cases) <> 180 THEN failures := array_append(failures, 'cases != 180'); END IF;
  IF (SELECT count(*) FROM speakup) <> 120 THEN failures := array_append(failures, 'speakup != 120'); END IF;
  IF (SELECT count(*) FROM case_events) <> 312 THEN failures := array_append(failures, 'case_events != 312'); END IF;
  IF (SELECT count(*) FROM speakup_events) <> 402 THEN failures := array_append(failures, 'speakup_events != 402'); END IF;
  IF (SELECT count(*) FROM cases WHERE created_at >= TIMESTAMP '2025-07-01 00:00:00' AND created_at < TIMESTAMP '2026-07-01 00:00:00') <> 180
    OR (SELECT count(*) FROM speakup WHERE submitted_at >= TIMESTAMP '2025-07-01 00:00:00' AND submitted_at < TIMESTAMP '2026-07-01 00:00:00') <> 120
  THEN failures := array_append(failures, 'default reporting window totals mismatch'); END IF;
  IF EXISTS (SELECT 1 FROM cases WHERE created_at >= TIMESTAMP '2026-07-01 00:00:00' OR last_updated_at >= TIMESTAMP '2026-07-01 00:00:00' OR target_closure_date >= DATE '2026-07-01')
    OR EXISTS (SELECT 1 FROM case_events WHERE created_at >= TIMESTAMP '2026-07-01 00:00:00')
    OR EXISTS (SELECT 1 FROM speakup WHERE created_at >= TIMESTAMP '2026-07-01 00:00:00' OR submitted_at >= TIMESTAMP '2026-07-01 00:00:00' OR closed_at >= TIMESTAMP '2026-07-01 00:00:00')
    OR EXISTS (SELECT 1 FROM speakup_events WHERE created_at >= TIMESTAMP '2026-07-01 00:00:00')
  THEN failures := array_append(failures, 'activity at or after analytical cutoff'); END IF;

  -- Pinned @dbml/cli@8.3.1 compilation proves all 9 PK and 18 FK definitions
  -- in the source DBML. RunSQL's CSV loader creates 0 physical PKs and 0 FKs;
  -- these assertions enforce the logical RI, lifecycle and tenant contracts.
  IF EXISTS (SELECT 1 FROM company_snapshots s LEFT JOIN companies c ON c.id=s.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM users u LEFT JOIN companies c ON c.id=u.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM case_managers m LEFT JOIN companies c ON c.id=m.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup_managers m LEFT JOIN companies c ON c.id=m.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM cases x LEFT JOIN companies c ON c.id=x.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM cases x LEFT JOIN case_managers m ON m.id=x.manager_id WHERE m.id IS NULL)
    OR EXISTS (SELECT 1 FROM cases x LEFT JOIN users u ON u.id=x.reporter_id WHERE u.id IS NULL)
    OR EXISTS (SELECT 1 FROM cases x LEFT JOIN cases original ON original.id=x.duplicate_of_case_id WHERE x.duplicate_of_case_id IS NOT NULL AND original.id IS NULL)
    OR EXISTS (SELECT 1 FROM cases x LEFT JOIN users u ON u.id=x.accused_id WHERE u.id IS NULL)
    OR EXISTS (SELECT 1 FROM case_events e LEFT JOIN cases x ON x.id=e.case_id WHERE x.id IS NULL)
    OR EXISTS (SELECT 1 FROM case_events e LEFT JOIN users u ON u.id=e.actor_user_id WHERE e.actor_user_id IS NOT NULL AND u.id IS NULL)
    OR EXISTS (SELECT 1 FROM case_events e LEFT JOIN case_managers m ON m.id=e.actor_manager_id WHERE e.actor_manager_id IS NOT NULL AND m.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup s LEFT JOIN users u ON u.id=s.user_id WHERE u.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup s LEFT JOIN companies c ON c.id=s.company_id WHERE c.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup s LEFT JOIN speakup_managers m ON m.id=s.manager_id WHERE m.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup_events e LEFT JOIN speakup s ON s.id=e.speakup_id WHERE s.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup_events e LEFT JOIN users u ON u.id=e.actor_user_id WHERE e.actor_user_id IS NOT NULL AND u.id IS NULL)
    OR EXISTS (SELECT 1 FROM speakup_events e LEFT JOIN speakup_managers m ON m.id=e.actor_manager_id WHERE e.actor_manager_id IS NOT NULL AND m.id IS NULL)
  THEN failures := array_append(failures, 'logical referential integrity mismatch'); END IF;

  IF EXISTS (SELECT 1 FROM case_events e JOIN cases c ON c.id=e.case_id WHERE e.created_at < c.created_at)
    OR EXISTS (SELECT 1 FROM speakup_events e JOIN speakup s ON s.id=e.speakup_id WHERE e.created_at < s.submitted_at)
  THEN failures := array_append(failures, 'event before parent submission/creation'); END IF;

  IF EXISTS (
    SELECT 1 FROM case_events e
    WHERE e.event_type='reopen'
      AND NOT EXISTS (SELECT 1 FROM case_events prior WHERE prior.case_id=e.case_id AND prior.event_type='close' AND prior.created_at < e.created_at)
  ) OR EXISTS (
    SELECT 1 FROM case_events e
    WHERE e.event_type='close' AND EXISTS (
      SELECT 1 FROM case_events later WHERE later.case_id=e.case_id AND later.event_type='reopen' AND later.created_at > e.created_at
        AND NOT EXISTS (SELECT 1 FROM case_events final WHERE final.case_id=e.case_id AND final.event_type='close' AND final.created_at > later.created_at)
    )
  ) THEN failures := array_append(failures, 'invalid Case close/reopen sequence'); END IF;

  IF EXISTS (
    SELECT 1 FROM speakup_events e
    WHERE e.event_type='reopen'
      AND NOT EXISTS (SELECT 1 FROM speakup_events prior WHERE prior.speakup_id=e.speakup_id AND prior.event_type='close' AND prior.created_at < e.created_at)
  ) OR EXISTS (
    SELECT 1 FROM speakup_events e
    WHERE e.event_type='close' AND EXISTS (
      SELECT 1 FROM speakup_events later WHERE later.speakup_id=e.speakup_id AND later.event_type='reopen' AND later.created_at > e.created_at
        AND NOT EXISTS (SELECT 1 FROM speakup_events final WHERE final.speakup_id=e.speakup_id AND final.event_type='close' AND final.created_at > later.created_at)
    )
  ) THEN failures := array_append(failures, 'invalid SpeakUp close/reopen sequence'); END IF;

  IF EXISTS (
    SELECT 1 FROM speakup s
    LEFT JOIN LATERAL (SELECT max(created_at) AS final_close FROM speakup_events e WHERE e.speakup_id=s.id AND e.event_type='close') x ON true
    WHERE (s.status='closed') IS DISTINCT FROM (x.final_close IS NOT NULL)
       OR s.closed_at IS DISTINCT FROM x.final_close
  ) THEN failures := array_append(failures, 'speakup current status/closed timestamp mismatch'); END IF;
  IF EXISTS (
    SELECT 1 FROM cases c
    LEFT JOIN LATERAL (SELECT max(created_at) AS final_close FROM case_events e WHERE e.case_id=c.id AND e.event_type='close') x ON true
    WHERE (c.status='Closed') IS DISTINCT FROM (x.final_close IS NOT NULL)
       OR c.last_updated_at < coalesce(x.final_close,c.created_at)
  ) THEN failures := array_append(failures, 'case current status/timestamp mismatch'); END IF;

  IF EXISTS (SELECT 1 FROM cases c JOIN users u ON u.id=c.reporter_id WHERE u.company_id<>c.company_id)
    OR EXISTS (SELECT 1 FROM cases c JOIN users u ON u.id=c.accused_id WHERE u.company_id<>c.company_id)
    OR EXISTS (SELECT 1 FROM cases c JOIN case_managers m ON m.id=c.manager_id WHERE m.company_id<>c.company_id)
    OR EXISTS (SELECT 1 FROM speakup s JOIN users u ON u.id=s.user_id WHERE u.company_id<>s.company_id)
    OR EXISTS (SELECT 1 FROM speakup s JOIN speakup_managers m ON m.id=s.manager_id WHERE m.company_id<>s.company_id)
  THEN failures := array_append(failures, 'parent company inconsistency'); END IF;
  IF EXISTS (SELECT 1 FROM case_events e JOIN cases c ON c.id=e.case_id JOIN users u ON u.id=e.actor_user_id WHERE u.company_id<>c.company_id)
    OR EXISTS (SELECT 1 FROM case_events e JOIN cases c ON c.id=e.case_id JOIN case_managers m ON m.id=e.actor_manager_id WHERE m.company_id<>c.company_id)
    OR EXISTS (SELECT 1 FROM speakup_events e JOIN speakup s ON s.id=e.speakup_id JOIN users u ON u.id=e.actor_user_id WHERE u.company_id<>s.company_id)
    OR EXISTS (SELECT 1 FROM speakup_events e JOIN speakup s ON s.id=e.speakup_id JOIN speakup_managers m ON m.id=e.actor_manager_id WHERE m.company_id<>s.company_id)
  THEN failures := array_append(failures, 'event actor company inconsistency'); END IF;

  IF EXISTS (SELECT 1 FROM users WHERE anonymous AND (synthetic_user_code IS NOT NULL OR role_code<>'REPORTER'))
    OR (SELECT count(*) FROM speakup WHERE anonymous) <> 36
    OR EXISTS (SELECT 1 FROM speakup s JOIN users u ON u.id=s.user_id WHERE s.anonymous IS DISTINCT FROM u.anonymous)
  THEN failures := array_append(failures, 'anonymous-user minimisation/split mismatch'); END IF;
  IF (SELECT count(*) FROM cases WHERE classification='actual') <> 144 OR (SELECT count(*) FROM cases WHERE classification='duplicate') <> 36
    OR EXISTS (SELECT 1 FROM cases d LEFT JOIN cases a ON a.id=d.duplicate_of_case_id WHERE d.classification='duplicate' AND (a.id IS NULL OR a.classification<>'actual' OR a.company_id<>d.company_id OR a.created_at>=d.created_at))
    OR EXISTS (SELECT 1 FROM cases WHERE (classification='duplicate') IS DISTINCT FROM (duplicate_of_case_id IS NOT NULL))
  THEN failures := array_append(failures, 'duplicate lineage/reconciliation mismatch'); END IF;

  IF EXISTS (
    SELECT 1 FROM companies c JOIN company_snapshots s ON s.company_id=c.id AND s.snapshot_month=DATE '2026-07-01'
    WHERE c.month_start_hc<>s.headcount OR c.app_user_hc_current<>s.app_user_hc OR abs(c.adoption_rate_current-(s.app_user_hc::decimal/s.headcount))>0.000001
  ) THEN failures := array_append(failures, 'latest compatibility values mismatch'); END IF;
  IF EXISTS (SELECT 1 FROM cases GROUP BY company_id HAVING count(*)<>30 OR count(*) FILTER (WHERE classification='actual')<>24 OR count(*) FILTER (WHERE classification='duplicate')<>6)
    OR EXISTS (SELECT 1 FROM speakup GROUP BY company_id HAVING count(*)<>20 OR count(*) FILTER (WHERE status='closed')<>15 OR count(*) FILTER (WHERE anonymous)<>6)
    OR (SELECT count(*) FROM speakup WHERE status='closed')<>90
  THEN failures := array_append(failures, 'golden company totals mismatch'); END IF;
  IF (SELECT count(*) FROM speakup_events WHERE event_type='manager_response')<>120
    OR EXISTS (SELECT 1 FROM speakup s WHERE NOT EXISTS (SELECT 1 FROM speakup_events e WHERE e.speakup_id=s.id AND e.event_type='manager_response' AND e.created_at>s.submitted_at))
  THEN failures := array_append(failures, 'first manager response contract mismatch'); END IF;

  IF cardinality(failures)>0 THEN RAISE EXCEPTION 'Brainstorm APAC assertions failed: %', array_to_string(failures, '; '); END IF;
  RAISE NOTICE 'Brainstorm APAC assertions passed';
END $$;
