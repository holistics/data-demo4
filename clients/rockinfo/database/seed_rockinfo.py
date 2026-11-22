#!/usr/bin/env python3
"""Deterministic synthetic seed for the Rockinfo embedded-analytics PoC.

Models a credentialing platform that serves several client organisations
(certification bodies, councils, institutes). Each client is one embedded tenant.

Usage:
  python seed_rockinfo.py --out <dir>             # write DDL + CSVs only
  python seed_rockinfo.py --out <dir> --load      # also load into Postgres

--load reads the connection string from NEON_DEMO_DATABASE_URL and (re)creates
ONLY the schema named by --schema (default rockinfo_demo). Nothing outside that
schema is touched. Requires `psycopg` (pip install "psycopg[binary]").
"""
import argparse
import csv
import math
import os
import random
from datetime import date, datetime, timedelta

SEED = 20261123
AS_OF = date(2026, 11, 21)          # data cutoff (exclusive upper bound is AS_OF + 1)
START = date(2024, 1, 1)

REGIONS = {
    'North America': ['United States', 'Canada'],
    'Latin America': ['Brazil', 'Mexico', 'Colombia'],
    'EMEA': ['United Kingdom', 'Germany', 'South Africa', 'United Arab Emirates'],
    'APAC': ['India', 'Singapore', 'Philippines', 'Japan'],
    'ANZ': ['Australia', 'New Zealand'],
}

# client_id, name, code, industry, hq_country, candidate target, region weights, programs
# program: name, type, recert_months (None = no expiry), exam fee USD (0 = no paid exam),
#          exam pass base, course topics
CLIENTS = [
    (101, 'Apex Cloud Academy', 'APX', 'Technology vendor certification', 'United States', 7000,
     {'North America': .45, 'Latin America': .10, 'EMEA': .20, 'APAC': .20, 'ANZ': .05}, [
         ('Cloud Practitioner', 'Certification', 36, 150, .78, ['Cloud Concepts', 'Core Services', 'Billing and Pricing']),
         ('Cloud Solutions Architect', 'Certification', 36, 300, .64, ['Resilient Design', 'High-Performing Architectures', 'Secure Workloads', 'Cost Optimisation']),
         ('Cloud Security Specialist', 'Certification', 24, 350, .58, ['Identity and Access', 'Threat Detection', 'Data Protection']),
         ('Data Engineering Path', 'Learning Path', None, 0, 0, ['Data Ingestion', 'Pipelines', 'Data Warehousing']),
     ]),
    (102, 'Meridian Nursing Council', 'MNC', 'Healthcare licensing and CPD', 'Australia', 5000,
     {'ANZ': .85, 'APAC': .10, 'EMEA': .05}, [
         ('Registered Nurse CPD', 'CPD', 12, 0, 0, ['Clinical Governance', 'Infection Control', 'Ethics in Practice']),
         ('Critical Care Endorsement', 'Certification', 36, 420, .61, ['Advanced Assessment', 'Ventilation Management', 'Critical Pharmacology', 'Deteriorating Patient']),
         ('Medication Safety', 'Micro-credential', 24, 95, .82, ['Safe Administration', 'High-Risk Medicines']),
     ]),
    (103, 'Northstar Project Institute', 'NPI', 'Professional certification', 'United Kingdom', 6000,
     {'EMEA': .50, 'North America': .15, 'APAC': .20, 'ANZ': .10, 'Latin America': .05}, [
         ('Project Foundations', 'Certification', 36, 200, .74, ['Project Lifecycle', 'Scope and Schedule', 'Stakeholders']),
         ('Agile Practitioner', 'Certification', 36, 275, .69, ['Agile Principles', 'Scrum in Practice', 'Scaling Agile']),
         ('Programme Management Professional', 'Certification', 36, 450, .55, ['Benefits Realisation', 'Programme Governance', 'Portfolio Alignment', 'Risk at Scale']),
     ]),
    (104, 'Harbor Safety Board', 'HSB', 'Workplace safety certification', 'United States', 4500,
     {'North America': .90, 'Latin America': .10}, [
         ('Site Safety Supervisor', 'Certification', 24, 180, .70, ['Hazard Identification', 'Incident Response', 'Safety Leadership']),
         ('Working at Heights', 'Micro-credential', 12, 60, .86, ['Fall Protection', 'Rescue Planning']),
         ('Hazardous Materials Handling', 'Certification', 24, 140, .72, ['Classification', 'Storage and Transport', 'Spill Response']),
     ]),
    (105, 'Lumen Financial Standards', 'LFS', 'Financial services certification', 'Singapore', 3500,
     {'APAC': .60, 'ANZ': .15, 'EMEA': .15, 'North America': .10}, [
         ('Certified Financial Planner', 'Certification', 24, 480, .52, ['Financial Planning Process', 'Investment Planning', 'Retirement and Estate', 'Tax Planning']),
         ('AML Compliance Specialist', 'Certification', 24, 320, .63, ['Money Laundering Typologies', 'KYC and CDD', 'Transaction Monitoring']),
         ('ESG Investing Certificate', 'Micro-credential', 36, 210, .76, ['ESG Foundations', 'Sustainable Portfolios']),
     ]),
]

