SELECT
  DATE_TRUNC('week', evt_block_time) AS period,
  CASE
    WHEN "from" = 0x0000000000000000000000000000000000000000
    THEN 'Mint'
    WHEN "to" = 0x0000000000000000000000000000000000000000
    THEN 'Burn'
  END AS event_type,
  SUM(ROUND(value / 1e18, 10)) AS total_amount
FROM cyclofinance_flare.cyclovault_evt_transfer
WHERE
  contract_address = 0xd8BF1d2720E9fFD01a2F9A2eFc3E101a05B852b4 /* Bytearray literal */
  AND (
    "from" = 0x0000000000000000000000000000000000000000 /* Mints */
    OR "to" = 0x0000000000000000000000000000000000000000 /* Burns */
  )
GROUP BY
  DATE_TRUNC('week', evt_block_time),
  2
ORDER BY
  period