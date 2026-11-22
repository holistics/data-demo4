"""Generate team-folders/Nam/LeoMessi/Dashboards/messi_albiceleste.page.aml as an HTMLLayout.

Static editorial content (hero, chapter heads, photo slots, footer) lives directly in the layout
HTML. Data lives in blocks placed with <h-block>: native charts/tables where Holistics renders
them well, MarkdownViz templates where the mockup needs bespoke cards (KPI strips, match tiles,
finals, awards, timeline). One scrolling story with a sticky chapter bar.
"""
import sys

DS = 'messi_argentina'
W, D, L = '#2a78d6', '#b7c3d1', '#eb6834'
GOLD, GOLD_INK, LOST, NAVY, CELESTE = '#f6b40e', '#3a2600', '#9fb0c3', '#0b2545', '#75aadb'

blocks = []        # (name, aml)
interactions = []  # (filter_block, field_ref, [targets])


def ind(s, n):
    pad = ' ' * n
    return '\n'.join(pad + l if l.strip() else l for l in s.split('\n'))


def add(name, aml):
    blocks.append((name, aml))


# ----------------------------------------------------------------------------- fields
def fmt(kind, pattern=None):
    if kind == 'text':
        return "format {\n  type: 'text'\n}"
    if kind == 'date':
        return "format {\n  type: 'date'\n  pattern: '%s'\n}" % (pattern or 'LLL dd yyyy')
    return "format {\n  type: 'number'\n  pattern: '%s'\n}" % (pattern or 'inherited')


def F(ref, label, kind='text', pattern=None, uname=None, hidden=False):
    extra = ''
    if uname:
        extra += "\n  uname: '%s'" % uname
    if hidden:
        extra += '\n  hidden: true'
    return "VizFieldFull {\n  label: '%s'\n  ref: r(%s)\n%s%s\n}" % (label, ref, ind(fmt(kind, pattern), 2), extra)


def Mt(metric, label, pattern='inherited'):
    return F('%s.%s' % (DS, metric), label, 'number', pattern)


# ----------------------------------------------------------------------------- shared card CSS
# MarkdownViz content is rendered per block, so every template carries the styles it uses.
CARD_CSS = """
.mx { font-family: Rubik, system-ui, sans-serif; color: #0b2545; box-sizing: border-box; height: 100%; }
.mx * { box-sizing: border-box; }
.mx-kpis { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; height: 100%; }
.mx-kpi { background: #fff; border: 1px solid #d3e3f3; border-radius: 14px; padding: 14px 16px; box-shadow: 0 1px 2px rgba(11,37,69,.06), 0 8px 24px -12px rgba(11,37,69,.18); display: flex; flex-direction: column; }
.mx-kpi .l { font: 500 13px/1.2 Rubik, sans-serif; color: #5d7694; }
.mx-kpi .v { font: 900 52px/1 'Big Shoulders Display', Impact, sans-serif; color: #0b2545; margin: 6px 0 4px; }
.mx-kpi .n { font: 400 12px/1.35 Rubik, sans-serif; color: #5d7694; margin-top: auto; }
.mx-kpi.gold { background: #fff2cc; border-color: #e9b42a; }
.mx-kpi.gold .l, .mx-kpi.gold .v, .mx-kpi.gold .n { color: #3a2600; }
.mx-split { display: flex; height: 28px; border-radius: 999px; overflow: hidden; margin: 10px 0 8px; }
.mx-split span { display: flex; align-items: center; justify-content: center; font: 600 12px/1 'DM Mono', monospace; color: #fff; min-width: 28px; }
.mx-split .w { background: #2a78d6; } .mx-split .d { background: #b7c3d1; color: #0b2545; } .mx-split .l { background: #eb6834; }
.mx-legend { display: flex; flex-wrap: wrap; gap: 14px; font: 400 12px/1 Rubik, sans-serif; color: #5d7694; }
.mx-legend i { display: inline-block; width: 10px; height: 10px; border-radius: 3px; margin-right: 6px; vertical-align: -1px; }
.mx-card { background: #fff; border: 1px solid #d3e3f3; border-radius: 14px; padding: 16px 18px; height: 100%; box-shadow: 0 1px 2px rgba(11,37,69,.06), 0 8px 24px -12px rgba(11,37,69,.18); overflow: auto; }
.mx-card h3 { font: 800 22px/1 'Big Shoulders Display', Impact, sans-serif; text-transform: uppercase; margin: 0 0 4px; color: #0b2545; }
.mx-card .sub { font: 400 13px/1.4 Rubik, sans-serif; color: #5d7694; margin: 0 0 12px; }
.mx-pill { display: inline-block; font: 600 11px/1 'DM Mono', monospace; letter-spacing: .04em; text-transform: uppercase; padding: 5px 8px; border-radius: 999px; }
.mx-pill.Win { background: #2a78d6; color: #fff; } .mx-pill.Draw { background: #b7c3d1; color: #0b2545; } .mx-pill.Loss { background: #eb6834; color: #fff; }
.mx-mono { font: 500 11px/1.3 'DM Mono', monospace; letter-spacing: .06em; text-transform: uppercase; color: #5d7694; }
"""


def md_block(name, label, fields, template, sorts=(), vfilter=None, limit=500):
    """A frameless MarkdownViz block: the template draws its own card."""
    flt = ''
    if vfilter:
        flt = "\n  filter {\n    field: r(%s)\n    operator: '%s'\n    value: %s\n  }" % vfilter
    srt = ''
    if sorts:
        srt = "\n    sorts: [\n%s\n    ]" % ind(',\n'.join(
            "SortSetting {\n  key: '%s'\n  direction: '%s'\n}" % s for s in sorts), 6)
    content = '<style>%s</style>\n%s' % (CARD_CSS.strip(), template.strip())
    dims = [f for f in fields if 'ref: r(%s.' % DS not in f]
    mets = [f for f in fields if 'ref: r(%s.' % DS in f]
    vals = ''
    if mets:
        vals = "\n    values: [\n%s\n    ]" % ind(',\n'.join(mets), 6)
    add(name, """block %s: VizBlock {
  label: '%s'
  theme: BlockTheme {
    background {
      bg_color: 'transparent'
    }
    border {
      border_width: 0
      border_radius: 0
      border_style: 'none'
    }
    padding: 0
    shadow: 'none'
  }
  settings {
    hide_label: true
    hide_controls: true
  }
  viz: MarkdownViz {
    dataset: %s%s
    rows: [
%s
    ]%s
    content: @md
%s
;;
    settings {%s
      pagination_size: %d
      row_limit: %d
    }
  }
}""" % (name, label, DS, flt, ind(',\n'.join(dims), 6), vals, content, srt, limit, limit))


