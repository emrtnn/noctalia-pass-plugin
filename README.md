# Pass

Launcher integration for `pass` (the standard Unix password manager).

## How to use

1. Open the Noctalia launcher and type `/pass`.
2. The background service scans your pass store periodically and reflects changes.
3. To copy a password, select an entry. It will be copied using `pass -c`.
4. To copy an OTP code, type `/pass otp <query>` and select the entry you know has an
OTP URI configured.
5. If the pass store is locked, a terminal will open so you can enter your passphrase.


## Features

- 🔑 Fuzzy search your password store
- 📋 Copy passwords using `pass -c`
- 🔢 Copy OTP codes using `pass otp -c`
- ⚡ Cached index for instant search
- 🔒 Never stores passwords in memory

## Requirements

- pass
- pass-otp
- gpg

## Installation

```sh
noctalia msg plugins source add emrtnn git https://github.com/emrtnn/noctalia-pass-plugin
