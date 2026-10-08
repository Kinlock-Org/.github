# M0-02 — Payee interviews

**Goal:** talk to 5 payees (schools, landlords) in candidate markets, including willingness to operate a wallet.
**Feeds:** `PRD.md` §8.2 trigger ("fewer than 3 of 5 interviewed payees will operate a wallet even with assisted onboarding") and §10 assumption 1.
**Done when:** at least 3 of 5 answers recorded against the §8.2 trigger.

## Who to recruit

- At least one school administrator/bursar and one landlord (or landlord-association member) per candidate market where possible.
- Should be the person who'd actually handle receiving/claiming funds day to day, not just an owner/principal who'd never touch the flow.

## Script

1. **Context.** How do you currently receive fee/rent payments from people who aren't paying in person (bank transfer, mobile money, agent, cash via a third party)? What breaks or annoys you about that?
2. **Wallet concept.** [Explain in plain terms: a wallet is an account you control that can receive and send a digital dollar called USDC; no bank needed, but you're responsible for a recovery phrase/key.] How does that sound? What's your gut reaction?
3. **Assisted onboarding.** If someone (an attester — a trusted local association or NGO) walked you through setup step by step and gave you a written checklist, would you be willing to try it? What would make you say no?
4. **Cash-out.** Once you receive USDC, would you want to convert it to local currency, or would holding USDC be fine (e.g. to pay suppliers, or if you trust it holds value better than local currency)? Do you know of a way to convert it today?
5. **Verification/trust.** Would you want your name/institution publicly shown as "verified" with an attester's endorsement? Any concerns about that visibility?
6. **Reliability concerns.** What would worry you about depending on this instead of your current method — losing access, a mistake sending the wrong amount, needing to dispute/decline a payment?
7. **The §8.2 question, explicitly:** *Would you operate a wallet yourself for this, with assisted onboarding — yes, no, or only if someone else manages it for you?*

## Note template (per interview — anonymized)

```
Interview ID: P-##
Date:
Country / currency:
Payee type (School / Rent):
Current receiving method + pain points:
Reaction to wallet concept:
Will operate a wallet with assisted onboarding? (yes / no / only-if-managed)
Cash-out preference (convert to local / hold USDC / unsure):
Comfort with public verified-payee visibility:
Biggest worry about switching:
```

## Log

| ID | Country | Type | Will operate wallet (assisted)? | Cash-out preference |
|---|---|---|---|---|
| _(append rows here as interviews complete)_ | | | | |

## §8.2 trigger check (fill in once 5 are logged)

Count of "yes" or "only-if-managed-but-willing" out of 5: ___ / 5
- If **< 3**: trigger fires — evaluate anchor-managed receiving (payee never touches crypto directly); re-scope trust model per `PRD.md` §8.2.
- If **≥ 3**: assumption 1 holds; proceed.

## Themes

- Common onboarding blockers:
- Cash-out expectations by market:
- Trust/visibility concerns:
