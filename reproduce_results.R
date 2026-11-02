# IgY-RIG funding analysis: numerical reproducibility snapshot (Nov 2026)
# Base R only. All values below are scenario assumptions, not audited forecasts.
# The 594,928 RIG-indicated count is as newly communicated by the team;
# source definition needs verification (earlier slide labels it new vaccination courses).

model <- function(eggs, iu_egg, loss, iu_vial, batches, batch_cost,
                  labour_hours, labour_rate, other_batch, fixed_annual,
                  capex, discount, horizon, delay, price, sold_fraction,
                  extra_unit = 0, demand_cap = Inf) {
  stopifnot(iu_vial > 0, horizon >= 1, delay >= 0, capex > 0,
            discount >= 0, sold_fraction >= 0, sold_fraction <= 1,
            demand_cap >= 0)
  capacity <- eggs * iu_egg * (1-loss) / iu_vial * batches
  sales <- min(capacity * sold_fraction, demand_cap)
  annual_production <- batches * (batch_cost + labour_hours*labour_rate + other_batch)
  annual_cost <- annual_production + fixed_annual + sales*extra_unit
  revenue <- sales * price
  cf <- revenue - annual_cost
  active <- if (delay < horizon) seq.int(delay+1, horizon) else integer(0)
  pv <- function(rate) sum((1+rate)^(-active))
  npv <- -capex + cf*pv(discount)
  irr_fn <- function(rate) -capex + cf*pv(rate)
  irr <- NA_real_
  if (cf > 0 && length(active) > 0 && irr_fn(-0.99)*irr_fn(5) < 0) {
    irr <- uniroot(irr_fn, interval=c(-0.99,5), tol=1e-12)$root
  }
  be_price <- if (sales > 0 && length(active)>0)
    (capex/pv(discount) + annual_production + fixed_annual)/sales + extra_unit else Inf
  be_sales <- if (price > extra_unit && length(active)>0)
    (capex/pv(discount) + annual_production + fixed_annual)/(price-extra_unit) else Inf
  c(capacity=capacity, sales=sales, revenue=revenue, annual_cost=annual_cost,
    cashflow=cf, npv=npv, pi=(npv+capex)/capex, irr=irr,
    npv_break_even_price=be_price, npv_break_even_sales=be_sales)
}

ct <- list(eggs=2600, iu_egg=1000, loss=0, iu_vial=400, batches=25,
  batch_cost=70960, labour_hours=144, labour_rate=156.25,
  other_batch=10000, fixed_annual=5e6, capex=150e6,
  discount=.05, horizon=10, delay=5, price=300, sold_fraction=.6,
  extra_unit=0)

ct_as_entered <- ct
ct_as_entered$loss <- .05
ct_as_entered$labour_rate <- 937.5

csv <- list(eggs=7000, iu_egg=1000, loss=.05, iu_vial=400, batches=25,
  batch_cost=70960, labour_hours=144, labour_rate=1500,
  other_batch=1200, fixed_annual=20e6, capex=450e6,
  discount=.05, horizon=20, delay=5, price=400, sold_fraction=.6,
  extra_unit=50)

# The CSV A/B rig_receipt fields (91.8% vs 84.68%) do not enter this financial model.
reported_exposures <- 1451921
reported_vaccine <- 702567
reported_rig_indicated <- 594928
rig_share <- reported_rig_indicated/reported_vaccine
assumed_igy_uptake <- .10       # scenario assumption, not observed
assumed_vials_per_person <- 2   # hypothetical, not approved clinical dose
demand_cap <- reported_rig_indicated * assumed_igy_uptake * assumed_vials_per_person

results <- rbind(
  CT_as_entered=do.call(model, ct_as_entered),
  CT_reconciled=do.call(model, ct),
  Shiny_A_and_B=do.call(model, csv),
  Shiny_demand_limited=do.call(model, c(csv, list(demand_cap=demand_cap)))
)
print(round(results, 4))
cat('\nRIG indicated / vaccinated (team-reported):', round(rig_share*100, 2), '%\n')
cat('Hypothetical IgY demand (vials):', demand_cap, '\n')
cat('Uptake needed for Shiny target sales:',
    round(results['Shiny_A_and_B','sales']/(reported_rig_indicated*assumed_vials_per_person)*100,2),'%\n')

# Numeric regression checks against November 2026 reconciled workbook
stopifnot(abs(results['CT_reconciled','npv']/1e6 - (-76.5118132158)) < 1e-5)
stopifnot(abs(results['CT_as_entered','npv']/1e6 - (-91.0137172711)) < 1e-5)
stopifnot(abs(results['Shiny_A_and_B','npv']/1e6 - 38.5922739907) < 1e-5)
stopifnot(abs(results['Shiny_demand_limited','npv']/1e6 - (-332.5555183533)) < 1e-5)
cat('Numeric regression checks passed.\n')
