# 🏏 IPL Data Analytics Project (Python • SQL • Power BI)

A comprehensive **end-to-end data analytics project** focused on **Indian Premier League (IPL)** data. This project demonstrates how raw cricket data can be transformed into **meaningful insights and interactive dashboards** using **SQL, Python, and Power BI**.

The goal of this project is not just visualization, but **storytelling through data** — understanding team strategies, player performance, match dynamics, and hidden patterns across IPL seasons.

---

## 🔧 Tools & Technologies

* **Python** – Data cleaning, transformation, and exploratory data analysis (EDA)

  * Libraries: `pandas`, `matplotlib`, `seaborn`
* **SQL (MySQL)** – Data extraction, filtering, aggregations, and KPI generation
* **Power BI** – Interactive dashboards, KPIs, slicers, drill-down analysis
* **Jupyter Notebook** – Analysis documentation and visual exploration

---

## 📂 Dataset Overview

* Source: **IPL Ball-by-Ball & Match Data (2008–2025)**
* Data Type: Match-level and ball-by-ball level data
* Format: CSV files

Using **SQL**, the master dataset was filtered and transformed into season-specific and analysis-ready datasets.

---

## 🎯 Project Objectives

This project answers key analytical questions such as:

* Does winning the **toss** significantly increase match-winning chances?
* Which teams and players are the **most consistent performers**?
* How do **batting positions** affect total runs scored?
* Which teams control matches using **dot balls and disciplined bowling**?
* What is the impact of **boundaries (4s & 6s)** on match outcomes?
* How effective is the **DRS review system** across teams?
* What target ranges are most common in successful chases?

---

## 🧪 Project Workflow

### 1️⃣ SQL – Data Preparation

* Imported raw IPL datasets into MySQL
* Cleaned data (removed abandoned matches, null values, inconsistencies)
* Created filtered tables and views for analysis
* Wrote advanced queries using:

  * `GROUP BY`, `JOIN`, `CASE`, subqueries
  * Aggregations for runs, wickets, strike rates, economy rates

**Key SQL Insights Generated:**

* Orange Cap & Purple Cap leaderboards
* Most runs scored in a match
* Strike rate & economy rate analysis
* Toss winner vs match winner comparison
* Player of the Match analysis

---

### 2️⃣ Python – Exploratory Data Analysis (EDA)

* Loaded SQL-exported datasets into pandas
* Performed data validation and cleaning
* Conducted season-wise and team-wise analysis
* Created visualizations for:

  * Team win percentage
  * Dot balls by team
  * Total boundaries (4s vs 6s)
  * Catches per team
  * Toss impact analysis

Jupyter Notebook was used to document insights with clear explanations.

---

### 3️⃣ Power BI – Dashboard & Visualization

Designed a **multi-page interactive Power BI dashboard**:

#### 📊 Dashboard Pages

**Page 1 – IPL Overview**

* Total matches, runs, boundaries (KPI cards)
* Toss winner vs match winner
* Team & season slicers

**Page 2 – Team Performance**

* Runs scored by teams
* Dot balls & catches comparison
* Boundary analysis (4s & 6s)

**Page 3 – Player Performance**

* Top run scorers (Orange Cap)
* Top wicket takers (Purple Cap)
* Batting position vs runs trend

**Page 4 – Match Insights**

* DRS review success rate
* Target range distribution during chases

✔ Interactive filters and clean visual design for easy exploration

---

## 📈 Key Insights

* Toss winners do **not always** win the match — strategy matters more
* Dot-ball pressure plays a major role in controlling matches
* Certain players consistently outperform across seasons
* High-scoring chases (200+ targets) are increasingly common
* Fielding performance (catches & errors) impacts match outcomes

---

## 💡 What I Learned

* End-to-end data pipeline: **SQL → Python → Power BI**
* Writing optimized SQL queries for analytics
* Cleaning real-world sports data
* Building professional dashboards with storytelling focus
* Translating raw numbers into actionable insights

---

## ▶️ How to Use This Project

1. Review SQL scripts to understand data preparation
2. Explore the Jupyter Notebook for analysis logic
3. Open the Power BI file to interact with dashboards
4. Modify queries or visuals to perform custom analysis

---

## 👤 Author

**Vijay**
Data Analyst | Python | SQL | Power BI

---

## ⭐ Final Note

This project showcases practical **data analytics skills applied to real-world sports data**. If you find it helpful, feel free to explore, fork, or build upon it.

**Thank you for checking out this project! 🚀**
