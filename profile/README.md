# Kinlock

Lock USDC on Stellar for a verified payee anywhere in the world. Funds can only reach that payee's payout address or go back to the sender, and anyone can verify the receipt on-chain.

Worldwide by design, launched market by market. Testnet only until audit and legal review.

**Live app (testnet):** [kinlock-app.vercel.app](https://kinlock-app.vercel.app) · **Docs:** [kinlock-org.github.io](https://kinlock-org.github.io)

| Repo | What it is |
|---|---|
| [`kinlock-contracts`](https://github.com/Kinlock-Org/kinlock-contracts) | Soroban contract (registry + vault), tests, deploy scripts, bindings |
| [`kinlock-registry`](https://github.com/Kinlock-Org/kinlock-registry) | Public payee data, schemas, hash-check CI |
| [`kinlock-sdk`](https://github.com/Kinlock-Org/kinlock-sdk) | TypeScript SDK and the event indexer |
| [`kinlock-app`](https://github.com/Kinlock-Org/kinlock-app) | Next.js web app |
| [`Kinlock-Org.github.io`](https://github.com/Kinlock-Org/Kinlock-Org.github.io) | Hosted docs site, and where documentation issues across all repos get filed |

Start with [`docs/ARCHITECTURE_ESSENTIALS.md`](../docs/ARCHITECTURE_ESSENTIALS.md). Status lives in [`docs/ROADMAP.md`](../docs/ROADMAP.md). Found a documentation gap anywhere in Kinlock? File it at [`Kinlock-Org.github.io`](https://github.com/Kinlock-Org/Kinlock-Org.github.io/issues/new/choose), not as a one-off issue in whichever repo you happened to be reading.
