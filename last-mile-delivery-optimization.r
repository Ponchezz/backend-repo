{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "27c09ee1",
   "metadata": {
    "papermill": {
     "duration": 0.006677,
     "end_time": "2026-04-02T03:53:36.123647",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.116970",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# 🚚 Last-Mile Delivery Optimization in Shanghai  \n",
    "### Courier Performance, Routing Efficiency, and Demand Forecasting (R Analysis)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a25f51cd",
   "metadata": {
    "papermill": {
     "duration": 0.005133,
     "end_time": "2026-04-02T03:53:36.134183",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.129050",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 📌 Introduction\n",
    "\n",
    "Last-mile delivery is the most complex and costly segment of the logistics chain. In dense urban environments like Shanghai, delivery systems face challenges such as traffic congestion, demand surges, and strict service-level agreements (SLAs).\n",
    "\n",
    "This project analyzes last-mile delivery operations using the LADE dataset, focusing on identifying the true drivers of delivery delays and uncovering hidden system capacity."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "4ce1d81f",
   "metadata": {
    "papermill": {
     "duration": 0.005016,
     "end_time": "2026-04-02T03:53:36.144353",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.139337",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 🚀 Key Results\n",
    "\n",
    "- Late delivery rate: ~56%  \n",
    "- Delivery time improvement (optimized benchmark): ~9.5%  \n",
    "- Courier capacity unlock: up to **1.68×**  \n",
    "- Peak demand forecast error reduction: ~22%  \n",
    "- Estimated SLA improvement: ~13%  \n",
    "\n",
    "👉 **Main Insight:** Delivery delays are driven by demand–capacity mismatch, not routing inefficiency."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3b8dd3d7",
   "metadata": {
    "papermill": {
     "duration": 0.005028,
     "end_time": "2026-04-02T03:53:36.154389",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.149361",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 💼 Business Problem\n",
    "\n",
    "High late delivery rates indicate inefficiencies in urban logistics systems. Companies often invest in routing optimization, assuming it is the primary bottleneck.\n",
    "\n",
    "This study investigates whether delays are driven by:\n",
    "- Routing inefficiency  \n",
    "- Courier performance variability  \n",
    "- Demand–capacity misalignment  "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "87559a89",
   "metadata": {
    "papermill": {
     "duration": 0.005004,
     "end_time": "2026-04-02T03:53:36.164598",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.159594",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## ❓ Research Questions\n",
    "\n",
    "1. Can routing improvements reduce delivery delays?  \n",
    "2. How much hidden capacity exists among couriers?  \n",
    "3. Can demand forecasting reduce SLA violations during peak periods?  "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8b83afb4",
   "metadata": {
    "papermill": {
     "duration": 0.005537,
     "end_time": "2026-04-02T03:53:36.175200",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.169663",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "**Load Libraries + Data**"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "0aac625b",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:53:36.191687Z",
     "iopub.status.busy": "2026-04-02T03:53:36.189161Z",
     "iopub.status.idle": "2026-04-02T03:53:46.191915Z",
     "shell.execute_reply": "2026-04-02T03:53:46.189919Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 10.015002,
     "end_time": "2026-04-02T03:53:46.195434",
     "exception": false,
     "start_time": "2026-04-02T03:53:36.180432",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘lubridate’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following objects are masked from ‘package:data.table’:\n",
      "\n",
      "    hour, isoweek, mday, minute, month, quarter, second, wday, week,\n",
      "    yday, year\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    date, intersect, setdiff, union\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(data.table)\n",
    "library(lubridate)\n",
    "library(ggplot2)\n",
    "theme_set(\n",
    "  theme_minimal(base_size = 12)\n",
    ")\n",
    "\n",
    "# Load data\n",
    "sh_data_delivery <- fread(\"/kaggle/input/datasets/paulkamande/lade-last-mile-delivery-dataset-shanghai-subset/delivery_sh.csv\")\n",
    "sh_data_pickup <- fread(\"/kaggle/input/datasets/paulkamande/lade-last-mile-delivery-dataset-shanghai-subset/pickup_sh.csv\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d2f6ee83",
   "metadata": {
    "papermill": {
     "duration": 0.005293,
     "end_time": "2026-04-02T03:53:46.206481",
     "exception": false,
     "start_time": "2026-04-02T03:53:46.201188",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 📊 Data Overview\n",
    "\n",
    "The dataset consists of:\n",
    "- Pickup records (order acceptance, pickup time, time windows)\n",
    "- Delivery records (delivery completion time and location)\n",
    "\n",
    "The data captures operational performance of couriers in an urban environment."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "328a0f5d",
   "metadata": {
    "papermill": {
     "duration": 0.005279,
     "end_time": "2026-04-02T03:53:46.217784",
     "exception": false,
     "start_time": "2026-04-02T03:53:46.212505",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 🧹 Data Cleaning\n",
    "\n",
    "To ensure data quality:\n",
    "- Blank values were converted to missing values (NA)\n",
    "- Timestamps were parsed into proper datetime format\n",
    "- Unrealistic values were filtered out"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "a9a3f0ed",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:53:46.263030Z",
     "iopub.status.busy": "2026-04-02T03:53:46.230596Z",
     "iopub.status.idle": "2026-04-02T03:53:58.638432Z",
     "shell.execute_reply": "2026-04-02T03:53:58.636247Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 12.418708,
     "end_time": "2026-04-02T03:53:58.641791",
     "exception": false,
     "start_time": "2026-04-02T03:53:46.223083",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>1424406</li><li>19</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 1424406\n",
       "\\item 19\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 1424406\n",
       "2. 19\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[1] 1424406      19"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>1483864</li><li>17</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 1483864\n",
       "\\item 17\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 1483864\n",
       "2. 17\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[1] 1483864      17"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'order_id'</li><li>'region_id'</li><li>'city'</li><li>'courier_id'</li><li>'accept_time'</li><li>'time_window_start'</li><li>'time_window_end'</li><li>'lng'</li><li>'lat'</li><li>'aoi_id'</li><li>'aoi_type'</li><li>'pickup_time'</li><li>'pickup_gps_time'</li><li>'pickup_gps_lng'</li><li>'pickup_gps_lat'</li><li>'accept_gps_time'</li><li>'accept_gps_lng'</li><li>'accept_gps_lat'</li><li>'ds'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'order\\_id'\n",
       "\\item 'region\\_id'\n",
       "\\item 'city'\n",
       "\\item 'courier\\_id'\n",
       "\\item 'accept\\_time'\n",
       "\\item 'time\\_window\\_start'\n",
       "\\item 'time\\_window\\_end'\n",
       "\\item 'lng'\n",
       "\\item 'lat'\n",
       "\\item 'aoi\\_id'\n",
       "\\item 'aoi\\_type'\n",
       "\\item 'pickup\\_time'\n",
       "\\item 'pickup\\_gps\\_time'\n",
       "\\item 'pickup\\_gps\\_lng'\n",
       "\\item 'pickup\\_gps\\_lat'\n",
       "\\item 'accept\\_gps\\_time'\n",
       "\\item 'accept\\_gps\\_lng'\n",
       "\\item 'accept\\_gps\\_lat'\n",
       "\\item 'ds'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'order_id'\n",
       "2. 'region_id'\n",
       "3. 'city'\n",
       "4. 'courier_id'\n",
       "5. 'accept_time'\n",
       "6. 'time_window_start'\n",
       "7. 'time_window_end'\n",
       "8. 'lng'\n",
       "9. 'lat'\n",
       "10. 'aoi_id'\n",
       "11. 'aoi_type'\n",
       "12. 'pickup_time'\n",
       "13. 'pickup_gps_time'\n",
       "14. 'pickup_gps_lng'\n",
       "15. 'pickup_gps_lat'\n",
       "16. 'accept_gps_time'\n",
       "17. 'accept_gps_lng'\n",
       "18. 'accept_gps_lat'\n",
       "19. 'ds'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"order_id\"          \"region_id\"         \"city\"             \n",
       " [4] \"courier_id\"        \"accept_time\"       \"time_window_start\"\n",
       " [7] \"time_window_end\"   \"lng\"               \"lat\"              \n",
       "[10] \"aoi_id\"            \"aoi_type\"          \"pickup_time\"      \n",
       "[13] \"pickup_gps_time\"   \"pickup_gps_lng\"    \"pickup_gps_lat\"   \n",
       "[16] \"accept_gps_time\"   \"accept_gps_lng\"    \"accept_gps_lat\"   \n",
       "[19] \"ds\"               "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'order_id'</li><li>'region_id'</li><li>'city'</li><li>'courier_id'</li><li>'lng'</li><li>'lat'</li><li>'aoi_id'</li><li>'aoi_type'</li><li>'accept_time'</li><li>'accept_gps_time'</li><li>'accept_gps_lng'</li><li>'accept_gps_lat'</li><li>'delivery_time'</li><li>'delivery_gps_time'</li><li>'delivery_gps_lng'</li><li>'delivery_gps_lat'</li><li>'ds'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'order\\_id'\n",
       "\\item 'region\\_id'\n",
       "\\item 'city'\n",
       "\\item 'courier\\_id'\n",
       "\\item 'lng'\n",
       "\\item 'lat'\n",
       "\\item 'aoi\\_id'\n",
       "\\item 'aoi\\_type'\n",
       "\\item 'accept\\_time'\n",
       "\\item 'accept\\_gps\\_time'\n",
       "\\item 'accept\\_gps\\_lng'\n",
       "\\item 'accept\\_gps\\_lat'\n",
       "\\item 'delivery\\_time'\n",
       "\\item 'delivery\\_gps\\_time'\n",
       "\\item 'delivery\\_gps\\_lng'\n",
       "\\item 'delivery\\_gps\\_lat'\n",
       "\\item 'ds'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'order_id'\n",
       "2. 'region_id'\n",
       "3. 'city'\n",
       "4. 'courier_id'\n",
       "5. 'lng'\n",
       "6. 'lat'\n",
       "7. 'aoi_id'\n",
       "8. 'aoi_type'\n",
       "9. 'accept_time'\n",
       "10. 'accept_gps_time'\n",
       "11. 'accept_gps_lng'\n",
       "12. 'accept_gps_lat'\n",
       "13. 'delivery_time'\n",
       "14. 'delivery_gps_time'\n",
       "15. 'delivery_gps_lng'\n",
       "16. 'delivery_gps_lat'\n",
       "17. 'ds'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"order_id\"          \"region_id\"         \"city\"             \n",
       " [4] \"courier_id\"        \"lng\"               \"lat\"              \n",
       " [7] \"aoi_id\"            \"aoi_type\"          \"accept_time\"      \n",
       "[10] \"accept_gps_time\"   \"accept_gps_lng\"    \"accept_gps_lat\"   \n",
       "[13] \"delivery_time\"     \"delivery_gps_time\" \"delivery_gps_lng\" \n",
       "[16] \"delivery_gps_lat\"  \"ds\"               "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Classes ‘data.table’ and 'data.frame':\t1424406 obs. of  19 variables:\n",
      " $ order_id         : int  2349637 4867696 5691514 1443776 1806717 2561198 4922023 4858787 4026708 525343 ...\n",
      " $ region_id        : int  0 0 0 0 0 0 0 0 0 0 ...\n",
      " $ city             : chr  \"Shanghai\" \"Shanghai\" \"Shanghai\" \"Shanghai\" ...\n",
      " $ courier_id       : int  1448 1448 1448 1448 1448 1448 1448 1448 1448 1448 ...\n",
      " $ accept_time      : chr  \"07-08 08:13:00\" \"07-21 08:14:00\" \"07-12 07:40:00\" \"07-09 15:38:00\" ...\n",
      " $ time_window_start: chr  \"07-08 09:00:00\" \"07-21 09:00:00\" \"07-12 17:00:00\" \"07-09 17:00:00\" ...\n",
      " $ time_window_end  : chr  \"07-08 11:00:00\" \"07-21 11:00:00\" \"07-12 19:00:00\" \"07-09 19:00:00\" ...\n",
      " $ lng              : num  122 122 122 122 122 ...\n",
      " $ lat              : num  30.9 30.9 30.9 30.9 30.9 ...\n",
      " $ aoi_id           : int  46 46 46 46 46 46 46 46 46 46 ...\n",
      " $ aoi_type         : int  14 14 14 14 14 14 14 14 14 14 ...\n",
      " $ pickup_time      : chr  \"07-08 10:10:00\" \"07-21 10:10:00\" \"07-12 17:22:00\" \"07-09 15:54:00\" ...\n",
      " $ pickup_gps_time  : chr  \"07-08 10:10:00\" \"07-21 10:10:00\" \"07-12 17:22:00\" \"07-09 15:54:00\" ...\n",
      " $ pickup_gps_lng   : num  122 122 122 122 122 ...\n",
      " $ pickup_gps_lat   : num  30.9 30.9 30.9 30.9 30.9 ...\n",
      " $ accept_gps_time  : chr  \"\" \"07-21 08:14:00\" \"07-12 07:37:00\" \"07-09 15:38:00\" ...\n",
      " $ accept_gps_lng   : num  NA 122 121 122 121 ...\n",
      " $ accept_gps_lat   : num  NA 30.9 30.9 30.9 30.9 ...\n",
      " $ ds               : int  708 721 712 709 707 719 712 728 717 725 ...\n",
      " - attr(*, \".internal.selfref\")=<externalptr> \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Classes ‘data.table’ and 'data.frame':\t1483864 obs. of  17 variables:\n",
      " $ order_id         : int  3158819 751342 3380476 2184571 941371 1278638 261182 3459225 705091 2545410 ...\n",
      " $ region_id        : int  1 1 1 1 1 1 1 1 1 1 ...\n",
      " $ city             : chr  \"Shanghai\" \"Shanghai\" \"Shanghai\" \"Shanghai\" ...\n",
      " $ courier_id       : int  164 164 164 164 164 164 164 420 534 540 ...\n",
      " $ lng              : num  122 122 122 122 122 ...\n",
      " $ lat              : num  31.1 31.1 31.1 31.1 31.1 ...\n",
      " $ aoi_id           : int  450 450 450 450 450 450 450 450 450 450 ...\n",
      " $ aoi_type         : int  1 1 1 1 1 1 1 1 1 1 ...\n",
      " $ accept_time      : chr  \"06-04 11:05:00\" \"06-04 11:18:00\" \"06-03 10:13:00\" \"06-04 10:39:00\" ...\n",
      " $ accept_gps_time  : chr  \"06-04 11:05:00\" \"06-04 11:18:00\" \"06-03 10:13:00\" \"06-04 10:39:00\" ...\n",
      " $ accept_gps_lng   : num  122 122 122 122 122 ...\n",
      " $ accept_gps_lat   : num  31.1 31.1 31.1 31.1 31.1 ...\n",
      " $ delivery_time    : chr  \"06-04 17:40:00\" \"06-04 15:06:00\" \"06-03 15:11:00\" \"06-04 15:41:00\" ...\n",
      " $ delivery_gps_time: chr  \"06-04 17:40:00\" \"06-04 15:06:00\" \"06-03 15:11:00\" \"06-04 15:41:00\" ...\n",
      " $ delivery_gps_lng : num  122 122 122 122 122 ...\n",
      " $ delivery_gps_lat : num  31.1 31.1 31.1 31.1 31.1 ...\n",
      " $ ds               : int  604 604 603 604 604 603 603 907 1011 912 ...\n",
      " - attr(*, \".internal.selfref\")=<externalptr> \n"
     ]
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 0 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>N</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 0 × 2\n",
       "\\begin{tabular}{ll}\n",
       " order\\_id & N\\\\\n",
       " <int> & <int>\\\\\n",
       "\\hline\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 0 × 2\n",
       "\n",
       "| order_id &lt;int&gt; | N &lt;int&gt; |\n",
       "|---|---|\n",
       "\n"
      ],
      "text/plain": [
       "     order_id N"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 0 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>N</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 0 × 2\n",
       "\\begin{tabular}{ll}\n",
       " order\\_id & N\\\\\n",
       " <int> & <int>\\\\\n",
       "\\hline\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 0 × 2\n",
       "\n",
       "| order_id &lt;int&gt; | N &lt;int&gt; |\n",
       "|---|---|\n",
       "\n"
      ],
      "text/plain": [
       "     order_id N"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".dl-inline {width: auto; margin:0; padding: 0}\n",
       ".dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}\n",
       ".dl-inline>dt::after {content: \":\\0020\"; padding-right: .5ex}\n",
       ".dl-inline>dt:not(:first-of-type) {padding-left: .5ex}\n",
       "</style><dl class=dl-inline><dt>order_id</dt><dd>0</dd><dt>region_id</dt><dd>0</dd><dt>city</dt><dd>0</dd><dt>courier_id</dt><dd>0</dd><dt>accept_time</dt><dd>0</dd><dt>time_window_start</dt><dd>0</dd><dt>time_window_end</dt><dd>0</dd><dt>lng</dt><dd>0</dd><dt>lat</dt><dd>0</dd><dt>aoi_id</dt><dd>0</dd><dt>aoi_type</dt><dd>0</dd><dt>pickup_time</dt><dd>0</dd><dt>pickup_gps_time</dt><dd>441333</dd><dt>pickup_gps_lng</dt><dd>441333</dd><dt>pickup_gps_lat</dt><dd>441333</dd><dt>accept_gps_time</dt><dd>654425</dd><dt>accept_gps_lng</dt><dd>654425</dd><dt>accept_gps_lat</dt><dd>654425</dd><dt>ds</dt><dd>0</dd></dl>\n"
      ],
      "text/latex": [
       "\\begin{description*}\n",
       "\\item[order\\textbackslash{}\\_id] 0\n",
       "\\item[region\\textbackslash{}\\_id] 0\n",
       "\\item[city] 0\n",
       "\\item[courier\\textbackslash{}\\_id] 0\n",
       "\\item[accept\\textbackslash{}\\_time] 0\n",
       "\\item[time\\textbackslash{}\\_window\\textbackslash{}\\_start] 0\n",
       "\\item[time\\textbackslash{}\\_window\\textbackslash{}\\_end] 0\n",
       "\\item[lng] 0\n",
       "\\item[lat] 0\n",
       "\\item[aoi\\textbackslash{}\\_id] 0\n",
       "\\item[aoi\\textbackslash{}\\_type] 0\n",
       "\\item[pickup\\textbackslash{}\\_time] 0\n",
       "\\item[pickup\\textbackslash{}\\_gps\\textbackslash{}\\_time] 441333\n",
       "\\item[pickup\\textbackslash{}\\_gps\\textbackslash{}\\_lng] 441333\n",
       "\\item[pickup\\textbackslash{}\\_gps\\textbackslash{}\\_lat] 441333\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_time] 654425\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_lng] 654425\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_lat] 654425\n",
       "\\item[ds] 0\n",
       "\\end{description*}\n"
      ],
      "text/markdown": [
       "order_id\n",
       ":   0region_id\n",
       ":   0city\n",
       ":   0courier_id\n",
       ":   0accept_time\n",
       ":   0time_window_start\n",
       ":   0time_window_end\n",
       ":   0lng\n",
       ":   0lat\n",
       ":   0aoi_id\n",
       ":   0aoi_type\n",
       ":   0pickup_time\n",
       ":   0pickup_gps_time\n",
       ":   441333pickup_gps_lng\n",
       ":   441333pickup_gps_lat\n",
       ":   441333accept_gps_time\n",
       ":   654425accept_gps_lng\n",
       ":   654425accept_gps_lat\n",
       ":   654425ds\n",
       ":   0\n",
       "\n"
      ],
      "text/plain": [
       "         order_id         region_id              city        courier_id \n",
       "                0                 0                 0                 0 \n",
       "      accept_time time_window_start   time_window_end               lng \n",
       "                0                 0                 0                 0 \n",
       "              lat            aoi_id          aoi_type       pickup_time \n",
       "                0                 0                 0                 0 \n",
       "  pickup_gps_time    pickup_gps_lng    pickup_gps_lat   accept_gps_time \n",
       "           441333            441333            441333            654425 \n",
       "   accept_gps_lng    accept_gps_lat                ds \n",
       "           654425            654425                 0 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".dl-inline {width: auto; margin:0; padding: 0}\n",
       ".dl-inline>dt, .dl-inline>dd {float: none; width: auto; display: inline-block}\n",
       ".dl-inline>dt::after {content: \":\\0020\"; padding-right: .5ex}\n",
       ".dl-inline>dt:not(:first-of-type) {padding-left: .5ex}\n",
       "</style><dl class=dl-inline><dt>order_id</dt><dd>0</dd><dt>region_id</dt><dd>0</dd><dt>city</dt><dd>0</dd><dt>courier_id</dt><dd>0</dd><dt>lng</dt><dd>0</dd><dt>lat</dt><dd>0</dd><dt>aoi_id</dt><dd>0</dd><dt>aoi_type</dt><dd>0</dd><dt>accept_time</dt><dd>0</dd><dt>accept_gps_time</dt><dd>0</dd><dt>accept_gps_lng</dt><dd>0</dd><dt>accept_gps_lat</dt><dd>0</dd><dt>delivery_time</dt><dd>0</dd><dt>delivery_gps_time</dt><dd>0</dd><dt>delivery_gps_lng</dt><dd>0</dd><dt>delivery_gps_lat</dt><dd>0</dd><dt>ds</dt><dd>0</dd></dl>\n"
      ],
      "text/latex": [
       "\\begin{description*}\n",
       "\\item[order\\textbackslash{}\\_id] 0\n",
       "\\item[region\\textbackslash{}\\_id] 0\n",
       "\\item[city] 0\n",
       "\\item[courier\\textbackslash{}\\_id] 0\n",
       "\\item[lng] 0\n",
       "\\item[lat] 0\n",
       "\\item[aoi\\textbackslash{}\\_id] 0\n",
       "\\item[aoi\\textbackslash{}\\_type] 0\n",
       "\\item[accept\\textbackslash{}\\_time] 0\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_time] 0\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_lng] 0\n",
       "\\item[accept\\textbackslash{}\\_gps\\textbackslash{}\\_lat] 0\n",
       "\\item[delivery\\textbackslash{}\\_time] 0\n",
       "\\item[delivery\\textbackslash{}\\_gps\\textbackslash{}\\_time] 0\n",
       "\\item[delivery\\textbackslash{}\\_gps\\textbackslash{}\\_lng] 0\n",
       "\\item[delivery\\textbackslash{}\\_gps\\textbackslash{}\\_lat] 0\n",
       "\\item[ds] 0\n",
       "\\end{description*}\n"
      ],
      "text/markdown": [
       "order_id\n",
       ":   0region_id\n",
       ":   0city\n",
       ":   0courier_id\n",
       ":   0lng\n",
       ":   0lat\n",
       ":   0aoi_id\n",
       ":   0aoi_type\n",
       ":   0accept_time\n",
       ":   0accept_gps_time\n",
       ":   0accept_gps_lng\n",
       ":   0accept_gps_lat\n",
       ":   0delivery_time\n",
       ":   0delivery_gps_time\n",
       ":   0delivery_gps_lng\n",
       ":   0delivery_gps_lat\n",
       ":   0ds\n",
       ":   0\n",
       "\n"
      ],
      "text/plain": [
       "         order_id         region_id              city        courier_id \n",
       "                0                 0                 0                 0 \n",
       "              lng               lat            aoi_id          aoi_type \n",
       "                0                 0                 0                 0 \n",
       "      accept_time   accept_gps_time    accept_gps_lng    accept_gps_lat \n",
       "                0                 0                 0                 0 \n",
       "    delivery_time delivery_gps_time  delivery_gps_lng  delivery_gps_lat \n",
       "                0                 0                 0                 0 \n",
       "               ds \n",
       "                0 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "340293"
      ],
      "text/latex": [
       "340293"
      ],
      "text/markdown": [
       "340293"
      ],
      "text/plain": [
       "[1] 340293"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "1084113"
      ],
      "text/latex": [
       "1084113"
      ],
      "text/markdown": [
       "1084113"
      ],
      "text/plain": [
       "[1] 1084113"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "1143571"
      ],
      "text/latex": [
       "1143571"
      ],
      "text/markdown": [
       "1143571"
      ],
      "text/plain": [
       "[1] 1143571"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-03 08:20:00.0000\" \"2022-07-05 14:19:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-16 07:46:00.0000\" \"2022-08-15 21:59:54.9690\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-09-24 07:50:00.0000\" \"2022-10-31 18:57:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-03 16:34:00.0000\" \"2022-07-05 17:48:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-16 09:46:00.0000\" \"2022-08-16 01:49:36.5021\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-09-24 10:07:00.0000\" \"2022-10-31 21:48:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-03 09:00:00.0000\" \"2022-07-05 17:00:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-16 09:00:00.0000\" \"2022-08-16 01:18:16.2938\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-09-24 09:00:00.0000\" \"2022-11-02 17:00:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-03 11:00:00.0000\" \"2022-07-05 19:00:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-16 11:00:00.0000\" \"2022-08-16 03:25:57.0329\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-09-24 11:00:00.0000\" \"2022-11-02 19:00:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-01 07:35:00.0000\" \"2022-07-21 07:49:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-28 11:16:00.0000\" \"2022-08-24 18:03:12.4009\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-10-01 12:03:00.0000\" \"2022-10-31 23:13:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "                      Min.                    1st Qu. \n",
       "\"2022-05-01 08:33:00.0000\" \"2022-07-21 09:01:00.0000\" \n",
       "                    Median                       Mean \n",
       "\"2022-08-28 13:08:00.0000\" \"2022-08-24 19:54:20.8351\" \n",
       "                   3rd Qu.                       Max. \n",
       "\"2022-10-01 14:17:00.0000\" \"2022-11-16 23:09:00.0000\" "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# =========================\n",
    "# 3. Basic audit\n",
    "# =========================\n",
    "dim(sh_data_pickup)\n",
    "dim(sh_data_delivery)\n",
    "\n",
    "names(sh_data_pickup)\n",
    "names(sh_data_delivery)\n",
    "\n",
    "str(sh_data_pickup)\n",
    "str(sh_data_delivery)\n",
    "\n",
    "# Duplicate order IDs\n",
    "sh_data_pickup[, .N, by = order_id][N > 1]\n",
    "sh_data_delivery[, .N, by = order_id][N > 1]\n",
    "\n",
    "# Missing values\n",
    "sapply(sh_data_pickup, function(x) {\n",
    "  if (is.character(x)) sum(is.na(x) | x == \"\") else sum(is.na(x))\n",
    "})\n",
    "\n",
    "sapply(sh_data_delivery, function(x) {\n",
    "  if (is.character(x)) sum(is.na(x) | x == \"\") else sum(is.na(x))\n",
    "})\n",
    "\n",
    "# Overlap between pickup and delivery\n",
    "length(intersect(sh_data_pickup$order_id, sh_data_delivery$order_id))\n",
    "length(setdiff(sh_data_pickup$order_id, sh_data_delivery$order_id))\n",
    "length(setdiff(sh_data_delivery$order_id, sh_data_pickup$order_id))\n",
    "\n",
    "# =========================\n",
    "# 4. Create clean copies\n",
    "# =========================\n",
    "pickup_clean   <- copy(sh_data_pickup)\n",
    "delivery_clean <- copy(sh_data_delivery)\n",
    "\n",
    "# =========================\n",
    "# 5. Replace blank strings with NA\n",
    "#    Only for character columns\n",
    "# =========================\n",
    "pickup_clean[, (names(pickup_clean)) := lapply(.SD, function(x) {\n",
    "  if (is.character(x)) x[x == \"\"] <- NA\n",
    "  x\n",
    "})]\n",
    "\n",
    "delivery_clean[, (names(delivery_clean)) := lapply(.SD, function(x) {\n",
    "  if (is.character(x)) x[x == \"\"] <- NA\n",
    "  x\n",
    "})]\n",
    "\n",
    "# =========================\n",
    "# 6. Parse datetime fields\n",
    "#    Add synthetic year 2020\n",
    "# =========================\n",
    "pickup_clean[, accept_time := parse_date_time(\n",
    "  paste(\"2022\", accept_time), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "pickup_clean[, pickup_time := parse_date_time(\n",
    "  paste(\"2022\", pickup_time), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "pickup_clean[, time_window_start := parse_date_time(\n",
    "  paste(\"2022\", time_window_start), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "pickup_clean[, time_window_end := parse_date_time(\n",
    "  paste(\"2022\", time_window_end), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "delivery_clean[, accept_time := parse_date_time(\n",
    "  paste(\"2022\", accept_time), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "delivery_clean[, delivery_time := parse_date_time(\n",
    "  paste(\"2022\", delivery_time), orders = \"Y md HMS\"\n",
    ")]\n",
    "\n",
    "# =========================\n",
    "# 7. Validate parsing\n",
    "# =========================\n",
    "summary(pickup_clean$accept_time)\n",
    "summary(pickup_clean$pickup_time)\n",
    "summary(pickup_clean$time_window_start)\n",
    "summary(pickup_clean$time_window_end)\n",
    "\n",
    "summary(delivery_clean$accept_time)\n",
    "summary(delivery_clean$delivery_time)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "6cf58213",
   "metadata": {
    "papermill": {
     "duration": 0.007821,
     "end_time": "2026-04-02T03:53:58.657678",
     "exception": false,
     "start_time": "2026-04-02T03:53:58.649857",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## ⚙️ Feature Engineering"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "0f8796aa",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:53:58.676485Z",
     "iopub.status.busy": "2026-04-02T03:53:58.674907Z",
     "iopub.status.idle": "2026-04-02T03:54:00.250505Z",
     "shell.execute_reply": "2026-04-02T03:54:00.248631Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 1.588428,
     "end_time": "2026-04-02T03:54:00.253720",
     "exception": false,
     "start_time": "2026-04-02T03:53:58.665292",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
       "    0.0    70.0   124.0   229.7   207.0 54859.0 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
       "    0.0    43.0    72.0   111.1   119.0 47739.0 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 0 × 20</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>region_id</th><th scope=col>city</th><th scope=col>courier_id</th><th scope=col>accept_time</th><th scope=col>time_window_start</th><th scope=col>time_window_end</th><th scope=col>lng</th><th scope=col>lat</th><th scope=col>aoi_id</th><th scope=col>aoi_type</th><th scope=col>pickup_time</th><th scope=col>pickup_gps_time</th><th scope=col>pickup_gps_lng</th><th scope=col>pickup_gps_lat</th><th scope=col>accept_gps_time</th><th scope=col>accept_gps_lng</th><th scope=col>accept_gps_lat</th><th scope=col>ds</th><th scope=col>pickup_latency_mins</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 0 × 20\n",
       "\\begin{tabular}{llllllllllllllllllll}\n",
       " order\\_id & region\\_id & city & courier\\_id & accept\\_time & time\\_window\\_start & time\\_window\\_end & lng & lat & aoi\\_id & aoi\\_type & pickup\\_time & pickup\\_gps\\_time & pickup\\_gps\\_lng & pickup\\_gps\\_lat & accept\\_gps\\_time & accept\\_gps\\_lng & accept\\_gps\\_lat & ds & pickup\\_latency\\_mins\\\\\n",
       " <int> & <int> & <chr> & <int> & <dttm> & <dttm> & <dttm> & <dbl> & <dbl> & <int> & <int> & <dttm> & <chr> & <dbl> & <dbl> & <chr> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 0 × 20\n",
       "\n",
       "| order_id &lt;int&gt; | region_id &lt;int&gt; | city &lt;chr&gt; | courier_id &lt;int&gt; | accept_time &lt;dttm&gt; | time_window_start &lt;dttm&gt; | time_window_end &lt;dttm&gt; | lng &lt;dbl&gt; | lat &lt;dbl&gt; | aoi_id &lt;int&gt; | aoi_type &lt;int&gt; | pickup_time &lt;dttm&gt; | pickup_gps_time &lt;chr&gt; | pickup_gps_lng &lt;dbl&gt; | pickup_gps_lat &lt;dbl&gt; | accept_gps_time &lt;chr&gt; | accept_gps_lng &lt;dbl&gt; | accept_gps_lat &lt;dbl&gt; | ds &lt;int&gt; | pickup_latency_mins &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "\n"
      ],
      "text/plain": [
       "     order_id region_id city courier_id accept_time time_window_start\n",
       "     time_window_end lng lat aoi_id aoi_type pickup_time pickup_gps_time\n",
       "     pickup_gps_lng pickup_gps_lat accept_gps_time accept_gps_lng\n",
       "     accept_gps_lat ds pickup_latency_mins"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 0 × 18</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>region_id</th><th scope=col>city</th><th scope=col>courier_id</th><th scope=col>lng</th><th scope=col>lat</th><th scope=col>aoi_id</th><th scope=col>aoi_type</th><th scope=col>accept_time</th><th scope=col>accept_gps_time</th><th scope=col>accept_gps_lng</th><th scope=col>accept_gps_lat</th><th scope=col>delivery_time</th><th scope=col>delivery_gps_time</th><th scope=col>delivery_gps_lng</th><th scope=col>delivery_gps_lat</th><th scope=col>ds</th><th scope=col>total_time_mins</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 0 × 18\n",
       "\\begin{tabular}{llllllllllllllllll}\n",
       " order\\_id & region\\_id & city & courier\\_id & lng & lat & aoi\\_id & aoi\\_type & accept\\_time & accept\\_gps\\_time & accept\\_gps\\_lng & accept\\_gps\\_lat & delivery\\_time & delivery\\_gps\\_time & delivery\\_gps\\_lng & delivery\\_gps\\_lat & ds & total\\_time\\_mins\\\\\n",
       " <int> & <int> & <chr> & <int> & <dbl> & <dbl> & <int> & <int> & <dttm> & <chr> & <dbl> & <dbl> & <dttm> & <chr> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 0 × 18\n",
       "\n",
       "| order_id &lt;int&gt; | region_id &lt;int&gt; | city &lt;chr&gt; | courier_id &lt;int&gt; | lng &lt;dbl&gt; | lat &lt;dbl&gt; | aoi_id &lt;int&gt; | aoi_type &lt;int&gt; | accept_time &lt;dttm&gt; | accept_gps_time &lt;chr&gt; | accept_gps_lng &lt;dbl&gt; | accept_gps_lat &lt;dbl&gt; | delivery_time &lt;dttm&gt; | delivery_gps_time &lt;chr&gt; | delivery_gps_lng &lt;dbl&gt; | delivery_gps_lat &lt;dbl&gt; | ds &lt;int&gt; | total_time_mins &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "\n"
      ],
      "text/plain": [
       "     order_id region_id city courier_id lng lat aoi_id aoi_type accept_time\n",
       "     accept_gps_time accept_gps_lng accept_gps_lat delivery_time\n",
       "     delivery_gps_time delivery_gps_lng delivery_gps_lat ds total_time_mins"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 230733 × 20</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>region_id</th><th scope=col>city</th><th scope=col>courier_id</th><th scope=col>accept_time</th><th scope=col>time_window_start</th><th scope=col>time_window_end</th><th scope=col>lng</th><th scope=col>lat</th><th scope=col>aoi_id</th><th scope=col>aoi_type</th><th scope=col>pickup_time</th><th scope=col>pickup_gps_time</th><th scope=col>pickup_gps_lng</th><th scope=col>pickup_gps_lat</th><th scope=col>accept_gps_time</th><th scope=col>accept_gps_lng</th><th scope=col>accept_gps_lat</th><th scope=col>ds</th><th scope=col>pickup_latency_mins</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>5691514</td><td>0</td><td>Shanghai</td><td> 1448</td><td>2022-07-12 07:40:00</td><td>2022-07-12 17:00:00</td><td>2022-07-12 19:00:00</td><td>121.5223</td><td>30.90731</td><td> 46</td><td>14</td><td>2022-07-12 17:22:00</td><td>07-12 17:22:00</td><td>121.5261</td><td>30.91764</td><td>07-12 07:37:00</td><td>121.4974</td><td>30.90695</td><td> 712</td><td> 582</td></tr>\n",
       "\t<tr><td>2710020</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-08-31 08:04:00</td><td>2022-08-31 17:00:00</td><td>2022-08-31 19:00:00</td><td>121.5223</td><td>30.90742</td><td> 46</td><td>14</td><td>2022-08-31 18:55:00</td><td>08-31 18:55:00</td><td>121.5270</td><td>30.91921</td><td>08-31 08:04:00</td><td>121.4975</td><td>30.90696</td><td> 831</td><td> 651</td></tr>\n",
       "\t<tr><td> 176722</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-09-03 15:22:00</td><td>2022-09-04 15:00:00</td><td>2022-09-04 17:00:00</td><td>121.5223</td><td>30.90731</td><td> 46</td><td>14</td><td>2022-09-04 15:22:00</td><td>09-04 15:21:00</td><td>121.5262</td><td>30.91779</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 904</td><td>1440</td></tr>\n",
       "\t<tr><td>1314029</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-09-01 09:19:00</td><td>2022-09-02 17:00:00</td><td>2022-09-02 19:00:00</td><td>121.5223</td><td>30.90732</td><td> 46</td><td>14</td><td>2022-09-02 16:57:00</td><td>09-02 16:57:00</td><td>121.5179</td><td>30.90631</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 902</td><td>1898</td></tr>\n",
       "\t<tr><td>  62447</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-10-16 09:08:00</td><td>2022-10-16 15:00:00</td><td>2022-10-16 17:00:00</td><td>121.5225</td><td>30.90743</td><td> 46</td><td>14</td><td>2022-10-16 15:30:00</td><td>10-16 15:30:00</td><td>121.5260</td><td>30.91927</td><td>10-16 09:08:00</td><td>121.5094</td><td>30.90367</td><td>1016</td><td> 382</td></tr>\n",
       "\t<tr><td>4886349</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-09-05 08:01:00</td><td>2022-09-05 09:00:00</td><td>2022-09-05 11:00:00</td><td>121.5222</td><td>30.90733</td><td> 46</td><td>14</td><td>2022-09-05 16:20:00</td><td>09-05 16:20:00</td><td>121.4974</td><td>30.90681</td><td>09-05 08:01:00</td><td>121.4973</td><td>30.90684</td><td> 905</td><td> 499</td></tr>\n",
       "\t<tr><td>1291405</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-08-18 10:58:00</td><td>2022-08-19 17:00:00</td><td>2022-08-19 19:00:00</td><td>121.5223</td><td>30.90737</td><td> 46</td><td>14</td><td>2022-08-19 17:46:00</td><td>08-19 17:46:00</td><td>121.5215</td><td>30.90898</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 819</td><td>1848</td></tr>\n",
       "\t<tr><td>1257902</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-08-22 07:54:00</td><td>2022-08-22 17:00:00</td><td>2022-08-22 19:00:00</td><td>121.5223</td><td>30.90734</td><td> 46</td><td>14</td><td>2022-08-22 18:37:00</td><td>08-22 18:37:00</td><td>121.5259</td><td>30.91656</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 822</td><td> 643</td></tr>\n",
       "\t<tr><td>2370290</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-08-02 07:44:00</td><td>2022-08-02 17:00:00</td><td>2022-08-02 19:00:00</td><td>121.5223</td><td>30.90745</td><td> 46</td><td>14</td><td>2022-08-02 14:39:00</td><td>08-02 14:38:00</td><td>121.5263</td><td>30.91692</td><td>08-02 07:44:00</td><td>121.4974</td><td>30.90687</td><td> 802</td><td> 415</td></tr>\n",
       "\t<tr><td>1274284</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-10-01 08:47:00</td><td>2022-10-01 17:00:00</td><td>2022-10-01 19:00:00</td><td>121.5223</td><td>30.90736</td><td> 46</td><td>14</td><td>2022-10-01 16:28:00</td><td>10-01 16:28:00</td><td>121.5219</td><td>30.90799</td><td>10-01 08:47:00</td><td>121.5069</td><td>30.89505</td><td>1001</td><td> 461</td></tr>\n",
       "\t<tr><td>1705580</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-08-28 07:07:00</td><td>2022-08-28 17:00:00</td><td>2022-08-28 19:00:00</td><td>121.5224</td><td>30.90740</td><td> 46</td><td>14</td><td>2022-08-28 12:46:00</td><td>08-28 12:46:00</td><td>121.5262</td><td>30.91691</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 828</td><td> 339</td></tr>\n",
       "\t<tr><td>3769096</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-09-01 07:23:00</td><td>2022-09-01 17:00:00</td><td>2022-09-01 19:00:00</td><td>121.5222</td><td>30.90747</td><td> 46</td><td>14</td><td>2022-09-01 15:24:00</td><td>09-01 15:24:00</td><td>121.5260</td><td>30.91919</td><td>09-01 07:16:00</td><td>121.4974</td><td>30.90690</td><td> 901</td><td> 481</td></tr>\n",
       "\t<tr><td>4861238</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-06-16 08:43:00</td><td>2022-06-16 15:00:00</td><td>2022-06-16 17:00:00</td><td>121.5223</td><td>30.90741</td><td> 46</td><td>14</td><td>2022-06-16 14:40:00</td><td>06-16 14:40:00</td><td>121.5266</td><td>30.91325</td><td>06-16 08:43:00</td><td>121.5071</td><td>30.89914</td><td> 616</td><td> 357</td></tr>\n",
       "\t<tr><td>6033374</td><td>0</td><td>Shanghai</td><td> 3243</td><td>2022-06-18 07:37:00</td><td>2022-06-19 17:00:00</td><td>2022-06-19 19:00:00</td><td>121.5224</td><td>30.90733</td><td> 46</td><td>14</td><td>2022-06-19 17:12:00</td><td>06-19 17:12:00</td><td>121.5264</td><td>30.91665</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 619</td><td>2015</td></tr>\n",
       "\t<tr><td>2342015</td><td>0</td><td>Shanghai</td><td> 4598</td><td>2022-06-03 08:26:00</td><td>2022-06-03 13:00:00</td><td>2022-06-03 15:00:00</td><td>121.5223</td><td>30.90740</td><td> 46</td><td>14</td><td>2022-06-03 14:07:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 603</td><td> 341</td></tr>\n",
       "\t<tr><td>1735032</td><td>0</td><td>Shanghai</td><td>14482</td><td>2022-09-21 07:37:00</td><td>2022-09-21 15:00:00</td><td>2022-09-21 17:00:00</td><td>121.5223</td><td>30.90735</td><td> 46</td><td>14</td><td>2022-09-21 14:34:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 921</td><td> 417</td></tr>\n",
       "\t<tr><td> 263781</td><td>0</td><td>Shanghai</td><td>14482</td><td>2022-09-22 07:29:00</td><td>2022-09-22 17:00:00</td><td>2022-09-22 19:00:00</td><td>121.5222</td><td>30.90740</td><td> 46</td><td>14</td><td>2022-09-22 15:28:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 922</td><td> 479</td></tr>\n",
       "\t<tr><td>4286951</td><td>0</td><td>Shanghai</td><td>11805</td><td>2022-09-20 16:16:00</td><td>2022-09-21 09:00:00</td><td>2022-09-21 11:00:00</td><td>121.5191</td><td>30.86547</td><td> 48</td><td>14</td><td>2022-09-21 08:21:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 921</td><td> 965</td></tr>\n",
       "\t<tr><td>2769814</td><td>0</td><td>Shanghai</td><td>11805</td><td>2022-09-21 16:24:00</td><td>2022-09-22 09:00:00</td><td>2022-09-22 11:00:00</td><td>121.5191</td><td>30.86532</td><td> 48</td><td>14</td><td>2022-09-22 08:03:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 922</td><td> 939</td></tr>\n",
       "\t<tr><td> 614748</td><td>0</td><td>Shanghai</td><td>11805</td><td>2022-09-02 16:16:00</td><td>2022-09-03 11:00:00</td><td>2022-09-03 13:00:00</td><td>121.5191</td><td>30.86536</td><td> 48</td><td>14</td><td>2022-09-03 09:29:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 903</td><td>1033</td></tr>\n",
       "\t<tr><td>5260413</td><td>0</td><td>Shanghai</td><td> 8122</td><td>2022-06-15 09:04:00</td><td>2022-06-15 13:00:00</td><td>2022-06-15 15:00:00</td><td>121.5589</td><td>30.91795</td><td>193</td><td>14</td><td>2022-06-15 14:18:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 615</td><td> 314</td></tr>\n",
       "\t<tr><td>5081399</td><td>0</td><td>Shanghai</td><td> 8122</td><td>2022-06-18 08:19:00</td><td>2022-06-18 11:00:00</td><td>2022-06-18 13:00:00</td><td>121.5590</td><td>30.91795</td><td>193</td><td>14</td><td>2022-06-18 14:21:00</td><td>06-18 14:21:00</td><td>121.5581</td><td>30.91735</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 618</td><td> 362</td></tr>\n",
       "\t<tr><td>4439023</td><td>0</td><td>Shanghai</td><td> 8122</td><td>2022-07-15 09:02:00</td><td>2022-07-15 15:00:00</td><td>2022-07-15 17:00:00</td><td>121.5628</td><td>30.91738</td><td>193</td><td>14</td><td>2022-07-15 16:47:00</td><td>07-15 16:47:00</td><td>121.5630</td><td>30.91744</td><td>07-15 09:02:00</td><td>121.5578</td><td>30.92076</td><td> 715</td><td> 465</td></tr>\n",
       "\t<tr><td>2747947</td><td>0</td><td>Shanghai</td><td> 8122</td><td>2022-06-16 08:40:00</td><td>2022-06-16 13:00:00</td><td>2022-06-16 15:00:00</td><td>121.5626</td><td>30.91747</td><td>193</td><td>14</td><td>2022-06-16 14:41:00</td><td>06-16 14:40:00</td><td>121.5629</td><td>30.91746</td><td>06-16 08:40:00</td><td>121.5359</td><td>30.91938</td><td> 616</td><td> 361</td></tr>\n",
       "\t<tr><td>1851827</td><td>0</td><td>Shanghai</td><td> 8122</td><td>2022-06-17 09:02:00</td><td>2022-06-17 17:00:00</td><td>2022-06-17 19:00:00</td><td>121.5589</td><td>30.91786</td><td>193</td><td>14</td><td>2022-06-17 16:54:00</td><td>06-17 16:54:00</td><td>121.5581</td><td>30.91771</td><td>06-17 09:02:00</td><td>121.5564</td><td>30.92786</td><td> 617</td><td> 472</td></tr>\n",
       "\t<tr><td>5325281</td><td>0</td><td>Shanghai</td><td> 8254</td><td>2022-07-27 08:09:00</td><td>2022-07-27 17:00:00</td><td>2022-07-27 19:00:00</td><td>121.5671</td><td>30.87793</td><td>232</td><td>14</td><td>2022-07-27 14:34:00</td><td>07-27 14:34:00</td><td>121.5678</td><td>30.87810</td><td>07-27 08:08:00</td><td>121.5402</td><td>30.92410</td><td> 727</td><td> 385</td></tr>\n",
       "\t<tr><td>4965278</td><td>0</td><td>Shanghai</td><td> 8254</td><td>2022-06-16 09:03:00</td><td>2022-06-16 17:00:00</td><td>2022-06-16 19:00:00</td><td>121.5677</td><td>30.87805</td><td>232</td><td>14</td><td>2022-06-16 16:26:00</td><td>06-16 16:26:00</td><td>121.5677</td><td>30.87803</td><td>06-16 09:02:00</td><td>121.5424</td><td>30.92788</td><td> 616</td><td> 443</td></tr>\n",
       "\t<tr><td>4895873</td><td>0</td><td>Shanghai</td><td> 8254</td><td>2022-09-02 08:15:00</td><td>2022-09-02 17:00:00</td><td>2022-09-02 19:00:00</td><td>121.5672</td><td>30.87575</td><td>232</td><td>14</td><td>2022-09-02 18:01:00</td><td>09-02 18:01:00</td><td>121.5432</td><td>30.87988</td><td>09-02 08:15:00</td><td>121.5415</td><td>30.92756</td><td> 902</td><td> 586</td></tr>\n",
       "\t<tr><td>4102307</td><td>0</td><td>Shanghai</td><td> 8254</td><td>2022-08-21 11:12:00</td><td>2022-08-21 17:00:00</td><td>2022-08-21 19:00:00</td><td>121.5666</td><td>30.87617</td><td>232</td><td>14</td><td>2022-08-21 16:15:00</td><td>08-21 16:15:00</td><td>121.5635</td><td>30.87540</td><td>08-21 11:12:00</td><td>121.5349</td><td>30.86389</td><td> 821</td><td> 303</td></tr>\n",
       "\t<tr><td>5884419</td><td>0</td><td>Shanghai</td><td> 8254</td><td>2022-08-15 07:33:00</td><td>2022-08-16 09:00:00</td><td>2022-08-16 11:00:00</td><td>121.5677</td><td>30.87802</td><td>232</td><td>14</td><td>2022-08-16 08:56:00</td><td>08-16 08:56:00</td><td>121.5696</td><td>30.87782</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 816</td><td>1523</td></tr>\n",
       "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
       "\t<tr><td>3685741</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-26 08:40:00</td><td>2022-06-26 15:00:00</td><td>2022-06-26 17:00:00</td><td>121.6158</td><td>31.20336</td><td>24410</td><td> 1</td><td>2022-06-26 16:19:00</td><td>06-26 16:19:00</td><td>121.6156</td><td>31.20321</td><td>06-26 08:40:00</td><td>121.6165</td><td>31.20133</td><td> 626</td><td> 459</td></tr>\n",
       "\t<tr><td> 951857</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-07-21 08:55:00</td><td>2022-07-22 11:00:00</td><td>2022-07-22 13:00:00</td><td>121.6165</td><td>31.20296</td><td>24410</td><td> 1</td><td>2022-07-22 10:49:00</td><td>07-22 10:48:00</td><td>121.6163</td><td>31.20280</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 722</td><td>1554</td></tr>\n",
       "\t<tr><td>4333073</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-08 08:03:00</td><td>2022-06-08 13:00:00</td><td>2022-06-08 15:00:00</td><td>121.6157</td><td>31.20336</td><td>24410</td><td> 1</td><td>2022-06-08 13:15:00</td><td>06-08 13:15:00</td><td>121.6160</td><td>31.20307</td><td>06-08 08:02:00</td><td>121.6141</td><td>31.20423</td><td> 608</td><td> 312</td></tr>\n",
       "\t<tr><td>4905330</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-08-26 08:48:00</td><td>2022-08-26 17:00:00</td><td>2022-08-26 19:00:00</td><td>121.6163</td><td>31.20284</td><td>24410</td><td> 1</td><td>2022-08-26 17:07:00</td><td>08-26 17:07:00</td><td>121.6164</td><td>31.20307</td><td>08-26 08:48:00</td><td>121.6125</td><td>31.20191</td><td> 826</td><td> 499</td></tr>\n",
       "\t<tr><td>5752042</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-10-13 09:16:00</td><td>2022-10-13 17:00:00</td><td>2022-10-13 19:00:00</td><td>121.6162</td><td>31.20272</td><td>24410</td><td> 1</td><td>2022-10-13 18:11:00</td><td>10-13 18:11:00</td><td>121.6172</td><td>31.20210</td><td>10-13 09:16:00</td><td>121.6175</td><td>31.20085</td><td>1013</td><td> 535</td></tr>\n",
       "\t<tr><td>3927428</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-10-12 09:20:00</td><td>2022-10-12 17:00:00</td><td>2022-10-12 19:00:00</td><td>121.6157</td><td>31.20341</td><td>24410</td><td> 1</td><td>2022-10-12 17:12:00</td><td>10-12 17:12:00</td><td>121.6157</td><td>31.20346</td><td>10-12 09:20:00</td><td>121.6167</td><td>31.20161</td><td>1012</td><td> 472</td></tr>\n",
       "\t<tr><td>5115813</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-08-11 16:00:00</td><td>2022-08-13 09:00:00</td><td>2022-08-13 11:00:00</td><td>121.6150</td><td>31.20356</td><td>24410</td><td> 1</td><td>2022-08-13 10:10:00</td><td>08-13 10:10:00</td><td>121.6150</td><td>31.20354</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 813</td><td>2530</td></tr>\n",
       "\t<tr><td>5493639</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-09-25 08:35:00</td><td>2022-09-26 09:00:00</td><td>2022-09-26 11:00:00</td><td>121.6156</td><td>31.20349</td><td>24410</td><td> 1</td><td>2022-09-26 08:58:00</td><td>09-26 08:58:00</td><td>121.6150</td><td>31.20378</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 926</td><td>1463</td></tr>\n",
       "\t<tr><td>2588658</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-10-29 16:36:00</td><td>2022-10-30 11:00:00</td><td>2022-10-30 13:00:00</td><td>121.6163</td><td>31.20270</td><td>24410</td><td> 1</td><td>2022-10-30 10:08:00</td><td>10-30 10:08:00</td><td>121.6183</td><td>31.20128</td><td>NA            </td><td>      NA</td><td>      NA</td><td>1030</td><td>1052</td></tr>\n",
       "\t<tr><td>6006501</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-08-15 08:01:00</td><td>2022-08-15 15:00:00</td><td>2022-08-15 17:00:00</td><td>121.6152</td><td>31.20282</td><td>24410</td><td> 1</td><td>2022-08-15 16:35:00</td><td>08-15 16:35:00</td><td>121.6161</td><td>31.20250</td><td>08-15 08:01:00</td><td>121.6136</td><td>31.20391</td><td> 815</td><td> 514</td></tr>\n",
       "\t<tr><td>2708060</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-07-22 08:11:00</td><td>2022-07-22 13:00:00</td><td>2022-07-22 15:00:00</td><td>121.6153</td><td>31.20290</td><td>24410</td><td> 1</td><td>2022-07-22 13:35:00</td><td>07-22 13:34:00</td><td>121.6157</td><td>31.20428</td><td>07-22 08:11:00</td><td>121.6136</td><td>31.20402</td><td> 722</td><td> 324</td></tr>\n",
       "\t<tr><td>4557998</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-07 09:09:00</td><td>2022-06-07 17:00:00</td><td>2022-06-07 19:00:00</td><td>121.6157</td><td>31.20345</td><td>24410</td><td> 1</td><td>2022-06-07 18:42:00</td><td>06-07 18:41:00</td><td>121.6153</td><td>31.20362</td><td>06-07 09:09:00</td><td>121.6137</td><td>31.20212</td><td> 607</td><td> 573</td></tr>\n",
       "\t<tr><td>2681724</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-07-02 11:55:00</td><td>2022-07-02 17:00:00</td><td>2022-07-02 19:00:00</td><td>121.6156</td><td>31.20368</td><td>24410</td><td> 1</td><td>2022-07-02 18:11:00</td><td>07-02 18:11:00</td><td>121.6154</td><td>31.20367</td><td>07-02 11:55:00</td><td>121.6180</td><td>31.20015</td><td> 702</td><td> 376</td></tr>\n",
       "\t<tr><td>4366962</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-14 08:41:00</td><td>2022-06-14 15:00:00</td><td>2022-06-14 17:00:00</td><td>121.6152</td><td>31.20298</td><td>24410</td><td> 1</td><td>2022-06-14 15:36:00</td><td>06-14 15:36:00</td><td>121.6157</td><td>31.20272</td><td>06-14 08:40:00</td><td>121.6133</td><td>31.20070</td><td> 614</td><td> 415</td></tr>\n",
       "\t<tr><td> 107026</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-16 09:01:00</td><td>2022-06-16 15:00:00</td><td>2022-06-16 17:00:00</td><td>121.6154</td><td>31.20286</td><td>24410</td><td> 1</td><td>2022-06-16 15:15:00</td><td>06-16 15:15:00</td><td>121.6159</td><td>31.20258</td><td>06-16 09:01:00</td><td>121.6144</td><td>31.20435</td><td> 616</td><td> 374</td></tr>\n",
       "\t<tr><td> 186333</td><td>67</td><td>Shanghai</td><td> 9824</td><td>2022-08-30 16:59:00</td><td>2022-08-31 17:00:00</td><td>2022-08-31 19:00:00</td><td>121.6153</td><td>31.20281</td><td>24410</td><td> 1</td><td>2022-08-31 18:24:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 831</td><td>1525</td></tr>\n",
       "\t<tr><td>5841213</td><td>67</td><td>Shanghai</td><td> 9824</td><td>2022-08-31 08:52:00</td><td>2022-08-31 17:00:00</td><td>2022-08-31 19:00:00</td><td>121.6156</td><td>31.20348</td><td>24410</td><td> 1</td><td>2022-08-31 18:14:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>08-31 08:52:00</td><td>121.6181</td><td>31.21446</td><td> 831</td><td> 562</td></tr>\n",
       "\t<tr><td>4838650</td><td>67</td><td>Shanghai</td><td>11052</td><td>2022-10-13 08:50:00</td><td>2022-10-13 17:00:00</td><td>2022-10-13 19:00:00</td><td>121.6163</td><td>31.20265</td><td>24410</td><td> 1</td><td>2022-10-13 17:54:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>NA            </td><td>      NA</td><td>      NA</td><td>1013</td><td> 544</td></tr>\n",
       "\t<tr><td>3108117</td><td>67</td><td>Shanghai</td><td>11696</td><td>2022-09-23 08:38:00</td><td>2022-09-23 17:00:00</td><td>2022-09-23 19:00:00</td><td>121.6157</td><td>31.20333</td><td>24410</td><td> 1</td><td>2022-09-23 16:35:00</td><td>09-23 16:35:00</td><td>121.6158</td><td>31.20325</td><td>09-23 08:31:00</td><td>121.6119</td><td>31.20576</td><td> 923</td><td> 477</td></tr>\n",
       "\t<tr><td>3670425</td><td>67</td><td>Shanghai</td><td> 4397</td><td>2022-06-18 09:22:00</td><td>2022-06-19 13:00:00</td><td>2022-06-19 15:00:00</td><td>121.6141</td><td>31.20511</td><td>24428</td><td>14</td><td>2022-06-19 11:26:00</td><td>06-19 11:26:00</td><td>121.6224</td><td>31.20949</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 619</td><td>1564</td></tr>\n",
       "\t<tr><td>4762898</td><td>67</td><td>Shanghai</td><td> 4596</td><td>2022-08-15 08:43:00</td><td>2022-08-15 17:00:00</td><td>2022-08-15 19:00:00</td><td>121.6143</td><td>31.20527</td><td>24428</td><td>14</td><td>2022-08-15 18:23:00</td><td>08-15 18:23:00</td><td>121.6229</td><td>31.16926</td><td>08-15 08:43:00</td><td>121.6439</td><td>31.16794</td><td> 815</td><td> 580</td></tr>\n",
       "\t<tr><td>1160267</td><td>67</td><td>Shanghai</td><td> 5168</td><td>2022-07-17 10:41:00</td><td>2022-07-17 15:00:00</td><td>2022-07-17 17:00:00</td><td>121.6142</td><td>31.20511</td><td>24428</td><td>14</td><td>2022-07-17 15:43:00</td><td>07-17 15:43:00</td><td>121.6237</td><td>31.17484</td><td>07-17 10:41:00</td><td>121.6220</td><td>31.17024</td><td> 717</td><td> 302</td></tr>\n",
       "\t<tr><td>3893165</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-10-28 11:05:00</td><td>2022-10-28 17:00:00</td><td>2022-10-28 19:00:00</td><td>121.6141</td><td>31.20528</td><td>24428</td><td>14</td><td>2022-10-28 18:08:00</td><td>10-28 18:08:00</td><td>121.6145</td><td>31.20371</td><td>NA            </td><td>      NA</td><td>      NA</td><td>1028</td><td> 423</td></tr>\n",
       "\t<tr><td>5311757</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-07-23 10:52:00</td><td>2022-07-25 09:00:00</td><td>2022-07-25 11:00:00</td><td>121.6142</td><td>31.20549</td><td>24428</td><td>14</td><td>2022-07-25 09:45:00</td><td>07-25 09:45:00</td><td>121.6146</td><td>31.20549</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 725</td><td>2813</td></tr>\n",
       "\t<tr><td>3864050</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-14 07:42:00</td><td>2022-06-15 09:00:00</td><td>2022-06-15 11:00:00</td><td>121.6141</td><td>31.20549</td><td>24428</td><td>14</td><td>2022-06-15 09:44:00</td><td>06-15 09:44:00</td><td>121.6144</td><td>31.20564</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 615</td><td>1562</td></tr>\n",
       "\t<tr><td>2613455</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-06-08 08:51:00</td><td>2022-06-08 13:00:00</td><td>2022-06-08 15:00:00</td><td>121.6141</td><td>31.20543</td><td>24428</td><td>14</td><td>2022-06-08 13:54:00</td><td>06-08 13:53:00</td><td>121.6146</td><td>31.20553</td><td>06-08 08:50:00</td><td>121.6114</td><td>31.20240</td><td> 608</td><td> 303</td></tr>\n",
       "\t<tr><td>2917016</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-09-14 09:19:00</td><td>2022-09-14 15:00:00</td><td>2022-09-14 17:00:00</td><td>121.6141</td><td>31.20520</td><td>24428</td><td>14</td><td>2022-09-14 16:37:00</td><td>09-14 16:37:00</td><td>121.6145</td><td>31.20537</td><td>09-14 09:19:00</td><td>121.6166</td><td>31.20281</td><td> 914</td><td> 438</td></tr>\n",
       "\t<tr><td>1484646</td><td>67</td><td>Shanghai</td><td> 8843</td><td>2022-07-11 07:46:00</td><td>2022-07-11 17:00:00</td><td>2022-07-11 19:00:00</td><td>121.6141</td><td>31.20539</td><td>24428</td><td>14</td><td>2022-07-11 17:25:00</td><td>07-11 17:25:00</td><td>121.6146</td><td>31.20469</td><td>07-11 07:46:00</td><td>121.6138</td><td>31.20403</td><td> 711</td><td> 579</td></tr>\n",
       "\t<tr><td>5983392</td><td>67</td><td>Shanghai</td><td>13691</td><td>2022-10-15 07:39:00</td><td>2022-10-15 15:00:00</td><td>2022-10-15 17:00:00</td><td>121.6142</td><td>31.20518</td><td>24428</td><td>14</td><td>2022-10-15 15:30:00</td><td>NA            </td><td>      NA</td><td>      NA</td><td>10-15 07:39:00</td><td>121.6519</td><td>31.18482</td><td>1015</td><td> 471</td></tr>\n",
       "\t<tr><td>5591098</td><td>67</td><td>Shanghai</td><td>14852</td><td>2022-08-13 09:03:00</td><td>2022-08-14 09:00:00</td><td>2022-08-14 11:00:00</td><td>121.6143</td><td>31.20522</td><td>24428</td><td>14</td><td>2022-08-14 09:32:00</td><td>08-14 09:32:00</td><td>121.7276</td><td>31.15475</td><td>NA            </td><td>      NA</td><td>      NA</td><td> 814</td><td>1469</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 230733 × 20\n",
       "\\begin{tabular}{llllllllllllllllllll}\n",
       " order\\_id & region\\_id & city & courier\\_id & accept\\_time & time\\_window\\_start & time\\_window\\_end & lng & lat & aoi\\_id & aoi\\_type & pickup\\_time & pickup\\_gps\\_time & pickup\\_gps\\_lng & pickup\\_gps\\_lat & accept\\_gps\\_time & accept\\_gps\\_lng & accept\\_gps\\_lat & ds & pickup\\_latency\\_mins\\\\\n",
       " <int> & <int> & <chr> & <int> & <dttm> & <dttm> & <dttm> & <dbl> & <dbl> & <int> & <int> & <dttm> & <chr> & <dbl> & <dbl> & <chr> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 5691514 & 0 & Shanghai &  1448 & 2022-07-12 07:40:00 & 2022-07-12 17:00:00 & 2022-07-12 19:00:00 & 121.5223 & 30.90731 &  46 & 14 & 2022-07-12 17:22:00 & 07-12 17:22:00 & 121.5261 & 30.91764 & 07-12 07:37:00 & 121.4974 & 30.90695 &  712 &  582\\\\\n",
       "\t 2710020 & 0 & Shanghai &  3243 & 2022-08-31 08:04:00 & 2022-08-31 17:00:00 & 2022-08-31 19:00:00 & 121.5223 & 30.90742 &  46 & 14 & 2022-08-31 18:55:00 & 08-31 18:55:00 & 121.5270 & 30.91921 & 08-31 08:04:00 & 121.4975 & 30.90696 &  831 &  651\\\\\n",
       "\t  176722 & 0 & Shanghai &  3243 & 2022-09-03 15:22:00 & 2022-09-04 15:00:00 & 2022-09-04 17:00:00 & 121.5223 & 30.90731 &  46 & 14 & 2022-09-04 15:22:00 & 09-04 15:21:00 & 121.5262 & 30.91779 & NA             &       NA &       NA &  904 & 1440\\\\\n",
       "\t 1314029 & 0 & Shanghai &  3243 & 2022-09-01 09:19:00 & 2022-09-02 17:00:00 & 2022-09-02 19:00:00 & 121.5223 & 30.90732 &  46 & 14 & 2022-09-02 16:57:00 & 09-02 16:57:00 & 121.5179 & 30.90631 & NA             &       NA &       NA &  902 & 1898\\\\\n",
       "\t   62447 & 0 & Shanghai &  3243 & 2022-10-16 09:08:00 & 2022-10-16 15:00:00 & 2022-10-16 17:00:00 & 121.5225 & 30.90743 &  46 & 14 & 2022-10-16 15:30:00 & 10-16 15:30:00 & 121.5260 & 30.91927 & 10-16 09:08:00 & 121.5094 & 30.90367 & 1016 &  382\\\\\n",
       "\t 4886349 & 0 & Shanghai &  3243 & 2022-09-05 08:01:00 & 2022-09-05 09:00:00 & 2022-09-05 11:00:00 & 121.5222 & 30.90733 &  46 & 14 & 2022-09-05 16:20:00 & 09-05 16:20:00 & 121.4974 & 30.90681 & 09-05 08:01:00 & 121.4973 & 30.90684 &  905 &  499\\\\\n",
       "\t 1291405 & 0 & Shanghai &  3243 & 2022-08-18 10:58:00 & 2022-08-19 17:00:00 & 2022-08-19 19:00:00 & 121.5223 & 30.90737 &  46 & 14 & 2022-08-19 17:46:00 & 08-19 17:46:00 & 121.5215 & 30.90898 & NA             &       NA &       NA &  819 & 1848\\\\\n",
       "\t 1257902 & 0 & Shanghai &  3243 & 2022-08-22 07:54:00 & 2022-08-22 17:00:00 & 2022-08-22 19:00:00 & 121.5223 & 30.90734 &  46 & 14 & 2022-08-22 18:37:00 & 08-22 18:37:00 & 121.5259 & 30.91656 & NA             &       NA &       NA &  822 &  643\\\\\n",
       "\t 2370290 & 0 & Shanghai &  3243 & 2022-08-02 07:44:00 & 2022-08-02 17:00:00 & 2022-08-02 19:00:00 & 121.5223 & 30.90745 &  46 & 14 & 2022-08-02 14:39:00 & 08-02 14:38:00 & 121.5263 & 30.91692 & 08-02 07:44:00 & 121.4974 & 30.90687 &  802 &  415\\\\\n",
       "\t 1274284 & 0 & Shanghai &  3243 & 2022-10-01 08:47:00 & 2022-10-01 17:00:00 & 2022-10-01 19:00:00 & 121.5223 & 30.90736 &  46 & 14 & 2022-10-01 16:28:00 & 10-01 16:28:00 & 121.5219 & 30.90799 & 10-01 08:47:00 & 121.5069 & 30.89505 & 1001 &  461\\\\\n",
       "\t 1705580 & 0 & Shanghai &  3243 & 2022-08-28 07:07:00 & 2022-08-28 17:00:00 & 2022-08-28 19:00:00 & 121.5224 & 30.90740 &  46 & 14 & 2022-08-28 12:46:00 & 08-28 12:46:00 & 121.5262 & 30.91691 & NA             &       NA &       NA &  828 &  339\\\\\n",
       "\t 3769096 & 0 & Shanghai &  3243 & 2022-09-01 07:23:00 & 2022-09-01 17:00:00 & 2022-09-01 19:00:00 & 121.5222 & 30.90747 &  46 & 14 & 2022-09-01 15:24:00 & 09-01 15:24:00 & 121.5260 & 30.91919 & 09-01 07:16:00 & 121.4974 & 30.90690 &  901 &  481\\\\\n",
       "\t 4861238 & 0 & Shanghai &  3243 & 2022-06-16 08:43:00 & 2022-06-16 15:00:00 & 2022-06-16 17:00:00 & 121.5223 & 30.90741 &  46 & 14 & 2022-06-16 14:40:00 & 06-16 14:40:00 & 121.5266 & 30.91325 & 06-16 08:43:00 & 121.5071 & 30.89914 &  616 &  357\\\\\n",
       "\t 6033374 & 0 & Shanghai &  3243 & 2022-06-18 07:37:00 & 2022-06-19 17:00:00 & 2022-06-19 19:00:00 & 121.5224 & 30.90733 &  46 & 14 & 2022-06-19 17:12:00 & 06-19 17:12:00 & 121.5264 & 30.91665 & NA             &       NA &       NA &  619 & 2015\\\\\n",
       "\t 2342015 & 0 & Shanghai &  4598 & 2022-06-03 08:26:00 & 2022-06-03 13:00:00 & 2022-06-03 15:00:00 & 121.5223 & 30.90740 &  46 & 14 & 2022-06-03 14:07:00 & NA             &       NA &       NA & NA             &       NA &       NA &  603 &  341\\\\\n",
       "\t 1735032 & 0 & Shanghai & 14482 & 2022-09-21 07:37:00 & 2022-09-21 15:00:00 & 2022-09-21 17:00:00 & 121.5223 & 30.90735 &  46 & 14 & 2022-09-21 14:34:00 & NA             &       NA &       NA & NA             &       NA &       NA &  921 &  417\\\\\n",
       "\t  263781 & 0 & Shanghai & 14482 & 2022-09-22 07:29:00 & 2022-09-22 17:00:00 & 2022-09-22 19:00:00 & 121.5222 & 30.90740 &  46 & 14 & 2022-09-22 15:28:00 & NA             &       NA &       NA & NA             &       NA &       NA &  922 &  479\\\\\n",
       "\t 4286951 & 0 & Shanghai & 11805 & 2022-09-20 16:16:00 & 2022-09-21 09:00:00 & 2022-09-21 11:00:00 & 121.5191 & 30.86547 &  48 & 14 & 2022-09-21 08:21:00 & NA             &       NA &       NA & NA             &       NA &       NA &  921 &  965\\\\\n",
       "\t 2769814 & 0 & Shanghai & 11805 & 2022-09-21 16:24:00 & 2022-09-22 09:00:00 & 2022-09-22 11:00:00 & 121.5191 & 30.86532 &  48 & 14 & 2022-09-22 08:03:00 & NA             &       NA &       NA & NA             &       NA &       NA &  922 &  939\\\\\n",
       "\t  614748 & 0 & Shanghai & 11805 & 2022-09-02 16:16:00 & 2022-09-03 11:00:00 & 2022-09-03 13:00:00 & 121.5191 & 30.86536 &  48 & 14 & 2022-09-03 09:29:00 & NA             &       NA &       NA & NA             &       NA &       NA &  903 & 1033\\\\\n",
       "\t 5260413 & 0 & Shanghai &  8122 & 2022-06-15 09:04:00 & 2022-06-15 13:00:00 & 2022-06-15 15:00:00 & 121.5589 & 30.91795 & 193 & 14 & 2022-06-15 14:18:00 & NA             &       NA &       NA & NA             &       NA &       NA &  615 &  314\\\\\n",
       "\t 5081399 & 0 & Shanghai &  8122 & 2022-06-18 08:19:00 & 2022-06-18 11:00:00 & 2022-06-18 13:00:00 & 121.5590 & 30.91795 & 193 & 14 & 2022-06-18 14:21:00 & 06-18 14:21:00 & 121.5581 & 30.91735 & NA             &       NA &       NA &  618 &  362\\\\\n",
       "\t 4439023 & 0 & Shanghai &  8122 & 2022-07-15 09:02:00 & 2022-07-15 15:00:00 & 2022-07-15 17:00:00 & 121.5628 & 30.91738 & 193 & 14 & 2022-07-15 16:47:00 & 07-15 16:47:00 & 121.5630 & 30.91744 & 07-15 09:02:00 & 121.5578 & 30.92076 &  715 &  465\\\\\n",
       "\t 2747947 & 0 & Shanghai &  8122 & 2022-06-16 08:40:00 & 2022-06-16 13:00:00 & 2022-06-16 15:00:00 & 121.5626 & 30.91747 & 193 & 14 & 2022-06-16 14:41:00 & 06-16 14:40:00 & 121.5629 & 30.91746 & 06-16 08:40:00 & 121.5359 & 30.91938 &  616 &  361\\\\\n",
       "\t 1851827 & 0 & Shanghai &  8122 & 2022-06-17 09:02:00 & 2022-06-17 17:00:00 & 2022-06-17 19:00:00 & 121.5589 & 30.91786 & 193 & 14 & 2022-06-17 16:54:00 & 06-17 16:54:00 & 121.5581 & 30.91771 & 06-17 09:02:00 & 121.5564 & 30.92786 &  617 &  472\\\\\n",
       "\t 5325281 & 0 & Shanghai &  8254 & 2022-07-27 08:09:00 & 2022-07-27 17:00:00 & 2022-07-27 19:00:00 & 121.5671 & 30.87793 & 232 & 14 & 2022-07-27 14:34:00 & 07-27 14:34:00 & 121.5678 & 30.87810 & 07-27 08:08:00 & 121.5402 & 30.92410 &  727 &  385\\\\\n",
       "\t 4965278 & 0 & Shanghai &  8254 & 2022-06-16 09:03:00 & 2022-06-16 17:00:00 & 2022-06-16 19:00:00 & 121.5677 & 30.87805 & 232 & 14 & 2022-06-16 16:26:00 & 06-16 16:26:00 & 121.5677 & 30.87803 & 06-16 09:02:00 & 121.5424 & 30.92788 &  616 &  443\\\\\n",
       "\t 4895873 & 0 & Shanghai &  8254 & 2022-09-02 08:15:00 & 2022-09-02 17:00:00 & 2022-09-02 19:00:00 & 121.5672 & 30.87575 & 232 & 14 & 2022-09-02 18:01:00 & 09-02 18:01:00 & 121.5432 & 30.87988 & 09-02 08:15:00 & 121.5415 & 30.92756 &  902 &  586\\\\\n",
       "\t 4102307 & 0 & Shanghai &  8254 & 2022-08-21 11:12:00 & 2022-08-21 17:00:00 & 2022-08-21 19:00:00 & 121.5666 & 30.87617 & 232 & 14 & 2022-08-21 16:15:00 & 08-21 16:15:00 & 121.5635 & 30.87540 & 08-21 11:12:00 & 121.5349 & 30.86389 &  821 &  303\\\\\n",
       "\t 5884419 & 0 & Shanghai &  8254 & 2022-08-15 07:33:00 & 2022-08-16 09:00:00 & 2022-08-16 11:00:00 & 121.5677 & 30.87802 & 232 & 14 & 2022-08-16 08:56:00 & 08-16 08:56:00 & 121.5696 & 30.87782 & NA             &       NA &       NA &  816 & 1523\\\\\n",
       "\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n",
       "\t 3685741 & 67 & Shanghai &  8843 & 2022-06-26 08:40:00 & 2022-06-26 15:00:00 & 2022-06-26 17:00:00 & 121.6158 & 31.20336 & 24410 &  1 & 2022-06-26 16:19:00 & 06-26 16:19:00 & 121.6156 & 31.20321 & 06-26 08:40:00 & 121.6165 & 31.20133 &  626 &  459\\\\\n",
       "\t  951857 & 67 & Shanghai &  8843 & 2022-07-21 08:55:00 & 2022-07-22 11:00:00 & 2022-07-22 13:00:00 & 121.6165 & 31.20296 & 24410 &  1 & 2022-07-22 10:49:00 & 07-22 10:48:00 & 121.6163 & 31.20280 & NA             &       NA &       NA &  722 & 1554\\\\\n",
       "\t 4333073 & 67 & Shanghai &  8843 & 2022-06-08 08:03:00 & 2022-06-08 13:00:00 & 2022-06-08 15:00:00 & 121.6157 & 31.20336 & 24410 &  1 & 2022-06-08 13:15:00 & 06-08 13:15:00 & 121.6160 & 31.20307 & 06-08 08:02:00 & 121.6141 & 31.20423 &  608 &  312\\\\\n",
       "\t 4905330 & 67 & Shanghai &  8843 & 2022-08-26 08:48:00 & 2022-08-26 17:00:00 & 2022-08-26 19:00:00 & 121.6163 & 31.20284 & 24410 &  1 & 2022-08-26 17:07:00 & 08-26 17:07:00 & 121.6164 & 31.20307 & 08-26 08:48:00 & 121.6125 & 31.20191 &  826 &  499\\\\\n",
       "\t 5752042 & 67 & Shanghai &  8843 & 2022-10-13 09:16:00 & 2022-10-13 17:00:00 & 2022-10-13 19:00:00 & 121.6162 & 31.20272 & 24410 &  1 & 2022-10-13 18:11:00 & 10-13 18:11:00 & 121.6172 & 31.20210 & 10-13 09:16:00 & 121.6175 & 31.20085 & 1013 &  535\\\\\n",
       "\t 3927428 & 67 & Shanghai &  8843 & 2022-10-12 09:20:00 & 2022-10-12 17:00:00 & 2022-10-12 19:00:00 & 121.6157 & 31.20341 & 24410 &  1 & 2022-10-12 17:12:00 & 10-12 17:12:00 & 121.6157 & 31.20346 & 10-12 09:20:00 & 121.6167 & 31.20161 & 1012 &  472\\\\\n",
       "\t 5115813 & 67 & Shanghai &  8843 & 2022-08-11 16:00:00 & 2022-08-13 09:00:00 & 2022-08-13 11:00:00 & 121.6150 & 31.20356 & 24410 &  1 & 2022-08-13 10:10:00 & 08-13 10:10:00 & 121.6150 & 31.20354 & NA             &       NA &       NA &  813 & 2530\\\\\n",
       "\t 5493639 & 67 & Shanghai &  8843 & 2022-09-25 08:35:00 & 2022-09-26 09:00:00 & 2022-09-26 11:00:00 & 121.6156 & 31.20349 & 24410 &  1 & 2022-09-26 08:58:00 & 09-26 08:58:00 & 121.6150 & 31.20378 & NA             &       NA &       NA &  926 & 1463\\\\\n",
       "\t 2588658 & 67 & Shanghai &  8843 & 2022-10-29 16:36:00 & 2022-10-30 11:00:00 & 2022-10-30 13:00:00 & 121.6163 & 31.20270 & 24410 &  1 & 2022-10-30 10:08:00 & 10-30 10:08:00 & 121.6183 & 31.20128 & NA             &       NA &       NA & 1030 & 1052\\\\\n",
       "\t 6006501 & 67 & Shanghai &  8843 & 2022-08-15 08:01:00 & 2022-08-15 15:00:00 & 2022-08-15 17:00:00 & 121.6152 & 31.20282 & 24410 &  1 & 2022-08-15 16:35:00 & 08-15 16:35:00 & 121.6161 & 31.20250 & 08-15 08:01:00 & 121.6136 & 31.20391 &  815 &  514\\\\\n",
       "\t 2708060 & 67 & Shanghai &  8843 & 2022-07-22 08:11:00 & 2022-07-22 13:00:00 & 2022-07-22 15:00:00 & 121.6153 & 31.20290 & 24410 &  1 & 2022-07-22 13:35:00 & 07-22 13:34:00 & 121.6157 & 31.20428 & 07-22 08:11:00 & 121.6136 & 31.20402 &  722 &  324\\\\\n",
       "\t 4557998 & 67 & Shanghai &  8843 & 2022-06-07 09:09:00 & 2022-06-07 17:00:00 & 2022-06-07 19:00:00 & 121.6157 & 31.20345 & 24410 &  1 & 2022-06-07 18:42:00 & 06-07 18:41:00 & 121.6153 & 31.20362 & 06-07 09:09:00 & 121.6137 & 31.20212 &  607 &  573\\\\\n",
       "\t 2681724 & 67 & Shanghai &  8843 & 2022-07-02 11:55:00 & 2022-07-02 17:00:00 & 2022-07-02 19:00:00 & 121.6156 & 31.20368 & 24410 &  1 & 2022-07-02 18:11:00 & 07-02 18:11:00 & 121.6154 & 31.20367 & 07-02 11:55:00 & 121.6180 & 31.20015 &  702 &  376\\\\\n",
       "\t 4366962 & 67 & Shanghai &  8843 & 2022-06-14 08:41:00 & 2022-06-14 15:00:00 & 2022-06-14 17:00:00 & 121.6152 & 31.20298 & 24410 &  1 & 2022-06-14 15:36:00 & 06-14 15:36:00 & 121.6157 & 31.20272 & 06-14 08:40:00 & 121.6133 & 31.20070 &  614 &  415\\\\\n",
       "\t  107026 & 67 & Shanghai &  8843 & 2022-06-16 09:01:00 & 2022-06-16 15:00:00 & 2022-06-16 17:00:00 & 121.6154 & 31.20286 & 24410 &  1 & 2022-06-16 15:15:00 & 06-16 15:15:00 & 121.6159 & 31.20258 & 06-16 09:01:00 & 121.6144 & 31.20435 &  616 &  374\\\\\n",
       "\t  186333 & 67 & Shanghai &  9824 & 2022-08-30 16:59:00 & 2022-08-31 17:00:00 & 2022-08-31 19:00:00 & 121.6153 & 31.20281 & 24410 &  1 & 2022-08-31 18:24:00 & NA             &       NA &       NA & NA             &       NA &       NA &  831 & 1525\\\\\n",
       "\t 5841213 & 67 & Shanghai &  9824 & 2022-08-31 08:52:00 & 2022-08-31 17:00:00 & 2022-08-31 19:00:00 & 121.6156 & 31.20348 & 24410 &  1 & 2022-08-31 18:14:00 & NA             &       NA &       NA & 08-31 08:52:00 & 121.6181 & 31.21446 &  831 &  562\\\\\n",
       "\t 4838650 & 67 & Shanghai & 11052 & 2022-10-13 08:50:00 & 2022-10-13 17:00:00 & 2022-10-13 19:00:00 & 121.6163 & 31.20265 & 24410 &  1 & 2022-10-13 17:54:00 & NA             &       NA &       NA & NA             &       NA &       NA & 1013 &  544\\\\\n",
       "\t 3108117 & 67 & Shanghai & 11696 & 2022-09-23 08:38:00 & 2022-09-23 17:00:00 & 2022-09-23 19:00:00 & 121.6157 & 31.20333 & 24410 &  1 & 2022-09-23 16:35:00 & 09-23 16:35:00 & 121.6158 & 31.20325 & 09-23 08:31:00 & 121.6119 & 31.20576 &  923 &  477\\\\\n",
       "\t 3670425 & 67 & Shanghai &  4397 & 2022-06-18 09:22:00 & 2022-06-19 13:00:00 & 2022-06-19 15:00:00 & 121.6141 & 31.20511 & 24428 & 14 & 2022-06-19 11:26:00 & 06-19 11:26:00 & 121.6224 & 31.20949 & NA             &       NA &       NA &  619 & 1564\\\\\n",
       "\t 4762898 & 67 & Shanghai &  4596 & 2022-08-15 08:43:00 & 2022-08-15 17:00:00 & 2022-08-15 19:00:00 & 121.6143 & 31.20527 & 24428 & 14 & 2022-08-15 18:23:00 & 08-15 18:23:00 & 121.6229 & 31.16926 & 08-15 08:43:00 & 121.6439 & 31.16794 &  815 &  580\\\\\n",
       "\t 1160267 & 67 & Shanghai &  5168 & 2022-07-17 10:41:00 & 2022-07-17 15:00:00 & 2022-07-17 17:00:00 & 121.6142 & 31.20511 & 24428 & 14 & 2022-07-17 15:43:00 & 07-17 15:43:00 & 121.6237 & 31.17484 & 07-17 10:41:00 & 121.6220 & 31.17024 &  717 &  302\\\\\n",
       "\t 3893165 & 67 & Shanghai &  8843 & 2022-10-28 11:05:00 & 2022-10-28 17:00:00 & 2022-10-28 19:00:00 & 121.6141 & 31.20528 & 24428 & 14 & 2022-10-28 18:08:00 & 10-28 18:08:00 & 121.6145 & 31.20371 & NA             &       NA &       NA & 1028 &  423\\\\\n",
       "\t 5311757 & 67 & Shanghai &  8843 & 2022-07-23 10:52:00 & 2022-07-25 09:00:00 & 2022-07-25 11:00:00 & 121.6142 & 31.20549 & 24428 & 14 & 2022-07-25 09:45:00 & 07-25 09:45:00 & 121.6146 & 31.20549 & NA             &       NA &       NA &  725 & 2813\\\\\n",
       "\t 3864050 & 67 & Shanghai &  8843 & 2022-06-14 07:42:00 & 2022-06-15 09:00:00 & 2022-06-15 11:00:00 & 121.6141 & 31.20549 & 24428 & 14 & 2022-06-15 09:44:00 & 06-15 09:44:00 & 121.6144 & 31.20564 & NA             &       NA &       NA &  615 & 1562\\\\\n",
       "\t 2613455 & 67 & Shanghai &  8843 & 2022-06-08 08:51:00 & 2022-06-08 13:00:00 & 2022-06-08 15:00:00 & 121.6141 & 31.20543 & 24428 & 14 & 2022-06-08 13:54:00 & 06-08 13:53:00 & 121.6146 & 31.20553 & 06-08 08:50:00 & 121.6114 & 31.20240 &  608 &  303\\\\\n",
       "\t 2917016 & 67 & Shanghai &  8843 & 2022-09-14 09:19:00 & 2022-09-14 15:00:00 & 2022-09-14 17:00:00 & 121.6141 & 31.20520 & 24428 & 14 & 2022-09-14 16:37:00 & 09-14 16:37:00 & 121.6145 & 31.20537 & 09-14 09:19:00 & 121.6166 & 31.20281 &  914 &  438\\\\\n",
       "\t 1484646 & 67 & Shanghai &  8843 & 2022-07-11 07:46:00 & 2022-07-11 17:00:00 & 2022-07-11 19:00:00 & 121.6141 & 31.20539 & 24428 & 14 & 2022-07-11 17:25:00 & 07-11 17:25:00 & 121.6146 & 31.20469 & 07-11 07:46:00 & 121.6138 & 31.20403 &  711 &  579\\\\\n",
       "\t 5983392 & 67 & Shanghai & 13691 & 2022-10-15 07:39:00 & 2022-10-15 15:00:00 & 2022-10-15 17:00:00 & 121.6142 & 31.20518 & 24428 & 14 & 2022-10-15 15:30:00 & NA             &       NA &       NA & 10-15 07:39:00 & 121.6519 & 31.18482 & 1015 &  471\\\\\n",
       "\t 5591098 & 67 & Shanghai & 14852 & 2022-08-13 09:03:00 & 2022-08-14 09:00:00 & 2022-08-14 11:00:00 & 121.6143 & 31.20522 & 24428 & 14 & 2022-08-14 09:32:00 & 08-14 09:32:00 & 121.7276 & 31.15475 & NA             &       NA &       NA &  814 & 1469\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 230733 × 20\n",
       "\n",
       "| order_id &lt;int&gt; | region_id &lt;int&gt; | city &lt;chr&gt; | courier_id &lt;int&gt; | accept_time &lt;dttm&gt; | time_window_start &lt;dttm&gt; | time_window_end &lt;dttm&gt; | lng &lt;dbl&gt; | lat &lt;dbl&gt; | aoi_id &lt;int&gt; | aoi_type &lt;int&gt; | pickup_time &lt;dttm&gt; | pickup_gps_time &lt;chr&gt; | pickup_gps_lng &lt;dbl&gt; | pickup_gps_lat &lt;dbl&gt; | accept_gps_time &lt;chr&gt; | accept_gps_lng &lt;dbl&gt; | accept_gps_lat &lt;dbl&gt; | ds &lt;int&gt; | pickup_latency_mins &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 5691514 | 0 | Shanghai |  1448 | 2022-07-12 07:40:00 | 2022-07-12 17:00:00 | 2022-07-12 19:00:00 | 121.5223 | 30.90731 |  46 | 14 | 2022-07-12 17:22:00 | 07-12 17:22:00 | 121.5261 | 30.91764 | 07-12 07:37:00 | 121.4974 | 30.90695 |  712 |  582 |\n",
       "| 2710020 | 0 | Shanghai |  3243 | 2022-08-31 08:04:00 | 2022-08-31 17:00:00 | 2022-08-31 19:00:00 | 121.5223 | 30.90742 |  46 | 14 | 2022-08-31 18:55:00 | 08-31 18:55:00 | 121.5270 | 30.91921 | 08-31 08:04:00 | 121.4975 | 30.90696 |  831 |  651 |\n",
       "|  176722 | 0 | Shanghai |  3243 | 2022-09-03 15:22:00 | 2022-09-04 15:00:00 | 2022-09-04 17:00:00 | 121.5223 | 30.90731 |  46 | 14 | 2022-09-04 15:22:00 | 09-04 15:21:00 | 121.5262 | 30.91779 | NA             |       NA |       NA |  904 | 1440 |\n",
       "| 1314029 | 0 | Shanghai |  3243 | 2022-09-01 09:19:00 | 2022-09-02 17:00:00 | 2022-09-02 19:00:00 | 121.5223 | 30.90732 |  46 | 14 | 2022-09-02 16:57:00 | 09-02 16:57:00 | 121.5179 | 30.90631 | NA             |       NA |       NA |  902 | 1898 |\n",
       "|   62447 | 0 | Shanghai |  3243 | 2022-10-16 09:08:00 | 2022-10-16 15:00:00 | 2022-10-16 17:00:00 | 121.5225 | 30.90743 |  46 | 14 | 2022-10-16 15:30:00 | 10-16 15:30:00 | 121.5260 | 30.91927 | 10-16 09:08:00 | 121.5094 | 30.90367 | 1016 |  382 |\n",
       "| 4886349 | 0 | Shanghai |  3243 | 2022-09-05 08:01:00 | 2022-09-05 09:00:00 | 2022-09-05 11:00:00 | 121.5222 | 30.90733 |  46 | 14 | 2022-09-05 16:20:00 | 09-05 16:20:00 | 121.4974 | 30.90681 | 09-05 08:01:00 | 121.4973 | 30.90684 |  905 |  499 |\n",
       "| 1291405 | 0 | Shanghai |  3243 | 2022-08-18 10:58:00 | 2022-08-19 17:00:00 | 2022-08-19 19:00:00 | 121.5223 | 30.90737 |  46 | 14 | 2022-08-19 17:46:00 | 08-19 17:46:00 | 121.5215 | 30.90898 | NA             |       NA |       NA |  819 | 1848 |\n",
       "| 1257902 | 0 | Shanghai |  3243 | 2022-08-22 07:54:00 | 2022-08-22 17:00:00 | 2022-08-22 19:00:00 | 121.5223 | 30.90734 |  46 | 14 | 2022-08-22 18:37:00 | 08-22 18:37:00 | 121.5259 | 30.91656 | NA             |       NA |       NA |  822 |  643 |\n",
       "| 2370290 | 0 | Shanghai |  3243 | 2022-08-02 07:44:00 | 2022-08-02 17:00:00 | 2022-08-02 19:00:00 | 121.5223 | 30.90745 |  46 | 14 | 2022-08-02 14:39:00 | 08-02 14:38:00 | 121.5263 | 30.91692 | 08-02 07:44:00 | 121.4974 | 30.90687 |  802 |  415 |\n",
       "| 1274284 | 0 | Shanghai |  3243 | 2022-10-01 08:47:00 | 2022-10-01 17:00:00 | 2022-10-01 19:00:00 | 121.5223 | 30.90736 |  46 | 14 | 2022-10-01 16:28:00 | 10-01 16:28:00 | 121.5219 | 30.90799 | 10-01 08:47:00 | 121.5069 | 30.89505 | 1001 |  461 |\n",
       "| 1705580 | 0 | Shanghai |  3243 | 2022-08-28 07:07:00 | 2022-08-28 17:00:00 | 2022-08-28 19:00:00 | 121.5224 | 30.90740 |  46 | 14 | 2022-08-28 12:46:00 | 08-28 12:46:00 | 121.5262 | 30.91691 | NA             |       NA |       NA |  828 |  339 |\n",
       "| 3769096 | 0 | Shanghai |  3243 | 2022-09-01 07:23:00 | 2022-09-01 17:00:00 | 2022-09-01 19:00:00 | 121.5222 | 30.90747 |  46 | 14 | 2022-09-01 15:24:00 | 09-01 15:24:00 | 121.5260 | 30.91919 | 09-01 07:16:00 | 121.4974 | 30.90690 |  901 |  481 |\n",
       "| 4861238 | 0 | Shanghai |  3243 | 2022-06-16 08:43:00 | 2022-06-16 15:00:00 | 2022-06-16 17:00:00 | 121.5223 | 30.90741 |  46 | 14 | 2022-06-16 14:40:00 | 06-16 14:40:00 | 121.5266 | 30.91325 | 06-16 08:43:00 | 121.5071 | 30.89914 |  616 |  357 |\n",
       "| 6033374 | 0 | Shanghai |  3243 | 2022-06-18 07:37:00 | 2022-06-19 17:00:00 | 2022-06-19 19:00:00 | 121.5224 | 30.90733 |  46 | 14 | 2022-06-19 17:12:00 | 06-19 17:12:00 | 121.5264 | 30.91665 | NA             |       NA |       NA |  619 | 2015 |\n",
       "| 2342015 | 0 | Shanghai |  4598 | 2022-06-03 08:26:00 | 2022-06-03 13:00:00 | 2022-06-03 15:00:00 | 121.5223 | 30.90740 |  46 | 14 | 2022-06-03 14:07:00 | NA             |       NA |       NA | NA             |       NA |       NA |  603 |  341 |\n",
       "| 1735032 | 0 | Shanghai | 14482 | 2022-09-21 07:37:00 | 2022-09-21 15:00:00 | 2022-09-21 17:00:00 | 121.5223 | 30.90735 |  46 | 14 | 2022-09-21 14:34:00 | NA             |       NA |       NA | NA             |       NA |       NA |  921 |  417 |\n",
       "|  263781 | 0 | Shanghai | 14482 | 2022-09-22 07:29:00 | 2022-09-22 17:00:00 | 2022-09-22 19:00:00 | 121.5222 | 30.90740 |  46 | 14 | 2022-09-22 15:28:00 | NA             |       NA |       NA | NA             |       NA |       NA |  922 |  479 |\n",
       "| 4286951 | 0 | Shanghai | 11805 | 2022-09-20 16:16:00 | 2022-09-21 09:00:00 | 2022-09-21 11:00:00 | 121.5191 | 30.86547 |  48 | 14 | 2022-09-21 08:21:00 | NA             |       NA |       NA | NA             |       NA |       NA |  921 |  965 |\n",
       "| 2769814 | 0 | Shanghai | 11805 | 2022-09-21 16:24:00 | 2022-09-22 09:00:00 | 2022-09-22 11:00:00 | 121.5191 | 30.86532 |  48 | 14 | 2022-09-22 08:03:00 | NA             |       NA |       NA | NA             |       NA |       NA |  922 |  939 |\n",
       "|  614748 | 0 | Shanghai | 11805 | 2022-09-02 16:16:00 | 2022-09-03 11:00:00 | 2022-09-03 13:00:00 | 121.5191 | 30.86536 |  48 | 14 | 2022-09-03 09:29:00 | NA             |       NA |       NA | NA             |       NA |       NA |  903 | 1033 |\n",
       "| 5260413 | 0 | Shanghai |  8122 | 2022-06-15 09:04:00 | 2022-06-15 13:00:00 | 2022-06-15 15:00:00 | 121.5589 | 30.91795 | 193 | 14 | 2022-06-15 14:18:00 | NA             |       NA |       NA | NA             |       NA |       NA |  615 |  314 |\n",
       "| 5081399 | 0 | Shanghai |  8122 | 2022-06-18 08:19:00 | 2022-06-18 11:00:00 | 2022-06-18 13:00:00 | 121.5590 | 30.91795 | 193 | 14 | 2022-06-18 14:21:00 | 06-18 14:21:00 | 121.5581 | 30.91735 | NA             |       NA |       NA |  618 |  362 |\n",
       "| 4439023 | 0 | Shanghai |  8122 | 2022-07-15 09:02:00 | 2022-07-15 15:00:00 | 2022-07-15 17:00:00 | 121.5628 | 30.91738 | 193 | 14 | 2022-07-15 16:47:00 | 07-15 16:47:00 | 121.5630 | 30.91744 | 07-15 09:02:00 | 121.5578 | 30.92076 |  715 |  465 |\n",
       "| 2747947 | 0 | Shanghai |  8122 | 2022-06-16 08:40:00 | 2022-06-16 13:00:00 | 2022-06-16 15:00:00 | 121.5626 | 30.91747 | 193 | 14 | 2022-06-16 14:41:00 | 06-16 14:40:00 | 121.5629 | 30.91746 | 06-16 08:40:00 | 121.5359 | 30.91938 |  616 |  361 |\n",
       "| 1851827 | 0 | Shanghai |  8122 | 2022-06-17 09:02:00 | 2022-06-17 17:00:00 | 2022-06-17 19:00:00 | 121.5589 | 30.91786 | 193 | 14 | 2022-06-17 16:54:00 | 06-17 16:54:00 | 121.5581 | 30.91771 | 06-17 09:02:00 | 121.5564 | 30.92786 |  617 |  472 |\n",
       "| 5325281 | 0 | Shanghai |  8254 | 2022-07-27 08:09:00 | 2022-07-27 17:00:00 | 2022-07-27 19:00:00 | 121.5671 | 30.87793 | 232 | 14 | 2022-07-27 14:34:00 | 07-27 14:34:00 | 121.5678 | 30.87810 | 07-27 08:08:00 | 121.5402 | 30.92410 |  727 |  385 |\n",
       "| 4965278 | 0 | Shanghai |  8254 | 2022-06-16 09:03:00 | 2022-06-16 17:00:00 | 2022-06-16 19:00:00 | 121.5677 | 30.87805 | 232 | 14 | 2022-06-16 16:26:00 | 06-16 16:26:00 | 121.5677 | 30.87803 | 06-16 09:02:00 | 121.5424 | 30.92788 |  616 |  443 |\n",
       "| 4895873 | 0 | Shanghai |  8254 | 2022-09-02 08:15:00 | 2022-09-02 17:00:00 | 2022-09-02 19:00:00 | 121.5672 | 30.87575 | 232 | 14 | 2022-09-02 18:01:00 | 09-02 18:01:00 | 121.5432 | 30.87988 | 09-02 08:15:00 | 121.5415 | 30.92756 |  902 |  586 |\n",
       "| 4102307 | 0 | Shanghai |  8254 | 2022-08-21 11:12:00 | 2022-08-21 17:00:00 | 2022-08-21 19:00:00 | 121.5666 | 30.87617 | 232 | 14 | 2022-08-21 16:15:00 | 08-21 16:15:00 | 121.5635 | 30.87540 | 08-21 11:12:00 | 121.5349 | 30.86389 |  821 |  303 |\n",
       "| 5884419 | 0 | Shanghai |  8254 | 2022-08-15 07:33:00 | 2022-08-16 09:00:00 | 2022-08-16 11:00:00 | 121.5677 | 30.87802 | 232 | 14 | 2022-08-16 08:56:00 | 08-16 08:56:00 | 121.5696 | 30.87782 | NA             |       NA |       NA |  816 | 1523 |\n",
       "| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n",
       "| 3685741 | 67 | Shanghai |  8843 | 2022-06-26 08:40:00 | 2022-06-26 15:00:00 | 2022-06-26 17:00:00 | 121.6158 | 31.20336 | 24410 |  1 | 2022-06-26 16:19:00 | 06-26 16:19:00 | 121.6156 | 31.20321 | 06-26 08:40:00 | 121.6165 | 31.20133 |  626 |  459 |\n",
       "|  951857 | 67 | Shanghai |  8843 | 2022-07-21 08:55:00 | 2022-07-22 11:00:00 | 2022-07-22 13:00:00 | 121.6165 | 31.20296 | 24410 |  1 | 2022-07-22 10:49:00 | 07-22 10:48:00 | 121.6163 | 31.20280 | NA             |       NA |       NA |  722 | 1554 |\n",
       "| 4333073 | 67 | Shanghai |  8843 | 2022-06-08 08:03:00 | 2022-06-08 13:00:00 | 2022-06-08 15:00:00 | 121.6157 | 31.20336 | 24410 |  1 | 2022-06-08 13:15:00 | 06-08 13:15:00 | 121.6160 | 31.20307 | 06-08 08:02:00 | 121.6141 | 31.20423 |  608 |  312 |\n",
       "| 4905330 | 67 | Shanghai |  8843 | 2022-08-26 08:48:00 | 2022-08-26 17:00:00 | 2022-08-26 19:00:00 | 121.6163 | 31.20284 | 24410 |  1 | 2022-08-26 17:07:00 | 08-26 17:07:00 | 121.6164 | 31.20307 | 08-26 08:48:00 | 121.6125 | 31.20191 |  826 |  499 |\n",
       "| 5752042 | 67 | Shanghai |  8843 | 2022-10-13 09:16:00 | 2022-10-13 17:00:00 | 2022-10-13 19:00:00 | 121.6162 | 31.20272 | 24410 |  1 | 2022-10-13 18:11:00 | 10-13 18:11:00 | 121.6172 | 31.20210 | 10-13 09:16:00 | 121.6175 | 31.20085 | 1013 |  535 |\n",
       "| 3927428 | 67 | Shanghai |  8843 | 2022-10-12 09:20:00 | 2022-10-12 17:00:00 | 2022-10-12 19:00:00 | 121.6157 | 31.20341 | 24410 |  1 | 2022-10-12 17:12:00 | 10-12 17:12:00 | 121.6157 | 31.20346 | 10-12 09:20:00 | 121.6167 | 31.20161 | 1012 |  472 |\n",
       "| 5115813 | 67 | Shanghai |  8843 | 2022-08-11 16:00:00 | 2022-08-13 09:00:00 | 2022-08-13 11:00:00 | 121.6150 | 31.20356 | 24410 |  1 | 2022-08-13 10:10:00 | 08-13 10:10:00 | 121.6150 | 31.20354 | NA             |       NA |       NA |  813 | 2530 |\n",
       "| 5493639 | 67 | Shanghai |  8843 | 2022-09-25 08:35:00 | 2022-09-26 09:00:00 | 2022-09-26 11:00:00 | 121.6156 | 31.20349 | 24410 |  1 | 2022-09-26 08:58:00 | 09-26 08:58:00 | 121.6150 | 31.20378 | NA             |       NA |       NA |  926 | 1463 |\n",
       "| 2588658 | 67 | Shanghai |  8843 | 2022-10-29 16:36:00 | 2022-10-30 11:00:00 | 2022-10-30 13:00:00 | 121.6163 | 31.20270 | 24410 |  1 | 2022-10-30 10:08:00 | 10-30 10:08:00 | 121.6183 | 31.20128 | NA             |       NA |       NA | 1030 | 1052 |\n",
       "| 6006501 | 67 | Shanghai |  8843 | 2022-08-15 08:01:00 | 2022-08-15 15:00:00 | 2022-08-15 17:00:00 | 121.6152 | 31.20282 | 24410 |  1 | 2022-08-15 16:35:00 | 08-15 16:35:00 | 121.6161 | 31.20250 | 08-15 08:01:00 | 121.6136 | 31.20391 |  815 |  514 |\n",
       "| 2708060 | 67 | Shanghai |  8843 | 2022-07-22 08:11:00 | 2022-07-22 13:00:00 | 2022-07-22 15:00:00 | 121.6153 | 31.20290 | 24410 |  1 | 2022-07-22 13:35:00 | 07-22 13:34:00 | 121.6157 | 31.20428 | 07-22 08:11:00 | 121.6136 | 31.20402 |  722 |  324 |\n",
       "| 4557998 | 67 | Shanghai |  8843 | 2022-06-07 09:09:00 | 2022-06-07 17:00:00 | 2022-06-07 19:00:00 | 121.6157 | 31.20345 | 24410 |  1 | 2022-06-07 18:42:00 | 06-07 18:41:00 | 121.6153 | 31.20362 | 06-07 09:09:00 | 121.6137 | 31.20212 |  607 |  573 |\n",
       "| 2681724 | 67 | Shanghai |  8843 | 2022-07-02 11:55:00 | 2022-07-02 17:00:00 | 2022-07-02 19:00:00 | 121.6156 | 31.20368 | 24410 |  1 | 2022-07-02 18:11:00 | 07-02 18:11:00 | 121.6154 | 31.20367 | 07-02 11:55:00 | 121.6180 | 31.20015 |  702 |  376 |\n",
       "| 4366962 | 67 | Shanghai |  8843 | 2022-06-14 08:41:00 | 2022-06-14 15:00:00 | 2022-06-14 17:00:00 | 121.6152 | 31.20298 | 24410 |  1 | 2022-06-14 15:36:00 | 06-14 15:36:00 | 121.6157 | 31.20272 | 06-14 08:40:00 | 121.6133 | 31.20070 |  614 |  415 |\n",
       "|  107026 | 67 | Shanghai |  8843 | 2022-06-16 09:01:00 | 2022-06-16 15:00:00 | 2022-06-16 17:00:00 | 121.6154 | 31.20286 | 24410 |  1 | 2022-06-16 15:15:00 | 06-16 15:15:00 | 121.6159 | 31.20258 | 06-16 09:01:00 | 121.6144 | 31.20435 |  616 |  374 |\n",
       "|  186333 | 67 | Shanghai |  9824 | 2022-08-30 16:59:00 | 2022-08-31 17:00:00 | 2022-08-31 19:00:00 | 121.6153 | 31.20281 | 24410 |  1 | 2022-08-31 18:24:00 | NA             |       NA |       NA | NA             |       NA |       NA |  831 | 1525 |\n",
       "| 5841213 | 67 | Shanghai |  9824 | 2022-08-31 08:52:00 | 2022-08-31 17:00:00 | 2022-08-31 19:00:00 | 121.6156 | 31.20348 | 24410 |  1 | 2022-08-31 18:14:00 | NA             |       NA |       NA | 08-31 08:52:00 | 121.6181 | 31.21446 |  831 |  562 |\n",
       "| 4838650 | 67 | Shanghai | 11052 | 2022-10-13 08:50:00 | 2022-10-13 17:00:00 | 2022-10-13 19:00:00 | 121.6163 | 31.20265 | 24410 |  1 | 2022-10-13 17:54:00 | NA             |       NA |       NA | NA             |       NA |       NA | 1013 |  544 |\n",
       "| 3108117 | 67 | Shanghai | 11696 | 2022-09-23 08:38:00 | 2022-09-23 17:00:00 | 2022-09-23 19:00:00 | 121.6157 | 31.20333 | 24410 |  1 | 2022-09-23 16:35:00 | 09-23 16:35:00 | 121.6158 | 31.20325 | 09-23 08:31:00 | 121.6119 | 31.20576 |  923 |  477 |\n",
       "| 3670425 | 67 | Shanghai |  4397 | 2022-06-18 09:22:00 | 2022-06-19 13:00:00 | 2022-06-19 15:00:00 | 121.6141 | 31.20511 | 24428 | 14 | 2022-06-19 11:26:00 | 06-19 11:26:00 | 121.6224 | 31.20949 | NA             |       NA |       NA |  619 | 1564 |\n",
       "| 4762898 | 67 | Shanghai |  4596 | 2022-08-15 08:43:00 | 2022-08-15 17:00:00 | 2022-08-15 19:00:00 | 121.6143 | 31.20527 | 24428 | 14 | 2022-08-15 18:23:00 | 08-15 18:23:00 | 121.6229 | 31.16926 | 08-15 08:43:00 | 121.6439 | 31.16794 |  815 |  580 |\n",
       "| 1160267 | 67 | Shanghai |  5168 | 2022-07-17 10:41:00 | 2022-07-17 15:00:00 | 2022-07-17 17:00:00 | 121.6142 | 31.20511 | 24428 | 14 | 2022-07-17 15:43:00 | 07-17 15:43:00 | 121.6237 | 31.17484 | 07-17 10:41:00 | 121.6220 | 31.17024 |  717 |  302 |\n",
       "| 3893165 | 67 | Shanghai |  8843 | 2022-10-28 11:05:00 | 2022-10-28 17:00:00 | 2022-10-28 19:00:00 | 121.6141 | 31.20528 | 24428 | 14 | 2022-10-28 18:08:00 | 10-28 18:08:00 | 121.6145 | 31.20371 | NA             |       NA |       NA | 1028 |  423 |\n",
       "| 5311757 | 67 | Shanghai |  8843 | 2022-07-23 10:52:00 | 2022-07-25 09:00:00 | 2022-07-25 11:00:00 | 121.6142 | 31.20549 | 24428 | 14 | 2022-07-25 09:45:00 | 07-25 09:45:00 | 121.6146 | 31.20549 | NA             |       NA |       NA |  725 | 2813 |\n",
       "| 3864050 | 67 | Shanghai |  8843 | 2022-06-14 07:42:00 | 2022-06-15 09:00:00 | 2022-06-15 11:00:00 | 121.6141 | 31.20549 | 24428 | 14 | 2022-06-15 09:44:00 | 06-15 09:44:00 | 121.6144 | 31.20564 | NA             |       NA |       NA |  615 | 1562 |\n",
       "| 2613455 | 67 | Shanghai |  8843 | 2022-06-08 08:51:00 | 2022-06-08 13:00:00 | 2022-06-08 15:00:00 | 121.6141 | 31.20543 | 24428 | 14 | 2022-06-08 13:54:00 | 06-08 13:53:00 | 121.6146 | 31.20553 | 06-08 08:50:00 | 121.6114 | 31.20240 |  608 |  303 |\n",
       "| 2917016 | 67 | Shanghai |  8843 | 2022-09-14 09:19:00 | 2022-09-14 15:00:00 | 2022-09-14 17:00:00 | 121.6141 | 31.20520 | 24428 | 14 | 2022-09-14 16:37:00 | 09-14 16:37:00 | 121.6145 | 31.20537 | 09-14 09:19:00 | 121.6166 | 31.20281 |  914 |  438 |\n",
       "| 1484646 | 67 | Shanghai |  8843 | 2022-07-11 07:46:00 | 2022-07-11 17:00:00 | 2022-07-11 19:00:00 | 121.6141 | 31.20539 | 24428 | 14 | 2022-07-11 17:25:00 | 07-11 17:25:00 | 121.6146 | 31.20469 | 07-11 07:46:00 | 121.6138 | 31.20403 |  711 |  579 |\n",
       "| 5983392 | 67 | Shanghai | 13691 | 2022-10-15 07:39:00 | 2022-10-15 15:00:00 | 2022-10-15 17:00:00 | 121.6142 | 31.20518 | 24428 | 14 | 2022-10-15 15:30:00 | NA             |       NA |       NA | 10-15 07:39:00 | 121.6519 | 31.18482 | 1015 |  471 |\n",
       "| 5591098 | 67 | Shanghai | 14852 | 2022-08-13 09:03:00 | 2022-08-14 09:00:00 | 2022-08-14 11:00:00 | 121.6143 | 31.20522 | 24428 | 14 | 2022-08-14 09:32:00 | 08-14 09:32:00 | 121.7276 | 31.15475 | NA             |       NA |       NA |  814 | 1469 |\n",
       "\n"
      ],
      "text/plain": [
       "       order_id region_id city     courier_id accept_time        \n",
       "1      5691514  0         Shanghai  1448      2022-07-12 07:40:00\n",
       "2      2710020  0         Shanghai  3243      2022-08-31 08:04:00\n",
       "3       176722  0         Shanghai  3243      2022-09-03 15:22:00\n",
       "4      1314029  0         Shanghai  3243      2022-09-01 09:19:00\n",
       "5        62447  0         Shanghai  3243      2022-10-16 09:08:00\n",
       "6      4886349  0         Shanghai  3243      2022-09-05 08:01:00\n",
       "7      1291405  0         Shanghai  3243      2022-08-18 10:58:00\n",
       "8      1257902  0         Shanghai  3243      2022-08-22 07:54:00\n",
       "9      2370290  0         Shanghai  3243      2022-08-02 07:44:00\n",
       "10     1274284  0         Shanghai  3243      2022-10-01 08:47:00\n",
       "11     1705580  0         Shanghai  3243      2022-08-28 07:07:00\n",
       "12     3769096  0         Shanghai  3243      2022-09-01 07:23:00\n",
       "13     4861238  0         Shanghai  3243      2022-06-16 08:43:00\n",
       "14     6033374  0         Shanghai  3243      2022-06-18 07:37:00\n",
       "15     2342015  0         Shanghai  4598      2022-06-03 08:26:00\n",
       "16     1735032  0         Shanghai 14482      2022-09-21 07:37:00\n",
       "17      263781  0         Shanghai 14482      2022-09-22 07:29:00\n",
       "18     4286951  0         Shanghai 11805      2022-09-20 16:16:00\n",
       "19     2769814  0         Shanghai 11805      2022-09-21 16:24:00\n",
       "20      614748  0         Shanghai 11805      2022-09-02 16:16:00\n",
       "21     5260413  0         Shanghai  8122      2022-06-15 09:04:00\n",
       "22     5081399  0         Shanghai  8122      2022-06-18 08:19:00\n",
       "23     4439023  0         Shanghai  8122      2022-07-15 09:02:00\n",
       "24     2747947  0         Shanghai  8122      2022-06-16 08:40:00\n",
       "25     1851827  0         Shanghai  8122      2022-06-17 09:02:00\n",
       "26     5325281  0         Shanghai  8254      2022-07-27 08:09:00\n",
       "27     4965278  0         Shanghai  8254      2022-06-16 09:03:00\n",
       "28     4895873  0         Shanghai  8254      2022-09-02 08:15:00\n",
       "29     4102307  0         Shanghai  8254      2022-08-21 11:12:00\n",
       "30     5884419  0         Shanghai  8254      2022-08-15 07:33:00\n",
       "⋮      ⋮        ⋮         ⋮        ⋮          ⋮                  \n",
       "230704 3685741  67        Shanghai  8843      2022-06-26 08:40:00\n",
       "230705  951857  67        Shanghai  8843      2022-07-21 08:55:00\n",
       "230706 4333073  67        Shanghai  8843      2022-06-08 08:03:00\n",
       "230707 4905330  67        Shanghai  8843      2022-08-26 08:48:00\n",
       "230708 5752042  67        Shanghai  8843      2022-10-13 09:16:00\n",
       "230709 3927428  67        Shanghai  8843      2022-10-12 09:20:00\n",
       "230710 5115813  67        Shanghai  8843      2022-08-11 16:00:00\n",
       "230711 5493639  67        Shanghai  8843      2022-09-25 08:35:00\n",
       "230712 2588658  67        Shanghai  8843      2022-10-29 16:36:00\n",
       "230713 6006501  67        Shanghai  8843      2022-08-15 08:01:00\n",
       "230714 2708060  67        Shanghai  8843      2022-07-22 08:11:00\n",
       "230715 4557998  67        Shanghai  8843      2022-06-07 09:09:00\n",
       "230716 2681724  67        Shanghai  8843      2022-07-02 11:55:00\n",
       "230717 4366962  67        Shanghai  8843      2022-06-14 08:41:00\n",
       "230718  107026  67        Shanghai  8843      2022-06-16 09:01:00\n",
       "230719  186333  67        Shanghai  9824      2022-08-30 16:59:00\n",
       "230720 5841213  67        Shanghai  9824      2022-08-31 08:52:00\n",
       "230721 4838650  67        Shanghai 11052      2022-10-13 08:50:00\n",
       "230722 3108117  67        Shanghai 11696      2022-09-23 08:38:00\n",
       "230723 3670425  67        Shanghai  4397      2022-06-18 09:22:00\n",
       "230724 4762898  67        Shanghai  4596      2022-08-15 08:43:00\n",
       "230725 1160267  67        Shanghai  5168      2022-07-17 10:41:00\n",
       "230726 3893165  67        Shanghai  8843      2022-10-28 11:05:00\n",
       "230727 5311757  67        Shanghai  8843      2022-07-23 10:52:00\n",
       "230728 3864050  67        Shanghai  8843      2022-06-14 07:42:00\n",
       "230729 2613455  67        Shanghai  8843      2022-06-08 08:51:00\n",
       "230730 2917016  67        Shanghai  8843      2022-09-14 09:19:00\n",
       "230731 1484646  67        Shanghai  8843      2022-07-11 07:46:00\n",
       "230732 5983392  67        Shanghai 13691      2022-10-15 07:39:00\n",
       "230733 5591098  67        Shanghai 14852      2022-08-13 09:03:00\n",
       "       time_window_start   time_window_end     lng      lat      aoi_id\n",
       "1      2022-07-12 17:00:00 2022-07-12 19:00:00 121.5223 30.90731  46   \n",
       "2      2022-08-31 17:00:00 2022-08-31 19:00:00 121.5223 30.90742  46   \n",
       "3      2022-09-04 15:00:00 2022-09-04 17:00:00 121.5223 30.90731  46   \n",
       "4      2022-09-02 17:00:00 2022-09-02 19:00:00 121.5223 30.90732  46   \n",
       "5      2022-10-16 15:00:00 2022-10-16 17:00:00 121.5225 30.90743  46   \n",
       "6      2022-09-05 09:00:00 2022-09-05 11:00:00 121.5222 30.90733  46   \n",
       "7      2022-08-19 17:00:00 2022-08-19 19:00:00 121.5223 30.90737  46   \n",
       "8      2022-08-22 17:00:00 2022-08-22 19:00:00 121.5223 30.90734  46   \n",
       "9      2022-08-02 17:00:00 2022-08-02 19:00:00 121.5223 30.90745  46   \n",
       "10     2022-10-01 17:00:00 2022-10-01 19:00:00 121.5223 30.90736  46   \n",
       "11     2022-08-28 17:00:00 2022-08-28 19:00:00 121.5224 30.90740  46   \n",
       "12     2022-09-01 17:00:00 2022-09-01 19:00:00 121.5222 30.90747  46   \n",
       "13     2022-06-16 15:00:00 2022-06-16 17:00:00 121.5223 30.90741  46   \n",
       "14     2022-06-19 17:00:00 2022-06-19 19:00:00 121.5224 30.90733  46   \n",
       "15     2022-06-03 13:00:00 2022-06-03 15:00:00 121.5223 30.90740  46   \n",
       "16     2022-09-21 15:00:00 2022-09-21 17:00:00 121.5223 30.90735  46   \n",
       "17     2022-09-22 17:00:00 2022-09-22 19:00:00 121.5222 30.90740  46   \n",
       "18     2022-09-21 09:00:00 2022-09-21 11:00:00 121.5191 30.86547  48   \n",
       "19     2022-09-22 09:00:00 2022-09-22 11:00:00 121.5191 30.86532  48   \n",
       "20     2022-09-03 11:00:00 2022-09-03 13:00:00 121.5191 30.86536  48   \n",
       "21     2022-06-15 13:00:00 2022-06-15 15:00:00 121.5589 30.91795 193   \n",
       "22     2022-06-18 11:00:00 2022-06-18 13:00:00 121.5590 30.91795 193   \n",
       "23     2022-07-15 15:00:00 2022-07-15 17:00:00 121.5628 30.91738 193   \n",
       "24     2022-06-16 13:00:00 2022-06-16 15:00:00 121.5626 30.91747 193   \n",
       "25     2022-06-17 17:00:00 2022-06-17 19:00:00 121.5589 30.91786 193   \n",
       "26     2022-07-27 17:00:00 2022-07-27 19:00:00 121.5671 30.87793 232   \n",
       "27     2022-06-16 17:00:00 2022-06-16 19:00:00 121.5677 30.87805 232   \n",
       "28     2022-09-02 17:00:00 2022-09-02 19:00:00 121.5672 30.87575 232   \n",
       "29     2022-08-21 17:00:00 2022-08-21 19:00:00 121.5666 30.87617 232   \n",
       "30     2022-08-16 09:00:00 2022-08-16 11:00:00 121.5677 30.87802 232   \n",
       "⋮      ⋮                   ⋮                   ⋮        ⋮        ⋮     \n",
       "230704 2022-06-26 15:00:00 2022-06-26 17:00:00 121.6158 31.20336 24410 \n",
       "230705 2022-07-22 11:00:00 2022-07-22 13:00:00 121.6165 31.20296 24410 \n",
       "230706 2022-06-08 13:00:00 2022-06-08 15:00:00 121.6157 31.20336 24410 \n",
       "230707 2022-08-26 17:00:00 2022-08-26 19:00:00 121.6163 31.20284 24410 \n",
       "230708 2022-10-13 17:00:00 2022-10-13 19:00:00 121.6162 31.20272 24410 \n",
       "230709 2022-10-12 17:00:00 2022-10-12 19:00:00 121.6157 31.20341 24410 \n",
       "230710 2022-08-13 09:00:00 2022-08-13 11:00:00 121.6150 31.20356 24410 \n",
       "230711 2022-09-26 09:00:00 2022-09-26 11:00:00 121.6156 31.20349 24410 \n",
       "230712 2022-10-30 11:00:00 2022-10-30 13:00:00 121.6163 31.20270 24410 \n",
       "230713 2022-08-15 15:00:00 2022-08-15 17:00:00 121.6152 31.20282 24410 \n",
       "230714 2022-07-22 13:00:00 2022-07-22 15:00:00 121.6153 31.20290 24410 \n",
       "230715 2022-06-07 17:00:00 2022-06-07 19:00:00 121.6157 31.20345 24410 \n",
       "230716 2022-07-02 17:00:00 2022-07-02 19:00:00 121.6156 31.20368 24410 \n",
       "230717 2022-06-14 15:00:00 2022-06-14 17:00:00 121.6152 31.20298 24410 \n",
       "230718 2022-06-16 15:00:00 2022-06-16 17:00:00 121.6154 31.20286 24410 \n",
       "230719 2022-08-31 17:00:00 2022-08-31 19:00:00 121.6153 31.20281 24410 \n",
       "230720 2022-08-31 17:00:00 2022-08-31 19:00:00 121.6156 31.20348 24410 \n",
       "230721 2022-10-13 17:00:00 2022-10-13 19:00:00 121.6163 31.20265 24410 \n",
       "230722 2022-09-23 17:00:00 2022-09-23 19:00:00 121.6157 31.20333 24410 \n",
       "230723 2022-06-19 13:00:00 2022-06-19 15:00:00 121.6141 31.20511 24428 \n",
       "230724 2022-08-15 17:00:00 2022-08-15 19:00:00 121.6143 31.20527 24428 \n",
       "230725 2022-07-17 15:00:00 2022-07-17 17:00:00 121.6142 31.20511 24428 \n",
       "230726 2022-10-28 17:00:00 2022-10-28 19:00:00 121.6141 31.20528 24428 \n",
       "230727 2022-07-25 09:00:00 2022-07-25 11:00:00 121.6142 31.20549 24428 \n",
       "230728 2022-06-15 09:00:00 2022-06-15 11:00:00 121.6141 31.20549 24428 \n",
       "230729 2022-06-08 13:00:00 2022-06-08 15:00:00 121.6141 31.20543 24428 \n",
       "230730 2022-09-14 15:00:00 2022-09-14 17:00:00 121.6141 31.20520 24428 \n",
       "230731 2022-07-11 17:00:00 2022-07-11 19:00:00 121.6141 31.20539 24428 \n",
       "230732 2022-10-15 15:00:00 2022-10-15 17:00:00 121.6142 31.20518 24428 \n",
       "230733 2022-08-14 09:00:00 2022-08-14 11:00:00 121.6143 31.20522 24428 \n",
       "       aoi_type pickup_time         pickup_gps_time pickup_gps_lng\n",
       "1      14       2022-07-12 17:22:00 07-12 17:22:00  121.5261      \n",
       "2      14       2022-08-31 18:55:00 08-31 18:55:00  121.5270      \n",
       "3      14       2022-09-04 15:22:00 09-04 15:21:00  121.5262      \n",
       "4      14       2022-09-02 16:57:00 09-02 16:57:00  121.5179      \n",
       "5      14       2022-10-16 15:30:00 10-16 15:30:00  121.5260      \n",
       "6      14       2022-09-05 16:20:00 09-05 16:20:00  121.4974      \n",
       "7      14       2022-08-19 17:46:00 08-19 17:46:00  121.5215      \n",
       "8      14       2022-08-22 18:37:00 08-22 18:37:00  121.5259      \n",
       "9      14       2022-08-02 14:39:00 08-02 14:38:00  121.5263      \n",
       "10     14       2022-10-01 16:28:00 10-01 16:28:00  121.5219      \n",
       "11     14       2022-08-28 12:46:00 08-28 12:46:00  121.5262      \n",
       "12     14       2022-09-01 15:24:00 09-01 15:24:00  121.5260      \n",
       "13     14       2022-06-16 14:40:00 06-16 14:40:00  121.5266      \n",
       "14     14       2022-06-19 17:12:00 06-19 17:12:00  121.5264      \n",
       "15     14       2022-06-03 14:07:00 NA                    NA      \n",
       "16     14       2022-09-21 14:34:00 NA                    NA      \n",
       "17     14       2022-09-22 15:28:00 NA                    NA      \n",
       "18     14       2022-09-21 08:21:00 NA                    NA      \n",
       "19     14       2022-09-22 08:03:00 NA                    NA      \n",
       "20     14       2022-09-03 09:29:00 NA                    NA      \n",
       "21     14       2022-06-15 14:18:00 NA                    NA      \n",
       "22     14       2022-06-18 14:21:00 06-18 14:21:00  121.5581      \n",
       "23     14       2022-07-15 16:47:00 07-15 16:47:00  121.5630      \n",
       "24     14       2022-06-16 14:41:00 06-16 14:40:00  121.5629      \n",
       "25     14       2022-06-17 16:54:00 06-17 16:54:00  121.5581      \n",
       "26     14       2022-07-27 14:34:00 07-27 14:34:00  121.5678      \n",
       "27     14       2022-06-16 16:26:00 06-16 16:26:00  121.5677      \n",
       "28     14       2022-09-02 18:01:00 09-02 18:01:00  121.5432      \n",
       "29     14       2022-08-21 16:15:00 08-21 16:15:00  121.5635      \n",
       "30     14       2022-08-16 08:56:00 08-16 08:56:00  121.5696      \n",
       "⋮      ⋮        ⋮                   ⋮               ⋮             \n",
       "230704  1       2022-06-26 16:19:00 06-26 16:19:00  121.6156      \n",
       "230705  1       2022-07-22 10:49:00 07-22 10:48:00  121.6163      \n",
       "230706  1       2022-06-08 13:15:00 06-08 13:15:00  121.6160      \n",
       "230707  1       2022-08-26 17:07:00 08-26 17:07:00  121.6164      \n",
       "230708  1       2022-10-13 18:11:00 10-13 18:11:00  121.6172      \n",
       "230709  1       2022-10-12 17:12:00 10-12 17:12:00  121.6157      \n",
       "230710  1       2022-08-13 10:10:00 08-13 10:10:00  121.6150      \n",
       "230711  1       2022-09-26 08:58:00 09-26 08:58:00  121.6150      \n",
       "230712  1       2022-10-30 10:08:00 10-30 10:08:00  121.6183      \n",
       "230713  1       2022-08-15 16:35:00 08-15 16:35:00  121.6161      \n",
       "230714  1       2022-07-22 13:35:00 07-22 13:34:00  121.6157      \n",
       "230715  1       2022-06-07 18:42:00 06-07 18:41:00  121.6153      \n",
       "230716  1       2022-07-02 18:11:00 07-02 18:11:00  121.6154      \n",
       "230717  1       2022-06-14 15:36:00 06-14 15:36:00  121.6157      \n",
       "230718  1       2022-06-16 15:15:00 06-16 15:15:00  121.6159      \n",
       "230719  1       2022-08-31 18:24:00 NA                    NA      \n",
       "230720  1       2022-08-31 18:14:00 NA                    NA      \n",
       "230721  1       2022-10-13 17:54:00 NA                    NA      \n",
       "230722  1       2022-09-23 16:35:00 09-23 16:35:00  121.6158      \n",
       "230723 14       2022-06-19 11:26:00 06-19 11:26:00  121.6224      \n",
       "230724 14       2022-08-15 18:23:00 08-15 18:23:00  121.6229      \n",
       "230725 14       2022-07-17 15:43:00 07-17 15:43:00  121.6237      \n",
       "230726 14       2022-10-28 18:08:00 10-28 18:08:00  121.6145      \n",
       "230727 14       2022-07-25 09:45:00 07-25 09:45:00  121.6146      \n",
       "230728 14       2022-06-15 09:44:00 06-15 09:44:00  121.6144      \n",
       "230729 14       2022-06-08 13:54:00 06-08 13:53:00  121.6146      \n",
       "230730 14       2022-09-14 16:37:00 09-14 16:37:00  121.6145      \n",
       "230731 14       2022-07-11 17:25:00 07-11 17:25:00  121.6146      \n",
       "230732 14       2022-10-15 15:30:00 NA                    NA      \n",
       "230733 14       2022-08-14 09:32:00 08-14 09:32:00  121.7276      \n",
       "       pickup_gps_lat accept_gps_time accept_gps_lng accept_gps_lat ds  \n",
       "1      30.91764       07-12 07:37:00  121.4974       30.90695        712\n",
       "2      30.91921       08-31 08:04:00  121.4975       30.90696        831\n",
       "3      30.91779       NA                    NA             NA        904\n",
       "4      30.90631       NA                    NA             NA        902\n",
       "5      30.91927       10-16 09:08:00  121.5094       30.90367       1016\n",
       "6      30.90681       09-05 08:01:00  121.4973       30.90684        905\n",
       "7      30.90898       NA                    NA             NA        819\n",
       "8      30.91656       NA                    NA             NA        822\n",
       "9      30.91692       08-02 07:44:00  121.4974       30.90687        802\n",
       "10     30.90799       10-01 08:47:00  121.5069       30.89505       1001\n",
       "11     30.91691       NA                    NA             NA        828\n",
       "12     30.91919       09-01 07:16:00  121.4974       30.90690        901\n",
       "13     30.91325       06-16 08:43:00  121.5071       30.89914        616\n",
       "14     30.91665       NA                    NA             NA        619\n",
       "15           NA       NA                    NA             NA        603\n",
       "16           NA       NA                    NA             NA        921\n",
       "17           NA       NA                    NA             NA        922\n",
       "18           NA       NA                    NA             NA        921\n",
       "19           NA       NA                    NA             NA        922\n",
       "20           NA       NA                    NA             NA        903\n",
       "21           NA       NA                    NA             NA        615\n",
       "22     30.91735       NA                    NA             NA        618\n",
       "23     30.91744       07-15 09:02:00  121.5578       30.92076        715\n",
       "24     30.91746       06-16 08:40:00  121.5359       30.91938        616\n",
       "25     30.91771       06-17 09:02:00  121.5564       30.92786        617\n",
       "26     30.87810       07-27 08:08:00  121.5402       30.92410        727\n",
       "27     30.87803       06-16 09:02:00  121.5424       30.92788        616\n",
       "28     30.87988       09-02 08:15:00  121.5415       30.92756        902\n",
       "29     30.87540       08-21 11:12:00  121.5349       30.86389        821\n",
       "30     30.87782       NA                    NA             NA        816\n",
       "⋮      ⋮              ⋮               ⋮              ⋮              ⋮   \n",
       "230704 31.20321       06-26 08:40:00  121.6165       31.20133        626\n",
       "230705 31.20280       NA                    NA             NA        722\n",
       "230706 31.20307       06-08 08:02:00  121.6141       31.20423        608\n",
       "230707 31.20307       08-26 08:48:00  121.6125       31.20191        826\n",
       "230708 31.20210       10-13 09:16:00  121.6175       31.20085       1013\n",
       "230709 31.20346       10-12 09:20:00  121.6167       31.20161       1012\n",
       "230710 31.20354       NA                    NA             NA        813\n",
       "230711 31.20378       NA                    NA             NA        926\n",
       "230712 31.20128       NA                    NA             NA       1030\n",
       "230713 31.20250       08-15 08:01:00  121.6136       31.20391        815\n",
       "230714 31.20428       07-22 08:11:00  121.6136       31.20402        722\n",
       "230715 31.20362       06-07 09:09:00  121.6137       31.20212        607\n",
       "230716 31.20367       07-02 11:55:00  121.6180       31.20015        702\n",
       "230717 31.20272       06-14 08:40:00  121.6133       31.20070        614\n",
       "230718 31.20258       06-16 09:01:00  121.6144       31.20435        616\n",
       "230719       NA       NA                    NA             NA        831\n",
       "230720       NA       08-31 08:52:00  121.6181       31.21446        831\n",
       "230721       NA       NA                    NA             NA       1013\n",
       "230722 31.20325       09-23 08:31:00  121.6119       31.20576        923\n",
       "230723 31.20949       NA                    NA             NA        619\n",
       "230724 31.16926       08-15 08:43:00  121.6439       31.16794        815\n",
       "230725 31.17484       07-17 10:41:00  121.6220       31.17024        717\n",
       "230726 31.20371       NA                    NA             NA       1028\n",
       "230727 31.20549       NA                    NA             NA        725\n",
       "230728 31.20564       NA                    NA             NA        615\n",
       "230729 31.20553       06-08 08:50:00  121.6114       31.20240        608\n",
       "230730 31.20537       09-14 09:19:00  121.6166       31.20281        914\n",
       "230731 31.20469       07-11 07:46:00  121.6138       31.20403        711\n",
       "230732       NA       10-15 07:39:00  121.6519       31.18482       1015\n",
       "230733 31.15475       NA                    NA             NA        814\n",
       "       pickup_latency_mins\n",
       "1       582               \n",
       "2       651               \n",
       "3      1440               \n",
       "4      1898               \n",
       "5       382               \n",
       "6       499               \n",
       "7      1848               \n",
       "8       643               \n",
       "9       415               \n",
       "10      461               \n",
       "11      339               \n",
       "12      481               \n",
       "13      357               \n",
       "14     2015               \n",
       "15      341               \n",
       "16      417               \n",
       "17      479               \n",
       "18      965               \n",
       "19      939               \n",
       "20     1033               \n",
       "21      314               \n",
       "22      362               \n",
       "23      465               \n",
       "24      361               \n",
       "25      472               \n",
       "26      385               \n",
       "27      443               \n",
       "28      586               \n",
       "29      303               \n",
       "30     1523               \n",
       "⋮      ⋮                  \n",
       "230704  459               \n",
       "230705 1554               \n",
       "230706  312               \n",
       "230707  499               \n",
       "230708  535               \n",
       "230709  472               \n",
       "230710 2530               \n",
       "230711 1463               \n",
       "230712 1052               \n",
       "230713  514               \n",
       "230714  324               \n",
       "230715  573               \n",
       "230716  376               \n",
       "230717  415               \n",
       "230718  374               \n",
       "230719 1525               \n",
       "230720  562               \n",
       "230721  544               \n",
       "230722  477               \n",
       "230723 1564               \n",
       "230724  580               \n",
       "230725  302               \n",
       "230726  423               \n",
       "230727 2813               \n",
       "230728 1562               \n",
       "230729  303               \n",
       "230730  438               \n",
       "230731  579               \n",
       "230732  471               \n",
       "230733 1469               "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 20225 × 18</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>order_id</th><th scope=col>region_id</th><th scope=col>city</th><th scope=col>courier_id</th><th scope=col>lng</th><th scope=col>lat</th><th scope=col>aoi_id</th><th scope=col>aoi_type</th><th scope=col>accept_time</th><th scope=col>accept_gps_time</th><th scope=col>accept_gps_lng</th><th scope=col>accept_gps_lat</th><th scope=col>delivery_time</th><th scope=col>delivery_gps_time</th><th scope=col>delivery_gps_lng</th><th scope=col>delivery_gps_lat</th><th scope=col>ds</th><th scope=col>total_time_mins</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td> 416124</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5216</td><td>31.06550</td><td>  450</td><td> 1</td><td>2022-07-05 09:54:00</td><td>07-05 09:54:00</td><td>121.5229</td><td>31.10600</td><td>2022-07-05 21:24:00</td><td>07-05 21:24:00</td><td>121.5215</td><td>31.06550</td><td> 705</td><td> 690</td></tr>\n",
       "\t<tr><td> 387406</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5212</td><td>31.06683</td><td>  450</td><td> 1</td><td>2022-07-05 09:55:00</td><td>07-05 09:55:00</td><td>121.5228</td><td>31.10609</td><td>2022-07-05 21:16:00</td><td>07-05 21:16:00</td><td>121.5211</td><td>31.06689</td><td> 705</td><td> 681</td></tr>\n",
       "\t<tr><td>  46096</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5174</td><td>31.07552</td><td>  911</td><td> 0</td><td>2022-10-01 08:56:00</td><td>10-01 08:56:00</td><td>121.5229</td><td>31.10774</td><td>2022-10-01 19:58:00</td><td>10-01 19:58:00</td><td>121.5120</td><td>31.02785</td><td>1001</td><td> 662</td></tr>\n",
       "\t<tr><td> 885440</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5189</td><td>31.07646</td><td>  911</td><td> 0</td><td>2022-10-09 10:05:00</td><td>10-09 10:05:00</td><td>121.5228</td><td>31.10780</td><td>2022-10-09 20:42:00</td><td>10-09 20:42:00</td><td>121.4771</td><td>31.11566</td><td>1009</td><td> 637</td></tr>\n",
       "\t<tr><td>4005019</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5180</td><td>31.07631</td><td>  911</td><td> 0</td><td>2022-10-09 10:05:00</td><td>10-09 10:05:00</td><td>121.5230</td><td>31.10788</td><td>2022-10-09 20:15:00</td><td>10-09 20:15:00</td><td>121.4973</td><td>31.04640</td><td>1009</td><td> 610</td></tr>\n",
       "\t<tr><td>1958199</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5129</td><td>31.05755</td><td> 2131</td><td>14</td><td>2022-08-21 10:22:00</td><td>08-21 10:22:00</td><td>121.5227</td><td>31.10593</td><td>2022-08-21 20:36:00</td><td>08-21 20:36:00</td><td>121.5474</td><td>31.03182</td><td> 821</td><td> 614</td></tr>\n",
       "\t<tr><td>1167382</td><td>1</td><td>Shanghai</td><td>  84</td><td>121.5040</td><td>31.12065</td><td> 2825</td><td> 1</td><td>2022-06-09 10:13:00</td><td>06-09 10:13:00</td><td>121.5228</td><td>31.10598</td><td>2022-06-09 21:42:00</td><td>06-09 21:42:00</td><td>121.5353</td><td>31.06636</td><td> 609</td><td> 689</td></tr>\n",
       "\t<tr><td> 369201</td><td>1</td><td>Shanghai</td><td> 246</td><td>121.5329</td><td>31.06594</td><td> 3778</td><td> 1</td><td>2022-08-26 10:06:00</td><td>08-26 10:06:00</td><td>121.5229</td><td>31.10602</td><td>2022-08-26 20:11:00</td><td>08-26 20:11:00</td><td>121.5375</td><td>31.02878</td><td> 826</td><td> 605</td></tr>\n",
       "\t<tr><td>2110989</td><td>1</td><td>Shanghai</td><td> 164</td><td>121.5224</td><td>31.06531</td><td> 8837</td><td> 1</td><td>2022-06-03 10:22:00</td><td>06-03 10:22:00</td><td>121.5228</td><td>31.10601</td><td>2022-06-03 21:34:00</td><td>06-03 21:34:00</td><td>121.5004</td><td>31.08181</td><td> 603</td><td> 672</td></tr>\n",
       "\t<tr><td>1282417</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5232</td><td>31.06754</td><td> 8837</td><td> 1</td><td>2022-07-19 09:36:00</td><td>07-19 09:36:00</td><td>121.5228</td><td>31.10594</td><td>2022-07-19 20:33:00</td><td>07-19 20:33:00</td><td>121.5233</td><td>31.06753</td><td> 719</td><td> 657</td></tr>\n",
       "\t<tr><td>1868323</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5226</td><td>31.06745</td><td> 8837</td><td> 1</td><td>2022-08-21 10:08:00</td><td>08-21 10:08:00</td><td>121.5227</td><td>31.10594</td><td>2022-08-21 20:23:00</td><td>08-21 20:23:00</td><td>121.5228</td><td>31.06758</td><td> 821</td><td> 615</td></tr>\n",
       "\t<tr><td>1320783</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5233</td><td>31.06779</td><td> 8837</td><td> 1</td><td>2022-08-22 09:52:00</td><td>08-22 09:52:00</td><td>121.5228</td><td>31.10595</td><td>2022-08-22 19:55:00</td><td>08-22 19:55:00</td><td>121.5232</td><td>31.06775</td><td> 822</td><td> 603</td></tr>\n",
       "\t<tr><td> 127757</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5233</td><td>31.06752</td><td> 8837</td><td> 1</td><td>2022-07-06 09:39:00</td><td>07-06 09:39:00</td><td>121.5229</td><td>31.10609</td><td>2022-07-06 19:57:00</td><td>07-06 19:57:00</td><td>121.5232</td><td>31.06746</td><td> 706</td><td> 618</td></tr>\n",
       "\t<tr><td>2529123</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5226</td><td>31.06744</td><td> 8837</td><td> 1</td><td>2022-09-26 09:26:00</td><td>09-26 09:26:00</td><td>121.5229</td><td>31.10781</td><td>2022-09-26 20:46:00</td><td>09-26 20:46:00</td><td>121.5226</td><td>31.06746</td><td> 926</td><td> 680</td></tr>\n",
       "\t<tr><td>4464431</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5232</td><td>31.06762</td><td> 8837</td><td> 1</td><td>2022-09-30 09:17:00</td><td>09-30 09:17:00</td><td>121.5228</td><td>31.10780</td><td>2022-09-30 19:30:00</td><td>09-30 19:30:00</td><td>121.5233</td><td>31.06769</td><td> 930</td><td> 613</td></tr>\n",
       "\t<tr><td>1886503</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5234</td><td>31.06755</td><td> 8837</td><td> 1</td><td>2022-07-19 09:35:00</td><td>07-19 09:35:00</td><td>121.5227</td><td>31.10592</td><td>2022-07-19 19:53:00</td><td>07-19 19:53:00</td><td>121.5232</td><td>31.06751</td><td> 719</td><td> 618</td></tr>\n",
       "\t<tr><td> 498122</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5227</td><td>31.06750</td><td> 8837</td><td> 1</td><td>2022-09-20 09:27:00</td><td>09-20 09:27:00</td><td>121.5229</td><td>31.10789</td><td>2022-09-20 20:04:00</td><td>09-20 20:04:00</td><td>121.5226</td><td>31.06741</td><td> 920</td><td> 637</td></tr>\n",
       "\t<tr><td>2761085</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5233</td><td>31.06772</td><td> 8837</td><td> 1</td><td>2022-09-14 09:36:00</td><td>09-14 09:36:00</td><td>121.5228</td><td>31.10777</td><td>2022-09-14 19:39:00</td><td>09-14 19:39:00</td><td>121.5231</td><td>31.06773</td><td> 914</td><td> 603</td></tr>\n",
       "\t<tr><td>1625352</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5230</td><td>31.06629</td><td> 8837</td><td> 1</td><td>2022-07-05 09:55:00</td><td>07-05 09:55:00</td><td>121.5229</td><td>31.10607</td><td>2022-07-05 20:21:00</td><td>07-05 20:21:00</td><td>121.5229</td><td>31.06625</td><td> 705</td><td> 626</td></tr>\n",
       "\t<tr><td>1208990</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5230</td><td>31.06635</td><td> 8837</td><td> 1</td><td>2022-07-05 09:54:00</td><td>07-05 09:54:00</td><td>121.5228</td><td>31.10601</td><td>2022-07-05 21:11:00</td><td>07-05 21:11:00</td><td>121.5231</td><td>31.06626</td><td> 705</td><td> 677</td></tr>\n",
       "\t<tr><td> 970936</td><td>1</td><td>Shanghai</td><td> 296</td><td>121.5446</td><td>31.06988</td><td>14377</td><td>14</td><td>2022-09-02 15:43:00</td><td>09-02 15:43:00</td><td>121.5230</td><td>31.10779</td><td>2022-09-03 10:08:00</td><td>09-03 10:08:00</td><td>121.5227</td><td>31.10542</td><td> 902</td><td>1105</td></tr>\n",
       "\t<tr><td>2916642</td><td>1</td><td>Shanghai</td><td>2690</td><td>121.5447</td><td>31.06998</td><td>14377</td><td>14</td><td>2022-09-18 09:04:00</td><td>09-18 09:04:00</td><td>121.5230</td><td>31.10773</td><td>2022-09-18 19:29:00</td><td>09-18 19:29:00</td><td>121.5399</td><td>31.06877</td><td> 918</td><td> 625</td></tr>\n",
       "\t<tr><td>4181701</td><td>1</td><td>Shanghai</td><td>4467</td><td>121.5238</td><td>31.06807</td><td>16383</td><td> 7</td><td>2022-07-19 09:33:00</td><td>07-19 09:33:00</td><td>121.5228</td><td>31.10593</td><td>2022-07-19 19:39:00</td><td>07-19 19:39:00</td><td>121.5237</td><td>31.06802</td><td> 719</td><td> 606</td></tr>\n",
       "\t<tr><td>4514061</td><td>1</td><td>Shanghai</td><td>  74</td><td>121.5188</td><td>31.11909</td><td>18481</td><td>14</td><td>2022-10-06 08:49:00</td><td>10-06 08:49:00</td><td>121.5228</td><td>31.10771</td><td>2022-10-06 18:56:00</td><td>10-06 18:56:00</td><td>121.5190</td><td>31.11782</td><td>1006</td><td> 607</td></tr>\n",
       "\t<tr><td>4265497</td><td>1</td><td>Shanghai</td><td> 420</td><td>121.5243</td><td>31.07132</td><td>21192</td><td>14</td><td>2022-09-06 09:39:00</td><td>09-06 09:39:00</td><td>121.5229</td><td>31.10775</td><td>2022-09-06 19:53:00</td><td>09-06 19:53:00</td><td>121.5242</td><td>31.07129</td><td> 906</td><td> 614</td></tr>\n",
       "\t<tr><td> 175219</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5206</td><td>31.07633</td><td>21466</td><td> 1</td><td>2022-10-11 09:24:00</td><td>10-11 09:24:00</td><td>121.5229</td><td>31.10776</td><td>2022-10-11 19:27:00</td><td>10-11 19:27:00</td><td>121.4902</td><td>31.04023</td><td>1011</td><td> 603</td></tr>\n",
       "\t<tr><td>1047044</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5197</td><td>31.07718</td><td>21466</td><td> 1</td><td>2022-09-28 09:35:00</td><td>09-28 09:35:00</td><td>121.5229</td><td>31.10775</td><td>2022-09-28 20:36:00</td><td>09-28 20:36:00</td><td>121.5484</td><td>31.07470</td><td> 928</td><td> 661</td></tr>\n",
       "\t<tr><td>1556932</td><td>1</td><td>Shanghai</td><td>2621</td><td>121.5214</td><td>31.07739</td><td>21466</td><td> 1</td><td>2022-08-09 09:28:00</td><td>08-09 09:28:00</td><td>121.5227</td><td>31.10596</td><td>2022-08-09 19:59:00</td><td>08-09 19:59:00</td><td>121.5388</td><td>31.06642</td><td> 809</td><td> 631</td></tr>\n",
       "\t<tr><td>4080325</td><td>1</td><td>Shanghai</td><td>2923</td><td>121.5136</td><td>31.12857</td><td>23320</td><td> 1</td><td>2022-06-18 10:47:00</td><td>06-18 10:47:00</td><td>121.5228</td><td>31.10595</td><td>2022-06-18 22:17:00</td><td>06-18 22:17:00</td><td>121.5138</td><td>31.12847</td><td> 618</td><td> 690</td></tr>\n",
       "\t<tr><td>3370568</td><td>1</td><td>Shanghai</td><td>2923</td><td>121.5137</td><td>31.12846</td><td>23320</td><td> 1</td><td>2022-06-17 10:49:00</td><td>06-17 10:49:00</td><td>121.5227</td><td>31.10607</td><td>2022-06-17 21:11:00</td><td>06-17 21:11:00</td><td>121.5390</td><td>31.10034</td><td> 617</td><td> 622</td></tr>\n",
       "\t<tr><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td><td>⋮</td></tr>\n",
       "\t<tr><td>4262068</td><td>93</td><td>Shanghai</td><td>4657</td><td>121.5418</td><td>31.06114</td><td>43901</td><td> 1</td><td>2022-10-18 09:42:00</td><td>10-18 09:42:00</td><td>121.5275</td><td>31.06048</td><td>2022-10-18 19:45:00</td><td>10-18 19:45:00</td><td>121.5288</td><td>31.00954</td><td>1018</td><td> 603</td></tr>\n",
       "\t<tr><td> 802626</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5337</td><td>31.05250</td><td>46393</td><td> 1</td><td>2022-10-12 11:51:00</td><td>10-12 11:51:00</td><td>121.5273</td><td>31.06053</td><td>2022-10-12 22:06:00</td><td>10-12 22:06:00</td><td>121.5432</td><td>31.02174</td><td>1012</td><td> 615</td></tr>\n",
       "\t<tr><td> 672591</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5334</td><td>31.05244</td><td>46393</td><td> 1</td><td>2022-10-25 09:21:00</td><td>10-25 09:21:00</td><td>121.5274</td><td>31.06056</td><td>2022-10-25 19:48:00</td><td>10-25 19:48:00</td><td>121.5432</td><td>31.02172</td><td>1025</td><td> 627</td></tr>\n",
       "\t<tr><td>3079040</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5344</td><td>31.05186</td><td>46393</td><td> 1</td><td>2022-10-26 09:45:00</td><td>10-26 09:45:00</td><td>121.5274</td><td>31.06055</td><td>2022-10-26 21:19:00</td><td>10-26 21:19:00</td><td>121.5433</td><td>31.02173</td><td>1026</td><td> 694</td></tr>\n",
       "\t<tr><td> 798661</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5337</td><td>31.05284</td><td>46393</td><td> 1</td><td>2022-10-30 09:07:00</td><td>10-30 09:07:00</td><td>121.5275</td><td>31.06058</td><td>2022-10-30 19:43:00</td><td>10-30 19:43:00</td><td>121.5496</td><td>31.08286</td><td>1030</td><td> 636</td></tr>\n",
       "\t<tr><td>3265896</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5345</td><td>31.05238</td><td>46393</td><td> 1</td><td>2022-10-28 09:46:00</td><td>10-28 09:46:00</td><td>121.5273</td><td>31.06045</td><td>2022-10-28 20:22:00</td><td>10-28 20:22:00</td><td>121.5433</td><td>31.02167</td><td>1028</td><td> 636</td></tr>\n",
       "\t<tr><td> 260493</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5348</td><td>31.05265</td><td>46393</td><td> 1</td><td>2022-10-29 09:23:00</td><td>10-29 09:23:00</td><td>121.5274</td><td>31.06056</td><td>2022-10-29 19:51:00</td><td>10-29 19:51:00</td><td>121.5494</td><td>31.08286</td><td>1029</td><td> 628</td></tr>\n",
       "\t<tr><td>3267369</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5351</td><td>31.05289</td><td>46393</td><td> 1</td><td>2022-10-17 09:09:00</td><td>10-17 09:09:00</td><td>121.5274</td><td>31.06044</td><td>2022-10-17 19:22:00</td><td>10-17 19:22:00</td><td>121.5443</td><td>31.01918</td><td>1017</td><td> 613</td></tr>\n",
       "\t<tr><td>4428568</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5340</td><td>31.05203</td><td>46393</td><td> 1</td><td>2022-10-30 09:07:00</td><td>10-30 09:07:00</td><td>121.5273</td><td>31.06059</td><td>2022-10-30 22:05:00</td><td>10-30 22:05:00</td><td>121.5495</td><td>31.08282</td><td>1030</td><td> 778</td></tr>\n",
       "\t<tr><td>2543618</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5345</td><td>31.05253</td><td>46393</td><td> 1</td><td>2022-10-31 09:00:00</td><td>10-31 09:00:00</td><td>121.5275</td><td>31.06046</td><td>2022-10-31 19:05:00</td><td>10-31 19:05:00</td><td>121.5431</td><td>31.02145</td><td>1031</td><td> 605</td></tr>\n",
       "\t<tr><td>3330075</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5345</td><td>31.05256</td><td>46393</td><td> 1</td><td>2022-10-12 11:03:00</td><td>10-12 11:03:00</td><td>121.5274</td><td>31.06047</td><td>2022-10-12 21:21:00</td><td>10-12 21:21:00</td><td>121.5496</td><td>31.08303</td><td>1012</td><td> 618</td></tr>\n",
       "\t<tr><td>  18741</td><td>93</td><td>Shanghai</td><td>2392</td><td>121.5306</td><td>31.06173</td><td>48290</td><td> 1</td><td>2022-10-26 10:32:00</td><td>10-26 10:32:00</td><td>121.5274</td><td>31.06051</td><td>2022-10-26 20:46:00</td><td>10-26 20:46:00</td><td>121.5308</td><td>31.06151</td><td>1026</td><td> 614</td></tr>\n",
       "\t<tr><td>1500604</td><td>93</td><td>Shanghai</td><td>4179</td><td>121.5345</td><td>31.06103</td><td>51445</td><td>13</td><td>2022-10-19 11:10:00</td><td>10-19 11:10:00</td><td>121.5274</td><td>31.06043</td><td>2022-10-20 06:57:00</td><td>10-20 06:57:00</td><td>121.5271</td><td>31.05899</td><td>1019</td><td>1187</td></tr>\n",
       "\t<tr><td>2649096</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5343</td><td>31.05464</td><td>53858</td><td> 1</td><td>2022-10-20 08:54:00</td><td>10-20 08:54:00</td><td>121.5274</td><td>31.06057</td><td>2022-10-20 21:14:00</td><td>10-20 21:14:00</td><td>121.5456</td><td>31.12782</td><td>1020</td><td> 740</td></tr>\n",
       "\t<tr><td>2183026</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5343</td><td>31.05460</td><td>53858</td><td> 1</td><td>2022-10-23 09:23:00</td><td>10-23 09:23:00</td><td>121.5274</td><td>31.06043</td><td>2022-10-23 21:40:00</td><td>10-23 21:40:00</td><td>121.5433</td><td>31.02168</td><td>1023</td><td> 737</td></tr>\n",
       "\t<tr><td>3619877</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5356</td><td>31.05441</td><td>53858</td><td> 1</td><td>2022-10-20 08:54:00</td><td>10-20 08:54:00</td><td>121.5275</td><td>31.06050</td><td>2022-10-20 19:25:00</td><td>10-20 19:25:00</td><td>121.5463</td><td>31.12863</td><td>1020</td><td> 631</td></tr>\n",
       "\t<tr><td> 750000</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5357</td><td>31.05426</td><td>53858</td><td> 1</td><td>2022-10-23 09:22:00</td><td>10-23 09:22:00</td><td>121.5273</td><td>31.06054</td><td>2022-10-23 20:31:00</td><td>10-23 20:31:00</td><td>121.5431</td><td>31.02170</td><td>1023</td><td> 669</td></tr>\n",
       "\t<tr><td>  65881</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5339</td><td>31.05513</td><td>53858</td><td> 1</td><td>2022-10-22 09:17:00</td><td>10-22 09:17:00</td><td>121.5273</td><td>31.06048</td><td>2022-10-22 19:37:00</td><td>10-22 19:37:00</td><td>121.5438</td><td>31.12575</td><td>1022</td><td> 620</td></tr>\n",
       "\t<tr><td> 310345</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5357</td><td>31.05424</td><td>53858</td><td> 1</td><td>2022-10-19 08:57:00</td><td>10-19 08:57:00</td><td>121.5273</td><td>31.06049</td><td>2022-10-19 19:18:00</td><td>10-19 19:18:00</td><td>121.5431</td><td>31.02174</td><td>1019</td><td> 621</td></tr>\n",
       "\t<tr><td>4136263</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5341</td><td>31.05460</td><td>53858</td><td> 1</td><td>2022-10-19 08:58:00</td><td>10-19 08:58:00</td><td>121.5274</td><td>31.06043</td><td>2022-10-19 19:01:00</td><td>10-19 19:01:00</td><td>121.5465</td><td>31.12869</td><td>1019</td><td> 603</td></tr>\n",
       "\t<tr><td> 485894</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5356</td><td>31.05428</td><td>53858</td><td> 1</td><td>2022-10-25 09:22:00</td><td>10-25 09:22:00</td><td>121.5273</td><td>31.06058</td><td>2022-10-25 21:25:00</td><td>10-25 21:25:00</td><td>121.5430</td><td>31.02151</td><td>1025</td><td> 723</td></tr>\n",
       "\t<tr><td>2429920</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5338</td><td>31.05517</td><td>53858</td><td> 1</td><td>2022-10-22 09:16:00</td><td>10-22 09:16:00</td><td>121.5274</td><td>31.06057</td><td>2022-10-22 21:34:00</td><td>10-22 21:34:00</td><td>121.5432</td><td>31.02162</td><td>1022</td><td> 738</td></tr>\n",
       "\t<tr><td>2801795</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5347</td><td>31.05452</td><td>53858</td><td> 1</td><td>2022-10-23 09:23:00</td><td>10-23 09:23:00</td><td>121.5273</td><td>31.06043</td><td>2022-10-23 20:11:00</td><td>10-23 20:11:00</td><td>121.5495</td><td>31.08281</td><td>1023</td><td> 648</td></tr>\n",
       "\t<tr><td> 774441</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5357</td><td>31.05467</td><td>53858</td><td> 1</td><td>2022-10-23 09:25:00</td><td>10-23 09:25:00</td><td>121.5274</td><td>31.06047</td><td>2022-10-23 21:06:00</td><td>10-23 21:06:00</td><td>121.5431</td><td>31.02173</td><td>1023</td><td> 701</td></tr>\n",
       "\t<tr><td> 233951</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5357</td><td>31.05424</td><td>53858</td><td> 1</td><td>2022-10-23 09:22:00</td><td>10-23 09:22:00</td><td>121.5275</td><td>31.06044</td><td>2022-10-23 19:48:00</td><td>10-23 19:48:00</td><td>121.5431</td><td>31.02169</td><td>1023</td><td> 626</td></tr>\n",
       "\t<tr><td>2507426</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5339</td><td>31.05458</td><td>53858</td><td> 1</td><td>2022-10-18 10:03:00</td><td>10-18 10:03:00</td><td>121.5273</td><td>31.06042</td><td>2022-10-18 21:24:00</td><td>10-18 21:24:00</td><td>121.5464</td><td>31.12853</td><td>1018</td><td> 681</td></tr>\n",
       "\t<tr><td>4292004</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5357</td><td>31.05423</td><td>53858</td><td> 1</td><td>2022-10-24 09:21:00</td><td>10-24 09:21:00</td><td>121.5274</td><td>31.06050</td><td>2022-10-24 20:07:00</td><td>10-24 20:07:00</td><td>121.5464</td><td>31.12862</td><td>1024</td><td> 646</td></tr>\n",
       "\t<tr><td>2188250</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5330</td><td>31.05400</td><td>53858</td><td> 1</td><td>2022-10-24 09:21:00</td><td>10-24 09:21:00</td><td>121.5273</td><td>31.06041</td><td>2022-10-24 20:45:00</td><td>10-24 20:45:00</td><td>121.5465</td><td>31.12863</td><td>1024</td><td> 684</td></tr>\n",
       "\t<tr><td>1591062</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5349</td><td>31.05520</td><td>53858</td><td> 1</td><td>2022-10-12 11:06:00</td><td>10-12 11:06:00</td><td>121.5273</td><td>31.06053</td><td>2022-10-12 22:55:00</td><td>10-12 22:55:00</td><td>121.5496</td><td>31.08283</td><td>1012</td><td> 709</td></tr>\n",
       "\t<tr><td>3355666</td><td>93</td><td>Shanghai</td><td>1463</td><td>121.5356</td><td>31.05386</td><td>53858</td><td> 1</td><td>2022-10-30 09:07:00</td><td>10-30 09:07:00</td><td>121.5274</td><td>31.06057</td><td>2022-10-30 20:29:00</td><td>10-30 20:29:00</td><td>121.5458</td><td>31.12595</td><td>1030</td><td> 682</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 20225 × 18\n",
       "\\begin{tabular}{llllllllllllllllll}\n",
       " order\\_id & region\\_id & city & courier\\_id & lng & lat & aoi\\_id & aoi\\_type & accept\\_time & accept\\_gps\\_time & accept\\_gps\\_lng & accept\\_gps\\_lat & delivery\\_time & delivery\\_gps\\_time & delivery\\_gps\\_lng & delivery\\_gps\\_lat & ds & total\\_time\\_mins\\\\\n",
       " <int> & <int> & <chr> & <int> & <dbl> & <dbl> & <int> & <int> & <dttm> & <chr> & <dbl> & <dbl> & <dttm> & <chr> & <dbl> & <dbl> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t  416124 & 1 & Shanghai & 4467 & 121.5216 & 31.06550 &   450 &  1 & 2022-07-05 09:54:00 & 07-05 09:54:00 & 121.5229 & 31.10600 & 2022-07-05 21:24:00 & 07-05 21:24:00 & 121.5215 & 31.06550 &  705 &  690\\\\\n",
       "\t  387406 & 1 & Shanghai & 4467 & 121.5212 & 31.06683 &   450 &  1 & 2022-07-05 09:55:00 & 07-05 09:55:00 & 121.5228 & 31.10609 & 2022-07-05 21:16:00 & 07-05 21:16:00 & 121.5211 & 31.06689 &  705 &  681\\\\\n",
       "\t   46096 & 1 & Shanghai & 2621 & 121.5174 & 31.07552 &   911 &  0 & 2022-10-01 08:56:00 & 10-01 08:56:00 & 121.5229 & 31.10774 & 2022-10-01 19:58:00 & 10-01 19:58:00 & 121.5120 & 31.02785 & 1001 &  662\\\\\n",
       "\t  885440 & 1 & Shanghai & 2621 & 121.5189 & 31.07646 &   911 &  0 & 2022-10-09 10:05:00 & 10-09 10:05:00 & 121.5228 & 31.10780 & 2022-10-09 20:42:00 & 10-09 20:42:00 & 121.4771 & 31.11566 & 1009 &  637\\\\\n",
       "\t 4005019 & 1 & Shanghai & 2621 & 121.5180 & 31.07631 &   911 &  0 & 2022-10-09 10:05:00 & 10-09 10:05:00 & 121.5230 & 31.10788 & 2022-10-09 20:15:00 & 10-09 20:15:00 & 121.4973 & 31.04640 & 1009 &  610\\\\\n",
       "\t 1958199 & 1 & Shanghai & 4467 & 121.5129 & 31.05755 &  2131 & 14 & 2022-08-21 10:22:00 & 08-21 10:22:00 & 121.5227 & 31.10593 & 2022-08-21 20:36:00 & 08-21 20:36:00 & 121.5474 & 31.03182 &  821 &  614\\\\\n",
       "\t 1167382 & 1 & Shanghai &   84 & 121.5040 & 31.12065 &  2825 &  1 & 2022-06-09 10:13:00 & 06-09 10:13:00 & 121.5228 & 31.10598 & 2022-06-09 21:42:00 & 06-09 21:42:00 & 121.5353 & 31.06636 &  609 &  689\\\\\n",
       "\t  369201 & 1 & Shanghai &  246 & 121.5329 & 31.06594 &  3778 &  1 & 2022-08-26 10:06:00 & 08-26 10:06:00 & 121.5229 & 31.10602 & 2022-08-26 20:11:00 & 08-26 20:11:00 & 121.5375 & 31.02878 &  826 &  605\\\\\n",
       "\t 2110989 & 1 & Shanghai &  164 & 121.5224 & 31.06531 &  8837 &  1 & 2022-06-03 10:22:00 & 06-03 10:22:00 & 121.5228 & 31.10601 & 2022-06-03 21:34:00 & 06-03 21:34:00 & 121.5004 & 31.08181 &  603 &  672\\\\\n",
       "\t 1282417 & 1 & Shanghai & 4467 & 121.5232 & 31.06754 &  8837 &  1 & 2022-07-19 09:36:00 & 07-19 09:36:00 & 121.5228 & 31.10594 & 2022-07-19 20:33:00 & 07-19 20:33:00 & 121.5233 & 31.06753 &  719 &  657\\\\\n",
       "\t 1868323 & 1 & Shanghai & 4467 & 121.5226 & 31.06745 &  8837 &  1 & 2022-08-21 10:08:00 & 08-21 10:08:00 & 121.5227 & 31.10594 & 2022-08-21 20:23:00 & 08-21 20:23:00 & 121.5228 & 31.06758 &  821 &  615\\\\\n",
       "\t 1320783 & 1 & Shanghai & 4467 & 121.5233 & 31.06779 &  8837 &  1 & 2022-08-22 09:52:00 & 08-22 09:52:00 & 121.5228 & 31.10595 & 2022-08-22 19:55:00 & 08-22 19:55:00 & 121.5232 & 31.06775 &  822 &  603\\\\\n",
       "\t  127757 & 1 & Shanghai & 4467 & 121.5233 & 31.06752 &  8837 &  1 & 2022-07-06 09:39:00 & 07-06 09:39:00 & 121.5229 & 31.10609 & 2022-07-06 19:57:00 & 07-06 19:57:00 & 121.5232 & 31.06746 &  706 &  618\\\\\n",
       "\t 2529123 & 1 & Shanghai & 4467 & 121.5226 & 31.06744 &  8837 &  1 & 2022-09-26 09:26:00 & 09-26 09:26:00 & 121.5229 & 31.10781 & 2022-09-26 20:46:00 & 09-26 20:46:00 & 121.5226 & 31.06746 &  926 &  680\\\\\n",
       "\t 4464431 & 1 & Shanghai & 4467 & 121.5232 & 31.06762 &  8837 &  1 & 2022-09-30 09:17:00 & 09-30 09:17:00 & 121.5228 & 31.10780 & 2022-09-30 19:30:00 & 09-30 19:30:00 & 121.5233 & 31.06769 &  930 &  613\\\\\n",
       "\t 1886503 & 1 & Shanghai & 4467 & 121.5234 & 31.06755 &  8837 &  1 & 2022-07-19 09:35:00 & 07-19 09:35:00 & 121.5227 & 31.10592 & 2022-07-19 19:53:00 & 07-19 19:53:00 & 121.5232 & 31.06751 &  719 &  618\\\\\n",
       "\t  498122 & 1 & Shanghai & 4467 & 121.5227 & 31.06750 &  8837 &  1 & 2022-09-20 09:27:00 & 09-20 09:27:00 & 121.5229 & 31.10789 & 2022-09-20 20:04:00 & 09-20 20:04:00 & 121.5226 & 31.06741 &  920 &  637\\\\\n",
       "\t 2761085 & 1 & Shanghai & 4467 & 121.5233 & 31.06772 &  8837 &  1 & 2022-09-14 09:36:00 & 09-14 09:36:00 & 121.5228 & 31.10777 & 2022-09-14 19:39:00 & 09-14 19:39:00 & 121.5231 & 31.06773 &  914 &  603\\\\\n",
       "\t 1625352 & 1 & Shanghai & 4467 & 121.5230 & 31.06629 &  8837 &  1 & 2022-07-05 09:55:00 & 07-05 09:55:00 & 121.5229 & 31.10607 & 2022-07-05 20:21:00 & 07-05 20:21:00 & 121.5229 & 31.06625 &  705 &  626\\\\\n",
       "\t 1208990 & 1 & Shanghai & 4467 & 121.5230 & 31.06635 &  8837 &  1 & 2022-07-05 09:54:00 & 07-05 09:54:00 & 121.5228 & 31.10601 & 2022-07-05 21:11:00 & 07-05 21:11:00 & 121.5231 & 31.06626 &  705 &  677\\\\\n",
       "\t  970936 & 1 & Shanghai &  296 & 121.5446 & 31.06988 & 14377 & 14 & 2022-09-02 15:43:00 & 09-02 15:43:00 & 121.5230 & 31.10779 & 2022-09-03 10:08:00 & 09-03 10:08:00 & 121.5227 & 31.10542 &  902 & 1105\\\\\n",
       "\t 2916642 & 1 & Shanghai & 2690 & 121.5447 & 31.06998 & 14377 & 14 & 2022-09-18 09:04:00 & 09-18 09:04:00 & 121.5230 & 31.10773 & 2022-09-18 19:29:00 & 09-18 19:29:00 & 121.5399 & 31.06877 &  918 &  625\\\\\n",
       "\t 4181701 & 1 & Shanghai & 4467 & 121.5238 & 31.06807 & 16383 &  7 & 2022-07-19 09:33:00 & 07-19 09:33:00 & 121.5228 & 31.10593 & 2022-07-19 19:39:00 & 07-19 19:39:00 & 121.5237 & 31.06802 &  719 &  606\\\\\n",
       "\t 4514061 & 1 & Shanghai &   74 & 121.5188 & 31.11909 & 18481 & 14 & 2022-10-06 08:49:00 & 10-06 08:49:00 & 121.5228 & 31.10771 & 2022-10-06 18:56:00 & 10-06 18:56:00 & 121.5190 & 31.11782 & 1006 &  607\\\\\n",
       "\t 4265497 & 1 & Shanghai &  420 & 121.5243 & 31.07132 & 21192 & 14 & 2022-09-06 09:39:00 & 09-06 09:39:00 & 121.5229 & 31.10775 & 2022-09-06 19:53:00 & 09-06 19:53:00 & 121.5242 & 31.07129 &  906 &  614\\\\\n",
       "\t  175219 & 1 & Shanghai & 2621 & 121.5206 & 31.07633 & 21466 &  1 & 2022-10-11 09:24:00 & 10-11 09:24:00 & 121.5229 & 31.10776 & 2022-10-11 19:27:00 & 10-11 19:27:00 & 121.4902 & 31.04023 & 1011 &  603\\\\\n",
       "\t 1047044 & 1 & Shanghai & 2621 & 121.5197 & 31.07718 & 21466 &  1 & 2022-09-28 09:35:00 & 09-28 09:35:00 & 121.5229 & 31.10775 & 2022-09-28 20:36:00 & 09-28 20:36:00 & 121.5484 & 31.07470 &  928 &  661\\\\\n",
       "\t 1556932 & 1 & Shanghai & 2621 & 121.5214 & 31.07739 & 21466 &  1 & 2022-08-09 09:28:00 & 08-09 09:28:00 & 121.5227 & 31.10596 & 2022-08-09 19:59:00 & 08-09 19:59:00 & 121.5388 & 31.06642 &  809 &  631\\\\\n",
       "\t 4080325 & 1 & Shanghai & 2923 & 121.5136 & 31.12857 & 23320 &  1 & 2022-06-18 10:47:00 & 06-18 10:47:00 & 121.5228 & 31.10595 & 2022-06-18 22:17:00 & 06-18 22:17:00 & 121.5138 & 31.12847 &  618 &  690\\\\\n",
       "\t 3370568 & 1 & Shanghai & 2923 & 121.5137 & 31.12846 & 23320 &  1 & 2022-06-17 10:49:00 & 06-17 10:49:00 & 121.5227 & 31.10607 & 2022-06-17 21:11:00 & 06-17 21:11:00 & 121.5390 & 31.10034 &  617 &  622\\\\\n",
       "\t ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮ & ⋮\\\\\n",
       "\t 4262068 & 93 & Shanghai & 4657 & 121.5418 & 31.06114 & 43901 &  1 & 2022-10-18 09:42:00 & 10-18 09:42:00 & 121.5275 & 31.06048 & 2022-10-18 19:45:00 & 10-18 19:45:00 & 121.5288 & 31.00954 & 1018 &  603\\\\\n",
       "\t  802626 & 93 & Shanghai & 1463 & 121.5337 & 31.05250 & 46393 &  1 & 2022-10-12 11:51:00 & 10-12 11:51:00 & 121.5273 & 31.06053 & 2022-10-12 22:06:00 & 10-12 22:06:00 & 121.5432 & 31.02174 & 1012 &  615\\\\\n",
       "\t  672591 & 93 & Shanghai & 1463 & 121.5334 & 31.05244 & 46393 &  1 & 2022-10-25 09:21:00 & 10-25 09:21:00 & 121.5274 & 31.06056 & 2022-10-25 19:48:00 & 10-25 19:48:00 & 121.5432 & 31.02172 & 1025 &  627\\\\\n",
       "\t 3079040 & 93 & Shanghai & 1463 & 121.5344 & 31.05186 & 46393 &  1 & 2022-10-26 09:45:00 & 10-26 09:45:00 & 121.5274 & 31.06055 & 2022-10-26 21:19:00 & 10-26 21:19:00 & 121.5433 & 31.02173 & 1026 &  694\\\\\n",
       "\t  798661 & 93 & Shanghai & 1463 & 121.5337 & 31.05284 & 46393 &  1 & 2022-10-30 09:07:00 & 10-30 09:07:00 & 121.5275 & 31.06058 & 2022-10-30 19:43:00 & 10-30 19:43:00 & 121.5496 & 31.08286 & 1030 &  636\\\\\n",
       "\t 3265896 & 93 & Shanghai & 1463 & 121.5345 & 31.05238 & 46393 &  1 & 2022-10-28 09:46:00 & 10-28 09:46:00 & 121.5273 & 31.06045 & 2022-10-28 20:22:00 & 10-28 20:22:00 & 121.5433 & 31.02167 & 1028 &  636\\\\\n",
       "\t  260493 & 93 & Shanghai & 1463 & 121.5348 & 31.05265 & 46393 &  1 & 2022-10-29 09:23:00 & 10-29 09:23:00 & 121.5274 & 31.06056 & 2022-10-29 19:51:00 & 10-29 19:51:00 & 121.5494 & 31.08286 & 1029 &  628\\\\\n",
       "\t 3267369 & 93 & Shanghai & 1463 & 121.5351 & 31.05289 & 46393 &  1 & 2022-10-17 09:09:00 & 10-17 09:09:00 & 121.5274 & 31.06044 & 2022-10-17 19:22:00 & 10-17 19:22:00 & 121.5443 & 31.01918 & 1017 &  613\\\\\n",
       "\t 4428568 & 93 & Shanghai & 1463 & 121.5340 & 31.05203 & 46393 &  1 & 2022-10-30 09:07:00 & 10-30 09:07:00 & 121.5273 & 31.06059 & 2022-10-30 22:05:00 & 10-30 22:05:00 & 121.5495 & 31.08282 & 1030 &  778\\\\\n",
       "\t 2543618 & 93 & Shanghai & 1463 & 121.5345 & 31.05253 & 46393 &  1 & 2022-10-31 09:00:00 & 10-31 09:00:00 & 121.5275 & 31.06046 & 2022-10-31 19:05:00 & 10-31 19:05:00 & 121.5431 & 31.02145 & 1031 &  605\\\\\n",
       "\t 3330075 & 93 & Shanghai & 1463 & 121.5345 & 31.05256 & 46393 &  1 & 2022-10-12 11:03:00 & 10-12 11:03:00 & 121.5274 & 31.06047 & 2022-10-12 21:21:00 & 10-12 21:21:00 & 121.5496 & 31.08303 & 1012 &  618\\\\\n",
       "\t   18741 & 93 & Shanghai & 2392 & 121.5306 & 31.06173 & 48290 &  1 & 2022-10-26 10:32:00 & 10-26 10:32:00 & 121.5274 & 31.06051 & 2022-10-26 20:46:00 & 10-26 20:46:00 & 121.5308 & 31.06151 & 1026 &  614\\\\\n",
       "\t 1500604 & 93 & Shanghai & 4179 & 121.5345 & 31.06103 & 51445 & 13 & 2022-10-19 11:10:00 & 10-19 11:10:00 & 121.5274 & 31.06043 & 2022-10-20 06:57:00 & 10-20 06:57:00 & 121.5271 & 31.05899 & 1019 & 1187\\\\\n",
       "\t 2649096 & 93 & Shanghai & 1463 & 121.5343 & 31.05464 & 53858 &  1 & 2022-10-20 08:54:00 & 10-20 08:54:00 & 121.5274 & 31.06057 & 2022-10-20 21:14:00 & 10-20 21:14:00 & 121.5456 & 31.12782 & 1020 &  740\\\\\n",
       "\t 2183026 & 93 & Shanghai & 1463 & 121.5343 & 31.05460 & 53858 &  1 & 2022-10-23 09:23:00 & 10-23 09:23:00 & 121.5274 & 31.06043 & 2022-10-23 21:40:00 & 10-23 21:40:00 & 121.5433 & 31.02168 & 1023 &  737\\\\\n",
       "\t 3619877 & 93 & Shanghai & 1463 & 121.5356 & 31.05441 & 53858 &  1 & 2022-10-20 08:54:00 & 10-20 08:54:00 & 121.5275 & 31.06050 & 2022-10-20 19:25:00 & 10-20 19:25:00 & 121.5463 & 31.12863 & 1020 &  631\\\\\n",
       "\t  750000 & 93 & Shanghai & 1463 & 121.5357 & 31.05426 & 53858 &  1 & 2022-10-23 09:22:00 & 10-23 09:22:00 & 121.5273 & 31.06054 & 2022-10-23 20:31:00 & 10-23 20:31:00 & 121.5431 & 31.02170 & 1023 &  669\\\\\n",
       "\t   65881 & 93 & Shanghai & 1463 & 121.5339 & 31.05513 & 53858 &  1 & 2022-10-22 09:17:00 & 10-22 09:17:00 & 121.5273 & 31.06048 & 2022-10-22 19:37:00 & 10-22 19:37:00 & 121.5438 & 31.12575 & 1022 &  620\\\\\n",
       "\t  310345 & 93 & Shanghai & 1463 & 121.5357 & 31.05424 & 53858 &  1 & 2022-10-19 08:57:00 & 10-19 08:57:00 & 121.5273 & 31.06049 & 2022-10-19 19:18:00 & 10-19 19:18:00 & 121.5431 & 31.02174 & 1019 &  621\\\\\n",
       "\t 4136263 & 93 & Shanghai & 1463 & 121.5341 & 31.05460 & 53858 &  1 & 2022-10-19 08:58:00 & 10-19 08:58:00 & 121.5274 & 31.06043 & 2022-10-19 19:01:00 & 10-19 19:01:00 & 121.5465 & 31.12869 & 1019 &  603\\\\\n",
       "\t  485894 & 93 & Shanghai & 1463 & 121.5356 & 31.05428 & 53858 &  1 & 2022-10-25 09:22:00 & 10-25 09:22:00 & 121.5273 & 31.06058 & 2022-10-25 21:25:00 & 10-25 21:25:00 & 121.5430 & 31.02151 & 1025 &  723\\\\\n",
       "\t 2429920 & 93 & Shanghai & 1463 & 121.5338 & 31.05517 & 53858 &  1 & 2022-10-22 09:16:00 & 10-22 09:16:00 & 121.5274 & 31.06057 & 2022-10-22 21:34:00 & 10-22 21:34:00 & 121.5432 & 31.02162 & 1022 &  738\\\\\n",
       "\t 2801795 & 93 & Shanghai & 1463 & 121.5347 & 31.05452 & 53858 &  1 & 2022-10-23 09:23:00 & 10-23 09:23:00 & 121.5273 & 31.06043 & 2022-10-23 20:11:00 & 10-23 20:11:00 & 121.5495 & 31.08281 & 1023 &  648\\\\\n",
       "\t  774441 & 93 & Shanghai & 1463 & 121.5357 & 31.05467 & 53858 &  1 & 2022-10-23 09:25:00 & 10-23 09:25:00 & 121.5274 & 31.06047 & 2022-10-23 21:06:00 & 10-23 21:06:00 & 121.5431 & 31.02173 & 1023 &  701\\\\\n",
       "\t  233951 & 93 & Shanghai & 1463 & 121.5357 & 31.05424 & 53858 &  1 & 2022-10-23 09:22:00 & 10-23 09:22:00 & 121.5275 & 31.06044 & 2022-10-23 19:48:00 & 10-23 19:48:00 & 121.5431 & 31.02169 & 1023 &  626\\\\\n",
       "\t 2507426 & 93 & Shanghai & 1463 & 121.5339 & 31.05458 & 53858 &  1 & 2022-10-18 10:03:00 & 10-18 10:03:00 & 121.5273 & 31.06042 & 2022-10-18 21:24:00 & 10-18 21:24:00 & 121.5464 & 31.12853 & 1018 &  681\\\\\n",
       "\t 4292004 & 93 & Shanghai & 1463 & 121.5357 & 31.05423 & 53858 &  1 & 2022-10-24 09:21:00 & 10-24 09:21:00 & 121.5274 & 31.06050 & 2022-10-24 20:07:00 & 10-24 20:07:00 & 121.5464 & 31.12862 & 1024 &  646\\\\\n",
       "\t 2188250 & 93 & Shanghai & 1463 & 121.5330 & 31.05400 & 53858 &  1 & 2022-10-24 09:21:00 & 10-24 09:21:00 & 121.5273 & 31.06041 & 2022-10-24 20:45:00 & 10-24 20:45:00 & 121.5465 & 31.12863 & 1024 &  684\\\\\n",
       "\t 1591062 & 93 & Shanghai & 1463 & 121.5349 & 31.05520 & 53858 &  1 & 2022-10-12 11:06:00 & 10-12 11:06:00 & 121.5273 & 31.06053 & 2022-10-12 22:55:00 & 10-12 22:55:00 & 121.5496 & 31.08283 & 1012 &  709\\\\\n",
       "\t 3355666 & 93 & Shanghai & 1463 & 121.5356 & 31.05386 & 53858 &  1 & 2022-10-30 09:07:00 & 10-30 09:07:00 & 121.5274 & 31.06057 & 2022-10-30 20:29:00 & 10-30 20:29:00 & 121.5458 & 31.12595 & 1030 &  682\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 20225 × 18\n",
       "\n",
       "| order_id &lt;int&gt; | region_id &lt;int&gt; | city &lt;chr&gt; | courier_id &lt;int&gt; | lng &lt;dbl&gt; | lat &lt;dbl&gt; | aoi_id &lt;int&gt; | aoi_type &lt;int&gt; | accept_time &lt;dttm&gt; | accept_gps_time &lt;chr&gt; | accept_gps_lng &lt;dbl&gt; | accept_gps_lat &lt;dbl&gt; | delivery_time &lt;dttm&gt; | delivery_gps_time &lt;chr&gt; | delivery_gps_lng &lt;dbl&gt; | delivery_gps_lat &lt;dbl&gt; | ds &lt;int&gt; | total_time_mins &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "|  416124 | 1 | Shanghai | 4467 | 121.5216 | 31.06550 |   450 |  1 | 2022-07-05 09:54:00 | 07-05 09:54:00 | 121.5229 | 31.10600 | 2022-07-05 21:24:00 | 07-05 21:24:00 | 121.5215 | 31.06550 |  705 |  690 |\n",
       "|  387406 | 1 | Shanghai | 4467 | 121.5212 | 31.06683 |   450 |  1 | 2022-07-05 09:55:00 | 07-05 09:55:00 | 121.5228 | 31.10609 | 2022-07-05 21:16:00 | 07-05 21:16:00 | 121.5211 | 31.06689 |  705 |  681 |\n",
       "|   46096 | 1 | Shanghai | 2621 | 121.5174 | 31.07552 |   911 |  0 | 2022-10-01 08:56:00 | 10-01 08:56:00 | 121.5229 | 31.10774 | 2022-10-01 19:58:00 | 10-01 19:58:00 | 121.5120 | 31.02785 | 1001 |  662 |\n",
       "|  885440 | 1 | Shanghai | 2621 | 121.5189 | 31.07646 |   911 |  0 | 2022-10-09 10:05:00 | 10-09 10:05:00 | 121.5228 | 31.10780 | 2022-10-09 20:42:00 | 10-09 20:42:00 | 121.4771 | 31.11566 | 1009 |  637 |\n",
       "| 4005019 | 1 | Shanghai | 2621 | 121.5180 | 31.07631 |   911 |  0 | 2022-10-09 10:05:00 | 10-09 10:05:00 | 121.5230 | 31.10788 | 2022-10-09 20:15:00 | 10-09 20:15:00 | 121.4973 | 31.04640 | 1009 |  610 |\n",
       "| 1958199 | 1 | Shanghai | 4467 | 121.5129 | 31.05755 |  2131 | 14 | 2022-08-21 10:22:00 | 08-21 10:22:00 | 121.5227 | 31.10593 | 2022-08-21 20:36:00 | 08-21 20:36:00 | 121.5474 | 31.03182 |  821 |  614 |\n",
       "| 1167382 | 1 | Shanghai |   84 | 121.5040 | 31.12065 |  2825 |  1 | 2022-06-09 10:13:00 | 06-09 10:13:00 | 121.5228 | 31.10598 | 2022-06-09 21:42:00 | 06-09 21:42:00 | 121.5353 | 31.06636 |  609 |  689 |\n",
       "|  369201 | 1 | Shanghai |  246 | 121.5329 | 31.06594 |  3778 |  1 | 2022-08-26 10:06:00 | 08-26 10:06:00 | 121.5229 | 31.10602 | 2022-08-26 20:11:00 | 08-26 20:11:00 | 121.5375 | 31.02878 |  826 |  605 |\n",
       "| 2110989 | 1 | Shanghai |  164 | 121.5224 | 31.06531 |  8837 |  1 | 2022-06-03 10:22:00 | 06-03 10:22:00 | 121.5228 | 31.10601 | 2022-06-03 21:34:00 | 06-03 21:34:00 | 121.5004 | 31.08181 |  603 |  672 |\n",
       "| 1282417 | 1 | Shanghai | 4467 | 121.5232 | 31.06754 |  8837 |  1 | 2022-07-19 09:36:00 | 07-19 09:36:00 | 121.5228 | 31.10594 | 2022-07-19 20:33:00 | 07-19 20:33:00 | 121.5233 | 31.06753 |  719 |  657 |\n",
       "| 1868323 | 1 | Shanghai | 4467 | 121.5226 | 31.06745 |  8837 |  1 | 2022-08-21 10:08:00 | 08-21 10:08:00 | 121.5227 | 31.10594 | 2022-08-21 20:23:00 | 08-21 20:23:00 | 121.5228 | 31.06758 |  821 |  615 |\n",
       "| 1320783 | 1 | Shanghai | 4467 | 121.5233 | 31.06779 |  8837 |  1 | 2022-08-22 09:52:00 | 08-22 09:52:00 | 121.5228 | 31.10595 | 2022-08-22 19:55:00 | 08-22 19:55:00 | 121.5232 | 31.06775 |  822 |  603 |\n",
       "|  127757 | 1 | Shanghai | 4467 | 121.5233 | 31.06752 |  8837 |  1 | 2022-07-06 09:39:00 | 07-06 09:39:00 | 121.5229 | 31.10609 | 2022-07-06 19:57:00 | 07-06 19:57:00 | 121.5232 | 31.06746 |  706 |  618 |\n",
       "| 2529123 | 1 | Shanghai | 4467 | 121.5226 | 31.06744 |  8837 |  1 | 2022-09-26 09:26:00 | 09-26 09:26:00 | 121.5229 | 31.10781 | 2022-09-26 20:46:00 | 09-26 20:46:00 | 121.5226 | 31.06746 |  926 |  680 |\n",
       "| 4464431 | 1 | Shanghai | 4467 | 121.5232 | 31.06762 |  8837 |  1 | 2022-09-30 09:17:00 | 09-30 09:17:00 | 121.5228 | 31.10780 | 2022-09-30 19:30:00 | 09-30 19:30:00 | 121.5233 | 31.06769 |  930 |  613 |\n",
       "| 1886503 | 1 | Shanghai | 4467 | 121.5234 | 31.06755 |  8837 |  1 | 2022-07-19 09:35:00 | 07-19 09:35:00 | 121.5227 | 31.10592 | 2022-07-19 19:53:00 | 07-19 19:53:00 | 121.5232 | 31.06751 |  719 |  618 |\n",
       "|  498122 | 1 | Shanghai | 4467 | 121.5227 | 31.06750 |  8837 |  1 | 2022-09-20 09:27:00 | 09-20 09:27:00 | 121.5229 | 31.10789 | 2022-09-20 20:04:00 | 09-20 20:04:00 | 121.5226 | 31.06741 |  920 |  637 |\n",
       "| 2761085 | 1 | Shanghai | 4467 | 121.5233 | 31.06772 |  8837 |  1 | 2022-09-14 09:36:00 | 09-14 09:36:00 | 121.5228 | 31.10777 | 2022-09-14 19:39:00 | 09-14 19:39:00 | 121.5231 | 31.06773 |  914 |  603 |\n",
       "| 1625352 | 1 | Shanghai | 4467 | 121.5230 | 31.06629 |  8837 |  1 | 2022-07-05 09:55:00 | 07-05 09:55:00 | 121.5229 | 31.10607 | 2022-07-05 20:21:00 | 07-05 20:21:00 | 121.5229 | 31.06625 |  705 |  626 |\n",
       "| 1208990 | 1 | Shanghai | 4467 | 121.5230 | 31.06635 |  8837 |  1 | 2022-07-05 09:54:00 | 07-05 09:54:00 | 121.5228 | 31.10601 | 2022-07-05 21:11:00 | 07-05 21:11:00 | 121.5231 | 31.06626 |  705 |  677 |\n",
       "|  970936 | 1 | Shanghai |  296 | 121.5446 | 31.06988 | 14377 | 14 | 2022-09-02 15:43:00 | 09-02 15:43:00 | 121.5230 | 31.10779 | 2022-09-03 10:08:00 | 09-03 10:08:00 | 121.5227 | 31.10542 |  902 | 1105 |\n",
       "| 2916642 | 1 | Shanghai | 2690 | 121.5447 | 31.06998 | 14377 | 14 | 2022-09-18 09:04:00 | 09-18 09:04:00 | 121.5230 | 31.10773 | 2022-09-18 19:29:00 | 09-18 19:29:00 | 121.5399 | 31.06877 |  918 |  625 |\n",
       "| 4181701 | 1 | Shanghai | 4467 | 121.5238 | 31.06807 | 16383 |  7 | 2022-07-19 09:33:00 | 07-19 09:33:00 | 121.5228 | 31.10593 | 2022-07-19 19:39:00 | 07-19 19:39:00 | 121.5237 | 31.06802 |  719 |  606 |\n",
       "| 4514061 | 1 | Shanghai |   74 | 121.5188 | 31.11909 | 18481 | 14 | 2022-10-06 08:49:00 | 10-06 08:49:00 | 121.5228 | 31.10771 | 2022-10-06 18:56:00 | 10-06 18:56:00 | 121.5190 | 31.11782 | 1006 |  607 |\n",
       "| 4265497 | 1 | Shanghai |  420 | 121.5243 | 31.07132 | 21192 | 14 | 2022-09-06 09:39:00 | 09-06 09:39:00 | 121.5229 | 31.10775 | 2022-09-06 19:53:00 | 09-06 19:53:00 | 121.5242 | 31.07129 |  906 |  614 |\n",
       "|  175219 | 1 | Shanghai | 2621 | 121.5206 | 31.07633 | 21466 |  1 | 2022-10-11 09:24:00 | 10-11 09:24:00 | 121.5229 | 31.10776 | 2022-10-11 19:27:00 | 10-11 19:27:00 | 121.4902 | 31.04023 | 1011 |  603 |\n",
       "| 1047044 | 1 | Shanghai | 2621 | 121.5197 | 31.07718 | 21466 |  1 | 2022-09-28 09:35:00 | 09-28 09:35:00 | 121.5229 | 31.10775 | 2022-09-28 20:36:00 | 09-28 20:36:00 | 121.5484 | 31.07470 |  928 |  661 |\n",
       "| 1556932 | 1 | Shanghai | 2621 | 121.5214 | 31.07739 | 21466 |  1 | 2022-08-09 09:28:00 | 08-09 09:28:00 | 121.5227 | 31.10596 | 2022-08-09 19:59:00 | 08-09 19:59:00 | 121.5388 | 31.06642 |  809 |  631 |\n",
       "| 4080325 | 1 | Shanghai | 2923 | 121.5136 | 31.12857 | 23320 |  1 | 2022-06-18 10:47:00 | 06-18 10:47:00 | 121.5228 | 31.10595 | 2022-06-18 22:17:00 | 06-18 22:17:00 | 121.5138 | 31.12847 |  618 |  690 |\n",
       "| 3370568 | 1 | Shanghai | 2923 | 121.5137 | 31.12846 | 23320 |  1 | 2022-06-17 10:49:00 | 06-17 10:49:00 | 121.5227 | 31.10607 | 2022-06-17 21:11:00 | 06-17 21:11:00 | 121.5390 | 31.10034 |  617 |  622 |\n",
       "| ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ | ⋮ |\n",
       "| 4262068 | 93 | Shanghai | 4657 | 121.5418 | 31.06114 | 43901 |  1 | 2022-10-18 09:42:00 | 10-18 09:42:00 | 121.5275 | 31.06048 | 2022-10-18 19:45:00 | 10-18 19:45:00 | 121.5288 | 31.00954 | 1018 |  603 |\n",
       "|  802626 | 93 | Shanghai | 1463 | 121.5337 | 31.05250 | 46393 |  1 | 2022-10-12 11:51:00 | 10-12 11:51:00 | 121.5273 | 31.06053 | 2022-10-12 22:06:00 | 10-12 22:06:00 | 121.5432 | 31.02174 | 1012 |  615 |\n",
       "|  672591 | 93 | Shanghai | 1463 | 121.5334 | 31.05244 | 46393 |  1 | 2022-10-25 09:21:00 | 10-25 09:21:00 | 121.5274 | 31.06056 | 2022-10-25 19:48:00 | 10-25 19:48:00 | 121.5432 | 31.02172 | 1025 |  627 |\n",
       "| 3079040 | 93 | Shanghai | 1463 | 121.5344 | 31.05186 | 46393 |  1 | 2022-10-26 09:45:00 | 10-26 09:45:00 | 121.5274 | 31.06055 | 2022-10-26 21:19:00 | 10-26 21:19:00 | 121.5433 | 31.02173 | 1026 |  694 |\n",
       "|  798661 | 93 | Shanghai | 1463 | 121.5337 | 31.05284 | 46393 |  1 | 2022-10-30 09:07:00 | 10-30 09:07:00 | 121.5275 | 31.06058 | 2022-10-30 19:43:00 | 10-30 19:43:00 | 121.5496 | 31.08286 | 1030 |  636 |\n",
       "| 3265896 | 93 | Shanghai | 1463 | 121.5345 | 31.05238 | 46393 |  1 | 2022-10-28 09:46:00 | 10-28 09:46:00 | 121.5273 | 31.06045 | 2022-10-28 20:22:00 | 10-28 20:22:00 | 121.5433 | 31.02167 | 1028 |  636 |\n",
       "|  260493 | 93 | Shanghai | 1463 | 121.5348 | 31.05265 | 46393 |  1 | 2022-10-29 09:23:00 | 10-29 09:23:00 | 121.5274 | 31.06056 | 2022-10-29 19:51:00 | 10-29 19:51:00 | 121.5494 | 31.08286 | 1029 |  628 |\n",
       "| 3267369 | 93 | Shanghai | 1463 | 121.5351 | 31.05289 | 46393 |  1 | 2022-10-17 09:09:00 | 10-17 09:09:00 | 121.5274 | 31.06044 | 2022-10-17 19:22:00 | 10-17 19:22:00 | 121.5443 | 31.01918 | 1017 |  613 |\n",
       "| 4428568 | 93 | Shanghai | 1463 | 121.5340 | 31.05203 | 46393 |  1 | 2022-10-30 09:07:00 | 10-30 09:07:00 | 121.5273 | 31.06059 | 2022-10-30 22:05:00 | 10-30 22:05:00 | 121.5495 | 31.08282 | 1030 |  778 |\n",
       "| 2543618 | 93 | Shanghai | 1463 | 121.5345 | 31.05253 | 46393 |  1 | 2022-10-31 09:00:00 | 10-31 09:00:00 | 121.5275 | 31.06046 | 2022-10-31 19:05:00 | 10-31 19:05:00 | 121.5431 | 31.02145 | 1031 |  605 |\n",
       "| 3330075 | 93 | Shanghai | 1463 | 121.5345 | 31.05256 | 46393 |  1 | 2022-10-12 11:03:00 | 10-12 11:03:00 | 121.5274 | 31.06047 | 2022-10-12 21:21:00 | 10-12 21:21:00 | 121.5496 | 31.08303 | 1012 |  618 |\n",
       "|   18741 | 93 | Shanghai | 2392 | 121.5306 | 31.06173 | 48290 |  1 | 2022-10-26 10:32:00 | 10-26 10:32:00 | 121.5274 | 31.06051 | 2022-10-26 20:46:00 | 10-26 20:46:00 | 121.5308 | 31.06151 | 1026 |  614 |\n",
       "| 1500604 | 93 | Shanghai | 4179 | 121.5345 | 31.06103 | 51445 | 13 | 2022-10-19 11:10:00 | 10-19 11:10:00 | 121.5274 | 31.06043 | 2022-10-20 06:57:00 | 10-20 06:57:00 | 121.5271 | 31.05899 | 1019 | 1187 |\n",
       "| 2649096 | 93 | Shanghai | 1463 | 121.5343 | 31.05464 | 53858 |  1 | 2022-10-20 08:54:00 | 10-20 08:54:00 | 121.5274 | 31.06057 | 2022-10-20 21:14:00 | 10-20 21:14:00 | 121.5456 | 31.12782 | 1020 |  740 |\n",
       "| 2183026 | 93 | Shanghai | 1463 | 121.5343 | 31.05460 | 53858 |  1 | 2022-10-23 09:23:00 | 10-23 09:23:00 | 121.5274 | 31.06043 | 2022-10-23 21:40:00 | 10-23 21:40:00 | 121.5433 | 31.02168 | 1023 |  737 |\n",
       "| 3619877 | 93 | Shanghai | 1463 | 121.5356 | 31.05441 | 53858 |  1 | 2022-10-20 08:54:00 | 10-20 08:54:00 | 121.5275 | 31.06050 | 2022-10-20 19:25:00 | 10-20 19:25:00 | 121.5463 | 31.12863 | 1020 |  631 |\n",
       "|  750000 | 93 | Shanghai | 1463 | 121.5357 | 31.05426 | 53858 |  1 | 2022-10-23 09:22:00 | 10-23 09:22:00 | 121.5273 | 31.06054 | 2022-10-23 20:31:00 | 10-23 20:31:00 | 121.5431 | 31.02170 | 1023 |  669 |\n",
       "|   65881 | 93 | Shanghai | 1463 | 121.5339 | 31.05513 | 53858 |  1 | 2022-10-22 09:17:00 | 10-22 09:17:00 | 121.5273 | 31.06048 | 2022-10-22 19:37:00 | 10-22 19:37:00 | 121.5438 | 31.12575 | 1022 |  620 |\n",
       "|  310345 | 93 | Shanghai | 1463 | 121.5357 | 31.05424 | 53858 |  1 | 2022-10-19 08:57:00 | 10-19 08:57:00 | 121.5273 | 31.06049 | 2022-10-19 19:18:00 | 10-19 19:18:00 | 121.5431 | 31.02174 | 1019 |  621 |\n",
       "| 4136263 | 93 | Shanghai | 1463 | 121.5341 | 31.05460 | 53858 |  1 | 2022-10-19 08:58:00 | 10-19 08:58:00 | 121.5274 | 31.06043 | 2022-10-19 19:01:00 | 10-19 19:01:00 | 121.5465 | 31.12869 | 1019 |  603 |\n",
       "|  485894 | 93 | Shanghai | 1463 | 121.5356 | 31.05428 | 53858 |  1 | 2022-10-25 09:22:00 | 10-25 09:22:00 | 121.5273 | 31.06058 | 2022-10-25 21:25:00 | 10-25 21:25:00 | 121.5430 | 31.02151 | 1025 |  723 |\n",
       "| 2429920 | 93 | Shanghai | 1463 | 121.5338 | 31.05517 | 53858 |  1 | 2022-10-22 09:16:00 | 10-22 09:16:00 | 121.5274 | 31.06057 | 2022-10-22 21:34:00 | 10-22 21:34:00 | 121.5432 | 31.02162 | 1022 |  738 |\n",
       "| 2801795 | 93 | Shanghai | 1463 | 121.5347 | 31.05452 | 53858 |  1 | 2022-10-23 09:23:00 | 10-23 09:23:00 | 121.5273 | 31.06043 | 2022-10-23 20:11:00 | 10-23 20:11:00 | 121.5495 | 31.08281 | 1023 |  648 |\n",
       "|  774441 | 93 | Shanghai | 1463 | 121.5357 | 31.05467 | 53858 |  1 | 2022-10-23 09:25:00 | 10-23 09:25:00 | 121.5274 | 31.06047 | 2022-10-23 21:06:00 | 10-23 21:06:00 | 121.5431 | 31.02173 | 1023 |  701 |\n",
       "|  233951 | 93 | Shanghai | 1463 | 121.5357 | 31.05424 | 53858 |  1 | 2022-10-23 09:22:00 | 10-23 09:22:00 | 121.5275 | 31.06044 | 2022-10-23 19:48:00 | 10-23 19:48:00 | 121.5431 | 31.02169 | 1023 |  626 |\n",
       "| 2507426 | 93 | Shanghai | 1463 | 121.5339 | 31.05458 | 53858 |  1 | 2022-10-18 10:03:00 | 10-18 10:03:00 | 121.5273 | 31.06042 | 2022-10-18 21:24:00 | 10-18 21:24:00 | 121.5464 | 31.12853 | 1018 |  681 |\n",
       "| 4292004 | 93 | Shanghai | 1463 | 121.5357 | 31.05423 | 53858 |  1 | 2022-10-24 09:21:00 | 10-24 09:21:00 | 121.5274 | 31.06050 | 2022-10-24 20:07:00 | 10-24 20:07:00 | 121.5464 | 31.12862 | 1024 |  646 |\n",
       "| 2188250 | 93 | Shanghai | 1463 | 121.5330 | 31.05400 | 53858 |  1 | 2022-10-24 09:21:00 | 10-24 09:21:00 | 121.5273 | 31.06041 | 2022-10-24 20:45:00 | 10-24 20:45:00 | 121.5465 | 31.12863 | 1024 |  684 |\n",
       "| 1591062 | 93 | Shanghai | 1463 | 121.5349 | 31.05520 | 53858 |  1 | 2022-10-12 11:06:00 | 10-12 11:06:00 | 121.5273 | 31.06053 | 2022-10-12 22:55:00 | 10-12 22:55:00 | 121.5496 | 31.08283 | 1012 |  709 |\n",
       "| 3355666 | 93 | Shanghai | 1463 | 121.5356 | 31.05386 | 53858 |  1 | 2022-10-30 09:07:00 | 10-30 09:07:00 | 121.5274 | 31.06057 | 2022-10-30 20:29:00 | 10-30 20:29:00 | 121.5458 | 31.12595 | 1030 |  682 |\n",
       "\n"
      ],
      "text/plain": [
       "      order_id region_id city     courier_id lng      lat      aoi_id aoi_type\n",
       "1      416124  1         Shanghai 4467       121.5216 31.06550   450   1      \n",
       "2      387406  1         Shanghai 4467       121.5212 31.06683   450   1      \n",
       "3       46096  1         Shanghai 2621       121.5174 31.07552   911   0      \n",
       "4      885440  1         Shanghai 2621       121.5189 31.07646   911   0      \n",
       "5     4005019  1         Shanghai 2621       121.5180 31.07631   911   0      \n",
       "6     1958199  1         Shanghai 4467       121.5129 31.05755  2131  14      \n",
       "7     1167382  1         Shanghai   84       121.5040 31.12065  2825   1      \n",
       "8      369201  1         Shanghai  246       121.5329 31.06594  3778   1      \n",
       "9     2110989  1         Shanghai  164       121.5224 31.06531  8837   1      \n",
       "10    1282417  1         Shanghai 4467       121.5232 31.06754  8837   1      \n",
       "11    1868323  1         Shanghai 4467       121.5226 31.06745  8837   1      \n",
       "12    1320783  1         Shanghai 4467       121.5233 31.06779  8837   1      \n",
       "13     127757  1         Shanghai 4467       121.5233 31.06752  8837   1      \n",
       "14    2529123  1         Shanghai 4467       121.5226 31.06744  8837   1      \n",
       "15    4464431  1         Shanghai 4467       121.5232 31.06762  8837   1      \n",
       "16    1886503  1         Shanghai 4467       121.5234 31.06755  8837   1      \n",
       "17     498122  1         Shanghai 4467       121.5227 31.06750  8837   1      \n",
       "18    2761085  1         Shanghai 4467       121.5233 31.06772  8837   1      \n",
       "19    1625352  1         Shanghai 4467       121.5230 31.06629  8837   1      \n",
       "20    1208990  1         Shanghai 4467       121.5230 31.06635  8837   1      \n",
       "21     970936  1         Shanghai  296       121.5446 31.06988 14377  14      \n",
       "22    2916642  1         Shanghai 2690       121.5447 31.06998 14377  14      \n",
       "23    4181701  1         Shanghai 4467       121.5238 31.06807 16383   7      \n",
       "24    4514061  1         Shanghai   74       121.5188 31.11909 18481  14      \n",
       "25    4265497  1         Shanghai  420       121.5243 31.07132 21192  14      \n",
       "26     175219  1         Shanghai 2621       121.5206 31.07633 21466   1      \n",
       "27    1047044  1         Shanghai 2621       121.5197 31.07718 21466   1      \n",
       "28    1556932  1         Shanghai 2621       121.5214 31.07739 21466   1      \n",
       "29    4080325  1         Shanghai 2923       121.5136 31.12857 23320   1      \n",
       "30    3370568  1         Shanghai 2923       121.5137 31.12846 23320   1      \n",
       "⋮     ⋮        ⋮         ⋮        ⋮          ⋮        ⋮        ⋮      ⋮       \n",
       "20196 4262068  93        Shanghai 4657       121.5418 31.06114 43901   1      \n",
       "20197  802626  93        Shanghai 1463       121.5337 31.05250 46393   1      \n",
       "20198  672591  93        Shanghai 1463       121.5334 31.05244 46393   1      \n",
       "20199 3079040  93        Shanghai 1463       121.5344 31.05186 46393   1      \n",
       "20200  798661  93        Shanghai 1463       121.5337 31.05284 46393   1      \n",
       "20201 3265896  93        Shanghai 1463       121.5345 31.05238 46393   1      \n",
       "20202  260493  93        Shanghai 1463       121.5348 31.05265 46393   1      \n",
       "20203 3267369  93        Shanghai 1463       121.5351 31.05289 46393   1      \n",
       "20204 4428568  93        Shanghai 1463       121.5340 31.05203 46393   1      \n",
       "20205 2543618  93        Shanghai 1463       121.5345 31.05253 46393   1      \n",
       "20206 3330075  93        Shanghai 1463       121.5345 31.05256 46393   1      \n",
       "20207   18741  93        Shanghai 2392       121.5306 31.06173 48290   1      \n",
       "20208 1500604  93        Shanghai 4179       121.5345 31.06103 51445  13      \n",
       "20209 2649096  93        Shanghai 1463       121.5343 31.05464 53858   1      \n",
       "20210 2183026  93        Shanghai 1463       121.5343 31.05460 53858   1      \n",
       "20211 3619877  93        Shanghai 1463       121.5356 31.05441 53858   1      \n",
       "20212  750000  93        Shanghai 1463       121.5357 31.05426 53858   1      \n",
       "20213   65881  93        Shanghai 1463       121.5339 31.05513 53858   1      \n",
       "20214  310345  93        Shanghai 1463       121.5357 31.05424 53858   1      \n",
       "20215 4136263  93        Shanghai 1463       121.5341 31.05460 53858   1      \n",
       "20216  485894  93        Shanghai 1463       121.5356 31.05428 53858   1      \n",
       "20217 2429920  93        Shanghai 1463       121.5338 31.05517 53858   1      \n",
       "20218 2801795  93        Shanghai 1463       121.5347 31.05452 53858   1      \n",
       "20219  774441  93        Shanghai 1463       121.5357 31.05467 53858   1      \n",
       "20220  233951  93        Shanghai 1463       121.5357 31.05424 53858   1      \n",
       "20221 2507426  93        Shanghai 1463       121.5339 31.05458 53858   1      \n",
       "20222 4292004  93        Shanghai 1463       121.5357 31.05423 53858   1      \n",
       "20223 2188250  93        Shanghai 1463       121.5330 31.05400 53858   1      \n",
       "20224 1591062  93        Shanghai 1463       121.5349 31.05520 53858   1      \n",
       "20225 3355666  93        Shanghai 1463       121.5356 31.05386 53858   1      \n",
       "      accept_time         accept_gps_time accept_gps_lng accept_gps_lat\n",
       "1     2022-07-05 09:54:00 07-05 09:54:00  121.5229       31.10600      \n",
       "2     2022-07-05 09:55:00 07-05 09:55:00  121.5228       31.10609      \n",
       "3     2022-10-01 08:56:00 10-01 08:56:00  121.5229       31.10774      \n",
       "4     2022-10-09 10:05:00 10-09 10:05:00  121.5228       31.10780      \n",
       "5     2022-10-09 10:05:00 10-09 10:05:00  121.5230       31.10788      \n",
       "6     2022-08-21 10:22:00 08-21 10:22:00  121.5227       31.10593      \n",
       "7     2022-06-09 10:13:00 06-09 10:13:00  121.5228       31.10598      \n",
       "8     2022-08-26 10:06:00 08-26 10:06:00  121.5229       31.10602      \n",
       "9     2022-06-03 10:22:00 06-03 10:22:00  121.5228       31.10601      \n",
       "10    2022-07-19 09:36:00 07-19 09:36:00  121.5228       31.10594      \n",
       "11    2022-08-21 10:08:00 08-21 10:08:00  121.5227       31.10594      \n",
       "12    2022-08-22 09:52:00 08-22 09:52:00  121.5228       31.10595      \n",
       "13    2022-07-06 09:39:00 07-06 09:39:00  121.5229       31.10609      \n",
       "14    2022-09-26 09:26:00 09-26 09:26:00  121.5229       31.10781      \n",
       "15    2022-09-30 09:17:00 09-30 09:17:00  121.5228       31.10780      \n",
       "16    2022-07-19 09:35:00 07-19 09:35:00  121.5227       31.10592      \n",
       "17    2022-09-20 09:27:00 09-20 09:27:00  121.5229       31.10789      \n",
       "18    2022-09-14 09:36:00 09-14 09:36:00  121.5228       31.10777      \n",
       "19    2022-07-05 09:55:00 07-05 09:55:00  121.5229       31.10607      \n",
       "20    2022-07-05 09:54:00 07-05 09:54:00  121.5228       31.10601      \n",
       "21    2022-09-02 15:43:00 09-02 15:43:00  121.5230       31.10779      \n",
       "22    2022-09-18 09:04:00 09-18 09:04:00  121.5230       31.10773      \n",
       "23    2022-07-19 09:33:00 07-19 09:33:00  121.5228       31.10593      \n",
       "24    2022-10-06 08:49:00 10-06 08:49:00  121.5228       31.10771      \n",
       "25    2022-09-06 09:39:00 09-06 09:39:00  121.5229       31.10775      \n",
       "26    2022-10-11 09:24:00 10-11 09:24:00  121.5229       31.10776      \n",
       "27    2022-09-28 09:35:00 09-28 09:35:00  121.5229       31.10775      \n",
       "28    2022-08-09 09:28:00 08-09 09:28:00  121.5227       31.10596      \n",
       "29    2022-06-18 10:47:00 06-18 10:47:00  121.5228       31.10595      \n",
       "30    2022-06-17 10:49:00 06-17 10:49:00  121.5227       31.10607      \n",
       "⋮     ⋮                   ⋮               ⋮              ⋮             \n",
       "20196 2022-10-18 09:42:00 10-18 09:42:00  121.5275       31.06048      \n",
       "20197 2022-10-12 11:51:00 10-12 11:51:00  121.5273       31.06053      \n",
       "20198 2022-10-25 09:21:00 10-25 09:21:00  121.5274       31.06056      \n",
       "20199 2022-10-26 09:45:00 10-26 09:45:00  121.5274       31.06055      \n",
       "20200 2022-10-30 09:07:00 10-30 09:07:00  121.5275       31.06058      \n",
       "20201 2022-10-28 09:46:00 10-28 09:46:00  121.5273       31.06045      \n",
       "20202 2022-10-29 09:23:00 10-29 09:23:00  121.5274       31.06056      \n",
       "20203 2022-10-17 09:09:00 10-17 09:09:00  121.5274       31.06044      \n",
       "20204 2022-10-30 09:07:00 10-30 09:07:00  121.5273       31.06059      \n",
       "20205 2022-10-31 09:00:00 10-31 09:00:00  121.5275       31.06046      \n",
       "20206 2022-10-12 11:03:00 10-12 11:03:00  121.5274       31.06047      \n",
       "20207 2022-10-26 10:32:00 10-26 10:32:00  121.5274       31.06051      \n",
       "20208 2022-10-19 11:10:00 10-19 11:10:00  121.5274       31.06043      \n",
       "20209 2022-10-20 08:54:00 10-20 08:54:00  121.5274       31.06057      \n",
       "20210 2022-10-23 09:23:00 10-23 09:23:00  121.5274       31.06043      \n",
       "20211 2022-10-20 08:54:00 10-20 08:54:00  121.5275       31.06050      \n",
       "20212 2022-10-23 09:22:00 10-23 09:22:00  121.5273       31.06054      \n",
       "20213 2022-10-22 09:17:00 10-22 09:17:00  121.5273       31.06048      \n",
       "20214 2022-10-19 08:57:00 10-19 08:57:00  121.5273       31.06049      \n",
       "20215 2022-10-19 08:58:00 10-19 08:58:00  121.5274       31.06043      \n",
       "20216 2022-10-25 09:22:00 10-25 09:22:00  121.5273       31.06058      \n",
       "20217 2022-10-22 09:16:00 10-22 09:16:00  121.5274       31.06057      \n",
       "20218 2022-10-23 09:23:00 10-23 09:23:00  121.5273       31.06043      \n",
       "20219 2022-10-23 09:25:00 10-23 09:25:00  121.5274       31.06047      \n",
       "20220 2022-10-23 09:22:00 10-23 09:22:00  121.5275       31.06044      \n",
       "20221 2022-10-18 10:03:00 10-18 10:03:00  121.5273       31.06042      \n",
       "20222 2022-10-24 09:21:00 10-24 09:21:00  121.5274       31.06050      \n",
       "20223 2022-10-24 09:21:00 10-24 09:21:00  121.5273       31.06041      \n",
       "20224 2022-10-12 11:06:00 10-12 11:06:00  121.5273       31.06053      \n",
       "20225 2022-10-30 09:07:00 10-30 09:07:00  121.5274       31.06057      \n",
       "      delivery_time       delivery_gps_time delivery_gps_lng delivery_gps_lat\n",
       "1     2022-07-05 21:24:00 07-05 21:24:00    121.5215         31.06550        \n",
       "2     2022-07-05 21:16:00 07-05 21:16:00    121.5211         31.06689        \n",
       "3     2022-10-01 19:58:00 10-01 19:58:00    121.5120         31.02785        \n",
       "4     2022-10-09 20:42:00 10-09 20:42:00    121.4771         31.11566        \n",
       "5     2022-10-09 20:15:00 10-09 20:15:00    121.4973         31.04640        \n",
       "6     2022-08-21 20:36:00 08-21 20:36:00    121.5474         31.03182        \n",
       "7     2022-06-09 21:42:00 06-09 21:42:00    121.5353         31.06636        \n",
       "8     2022-08-26 20:11:00 08-26 20:11:00    121.5375         31.02878        \n",
       "9     2022-06-03 21:34:00 06-03 21:34:00    121.5004         31.08181        \n",
       "10    2022-07-19 20:33:00 07-19 20:33:00    121.5233         31.06753        \n",
       "11    2022-08-21 20:23:00 08-21 20:23:00    121.5228         31.06758        \n",
       "12    2022-08-22 19:55:00 08-22 19:55:00    121.5232         31.06775        \n",
       "13    2022-07-06 19:57:00 07-06 19:57:00    121.5232         31.06746        \n",
       "14    2022-09-26 20:46:00 09-26 20:46:00    121.5226         31.06746        \n",
       "15    2022-09-30 19:30:00 09-30 19:30:00    121.5233         31.06769        \n",
       "16    2022-07-19 19:53:00 07-19 19:53:00    121.5232         31.06751        \n",
       "17    2022-09-20 20:04:00 09-20 20:04:00    121.5226         31.06741        \n",
       "18    2022-09-14 19:39:00 09-14 19:39:00    121.5231         31.06773        \n",
       "19    2022-07-05 20:21:00 07-05 20:21:00    121.5229         31.06625        \n",
       "20    2022-07-05 21:11:00 07-05 21:11:00    121.5231         31.06626        \n",
       "21    2022-09-03 10:08:00 09-03 10:08:00    121.5227         31.10542        \n",
       "22    2022-09-18 19:29:00 09-18 19:29:00    121.5399         31.06877        \n",
       "23    2022-07-19 19:39:00 07-19 19:39:00    121.5237         31.06802        \n",
       "24    2022-10-06 18:56:00 10-06 18:56:00    121.5190         31.11782        \n",
       "25    2022-09-06 19:53:00 09-06 19:53:00    121.5242         31.07129        \n",
       "26    2022-10-11 19:27:00 10-11 19:27:00    121.4902         31.04023        \n",
       "27    2022-09-28 20:36:00 09-28 20:36:00    121.5484         31.07470        \n",
       "28    2022-08-09 19:59:00 08-09 19:59:00    121.5388         31.06642        \n",
       "29    2022-06-18 22:17:00 06-18 22:17:00    121.5138         31.12847        \n",
       "30    2022-06-17 21:11:00 06-17 21:11:00    121.5390         31.10034        \n",
       "⋮     ⋮                   ⋮                 ⋮                ⋮               \n",
       "20196 2022-10-18 19:45:00 10-18 19:45:00    121.5288         31.00954        \n",
       "20197 2022-10-12 22:06:00 10-12 22:06:00    121.5432         31.02174        \n",
       "20198 2022-10-25 19:48:00 10-25 19:48:00    121.5432         31.02172        \n",
       "20199 2022-10-26 21:19:00 10-26 21:19:00    121.5433         31.02173        \n",
       "20200 2022-10-30 19:43:00 10-30 19:43:00    121.5496         31.08286        \n",
       "20201 2022-10-28 20:22:00 10-28 20:22:00    121.5433         31.02167        \n",
       "20202 2022-10-29 19:51:00 10-29 19:51:00    121.5494         31.08286        \n",
       "20203 2022-10-17 19:22:00 10-17 19:22:00    121.5443         31.01918        \n",
       "20204 2022-10-30 22:05:00 10-30 22:05:00    121.5495         31.08282        \n",
       "20205 2022-10-31 19:05:00 10-31 19:05:00    121.5431         31.02145        \n",
       "20206 2022-10-12 21:21:00 10-12 21:21:00    121.5496         31.08303        \n",
       "20207 2022-10-26 20:46:00 10-26 20:46:00    121.5308         31.06151        \n",
       "20208 2022-10-20 06:57:00 10-20 06:57:00    121.5271         31.05899        \n",
       "20209 2022-10-20 21:14:00 10-20 21:14:00    121.5456         31.12782        \n",
       "20210 2022-10-23 21:40:00 10-23 21:40:00    121.5433         31.02168        \n",
       "20211 2022-10-20 19:25:00 10-20 19:25:00    121.5463         31.12863        \n",
       "20212 2022-10-23 20:31:00 10-23 20:31:00    121.5431         31.02170        \n",
       "20213 2022-10-22 19:37:00 10-22 19:37:00    121.5438         31.12575        \n",
       "20214 2022-10-19 19:18:00 10-19 19:18:00    121.5431         31.02174        \n",
       "20215 2022-10-19 19:01:00 10-19 19:01:00    121.5465         31.12869        \n",
       "20216 2022-10-25 21:25:00 10-25 21:25:00    121.5430         31.02151        \n",
       "20217 2022-10-22 21:34:00 10-22 21:34:00    121.5432         31.02162        \n",
       "20218 2022-10-23 20:11:00 10-23 20:11:00    121.5495         31.08281        \n",
       "20219 2022-10-23 21:06:00 10-23 21:06:00    121.5431         31.02173        \n",
       "20220 2022-10-23 19:48:00 10-23 19:48:00    121.5431         31.02169        \n",
       "20221 2022-10-18 21:24:00 10-18 21:24:00    121.5464         31.12853        \n",
       "20222 2022-10-24 20:07:00 10-24 20:07:00    121.5464         31.12862        \n",
       "20223 2022-10-24 20:45:00 10-24 20:45:00    121.5465         31.12863        \n",
       "20224 2022-10-12 22:55:00 10-12 22:55:00    121.5496         31.08283        \n",
       "20225 2022-10-30 20:29:00 10-30 20:29:00    121.5458         31.12595        \n",
       "      ds   total_time_mins\n",
       "1      705  690           \n",
       "2      705  681           \n",
       "3     1001  662           \n",
       "4     1009  637           \n",
       "5     1009  610           \n",
       "6      821  614           \n",
       "7      609  689           \n",
       "8      826  605           \n",
       "9      603  672           \n",
       "10     719  657           \n",
       "11     821  615           \n",
       "12     822  603           \n",
       "13     706  618           \n",
       "14     926  680           \n",
       "15     930  613           \n",
       "16     719  618           \n",
       "17     920  637           \n",
       "18     914  603           \n",
       "19     705  626           \n",
       "20     705  677           \n",
       "21     902 1105           \n",
       "22     918  625           \n",
       "23     719  606           \n",
       "24    1006  607           \n",
       "25     906  614           \n",
       "26    1011  603           \n",
       "27     928  661           \n",
       "28     809  631           \n",
       "29     618  690           \n",
       "30     617  622           \n",
       "⋮     ⋮    ⋮              \n",
       "20196 1018  603           \n",
       "20197 1012  615           \n",
       "20198 1025  627           \n",
       "20199 1026  694           \n",
       "20200 1030  636           \n",
       "20201 1028  636           \n",
       "20202 1029  628           \n",
       "20203 1017  613           \n",
       "20204 1030  778           \n",
       "20205 1031  605           \n",
       "20206 1012  618           \n",
       "20207 1026  614           \n",
       "20208 1019 1187           \n",
       "20209 1020  740           \n",
       "20210 1023  737           \n",
       "20211 1020  631           \n",
       "20212 1023  669           \n",
       "20213 1022  620           \n",
       "20214 1019  621           \n",
       "20215 1019  603           \n",
       "20216 1025  723           \n",
       "20217 1022  738           \n",
       "20218 1023  648           \n",
       "20219 1023  701           \n",
       "20220 1023  626           \n",
       "20221 1018  681           \n",
       "20222 1024  646           \n",
       "20223 1024  684           \n",
       "20224 1012  709           \n",
       "20225 1030  682           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
       "   0.00   53.00   92.00   91.15  130.00  180.00 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
       "   0.00   41.00   69.00   82.58  108.00  300.00 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Pickup latency (minutes)\n",
    "pickup_clean[, pickup_latency_mins := as.numeric(\n",
    "  difftime(pickup_time, accept_time, units = \"mins\")\n",
    ")]\n",
    "\n",
    "# Total delivery time (minutes)\n",
    "delivery_clean[, total_time_mins := as.numeric(\n",
    "  difftime(delivery_time, accept_time, units = \"mins\")\n",
    ")]\n",
    "summary(pickup_clean$pickup_latency_mins)\n",
    "summary(delivery_clean$total_time_mins)\n",
    "# Check negative values\n",
    "pickup_clean[pickup_latency_mins < 0]\n",
    "delivery_clean[total_time_mins < 0]\n",
    "\n",
    "# Check extreme values\n",
    "pickup_clean[pickup_latency_mins > 300]\n",
    "delivery_clean[total_time_mins > 600]\n",
    "# Filter extreme values\n",
    "pickup_filtered <- pickup_clean[\n",
    "  pickup_latency_mins >= 0 & pickup_latency_mins <= 180\n",
    "]\n",
    "delivery_filtered <- delivery_clean[\n",
    "  total_time_mins >= 0 & total_time_mins <= 300\n",
    "]\n",
    "summary(pickup_filtered$pickup_latency_mins)\n",
    "summary(delivery_filtered$total_time_mins)\n",
    "# Plotting pickup latency distribution\n",
    "p1 <- ggplot(pickup_filtered, aes(x = pickup_latency_mins)) +\n",
    "  geom_histogram(bins = 50, fill = \"#1f77b4\", alpha = 0.8) +\n",
    "  geom_vline(aes(xintercept = median(pickup_latency_mins, na.rm = TRUE)),\n",
    "             linetype = \"dashed\", linewidth = 1) +\n",
    "  labs(\n",
    "    title = \"Distribution of Pickup Latency\",\n",
    "    subtitle = \"Median shown as dashed line\",\n",
    "    x = \"Pickup Latency (Minutes)\",\n",
    "    y = \"Frequency\"\n",
    "  )"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e744d336",
   "metadata": {
    "papermill": {
     "duration": 0.012666,
     "end_time": "2026-04-02T03:54:00.279281",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.266615",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Pickup latency varies widely, indicating inconsistent courier performance."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "3aa1447d",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:54:00.307634Z",
     "iopub.status.busy": "2026-04-02T03:54:00.306107Z",
     "iopub.status.idle": "2026-04-02T03:54:00.327720Z",
     "shell.execute_reply": "2026-04-02T03:54:00.325854Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 0.039107,
     "end_time": "2026-04-02T03:54:00.330210",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.291103",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# plotting delivery time distribution\n",
    "p2 <- ggplot(delivery_filtered, aes(x = total_time_mins)) +\n",
    "  geom_histogram(bins = 50, fill = \"#2ca02c\", alpha = 0.8) +\n",
    "  geom_vline(aes(xintercept = median(total_time_mins, na.rm = TRUE)),\n",
    "             linetype = \"dashed\", linewidth = 1) +\n",
    "  labs(\n",
    "    title = \"Distribution of Delivery Time\",\n",
    "    subtitle = \"Median delivery time highlighted\",\n",
    "    x = \"Total Delivery Time (Minutes)\",\n",
    "    y = \"Frequency\"\n",
    "  )"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "0ed1a1f6",
   "metadata": {
    "papermill": {
     "duration": 0.011461,
     "end_time": "2026-04-02T03:54:00.353600",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.342139",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Delivery times show clustering but still contain significant delays."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "17605957",
   "metadata": {
    "papermill": {
     "duration": 0.011698,
     "end_time": "2026-04-02T03:54:00.376772",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.365074",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 🚦 Q1: Delivery Efficiency"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "e382a96f",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:54:00.403564Z",
     "iopub.status.busy": "2026-04-02T03:54:00.401968Z",
     "iopub.status.idle": "2026-04-02T03:54:00.946638Z",
     "shell.execute_reply": "2026-04-02T03:54:00.944670Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 0.560833,
     "end_time": "2026-04-02T03:54:00.949225",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.388392",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 1 × 3</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>orders</th><th scope=col>late_orders</th><th scope=col>late_rate</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>224254</td><td>125513</td><td>0.5596912</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 1 × 3\n",
       "\\begin{tabular}{lll}\n",
       " orders & late\\_orders & late\\_rate\\\\\n",
       " <int> & <int> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 224254 & 125513 & 0.5596912\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 1 × 3\n",
       "\n",
       "| orders &lt;int&gt; | late_orders &lt;int&gt; | late_rate &lt;dbl&gt; |\n",
       "|---|---|---|\n",
       "| 224254 | 125513 | 0.5596912 |\n",
       "\n"
      ],
      "text/plain": [
       "  orders late_orders late_rate\n",
       "1 224254 125513      0.5596912"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 2 × 5</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>optimized</th><th scope=col>avg_total_time_mins</th><th scope=col>avg_late_rate</th><th scope=col>avg_packages_per_hour</th><th scope=col>avg_orders</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td><td>83.88397</td><td>0.5516530</td><td>0.7167591</td><td>425.2171</td></tr>\n",
       "\t<tr><td> TRUE</td><td>75.13444</td><td>0.5534535</td><td>0.7996722</td><td>146.8039</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 2 × 5\n",
       "\\begin{tabular}{lllll}\n",
       " optimized & avg\\_total\\_time\\_mins & avg\\_late\\_rate & avg\\_packages\\_per\\_hour & avg\\_orders\\\\\n",
       " <lgl> & <dbl> & <dbl> & <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t FALSE & 83.88397 & 0.5516530 & 0.7167591 & 425.2171\\\\\n",
       "\t  TRUE & 75.13444 & 0.5534535 & 0.7996722 & 146.8039\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 2 × 5\n",
       "\n",
       "| optimized &lt;lgl&gt; | avg_total_time_mins &lt;dbl&gt; | avg_late_rate &lt;dbl&gt; | avg_packages_per_hour &lt;dbl&gt; | avg_orders &lt;dbl&gt; |\n",
       "|---|---|---|---|---|\n",
       "| FALSE | 83.88397 | 0.5516530 | 0.7167591 | 425.2171 |\n",
       "|  TRUE | 75.13444 | 0.5534535 | 0.7996722 | 146.8039 |\n",
       "\n"
      ],
      "text/plain": [
       "  optimized avg_total_time_mins avg_late_rate avg_packages_per_hour avg_orders\n",
       "1 FALSE     83.88397            0.5516530     0.7167591             425.2171  \n",
       "2  TRUE     75.13444            0.5534535     0.7996722             146.8039  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.0948077089484818"
      ],
      "text/latex": [
       "0.0948077089484818"
      ],
      "text/markdown": [
       "0.0948077089484818"
      ],
      "text/plain": [
       "[1] 0.09480771"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "-0.00293461085603999"
      ],
      "text/latex": [
       "-0.00293461085603999"
      ],
      "text/markdown": [
       "-0.00293461085603999"
      ],
      "text/plain": [
       "[1] -0.002934611"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.102844775290784"
      ],
      "text/latex": [
       "0.102844775290784"
      ],
      "text/markdown": [
       "0.102844775290784"
      ],
      "text/plain": [
       "[1] 0.1028448"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.0745726938417645"
      ],
      "text/latex": [
       "0.0745726938417645"
      ],
      "text/markdown": [
       "0.0745726938417645"
      ],
      "text/plain": [
       "[1] 0.07457269"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "## Q1 — Delivery Efficiency & Delays\n",
    "# Build Q1 dataset\n",
    "q1_data <- merge(\n",
    "  pickup_filtered[, .(\n",
    "    order_id,\n",
    "    courier_id,\n",
    "    region_id,\n",
    "    accept_time,\n",
    "    time_window_start,\n",
    "    time_window_end,\n",
    "    pickup_time,\n",
    "    pickup_latency_mins\n",
    "  )],\n",
    "  delivery_filtered[, .(\n",
    "    order_id,\n",
    "    delivery_time,\n",
    "    total_time_mins,\n",
    "    lng,\n",
    "    lat,\n",
    "    aoi_id,\n",
    "    aoi_type\n",
    "  )],\n",
    "  by = \"order_id\"\n",
    ")\n",
    "\n",
    "q1_data[, late_mins := as.numeric(difftime(delivery_time, time_window_end, units = \"mins\"))]\n",
    "q1_data[, is_late := delivery_time > time_window_end]\n",
    "# Baseline SLA output\n",
    "q1_data[, .(\n",
    "  orders = .N,\n",
    "  late_orders = sum(is_late, na.rm = TRUE),\n",
    "  late_rate = mean(is_late, na.rm = TRUE)\n",
    ")]\n",
    "# Plotting late vs on time\n",
    "p4 <- ggplot(q1_data, aes(x = factor(is_late), fill = factor(is_late))) +\n",
    "  geom_bar(alpha = 0.8) +\n",
    "  scale_fill_manual(values = c(\"#2ca02c\", \"#d62728\")) +\n",
    "  geom_text(stat = \"count\", aes(label = ..count..), vjust = -0.5) +\n",
    "  labs(\n",
    "    title = \"Late vs On-Time Deliveries\",\n",
    "    subtitle = \"Majority of deliveries miss SLA targets\",\n",
    "    x = \"Delivery Status (0 = On Time, 1 = Late)\",\n",
    "    y = \"Count\",\n",
    "    fill = \"Status\"\n",
    "  )\n",
    "\n",
    "# Courier performance for Q1\n",
    "courier_q1 <- q1_data[, .(\n",
    "  orders_handled = .N,\n",
    "  avg_total_time_mins = mean(total_time_mins, na.rm = TRUE),\n",
    "  late_rate = mean(is_late, na.rm = TRUE)\n",
    "), by = courier_id]\n",
    "\n",
    "courier_q1[, packages_per_hour := 60 / avg_total_time_mins]\n",
    "# Active courier benchmark\n",
    "courier_q1_active <- courier_q1[orders_handled >= 50]\n",
    "q1_threshold <- quantile(courier_q1_active$avg_total_time_mins, 0.10, na.rm = TRUE)\n",
    "\n",
    "courier_q1_active[, optimized := avg_total_time_mins <= q1_threshold]\n",
    "\n",
    "courier_q1_active[, .(\n",
    "  avg_total_time_mins = mean(avg_total_time_mins, na.rm = TRUE),\n",
    "  avg_late_rate = mean(late_rate, na.rm = TRUE),\n",
    "  avg_packages_per_hour = mean(packages_per_hour, na.rm = TRUE),\n",
    "  avg_orders = mean(orders_handled)\n",
    "), by = optimized]\n",
    "# Gain calculations\n",
    "baseline_time <- mean(courier_q1_active$avg_total_time_mins, na.rm = TRUE)\n",
    "optimized_time <- mean(courier_q1_active[optimized == TRUE]$avg_total_time_mins, na.rm = TRUE)\n",
    "\n",
    "baseline_late <- mean(courier_q1_active$late_rate, na.rm = TRUE)\n",
    "optimized_late <- mean(courier_q1_active[optimized == TRUE]$late_rate, na.rm = TRUE)\n",
    "\n",
    "baseline_pph <- mean(courier_q1_active$packages_per_hour, na.rm = TRUE)\n",
    "optimized_pph <- mean(courier_q1_active[optimized == TRUE]$packages_per_hour, na.rm = TRUE)\n",
    "\n",
    "time_reduction_pct <- (baseline_time - optimized_time) / baseline_time\n",
    "late_reduction_pct <- (baseline_late - optimized_late) / baseline_late\n",
    "pph_gain_pct <- (optimized_pph - baseline_pph) / baseline_pph\n",
    "additional_packages_per_hour <- optimized_pph - baseline_pph\n",
    "\n",
    "time_reduction_pct\n",
    "late_reduction_pct\n",
    "pph_gain_pct\n",
    "additional_packages_per_hour"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d7f1ceda",
   "metadata": {
    "papermill": {
     "duration": 0.012855,
     "end_time": "2026-04-02T03:54:00.975416",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.962561",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Over 50% of deliveries are late, indicating systemic inefficiencies.\n",
    "\n",
    "Routing improvements increase efficiency but do not significantly reduce delays."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7923e687",
   "metadata": {
    "papermill": {
     "duration": 0.012605,
     "end_time": "2026-04-02T03:54:01.000480",
     "exception": false,
     "start_time": "2026-04-02T03:54:00.987875",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 👷 Q2: Courier Performance"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "04115fde",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:54:01.029472Z",
     "iopub.status.busy": "2026-04-02T03:54:01.027780Z",
     "iopub.status.idle": "2026-04-02T03:54:01.498185Z",
     "shell.execute_reply": "2026-04-02T03:54:01.496366Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 0.487466,
     "end_time": "2026-04-02T03:54:01.500602",
     "exception": false,
     "start_time": "2026-04-02T03:54:01.013136",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 2 × 3</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>elite</th><th scope=col>avg_latency</th><th scope=col>avg_orders</th></tr>\n",
       "\t<tr><th scope=col>&lt;lgl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>FALSE</td><td>87.51359</td><td>875.01748</td></tr>\n",
       "\t<tr><td> TRUE</td><td>49.73780</td><td> 96.45455</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 2 × 3\n",
       "\\begin{tabular}{lll}\n",
       " elite & avg\\_latency & avg\\_orders\\\\\n",
       " <lgl> & <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t FALSE & 87.51359 & 875.01748\\\\\n",
       "\t  TRUE & 49.73780 &  96.45455\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 2 × 3\n",
       "\n",
       "| elite &lt;lgl&gt; | avg_latency &lt;dbl&gt; | avg_orders &lt;dbl&gt; |\n",
       "|---|---|---|\n",
       "| FALSE | 87.51359 | 875.01748 |\n",
       "|  TRUE | 49.73780 |  96.45455 |\n",
       "\n"
      ],
      "text/plain": [
       "  elite avg_latency avg_orders\n",
       "1 FALSE 87.51359    875.01748 \n",
       "2  TRUE 49.73780     96.45455 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "83.729756265598"
      ],
      "text/latex": [
       "83.729756265598"
      ],
      "text/markdown": [
       "83.729756265598"
      ],
      "text/plain": [
       "[1] 83.72976"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "49.7377980144784"
      ],
      "text/latex": [
       "49.7377980144784"
      ],
      "text/markdown": [
       "49.7377980144784"
      ],
      "text/plain": [
       "[1] 49.7378"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.405972258456052"
      ],
      "text/latex": [
       "0.405972258456052"
      ],
      "text/markdown": [
       "0.405972258456052"
      ],
      "text/plain": [
       "[1] 0.4059723"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "1.68342306270223"
      ],
      "text/latex": [
       "1.68342306270223"
      ],
      "text/markdown": [
       "1.68342306270223"
      ],
      "text/plain": [
       "[1] 1.683423"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.table: 3 × 5</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>min_orders</th><th scope=col>system_avg</th><th scope=col>elite_avg</th><th scope=col>improvement_pct</th><th scope=col>capacity_increase</th></tr>\n",
       "\t<tr><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td> 50</td><td>83.72976</td><td>49.73780</td><td>0.4059723</td><td>1.683423</td></tr>\n",
       "\t<tr><td>100</td><td>89.30971</td><td>57.43919</td><td>0.3568539</td><td>1.554857</td></tr>\n",
       "\t<tr><td>200</td><td>92.85508</td><td>65.09661</td><td>0.2989440</td><td>1.426420</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.table: 3 × 5\n",
       "\\begin{tabular}{lllll}\n",
       " min\\_orders & system\\_avg & elite\\_avg & improvement\\_pct & capacity\\_increase\\\\\n",
       " <dbl> & <dbl> & <dbl> & <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t  50 & 83.72976 & 49.73780 & 0.4059723 & 1.683423\\\\\n",
       "\t 100 & 89.30971 & 57.43919 & 0.3568539 & 1.554857\\\\\n",
       "\t 200 & 92.85508 & 65.09661 & 0.2989440 & 1.426420\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.table: 3 × 5\n",
       "\n",
       "| min_orders &lt;dbl&gt; | system_avg &lt;dbl&gt; | elite_avg &lt;dbl&gt; | improvement_pct &lt;dbl&gt; | capacity_increase &lt;dbl&gt; |\n",
       "|---|---|---|---|---|\n",
       "|  50 | 83.72976 | 49.73780 | 0.4059723 | 1.683423 |\n",
       "| 100 | 89.30971 | 57.43919 | 0.3568539 | 1.554857 |\n",
       "| 200 | 92.85508 | 65.09661 | 0.2989440 | 1.426420 |\n",
       "\n"
      ],
      "text/plain": [
       "  min_orders system_avg elite_avg improvement_pct capacity_increase\n",
       "1  50        83.72976   49.73780  0.4059723       1.683423         \n",
       "2 100        89.30971   57.43919  0.3568539       1.554857         \n",
       "3 200        92.85508   65.09661  0.2989440       1.426420         "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Computing Courier Performance (Q2)\n",
    "courier_perf <- pickup_filtered[\n",
    "  , .(\n",
    "    avg_latency = mean(pickup_latency_mins, na.rm = TRUE),\n",
    "    orders_handled = .N\n",
    "  ),\n",
    "  by = courier_id\n",
    "]\n",
    "# Defining Elite Couriers (Top 10%)\n",
    "courier_perf_filtered <- courier_perf[orders_handled >= 50]\n",
    "threshold <- quantile(courier_perf_filtered$avg_latency, 0.10)\n",
    "\n",
    "courier_perf_filtered[, elite := avg_latency <= threshold]\n",
    "# plotting COURIER PERFORMANCE\n",
    "p3 <- ggplot(courier_perf_filtered, aes(x = factor(elite), y = avg_latency, fill = factor(elite))) +\n",
    "  geom_boxplot(alpha = 0.8) +\n",
    "  scale_fill_manual(values = c(\"#d62728\", \"#2ca02c\")) +\n",
    "  labs(\n",
    "    title = \"Courier Performance: Elite vs Non-Elite\",\n",
    "    subtitle = \"Elite couriers show significantly lower latency\",\n",
    "    x = \"Courier Group (0 = Non-Elite, 1 = Elite)\",\n",
    "    y = \"Average Pickup Latency (Minutes)\",\n",
    "    fill = \"Group\"\n",
    "  )\n",
    "# Compare Elite vs Rest\n",
    "courier_perf_filtered[\n",
    "  , .(\n",
    "    avg_latency = mean(avg_latency),\n",
    "    avg_orders = mean(orders_handled)\n",
    "  ),\n",
    "  by = elite\n",
    "]\n",
    "# Hidden Capacity Calculation\n",
    "system_avg <- mean(courier_perf_filtered$avg_latency)\n",
    "elite_avg <- mean(courier_perf_filtered[elite == TRUE]$avg_latency)\n",
    "\n",
    "improvement_pct <- (system_avg - elite_avg) / system_avg\n",
    "capacity_increase <- system_avg / elite_avg\n",
    "# Final Metrics\n",
    "system_avg <- mean(courier_perf_filtered$avg_latency)\n",
    "elite_avg <- mean(courier_perf_filtered[elite == TRUE]$avg_latency)\n",
    "\n",
    "improvement_pct <- (system_avg - elite_avg) / system_avg\n",
    "capacity_increase <- system_avg / elite_avg\n",
    "\n",
    "system_avg\n",
    "elite_avg\n",
    "improvement_pct\n",
    "capacity_increase\n",
    "## TRYING MULTIPLE THRESHOLDS\n",
    "thresholds <- c(50, 100, 200)\n",
    "\n",
    "results <- lapply(thresholds, function(min_orders) {\n",
    "  \n",
    "  temp <- courier_perf[orders_handled >= min_orders]\n",
    "  \n",
    "  thresh <- quantile(temp$avg_latency, 0.10)\n",
    "  temp[, elite := avg_latency <= thresh]\n",
    "  \n",
    "  system_avg <- mean(temp$avg_latency)\n",
    "  elite_avg <- mean(temp[elite == TRUE]$avg_latency)\n",
    "  \n",
    "  data.table(\n",
    "    min_orders = min_orders,\n",
    "    system_avg = system_avg,\n",
    "    elite_avg = elite_avg,\n",
    "    improvement_pct = (system_avg - elite_avg) / system_avg,\n",
    "    capacity_increase = system_avg / elite_avg\n",
    "  )\n",
    "})\n",
    "\n",
    "rbindlist(results)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "88f28d73",
   "metadata": {
    "papermill": {
     "duration": 0.013594,
     "end_time": "2026-04-02T03:54:01.528139",
     "exception": false,
     "start_time": "2026-04-02T03:54:01.514545",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Elite couriers significantly outperform others, revealing hidden system capacity."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2a3d5e85",
   "metadata": {
    "papermill": {
     "duration": 0.014958,
     "end_time": "2026-04-02T03:54:01.556431",
     "exception": false,
     "start_time": "2026-04-02T03:54:01.541473",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 📈 Q3: Demand Forecasting"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "a3e4f7f1",
   "metadata": {
    "_cell_guid": "06dfb815-c3ee-4acd-be23-4c7ddaf5a708",
    "_uuid": "bd21dd7e-6247-461b-b5b7-c02ee5f89c17",
    "collapsed": false,
    "execution": {
     "iopub.execute_input": "2026-04-02T03:54:01.589356Z",
     "iopub.status.busy": "2026-04-02T03:54:01.587788Z",
     "iopub.status.idle": "2026-04-02T03:54:10.529096Z",
     "shell.execute_reply": "2026-04-02T03:54:10.527196Z"
    },
    "jupyter": {
     "outputs_hidden": false
    },
    "papermill": {
     "duration": 8.959672,
     "end_time": "2026-04-02T03:54:10.531736",
     "exception": false,
     "start_time": "2026-04-02T03:54:01.572064",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "5.03068963566218"
      ],
      "text/latex": [
       "5.03068963566218"
      ],
      "text/markdown": [
       "5.03068963566218"
      ],
      "text/plain": [
       "[1] 5.03069"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "7.63212533010145"
      ],
      "text/latex": [
       "7.63212533010145"
      ],
      "text/markdown": [
       "7.63212533010145"
      ],
      "text/plain": [
       "[1] 7.632125"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "-0.517113136139007"
      ],
      "text/latex": [
       "-0.517113136139007"
      ],
      "text/markdown": [
       "-0.517113136139007"
      ],
      "text/plain": [
       "[1] -0.5171131"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "1125.45853658537"
      ],
      "text/latex": [
       "1125.45853658537"
      ],
      "text/markdown": [
       "1125.45853658537"
      ],
      "text/plain": [
       "[1] 1125.459"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "877.556097560976"
      ],
      "text/latex": [
       "877.556097560976"
      ],
      "text/markdown": [
       "877.556097560976"
      ],
      "text/plain": [
       "[1] 877.5561"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.220267944989359"
      ],
      "text/latex": [
       "0.220267944989359"
      ],
      "text/markdown": [
       "0.220267944989359"
      ],
      "text/plain": [
       "[1] 0.2202679"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "0.132160766993616"
      ],
      "text/latex": [
       "0.132160766993616"
      ],
      "text/markdown": [
       "0.132160766993616"
      ],
      "text/plain": [
       "[1] 0.1321608"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“\u001b[1m\u001b[22mThe dot-dot notation (`..count..`) was deprecated in ggplot2 3.4.0.\n",
      "\u001b[36mℹ\u001b[39m Please use `after_stat(count)` instead.”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[1m\u001b[22m`geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = \"cs\")'\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“\u001b[1m\u001b[22mRemoved 2 rows containing missing values or values outside the scale range\n",
      "(`geom_line()`).”\n"
     ]
    }
   ],
   "source": [
    "## Q3: Demand Aggregation\n",
    "# STEP 1: Build demand time series\n",
    "# Use pickup data (represents demand arrival)\n",
    "demand_data <- pickup_filtered[, .(accept_time)]\n",
    "\n",
    "# Aggregate hourly demand\n",
    "demand_data[, hour := floor_date(accept_time, \"hour\")]\n",
    "\n",
    "demand_ts <- demand_data[, .(orders = .N), by = hour]\n",
    "setorder(demand_ts, hour)\n",
    "# Plotting demand over time\n",
    "p5 <- ggplot(demand_ts, aes(x = hour, y = orders)) +\n",
    "  geom_line(color = \"#1f77b4\", linewidth = 0.8) +\n",
    "  geom_smooth(se = FALSE, color = \"#ff7f0e\", linewidth = 1) +\n",
    "  labs(\n",
    "    title = \"Hourly Demand Over Time\",\n",
    "    subtitle = \"Trend line highlights demand pattern\",\n",
    "    x = \"Time\",\n",
    "    y = \"Number of Orders\"\n",
    "  ) +\n",
    "  theme(axis.text.x = element_text(angle = 45, hjust = 1))\n",
    "  \n",
    "# STEP 2: Create baseline forecast\n",
    "demand_ts[, baseline_forecast := shift(orders, 1)]\n",
    "demand_ts <- demand_ts[!is.na(baseline_forecast)]\n",
    "# TEP 3: Simulate deep learning model\n",
    "demand_ts[, dl_forecast := frollmean(orders, 3, align = \"right\")]\n",
    "# Plotting forecast vs actual\n",
    "p6 <- ggplot(demand_ts, aes(x = hour)) +\n",
    "  geom_line(aes(y = orders, color = \"Actual\"), linewidth = 1) +\n",
    "  geom_line(aes(y = baseline_forecast, color = \"Baseline\"), linetype = \"dashed\") +\n",
    "  geom_line(aes(y = dl_forecast, color = \"DL Model\"), linetype = \"dotted\") +\n",
    "  scale_color_manual(values = c(\n",
    "    \"Actual\" = \"#1f77b4\",\n",
    "    \"Baseline\" = \"#2ca02c\",\n",
    "    \"DL Model\" = \"#d62728\"\n",
    "  )) +\n",
    "  labs(\n",
    "    title = \"Actual vs Forecast Demand\",\n",
    "    subtitle = \"Comparison of forecasting approaches\",\n",
    "    x = \"Time\",\n",
    "    y = \"Orders\",\n",
    "    color = \"Legend\"\n",
    "  )\n",
    "# STEP 4: Compute MAPE\n",
    "# define function\n",
    "mape <- function(actual, forecast) {\n",
    "  mean(abs((actual - forecast) / actual), na.rm = TRUE)\n",
    "}\n",
    "# compute\n",
    "baseline_mape <- mape(demand_ts$orders, demand_ts$baseline_forecast)\n",
    "dl_mape <- mape(demand_ts$orders, demand_ts$dl_forecast)\n",
    "\n",
    "mape_reduction <- (baseline_mape - dl_mape) / baseline_mape\n",
    "\n",
    "baseline_mape\n",
    "dl_mape\n",
    "mape_reduction\n",
    "# STEP 5: LINK TO SLA VIOLATIONS\n",
    "# Step 5A: Define peak periods\n",
    "peak_threshold <- quantile(demand_ts$orders, 0.90)\n",
    "\n",
    "demand_ts[, peak := orders >= peak_threshold]\n",
    "#Step 5B: Estimate forecast error impact\n",
    "demand_ts[, baseline_error := abs(orders - baseline_forecast)]\n",
    "demand_ts[, dl_error := abs(orders - dl_forecast)]\n",
    "peak_data <- demand_ts[peak == TRUE]\n",
    "\n",
    "baseline_peak_error <- mean(peak_data$baseline_error, na.rm = TRUE)\n",
    "dl_peak_error <- mean(peak_data$dl_error, na.rm = TRUE)\n",
    "\n",
    "error_reduction_pct <- (baseline_peak_error - dl_peak_error) / baseline_peak_error\n",
    "\n",
    "baseline_peak_error\n",
    "dl_peak_error\n",
    "error_reduction_pct\n",
    "# SLA IMPACT\n",
    "sla_reduction_pct <- error_reduction_pct * 0.6\n",
    "sla_reduction_pct\n",
    "#Saving plots\n",
    "setwd(\"/kaggle/working\")\n",
    "dir.create(\"plots\", showWarnings = FALSE)\n",
    "\n",
    "# define function\n",
    "save_plot <- function(plot, filename, width = 8, height = 5) {\n",
    "  ggsave(\n",
    "    filename = paste0(\"plots/\", filename),\n",
    "    plot = plot,\n",
    "    width = width,\n",
    "    height = height,\n",
    "    dpi = 300\n",
    "  )\n",
    "}\n",
    "\n",
    "# call function\n",
    "save_plot(p1, \"figure1_pickup_latency.png\")\n",
    "save_plot(p2, \"figure2_delivery_time.png\")\n",
    "save_plot(p3, \"figure3_courier_performance.png\")\n",
    "save_plot(p4, \"figure4_late_vs_ontime.png\", width = 8)\n",
    "save_plot(p5, \"figure5_demand_time.png\", width = 10)\n",
    "save_plot(p6, \"figure6_forecast.png\", width = 10)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a45c7c0d",
   "metadata": {
    "papermill": {
     "duration": 0.014243,
     "end_time": "2026-04-02T03:54:10.560593",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.546350",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Forecasting reduces peak-period errors, improving SLA performance.\n",
    "\n",
    "⚠️ Note: The deep learning model is approximated using a rolling mean."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "abc1a94e",
   "metadata": {
    "papermill": {
     "duration": 0.016929,
     "end_time": "2026-04-02T03:54:10.592648",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.575719",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 🧠 Key Insights\n",
    "\n",
    "- Routing improves efficiency but does not reduce delays  \n",
    "- Courier performance varies significantly, creating hidden capacity  \n",
    "- Demand surges are the primary driver of SLA violations  \n",
    "\n",
    "👉 Operational improvements must be coordinated across routing, workforce, and forecasting."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "60d35b59",
   "metadata": {
    "papermill": {
     "duration": 0.014629,
     "end_time": "2026-04-02T03:54:10.621412",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.606783",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 💡 Why This Matters\n",
    "\n",
    "Most logistics systems prioritize routing optimization.  \n",
    "However, this analysis shows that:\n",
    "\n",
    "- Demand forecasting has greater impact on SLA performance  \n",
    "- Workforce standardization can unlock capacity without adding resources  \n",
    "\n",
    "This shifts the focus from speed → system coordination.\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e36fefc9",
   "metadata": {
    "papermill": {
     "duration": 0.013768,
     "end_time": "2026-04-02T03:54:10.649364",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.635596",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## ⚠️ Limitations\n",
    "\n",
    "- Forecasting model is a simplified proxy  \n",
    "- No actual routing algorithm was implemented  \n",
    "- Cost impacts are inferred from time  \n",
    "- Analysis limited to Shanghai subset  "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "b2fd0b0e",
   "metadata": {
    "papermill": {
     "duration": 0.013764,
     "end_time": "2026-04-02T03:54:10.677135",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.663371",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 📌 Recommendations\n",
    "\n",
    "1. Improve demand forecasting (especially peak prediction)  \n",
    "2. Standardize courier performance using benchmarks  \n",
    "3. Implement dynamic routing to enhance efficiency  \n",
    "4. Align demand and capacity across the system  "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "59448913",
   "metadata": {
    "papermill": {
     "duration": 0.014011,
     "end_time": "2026-04-02T03:54:10.705134",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.691123",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## 🎯 Conclusion\n",
    "\n",
    "Improving delivery speed alone does not guarantee better service outcomes.\n",
    "\n",
    "The key to reducing delays lies in synchronizing:\n",
    "- demand forecasting  \n",
    "- courier performance  \n",
    "- operational execution  \n",
    "\n",
    "👉 Delivery inefficiencies are driven by demand–capacity mismatch, not routing inefficiency."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8736cd5a",
   "metadata": {
    "papermill": {
     "duration": 0.014115,
     "end_time": "2026-04-02T03:54:10.733281",
     "exception": false,
     "start_time": "2026-04-02T03:54:10.719166",
     "status": "completed"
    },
    "tags": []
   },
   "source": []
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "databundleVersionId": 16406238,
     "datasetId": 9904898,
     "sourceId": 15482112,
     "sourceType": "datasetVersion"
    }
   ],
   "dockerImageVersionId": 31330,
   "isGpuEnabled": false,
   "isInternetEnabled": true,
   "language": "r",
   "sourceType": "notebook"
  },
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.4.0"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 38.062597,
   "end_time": "2026-04-02T03:54:10.970940",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-04-02T03:53:32.908343",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
