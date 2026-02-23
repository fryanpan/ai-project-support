# Security Review: Happy Claude Code Mobile Client

**Date:** 2026-02-22
**Repos:** github.com/slopus/happy (monorepo), github.com/slopus/happy-cli (deprecated, merged into monorepo)
**Components:** happy-app (Expo mobile/web), happy-cli (Node.js CLI wrapper), happy-server (Fastify + Postgres + Socket.IO relay)
**Open Issues at Review Time:** 497 in main repo

---

## Summary

The core message-passing architecture is sound. If you use the default setup — mobile app controls CLI, messages are end-to-end encrypted — your actual code and Claude conversations are protected from the relay operator and passive eavesdroppers. However, three issues warrant attention before using this in a high-stakes environment:

1. **Do not use `happy connect` to store API keys.** Issue #681 is open. Anthropic/OpenAI/Gemini keys are currently server-side encrypted, not client-side — the relay operator can read them.
2. **QR codes have no expiry (issue #674).** Anyone who photographs your QR code can pair indefinitely.
3. **Avoid the web client for sensitive sessions.** Master secret stored in `localStorage` + unpatched Mermaid XSS (#678) is a meaningful attack chain.

---

## 1. Encryption Implementation

### Two Variants

**Variant A: Legacy (NaCl secretbox)**
- Algorithm: XSalsa20-Poly1305 via TweetNaCl `secretbox`
- Key: single 32-byte shared secret from mobile master secret, transferred during pairing
- Wire: `[ nonce (24 bytes) | ciphertext + auth tag ]`, base64-encoded

**Variant B: dataKey (AES-256-GCM)** — current default
- Content: AES-256-GCM, 12-byte random nonce, 16-byte auth tag
- Wire: `[ version byte (0x00) | nonce (12) | ciphertext | auth tag (16) ]`
- Per-session keys generated fresh on CLI (`getRandomBytes(32)`) for each session
- Content key wrapped via NaCl box (Curve25519 ECDH + XSalsa20-Poly1305):
  `[ ephemeral public key (32) | nonce (24) | encrypted content key ]`

### What the Server Sees

The server stores opaque base64 blobs for: session metadata, agent state, daemon state, all messages, artifacts, KV store values, and access keys. It has no keys to decrypt any of these. Messages are stored as `{ t: "encrypted", c: "<base64>" }`. The server only routes and persists ciphertext.

### Primitives Assessment

XSalsa20-Poly1305 and AES-256-GCM are well-established AEAD schemes. NaCl box (Curve25519 ECDH + XSalsa20-Poly1305) for key wrapping is the same construction used in Signal. TweetNaCl and libsodium are widely audited. Cryptographic choices are sound.

---

## 2. Authentication Model

### Initial Pairing (CLI to Mobile)

1. CLI generates ephemeral Curve25519 keypair
2. CLI posts ephemeral public key to `POST /v1/auth/request`
3. CLI displays `happy://terminal?<base64url-public-key>` as QR code
4. User scans QR; mobile app (already authenticated) encrypts master key material to CLI's ephemeral public key via NaCl box
5. CLI polls until `authorized`, decrypts response using ephemeral secret key
6. CLI writes credentials to `~/.happy/access.key` (Bearer token + encryption keys)

### Mobile App Authentication

Ed25519 challenge-response:
1. App generates 32-byte random challenge
2. Signs with Ed25519 private key (derived from master secret via `crypto_sign_seed_keypair`)
3. Server verifies signature against supplied public key
4. Server returns Bearer token (no expiry, cached in-memory indefinitely)

### Authorization

All protected endpoints require `Authorization: Bearer <token>`. Session, message, machine, artifact, and KV operations all enforce `accountId = userId` in Prisma queries — users can only access their own data.

---

## 3. Attack Vectors

### HIGH

**H1 — QR code has no expiry (open issue #674)**
`terminalAuthRequest` and `accountAuthRequest` rows have no `expiresAt` field and no cleanup job. A QR captured in a screenshot, screen share, or over someone's shoulder is usable indefinitely. An attacker who captures it can pair at any future time, observe metadata, presence, and machine state (though not decrypt messages without the master key).

**H2 — Vendor API tokens not E2E encrypted (open issue #681, PR open)**
`happy connect claude/openai` sends your API key to the server where it is encrypted server-side using `HANDY_MASTER_SECRET`. A compromised server, rogue operator, or `HANDY_MASTER_SECRET` leak exposes all stored API keys in plaintext. PR is open to move encryption to the client.

### MEDIUM

**M1 — Wildcard CORS (issue #673, closed on GitHub but `*` still in source)**
HTTP and Socket.IO currently show `origin: '*'`. The issue was closed, suggesting a production fix, but self-hosters from source would be vulnerable.

**M2 — Auth challenge is client-generated (open issue #669)**
`POST /v1/auth` accepts the challenge from the client. Any `(publicKey, challenge, signature)` triple from a past auth request can be replayed to mint new tokens. Hard to exploit under HTTPS, but not defense-in-depth.

**M3 — Token cache has no TTL**
`auth.verifyToken()` caches tokens indefinitely. No logout-invalidates-server-token mechanism. A stolen Bearer token is valid until the server restarts.

**M4 — XSS in Mermaid WebView (open issue #678, PR open)**
Agent-generated Mermaid content is interpolated into HTML without sanitization. A malicious Claude session could execute arbitrary JavaScript in the mobile app's WebView context.

**M5 — Web client stores master secret in `localStorage`**
Not protected by OS-level secure enclave. Combined with M4 (Mermaid XSS), there is a potential attack chain where agent-generated content executes JS that reads the master secret.

### LOW

**L1 — RevenueCat key accepted from client (open issue #670)**
Voice token endpoint accepts the RevenueCat API key from the request body — authenticated users can bypass the voice subscription paywall.

**L2 — `HANDY_MASTER_SECRET` is a single point of failure**
Compromise allows: forging Bearer tokens for any userId, decrypting all stored vendor API tokens.

**L3 — No rate limiting on auth endpoints**

**L4 — CLI credentials stored unencrypted on disk**
`~/.happy/access.key` is plaintext JSON containing the Bearer token and encryption key material. No macOS Keychain integration.

---

## 4. Server Compromise Scenario

**What the attacker gets:**
- All stored ciphertext — unreadable without client keys
- All stored vendor API tokens — decryptable with `HANDY_MASTER_SECRET`
- GitHub OAuth tokens — decryptable with `HANDY_MASTER_SECRET`
- Ability to forge Bearer tokens for any user with `HANDY_MASTER_SECRET`
- Message metadata: timing, session IDs, machine IDs, presence, usage counts
- Push notification tokens, unencrypted KV keys, account public keys

**What they cannot do without client key material:**
- Decrypt session messages, metadata, agent state, artifacts, or KV values

---

## 5. What Is Good

- Core design is correct: relay is a dumb store of opaque ciphertext, consistently applied
- NaCl box with ephemeral keypair for pairing key exchange — no replay possible
- Per-session, per-machine encryption keys (dataKey variant) — key isolation
- Mobile uses `expo-secure-store` (iOS Keychain / Android Keystore) for master secret
- Session/message operations consistently enforce `accountId = userId` in DB queries
- Optimistic concurrency and serializable transaction isolation on multi-write operations
- Input validation via Zod schemas on all routes
- RPC calls correctly restricted to same-user sockets
- Fully open source with architecture, protocol, and encryption documentation

---

## 6. Summary Table

| Topic | Finding |
|---|---|
| Message encryption | AES-256-GCM (dataKey) / XSalsa20-Poly1305 (legacy). Sound primitives, correct implementation. |
| Key exchange | NaCl box with ephemeral keypair. QR transfers master key material. No expiry — open issue. |
| Relay operator visibility | Cannot read messages or agent state. CAN read vendor API keys, GitHub token, timestamps, usage counts. |
| Vendor API key encryption | Server-side only. PR open to fix. HIGH risk for `happy connect` users. |
| Auth model | Ed25519 challenge-signature for identity. Bearer tokens with no expiry. Client-generated challenge (minor antipattern). |
| Session isolation | Enforced at DB query level via `accountId = userId`. Appears solid. |
| CORS | Wildcard in source code. Issue closed (prod fix claimed). Self-hosters should verify. |
| XSS | Mermaid WebView XSS open. PR pending. |
| Web client key storage | `localStorage` — weaker than mobile SecureStore. |
| Self-hosting | Supported. Removes relay operator from trust model. |
| Overall | Use with caution. Sound design, specific operational gaps. Do not use `happy connect` for API keys until #681 merges. |

---

## Sources

- https://github.com/slopus/happy — main repo
- Issue #674 (QR expiry): https://github.com/slopus/happy/issues/674
- Issue #681 (vendor token E2E): https://github.com/slopus/happy/issues/681
- Issue #678 (Mermaid XSS): https://github.com/slopus/happy/issues/678
- Issue #669 (client challenge): https://github.com/slopus/happy/issues/669
- Issue #670 (RevenueCat): https://github.com/slopus/happy/issues/670
- Issue #673 (CORS): https://github.com/slopus/happy/issues/673
