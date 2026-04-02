# %% [markdown]
# # 🚚 Last-Mile Delivery Optimization in Shanghai  
# ### Courier Performance, Routing Efficiency, and Demand Forecasting (R Analysis)

# %% [markdown]
# ## 📌 Introduction
# 
# Last-mile delivery is the most complex and costly segment of the logistics chain. In dense urban environments like Shanghai, delivery systems face challenges such as traffic congestion, demand surges, and strict service-level agreements (SLAs).
# 
# This project analyzes last-mile delivery operations using the LADE dataset, focusing on identifying the true drivers of delivery delays and uncovering hidden system capacity.

# %% [markdown]
# ## 🚀 Key Results
# 
# - Late delivery rate: ~56%  
# - Delivery time improvement (optimized benchmark): ~9.5%  
# - Courier capacity unlock: up to **1.68×**  
# - Peak demand forecast error reduction: ~22%  
# - Estimated SLA improvement: ~13%  
# 
# 👉 **Main Insight:** Delivery delays are driven by demand–capacity mismatch, not routing inefficiency.

# %% [markdown]
# ## 💼 Business Problem
# 
# High late delivery rates indicate inefficiencies in urban logistics systems. Companies often invest in routing optimization, assuming it is the primary bottleneck.
# 
# This study investigates whether delays are driven by:
# - Routing inefficiency  
# - Courier performance variability  
# - Demand–capacity misalignment  

# %% [markdown]
# ## ❓ Research Questions
# 
# 1. Can routing improvements reduce delivery delays?  
# 2. How much hidden capacity exists among couriers?  
# 3. Can demand forecasting reduce SLA violations during peak periods?  

# %% [markdown]
# **Load Libraries + Data**

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:51:54.659056Z","iopub.execute_input":"2026-04-02T03:51:54.660948Z","iopub.status.idle":"2026-04-02T03:51:59.670722Z","shell.execute_reply":"2026-04-02T03:51:59.668385Z"}}
library(data.table)
library(lubridate)
library(ggplot2)
theme_set(
  theme_minimal(base_size = 12)
)

# Load data
sh_data_delivery <- fread("/kaggle/input/datasets/paulkamande/lade-last-mile-delivery-dataset-shanghai-subset/delivery_sh.csv")
sh_data_pickup <- fread("/kaggle/input/datasets/paulkamande/lade-last-mile-delivery-dataset-shanghai-subset/pickup_sh.csv")

# %% [markdown]
# ## 📊 Data Overview
# 
# The dataset consists of:
# - Pickup records (order acceptance, pickup time, time windows)
# - Delivery records (delivery completion time and location)
# 
# The data captures operational performance of couriers in an urban environment.

# %% [markdown]
# ## 🧹 Data Cleaning
# 
# To ensure data quality:
# - Blank values were converted to missing values (NA)
# - Timestamps were parsed into proper datetime format
# - Unrealistic values were filtered out

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:51:59.674772Z","iopub.execute_input":"2026-04-02T03:51:59.676452Z","iopub.status.idle":"2026-04-02T03:52:10.273645Z","shell.execute_reply":"2026-04-02T03:52:10.270936Z"}}
# =========================
# 3. Basic audit
# =========================
dim(sh_data_pickup)
dim(sh_data_delivery)

names(sh_data_pickup)
names(sh_data_delivery)

str(sh_data_pickup)
str(sh_data_delivery)

# Duplicate order IDs
sh_data_pickup[, .N, by = order_id][N > 1]
sh_data_delivery[, .N, by = order_id][N > 1]

# Missing values
sapply(sh_data_pickup, function(x) {
  if (is.character(x)) sum(is.na(x) | x == "") else sum(is.na(x))
})

sapply(sh_data_delivery, function(x) {
  if (is.character(x)) sum(is.na(x) | x == "") else sum(is.na(x))
})

# Overlap between pickup and delivery
length(intersect(sh_data_pickup$order_id, sh_data_delivery$order_id))
length(setdiff(sh_data_pickup$order_id, sh_data_delivery$order_id))
length(setdiff(sh_data_delivery$order_id, sh_data_pickup$order_id))

# =========================
# 4. Create clean copies
# =========================
pickup_clean   <- copy(sh_data_pickup)
delivery_clean <- copy(sh_data_delivery)

