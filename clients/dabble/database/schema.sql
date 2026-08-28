create schema if not exists dabble_demo;

create table if not exists dabble_demo.dim_user (
  user_id bigint primary key
, source_user_id text not null unique
, display_alias text not null unique
, home_state text not null check (home_state in ('ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA'))
, signup_date date not null
, acquisition_category text not null
, risk_rating text not null check (risk_rating in ('Low', 'Medium', 'High', 'Other / Unclassified'))
, risk_factor numeric(8,4) not null
);

create table if not exists dabble_demo.dim_sport (
  sport_id integer primary key
, source_sport_id text not null unique
, sport_name text not null unique
, is_racing boolean not null
);

create table if not exists dabble_demo.dim_competition (
  competition_id integer primary key
, source_competition_id text not null unique
, sport_id integer not null references dabble_demo.dim_sport (sport_id)
, competition_name text not null
, country_code char(2) not null
, competition_state text check (competition_state is null or competition_state in ('ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA'))
, unique (sport_id, competition_name)
);

create table if not exists dabble_demo.dim_fixture (
  fixture_id bigint primary key
, source_fixture_id text not null unique
, competition_id integer not null references dabble_demo.dim_competition (competition_id)
, fixture_name text not null
, advertised_start timestamptz not null
, actual_close_time timestamptz not null
, fixture_status text not null check (fixture_status = 'Settled')
);

create table if not exists dabble_demo.dim_market (
  market_id bigint primary key
, source_market_id text not null unique
, fixture_id bigint not null references dabble_demo.dim_fixture (fixture_id)
, market_name text not null
, market_group text not null
);

create table if not exists dabble_demo.fact_bet (
  bet_id bigint primary key
, source_bet_id text not null unique
, user_id bigint not null references dabble_demo.dim_user (user_id)
, bet_type text not null check (bet_type in ('Single', 'Multi', 'SGM', 'Each Way', 'Dabble Div'))
, leg_count smallint not null check (leg_count between 1 and 25)
, rocket_category text not null check (rocket_category in ('Copied Rocket Bet', 'Non Copied Rocket Bet', 'Not Rocket'))
, placed_at timestamptz not null
, settled_at timestamptz not null check (settled_at >= placed_at)
, placed_risk_rating text not null check (placed_risk_rating in ('Low', 'Medium', 'High', 'Other / Unclassified'))
, placed_risk_factor numeric(8,4) not null
, cash_stake numeric(18,2) not null check (cash_stake >= 0)
, bonus_stake numeric(18,2) not null check (bonus_stake >= 0)
, combined_stake numeric(18,2) not null check (combined_stake = cash_stake + bonus_stake)
, restricted_stake numeric(18,2) not null check (restricted_stake >= 0 and restricted_stake <= combined_stake)
, cash_payout numeric(18,2) not null check (cash_payout >= 0)
, bonus_payout numeric(18,2) not null check (bonus_payout >= 0)
, combined_payout numeric(18,2) not null check (combined_payout = cash_payout + bonus_payout)
, rocket_boost numeric(18,2) not null check (rocket_boost >= 0)
, brg numeric(18,2) not null check (brg >= 0)
, gross_win numeric(18,2) not null check (gross_win = cash_stake - cash_payout + rocket_boost)
, trading_net_win numeric(18,2) not null check (trading_net_win = gross_win - brg)
, nt_tax numeric(18,2) not null check (nt_tax >= 0)
, premium_experiences numeric(18,2) not null check (premium_experiences >= 0)
, betstop_levies numeric(18,2) not null check (betstop_levies >= 0)
, gst numeric(18,2) not null check (gst >= 0)
, poc numeric(18,2) not null check (poc >= 0)
, sky_racing numeric(18,2) not null check (sky_racing >= 0)
, product_fee numeric(18,2) not null check (product_fee >= 0)
, payment_processing_fees numeric(18,2) not null check (payment_processing_fees >= 0)
, cogs numeric(18,2) not null check (cogs = nt_tax + premium_experiences + betstop_levies + gst + poc + sky_racing + product_fee + payment_processing_fees)
, trading_net_revenue numeric(18,2) not null check (trading_net_revenue = trading_net_win - cogs)
);

