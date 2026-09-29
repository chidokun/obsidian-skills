---
name: "obsidian-doc-to-note"
description: "Chuyển đổi tài liệu (PDF, trang web, bài viết, văn bản thô) thành ghi chú Obsidian có cấu trúc. Dùng khi người dùng muốn lưu tài liệu thành note, tạo note từ URL hoặc file hoặc text cho sẵn, hoặc nói 'lưu thành note', 'tạo note', 'tóm tắt tài liệu này'. Cờ --book cho sách/khóa học nhiều chương, --doc (mặc định) cho tài liệu thường."
argument-hint: "[--book|--doc] <URL | đường dẫn file | văn bản>"
allowed-tools: [Read, Write, Glob, WebFetch, Bash(find *)]
---

## Mục tiêu

Chuyển đổi tài liệu (PDF, trang web, bài viết, văn bản) thành ghi chú markdown tương thích Obsidian, tuân theo nguyên tắc Zettelkasten và lưu vào Vault.

## Khi nào dùng

- Muốn lưu PDF hoặc trang web thành ghi chú
- Muốn tổ chức nội dung tài liệu vào Obsidian Vault
- Muốn tóm tắt bài viết hoặc tài liệu thành note

## Khi nào KHÔNG dùng

- Tài liệu hóa code.
- Tạo changelog.

## Tham số

Cờ đặt ở bất kỳ vị trí nào trong `$ARGUMENTS`, phần còn lại là nguồn (URL, đường dẫn file hoặc văn bản).

| Cờ | Ý nghĩa | Cấu trúc note |
|---|---|---|
| `--doc` (mặc định) | Tài liệu thường: bài viết, trang web, văn bản, PDF ngắn | Atomic notes, không có MOC chương |
| `--book` | Sách (hoặc khóa học) có nhiều chương | MOC lớn + MOC từng chương + atomic notes |

- Không có cờ → coi là `--doc`. Không tự đoán là sách.
- Có cả `--book` và `--doc` → hỏi lại người dùng muốn dùng cờ nào.

Ví dụ:

- `https://example.com/bai-viet`
- `--book ~/Downloads/atomic-habits.pdf`
- `--doc ghi-chu.txt`

## Nguyên tắc Zettelkasten

Tuân theo [nguyên tắc Zettelkasten](../../docs/Zettelkasten-Principles.md): mỗi note một ý (atomic), viết bằng lời của mình, chủ động gắn `[[wiki-link]]` tới note đã có trong Vault.

## Giá trị mặc định cho frontmatter

Nếu không tìm thấy file `[[Hướng dẫn sử dụng]]` trong Vault, dùng giá trị mặc định:
- `type`: `input`
- `status`: `seed`

## Hướng dẫn

Chuyển đổi `$ARGUMENTS` (URL, đường dẫn file, hoặc nội dung văn bản, kèm cờ `--book` hoặc `--doc`) thành ghi chú.

### Bước 1 — Phân tích đầu vào

- Tách cờ `--book` / `--doc` ra khỏi `$ARGUMENTS` (mặc định `--doc`), phần còn lại là nguồn
- URL → dùng WebFetch lấy nội dung
- Đường dẫn file → dùng Read
- Văn bản thô → dùng trực tiếp

### Bước 2 — Chọn cấu trúc note theo cờ

| Cờ | Loại tài liệu | Cấu trúc note |
|---|---|---|
| `--book` | Sách / khóa học có nhiều chương | MOC lớn + MOC từng chương + atomic notes |
| `--doc` | Bài viết / trang web đơn lẻ | Atomic notes (không cần MOC) |
| `--doc` | Đoạn văn bản ngắn | Một atomic note duy nhất |

Cờ quyết định cấu trúc, không suy đoán lại từ nội dung. Nếu với `--book` không tách được chương, hỏi người dùng thay vì chuyển sang `--doc`.

### Bước 3 — Tìm liên kết trong Vault

Với mỗi ý tưởng/khái niệm quan trọng trong nội dung, dùng Grep tìm file `.md` trong Vault có tên hoặc nội dung khớp keyword đó. Chỉ gắn `[[wiki-link]]` khi tìm thấy note thực sự liên quan — không tạo link tới note không tồn tại.

### Bước 4 — Viết và lưu note

- Nếu xác định chỉ có 1 note thì không tạo thư mục tài liệu, chỉ lưu note.
- Nếu xác định có nhiều note thì tạo 1 thư mục tên tài liệu, lưu tất cả note vào đó (phẳng, không có thư mục con).
- Người dùng sẽ tự chuyển sang thư mục phù hợp sau khi kiểm tra.

### Bước 5 — Kiểm tra lại

- Đọc lại mục lục, kiểm tra lại với các note xem đã đầy đủ và đúng chưa.

### Quy tắc đặt tên file

- Dùng tiếng Việt, viết thường, không dấu gạch ngang hay underscore
- Ngắn gọn, đủ nghĩa, không có ký tự đặc biệt `/ \ : * ? " < > |`
- Tên phản ánh **ý tưởng**, không phải số chương hay vị trí trong tài liệu

| Loại | Ví dụ đúng | Ví dụ sai |
|---|---|---|
| MOC lớn | `Atomic Habits` | `atomic_habits_book` |
| MOC chương | `Atomic Habits - Bản sắc quyết định hành vi` | `Chương 2` |
| Atomic note | `Thay đổi nhỏ tạo ra kết quả lớn` | `note_001_chapter2_idea` |

### Quy tắc chia tách note

- Tuân theo nguyên tắc Zettelkasten.
- Các bài tập, trắc nghiệm, checklist, đề xuất được đề cập trong tài liệu cần được tách riêng ra thành 1 note và liên kết vào MOC chương tương ứng.

### Định dạng đầu ra

`MOC lớn` và `MOC chương` chỉ dùng với `--book`. Với `--doc` chỉ dùng `Atomic note`.

**MOC lớn** — tên file: `tên quyển sách/khóa học/tài liệu`

Lưu ý:
- Nếu là sách: sử dụng template `[[Book Highlights]]` thay thế
- Nếu là khóa học: sử dụng template `[[Course Highlights]]` thay thế

~~~markdown
---
type: input
related: []
status: seed
tags:
  - {{book hoặc course}}
---

# {{tên quyển sách/khóa học/tài liệu}}

{{Mô tả ngắn về tài liệu}}

## Mục lục

- [[tên tài liệu - Chương 1|Chương 1: Tên chương]]
- [[tên tài liệu - Chương 2|Chương 2: Tên chương]]
~~~

**MOC chương** — tên file: `tên tài liệu - Tên chương`

~~~markdown
---
alias: "{{Tên chương}}"
type: input
related:
  - "[[tên tài liệu]]"
status: seed
---

# {{Tên chương}}

{{Mô tả ngắn về chương}}

## Các ý chính

- [[tên ý tưởng 1]]
- [[tên ý tưởng 2]]
~~~

**Atomic note** — tên file: `tiêu đề ngắn gọn diễn đạt một ý tưởng`

~~~markdown
---
type: input
related:
  - "[[MOC chương hoặc tài liệu gốc]]"
  - "[[note liên quan khác]]"
status: seed
---

# {{Tiêu đề ngắn gọn}}

{{Nội dung diễn đạt bằng lời của mình — một ý tưởng duy nhất}}
~~~