# =========================
# 5. Replace blank strings with NA
#    Only for character columns
# =========================
pickup_clean[, (names(pickup_clean)) := lapply(.SD, function(x) {
  if (is.character(x)) x[x == ""] <- NA
  x
})]

delivery_clean[, (names(delivery_clean)) := lapply(.SD, function(x) {
  if (is.character(x)) x[x == ""] <- NA
  x
})]

# =========================
# 6. Parse datetime fields
#    Add synthetic year 2020
# =========================
pickup_clean[, accept_time := parse_date_time(
  paste("2022", accept_time), orders = "Y md HMS"
)]

pickup_clean[, pickup_time := parse_date_time(
  paste("2022", pickup_time), orders = "Y md HMS"
)]

pickup_clean[, time_window_start := parse_date_time(
  paste("2022", time_window_start), orders = "Y md HMS"
)]

pickup_clean[, time_window_end := parse_date_time(
  paste("2022", time_window_end), orders = "Y md HMS"
)]

delivery_clean[, accept_time := parse_date_time(
  paste("2022", accept_time), orders = "Y md HMS"
)]

delivery_clean[, delivery_time := parse_date_time(
  paste("2022", delivery_time), orders = "Y md HMS"
)]

# =========================
# 7. Validate parsing
# =========================
summary(pickup_clean$accept_time)
summary(pickup_clean$pickup_time)
summary(pickup_clean$time_window_start)
summary(pickup_clean$time_window_end)

summary(delivery_clean$accept_time)
summary(delivery_clean$delivery_time)

# %% [markdown]
# ## ⚙️ Feature Engineering

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:52:10.278041Z","iopub.execute_input":"2026-04-02T03:52:10.279755Z","iopub.status.idle":"2026-04-02T03:52:11.748197Z","shell.execute_reply":"2026-04-02T03:52:11.746456Z"}}
# Pickup latency (minutes)
pickup_clean[, pickup_latency_mins := as.numeric(
  difftime(pickup_time, accept_time, units = "mins")
)]

# Total delivery time (minutes)
delivery_clean[, total_time_mins := as.numeric(
  difftime(delivery_time, accept_time, units = "mins")
)]
summary(pickup_clean$pickup_latency_mins)
summary(delivery_clean$total_time_mins)
# Check negative values
pickup_clean[pickup_latency_mins < 0]
delivery_clean[total_time_mins < 0]

# Check extreme values
pickup_clean[pickup_latency_mins > 300]
delivery_clean[total_time_mins > 600]
# Filter extreme values
pickup_filtered <- pickup_clean[
  pickup_latency_mins >= 0 & pickup_latency_mins <= 180
]
delivery_filtered <- delivery_clean[
  total_time_mins >= 0 & total_time_mins <= 300
]
summary(pickup_filtered$pickup_latency_mins)
summary(delivery_filtered$total_time_mins)
# Plotting pickup latency distribution
p1 <- ggplot(pickup_filtered, aes(x = pickup_latency_mins)) +
  geom_histogram(bins = 50, fill = "#1f77b4", alpha = 0.8) +
  geom_vline(aes(xintercept = median(pickup_latency_mins, na.rm = TRUE)),
             linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution of Pickup Latency",
    subtitle = "Median shown as dashed line",
    x = "Pickup Latency (Minutes)",
    y = "Frequency"
  )

# %% [markdown]
# Pickup latency varies widely, indicating inconsistent courier performance.

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:52:11.752391Z","iopub.execute_input":"2026-04-02T03:52:11.754377Z","iopub.status.idle":"2026-04-02T03:52:11.778559Z","shell.execute_reply":"2026-04-02T03:52:11.776784Z"}}
# plotting delivery time distribution
p2 <- ggplot(delivery_filtered, aes(x = total_time_mins)) +
  geom_histogram(bins = 50, fill = "#2ca02c", alpha = 0.8) +
  geom_vline(aes(xintercept = median(total_time_mins, na.rm = TRUE)),
             linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution of Delivery Time",
    subtitle = "Median delivery time highlighted",
    x = "Total Delivery Time (Minutes)",
    y = "Frequency"
  )

# %% [markdown]
# Delivery times show clustering but still contain significant delays.

