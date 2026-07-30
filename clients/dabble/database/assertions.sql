set timezone to 'Australia/Sydney';

do $$
declare
  failures text[] := array[]::text[];
begin
  if (select count(*) from dabble_demo.dim_user) <> 3000 then failures := array_append(failures, 'dim_user must contain 3,000 rows'); end if;
  if (select count(*) from dabble_demo.dim_sport) <> 24 then failures := array_append(failures, 'dim_sport must contain 24 rows'); end if;
  if (select count(*) from dabble_demo.dim_competition) <> 66 then failures := array_append(failures, 'dim_competition must contain 66 rows'); end if;
  if (select count(*) from dabble_demo.dim_fixture) <> 1200 then failures := array_append(failures, 'dim_fixture must contain 1,200 rows'); end if;
  if (select count(*) from dabble_demo.dim_market) <> 4200 then failures := array_append(failures, 'dim_market must contain 4,200 rows'); end if;
  if (select count(*) from dabble_demo.fact_bet) <> 90000 then failures := array_append(failures, 'fact_bet must contain 90,000 rows'); end if;
  if (select count(*) from dabble_demo.fact_bet_leg) not between 120000 and 200000 then failures := array_append(failures, 'fact_bet_leg must contain 120,000-200,000 rows'); end if;

  if exists (select 1 from dabble_demo.fact_bet b left join dabble_demo.dim_user u on u.user_id = b.user_id where u.user_id is null)
    or exists (select 1 from dabble_demo.fact_bet_leg l left join dabble_demo.fact_bet b on b.bet_id = l.bet_id where b.bet_id is null)
    or exists (select 1 from dabble_demo.fact_bet_leg l left join dabble_demo.dim_market m on m.market_id = l.market_id where m.market_id is null)
    or exists (select 1 from dabble_demo.dim_market m left join dabble_demo.dim_fixture f on f.fixture_id = m.fixture_id where f.fixture_id is null)
    or exists (select 1 from dabble_demo.dim_fixture f left join dabble_demo.dim_competition c on c.competition_id = f.competition_id where c.competition_id is null)
    or exists (select 1 from dabble_demo.dim_competition c left join dabble_demo.dim_sport s on s.sport_id = c.sport_id where s.sport_id is null)
  then failures := array_append(failures, 'one or more foreign keys/hierarchy links are orphaned'); end if;

  if exists (
    select bet_id from dabble_demo.fact_bet group by bet_id having count(*) > 1
    union all select bet_leg_id from dabble_demo.fact_bet_leg group by bet_leg_id having count(*) > 1
  ) then failures := array_append(failures, 'duplicate fact primary keys found'); end if;

  if exists (
    select 1 from dabble_demo.fact_bet
    where combined_stake <> cash_stake + bonus_stake
       or combined_payout <> cash_payout + bonus_payout
       or gross_win <> cash_stake - cash_payout + rocket_boost
       or trading_net_win <> gross_win - brg
       or cogs <> nt_tax + premium_experiences + betstop_levies + gst + poc + sky_racing + product_fee + payment_processing_fees
       or trading_net_revenue <> trading_net_win - cogs
  ) then failures := array_append(failures, 'bet money identity failed'); end if;

  if exists (
    select 1
    from dabble_demo.fact_bet b
    join (
      select bet_id
        , count(*) as leg_count
        , sum(cash_stake) as cash_stake
        , sum(bonus_stake) as bonus_stake
        , sum(combined_stake) as combined_stake
        , sum(restricted_stake) as restricted_stake
        , sum(cash_payout) as cash_payout
        , sum(bonus_payout) as bonus_payout
        , sum(combined_payout) as combined_payout
        , sum(rocket_boost) as rocket_boost
        , sum(brg) as brg
        , sum(gross_win) as gross_win
        , sum(trading_net_win) as trading_net_win
        , sum(cogs) as cogs
        , sum(trading_net_revenue) as trading_net_revenue
      from dabble_demo.fact_bet_leg
      group by bet_id
    ) l on l.bet_id = b.bet_id
    where (b.leg_count, b.cash_stake, b.bonus_stake, b.combined_stake, b.restricted_stake, b.cash_payout, b.bonus_payout, b.combined_payout, b.rocket_boost, b.brg, b.gross_win, b.trading_net_win, b.cogs, b.trading_net_revenue)
       <> (l.leg_count, l.cash_stake, l.bonus_stake, l.combined_stake, l.restricted_stake, l.cash_payout, l.bonus_payout, l.combined_payout, l.rocket_boost, l.brg, l.gross_win, l.trading_net_win, l.cogs, l.trading_net_revenue)
  ) then failures := array_append(failures, 'leg-to-bet rollup failed'); end if;

  if exists (
    select 1
    from dabble_demo.fact_user_day d
    full join (
      select user_id
        , settled_at::date as reporting_date
        , count(*) as bets_count
        , sum(leg_count) as legs_count
        , sum(cash_stake) as cash_stake
        , sum(bonus_stake) as bonus_stake
        , sum(combined_stake) as combined_stake
        , sum(restricted_stake) as restricted_stake
        , sum(cash_payout) as cash_payout
        , sum(bonus_payout) as bonus_payout
        , sum(combined_payout) as combined_payout
        , sum(rocket_boost) as rocket_boost
        , sum(brg) as brg
        , sum(gross_win) as gross_win
        , sum(trading_net_win) as trading_net_win
        , sum(cogs) as cogs
        , sum(trading_net_revenue) as trading_net_revenue
      from dabble_demo.fact_bet
      group by user_id, settled_at::date
    ) b on b.user_id = d.user_id and b.reporting_date = d.reporting_date
    where d.user_id is null or b.user_id is null
       or (d.bets_count, d.legs_count, d.cash_stake, d.bonus_stake, d.combined_stake, d.restricted_stake, d.cash_payout, d.bonus_payout, d.combined_payout, d.rocket_boost, d.brg, d.gross_win, d.trading_net_win, d.cogs, d.trading_net_revenue)
       <> (b.bets_count, b.legs_count, b.cash_stake, b.bonus_stake, b.combined_stake, b.restricted_stake, b.cash_payout, b.bonus_payout, b.combined_payout, b.rocket_boost, b.brg, b.gross_win, b.trading_net_win, b.cogs, b.trading_net_revenue)
  ) then failures := array_append(failures, 'bet-to-user-day rollup failed'); end if;

  if (select min(placed_at::date) from dabble_demo.fact_bet) <> date '2024-01-01'
    or (select max(settled_at::date) from dabble_demo.fact_bet) <> date '2026-07-26'
    or not exists (select 1 from dabble_demo.dim_fixture where advertised_start::date between date '2026-07-01' and date '2026-07-26')
  then failures := array_append(failures, 'required 2024-01-01 through 2026-07-26 date coverage failed'); end if;

  if (select count(distinct home_state) from dabble_demo.dim_user) <> 8
    or (select count(distinct bet_type) from dabble_demo.fact_bet) <> 5
    -- The supplied margin table displays leg counts from 1 through 25.
    or (select min(leg_count) from dabble_demo.fact_bet) <> 1
    or (select max(leg_count) from dabble_demo.fact_bet) <> 25
    or (select count(distinct leg_count) from dabble_demo.fact_bet) <> 25
    or (select count(distinct risk_rating) from dabble_demo.dim_user) <> 4
    or (select count(distinct rocket_category) from dabble_demo.fact_bet) <> 3
    or not exists (select 1 from dabble_demo.dim_user where risk_factor = -1)
    or not exists (select 1 from dabble_demo.dim_user where risk_factor between 0.91 and 0.99)
    or not exists (select 1 from dabble_demo.dim_user where risk_factor between 1.01 and 1.05)
    or not exists (select 1 from dabble_demo.fact_bet_leg where dividend > 1)
  then failures := array_append(failures, 'required state/bet/risk/Rocket category coverage failed'); end if;

  if exists (
    select 1 from information_schema.columns
    where table_schema = 'dabble_demo'
      and (column_name ilike '%email%' or column_name ilike '%name%' and column_name not in ('sport_name', 'competition_name', 'fixture_name', 'market_name', 'selection_name', 'display_alias'))
  ) or exists (select 1 from dabble_demo.dim_user where display_alias !~ '^Punter [0-9]{4}$')
  then failures := array_append(failures, 'PII-safe schema/alias assertion failed'); end if;

  if not exists (
    select s.sport_id
    from dabble_demo.fact_bet_leg l
    join dabble_demo.dim_market m on m.market_id = l.market_id
    join dabble_demo.dim_fixture f on f.fixture_id = m.fixture_id
    join dabble_demo.dim_competition c on c.competition_id = f.competition_id
    join dabble_demo.dim_sport s on s.sport_id = c.sport_id
    group by s.sport_id
    having sum(l.trading_net_revenue) < 0
  ) then failures := array_append(failures, 'no negative-profitability sport slice found'); end if;

  if cardinality(failures) > 0 then
    raise exception 'Dabble seed assertions failed: %', array_to_string(failures, '; ');
  end if;
  raise notice 'Dabble seed assertions passed';
end $$;
