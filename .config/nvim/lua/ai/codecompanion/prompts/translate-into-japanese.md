---
name: Translate into Japanese
interaction: chat
description: Translate into Japanese
opts:
  alias: translate
  auto_submit: true
  is_slash_cmd: true
  modes:
    - v
  stop_context_insertion: true
---

## system

Please translate into Japanese.

## user

Please translate this from buffer ${context.bufnr}:

```${context.filetype}
${context.code}
```
