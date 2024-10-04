WITH bnb_token_volume AS (
  SELECT
    t.block_date,
    t.token_bought_symbol AS token_symbol,
    SUM(t.amount_usd) AS usd_volume
  FROM dex.trades AS t
  INNER JOIN raindex_bnb.OrderBook_evt_TakeOrder AS to
    ON t.tx_hash = to.evt_tx_hash AND t.block_number = to.evt_block_number
  WHERE
    t.block_date > TRY_CAST('2023-09-01' AS DATE)
  GROUP BY
    t.block_date,
    t.token_bought_symbol
)
SELECT
  block_date,
  token_symbol AS token,
  usd_volume
FROM bnb_token_volume
ORDER BY
  block_date,
  token_symbol;
