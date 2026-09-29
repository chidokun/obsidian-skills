---
name: "obsidian-feynman-learn"
description: "Học một khái niệm bằng kỹ thuật Feynman: người dùng tự giải thích bằng ngôn ngữ đơn giản, agent đóng vai người học tò mò để lộ chỗ chưa hiểu, lặp lại đến khi giải thích trôi chảy, rồi lưu thành ghi chú Obsidian atomic có liên kết. Dùng khi nói 'để tôi giải thích X', 'học X kiểu Feynman', 'kiểm tra xem tôi giải thích X có đơn giản chưa'."
argument-hint: "<khái niệm / chủ đề>"
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch, Bash(find *)]
---

## Mục tiêu

Giúp người dùng **kiểm tra và củng cố hiểu biết** về một khái niệm bằng kỹ thuật Feynman: người dùng tự giải thích bằng ngôn ngữ đơn giản như đang dạy người mới, agent đóng vai người học tò mò để lộ ra chỗ mơ hồ, chỗ nhảy bước, chỗ sai. Sau vài vòng chỉnh sửa, lưu bản giải thích cuối cùng của người dùng thành ghi chú markdown atomic tương thích Obsidian — tuân theo Zettelkasten và liên kết với Vault hiện có.

## Khi nào dùng

- Cảm thấy đã hiểu một khái niệm nhưng chưa chắc giải thích được
- Vừa đọc/học xong và muốn kiểm tra hiểu biết trước khi lưu note
- Muốn có note viết bằng lời đơn giản của chính mình, kèm analogy dễ nhớ

## Khi nào KHÔNG dùng

- Chưa biết gì về chủ đề, muốn được dẫn dắt từng bước → dùng `obsidian-socratic-learn`
- Chỉ cần đọc lời giải thích và lưu note → dùng `obsidian-explain-to-note`
- Đã có tài liệu gốc (PDF, URL, file) → dùng `obsidian-doc-to-note`
- Chỉ cần giải thích nhanh trong chat, không lưu note → dùng `learn`
- Tài liệu hóa code hoặc changelog

## Đầu vào

Parse từ `$ARGUMENTS`:

| Tham số | Mô tả | Mặc định |
|---|---|---|
| **Chủ đề** | Khái niệm muốn tự giải thích | (bắt buộc) |

Ví dụ:
- `CAP theorem`
- `event sourcing`
- `cách Raft đạt consensus`

Nếu thiếu chủ đề → hỏi người dùng trước khi tiếp tục. Nếu chủ đề quá rộng → hỏi thu hẹp về một khái niệm đủ giải thích trong vài đoạn.

## Nguyên tắc Zettelkasten

Tuân theo [nguyên tắc Zettelkasten](../../docs/Zettelkasten-Principles.md): mỗi note một ý (atomic), viết bằng lời của mình, chủ động gắn `[[wiki-link]]` tới note đã có trong Vault. "Lời của mình" ở đây là **lời của người dùng** ở vòng giải thích cuối, chỉ sửa khi sai. Ngoài ra, skill này có thêm các nguyên tắc riêng:

- **Người dùng giải thích trước**: Không giải thích chủ đề thay người dùng trước khi họ thử. Chỉ giải thích khi họ yêu cầu sau khi đã thử ít nhất một lần.
- **Không ghi điều sai vào note**: Chỗ sai phải được chỉnh trong buổi học và ghi dưới dạng "chỗ từng vấp", không ghi như một khẳng định.
- **Ghi nguồn**: Cuối mỗi note, thêm mục `## Nguồn tham khảo` với URL đã dùng để kiểm chứng (không paste nguyên văn).

## Giá trị mặc định cho frontmatter

Nếu không tìm thấy file `[[Hướng dẫn sử dụng]]` trong Vault, dùng giá trị mặc định:
- `type`: `input`
- `status`: `seed`

## Hướng dẫn

Dẫn dắt người dùng tự giải thích `$ARGUMENTS`, rồi chuyển kết quả thành ghi chú. Đây là skill **tương tác nhiều lượt**: mỗi lượt xong thì dừng lại chờ người dùng. Dùng ngôn ngữ của người dùng (mặc định tiếng Việt).

### Bước 1 — Xác định chủ đề và đối tượng giải thích

