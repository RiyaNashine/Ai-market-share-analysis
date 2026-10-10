# AI Market Share Analysis: ChatGPT vs Claude vs Gemini vs Perplexity (2026)

An end-to-end data analysis project that stores market data in **PostgreSQL**, processes it with **Python (Pandas)** in Jupyter Notebook, and presents the results in an interactive **Power BI** dashboard.

![Dashboard](images/dashboard.png)

---

## Table of Contents
- [Objective](#objective)
- [Tools Used](#tools-used)
- [Dataset](#dataset)
- [Workflow](#workflow)
- [Key Findings](#key-findings)
- [Limitations](#limitations)
- [Repository Structure](#repository-structure)
- [How to Run](#how-to-run)
- [Skills Demonstrated](#skills-demonstrated)
- [Author](#author)

## Objective

To compare how the market position of the major AI chatbot players (OpenAI, Anthropic, Google, Perplexity) changed in 2026, using market share, user and revenue data, and to demonstrate a complete **store, query, process, visualize** workflow.

## Tools Used

| Stage | Tools |
|---|---|
| Data storage and querying | PostgreSQL, pgAdmin, SQL |
| Data processing | Python (Pandas, SQLAlchemy), Jupyter Notebook |
| Visualization | Power BI |

## Dataset

The dataset was compiled manually from published reports and news sources, and stored in a PostgreSQL table called `market_impact`.

| company | product | metric_type | value_before | value_after | source |
|---|---|---|---|---|---|
| OpenAI | ChatGPT | Market Share % | 76.4 | 62.6 | SearchEngineJournal |
| Anthropic | Claude | Market Share % | 8.9 | 18.5 | SearchEngineJournal |
| Google | Gemini | Market Share % | 9.0 | 27.3 | SearchEngineJournal |
| Perplexity | Perplexity | Market Share % | 3.5 | 7.3 | First Page Sage |
| OpenAI | ChatGPT | Weekly Active Users (M) | 900 | 900 | OpenAI Official |
| Google | Gemini | Monthly Active Users (M) | 500 | 1000 | First Page Sage |
| Anthropic | Claude | Annual Revenue ($B) | 9 | 65 | Reuters |
| OpenAI | GPT-6 Astra | Benchmark Score | 0 | 53 | Artificial Analysis Index |
| Anthropic | Claude Fable 5.1 | Benchmark Score | 0 | 53 | Artificial Analysis Index |

**Table schema**

```sql
CREATE TABLE market_impact (
    id SERIAL PRIMARY KEY,
    company VARCHAR(50),
    product VARCHAR(50),
    metric_type VARCHAR(50),
    value_before NUMERIC,
    value_after NUMERIC,
    source VARCHAR(100)
);
```

## Workflow

### 1. SQL (PostgreSQL)
- Created the `market_impact` table and inserted the dataset
- Calculated % change for every metric, using `NULLIF` to avoid divide-by-zero errors where the starting value is 0 (the benchmark score rows)
- Filtered the market share rows to calculate the percentage-point change per company

```sql
SELECT
    company,
    product,
    metric_type,
    value_before,
    value_after,
    ROUND(((value_after - value_before) / NULLIF(value_before, 0)) * 100, 2) AS percent_change
FROM market_impact
ORDER BY percent_change DESC;
```

```sql
SELECT
    company,
    value_before AS share_before,
    value_after AS share_after,
    ROUND(value_after - value_before, 2) AS point_change
FROM market_impact
WHERE metric_type = 'Market Share %'
ORDER BY point_change DESC;
```

### 2. Python (Pandas)
- Connected to PostgreSQL using SQLAlchemy and loaded the table into a DataFrame
- Calculated % change, sorted the results and exported a CSV for Power BI

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:YOUR_PASSWORD@localhost:5432/YOUR_DATABASE')
df = pd.read_sql("SELECT * FROM market_impact;", engine)

df['percent_change'] = df.apply(
    lambda row: round(((row['value_after'] - row['value_before']) / row['value_before']) * 100, 2)
    if row['value_before'] != 0 else None,
    axis=1
)

df_sorted = df.sort_values(by='percent_change', ascending=False)
df.to_csv('ai_market_processed.csv', index=False)
```

### 3. Power BI
The processed CSV was loaded into Power BI to build a one-page dashboard with:
- A clustered column chart showing market share before vs after, per company
- A bar chart showing % change in market share (OpenAI highlighted in orange as the only decline)
- A detailed data table
- A company slicer that filters all visuals
- A key insights text box

## Key Findings

| Company | Market share before | After | Change (points) | Change (%) |
|---|---|---|---|---|
| Google (Gemini) | 9.0 | 27.3 | +18.3 | +203.3% |
| Anthropic (Claude) | 8.9 | 18.5 | +9.6 | +107.9% |
| Perplexity | 3.5 | 7.3 | +3.8 | +108.6% |
| OpenAI (ChatGPT) | 76.4 | 62.6 | -13.8 | -18.1% |

- OpenAI is the only company whose market share fell, although it remains the largest player
- Google and Anthropic gained the most share in absolute points
- Anthropic's annual revenue grew 622%, from $9B to $65B
- Gemini's reported monthly active users doubled, from 500M to 1,000M

## Limitations

- The figures were compiled from **different reports covering different time periods**, so the "before" and "after" values do not come from one single source or date. This project shows the **broader trend**, not the exact effect of any single product launch.
- Different sources measure market share differently, so the values do **not add up to exactly 100%**. Compare the direction and size of the change rather than treating each figure as exact.
- The benchmark score rows start from 0 because they are new models, so a % change cannot be calculated for them (shown as empty/NULL).
- The weekly active users row for ChatGPT uses a single reported figure (900M) for both columns, so its change is 0% and it is not used as a finding.
- The data was entered manually. Please check the original sources before reusing any numbers.

## Repository Structure

```
├── README.md
├── ai_market_analysis_queries.sql     # SQL: table creation, insert, analysis queries
├── ai_market_analysis.ipynb           # Python notebook
├── ai_market_processed.csv            # Processed data used in Power BI
├── AI_Market_Dashboard.pbix           # Power BI dashboard
└── images/
    └── dashboard.png                  # Dashboard screenshot
```

## How to Run

1. Create a PostgreSQL database and run `ai_market_analysis_queries.sql` to create and fill the `market_impact` table
2. Open `ai_market_analysis.ipynb` and replace `YOUR_PASSWORD` and `YOUR_DATABASE` in the connection string with your own PostgreSQL details
3. Run the notebook to generate `ai_market_processed.csv`
4. Open `AI_Market_Dashboard.pbix` in Power BI Desktop

## Skills Demonstrated

- SQL: table design, inserts, calculated columns, filtering, NULL handling
- Python: Pandas, database connection with SQLAlchemy, data export
- Power BI: charts, slicers, formatting, dashboard layout
- Data storytelling: turning numbers into a clear business insight, and stating the limits of the data honestly

## Author

**Riya Nashine**
[LinkedIn](https://www.linkedin.com/in/riya-nashine-4803b539a) | riyanashine112255@gmail.com