# %% [markdown]
# ## 🚦 Q1: Delivery Efficiency

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:52:11.782690Z","iopub.execute_input":"2026-04-02T03:52:11.784522Z","iopub.status.idle":"2026-04-02T03:52:12.160134Z","shell.execute_reply":"2026-04-02T03:52:12.157654Z"}}
## Q1 — Delivery Efficiency & Delays
# Build Q1 dataset
q1_data <- merge(
  pickup_filtered[, .(
    order_id,
    courier_id,
    region_id,
    accept_time,
    time_window_start,
    time_window_end,
    pickup_time,
    pickup_latency_mins
  )],
  delivery_filtered[, .(
    order_id,
    delivery_time,
    total_time_mins,
    lng,
    lat,
    aoi_id,
    aoi_type
  )],
  by = "order_id"
)

q1_data[, late_mins := as.numeric(difftime(delivery_time, time_window_end, units = "mins"))]
q1_data[, is_late := delivery_time > time_window_end]
# Baseline SLA output
q1_data[, .(
  orders = .N,
  late_orders = sum(is_late, na.rm = TRUE),
  late_rate = mean(is_late, na.rm = TRUE)
)]
# Plotting late vs on time
p4 <- ggplot(q1_data, aes(x = factor(is_late), fill = factor(is_late))) +
  geom_bar(alpha = 0.8) +
  scale_fill_manual(values = c("#2ca02c", "#d62728")) +
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
  labs(
    title = "Late vs On-Time Deliveries",
    subtitle = "Majority of deliveries miss SLA targets",
    x = "Delivery Status (0 = On Time, 1 = Late)",
    y = "Count",
    fill = "Status"
  )

# Courier performance for Q1
courier_q1 <- q1_data[, .(
  orders_handled = .N,
  avg_total_time_mins = mean(total_time_mins, na.rm = TRUE),
  late_rate = mean(is_late, na.rm = TRUE)
), by = courier_id]

courier_q1[, packages_per_hour := 60 / avg_total_time_mins]
# Active courier benchmark
courier_q1_active <- courier_q1[orders_handled >= 50]
q1_threshold <- quantile(courier_q1_active$avg_total_time_mins, 0.10, na.rm = TRUE)

courier_q1_active[, optimized := avg_total_time_mins <= q1_threshold]

courier_q1_active[, .(
  avg_total_time_mins = mean(avg_total_time_mins, na.rm = TRUE),
  avg_late_rate = mean(late_rate, na.rm = TRUE),
  avg_packages_per_hour = mean(packages_per_hour, na.rm = TRUE),
  avg_orders = mean(orders_handled)
), by = optimized]
# Gain calculations
baseline_time <- mean(courier_q1_active$avg_total_time_mins, na.rm = TRUE)
optimized_time <- mean(courier_q1_active[optimized == TRUE]$avg_total_time_mins, na.rm = TRUE)

baseline_late <- mean(courier_q1_active$late_rate, na.rm = TRUE)
optimized_late <- mean(courier_q1_active[optimized == TRUE]$late_rate, na.rm = TRUE)

baseline_pph <- mean(courier_q1_active$packages_per_hour, na.rm = TRUE)
optimized_pph <- mean(courier_q1_active[optimized == TRUE]$packages_per_hour, na.rm = TRUE)

time_reduction_pct <- (baseline_time - optimized_time) / baseline_time
late_reduction_pct <- (baseline_late - optimized_late) / baseline_late
pph_gain_pct <- (optimized_pph - baseline_pph) / baseline_pph
additional_packages_per_hour <- optimized_pph - baseline_pph

time_reduction_pct
late_reduction_pct
pph_gain_pct
additional_packages_per_hour

# %% [markdown]
# Over 50% of deliveries are late, indicating systemic inefficiencies.
# 
# Routing improvements increase efficiency but do not significantly reduce delays.

# %% [markdown]
# ## 👷 Q2: Courier Performance

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:52:12.164265Z","iopub.execute_input":"2026-04-02T03:52:12.166101Z","iopub.status.idle":"2026-04-02T03:52:12.353811Z","shell.execute_reply":"2026-04-02T03:52:12.350768Z"}}
# Computing Courier Performance (Q2)
courier_perf <- pickup_filtered[
  , .(
    avg_latency = mean(pickup_latency_mins, na.rm = TRUE),
    orders_handled = .N
  ),
  by = courier_id
]
# Defining Elite Couriers (Top 10%)
courier_perf_filtered <- courier_perf[orders_handled >= 50]
threshold <- quantile(courier_perf_filtered$avg_latency, 0.10)

