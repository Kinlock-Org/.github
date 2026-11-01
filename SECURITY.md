# Security policy

Kinlock handles user-authorized escrow transactions on Stellar. If you discover a security vulnerability, privacy defect, or invariant violation, **do not open a public issue.** Report it privately through GitHub's "Report a vulnerability" (Private Security Advisories) on the affected repository, or email the maintainers directly:
- `adenikeajala2018@gmail.com`
- `Yazarayobami76@gmail.com`

## Response & Disclosure Timelines

- **Initial Acknowledgement:** We acknowledge receipt of vulnerability reports within **48 hours**.
- **Triage & Assessment:** We assess severity and provide a remediation plan or status update within **5 business days**.
- **Coordinated Disclosure:** Security patches will be prepared, verified, and released in coordinated disclosure with the reporter. We ask reporters to follow responsible disclosure practices and refrain from public disclosure until patches have landed.

## Scope

In scope:
- `kinlock-contracts`: Soroban smart contract invariants, state transition rules, authorization verification, and fund release/refund boundaries.
- `kinlock-sdk`: Transaction construction, parameter validation, reference hashing (`sha256(reference ‖ salt)`), and event indexer service.
- `kinlock-app`: Web application, wallet signing kit, and URL fragment privacy guarantees.
- `kinlock-registry`: Public payee schema validation and cryptographic hashing bindings.
