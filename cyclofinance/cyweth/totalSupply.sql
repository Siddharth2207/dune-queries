WITH 
-- Get all mints and burns
mints_and_burns AS (
  SELECT
    evt_block_number AS block_number,
    evt_block_time AS block_time,
    value / 1e18 AS token_amount, /* Adjust decimals if necessary */
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
-- Calculate net mints and burns per block
net_supply_per_block AS (
  SELECT
    block_number,
    block_time,
    SUM(CASE WHEN event_type = 'Mint' THEN token_amount ELSE 0 END) AS block_mints,
    SUM(CASE WHEN event_type = 'Burn' THEN token_amount ELSE 0 END) AS block_burns
  FROM 
    mints_and_burns
  GROUP BY 
    block_number, block_time
),
-- Calculate cumulative total supply across blocks
total_supply AS (
  SELECT
    block_number,
    block_time,
    SUM(block_mints - block_burns) OVER (ORDER BY block_number ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_supply
  FROM 
    net_supply_per_block
)
-- Output total supply across blocks
SELECT 
  block_number,
  block_time,
  total_supply
FROM 
  total_supply
ORDER BY 
  block_number ASC;
