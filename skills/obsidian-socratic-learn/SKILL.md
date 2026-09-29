---
name: "obsidian-socratic-learn"
description: "Học một khái niệm bằng phương pháp Socratic: agent đặt câu hỏi dẫn dắt để người dùng tự suy luận ra câu trả lời, rồi lưu những gì đã hiểu thành ghi chú Obsidian atomic có liên kết. Dùng khi nói 'hỏi tôi về X', 'dạy tôi X kiểu Socratic', 'học X bằng câu hỏi', 'kiểm tra xem tôi hiểu X chưa'."
argument-hint: "<khái niệm / chủ đề>"
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch, Bash(find *)]
---

## Mục tiêu

Giúp người dùng **tự hiểu** một khái niệm bằng chuỗi câu hỏi dẫn dắt (phương pháp Socratic) thay vì được giải thích sẵn. Kết thúc buổi hỏi đáp, lưu những gì người dùng đã hiểu ra thành ghi chú markdown atomic tương thích Obsidian — tuân theo Zettelkasten và liên kết với Vault hiện có.

## Khi nào dùng

- Muốn học sâu một khái niệm bằng cách tự suy luận, không muốn đọc lời giải thích sẵn
- Muốn kiểm tra mình đã hiểu thật hay chỉ "nghe quen"
- Muốn có note phản ánh đúng cách bản thân hiểu, kèm các câu hỏi giúp ôn lại sau này

## Khi nào KHÔNG dùng

- Chỉ cần đọc lời giải thích và lưu note, không muốn bị hỏi → dùng `obsidian-explain-to-note`
- Đã có tài liệu gốc (PDF, URL, file) → dùng `obsidian-doc-to-note`
- Muốn tự giải thích lại bằng lời của mình để lộ chỗ hổng → dùng `obsidian-feynman-learn`
- Chỉ cần giải thích nhanh trong chat, không lưu note → dùng `learn`
- Tài liệu hóa code hoặc changelog

## Đầu vào

Parse từ `$ARGUMENTS`:

| Tham số | Mô tả | Mặc định |
|---|---|---|
| **Chủ đề** | Khái niệm hoặc chủ đề muốn học | (bắt buộc) |

Ví dụ:
- `CAP theorem`
- `event sourcing`
- `vì sao Raft cần bầu leader`

Nếu thiếu chủ đề → hỏi người dùng trước khi tiếp tục. Nếu chủ đề quá rộng (ví dụ "hệ thống phân tán") → hỏi thu hẹp về một khía cạnh trước khi bắt đầu.

## Nguyên tắc Zettelkasten

Tuân theo [nguyên tắc Zettelkasten](../../docs/Zettelkasten-Principles.md): mỗi note một ý (atomic), viết bằng lời của mình, chủ động gắn `[[wiki-link]]` tới note đã có trong Vault. "Lời của mình" ở đây là **lời của người dùng** — lấy từ câu trả lời của họ trong buổi hỏi đáp, chỉ sửa khi sai hoặc quá mơ hồ. Ngoài ra, skill này có thêm các nguyên tắc riêng:

- **Không dạy trước khi hỏi**: Không giải thích chủ đề trước khi người dùng thử suy nghĩ. Chỉ giải thích khi đã thử các cách gợi ý mà người dùng vẫn bí, hoặc khi họ yêu cầu.
- **Không ghi điều sai vào note**: Note chỉ chứa kiến thức đã được kiểm chứng với nguồn. Ý người dùng hiểu sai phải được chỉnh trong buổi hỏi đáp và ghi dưới dạng "chỗ từng hiểu nhầm", không ghi như một khẳng định.
- **Ghi nguồn**: Cuối mỗi note, thêm mục `## Nguồn tham khảo` với URL đã dùng để kiểm chứng (không paste nguyên văn).

## Giá trị mặc định cho frontmatter

