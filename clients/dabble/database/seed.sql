begin;
set local search_path to dabble_demo, public;
set local timezone to 'Australia/Sydney';

truncate table fact_user_day, fact_bet_leg, fact_bet, dim_market, dim_fixture, dim_competition, dim_sport, dim_user restart identity cascade;

insert into dim_user (user_id, source_user_id, display_alias, home_state, signup_date, acquisition_category, risk_rating, risk_factor)
select n
  , 'usr_' || lpad(n::text, 7, '0')
  , 'Punter ' || lpad(n::text, 4, '0')
  , (array['ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA'])[1 + ((n * 17) % 8)]
  , date '2023-01-01' + ((n * 73) % 365)
  , (array['Organic', 'Affiliate', 'Paid Social', 'Referral', 'Partnership'])[1 + ((n * 11) % 5)]
  , (array['Low', 'Medium', 'High', 'Other / Unclassified'])[1 + ((n * 7) % 4)]
  , (array[-1.00, 0.15, 0.40, 0.65, 0.90, 0.95, 1.00, 1.03, 1.08, 1.11, 5.50, 10.50]::numeric[])[1 + ((n * 13) % 12)]
from generate_series(1, 3000) as g(n);

insert into dim_sport (sport_id, source_sport_id, sport_name, is_racing)
select n
  , 'spr_' || lpad(n::text, 3, '0')
  , (array['Thoroughbred Racing', 'Greyhound Racing', 'Harness Racing', 'Australian Rules', 'Rugby League', 'Football', 'Baseball', 'American Football', 'Tennis', 'AFL - Brownlow 3 Votes', 'Ice Hockey', 'Racing Futures', 'Volleyball', 'Boxing', 'Rugby Union', 'Basketball', 'Cricket', 'Cycling', 'Darts', 'Esports', 'Golf', 'MMA', 'Commonwealth Games', 'Daily Dabbles'])[n]
  , n <= 3 or n = 12
from generate_series(1, 24) as g(n);

insert into dim_competition (competition_id, source_competition_id, sport_id, competition_name, country_code, competition_state)
select n
  , 'cmp_' || lpad(n::text, 4, '0')
  , case when n <= 36 then 1 + ((n - 1) % 3) else 4 + ((n * 11) % 21) end
  , case when n = 37 then 'AFL Matches' when n = 38 then 'Brownlow Medal' when n = 39 then 'UFC' else 'Competition ' || lpad(n::text, 2, '0') end
  , 'AU'
  , case when n <= 36 then (array['ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA'])[1 + ((n * 5) % 8)] end
from generate_series(1, 66) as g(n);

insert into dim_fixture (fixture_id, source_fixture_id, competition_id, fixture_name, advertised_start, actual_close_time, fixture_status)
select n
  , 'fix_' || lpad(n::text, 6, '0')
  , 1 + ((n * 17) % 66)
  , case
      when n = 1196 then 'Adelaide Crows v Collingwood Magpies'
      when n = 1197 then 'Sydney Swans v Adelaide Crows'
      when n = 1198 then 'Melbourne Demons v Geelong Cats'
      when n = 1199 then 'Collingwood Magpies v Carlton Blues'
      when n = 1200 then 'Conor McGregor v Max Holloway'
      else 'Fixture ' || lpad(n::text, 4, '0')
    end
  , timestamptz '2024-01-01 01:00:00+11' + ((n * 563) % 938)::int * interval '1 day' + ((n * 37) % 20) * interval '1 hour'
  , timestamptz '2024-01-01 01:00:00+11' + ((n * 563) % 938)::int * interval '1 day' + ((n * 37) % 20) * interval '1 hour' + interval '3 hours'
  , 'Settled'
from generate_series(1, 1200) as g(n);

-- Guarantee recognisable July 2026 public-style fixtures in the prototype.
update dim_fixture
set advertised_start = fixture_date.advertised_start
  , actual_close_time = fixture_date.advertised_start + interval '3 hours'
from (
  values
    (1196::bigint, timestamptz '2026-07-11 19:35:00+10')
  , (1197::bigint, timestamptz '2026-07-15 19:10:00+10')
  , (1198::bigint, timestamptz '2026-07-18 16:35:00+10')
  , (1199::bigint, timestamptz '2026-07-18 19:35:00+10')
  , (1200::bigint, timestamptz '2026-07-26 15:15:00+10')
) as fixture_date(fixture_id, advertised_start)
where dim_fixture.fixture_id = fixture_date.fixture_id;

