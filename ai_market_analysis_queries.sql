CREATE TABLE market_impact(
id SERIAL PRIMARY KEY,
company VARCHAR(50),
product VARCHAR(50),
metric_type VARCHAR(50),
value_before NUMERIC,
value_after NUMERIC,
source VARCHAR(100)
);
INSERT INTO market_impact (company, product, metric_type, value_before, value_after, source) VALUES
('OpenAI', 'ChatGPT', 'Market Share %', 76.4, 62.6, 'SearchEngineJournal'),
('Anthropic', 'Claude', 'Market Share %', 8.9, 18.5, 'SearchEngineJournal'),
('Google', 'Gemini', 'Market Share %', 9.0, 27.3, 'SearchEngineJournal'),
('Perplexity', 'Perplexity', 'Market Share %', 3.5, 7.3, 'First Page Sage'),
('OpenAI', 'ChatGPT', 'Weekly Active Users (M)', 900, 900, 'OpenAI Official'),
('Google', 'Gemini', 'Monthly Active Users (M)', 500, 1000, 'First Page Sage'),
('Anthropic', 'Claude', 'Annual Revenue ($B)', 9, 65, 'Reuters'),
('OpenAI', 'GPT-6 Astra', 'Benchmark Score', 0, 53, 'Artificial Analysis Index'),
('Anthropic', 'Claude Fable 5.1', 'Benchmark Score', 0, 53, 'Artificial Analysis Index');

SELECT * FROM market_impact;
SELECT
company,
product,
metric_type,
value_before,
value_after,
ROUND(((value_after-value_before)/NULLIF(value_before,0))*100,2)
AS percent_change
FROM market_impact
ORDER BY percent_change DESC;

SELECT 
company,
value_before AS share_before,
value_after AS share_after,
ROUND(value_after-value_before,2)AS point_change
FROM market_impact
WHERE metric_type ='Market Share %'
ORDER BY point_change DESC;

