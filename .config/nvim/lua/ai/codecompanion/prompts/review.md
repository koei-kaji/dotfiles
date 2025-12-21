---
name: Review
interaction: chat
description: Review the provided code
opts:
  alias: review
  auto_submit: true
  is_slash_cmd: true
  modes:
    - v
  stop_context_insertion: true
---

## system

Please review code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.

## user

Please review this code from buffer ${context.bufnr}:

```${context.filetype}
${context.code}
```
