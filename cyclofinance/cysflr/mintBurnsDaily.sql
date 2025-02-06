SELECT
  DATE_TRUNC('day', evt_block_time) AS period,
  CASE
    WHEN "from" = 0x0000000000000000000000000000000000000000
    THEN 'Mint'
    WHEN "to" = 0x0000000000000000000000000000000000000000
    THEN 'Burn'
  END AS event_type,
  SUM(ROUND(value / 1e18, 10)) AS total_amount
FROM cyclofinance_flare.ERC20PriceOracleReceiptVault_evt_Transfer
WHERE
  contract_address = 0x19831cfb53a0dbead9866c43557c1d48dff76567 /* Bytearray literal */
  AND (
    "from" = 0x0000000000000000000000000000000000000000 /* Mints */
    OR "to" = 0x0000000000000000000000000000000000000000 /* Burns */
  )
GROUP BY
  DATE_TRUNC('day', evt_block_time),
  2
ORDER BY
  period