- Tách chủ đề từ đầu vào, hỏi làm rõ nếu mơ hồ hoặc quá rộng
- Hỏi (hoặc mặc định) **đối tượng tưởng tượng** mà người dùng sẽ giải thích cho: mặc định là *người hoàn toàn mới, thông minh, không có kiến thức nền* (như một học sinh cấp 2)

### Bước 2 — Chuẩn bị (không hiển thị cho người dùng)

- Kiểm tra trong vault đã có các note liên quan chưa, nếu có thì sử dụng các note trong vault.
- Cũng dùng **WebSearch** tìm nguồn uy tín (docs chính thức, bài kỹ thuật, Wikipedia), dùng **WebFetch** đọc chi tiết 1–3 nguồn phù hợp nhất. Mục đích là để **agent làm thước đo đúng/sai**, không phải để giảng lại.
- Lập nhanh danh sách 3–6 ý cốt lõi mà một lời giải thích đầy đủ phải chạm tới, cùng các hiểu lầm phổ biến. Giữ nội bộ.

### Bước 3 — Người dùng giải thích lần đầu

Mời người dùng giải thích chủ đề như đang dạy đối tượng ở Bước 1, với các quy ước:

- Không nhìn tài liệu
- Tránh thuật ngữ; nếu buộc phải dùng thì tự giải thích thuật ngữ đó
- Không cần hoàn hảo — chỗ bí cũng là thông tin có giá trị

Sau đó dừng chờ.

### Bước 4 — Agent đóng vai người học tò mò

Nhập vai đối tượng đã chọn. Trong vai này:

- Chỉ đặt câu hỏi ngây thơ, chân thành: "X nghĩa là gì?", "Tại sao lại thế?", "Sao từ đoạn này lại ra đoạn kia?", "Cho mình ví dụ được không?"
- **Không** sửa lỗi hay bổ sung kiến thức trong vai; **không** dùng kiến thức mà đối tượng không thể có
- Mỗi lượt hỏi 1–2 câu tại đúng chỗ mơ hồ nhất, rồi chờ người dùng trả lời
- Khoảng 2–4 lượt là đủ để lộ các khoảng trống chính

**Ghi nhớ nội bộ** các loại khoảng trống:

| Loại | Dấu hiệu |
|---|---|
| Thuật ngữ chưa giải thích | Dùng từ chuyên ngành như thể ai cũng biết |
| Nhảy bước | Kết luận không có lý do dẫn tới nó |
| Vòng luẩn quẩn | Định nghĩa dùng chính từ đang định nghĩa |
| Mơ hồ | Nói chung chung, không có ví dụ cụ thể |
| Sai | Mâu thuẫn với nguồn đã kiểm chứng |
| Thiếu ý cốt lõi | Bỏ qua một ý trong danh sách ở Bước 2 |

### Bước 5 — Báo cáo khoảng trống

Thoát vai và nói rõ là đã thoát vai. Trình bày ngắn gọn, cụ thể:

- ✅ **Giải thích tốt**: những chỗ rõ ràng, đúng (nêu cụ thể)
- ⚠️ **Thuật ngữ / chỗ mơ hồ** cần làm rõ
- ❓ **Chỗ nhảy bước** cần bổ sung
- ❌ **Chỗ sai**, kèm cách hiểu đúng ngắn gọn dựa trên nguồn
- 🧩 **Ý cốt lõi còn thiếu** (nếu có)

Không liệt kê quá 5 mục cần sửa mỗi vòng — chọn những mục ảnh hưởng nhiều nhất. Rồi hỏi người dùng chọn: **tự thử sửa** hay **nhờ agent giải thích** phần còn thiếu. Nếu nhờ giải thích, dùng analogy và ví dụ cụ thể, ngắn gọn, không đọc lại toàn bộ chủ đề.

### Bước 6 — Giải thích lại (lặp)

Mời người dùng giải thích lại phần đã sửa, hoặc toàn bộ, **đơn giản hơn**. Quay lại Bước 4–5 nếu còn khoảng trống đáng kể.

- Tối đa khoảng 3 vòng. Nếu vẫn còn vướng, đề nghị người dùng học thêm (gợi ý `obsidian-socratic-learn` hoặc `obsidian-explain-to-note`) rồi quay lại sau, và ghi phần còn vướng vào "câu hỏi còn mở"
- Dừng ngay khi người dùng giải thích trôi chảy và đúng, đừng kéo dài

### Bước 7 — Chốt: một câu và một analogy