PARTNER_STEMS = ['Skyline', 'Bluegate', 'Northwind', 'Crestview', 'Summit', 'Ironbark', 'Harbourline', 'Keystone',
                 'Silverleaf', 'Redwood', 'Atlas', 'Pinnacle', 'Evergreen', 'Cobalt', 'Granite', 'Brightpath',
                 'Westbrook', 'Lakeside', 'Orion', 'Vantage', 'Clearwater', 'Highgate', 'Riverstone', 'Copperfield',
                 'Sterling', 'Bayside', 'Foxglove', 'Juniper', 'Tidewater', 'Kingsway', 'Ashford', 'Monarch',
                 'Sunridge', 'Oakmont', 'Larkspur', 'Wildfern', 'Quartz', 'Halcyon', 'Driftwood', 'Beacon']
PARTNER_SUFFIX = {
    'Training Partner': ['Learning', 'Academy', 'Training', 'Skills'],
    'Reseller': ['Solutions', 'Distribution', 'Digital'],
    'Corporate Account': {101: ['Technologies', 'Systems'], 102: ['Health', 'Hospitals'], 103: ['Consulting', 'Group'],
                          104: ['Construction', 'Energy'], 105: ['Bank', 'Capital']},
    'Academic': ['University', 'College', 'Polytechnic'],
}
TIER_DISCOUNT = {'Platinum': 25, 'Gold': 15, 'Silver': 10, 'Direct': 0}

FIRST = ['Olivia', 'Liam', 'Emma', 'Noah', 'Ava', 'Oliver', 'Sophia', 'Lucas', 'Mia', 'Ethan', 'Isla', 'Leo', 'Chloe',
         'Arjun', 'Priya', 'Wei', 'Mei', 'Hiroshi', 'Yuki', 'Carlos', 'Sofia', 'Mateo', 'Valentina', 'Thabo', 'Amara',
         'Fatima', 'Omar', 'Hannah', 'Jack', 'Grace', 'Ravi', 'Ananya', 'Jin', 'Min-jun', 'Lucia', 'Diego', 'Zara',
         'Kai', 'Aisha', 'Daniel', 'Charlotte', 'James', 'Amelia', 'Henry', 'Ruby', 'Samuel', 'Nina', 'Tom', 'Elena']
LAST = ['Smith', 'Nguyen', 'Patel', 'Garcia', 'Chen', 'Williams', 'Brown', 'Singh', 'Kim', 'Tanaka', 'Silva', 'Martinez',
        'Taylor', 'Wilson', 'Khan', 'Mokoena', 'Okafor', 'Rossi', 'Muller', 'Lopez', 'Wong', 'Lee', 'Sato', 'Cohen',
        'Anderson', 'Thompson', 'Rahman', 'Reyes', 'Kumar', 'Fernandes', 'Walker', 'Hughes', 'Murphy', 'Oconnor',
        'Schmidt', 'Novak', 'Ali', 'Ito', 'Santos', 'Clarke']

R = random.Random(SEED)


def wchoice(d):
    keys = list(d)
    return R.choices(keys, weights=[d[k] for k in keys])[0]


def rand_date(lo, hi):
    if hi < lo:
        hi = lo
    return lo + timedelta(days=R.randint(0, (hi - lo).days))