Nếu không tìm thấy file `[[Hướng dẫn sử dụng]]` trong Vault, dùng giá trị mặc định:
- `type`: `input`
- `status`: `seed`

## Hướng dẫn

Dẫn dắt người dùng học `$ARGUMENTS` bằng câu hỏi, rồi chuyển kết quả thành ghi chú. Đây là skill **tương tác nhiều lượt**: mỗi lượt chỉ hỏi rồi dừng lại chờ người dùng trả lời. Dùng ngôn ngữ của người dùng (mặc định tiếng Việt).

### Bước 1 — Xác định chủ đề

- Tách chủ đề từ đầu vào, hỏi làm rõ nếu mơ hồ hoặc quá rộng

### Bước 2 — Chuẩn bị (không hiển thị cho người dùng)

- Kiểm tra trong vault đã có các note liên quan chưa, nếu có thì sử dụng các note trong vault.
- Cũng dùng **WebSearch** tìm nguồn uy tín (docs chính thức, bài kỹ thuật, Wikipedia), dùng **WebFetch** đọc chi tiết 1–3 nguồn phù hợp nhất. Mục đích là để **bản thân agent hiểu đúng**, đủ để nhận ra khi người dùng nói sai.
- Lập nhanh "bản đồ ý" của chủ đề: 3–6 ý cốt lõi và các hiểu lầm phổ biến. Giữ nội bộ, **không tiết lộ** cho người dùng trước khi họ tự suy ra.

### Bước 3 — Chẩn đoán điểm xuất phát

Hỏi **một** câu mở để biết người dùng đang ở đâu, ví dụ: "Bạn đã biết gì về X? Nếu phải đoán, bạn nghĩ X dùng để giải quyết vấn đề gì?". Điều chỉnh độ khó của các câu tiếp theo theo câu trả lời. Không cần hỏi thêm về mục tiêu học.

### Bước 4 — Vòng hỏi đáp

Lặp lại cho từng ý cốt lõi trong bản đồ ý, theo thứ tự từ nền tảng đến nâng cao.

**Nhịp mỗi lượt**: một câu hỏi (tối đa hai câu liên quan chặt chẽ), ngắn gọn, rồi dừng chờ trả lời.

**Loại câu hỏi** (chọn theo tình huống, không dùng máy móc):

| Loại | Mục đích | Ví dụ |
|---|---|---|
| Làm rõ | Hiểu người dùng đang nói gì | "Bạn hiểu 'nhất quán' ở đây nghĩa là gì?" |
| Khai thác giả định | Lộ ra điều đang mặc định | "Bạn đang giả định mạng luôn ổn định, đúng không?" |
| Ví dụ / phản ví dụ | Kiểm tra ranh giới | "Có trường hợp nào điều đó không đúng không?" |
| Hệ quả | Suy luận tiếp | "Nếu vậy thì điều gì xảy ra khi node A mất kết nối?" |
| Góc nhìn khác | Mở rộng | "Một hệ thống ưu tiên tốc độ sẽ nhìn vấn đề này thế nào?" |
| Tự tổng kết | Củng cố | "Bạn tóm lại ý này bằng một câu được không?" |

**Khi người dùng trả lời đúng**: xác nhận ngắn gọn và cụ thể (nêu rõ đúng ở chỗ nào, không khen chung chung), rồi đào sâu hoặc chuyển sang ý tiếp theo.

**Khi người dùng trả lời sai hoặc bí**: **không** nói thẳng đáp án. Đi theo thang gợi ý, mỗi nấc là một lượt:

1. Hỏi lại theo cách khác hoặc chia nhỏ câu hỏi
2. Đưa một ví dụ / phản ví dụ cụ thể để người dùng tự thấy mâu thuẫn
3. Gợi ý một mảnh của đáp án
4. Giải thích ngắn (tối đa 3–4 câu) rồi hỏi lại một câu kiểm tra mới, để người dùng tự diễn đạt lại