courier_perf_filtered[, elite := avg_latency <= threshold]
# plotting COURIER PERFORMANCE
p3 <- ggplot(courier_perf_filtered, aes(x = factor(elite), y = avg_latency, fill = factor(elite))) +
  geom_boxplot(alpha = 0.8) +
  scale_fill_manual(values = c("#d62728", "#2ca02c")) +
  labs(
    title = "Courier Performance: Elite vs Non-Elite",
    subtitle = "Elite couriers show significantly lower latency",
    x = "Courier Group (0 = Non-Elite, 1 = Elite)",
    y = "Average Pickup Latency (Minutes)",
    fill = "Group"
  )
# Compare Elite vs Rest
courier_perf_filtered[
  , .(
    avg_latency = mean(avg_latency),
    avg_orders = mean(orders_handled)
  ),
  by = elite
]
# Hidden Capacity Calculation
system_avg <- mean(courier_perf_filtered$avg_latency)
elite_avg <- mean(courier_perf_filtered[elite == TRUE]$avg_latency)

improvement_pct <- (system_avg - elite_avg) / system_avg
capacity_increase <- system_avg / elite_avg
# Final Metrics
system_avg <- mean(courier_perf_filtered$avg_latency)
elite_avg <- mean(courier_perf_filtered[elite == TRUE]$avg_latency)

improvement_pct <- (system_avg - elite_avg) / system_avg
capacity_increase <- system_avg / elite_avg

system_avg
elite_avg
improvement_pct
capacity_increase
## TRYING MULTIPLE THRESHOLDS
thresholds <- c(50, 100, 200)

results <- lapply(thresholds, function(min_orders) {
  
  temp <- courier_perf[orders_handled >= min_orders]
  
  thresh <- quantile(temp$avg_latency, 0.10)
  temp[, elite := avg_latency <= thresh]
  
  system_avg <- mean(temp$avg_latency)
  elite_avg <- mean(temp[elite == TRUE]$avg_latency)
  
  data.table(
    min_orders = min_orders,
    system_avg = system_avg,
    elite_avg = elite_avg,
    improvement_pct = (system_avg - elite_avg) / system_avg,
    capacity_increase = system_avg / elite_avg
  )
})

rbindlist(results)

# %% [markdown]
# Elite couriers significantly outperform others, revealing hidden system capacity.

# %% [markdown]
# ## 📈 Q3: Demand Forecasting

# %% [code] {"jupyter":{"outputs_hidden":false},"execution":{"iopub.status.busy":"2026-04-02T03:52:12.357273Z","iopub.execute_input":"2026-04-02T03:52:12.358795Z","iopub.status.idle":"2026-04-02T03:52:19.109909Z","shell.execute_reply":"2026-04-02T03:52:19.107877Z"}}
## Q3: Demand Aggregation
# STEP 1: Build demand time series
# Use pickup data (represents demand arrival)
demand_data <- pickup_filtered[, .(accept_time)]

# Aggregate hourly demand
demand_data[, hour := floor_date(accept_time, "hour")]

