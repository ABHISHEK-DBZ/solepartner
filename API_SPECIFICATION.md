# SOLEPARTNER — API SPECIFICATION & INTEGRATION INTERFACES
**Version:** 1.0.0-PROD  
**Specification Type:** OpenAPI 3.1 & Service Boundary Contracts  
**Document Classification:** Interface Architecture (Phase 0)

---

## 1. Cloud AI Chat Completions Interface

SolePartner interacts with OpenAI-compatible inference backends (e.g., Groq, OpenAI, self-hosted vLLM) strictly over HTTPS with Bearer authentication.

### Endpoint: `POST /v1/chat/completions`
- **Transport:** HTTPS only (TLS 1.3/1.2). Cleartext HTTP is rejected at client boundary.
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <API_KEY>`

#### Request Payload:
```json
{
  "model": "openai/gpt-oss-120b",
  "temperature": 0.1,
  "response_format": { "type": "json_object" },
  "messages": [
    {
      "role": "system",
      "content": "You are SolePartner AI. Classify the kirana merchant voice command. Return strictly valid JSON matching the schema: {\"intent\": string, \"amount_paise\": integer, \"customer_name\": string, \"product_name\": string, \"payment_method\": string}."
    },
    {
      "role": "user",
      "content": "Ramesh bought 2 bags of sugar on udhaar for 500 rupees"
    }
  ]
}
```

#### Validated Response Structure:
```json
{
  "id": "chatcmpl-92384920",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "{\"intent\":\"giveCredit\",\"amount_paise\":50000,\"customer_name\":\"Ramesh\",\"product_name\":\"sugar\",\"payment_method\":\"credit\"}"
      }
    }
  ]
}
```

---

## 2. Solana JSON-RPC 2.0 Interface

SolePartner communicates directly with the Solana Devnet cluster endpoint (`https://api.devnet.solana.com`).

### 2.1. `getBalance`
- **Method:** `POST /`
- **Params:** `["<BASE58_WALLET_ADDRESS>", {"commitment": "confirmed"}]`
- **Response:**
  ```json
  {
    "jsonrpc": "2.0",
    "result": { "context": { "slot": 312894102 }, "value": 12540000000 },
    "id": 1
  }
  ```

### 2.2. `sendTransaction`
- **Method:** `POST /`
- **Params:** `["<SIGNED_BASE64_TRANSACTION_PAYLOAD>", {"encoding": "base64", "preflightCommitment": "confirmed"}]`
- **Response:**
  ```json
  {
    "jsonrpc": "2.0",
    "result": "5YgqT9N2Z...88CharSignatureString",
    "id": 2
  }
  ```

### 2.3. `getTransaction` (Verification Call)
- **Method:** `POST /`
- **Params:** `["<SIGNATURE>", {"encoding": "jsonParsed", "commitment": "confirmed", "maxSupportedTransactionVersion": 0}]`
- **Response Attributes Verified by Client:**
  - `result.meta.err == null`
  - `result.transaction.message.instructions[*].parsed.type == "transfer"`
  - `result.transaction.message.instructions[*].parsed.info.destination == <EXPECTED_RECIPIENT>`
  - `result.transaction.message.instructions[*].parsed.info.lamports == <EXPECTED_LAMPORTS>`

---

## 3. Future Cloud Synchronization API (FastAPI / Supabase Blueprint)

For multi-device synchronization and remote backup:

### 3.1. `POST /api/v1/sync/push`
Pushes local change events to central server.
- **Headers:** `Authorization: Bearer <SUPABASE_JWT>`, `X-Merchant-ID: <UUID>`
- **Request:**
  ```json
  {
    "client_id": "device_pixel7_01",
    "last_synced_rev": 142,
    "mutations": [
      {
        "entity": "transaction",
        "op": "insert",
        "idempotency_key": "tx_20261108_94821",
        "data": {
          "kind": "sale",
          "amount_paise": 24000,
          "method": "cash",
          "occurred_at": "2026-11-08T14:30:00Z"
        }
      }
    ]
  }
  ```

### 3.2. `GET /api/v1/sync/pull`
Fetches server-side revisions since `since_rev`.
- **Query Params:** `?since_rev=142&limit=500`
- **Response:**
  ```json
  {
    "current_rev": 150,
    "has_more": false,
    "changes": []
  }
  ```

