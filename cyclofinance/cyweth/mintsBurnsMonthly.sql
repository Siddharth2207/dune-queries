SELECT
  CAST(DATE_TRUNC('month', evt_block_time) AS DATE) AS period, /* Extract only the date (YYYY-MM-DD) */
  CASE
    WHEN "from" = 0x0000000000000000000000000000000000000000 THEN 'Mint'
    WHEN "to" = 0x0000000000000000000000000000000000000000 THEN 'Burn'
  END AS event_type,
  SUM(ROUND(value / 1e18, 10)) AS total_amount,
  MIN(evt_block_time) AS block_time /* Earliest block time in the month for reference */
FROM 
  cyclofinance_flare.cyclovault_evt_transfer
WHERE
  contract_address = 0x19831cfb53a0dbead9866c43557c1d48dff76567 /* Bytearray literal */
  AND (
    "from" = 0x0000000000000000000000000000000000000000 /* Mints */
    OR "to" = 0x0000000000000000000000000000000000000000 /* Burns */
  )
GROUP BY
  DATE_TRUNC('month', evt_block_time),
  CASE
    WHEN "from" = 0x0000000000000000000000000000000000000000 THEN 'Mint'
    WHEN "to" = 0x0000000000000000000000000000000000000000 THEN 'Burn'
  END
ORDER BY
  period ASC;
