---
name: "obsidian-explain-to-note"
description: "Giải thích khái niệm/từ khóa/yêu cầu cụ thể qua tìm kiếm web, rồi chuyển thành ghi chú Obsidian atomic có liên kết. Dùng khi muốn học và lưu concept thành note, nói 'giải thích X thành note', 'tìm hiểu Y', 'ghi chú về Z' — không cần tài liệu gốc."
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch, Bash(find *)]
---

## Mục tiêu

Nhận **khái niệm, từ khóa, hoặc yêu cầu cụ thể** (không cần tài liệu sẵn có), tìm kiếm web để hiểu, giải thích bằng lời của mình, rồi lưu thành ghi chú markdown atomic tương thích Obsidian — tuân theo Zettelkasten và liên kết với Vault hiện có.

## Khi nào dùng

- Muốn học một khái niệm mới và lưu thành note có cấu trúc
- Có từ khóa hoặc câu hỏi cụ thể, chưa có tài liệu nguồn
- Muốn mở rộng kiến thức từ một chủ đề thành mạng note liên kết

## Khi nào KHÔNG dùng

- Đã có tài liệu gốc (PDF, URL, file) → dùng `obsidian-doc-to-note`
- Chỉ cần giải thích nhanh trong chat, không lưu note → dùng `learn`
- Tài liệu hóa code hoặc changelog

## Đầu vào

Parse từ `$ARGUMENTS`:

| Tham số | Mô tả | Mặc định |
|---|---|---|
| **Chủ đề** | Khái niệm, từ khóa, hoặc yêu cầu cụ thể | (bắt buộc) |
| **effort** | Mức độ sâu: `low` · `medium` · `high` | `low` |

Ví dụ:
- `CAP theorem`
- `event sourcing effort:medium`
- `giải thích cách Raft đạt consensus effort:high`

Nếu thiếu chủ đề → hỏi người dùng trước khi tiếp tục.

## Mức độ sâu (effort)

### `low` (mặc định)

- Tìm kiếm web **chỉ** cho chủ đề được yêu cầu
- Tạo MOC chủ đề + các atomic note cần thiết để giải thích đủ hiểu cơ bản
- Không chủ động mở rộng sang khái niệm phụ trừ khi không thể giải thích chủ đề mà không nhắc tới

### `medium`

- Tìm kiếm web cho chủ đề chính
- Trong quá trình viết note: nếu nhận thấy cần giải thích chuyên sâu một khái niệm phụ → **tìm kiếm web thêm** và tạo atomic note riêng
- MOC liệt kê đầy đủ các note con, kể cả note phụ sinh ra trong quá trình viết

### `high`

- Tìm kiếm web **rất chuyên sâu**: nhiều nguồn, góc nhìn khác nhau, edge case, so sánh với khái niệm liên quan
- Giải thích chi tiết, có ví dụ cụ thể
- Mỗi atomic note (hoặc MOC) có thể có mục **Mẹo ghi nhớ** — analogy, câu hỏi tự kiểm, hoặc mẹo tránh nhầm lẫn
- Chủ động tạo note phụ cho mọi khái niệm nền tảng cần thiết để hiểu chủ đề

## Nguyên tắc Zettelkasten

Mỗi note phải tuân theo các nguyên tắc sau:

- **Tính nguyên tử (Atomic)**: Mỗi note chỉ chứa **một ý tưởng duy nhất**. Chủ đề phức tạp → tách thành nhiều note riêng biệt.
- **Viết bằng lời của mình**: Không copy nguyên văn từ web. Tổng hợp và diễn đạt lại — người dùng sẽ edit sau.
- **Liên kết (Linking)**: Chủ động tìm và gắn `[[wiki-link]]` đến các note đã có trong Vault liên quan đến ý tưởng.
- **Ghi nguồn**: Cuối mỗi note, thêm mục `## Nguồn tham khảo` với URL đã dùng (không paste nguyên văn).

## Giá trị mặc định cho frontmatter

Nếu không tìm thấy file `[[Hướng dẫn sử dụng]]` trong Vault, dùng giá trị mặc định:
- `type`: `input`
- `status`: `seed`

## Hướng dẫn

Giải thích và chuyển `$ARGUMENTS` thành ghi chú.

### Bước 1 — Xác định chủ đề và effort

- Tách chủ đề và `effort` từ đầu vào
- Nếu chủ đề mơ hồ → hỏi làm rõ phạm vi trước khi tìm kiếm

### Bước 2 — Tìm kiếm web

- Dùng **WebSearch** để tìm nguồn uy tín (docs chính thức, bài viết kỹ thuật, Wikipedia)
- Dùng **WebFetch** đọc chi tiết 2–4 nguồn phù hợp nhất
- Số lượng tìm kiếm theo effort:

| effort | Tìm kiếm ban đầu | Tìm kiếm bổ sung |
|---|---|---|
| `low` | 1–2 query | Không |
| `medium` | 2–3 query | Thêm khi viết note phát hiện gap |
| `high` | 3–5 query | Nhiều query cho chủ đề chính + từng khái niệm phụ |

### Bước 3 — Lập kế hoạch cấu trúc note

| Độ phức tạp chủ đề | Cấu trúc note |
|---|---|
| Khái niệm đơn giản, một ý | Một atomic note duy nhất |
| Khái niệm có vài khía cạnh | MOC chủ đề + atomic notes |
| Chủ đề rộng, nhiều khái niệm liên quan | MOC chủ đề + atomic notes + (medium/high) note phụ |

Đặt tên thư mục theo chủ đề chính (viết thường, không dấu, ngắn gọn).

### Bước 4 — Tìm liên kết trong Vault

Với mỗi ý tưởng/khái niệm quan trọng, dùng Grep tìm file `.md` trong Vault có tên hoặc nội dung khớp keyword. Chỉ gắn `[[wiki-link]]` khi tìm thấy note thực sự liên quan — không tạo link tới note không tồn tại.

### Bước 5 — Viết và lưu note

- Tạo 1 thư mục tên chủ đề, lưu tất cả note vào đó (phẳng, không có thư mục con)
- Người dùng sẽ tự chuyển sang thư mục phù hợp sau khi kiểm tra
- Với `effort:high`: thêm mục **Mẹo ghi nhớ** vào MOC hoặc từng atomic note

### Bước 6 — Kiểm tra lại

- Đọc lại MOC (nếu có), kiểm tra các atomic note đã đủ và đúng chưa
- Xác nhận mọi `[[wiki-link]]` trỏ tới note tồn tại hoặc note vừa tạo trong cùng batch
- Với `medium`/`high`: kiểm tra không còn khái niệm quan trọng bị nhắc tới mà chưa có note riêng

### Quy tắc đặt tên file

- Dùng tiếng Việt, viết thường, không dấu gạch ngang hay underscore
- Ngắn gọn, đủ nghĩa, không có ký tự đặc biệt `/ \ : * ? " < > |`
- Tên phản ánh **ý tưởng**, không phải thuật ngữ tiếng Anh thuần (trừ khi đó là tên riêng phổ biến)

| Loại | Ví dụ đúng | Ví dụ sai |
|---|---|---|
| MOC chủ đề | `CAP theorem` | `cap_theorem_notes` |
| Atomic note | `Hệ thống phân tán chỉ đảm bảo được hai trong ba` | `note_cap_001` |
| Note phụ | `Tính nhất quán trong CAP` | `consistency_chapter` |

### Quy tắc chia tách note

- Tuân theo nguyên tắc Zettelkasten như ở trên
- Định nghĩa, nguyên lý, ví dụ, so sánh, mẹo ghi nhớ — mỗi loại có thể là note riêng nếu đủ dài
- Với `effort:low`: gộp nhẹ nếu chủ đề thực sự chỉ có một ý

### Định dạng đầu ra

**MOC chủ đề** — tên file: `tên chủ đề`

~~~markdown
---
type: input
related: []
status: seed
---

# {{Tên chủ đề}}

{{Mô tả ngắn — chủ đề này là gì, tại sao quan trọng}}

## Các ý chính

- [[tên ý tưởng 1]]
- [[tên ý tưởng 2]]

## Mẹo ghi nhớ

{{Chỉ với effort:high — analogy, câu hỏi tự kiểm, hoặc mẹo tránh nhầm}}

## Nguồn tham khảo

- [Tên nguồn](URL)
~~~

**Atomic note** — tên file: `tiêu đề ngắn gọn diễn đạt một ý tưởng`

~~~markdown
---
type: input
related:
  - "[[MOC chủ đề]]"
  - "[[note liên quan khác]]"
status: seed
---

# {{Tiêu đề ngắn gọn}}

{{Nội dung diễn đạt bằng lời của mình — một ý tưởng duy nhất}}

## Ví dụ

{{Ví dụ cụ thể — bắt buộc với effort:medium và effort:high}}

## Mẹo ghi nhớ

{{Chỉ với effort:high}}

## Nguồn tham khảo

- [Tên nguồn](URL)
~~~

**Atomic note đơn** (chủ đề đơn giản, không cần MOC) — dùng cùng template atomic note ở trên, bỏ `related` tới MOC nếu không có.

## So sánh với skill liên quan

| | `obsidian-doc-to-note` | `obsidian-explain-to-note` | `learn` |
|---|---|---|---|
| Đầu vào | Tài liệu có sẵn | Khái niệm / từ khóa | Khái niệm |
| Nguồn | Tài liệu gốc | Web search | Kiến thức agent + web nhẹ |
| Output | Note trong Vault | Note trong Vault | Chat + (tuỳ chọn) note |
| Mức sâu | Theo tài liệu | `effort: low/medium/high` | Feynman tương tác |