def kpi_strip(name, label, metrics, notes, gold=None, dims=()):
    """Four KPI cards from one query. metrics: [(metric, Label)]; notes: template text per card."""
    fields = list(dims) + [Mt(m, lbl) for m, lbl in metrics]
    cards = []
    for (m, lbl), note in zip(metrics, notes):
        cards.append('<div class="mx-kpi"><span class="l">%s</span><span class="v">{{ values.`%s`.formatted }}</span><span class="n">%s</span></div>' % (lbl, lbl, note))
    if gold:
        cards.append(gold)
    tpl = '{%% map(rows) %%}<div class="mx mx-kpis">%s</div>{%% end %%}' % ''.join(cards)
    md_block(name, label, fields, tpl, limit=1)


def ffilter(name, label, field, default=None, input_type=None):
    d = "default {\n  operator: 'is'\n  value: %s\n}" % (default if default else "'$H_NIL$'")
    s = "\nsettings {\n  input_type: '%s'\n}" % input_type if input_type else ''
    add(name, """block %s: FilterBlock {
  label: '%s'
  type: 'field'
  source: FieldFilterSource {
    dataset: %s
    field: r(%s)
  }
%s%s
}""" % (name, label, DS, field, ind(d, 2), ind(s, 2)))


def cf_pill(ref, value, text_c, bg):
    return """ConditionalFormat {
  ref: r(%s)
  format: SingleFormat {
    condition {
      operator: 'is'
      value: '%s'
    }
    text_color: '%s'
    background_color: '%s'
  }
}""" % (ref, value, text_c, bg)


def table(name, label, fields, sort_idx=0, sort_dir='asc', cfs=(), page=25):
    cf = ''
    if cfs:
        cf = "\n    conditional_formats: [\n%s\n    ]" % ind(',\n'.join(cfs), 6)
    add(name, """block %s: VizBlock {
  label: '%s'
  viz: DataTable {
    dataset: %s
    fields: [
%s
    ]
    settings {
      pagination_size: %d
      sorts: [
        IndexBasedSortSetting {
          field_index: %d
          direction: '%s'
        }
      ]%s
    }
  }
}""" % (name, label, DS, ind(',\n'.join(fields), 6), page, sort_idx, sort_dir, cf))


def result_points():
    return """settings {
  point {
    value: 'Win'
    color: '%s'
  }
  point {
    value: 'Draw'
    color: '%s'
  }
  point {
    value: 'Loss'
    color: '%s'
  }
}""" % (W, D, L)


# =====================================================================================
# CHAPTER 1 — THE LAST DANCE
# =====================================================================================
ffilter('f1_year', 'Year', 'messi_matches.year')
ffilter('f1_comp', 'Competition', 'messi_matches.competition_type')
ffilter('f1_coach', 'Coach', 'messi_matches.coach')

md_block('k1_kpis', 'Career KPIs', [
    Mt('messi_caps', 'Caps'), Mt('messi_total_goals', 'Goals'), Mt('messi_win_rate', 'Win rate'),
    Mt('messi_goals_per_match', 'Per match'), Mt('messi_wins', 'Won'), Mt('messi_draws', 'Drawn'),
    Mt('messi_losses', 'Lost')],
    '''{% map(rows) %}<div class="mx" style="display:grid;grid-template-rows:auto 1fr;gap:14px">
<div class="mx-kpis">
<div class="mx-kpi"><span class="l">Caps</span><span class="v">{{ values.`Caps`.formatted }}</span><span class="n">Matches in the selection</span></div>
<div class="mx-kpi"><span class="l">Goals</span><span class="v">{{ values.`Goals`.formatted }}</span><span class="n">{{ values.`Per match`.formatted }} per match</span></div>
<div class="mx-kpi"><span class="l">Win rate</span><span class="v">{{ values.`Win rate`.formatted }}</span><span class="n">After 90/120 minutes</span></div>
<div class="mx-kpi gold"><span class="l">Assists</span><span class="v">65</span><span class="n">Career total, the provider too. Not filterable.</span></div>
</div>
<div class="mx-card"><h3>Won, drawn, lost</h3>
<div class="mx-split"><span class="w" style="flex:{{ values.`Won`.raw }}">{{ values.`Won`.formatted }}</span><span class="d" style="flex:{{ values.`Drawn`.raw }}">{{ values.`Drawn`.formatted }}</span><span class="l" style="flex:{{ values.`Lost`.raw }}">{{ values.`Lost`.formatted }}</span></div>
<div class="mx-legend"><span><i style="background:#2a78d6"></i>Won</span><span><i style="background:#b7c3d1"></i>Drawn</span><span><i style="background:#eb6834"></i>Lost</span><span>Shootouts count as draws</span></div>
</div></div>{% end %}''', limit=1)

