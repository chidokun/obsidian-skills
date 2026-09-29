---
name: obsidian-notes
description: >-
  Ghi note Obsidian đúng convention (frontmatter, template, link).
  Dùng khi lưu research, decision, learn note, daily log vào vault.
---

# Obsidian Notes

## Mục tiêu

Agent **ghi note đúng format** vào vault người dùng chỉ định.

## Config

Đọc `config.local.yaml`:

- `obsidian.vault_path`
- `obsidian.notes_folder` (mặc định `Notes`)

Nếu chưa có config → hỏi đường dẫn vault, đừng đoán.

## Convention

1. Dùng template trong thư mục `templates/` cạnh skill này:
   - `research.md` · `decision.md` · `learn.md` · `daily.md`
2. Frontmatter tối thiểu:

```yaml
---
title: "…"
date: YYYY-MM-DD
tags: […]
---
```

3. Tên file: `YYYY-MM-DD-slug-ngan.md` (ASCII slug).
4. Path: `{vault_path}/{notes_folder}/{loai}/` với `loai` ∈ `research|decisions|learn|daily`.
5. Link nội bộ Obsidian: `[[ten-note]]` khi biết note liên quan.

## Quy trình

1. Xác định loại note + template.
2. Điền nội dung từ kết quả task (research / decision / learn).
3. Ghi file vào đúng path (tạo thư mục nếu thiếu).
4. Báo lại path đầy đủ cho người dùng.

## Cấm

- Ghi đè note không hỏi
- Commit nội dung vault vào repo dự án đang làm việc
- Đưa secret vào note