insert into dim_market (market_id, source_market_id, fixture_id, market_name, market_group)
select n
  , 'mkt_' || lpad(n::text, 7, '0')
  , 1 + ((n * 29) % 1200)
  , 'Market ' || lpad(n::text, 4, '0')
  , (array['RacingDDFirstFour', 'RacingDDTrifecta', 'RacingSrmTop4', 'RacingFixedPlace', 'RacingSrmTop3', 'match_winner', 'RacingSrmWin', 'RacingSrmTop2', 'RacingDDExacta', 'RacingDDQuinella', 'RacingDDQuaddie', 'oddsjam_points', 'sportcast_anytime', 'odds_on_pickem', 'odds_on_to_get', 'odds_on_to_kick'])[1 + ((n * 11) % 16)]
from generate_series(1, 4200) as g(n);

create temporary table seed_bet on commit drop as
select n as bet_id
  , 1 + ((n * 1543) % 3000) as user_id
  , case when n % 20 < 9 then 'Single' when n % 20 < 14 then 'Multi' when n % 20 < 17 then 'SGM' when n % 20 < 19 then 'Each Way' else 'Dabble Div' end as bet_type
<<<<<<< local:clients/dabble/database/seed.sql
  , case
      when n % 20 < 9 then 1
      when n % 20 < 14 and (n / 20) % 50 = 0 then 6 + ((n / 1000) % 20)
      when n % 20 < 14 then 2 + (n % 4)
      when n % 20 < 17 then 2 + (n % 3)
      when n % 20 < 19 then 2
      else 3 + (n % 2)
    end::smallint as leg_count
=======
  , case when n % 20 < 9 then 1 when n % 20 < 14 then 2 + (n % 3) when n % 20 < 17 then 2 + (n % 2) when n % 20 < 19 then 2 else 3 + (n % 2) end::smallint as leg_count
>>>>>>> cloud:clients/dabble/database/seed.sql
  , (timestamp '2024-01-01 00:00:00' + ((n * 701) % 938) * interval '1 day' + ((n * 43) % 86400) * interval '1 second') at time zone 'Australia/Sydney' as placed_at
  , case when n % 10 = 0 then 'Copied Rocket Bet' when n % 10 = 1 then 'Non Copied Rocket Bet' else 'Not Rocket' end as rocket_category
from generate_series(1, 90000) as g(n);

create temporary table seed_leg on commit drop as
select b.bet_id
  , l.leg_number::smallint
  , 1 + ((b.bet_id * 31 + l.leg_number * 101) % 4200) as market_id
  , round((1 + ((b.bet_id * 47 + l.leg_number * 19) % 9000) / 100.0)::numeric, 2) as cash_stake
  , case when (b.bet_id + l.leg_number) % 7 = 0 then round((1 + ((b.bet_id * 13) % 1500) / 100.0)::numeric, 2) else 0::numeric end as bonus_stake
  , case when (b.bet_id + l.leg_number) % 23 = 0 then round((1 + ((b.bet_id * 17) % 500) / 100.0)::numeric, 2) else 0::numeric end as rocket_boost
  , b.rocket_category
from seed_bet b
cross join lateral generate_series(1, b.leg_count) as l(leg_number);

create temporary table seed_finance on commit drop as
select s.*
  , round((s.cash_stake * case
      when c.sport_id in (11, 14) then 1.35 + ((s.bet_id % 80) / 100.0)
      when (s.bet_id + s.leg_number * 3) % 10 < 7 then 0
      else 1.65 + ((s.bet_id % 140) / 100.0)
    end)::numeric, 2) as cash_payout
  , round((s.bonus_stake * case when (s.bet_id + s.leg_number) % 4 = 0 then 1.8 else 0 end)::numeric, 2) as bonus_payout
  , round(((s.cash_stake + s.bonus_stake) * case when (s.bet_id + s.leg_number) % 13 = 0 then 0.20 else 0 end)::numeric, 2) as restricted_stake
  , round(((s.cash_stake + s.bonus_stake) * 0.010)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.002)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.001)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.006)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.018)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.003)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.004)::numeric, 2)
    + round(((s.cash_stake + s.bonus_stake) * 0.007)::numeric, 2) as cogs
from seed_leg s
join dim_market m on m.market_id = s.market_id
join dim_fixture f on f.fixture_id = m.fixture_id
join dim_competition c on c.competition_id = f.competition_id;