add('v1_year', """block v1_year: VizBlock {
  label: 'Every year, every goal'
  description: 'His best year: 18 goals in 2022, the year he won the World Cup. Click a column to filter the chapter.'
  viz: ColumnChart {
    dataset: %s
    x_axis: VizFieldFull {
      label: 'Year'
      ref: r(messi_matches.year)
      format {
        type: 'number'
        pattern: '0'
      }
    }
    legend: VizFieldFull {
      label: 'Competition'
      ref: r(messi_matches.competition_type)
      format {
        type: 'text'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Messi goals'
          ref: r(%s.messi_total_goals)
          format {
            type: 'number'
            pattern: 'inherited'
          }
        }
      }
      settings {
        stack_series_by: 'value'
      }
    }
    settings {
      legend_label: 'bottom'
      sort: LineFamilySort {
        type: 'xaxis'
        direction: 'asc'
      }
    }
  }
}""" % (DS, DS))
table('v1_coach', 'Nine coaches, one constant', [
    F('messi_matches.coach', 'Coach'),
    Mt('messi_caps', 'Caps'), Mt('messi_wins', 'Won'), Mt('messi_draws', 'Drawn'), Mt('messi_losses', 'Lost'),
    Mt('messi_win_rate', 'Win rate'), Mt('messi_total_goals', 'Messi goals'), Mt('messi_goals_per_match', 'Goals / match'),
], sort_idx=1, sort_dir='desc', cfs=["""ConditionalFormat {
  ref: r(%s.messi_win_rate)
  format: ScaleFormat {
    min {
      type: 'percentage'
      value: 0
      color: '#ffffff'
    }
    max {
      type: 'percentage'
      value: 1
      color: '%s'
    }
  }
}""" % (DS, CELESTE)], page=10)
table('v1_log', 'The match log', [
    F('messi_matches.cap_no', 'Cap', 'number', '0'),
    F('messi_matches.match_date', 'Date', 'date'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.competition_type', 'Competition'),
    F('messi_matches.stage', 'Stage'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_label', 'Result'),
    F('messi_matches.messi_goals', 'Messi goals', 'number', '0'),
    F('messi_matches.coach', 'Coach'),
], sort_idx=1, sort_dir='desc', cfs=[
    cf_pill('messi_matches.result_label', 'Win', '#ffffff', W),
    cf_pill('messi_matches.result_label', 'Draw', NAVY, D),
    cf_pill('messi_matches.result_label', 'Loss', '#ffffff', L)], page=15)

T1 = ['k1_kpis', 'v1_year', 'v1_coach', 'v1_log']
interactions += [('f1_year', 'messi_matches.year', T1),
                 ('f1_comp', 'messi_matches.competition_type', T1),
                 ('f1_coach', 'messi_matches.coach', T1)]

# =====================================================================================
# CHAPTER 2 — SIX WORLD CUPS
# =====================================================================================
ffilter('f2_wc', 'World Cup', 'messi_tournaments.world_cup', default="'2022 · Qatar'", input_type='single')
ffilter('f2_metric', 'Compare by', 'messi_params.metric_selector', default="['Goals']", input_type='single')

md_block('k2_kpis', 'World Cup KPIs', [
    F('messi_tournaments.world_cup', 'World Cup'),
    F('messi_tournaments.argentina_finish', 'Finish'),
    F('messi_tournaments.messi_individual_awards', 'Award'),
    Mt('messi_caps', 'Matches'), Mt('messi_total_goals', 'Goals'), Mt('messi_penalty_goals', 'Penalties')],
    '''{% map(rows) %}<div class="mx mx-kpis">
<div class="mx-kpi"><span class="l">Matches</span><span class="v">{{ values.`Matches`.formatted }}</span><span class="n">{{ `World Cup`.formatted }}</span></div>
<div class="mx-kpi"><span class="l">Goals</span><span class="v">{{ values.`Goals`.formatted }}</span><span class="n">Argentina finish: {{ `Finish`.formatted }}</span></div>
<div class="mx-kpi"><span class="l">Penalties</span><span class="v">{{ values.`Penalties`.formatted }}</span><span class="n">Of his goals at this World Cup</span></div>
<div class="mx-kpi gold"><span class="l">Award</span><span class="v" style="font-size:30px;line-height:1.05">{{ `Award`.formatted }}</span><span class="n">Individual honours at the tournament</span></div>
</div>{% end %}''', vfilter=('messi_tournaments.tournament_name', 'is', "'FIFA World Cup'"), limit=1)

md_block('v2_road', 'The road through the tournament', [
    F('messi_matches.match_date', 'Date', 'date', 'dd LLL yyyy', uname='road_date'),
    F('messi_matches.stage', 'Stage'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.city', 'City'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_incl_shootout', 'Result'),
    F('messi_matches.messi_goals', 'Messi goals', 'number', '0')],
    '''<style>
.mx-road { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 12px; }
.mx-step { background: #fff; border: 1px solid #d3e3f3; border-top: 5px solid #b7c3d1; border-radius: 12px; padding: 12px; }
.mx-step.Win { border-top-color: #2a78d6; } .mx-step.Loss { border-top-color: #eb6834; }
.mx-step b { display: block; font: 800 20px/1.05 'Big Shoulders Display', Impact, sans-serif; text-transform: uppercase; margin: 6px 0 4px; }
.mx-step .score { font: 900 30px/1 'Big Shoulders Display', Impact, sans-serif; }
.mx-step .goals { font: 500 12px/1.3 Rubik, sans-serif; color: #3a2600; background: #fff2cc; border-radius: 6px; padding: 3px 6px; display: inline-block; margin-top: 6px; }
</style>
<div class="mx mx-card"><h3>The road through the tournament</h3><p class="sub">One card per match, coloured by the result after penalties.</p><div class="mx-road">
{% map(rows) %}<div class="mx-step {{ `Result`.raw }}"><span class="mx-mono">{{ `Stage`.formatted }} · {{ `Date`.formatted }}</span><b>vs {{ `Opponent`.formatted }}</b><span class="score">{{ `Score`.formatted }}</span> <span class="mx-pill {{ `Result`.raw }}">{{ `Result`.formatted }}</span><br><span class="goals">Messi ⚽ {{ `Messi goals`.formatted }}</span><div class="mx-mono" style="margin-top:6px">{{ `City`.formatted }}</div></div>{% end %}
</div></div>''', sorts=[('road_date', 'asc')], limit=10)

add('v2_summers', """block v2_summers: VizBlock {
  label: 'Six summers side by side'
  description: 'Use "Compare by" to switch the metric. Not affected by the World Cup picker.'
  viz: ColumnChart {
    dataset: %s
    filter {
      field: r(messi_tournaments.tournament_name)
      operator: 'is'
      value: 'FIFA World Cup'
    }
    x_axis: VizFieldFull {
      label: 'World Cup'
      ref: r(messi_tournaments.world_cup)
      format {
        type: 'text'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Selected metric'
          ref: r(%s.messi_selected_metric)
          format {
            type: 'number'
            pattern: '#,##0.##'
          }
        }
        settings {
          color: '%s'
        }
      }
    }
    settings {
      legend_label: 'hidden'
      sort: LineFamilySort {
        type: 'xaxis'
        direction: 'asc'
      }
    }
  }
}""" % (DS, DS, NAVY))

interactions += [('f2_wc', 'messi_tournaments.world_cup', ['k2_kpis', 'v2_road']),
                 ('f2_metric', 'messi_params.metric_selector', ['v2_summers'])]

# =====================================================================================
# CHAPTER 3 — GOAL MACHINE
# =====================================================================================
ffilter('f3_comp', 'Competition', 'messi_matches.competition_type')
ffilter('f3_type', 'Goal type', 'messi_goals.goal_type')
ffilter('f3_opp', 'Opponent', 'messi_matches.opponent')

kpi_strip('k3_kpis', 'Goal KPIs',
          [('messi_total_goals', 'Goals'), ('messi_penalty_goals', 'Penalties'),
           ('messi_hat_tricks', 'Hat-tricks or better'), ('messi_matches_scored_in', 'Matches scored in')],
          ['In the selection', 'From the spot, in play', 'Three or more in a match', 'Caps with at least one goal'])

add('v3_heat', """block v3_heat: VizBlock {
  label: 'Twenty-one years of goals'
  viz: PivotTable {
    dataset: %s
    rows: [
      VizFieldFull {
        label: 'Competition'
        ref: r(messi_matches.competition_type)
        format {
          type: 'text'
        }
      }
    ]
    columns: [
      VizFieldFull {
        label: 'Year'
        ref: r(messi_matches.year)
        format {
          type: 'number'
          pattern: '0'
        }
      }
    ]
    values: [
      VizFieldFull {
        label: 'Goals'
        ref: r(%s.messi_total_goals)
        format {
          type: 'number'
          pattern: 'inherited'
        }
      }
    ]
    settings {
      show_row_total: true
      show_column_total: true
      show_sub_total: false
      empty_cell_as_zero: true
      conditional_formats: [
        ConditionalFormat {
          ref: r(%s.messi_total_goals)
          format: ScaleFormat {
            min {
              type: 'percentage'
              value: 0
              color: '#cde2fb'
            }
            max {
              type: 'percentage'
              value: 1
              color: '#104281'
            }
          }
        }
      ]
      pagination_size: 25
      wrap_header_text: true
    }
  }
}""" % (DS, DS, DS))
add('v3_victims', """block v3_victims: VizBlock {
  label: 'His favourite victims'
  description: 'Top 15 opponents by Messi goals. Click a bar to filter the chapter.'
  viz: BarChart {
    dataset: %s
    x_axis: VizFieldFull {
      label: 'Opponent'
      ref: r(messi_matches.opponent)
      format {
        type: 'text'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Messi goals'
          ref: r(%s.messi_total_goals)
          format {
            type: 'number'
            pattern: 'inherited'
          }
        }
        settings {
          color: '%s'
        }
      }
    }
    settings {
      row_limit: 15
      legend_label: 'hidden'
      sort {
        field_index: 0
        direction: 'desc'
        type: 'yaxis'
      }
    }
  }
}""" % (DS, DS, W))
add('v3_climb', """block v3_climb: VizBlock {
  label: 'The climb to 125'
  description: 'Career goal number by date. Goal 55 (21 Jun 2016) passed Batistuta; goal 100 came against Curaçao in 2023.'
  viz: LineChart {
    dataset: %s
    calculation goal_no {
      label: 'Career goal no.'
      formula: @aql max(messi_goals.career_goal_no);;
      calc_type: 'measure'
      data_type: 'number'
    }
    x_axis: VizFieldFull {
      label: 'Date'
      ref: r(messi_goals.match_date)
      transformation: 'datetrunc day'
      format {
        type: 'date'
        pattern: 'LLL dd yyyy'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Career goal no.'
          ref: 'goal_no'
          format {
            type: 'number'
            pattern: '#,###0'
          }
        }
        settings {
          color: '%s'
        }
      }
    }
    settings {
      legend_label: 'hidden'
      show_data_points: true
      sort: LineFamilySort {
        type: 'xaxis'
        direction: 'asc'
      }
    }
  }
}""" % (DS, W))
md_block('v3_hat', 'Eleven hat-tricks', [
    F('messi_matches.match_date', 'Date', 'date', 'dd LLL yyyy', uname='hat_date'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.competition_type', 'Competition'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.messi_goals', 'Goals', 'number', '0')],
    '''<style>
.mx-hats { display: grid; grid-template-columns: repeat(auto-fill, minmax(170px, 1fr)); gap: 10px; }
.mx-hat { border: 1px solid #e9b42a; background: #fff2cc; border-radius: 12px; padding: 10px 12px; }
.mx-hat .n { font: 900 40px/1 'Big Shoulders Display', Impact, sans-serif; color: #3a2600; }
.mx-hat b { display: block; font: 700 15px/1.2 Rubik, sans-serif; color: #0b2545; }
</style>
<div class="mx mx-card"><h3>Eleven hat-tricks</h3><p class="sub">Every match with three or more Messi goals.</p><div class="mx-hats">
{% map(rows) %}<div class="mx-hat"><span class="n">{{ `Goals`.formatted }}</span><b>vs {{ `Opponent`.formatted }}</b><span class="mx-mono">{{ `Date`.formatted }} · {{ `Score`.formatted }}</span><div class="mx-mono">{{ `Competition`.formatted }}</div></div>{% end %}
</div></div>''', sorts=[('hat_date', 'asc')], vfilter=('messi_matches.is_hat_trick', 'is', 'true'), limit=20)

interactions += [('f3_comp', 'messi_matches.competition_type', ['k3_kpis', 'v3_heat', 'v3_victims', 'v3_climb', 'v3_hat']),
                 ('f3_type', 'messi_goals.goal_type', ['k3_kpis', 'v3_heat', 'v3_victims', 'v3_climb']),
                 ('f3_opp', 'messi_matches.opponent', ['k3_kpis', 'v3_heat', 'v3_victims', 'v3_climb', 'v3_hat'])]

# =====================================================================================
# CHAPTER 4 — RIVALS
# =====================================================================================
ffilter('f4_conf', 'Confederation', 'messi_matches.opponent_confederation')
ffilter('f4_opp', 'Opponent', 'messi_matches.opponent')

md_block('k4_kpis', 'Rival KPIs', [
    Mt('messi_caps', 'Matches'), Mt('messi_wins', 'W'), Mt('messi_draws', 'D'), Mt('messi_losses', 'L'),
    Mt('messi_total_goals', 'Messi goals'), Mt('messi_goals_per_match', 'Goals per match')],
    '''{% map(rows) %}<div class="mx mx-kpis">
<div class="mx-kpi"><span class="l">Matches</span><span class="v">{{ values.`Matches`.formatted }}</span><span class="n">Meetings in the selection</span></div>
<div class="mx-kpi"><span class="l">W–D–L</span><span class="v">{{ values.`W`.formatted }}–{{ values.`D`.formatted }}–{{ values.`L`.formatted }}</span><span class="n">Shootouts count as draws</span></div>
<div class="mx-kpi"><span class="l">Messi goals</span><span class="v">{{ values.`Messi goals`.formatted }}</span><span class="n">Against this selection</span></div>
<div class="mx-kpi"><span class="l">Goals per match</span><span class="v">{{ values.`Goals per match`.formatted }}</span><span class="n">Career rate: 0.60</span></div>
</div>{% end %}''', limit=1)

md_block('v4_tiles', 'Every meeting', [
    F('messi_matches.cap_no', 'Cap', 'number', '0', uname='tile_cap'),
    F('messi_matches.match_date', 'Date', 'date', 'dd LLL yyyy'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_label', 'Result'),
    F('messi_matches.messi_goals', 'Goals', 'number', '0')],
    '''<style>
.mx-tiles { display: flex; flex-wrap: wrap; gap: 5px; }
.mx-tile { width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font: 600 12px/1 'DM Mono', monospace; color: #fff; background: #b7c3d1; }
.mx-tile.Win { background: #2a78d6; } .mx-tile.Loss { background: #eb6834; } .mx-tile.Draw { color: #0b2545; }
.mx-tile.g0 { opacity: .75; }
</style>
<div class="mx mx-card"><h3>Every meeting</h3><p class="sub">One tile per match, in order, coloured by result. The number is Messi's goals. Hover for details.</p>
<div class="mx-legend" style="margin-bottom:12px"><span><i style="background:#2a78d6"></i>Won</span><span><i style="background:#b7c3d1"></i>Drawn</span><span><i style="background:#eb6834"></i>Lost</span></div>
<div class="mx-tiles">{% map(rows) %}<span class="mx-tile {{ `Result`.raw }} g{{ `Goals`.raw }}" title="Cap {{ `Cap`.formatted }} · {{ `Date`.formatted }} · vs {{ `Opponent`.raw }} {{ `Score`.raw }}">{{ `Goals`.formatted }}</span>{% end %}</div></div>''',
    sorts=[('tile_cap', 'asc')], limit=250)

add('v4_conf', """block v4_conf: VizBlock {
  label: 'He beat every continent'
  description: 'Share of matches won, drawn and lost by opponent confederation. Click a bar to filter.'
  viz: BarChart {
    dataset: %s
    x_axis: VizFieldFull {
      label: 'Confederation'
      ref: r(messi_matches.opponent_confederation)
      format {
        type: 'text'
      }
    }
    legend: VizFieldFull {
      label: 'Result'
      ref: r(messi_matches.result_label)
      format {
        type: 'text'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Caps'
          ref: r(%s.messi_caps)
          format {
            type: 'number'
            pattern: 'inherited'
          }
        }
%s
      }
      settings {
        stack_series_by: 'percentage'
        show_data_label_by: 'percentage'
      }
    }
    settings {
      legend_label: 'bottom'
      sort: LineFamilySort {
        type: 'xaxis'
        direction: 'asc'
      }
    }
  }
}""" % (DS, DS, ind(result_points(), 8)))
add('v4_country', """block v4_country: VizBlock {
  label: '36 countries, one shirt'
  description: 'Caps by the country the match was played in.'
  viz: BarChart {
    dataset: %s
    x_axis: VizFieldFull {
      label: 'Venue country'
      ref: r(messi_matches.country)
      format {
        type: 'text'
      }
    }
    y_axis {
      series {
        field: VizFieldFull {
          label: 'Caps'
          ref: r(%s.messi_caps)
          format {
            type: 'number'
            pattern: 'inherited'
          }
        }
        settings {
          color: '%s'
        }
      }
    }
    settings {
      row_limit: 40
      legend_label: 'hidden'
      sort {
        field_index: 0
        direction: 'desc'
        type: 'yaxis'
      }
    }
  }
}""" % (DS, DS, CELESTE))
table('v4_meetings', 'Every meeting, in order', [
    F('messi_matches.match_date', 'Date', 'date'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.competition_type', 'Competition'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_label', 'Result'),
    F('messi_matches.messi_goals', 'Messi goals', 'number', '0'),
], sort_idx=0, sort_dir='asc', cfs=[
    cf_pill('messi_matches.result_label', 'Win', '#ffffff', W),
    cf_pill('messi_matches.result_label', 'Draw', NAVY, D),
    cf_pill('messi_matches.result_label', 'Loss', '#ffffff', L)], page=12)

T4 = ['k4_kpis', 'v4_tiles', 'v4_conf', 'v4_country', 'v4_meetings']
interactions += [('f4_conf', 'messi_matches.opponent_confederation', T4),
                 ('f4_opp', 'messi_matches.opponent', T4)]

# =====================================================================================
# CHAPTER 5 — HEARTBREAK TO GLORY
# =====================================================================================
md_block('v5_finals', 'Nine finals', [
    F('messi_matches.match_date', 'Date', 'date', 'dd LLL yyyy', uname='final_date'),
    F('messi_tournaments.tournament_name', 'Tournament'),
    F('messi_tournaments.year', 'Year', 'number', '0'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.city', 'City'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_incl_shootout', 'Result'),
    F('messi_matches.messi_goals', 'Goals', 'number', '0')],
    '''<style>
.mx-finals { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px; }
.mx-final { border-radius: 14px; padding: 14px; background: #e7f1fb; border: 1px solid #d3e3f3; color: #36506f; }
.mx-final.Win { background: #fff2cc; border-color: #e9b42a; color: #3a2600; }
.mx-final .yr { font: 900 44px/.9 'Big Shoulders Display', Impact, sans-serif; color: #9fb0c3; }
.mx-final.Win .yr { color: #f6b40e; }
.mx-final b { display: block; font: 700 15px/1.25 Rubik, sans-serif; color: #0b2545; margin: 6px 0 2px; }
.mx-final .score { font: 800 22px/1 'Big Shoulders Display', Impact, sans-serif; color: #0b2545; }
.mx-tag { float: right; font: 600 11px/1 'DM Mono', monospace; text-transform: uppercase; padding: 5px 8px; border-radius: 999px; background: #9fb0c3; color: #0b2545; }
.mx-final.Win .mx-tag { background: #f6b40e; color: #3a2600; }
</style>
<div class="mx mx-card"><h3>Nine finals</h3><p class="sub">Four finals lost. Then four won in a row.</p><div class="mx-finals">
{% map(rows) %}<div class="mx-final {{ `Result`.raw }}"><span class="mx-tag">{{ `Result`.formatted }}</span><span class="yr">{{ `Year`.formatted }}</span><b>{{ `Tournament`.formatted }}</b><span class="mx-mono">vs {{ `Opponent`.formatted }} · {{ `City`.formatted }}</span><div class="score" style="margin-top:8px">{{ `Score`.formatted }}</div><span class="mx-mono">{{ `Date`.formatted }} · Messi goals {{ `Goals`.formatted }}</span></div>{% end %}
</div></div>''', sorts=[('final_date', 'asc')], vfilter=('messi_matches.stage', 'is', "'Final'"), limit=20)

md_block('v5_shootouts', 'Nerves of steel', [
    F('messi_matches.match_date', 'Date', 'date', 'dd LLL yyyy', uname='so_date'),
    F('messi_matches.opponent', 'Opponent'),
    F('messi_matches.stage', 'Stage'),
    F('messi_matches.scoreline', 'Score'),
    F('messi_matches.result_incl_shootout', 'Result')],
    '''<style>
.mx-so { display: grid; grid-template-columns: repeat(auto-fill, minmax(190px, 1fr)); gap: 10px; }
.mx-so div { border-left: 5px solid #eb6834; background: #f7fbff; border-radius: 8px; padding: 8px 10px; }
.mx-so div.Win { border-left-color: #2a78d6; }
.mx-so b { display: block; font: 700 14px/1.2 Rubik, sans-serif; }
</style>
<div class="mx mx-card"><h3>Nerves of steel</h3><p class="sub">Matches decided on penalties. They count as draws in the results; the shootout outcome is shown here.</p><div class="mx-so">
{% map(rows) %}<div class="{{ `Result`.raw }}"><span class="mx-pill {{ `Result`.raw }}">{{ `Result`.formatted }}</span><b style="margin-top:6px">vs {{ `Opponent`.formatted }}</b><span class="mx-mono">{{ `Stage`.formatted }} · {{ `Date`.formatted }} · {{ `Score`.formatted }}</span></div>{% end %}
</div></div>''', sorts=[('so_date', 'asc')], vfilter=('messi_matches.went_to_shootout', 'is', 'true'), limit=20)

md_block('v5_awards', 'The honours', [
    F('messi_individual_awards.year', 'Year', 'number', '0', uname='aw_year'),
    F('messi_individual_awards.awarding_body_or_event', 'Event'),
    F('messi_individual_awards.award', 'Award'),
    F('messi_individual_awards.notes', 'Notes'),
    F('messi_individual_awards.award_id', 'Id', 'number', '0', uname='aw_id', hidden=True)],
    '''<style>
.mx-awards { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 12px; }
.mx-award { border: 1px solid #e9b42a; border-radius: 14px; padding: 14px; background: linear-gradient(180deg, #fff2cc, #ffffff 70%); }
.mx-award .yr { font: 900 34px/.9 'Big Shoulders Display', Impact, sans-serif; color: #f6b40e; }
.mx-award b { display: block; font: 800 20px/1.05 'Big Shoulders Display', Impact, sans-serif; text-transform: uppercase; color: #0b2545; margin: 6px 0 4px; }
.mx-award p { margin: 6px 0 0; font: 400 12px/1.35 Rubik, sans-serif; color: #36506f; }
</style>
<div class="mx mx-card"><h3>The honours</h3><p class="sub">Fifteen individual awards won in the sky-blue and white.</p><div class="mx-awards">
{% map(rows) %}<div class="mx-award"><span class="yr">{{ `Year`.formatted }}</span><b>{{ `Award`.formatted }}</b><span class="mx-mono">{{ `Event`.formatted }}</span><p>{{ `Notes`.formatted }}</p></div>{% end %}
</div></div>''', sorts=[('aw_year', 'asc'), ('aw_id', 'asc')], limit=30)

md_block('v5_timeline', 'Milestones', [
    F('messi_milestones.event_date', 'Date', 'date', 'dd LLL yyyy', uname='ms_date'),
    F('messi_milestones.milestone', 'Milestone'),
    F('messi_milestones.detail', 'Detail')],
    '''<style>
.mx-tl { position: relative; margin: 0; padding: 0 0 0 22px; list-style: none; }
.mx-tl:before { content: ""; position: absolute; left: 6px; top: 4px; bottom: 4px; width: 3px; background: #75aadb; border-radius: 3px; }
.mx-tl li { position: relative; padding: 0 0 14px; }
.mx-tl li:before { content: ""; position: absolute; left: -21px; top: 3px; width: 11px; height: 11px; border-radius: 50%; background: #f6b40e; border: 2px solid #0b2545; }
.mx-tl b { display: block; font: 700 15px/1.25 Rubik, sans-serif; color: #0b2545; }
.mx-tl p { margin: 2px 0 0; font: 400 13px/1.4 Rubik, sans-serif; color: #36506f; }
</style>
<div class="mx mx-card"><h3>Milestone by milestone</h3><p class="sub">From a red card on debut to a farewell in a World Cup final.</p><ul class="mx-tl">
{% map(rows) %}<li><span class="mx-mono">{{ `Date`.formatted }}</span><b>{{ `Milestone`.formatted }}</b><p>{{ `Detail`.formatted }}</p></li>{% end %}
</ul></div>''', sorts=[('ms_date', 'asc')], limit=30)

# ---- sanity ------------------------------------------------------------------------
names = [n for n, _ in blocks]
assert len(names) == len(set(names))
for f, _, tgts in interactions:
    assert f in names and all(t in names for t in tgts), (f, tgts)

# =====================================================================================
# LAYOUT
# =====================================================================================
def media(tag, cap, src, h):
    return ('<div class="mx-media" style="height:%dpx"><span class="tag">%s</span><div class="cap">%s'
            '<span class="src">%s</span></div></div>' % (h, tag, cap, src))


def head(anchor, kicker, title, body):
    return ('<section id="%s" class="mxl-chapter"><div class="mx-tabhead"><div><span class="mx-kicker">%s</span>'
            '<h2>%s</h2></div><p>%s</p></div>' % (anchor, kicker, title, body))


def hb(name, h=None, cls=''):
    style = ' style="height:%dpx"' % h if h else ''
    return '<div class="mxl-slot %s"%s><h-block name="%s" /></div>' % (cls, style, name)


LAYOUT_CSS = """
.mxl { --gap: 18px; inline-size: min(100%, 1280px); min-inline-size: 64rem; margin-inline: auto; padding: 0 20px 56px;
  background: #f2f8fe; color: #0b2545; font-family: Rubik, system-ui, sans-serif; }
.mxl * { box-sizing: border-box; }
.mxl h-block { display: block; block-size: 100%; min-inline-size: 0; }
.mxl-slot { min-inline-size: 0; }
.mxl-hero { margin: 0 -20px; }
.mxl-hero .mx-hero { border-radius: 0; min-height: 330px; padding: 34px 40px; }
.mxl-nav { position: sticky; top: 0; z-index: 5; margin: 0 -20px 6px; background: #0b2545; padding: 10px 20px; display: flex; gap: 6px; flex-wrap: wrap; }
.mxl-nav a { color: #c0d5ec; text-decoration: none; font: 600 14px/1 Rubik, sans-serif; padding: 9px 12px; border-radius: 10px; }
.mxl-nav a b { font: 500 11px/1 'DM Mono', monospace; color: #75aadb; margin-right: 6px; }
.mxl-nav a:hover { background: #123766; color: #fff; }
.mxl-chapter { scroll-margin-top: 64px; padding-top: 30px; }
.mxl-chapter .mx-tabhead { height: auto; margin-bottom: 16px; }
.mxl-filters { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: var(--gap); margin-bottom: var(--gap); }
.mxl-filters .mxl-slot { height: 76px; }
.mxl-grid { display: grid; grid-template-columns: repeat(12, minmax(0, 1fr)); gap: var(--gap); margin-bottom: var(--gap); }
.c4 { grid-column: span 4; } .c5 { grid-column: span 5; } .c6 { grid-column: span 6; } .c7 { grid-column: span 7; } .c8 { grid-column: span 8; } .c12 { grid-column: span 12; }
@media (max-width: 900px) {
  .mxl { min-inline-size: 0; }
  .mxl-grid > * { grid-column: 1 / -1; }
  .mxl-filters { grid-template-columns: 1fr 1fr; }
  .mx-tabhead { grid-template-columns: 1fr !important; }
}
"""

HERO = '''<div class="mx-hero"><div class="mx-plate"><span class="mx-eyebrow">Special report · Selección Argentina · 2005–2026</span>
<div class="mx-h1">Gracias, Leo <span class="ten">10</span></div>
<p class="mx-dek">Twenty-one years, 207 caps, 125 goals and the World Cup he was always destined to lift. Lionel Messi leaves the albiceleste as the most-capped and highest-scoring player in its history, and as the captain who finally brought the World Cup home.</p>
<div class="mx-stars"><span class="mx-star">★ 1978</span><span class="mx-star">★ 1986</span><span class="mx-star">★ 2022</span></div></div>
<div class="mx-hero-stats"><div class="mx-hero-stat"><b>207</b><span>Caps · national record</span></div><div class="mx-hero-stat"><b>125</b><span>Goals · national record</span></div><div class="mx-hero-stat"><b>65</b><span>Assists</span></div><div class="mx-hero-stat"><b>6</b><span>World Cups played</span></div></div></div>'''

body = []
body.append('<div class="mxl">')
body.append('<style>%s</style>' % LAYOUT_CSS.strip())
body.append('<header class="mxl-hero">%s</header>' % HERO)
body.append('<nav class="mxl-nav"><a href="#ch1"><b>01</b>The Last Dance</a><a href="#ch2"><b>02</b>Six World Cups</a>'
            '<a href="#ch3"><b>03</b>Goal Machine</a><a href="#ch4"><b>04</b>Rivals</a><a href="#ch5"><b>05</b>Heartbreak to Glory</a></nav>')

# Chapter 1
body.append(head('ch1', 'Chapter 1 · El último baile', 'The Last Dance',
                 'From a 2005 debut in Budapest to a farewell in the 2026 World Cup final, Messi won 134 of his 207 games in the sky-blue and white. Pick any stretch of years, any competition or any coach, and his numbers hold up. Click a year or a coach to zoom in.'))
body.append('<div class="mxl-filters">%s%s%s</div>' % (hb('f1_year'), hb('f1_comp'), hb('f1_coach')))
body.append('<div class="mxl-grid"><div class="c4">%s</div><div class="c8">%s</div></div>' % (
    media('PHOTO / GIF', '18 December 2022: the captain lifts the World Cup in Lusail', 'Photo/GIF slot · GIPHY embed or Wikimedia Commons URL', 330),
    hb('k1_kpis', 330)))
body.append('<div class="mxl-grid">%s</div>' % hb('v1_year', 420, 'c12'))
body.append('<div class="mxl-grid">%s</div>' % hb('v1_coach', 440, 'c12'))
body.append('<div class="mxl-grid">%s</div>' % hb('v1_log', 620, 'c12'))
body.append('</section>')

# Chapter 2
body.append(head('ch2', 'Chapter 2 · Seis Mundiales', 'Six World Cups',
                 'Six tournaments over twenty years. He went from an 18-year-old scoring in Gelsenkirchen to world champion in Lusail. At his sixth, in 2026, he scored eight more. Choose a summer to relive it.'))
body.append('<div class="mxl-filters">%s</div>' % hb('f2_wc'))
body.append('<div class="mxl-grid">%s</div>' % hb('k2_kpis', 160, 'c12'))
body.append('<div class="mxl-grid">%s</div>' % hb('v2_road', 420, 'c12'))
body.append('<div class="mxl-filters">%s</div>' % hb('f2_metric'))
body.append('<div class="mxl-grid">%s</div>' % hb('v2_summers', 400, 'c12'))
body.append('</section>')

# Chapter 3
body.append(head('ch3', 'Chapter 3 · Máquina de goles', 'Goal Machine',
                 "Gabriel Batistuta's record of 54 goals once looked untouchable. Messi passed it in 2016 and then scored 70 more. Here are all 125 goals, with eleven hat-tricks among them. Click a rival to see how they were scored."))
body.append('<div class="mxl-filters">%s%s%s</div>' % (hb('f3_comp'), hb('f3_type'), hb('f3_opp')))
body.append('<div class="mxl-grid">%s</div>' % hb('k3_kpis', 160, 'c12'))
body.append('<div class="mxl-grid">%s</div>' % hb('v3_heat', 320, 'c12'))
body.append('<div class="mxl-grid">%s%s</div>' % (hb('v3_victims', 460, 'c5'), hb('v3_climb', 460, 'c7')))
body.append('<div class="mxl-grid"><div class="c4">%s</div>%s</div>' % (
    media('PHOTO / GIF', 'Goals 97 and 98: two in a World Cup final, against France', 'GIF slot · GIPHY embed', 380),
    hb('v3_hat', 380, 'c8')))
body.append('</section>')

# Chapter 4
body.append(head('ch4', 'Chapter 4 · Rivales', 'Rivals',
                 'Over two decades he faced 63 national teams across five continents and played in 36 countries. Bolivia conceded 11 goals to him. Brazil saw him lift the Copa América at the Maracanã. Pick a rival and look back at every meeting.'))
body.append('<div class="mxl-filters">%s%s</div>' % (hb('f4_conf'), hb('f4_opp')))
body.append('<div class="mxl-grid">%s</div>' % hb('k4_kpis', 160, 'c12'))
body.append('<div class="mxl-grid">%s</div>' % hb('v4_tiles', 340, 'c12'))
body.append('<div class="mxl-grid">%s%s</div>' % (hb('v4_conf', 420, 'c6'), hb('v4_country', 420, 'c6')))
body.append('<div class="mxl-grid">%s</div>' % hb('v4_meetings', 560, 'c12'))
body.append('</section>')

# Chapter 5
body.append(head('ch5', 'Chapter 5 · Del dolor a la gloria', 'Heartbreak to Glory',
                 'He lost four finals and even walked away from the team in 2016. Then he came back and won the next four finals he played, between 2021 and 2024.'))
body.append('<div class="mxl-grid">%s</div>' % hb('v5_finals', 470, 'c12'))
body.append('<div class="mxl-grid"><div class="c6">%s</div><div class="c6">%s</div></div>' % (
    media('PHOTO', '2016, MetLife: the night he said goodbye, then changed his mind', 'Photo slot · Wikimedia Commons, credit the photographer', 340),
    media('PHOTO / GIF', '2022, Lusail: the night it all came true', 'GIF slot · GIPHY embed', 340)))
body.append('<div class="mxl-grid">%s</div>' % hb('v5_shootouts', 300, 'c12'))
body.append('<div class="mxl-grid">%s%s</div>' % (hb('v5_awards', 760, 'c7'), hb('v5_timeline', 760, 'c5')))
body.append('</section>')
body.append('''<footer class="mx-footer"><h2>¡Gracias, <span>Leo!</span></h2><p>207 caps, 125 goals, a World Cup, two Copas América, a Finalissima, and the third star on the shirt. Messi announced his retirement from the national team on 31 August 2026.</p><small>Sources: RSSSF (Roberto Mamrud), Wikipedia goal and achievement lists, 2026 FIFA World Cup final page. Striped jersey panels mark where photos and GIFs go. Assists are a career total and don't change with the filters.</small></footer>''')
body.append('</div>')

placed = set()
for line in body:
    for n in names:
        if '<h-block name="%s" />' % n in line:
            placed.add(n)
assert placed == set(names), set(names) - placed

out = ["""// Messi · Albiceleste 2005–2026 — five-chapter story of Messi's Argentina career, as an HTMLLayout.
// Built from the mockup "Messi · Albiceleste 2005–2026.html". Generated by a script: editorial
// content lives in the layout HTML; data blocks are placed with <h-block>. Every filter is
// wired explicitly to its own chapter's blocks.
Dashboard messi_albiceleste {
  title: 'Messi · Albiceleste 2005–2026'
  description: '''Lionel Messi's senior international career with Argentina in five chapters: the whole career, six World Cups, 125 goals, rivals, and nine finals. Reads dataset messi_argentina (data source demo_nam_leo_messi).'''
  owner: 'nam.tran@holistics.io'
"""]
for _, aml in blocks:
    out.append(ind(aml, 2))
out.append('  explicit_interactions: [')
out.append(',\n'.join(ind("""FilterInteraction {
  from: '%s'
  to: [%s]
  field: r(%s)
}""" % (f, ', '.join("'%s'" % t for t in tgts), fld), 4) for f, fld, tgts in interactions))
out.append('  ]')
out.append('  view: HTMLLayout {\n    content: @html')
out.append('\n'.join(body))
out.append(';;\n  }')
out.append('  theme: messi_theme')
out.append('}')
open(sys.argv[1], 'w').write('\n'.join(out) + '\n')
print('blocks', len(blocks), 'interactions', len(interactions))
