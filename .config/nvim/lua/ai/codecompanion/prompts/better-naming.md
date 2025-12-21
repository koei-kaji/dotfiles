---
name: Better Naming
interaction: chat
description: Give better naming for the provided code
opts:
  alias: naming
  auto_submit: true
  is_slash_cmd: true
  modes:
    - v
  stop_context_insertion: true
---

## system

Please provide better names for the following variables and functions.

## user

Please provide better naming for this code from buffer ${context.bufnr}:

```${context.filetype}
${context.code}
```
