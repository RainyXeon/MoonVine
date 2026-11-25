# MoonVine's Discord Internal SDK

This is MoonVine's Discord Internal SDK. The "internal" word here's to describe this library is not recommended to use
outside the MoonVine repository. Although with some modification, it can.

THIS LIBRARY IS UNDER HEAVY DEVELOPMENT!!!

## To-do List
- [x] HTTP API
  - Common endpoints and typed payloads are implemented; this is not an exhaustive wrapper for every Discord REST route. Gateway dispatch exposes typed decoding for event payloads, with reconnect/heartbeat scheduling owned by the caller.
  - [x] Application
  - [x] Application Identity Profile
  - [x] Application Role Connection Metadata
  - [x] Audit Log
  - [x] Auto Moderation
  - [x] Channel
  - [x] Emoji
  - [x] Entitlement
  - [x] Guild
  - [x] Guild Scheduled Event
  - [x] Guild Template
  - [x] Invite
  - [x] Lobby
  - [x] Message
  - [x] Poll
  - [x] SKU
  - [x] Soundboard
  - [x] Stage Instance
  - [x] Sticker
  - [x] Subscription
  - [x] User
  - [ ] Voice
  - [ ] Webhook
- [x] Events (WebSocket / Gateway)
  - [x] Lifecycle & Connection
    - [x] Hello
    - [x] Ready
    - [x] Resumed
    - [x] Reconnect
    - [x] Invalid Session
    - [x] Heartbeat / Heartbeat ACK
  - [x] Application & Entitlements
    - [x] Application Command Permissions Update
    - [x] Entitlement Create / Update / Delete
    - [x] Subscription Create / Update / Delete
  - [x] Auto Moderation
    - [x] Auto Moderation Rule Create / Update / Delete
    - [x] Auto Moderation Action Execution
  - [x] Channels & Threads
    - [x] Channel Create / Update / Delete
    - [x] Channel Pins Update
    - [x] Thread Create / Update / Delete
    - [x] Thread List Sync
    - [x] Thread Member Update
    - [x] Thread Members Update
  - [x] Guilds, Roles & Emojis
    - [x] Guild Create / Update / Delete
    - [x] Guild Audit Log Entry Create
    - [x] Guild Ban Add / Remove
    - [x] Guild Emojis Update
    - [x] Guild Stickers Update
    - [x] Guild Integrations Update
    - [x] Guild Member Add / Update / Remove
    - [x] Guild Members Chunk
    - [x] Guild Role Create / Update / Delete
    - [x] Guild Scheduled Event Create / Update / Delete
    - [x] Guild Scheduled Event User Add / Remove
    - [x] Guild Soundboard Sound Create / Update / Delete
    - [x] Guild Soundboard Sounds Update
    - [x] Soundboard Sounds
  - [x] Integrations & Webhooks
    - [x] Integration Create / Update / Delete
    - [x] Webhooks Update
  - [x] Interactions & Invites
    - [x] Interaction Create
    - [x] Invite Create / Delete
  - [x] Messages & Polls
    - [x] Message Create / Update / Delete
    - [x] Message Delete Bulk
    - [x] Message Reaction Add / Remove / Remove All / Remove Emoji
    - [x] Message Poll Vote Add / Remove
  - [x] Presence, Typing & Users
    - [x] Presence Update
    - [x] Typing Start
    - [x] User Update
  - [x] Voice & Stage
    - [x] Voice Channel Effect Send
    - [x] Voice State Update
    - [x] Voice Server Update
    - [x] Stage Instance Create / Update / Delete
- [ ] Voice
  - [ ] Connect to Voice (Gateway OP 4 Voice State Update & Server Update)
  - [ ] Establishing a Voice WebSocket Connection
  - [ ] Heartbeating
  - [ ] Establishing a Voice UDP Connection
  - [ ] IP Discovery
  - [ ] Select Protocol & Transport Encryption (AEAD AES256-GCM / XChaCha20-Poly1305)
  - [ ] E2EE (DAVE Protocol / MLS Key Exchange)
  - [ ] Opus Encoder
  - [ ] Voice Encrypt and Send (RTP Packetization)

## License

This library is licensed under `LGPL-3.0`