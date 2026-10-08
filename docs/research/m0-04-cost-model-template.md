# M0-04 — Sender all-in cost model (template)

**Goal:** a spreadsheet with fees at each hop, used to set the cost target in `M0-13`.
**Depends on:** `M0-01` (sender interviews — not yet conducted) and `M0-05` (anchor spike per candidate market — not yet run).
**Done when:** spreadsheet with fees at each hop; target cost set (`M0-13`).

## Why this is a template, not the answer

This fills in the **structure** `M0-04` asks for, seeded with public benchmark ranges so the model exists and can be sanity-checked — but the actual numbers Kinlock needs are:
1. What senders **currently pay** through their actual channel, for their actual corridor (comes from `M0-01` interviews — templates drafted, no interviews run yet).
2. What a candidate market's **real anchor/off-ramp rate** is for the payee's payout currency (comes from `M0-05` anchor spike — not yet run).

Don't treat the illustrative ranges below as Kinlock's cost claim. They're public-market reference points to structure the model, not Kinlock-specific data.

## Hop-by-hop structure

| Hop | What happens | Illustrative range | Source | Real value (fill in) |
|---|---|---|---|---|
| 1. Sender's local currency → USDC (on-ramp) | Sender acquires USDC via an exchange or anchor | ~0.1%–2% (varies widely by provider and region; centralized-exchange rates like Coinbase/Kraken ACH run ~0.1–0.4%, consumer apps like MoonPay/Ramp/Transak run ~0.5–5.5%) | [USDC off/on-ramp fee comparison, eco.com, 2026](https://eco.com/support/en/articles/15039728-convert-usdc-to-bank-account-fastest-routes-in-2026) | — *(needs `M0-01`: what senders in each candidate market actually use and pay)* |
| 2. Lock USDC on Stellar (on-chain) | `create_lock` call; negligible network fee | ~$0.0001 per operation, flat regardless of amount | [Stellar fee structure, range.org / eco.com, 2026](https://www.range.org/blog/how-usdc-moves-on-stellar-stablecoin-usage-and-growth-across-borders) | Effectively zero — this hop isn't where cost risk lives |
| 3. Release USDC → payee's local currency (off-ramp) | Payee converts to local currency via an anchor/exchange, or holds USDC | ~0.1%–5.5% depending on provider; consumer off-ramp apps often land 1–4% all-in | [Same as above, eco.com, 2026](https://eco.com/support/en/articles/15039728-convert-usdc-to-bank-account-fastest-routes-in-2026) | — *(needs `M0-05`: real anchor/wallet route per candidate market — may not exist at all in some markets, per `PRD.md` §8.2 pivot trigger)* |
| **All-in (hops 1–3)** | | **Illustrative: ~0.2%–7.5%**, dominated entirely by hops 1 and 3, not the blockchain itself | — | — |

## Incumbent comparison (for `PRD.md` §8.2's cost trigger)

| Route | All-in cost | Source |
|---|---|---|
| Global average remittance cost (World Bank, 367 corridors) | **6.49%** of amount sent | [Remittance Prices Worldwide, World Bank, data through Aug 2025](https://remittanceprices.worldbank.org) |

**Caveat:** a single global average is the wrong thing to compare against once pilot markets are chosen (`M0-16`) — remittance cost varies enormously by corridor (some well under 2%, some well over 15%). Replace this row with the *specific* corridor's incumbent cost once `M0-01` interviews report what senders in that corridor actually pay today, and once the pilot market(s) are fixed.

## How to finish this (for whoever runs M0-01/M0-05)

1. Run the `M0-01` sender interviews (materials already in `docs/research/m0-01-sender-interviews.md`); record the "Current channel + rough all-in cost" field per interview.
2. Run the `M0-05` anchor spike per candidate market; record real on/off-ramp rates.
3. Replace the "Real value" column above with actual numbers.
4. Move to `M0-13`: set the sender all-in cost target from this data, recorded in `PRD.md` §8.1.

## Sources

- [Remittance Prices Worldwide — World Bank](https://remittanceprices.worldbank.org)
- [USDC off-ramp/on-ramp fee comparison — eco.com, 2026](https://eco.com/support/en/articles/15039728-convert-usdc-to-bank-account-fastest-routes-in-2026)
- [How USDC moves on Stellar — range.org](https://www.range.org/blog/how-usdc-moves-on-stellar-stablecoin-usage-and-growth-across-borders)