Yêu cầu người dùng viết:

1. **Tóm tắt một câu** cho khái niệm
2. **Một analogy** với thứ quen thuộc trong đời sống

Nếu người dùng chưa nghĩ ra analogy, đưa 2–3 gợi ý để họ chọn hoặc sửa. Kiểm tra analogy không dẫn tới hiểu sai (nêu chỗ analogy không còn đúng nếu có).

### Bước 8 — Tìm liên kết trong Vault

Với mỗi ý quan trọng, dùng Grep tìm file `.md` trong Vault có tên hoặc nội dung khớp keyword. Chỉ gắn `[[wiki-link]]` khi tìm thấy note thực sự liên quan — không tạo link tới note không tồn tại.

### Bước 9 — Viết và lưu note

- Hỏi người dùng có muốn lưu lại note hay không, nếu không thì bỏ qua và kết thúc.
- Nội dung note là **bản giải thích cuối cùng của người dùng** (vòng gần nhất), chỉ chỉnh cho đúng và gọn; không thay bằng giải thích của agent
- Khái niệm nhỏ, một ý → một atomic note, không tạo thư mục, chỉ lưu note
- Khái niệm nhiều ý → mỗi ý một atomic note; từ 3 note trở lên thì tạo MOC chủ đề và 1 thư mục tên chủ đề (viết thường, không dấu, ngắn gọn), lưu tất cả note vào đó (phẳng, không có thư mục con)
- Người dùng sẽ tự chuyển sang thư mục phù hợp sau khi kiểm tra
- Mục **Chỗ từng vấp** ghi lại các khoảng trống đã lộ ra (để ôn lại và tránh vấp lại)

### Bước 10 — Kiểm tra lại

- Đọc lại các note: không có khẳng định sai, mỗi note chỉ một ý, không còn thuật ngữ chưa giải thích
- Xác nhận mọi `[[wiki-link]]` trỏ tới note tồn tại hoặc note vừa tạo trong cùng batch
- Báo cho người dùng danh sách note đã tạo và đường dẫn

### Quy tắc đặt tên file

- Dùng tiếng Việt, viết thường, không dấu gạch ngang hay underscore
- Ngắn gọn, đủ nghĩa, không có ký tự đặc biệt `/ \ : * ? " < > |`
- Tên phản ánh **ý tưởng**, không phải thuật ngữ tiếng Anh thuần (trừ khi đó là tên riêng phổ biến)

| Loại | Ví dụ đúng | Ví dụ sai |
|---|---|---|
| MOC chủ đề | `CAP theorem` | `cap_theorem_notes` |
| Atomic note | `Hệ thống phân tán chỉ đảm bảo được hai trong ba` | `note_cap_001` |

### Định dạng đầu ra

**MOC chủ đề** (chỉ khi có từ 3 atomic note trở lên) — tên file: `tên chủ đề`

~~~markdown
---
type: input
related: []
status: seed
---

# {{Tên chủ đề}}

{{Tóm tắt một câu của người dùng}}

## Các ý chính

- [[tên ý tưởng 1]]
- [[tên ý tưởng 2]]

## Câu hỏi còn mở

- {{Những điểm còn vướng sau buổi học, nếu có}}

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

> {{Tóm tắt một câu}}

{{Giải thích đơn giản theo lời của người dùng — một ý tưởng duy nhất}}

## Analogy

{{Analogy do người dùng chọn, kèm chỗ analogy không còn đúng nếu có}}

## Chỗ từng vấp

- {{Khoảng trống đã lộ ra trong buổi học và cách hiểu đúng}}

## Nguồn tham khảo

- [Tên nguồn](URL)
~~~

Nếu chỉ có một note, bỏ `related` tới MOC.

## So sánh với skill liên quan

| | `obsidian-feynman-learn` | `obsidian-socratic-learn` | `obsidian-explain-to-note` |
|---|---|---|---|
| Ai nói nhiều | Người dùng giải thích, agent hỏi ngây thơ | Agent hỏi, người dùng trả lời | Agent giải thích |
| Phù hợp | Cảm thấy đã hiểu, muốn kiểm tra | Chưa biết gì hoặc biết mơ hồ, muốn tự suy luận | Cần kiến thức nhanh |
| Nguồn note | Lời giải thích của người dùng | Câu trả lời của người dùng | Web search |
| Tương tác | Nhiều lượt | Nhiều lượt | Không |