**Khi người dùng nói "không biết", "cho tôi đáp án", hoặc tỏ ra bực**: tôn trọng ngay — nhảy tới nấc 4, không ép tiếp. Vẫn cho họ diễn đạt lại sau đó.

**Ghi nhớ nội bộ** trong lúc hỏi đáp: ý nào người dùng tự suy ra được, ý nào cần gợi ý, ý nào vẫn chưa nắm, và mọi hiểu lầm đã lộ ra.

**Khi nào dừng**: khi các ý cốt lõi đã được bao phủ, hoặc người dùng muốn dừng. Thông thường khoảng 6–12 lượt hỏi đáp. Đừng kéo dài thêm khi người dùng đã hiểu.

### Bước 5 — Tổng kết buổi học

Trình bày ngắn cho người dùng:

- Những ý bạn đã tự suy ra
- Những ý cần gợi ý (nên xem lại)
- Những hiểu lầm đã sửa
- Câu hỏi còn mở (nếu có)

Chưa nắm chắc ý nào thì ghi vào "câu hỏi còn mở", **không** tạo atomic note khẳng định ý đó như đã hiểu.

### Bước 6 — Tìm liên kết trong Vault, tạo note nếu cần

- Kiểm tra xem các note trong vault đã có, hoặc đã đủ ý như người dùng đã học chính xác chưa.
- Nếu đã có note đầy đủ rồi thì bỏ qua và kết thúc.
- Nếu chưa có note, hoặc note chưa cập nhật đầy đủ thì hỏi người dùng có muốn update hay tạo mới không?
  - Nếu là kiến thức đã có note và chỉ cần cập nhật thêm -> Gợi ý update thêm kiến thức vào các note, có thể tạo thêm note tùy kiến thức.
  - Nếu là kiến thức hoàn toàn mới, cần nhiều note để giải thích và lưu trữ -> Gợi ý người dùng tạo thư mục và tạo các note.

Với mỗi ý quan trọng, dùng Grep tìm file `.md` trong Vault có tên hoặc nội dung khớp keyword. Chỉ gắn `[[wiki-link]]` khi tìm thấy note thực sự liên quan — không tạo link tới note không tồn tại.

### Bước 7 — Kiểm tra lại

- Đọc lại các note: Kiểm tra xem note đã đủ ý cần thiết chưa.
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

{{Mô tả ngắn — chủ đề này là gì, tại sao quan trọng}}

## Các ý chính

- [[tên ý tưởng 1]]
- [[tên ý tưởng 2]]

## Câu hỏi còn mở

- {{Những điểm chưa nắm chắc sau buổi hỏi đáp, nếu có}}

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

{{Ý tưởng theo cách người dùng đã hiểu ra, đã chỉnh cho đúng — một ý tưởng duy nhất}}

## Câu hỏi dẫn dắt

- {{Câu hỏi đã giúp người dùng hiểu ra ý này}}

## Chỗ từng hiểu nhầm

{{Chỉ khi có — hiểu nhầm ban đầu và vì sao nó sai}}

## Nguồn tham khảo

- [Tên nguồn](URL)
~~~

Nếu chỉ có một note, bỏ `related` tới MOC.

## So sánh với skill liên quan

| | `obsidian-socratic-learn` | `obsidian-feynman-learn` | `obsidian-explain-to-note` |
|---|---|---|---|
| Ai nói nhiều | Agent hỏi, người dùng trả lời | Người dùng giải thích, agent hỏi ngây thơ | Agent giải thích |
| Phù hợp | Chưa biết gì hoặc biết mơ hồ, muốn tự suy luận | Cảm thấy đã hiểu, muốn kiểm tra | Cần kiến thức nhanh |
| Nguồn note | Câu trả lời của người dùng | Lời giải thích của người dùng | Web search |
| Tương tác | Nhiều lượt | Nhiều lượt | Không |