insert into fact_bet (bet_id, source_bet_id, user_id, bet_type, leg_count, rocket_category, placed_at, settled_at, placed_risk_rating, placed_risk_factor, cash_stake, bonus_stake, combined_stake, restricted_stake, cash_payout, bonus_payout, combined_payout, rocket_boost, brg, gross_win, trading_net_win, nt_tax, premium_experiences, betstop_levies, gst, poc, sky_racing, product_fee, payment_processing_fees, cogs, trading_net_revenue)
select b.bet_id
  , 'bet_' || lpad(b.bet_id::text, 8, '0')
  , b.user_id
  , b.bet_type
  , b.leg_count
  , b.rocket_category
  , b.placed_at
  , least(b.placed_at + interval '3 hours', timestamptz '2026-07-26 23:59:59+10')
  , u.risk_rating
  , u.risk_factor
  , sum(f.cash_stake)
  , sum(f.bonus_stake)
  , sum(f.cash_stake + f.bonus_stake)
  , sum(f.restricted_stake)
  , sum(f.cash_payout)
  , sum(f.bonus_payout)
  , sum(f.cash_payout + f.bonus_payout)
  , sum(f.rocket_boost)
  , sum(round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2))
  , sum(f.cash_stake - f.cash_payout + f.rocket_boost)
  , sum(f.cash_stake - f.cash_payout + f.rocket_boost - round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.010)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.002)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.001)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.006)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.018)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.003)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.004)::numeric, 2))
  , sum(round(((f.cash_stake + f.bonus_stake) * 0.007)::numeric, 2))
  , sum(f.cogs)
  , sum(f.cash_stake - f.cash_payout + f.rocket_boost - round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2) - f.cogs)
from seed_bet b
join dim_user u on u.user_id = b.user_id
join seed_finance f on f.bet_id = b.bet_id
group by b.bet_id, b.user_id, b.bet_type, b.leg_count, b.rocket_category, b.placed_at, u.risk_rating, u.risk_factor;

insert into fact_bet_leg (bet_leg_id, source_bet_leg_id, bet_id, leg_number, market_id, selection_name, result, dividend, cash_stake, bonus_stake, combined_stake, restricted_stake, cash_payout, bonus_payout, combined_payout, rocket_boost, brg, gross_win, trading_net_win, nt_tax, premium_experiences, betstop_levies, gst, poc, sky_racing, product_fee, payment_processing_fees, cogs, trading_net_revenue)
select f.bet_id * 100 + f.leg_number
  , 'leg_' || lpad(f.bet_id::text, 8, '0') || '_' || lpad(f.leg_number::text, 2, '0')
  , f.bet_id
  , f.leg_number
  , f.market_id
  , 'Selection ' || (1 + ((f.bet_id + f.leg_number) % 40))
  , case when f.cash_payout + f.bonus_payout > 0 then 'Won' else 'Lost' end
  , round((1.05 + ((f.bet_id * 17 + f.leg_number * 29) % 695) / 100.0)::numeric, 4)
  , f.cash_stake
  , f.bonus_stake
  , f.cash_stake + f.bonus_stake
  , f.restricted_stake
  , f.cash_payout
  , f.bonus_payout
  , f.cash_payout + f.bonus_payout
  , f.rocket_boost
  , round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2)
  , f.cash_stake - f.cash_payout + f.rocket_boost
  , f.cash_stake - f.cash_payout + f.rocket_boost - round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.010)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.002)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.001)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.006)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.018)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.003)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.004)::numeric, 2)
  , round(((f.cash_stake + f.bonus_stake) * 0.007)::numeric, 2)
  , f.cogs
  , f.cash_stake - f.cash_payout + f.rocket_boost - round(((f.cash_stake + f.bonus_stake) * case when f.bet_id % 9 = 0 then 0.08 else 0.025 end)::numeric, 2) - f.cogs
from seed_finance f;

insert into fact_user_day (user_id, reporting_date, bets_count, legs_count, cash_stake, bonus_stake, combined_stake, restricted_stake, cash_payout, bonus_payout, combined_payout, rocket_boost, brg, gross_win, trading_net_win, cogs, trading_net_revenue)
select user_id
  , settled_at::date
  , count(*)
  , sum(leg_count)
  , sum(cash_stake)
  , sum(bonus_stake)
  , sum(combined_stake)
  , sum(restricted_stake)
  , sum(cash_payout)
  , sum(bonus_payout)
  , sum(combined_payout)
  , sum(rocket_boost)
  , sum(brg)
  , sum(gross_win)
  , sum(trading_net_win)
  , sum(cogs)
  , sum(trading_net_revenue)
from fact_bet
group by user_id, settled_at::date;

analyze;
commit;
