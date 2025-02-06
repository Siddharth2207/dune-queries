WITH 
-- Get all mints and burns
mints_and_burns AS (
  SELECT
    ROUND(value / 1e18, 10) AS token_amount, /* Adjust decimals to show up to 10 decimal places */
    CASE
      WHEN "from" = 0x0000000000000000000000000000000000000000 THEN 'Mint'
      WHEN "to" = 0x0000000000000000000000000000000000000000 THEN 'Burn'
    END AS event_type
  FROM 
    cyclofinance_flare.cyclovault_evt_transfer
  WHERE 
    contract_address = 0xd8BF1d2720E9fFD01a2F9A2eFc3E101a05B852b4 /* Bytearray literal */
    AND (
      "from" = 0x0000000000000000000000000000000000000000 /* Mints */
      OR "to" = 0x0000000000000000000000000000000000000000 /* Burns */
    )
),
-- Calculate totals for mints and burns
totals AS (
  SELECT
    SUM(CASE WHEN event_type = 'Mint' THEN token_amount ELSE 0 END) AS total_mints,
    SUM(CASE WHEN event_type = 'Burn' THEN token_amount ELSE 0 END) AS total_burns
  FROM 
    mints_and_burns
)
-- Output total mints, total burns, and total supply
SELECT
  total_mints,
  total_burns,
  total_mints - total_burns AS total_supply
FROM 
  totals;