def month_weights():
    """Registration month weights: ~35% YoY growth plus seasonality."""
    out = {}
    d = START
    season = {1: 1.15, 2: 1.1, 3: 1.25, 4: 1.0, 5: 0.95, 6: 0.85, 7: 0.85, 8: 1.0, 9: 1.2, 10: 1.1, 11: 1.0, 12: 0.6}
    while d <= AS_OF:
        t = (d.year - START.year) * 12 + d.month - 1
        out[(d.year, d.month)] = math.pow(1.35, t / 12) * season[d.month]
        d = date(d.year + (d.month // 12), d.month % 12 + 1, 1)
    return out


def month_bounds(y, m):
    lo = date(y, m, 1)
    hi = date(y + (m // 12), m % 12 + 1, 1) - timedelta(days=1)
    return lo, min(hi, AS_OF)


def add_months(d, n):
    y, m = divmod(d.month - 1 + n, 12)
    y += d.year
    m += 1
    day = min(d.day, 28)
    return date(y, m, day)


def ts(d, rng_hours=True):
    return datetime(d.year, d.month, d.day, R.randint(7, 21) if rng_hours else 9, R.randint(0, 59))


def build():
    T = {k: [] for k in ['clients', 'programs', 'courses', 'exams', 'partners', 'candidates', 'enrolments',
                         'exam_attempts', 'credentials', 'vouchers']}
    ids = {k: 0 for k in T}

    def nid(k, base):
        ids[k] += 1
        return base + ids[k]

    mw = month_weights()
    stems = PARTNER_STEMS[:]
    R.shuffle(stems)
    used_names = set()

    for cid, cname, code, industry, hq, n_cand, rweights, progs in CLIENTS:
        plan = R.choice(['Enterprise', 'Enterprise', 'Growth'])
        T['clients'].append(dict(client_id=cid, client_name=cname, client_code=code, industry=industry,
                                 hq_country=hq, plan_tier=plan, go_live_date=START - timedelta(days=R.randint(60, 400))))
        # programs, courses, exams
        prog_rows = []
        for pname, ptype, recert, fee, pass_base, topics in progs:
            pid = nid('programs', 0)
            prow = dict(program_id=pid, client_id=cid, program_name=pname, program_type=ptype,
                        recert_cycle_months=recert, exam_fee_usd=fee, launched_on=START - timedelta(days=R.randint(30, 900)))
            T['programs'].append(prow)
            courses = []
            for i, topic in enumerate(topics, 1):
                kid = nid('courses', 0)
                c = dict(course_id=kid, client_id=cid, program_id=pid, course_name=f'{pname} - {topic}',
                         course_sequence=i, modality=R.choice(['Self-paced', 'Self-paced', 'Virtual instructor-led', 'Blended']),
                         duration_hours=R.choice([4, 6, 8, 10, 12, 16]))
                T['courses'].append(c)
                courses.append(c)
            exam = None
            if fee > 0:
                eid = nid('exams', 0)
                exam = dict(exam_id=eid, client_id=cid, program_id=pid, exam_name=f'{pname} Exam',
                            exam_code=f'{code}-{eid:03d}', passing_score=R.choice([65, 70, 72, 75]),
                            delivery_mode=R.choice(['Online proctored', 'Test centre', 'Online proctored']),
                            list_price_usd=fee)
                T['exams'].append(exam)
            prog_rows.append((prow, courses, exam, pass_base))

        # partners: one Direct channel + 9-12 partners
        partners = []
        pid = nid('partners', 0)
        direct = dict(partner_id=pid, client_id=cid, partner_name=f'{cname} Direct', partner_type='Direct',
                      partner_tier='Direct', region=None, country=hq, onboarded_on=START)
        T['partners'].append(direct)
        n_part = R.randint(9, 12)
        types = ['Training Partner'] * 4 + ['Reseller'] * 2 + ['Corporate Account'] * 3 + ['Academic'] * 2
        for _ in range(n_part):
            ptype = R.choice(types)
            region = wchoice(rweights)
            suf = PARTNER_SUFFIX[ptype]
            suf = suf[cid] if isinstance(suf, dict) else suf
            while True:
                name = f'{R.choice(stems)} {R.choice(suf)}'
                if name not in used_names:
                    used_names.add(name)
                    break
            p = dict(partner_id=nid('partners', 0), client_id=cid, partner_name=name, partner_type=ptype,
                     partner_tier=R.choices(['Platinum', 'Gold', 'Silver'], [2, 4, 5])[0], region=region,
                     country=R.choice(REGIONS[region]), onboarded_on=rand_date(START - timedelta(days=500), date(2025, 9, 1)))
            T['partners'].append(p)
            partners.append(p)
        pweights = {p['partner_id']: R.uniform(0.4, 2.2) for p in partners}
        pmap = {p['partner_id']: p for p in partners}

        # partner voucher orders: key (partner, exam, yyyy-mm) -> order dict
        orders = {}

        # candidates
        months = list(mw)
        for _ in range(n_cand):
            y, m = R.choices(months, weights=[mw[k] for k in months])[0]
            reg = rand_date(*month_bounds(y, m))
            if R.random() < 0.32:
                partner = direct
                region = wchoice(rweights)
            else:
                partner = pmap[R.choices(list(pweights), weights=list(pweights.values()))[0]]
                region = partner['region']
            segment = {'Corporate Account': 'Employer-sponsored', 'Academic': 'Student'}.get(partner['partner_type'], 'Individual')
            fn, ln = R.choice(FIRST), R.choice(LAST)
            cand_id = nid('candidates', 100000)
            T['candidates'].append(dict(candidate_id=cand_id, client_id=cid, partner_id=partner['partner_id'],
                                        candidate_name=f'{fn} {ln}',
                                        email=f'{fn.lower()}.{ln.lower()}.{cand_id}@example.com'.replace(' ', ''),
                                        region=region, country=R.choice(REGIONS[region]), segment=segment,
                                        registered_at=ts(reg)))

            n_prog = 1 if R.random() < 0.8 else 2
            chosen = R.sample(prog_rows, min(n_prog, len(prog_rows)))
            start = reg + timedelta(days=R.randint(0, 30))
            for prow, courses, exam, pass_base in chosen:
                if start > AS_OF:
                    break
                skill = R.gauss(0, 1)
                last_done = start
                completed_all = True
                if not (exam and R.random() < 0.12):        # 12% go straight to the exam
                    cur = start
                    for c in courses:
                        if cur > AS_OF:
                            completed_all = False
                            break
                        enr_id = nid('enrolments', 0)
                        p_complete = 0.86 if c['course_sequence'] == 1 else 0.90
                        dur = R.randint(7, 55)
                        done = cur + timedelta(days=dur)
                        if R.random() < p_complete and done <= AS_OF:
                            score = max(55, min(100, round(R.gauss(82 + 5 * skill, 7))))
                            T['enrolments'].append(dict(enrolment_id=enr_id, client_id=cid, candidate_id=cand_id,
                                                        course_id=c['course_id'], enrolled_at=ts(cur), completed_at=ts(done),
                                                        status='Completed', progress_pct=100, final_score=score))
                            last_done = done
                            cur = done + timedelta(days=R.randint(0, 14))
                        else:
                            age = (AS_OF - cur).days
                            status = 'In progress' if age <= 120 else 'Withdrawn'
                            prog_pct = R.randint(5, 95) if status == 'In progress' else R.randint(5, 60)
                            T['enrolments'].append(dict(enrolment_id=enr_id, client_id=cid, candidate_id=cand_id,
                                                        course_id=c['course_id'], enrolled_at=ts(cur), completed_at=None,
                                                        status=status, progress_pct=prog_pct, final_score=None))
                            completed_all = False
                            break

                recert = prow['recert_cycle_months']
                issued = None
                if completed_all and not exam:
                    # CPD / learning path credential is earned by completing all courses
                    issued = last_done + timedelta(days=R.randint(0, 3))
                elif completed_all and exam and R.random() < 0.86:
                    att_date = last_done + timedelta(days=R.randint(5, 45))
                    for n_try in range(1, 4):
                        if att_date > AS_OF:
                            break
                        att_id = nid('exam_attempts', 500000)
                        # voucher used for this attempt
                        vtype = 'Standard' if n_try == 1 else 'Retake'
                        issued_v = att_date - timedelta(days=R.randint(2, 75) if partner['partner_type'] != 'Direct' else R.randint(0, 10))
                        v = make_voucher(T, nid, orders, cid, code, partner, exam, issued_v, vtype)
                        v.update(redeemed_at=ts(att_date), redeemed_by_candidate_id=cand_id, attempt_id=att_id, status='Redeemed')
                        p_pass = min(0.97, max(0.1, pass_base + 0.08 * skill + 0.07 * (n_try - 1)))
                        passed = R.random() < p_pass
                        ps = exam['passing_score']
                        score = R.randint(ps, 98) if passed else R.randint(max(30, ps - 30), ps - 1)
                        T['exam_attempts'].append(dict(attempt_id=att_id, client_id=cid, candidate_id=cand_id,
                                                       exam_id=exam['exam_id'], voucher_id=v['voucher_id'],
                                                       attempt_number=n_try, attempted_at=ts(att_date), score=score,
                                                       result='Pass' if passed else 'Fail',
                                                       delivery_mode=exam['delivery_mode']))
                        if passed:
                            issued = att_date + timedelta(days=R.randint(1, 3))
                            break
                        if R.random() > 0.68:
                            break
                        att_date = att_date + timedelta(days=R.randint(14, 60))

                if issued and issued <= AS_OF:
                    prev = None
                    is_recert = False
                    while issued <= AS_OF:
                        cred_id = nid('credentials', 900000)
                        expires = add_months(issued, recert) if recert else None
                        row = dict(credential_id=cred_id, client_id=cid, candidate_id=cand_id,
                                   program_id=prow['program_id'], credential_code=f'{code}-{cred_id}',
                                   issued_at=ts(issued), expires_at=expires, is_recertification=is_recert,
                                   previous_credential_id=prev, revoked=R.random() < 0.004)
                        T['credentials'].append(row)
                        if not expires or row['revoked']:
                            break
                        # recertification decision near expiry
                        if expires - timedelta(days=75) > AS_OF:
                            break
                        p_recert = 0.66 if prow['program_type'] != 'CPD' else 0.8
                        if R.random() > p_recert:
                            break
                        issued = expires - timedelta(days=R.randint(0, 75))
                        prev, is_recert = cred_id, True
                start = start + timedelta(days=R.randint(60, 300))

        # unredeemed stock on partner orders + some direct breakage
        for o in orders.values():
            if o['channel'] == 'Partner order':
                extra = math.ceil(o['count'] * R.uniform(0.08, 0.45))
            else:
                extra = 1 if R.random() < 0.05 else 0
            for _ in range(extra):
                v = make_voucher(T, nid, None, cid, code, o['partner'], o['exam'], o['issued'], 'Standard', order=o)
                exp = v['expires_at']
                v.update(status='Expired' if exp < AS_OF else 'Unredeemed')
    return T


def make_voucher(T, nid, orders, cid, code, partner, exam, issued, vtype, order=None):
    if order is None:
        if partner['partner_type'] == 'Direct':
            key = ('d', nid('vouchers', 0) * 0 + len(T['vouchers']))
            channel = 'Web store'
        else:
            key = (partner['partner_id'], exam['exam_id'], issued.year, issued.month)
            channel = 'Partner order'
        order = orders.get(key)
        if order is None:
            order = dict(order_id=f'{code}-PO-{len(orders) + 1:05d}', partner=partner, exam=exam,
                         issued=issued if channel == 'Web store' else date(issued.year, issued.month, 1) + timedelta(days=R.randint(0, 5)),
                         channel=channel, count=0)
            if order['issued'] > issued:
                order['issued'] = issued
            orders[key] = order
        order['count'] += 1
    vid = nid('vouchers', 700000)
    disc = TIER_DISCOUNT[partner['partner_tier']] + (50 if vtype == 'Retake' else 0)
    disc = min(disc, 60)
    price = exam['list_price_usd']
    v = dict(voucher_id=vid, client_id=cid, partner_id=partner['partner_id'], exam_id=exam['exam_id'],
             order_id=order['order_id'], sales_channel=order['channel'],
             voucher_code=f"{code}-{R.randint(0, 0xFFFF):04X}-{R.randint(0, 0xFFFF):04X}",
             voucher_type=vtype, issued_at=ts(order['issued']), expires_at=add_months(order['issued'], 12),
             redeemed_at=None, redeemed_by_candidate_id=None, attempt_id=None,
             list_price_usd=price, discount_pct=disc, net_price_usd=round(price * (100 - disc) / 100, 2), status=None)
    T['vouchers'].append(v)
    return v


DDL = {
    'clients': '''client_id integer primary key, client_name text not null, client_code text not null,
        industry text, hq_country text, plan_tier text, go_live_date date''',
    'programs': '''program_id integer primary key, client_id integer not null, program_name text not null,
        program_type text not null, recert_cycle_months integer, exam_fee_usd numeric(10,2), launched_on date''',
    'courses': '''course_id integer primary key, client_id integer not null, program_id integer not null,
        course_name text not null, course_sequence integer, modality text, duration_hours integer''',
    'exams': '''exam_id integer primary key, client_id integer not null, program_id integer not null,
        exam_name text not null, exam_code text, passing_score integer, delivery_mode text, list_price_usd numeric(10,2)''',
    'partners': '''partner_id integer primary key, client_id integer not null, partner_name text not null,
        partner_type text not null, partner_tier text, region text, country text, onboarded_on date''',
    'candidates': '''candidate_id integer primary key, client_id integer not null, partner_id integer not null,
        candidate_name text, email text, region text, country text, segment text, registered_at timestamp not null''',
    'enrolments': '''enrolment_id integer primary key, client_id integer not null, candidate_id integer not null,
        course_id integer not null, enrolled_at timestamp not null, completed_at timestamp, status text not null,
        progress_pct integer, final_score integer''',
    'exam_attempts': '''attempt_id integer primary key, client_id integer not null, candidate_id integer not null,
        exam_id integer not null, voucher_id integer, attempt_number integer, attempted_at timestamp not null,
        score integer, result text not null, delivery_mode text''',
    'credentials': '''credential_id integer primary key, client_id integer not null, candidate_id integer not null,
        program_id integer not null, credential_code text, issued_at timestamp not null, expires_at date,
        is_recertification boolean not null, previous_credential_id integer, revoked boolean not null''',
    'vouchers': '''voucher_id integer primary key, client_id integer not null, partner_id integer not null,
        exam_id integer not null, order_id text not null, sales_channel text, voucher_code text, voucher_type text,
        issued_at timestamp not null, expires_at date not null, redeemed_at timestamp, redeemed_by_candidate_id integer,
        attempt_id integer, list_price_usd numeric(10,2), discount_pct integer, net_price_usd numeric(10,2), status text not null''',
}


def write(T, out):
    os.makedirs(out, exist_ok=True)
    for name, rows in T.items():
        cols = [c.strip().split()[0] for c in DDL[name].replace('\n', ' ').split(',') if c.strip() and not c.strip()[0].isdigit() and c.strip().split()[0] not in ('2)',)]
        cols = [c for c in cols if not c.endswith(')')]
        with open(os.path.join(out, f'{name}.csv'), 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=cols)
            w.writeheader()
            for r in rows:
                w.writerow({k: ('' if r.get(k) is None else r.get(k)) for k in cols})
        print(f'{name:14s} {len(rows):>7,d}')


def load(out, schema):
    import psycopg
    url = os.environ['NEON_DEMO_DATABASE_URL']
    with psycopg.connect(url) as con, con.cursor() as cur:
        cur.execute(f'drop schema if exists {schema} cascade')
        cur.execute(f'create schema {schema}')
        for name, ddl in DDL.items():
            cur.execute(f'create table {schema}.{name} ({ddl})')
            with open(os.path.join(out, f'{name}.csv')) as f:
                header = f.readline().strip()
                with cur.copy(f"copy {schema}.{name} ({header}) from stdin with (format csv, null '')") as cp:
                    for line in f:
                        cp.write(line)
        for t in ['programs', 'courses', 'exams', 'partners', 'candidates', 'enrolments', 'exam_attempts', 'credentials', 'vouchers']:
            cur.execute(f'create index on {schema}.{t} (client_id)')
        cur.execute(f'analyze')
        con.commit()
        for name in DDL:
            cur.execute(f'select count(*) from {schema}.{name}')
            print(f'loaded {schema}.{name}: {cur.fetchone()[0]:,}')


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', required=True)
    ap.add_argument('--schema', default='rockinfo_demo')
    ap.add_argument('--load', action='store_true')
    a = ap.parse_args()
    T = build()
    write(T, a.out)
    if a.load:
        load(a.out, a.schema)