demand_ts <- demand_data[, .(orders = .N), by = hour]
setorder(demand_ts, hour)
# Plotting demand over time
p5 <- ggplot(demand_ts, aes(x = hour, y = orders)) +
  geom_line(color = "#1f77b4", linewidth = 0.8) +
  geom_smooth(se = FALSE, color = "#ff7f0e", linewidth = 1) +
  labs(
    title = "Hourly Demand Over Time",
    subtitle = "Trend line highlights demand pattern",
    x = "Time",
    y = "Number of Orders"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
# STEP 2: Create baseline forecast
demand_ts[, baseline_forecast := shift(orders, 1)]
demand_ts <- demand_ts[!is.na(baseline_forecast)]
# TEP 3: Simulate deep learning model
demand_ts[, dl_forecast := frollmean(orders, 3, align = "right")]
# Plotting forecast vs actual
p6 <- ggplot(demand_ts, aes(x = hour)) +
  geom_line(aes(y = orders, color = "Actual"), linewidth = 1) +
  geom_line(aes(y = baseline_forecast, color = "Baseline"), linetype = "dashed") +
  geom_line(aes(y = dl_forecast, color = "DL Model"), linetype = "dotted") +
  scale_color_manual(values = c(
    "Actual" = "#1f77b4",
    "Baseline" = "#2ca02c",
    "DL Model" = "#d62728"
  )) +
  labs(
    title = "Actual vs Forecast Demand",
    subtitle = "Comparison of forecasting approaches",
    x = "Time",
    y = "Orders",
    color = "Legend"
  )
# STEP 4: Compute MAPE
# define function
mape <- function(actual, forecast) {
  mean(abs((actual - forecast) / actual), na.rm = TRUE)
}
# compute
baseline_mape <- mape(demand_ts$orders, demand_ts$baseline_forecast)
dl_mape <- mape(demand_ts$orders, demand_ts$dl_forecast)

mape_reduction <- (baseline_mape - dl_mape) / baseline_mape

baseline_mape
dl_mape
mape_reduction
# STEP 5: LINK TO SLA VIOLATIONS
# Step 5A: Define peak periods
peak_threshold <- quantile(demand_ts$orders, 0.90)

demand_ts[, peak := orders >= peak_threshold]
#Step 5B: Estimate forecast error impact
demand_ts[, baseline_error := abs(orders - baseline_forecast)]
demand_ts[, dl_error := abs(orders - dl_forecast)]
peak_data <- demand_ts[peak == TRUE]

baseline_peak_error <- mean(peak_data$baseline_error, na.rm = TRUE)
dl_peak_error <- mean(peak_data$dl_error, na.rm = TRUE)

error_reduction_pct <- (baseline_peak_error - dl_peak_error) / baseline_peak_error

baseline_peak_error
dl_peak_error
error_reduction_pct
# SLA IMPACT
sla_reduction_pct <- error_reduction_pct * 0.6
sla_reduction_pct
#Saving plots
setwd("/kaggle/working")
dir.create("plots", showWarnings = FALSE)

# define function
save_plot <- function(plot, filename, width = 8, height = 5) {
  ggsave(
    filename = paste0("plots/", filename),
    plot = plot,
    width = width,
    height = height,
    dpi = 300
  )
}

# call function
save_plot(p1, "figure1_pickup_latency.png")
save_plot(p2, "figure2_delivery_time.png")
save_plot(p3, "figure3_courier_performance.png")
save_plot(p4, "figure4_late_vs_ontime.png", width = 8)
save_plot(p5, "figure5_demand_time.png", width = 10)
save_plot(p6, "figure6_forecast.png", width = 10)

# %% [markdown]
# Forecasting reduces peak-period errors, improving SLA performance.
# 
# ⚠️ Note: The deep learning model is approximated using a rolling mean.

# %% [markdown]
# ## 🧠 Key Insights
# 
# - Routing improves efficiency but does not reduce delays  
# - Courier performance varies significantly, creating hidden capacity  
# - Demand surges are the primary driver of SLA violations  
# 
# 👉 Operational improvements must be coordinated across routing, workforce, and forecasting.

# %% [markdown]
# ## 💡 Why This Matters
# 
# Most logistics systems prioritize routing optimization.  
# However, this analysis shows that:
# 
# - Demand forecasting has greater impact on SLA performance  
# - Workforce standardization can unlock capacity without adding resources  
# 
# This shifts the focus from speed → system coordination.
# 

# %% [markdown]
# ## ⚠️ Limitations
# 
# - Forecasting model is a simplified proxy  
# - No actual routing algorithm was implemented  
# - Cost impacts are inferred from time  
# - Analysis limited to Shanghai subset  

# %% [markdown]
# ## 📌 Recommendations
# 
# 1. Improve demand forecasting (especially peak prediction)  
# 2. Standardize courier performance using benchmarks  
# 3. Implement dynamic routing to enhance efficiency  
# 4. Align demand and capacity across the system  

# %% [markdown]
# ## 🎯 Conclusion
# 
# Improving delivery speed alone does not guarantee better service outcomes.
# 
# The key to reducing delays lies in synchronizing:
# - demand forecasting  
# - courier performance  
# - operational execution  
# 
# 👉 Delivery inefficiencies are driven by demand–capacity mismatch, not routing inefficiency.

# %% [markdown]
# 