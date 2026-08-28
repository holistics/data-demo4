-- ShelfOptix — P&G RetailFocus "Shelf Availability Executive Summary" seed.
-- Source: RetailFocus _ Shelf Availability — Executive Summary_v20260803_MDM.html
-- (customer export dated 2026-08-03, delivered in #holistics-shelfoptix-external 2026-08-04).
-- These are ShelfOptix's REAL P&G figures lifted from the embedded chart data, not synthetic.
--
-- Recovered and verified against all 40 rows (0 mismatches):
--   base_osa_pct = instock_ct / observed_ct
--   adj_osa_pct  = (instock_ct - ghost_ct) / observed_ct
-- Both are therefore computed in the semantic layer, NOT stored here.
--
-- Run in the BigQuery console against project data-demo-502609.

CREATE SCHEMA IF NOT EXISTS `data-demo-502609.shelfoptix_pg`;

CREATE OR REPLACE TABLE `data-demo-502609.shelfoptix_pg.pg_osa_weekly` (
  week_date   DATE NOT NULL,
  observed_ct INT64,
  instock_ct  INT64,
  oos_ct      INT64,
  ghost_ct    INT64,
  negoh_ct    INT64,
  store_count INT64
);
INSERT INTO `data-demo-502609.shelfoptix_pg.pg_osa_weekly`
  (week_date, observed_ct, instock_ct, oos_ct, ghost_ct, negoh_ct, store_count)
VALUES
  (DATE '2026-05-11', 315478, 269967, 38730, 0, 6781, 279),
  (DATE '2026-05-18', 313399, 269978, 36736, 31236, 6685, 278),
  (DATE '2026-05-25', 311788, 270389, 34897, 30935, 6502, 278),
  (DATE '2026-06-01', 311946, 269367, 36386, 30095, 6193, 278),
  (DATE '2026-06-08', 312997, 270974, 35876, 32679, 6147, 278),
  (DATE '2026-06-15', 311678, 270869, 34748, 34333, 6061, 278),
  (DATE '2026-06-22', 310910, 270389, 34626, 32332, 5895, 278),
  (DATE '2026-06-29', 310719, 271810, 33134, 31975, 5775, 278),
  (DATE '2026-07-06', 314489, 275329, 33679, 31927, 5481, 278),
  (DATE '2026-07-13', 316051, 277829, 32952, 31840, 5270, 278);

-- Test/control arms. TREATED_PRE and TREATED_POST are the treated stores before and
-- after the service began; UNTREATED is the matched control. pair_count is the number
-- of matched store-SKU pairs behind each week.
CREATE OR REPLACE TABLE `data-demo-502609.shelfoptix_pg.pg_osa_weekly_arms` (
  week_date   DATE   NOT NULL,
  arm         STRING NOT NULL,
  observed_ct INT64,
  instock_ct  INT64,
  oos_ct      INT64,
  ghost_ct    INT64,
  negoh_ct    INT64,
  store_count INT64,
  pair_count  INT64
);
INSERT INTO `data-demo-502609.shelfoptix_pg.pg_osa_weekly_arms`
  (week_date, arm, observed_ct, instock_ct, oos_ct, ghost_ct, negoh_ct, store_count, pair_count)
VALUES
  (DATE '2026-05-11', 'TREATED_POST', 304, 304, 0, 0, 0, 30, 304),
  (DATE '2026-05-18', 'TREATED_POST', 1658, 1631, 16, 348, 11, 166, 1658),
  (DATE '2026-05-25', 'TREATED_POST', 2811, 2770, 31, 693, 10, 259, 2811),
  (DATE '2026-06-01', 'TREATED_POST', 3839, 3773, 48, 910, 18, 267, 3839),
  (DATE '2026-06-08', 'TREATED_POST', 4880, 4818, 47, 1341, 15, 276, 4880),
  (DATE '2026-06-15', 'TREATED_POST', 5840, 5807, 24, 1826, 9, 277, 5840),
  (DATE '2026-06-22', 'TREATED_POST', 6764, 6691, 56, 1839, 17, 277, 6764),
  (DATE '2026-06-29', 'TREATED_POST', 7686, 7637, 33, 2055, 16, 277, 7686),
  (DATE '2026-07-06', 'TREATED_POST', 8323, 8221, 85, 2292, 17, 277, 8323),
  (DATE '2026-07-13', 'TREATED_POST', 9359, 9296, 48, 2587, 15, 277, 9359),
  (DATE '2026-05-11', 'TREATED_PRE', 13768, 13550, 181, 0, 37, 278, 13768),
  (DATE '2026-05-18', 'TREATED_PRE', 12549, 12247, 251, 3429, 51, 278, 12549),
  (DATE '2026-05-25', 'TREATED_PRE', 11395, 11192, 158, 3074, 45, 278, 11395),
  (DATE '2026-06-01', 'TREATED_PRE', 10367, 10055, 269, 2597, 43, 278, 10367),
  (DATE '2026-06-08', 'TREATED_PRE', 9326, 9079, 214, 2638, 33, 278, 9326),
  (DATE '2026-06-15', 'TREATED_PRE', 8366, 8263, 88, 2585, 15, 278, 8366),
  (DATE '2026-06-22', 'TREATED_PRE', 7442, 7296, 133, 2084, 13, 278, 7442),
  (DATE '2026-06-29', 'TREATED_PRE', 6520, 6447, 59, 1768, 14, 278, 6520),
  (DATE '2026-07-06', 'TREATED_PRE', 5883, 5794, 78, 1509, 11, 277, 5883),
  (DATE '2026-07-13', 'TREATED_PRE', 4847, 4814, 28, 1178, 5, 272, 4847),
  (DATE '2026-05-11', 'UNTREATED', 66687, 64168, 2192, 0, 327, 279, 66687),
  (DATE '2026-05-18', 'UNTREATED', 66535, 64017, 2178, 27459, 340, 278, 66535),
  (DATE '2026-05-25', 'UNTREATED', 66382, 64142, 1904, 27168, 336, 278, 66382),
  (DATE '2026-06-01', 'UNTREATED', 66351, 63780, 2219, 26588, 352, 278, 66351),
  (DATE '2026-06-08', 'UNTREATED', 66330, 63666, 2290, 28700, 374, 278, 66330),
  (DATE '2026-06-15', 'UNTREATED', 66298, 64241, 1705, 29922, 352, 278, 66298),
  (DATE '2026-06-22', 'UNTREATED', 66279, 63969, 1950, 28409, 360, 278, 66279),
  (DATE '2026-06-29', 'UNTREATED', 66262, 64333, 1556, 28152, 373, 278, 66262),
  (DATE '2026-07-06', 'UNTREATED', 66248, 64070, 1798, 28126, 380, 278, 66248),
  (DATE '2026-07-13', 'UNTREATED', 66233, 64386, 1552, 28075, 295, 278, 66233);
