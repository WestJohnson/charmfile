# Third-party notices

Charmfile includes or adapts permissively licensed agent skills. The upstream
projects are not affiliated with or responsible for Charmfile.

## Microsoft Playwright CLI

Source: <https://github.com/microsoft/playwright-cli>

Charmfile adapts the upstream `playwright-cli` skill with a pinned installer,
macOS-only platform boundary, and explicit separation between isolated
automation and signed-in Chrome. The `playwright-live-chrome` wrapper adds a
macOS Keychain handshake, explicit session naming, and live-account safety
boundaries. The Chrome extension itself is not bundled.

Playwright CLI is licensed under the Apache License 2.0, reproduced in this
repository's `LICENSE`.

Copyright (c) Microsoft Corporation

## Addy Osmani Agent Skills

Source: <https://github.com/addyosmani/agent-skills>

Charmfile's `frontend-ui-engineering` skill began from the upstream
`frontend-ui-engineering` skill and was modified with Chrome-first
verification, stricter mobile QA, Codex workflow boundaries, and a smaller
art-direction contract.

MIT License

Copyright (c) 2025 Addy Osmani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Impeccable

Source: <https://github.com/pbakaus/impeccable>

The compact art-direction workflow in `frontend-ui-engineering` is informed by
Impeccable 4.0.2 and modified for Charmfile. Impeccable is licensed under the
Apache License 2.0, reproduced in this repository's `LICENSE`.

## CloudAI-X Three.js Skills

Source: <https://github.com/CloudAI-X/threejs-skills>

The ten skills in `charmfile-threejs` are distributed from the upstream
collection. The upstream README declares the collection MIT licensed and does
not currently provide a separate license file or copyright notice.

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

This permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Codex Obsidian Sidecar

Source: <https://ai.westhawaiimarketing.com/charmfile/git/codex-obsidian-sidecar.git>

Charmfile bundles the Sidecar setup skill, not the Sidecar runtime. The setup
skill is distributed under the Sidecar's MIT license.

MIT License

Copyright (c) 2026 Codex Obsidian Sidecar contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