create table if not exists dabble_demo.fact_bet_leg (
  bet_leg_id bigint primary key
, source_bet_leg_id text not null unique
, bet_id bigint not null references dabble_demo.fact_bet (bet_id) on delete cascade
, leg_number smallint not null check (leg_number > 0)
, market_id bigint not null references dabble_demo.dim_market (market_id)
, selection_name text not null
, result text not null check (result in ('Won', 'Lost'))
, dividend numeric(12,4) not null check (dividend >= 1)
, cash_stake numeric(18,2) not null check (cash_stake >= 0)
, bonus_stake numeric(18,2) not null check (bonus_stake >= 0)
, combined_stake numeric(18,2) not null check (combined_stake = cash_stake + bonus_stake)
, restricted_stake numeric(18,2) not null check (restricted_stake >= 0 and restricted_stake <= combined_stake)
, cash_payout numeric(18,2) not null check (cash_payout >= 0)
, bonus_payout numeric(18,2) not null check (bonus_payout >= 0)
, combined_payout numeric(18,2) not null check (combined_payout = cash_payout + bonus_payout)
, rocket_boost numeric(18,2) not null check (rocket_boost >= 0)
, brg numeric(18,2) not null check (brg >= 0)
, gross_win numeric(18,2) not null check (gross_win = cash_stake - cash_payout + rocket_boost)
, trading_net_win numeric(18,2) not null check (trading_net_win = gross_win - brg)
, nt_tax numeric(18,2) not null check (nt_tax >= 0)
, premium_experiences numeric(18,2) not null check (premium_experiences >= 0)
, betstop_levies numeric(18,2) not null check (betstop_levies >= 0)
, gst numeric(18,2) not null check (gst >= 0)
, poc numeric(18,2) not null check (poc >= 0)
, sky_racing numeric(18,2) not null check (sky_racing >= 0)
, product_fee numeric(18,2) not null check (product_fee >= 0)
, payment_processing_fees numeric(18,2) not null check (payment_processing_fees >= 0)
, cogs numeric(18,2) not null check (cogs = nt_tax + premium_experiences + betstop_levies + gst + poc + sky_racing + product_fee + payment_processing_fees)
, trading_net_revenue numeric(18,2) not null check (trading_net_revenue = trading_net_win - cogs)
, unique (bet_id, leg_number)
);

alter table dabble_demo.fact_bet_leg
  add column if not exists dividend numeric(12,4) not null default 1 check (dividend >= 1);

create table if not exists dabble_demo.fact_user_day (
  user_id bigint not null references dabble_demo.dim_user (user_id) on delete cascade
, reporting_date date not null
, bets_count integer not null check (bets_count > 0)
, legs_count integer not null check (legs_count >= bets_count)
, cash_stake numeric(18,2) not null
, bonus_stake numeric(18,2) not null
, combined_stake numeric(18,2) not null check (combined_stake = cash_stake + bonus_stake)
, restricted_stake numeric(18,2) not null
, cash_payout numeric(18,2) not null
, bonus_payout numeric(18,2) not null
, combined_payout numeric(18,2) not null check (combined_payout = cash_payout + bonus_payout)
, rocket_boost numeric(18,2) not null
, brg numeric(18,2) not null
, gross_win numeric(18,2) not null check (gross_win = cash_stake - cash_payout + rocket_boost)
, trading_net_win numeric(18,2) not null check (trading_net_win = gross_win - brg)
, cogs numeric(18,2) not null
, trading_net_revenue numeric(18,2) not null check (trading_net_revenue = trading_net_win - cogs)
, primary key (user_id, reporting_date)
);

create index if not exists dim_competition_sport_idx on dabble_demo.dim_competition (sport_id);
create index if not exists dim_fixture_competition_start_idx on dabble_demo.dim_fixture (competition_id, advertised_start);
create index if not exists dim_market_fixture_idx on dabble_demo.dim_market (fixture_id);
create index if not exists fact_bet_user_settled_idx on dabble_demo.fact_bet (user_id, settled_at);
create index if not exists fact_bet_type_idx on dabble_demo.fact_bet (bet_type);
create index if not exists fact_bet_risk_idx on dabble_demo.fact_bet (placed_risk_factor, placed_risk_rating);
create index if not exists fact_bet_leg_bet_idx on dabble_demo.fact_bet_leg (bet_id);
create index if not exists fact_bet_leg_market_idx on dabble_demo.fact_bet_leg (market_id);
create index if not exists fact_user_day_date_idx on dabble_demo.fact_user_day (reporting_date);
