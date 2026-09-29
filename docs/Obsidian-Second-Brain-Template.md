# Second Brain — Cấu trúc và quy trình

> 🇬🇧 English reference: [en/Obsidian-Second-Brain-Template.md](en/Obsidian-Second-Brain-Template.md)

## Tổng quan

Second brain là một Obsidian vault cá nhân nhằm lưu trữ ghi chú để học, suy luận và sáng tạo tri thức. Nguyên tắc sử dụng Obsidian là không sử dụng thư mục. Tuy nhiên, thư mục vẫn cần thiết trong một số quy trình ghi chú. Vì vậy, trong Second brain vẫn có thư mục. Cách chia thư mục này dựa trên bộ cấu hình "[Obsidian Go](https://github.com/thinh-vu/obsidian-go)" và được tinh chỉnh cho việc học, làm dự án và nhìn lại bản thân.

Vault dựa trên ba ý tưởng:

- **Thư mục chỉ chứa loại ghi chú đặc thù** (nhật ký, dự án, tài nguyên, lưu trữ). Kiến thức không bị chia nhỏ theo chủ đề bằng thư mục mà được nối với nhau bằng `[[wiki-link]]` và các note index.
- **Zettelkasten**: mỗi note một ý (atomic), viết bằng lời của mình, liên kết chủ động với note khác.
- **Thuộc tính thay cho thư mục**: `type`, `status`, `related`, `tags` cho biết note là gì và chín tới đâu (mục Quy ước ghi chú bên dưới).

Vòng đời một note: **ý tưởng hoặc tài liệu thô** → note `seed` → được xem lại và liên kết (`bud`) → note hoàn chỉnh, sẵn sàng để liên kết (`evergreen`).

## Obsidian Graph

Là đồ thị tri thức để biểu diễn các cụm tri thức trong Second brain. Graph cho thấy **cách các note nối với nhau**. Xem graph định kỳ giúp:

- Nhìn được bức tranh tổng thể: chủ đề nào đang dày, chủ đề nào còn thưa.
- Phát hiện note chưa được liên kết và link bị hỏng trước khi chúng bị quên lãng.
- Kiểm tra Zettelkasten có đang "sống" không: note mới có được nối vào mạng cũ hay chỉ tích lũy rời rạc.
- Theo dõi mức độ trưởng thành của kiến thức, dựa vào màu theo `status` (mục màu bên dưới).

### Những điều cần xem

| Quan sát trên graph | Ý nghĩa | Việc cần làm |
| --- | --- | --- |
| Node lẻ loi, không có đường nối (orphan) | Note chưa liên kết với note nào | Thêm `related` tới một note index hoặc note cùng chủ đề |
| Node mờ, chỉ có tên link, không phải file thật (unresolved) | `[[link]]` trỏ tới note chưa tạo hoặc gõ sai tên | Research kiến thức về note đó, tạo note đó hoặc sửa lại link |
| Cụm dày quanh một node index | Chủ đề đã có nhiều ý | Xem lại, tách note quá dài, viết note tổng hợp |
| Cụm không có node index nào | Chủ đề chưa có "cổng vào" | Tạo note index và nối các note trong cụm vào đó |
| Cụm có ít node xanh lá (`evergreen`) | Kiến thức còn thô | Review, viết lại, nâng `status` từ `seed` lên `bud`, rồi `evergreen` |
| Hai cụm gần nhau nhưng chỉ nối bằng rất ít đường | Thiếu liên kết liên chủ đề | Tìm ý chung giữa hai cụm và thêm link |
| Node có rất nhiều đường nối | Note trung tâm (hub) của một chủ đề | Giữ nội dung gọn, chuyển chi tiết sang note con |

### Tô màu graph

Graph dùng các nhóm màu (`colorGroups`) khai báo trong `.obsidian/graph.json`, mỗi nhóm gồm một truy vấn theo thuộc tính và một màu. Đang có hai nhóm, nhờ vậy màu phản ánh đúng hai thuộc tính `type` và `status` ở mục Quy ước ghi chú:

| Thứ tự | Truy vấn | Màu | Ý nghĩa |
| --- | --- | --- | --- |
| 1 | `["type":index]` | Đỏ (`#D65C5C`) | Note index: cổng vào của một chủ đề |
| 2 | `["status":evergreen]` | Xanh lá (`#34A236`) | Note hoàn chỉnh, sẵn sàng để liên kết |
| — | (không khớp nhóm nào) | Màu mặc định | Note còn `seed` hoặc `bud`, note nhật ký, note dự án... |

Một note khớp nhiều nhóm sẽ lấy màu của nhóm đứng trước, nên note vừa là `index` vừa là `evergreen` hiển thị màu đỏ. Đọc graph theo thói quen: **đỏ là cổng chủ đề, xanh là kiến thức đã chín, còn lại là việc còn đang làm**.

Các tùy chọn hiển thị khác trong cùng file:

- `showOrphans: true`: hiện note mồ côi, để nhìn thấy chúng.
- `hideUnresolved: false`: hiện link chưa tạo note, để phát hiện link hỏng.
- `showTags: false`, `showAttachments: false`, `showArrow: false`: tắt tag, file đính kèm và mũi tên cho graph đỡ rối, chỉ còn note và liên kết.

## Cấu trúc thư mục

Sáu thư mục đánh số nằm cạnh vùng chờ xử lý ở thư mục gốc; các thư mục ẩn là cấu hình của công cụ.

```text
<Vault>/
├── 0. JOURNAL/            nhật ký hằng ngày (YYYY-MM-DD.md)
├── 1. PROJECT/            mỗi dự án một thư mục con
│   └── <Tên dự án>/
├── 2. RESOURCE/           kho kiến thức và mục tiêu dùng lâu dài
│   ├── index/             note index theo chủ đề
│   ├── template/          template ghi chú
│   └── attachments/       ảnh và file đính kèm
├── 3. ARCHIVED/
│   └── clippings/         bài web đã clip về
├── 4. VISUAL NOTES/       sơ đồ, canvas, Excalidraw
├── 5. OPERATION/          tài liệu vận hành vault
├── <Tài liệu đang xử lý>/  thư mục sách/khóa học (MOC + atomic note)
├── <Ghi chú lẻ>.md      note chưa xử lý xong
├── .obsidian/             cấu hình Obsidian và plugin
└── .claude/               skill và cấu hình cho AI agent (tùy chọn)
```

## Chức năng từng thư mục

| Thư mục | Chứa gì | Đặc điểm |
| --- | --- | --- |
| `0. JOURNAL` | Nhật ký hằng ngày, mỗi ngày một file `YYYY-MM-DD.md`. | Dùng template Daily Journal, `type: journal`, tag `daily`. |
| `1. PROJECT` | Ghi chú theo dự án đang làm, mỗi dự án một thư mục con. | Mỗi thư mục có một note trung tâm cùng tên (`type: index`, `related: [[Project]]`) giữ link tài liệu liên quan (PRD, wiki), kèm các note riêng cho từng việc: điều tra sự cố, truy vấn, yêu cầu tính năng, ý tưởng. |
| `2. RESOURCE` | Kho kiến thức dùng lâu dài: khái niệm, phương pháp, hồ sơ người, số liệu cá nhân, mục tiêu năm (OKR). | Thư mục lớn nhất, note để phẳng ở gốc. Có 3 thư mục con: `index/` (note index theo chủ đề), `template/`, `attachments/` (thư mục đính kèm của vault). |
| `3. ARCHIVED` | Tài liệu tạm không dùng thường xuyên, chỉ cần lưu để tìm lại. | Chủ yếu là `clippings/`: bài web clip nguyên bản, tag `clipping`, có `url` nguồn. |
| `4. VISUAL NOTES` | Ghi chú dạng hình: sketch note, flowchart (Excalidraw hoặc Canvas). | Chỉ chứa các file hình, không chứa note văn bản. |
| `5. OPERATION` | Tài liệu vận hành vault: `README` (bộ cấu hình), `Hướng dẫn sử dụng` (quy tắc thuộc tính, tag, trình tự làm việc), `KNOWLEDGE BASE` (note index gốc). | Rất ít file; là nơi tra cứu cách dùng vault. |
| Thư mục tài liệu ở gốc | Mỗi sách/khóa học/tài liệu một thư mục phẳng: một MOC lớn, MOC từng chương và các atomic note. | Chưa xử lý xong; xử lý xong thì chuyển vào `2. RESOURCE`. Thường là đầu ra của skill `obsidian-doc-to-note` và `obsidian-explain-to-note`. |
| Ghi chú lẻ ở gốc | Note mới tạo chưa được xếp vào đâu. | Chưa xử lý xong; xử lý xong thì chuyển vào `2. RESOURCE`. |

### Thư mục `2. RESOURCE/index`

Mỗi note index là một "cổng vào" của một chủ đề đời sống hoặc kiến thức (ví dụ sức khỏe, sự nghiệp, năng suất, công nghệ). Note mới được gắn `[[link]]` tới ít nhất một note index qua thuộc tính `related`, nhờ vậy cùng chủ đề thì gần nhau trên đồ thị.

### Template trong `2. RESOURCE/template`

Bộ template gợi ý: `New Note`, `Index Note`, `Daily Journal`, `Weekly Journal`, `Monthly Journal`, `Life Reflection`, `People profile`, `Book Highlights`, `Course Highlights`.

## Quy ước ghi chú

Mỗi note mở đầu bằng frontmatter với các thuộc tính sau:

| Thuộc tính | Giá trị | Ý nghĩa |
| --- | --- | --- |
| `type` | `index`, `input`, `output`, `journal` | `index`: MOC hoặc note tham chiếu cùng chủ đề. `input`: note ghi để học. `output`: sản phẩm đầu ra. `journal`: nhật ký ngày/tuần/tháng. |
| `status` | `seed`, `bud`, `evergreen` | `seed`: ý tưởng thô, chưa xử lý. `bud`: đang review, refactor. `evergreen`: atomic note hoàn chỉnh, sẵn sàng để liên kết. |
| `related` | danh sách `[[link]]` | Note cùng chủ đề, note index hoặc note nhật ký ngày tạo ra nó. |
| `created` | `YYYY-MM-DD HH:mm` | Thời điểm tạo. |
| `tags` | danh sách | Phân loại nhanh để truy vấn. |
| `url` | danh sách | Nguồn tham khảo. |

Danh mục tag tham khảo: `#idea`, `#daily`, `#weekly`, `#monthly`, `#people`, `#clipping`, `#todo`, `#okr`, `#book`, `#course`.

Quy ước đặt tên và chia note:

- **Atomic note**: một ý, tên là câu ngắn diễn đạt ý đó, không đặt theo số chương hay vị trí trong tài liệu gốc.
- **Sách, khóa học**: một MOC lớn, mỗi chương một MOC (`Tên tài liệu - Tên chương`), bên dưới là các atomic note; bài tập, trắc nghiệm, checklist tách thành note riêng.
- **Mục tiêu năm**: mỗi Key Result một note `<năm> KR - <tên>` (`type: output`, tag `okr`), tổng hợp bằng note `<năm> KR` và truy vấn Dataview.

## Quy trình hằng ngày

### 1. Mở ngày (nhật ký)

1. Mở note hôm nay bằng `Open Today` (Periodic Notes), plugin sẽ tạo sẵn file `0. JOURNAL/YYYY-MM-DD.md` từ template Daily Journal.
2. Ở mục `Project`, liệt kê việc cần làm dưới dạng task `- [ ]`, nối bằng `[[link]]` tới note dự án liên quan.
3. Ở mục `OKR`, ghi các việc gắn với mục tiêu năm.
4. Cuối note có sẵn truy vấn Dataview liệt kê các note `#okr` link tới note mục tiêu năm (`[[<năm> KR]]`) kèm `status`, dùng để nhìn nhanh tiến độ.

### 2. Trong ngày: ghi chú nhanh

1. Tạo note mới bằng `Cmd + N` (macOS) hoặc `Ctrl + N`.
2. Chèn template (`/Templates: Insert Template`), thường là `New Note`.
3. Điền `related`: note nhật ký hôm nay và ít nhất một note index.
4. Viết ý đó bằng lời của mình, `status: seed`, rồi gắn `[[wiki-link]]` tới các note liên quan.
5. Note công việc dự án (điều tra lỗi, truy vấn, yêu cầu) đặt thẳng trong `1. PROJECT/<dự án>/` và link về note trung tâm của dự án.

### 3. Học từ tài liệu hoặc khái niệm mới

1. Có tài liệu (PDF, URL, sách, khóa học): chạy skill `obsidian-doc-to-note`. Chỉ có khái niệm hoặc từ khóa: chạy `obsidian-explain-to-note` (chọn `effort:low|medium|high`).
2. Skill tạo một thư mục phẳng ở gốc vault gồm MOC và atomic note, `status: seed`, đã gắn link tới note có sẵn.
3. Đọc lại, nghiền ngẫm, sửa bằng lời của mình, đổi `status` sang `bud`, rồi `evergreen` khi hoàn chỉnh.
4. Xử lý xong thì chuyển thư mục/note vào `2. RESOURCE` và thêm `related` tới note index.

### 4. Lưu bài viết trên mạng

1. Clip bài web về vault sử dụng plugin Obsidian trên Chrome, gắn tag `clipping` và `url` nguồn.
2. Đặt vào `3. ARCHIVED/clippings`.
3. Khi cần dùng, rút ý ra thành atomic note riêng và link ngược về bài clip.

### 5. Cuối ngày và định kỳ

1. Tick `- [x]` các task đã xong trong note hôm nay; việc dở để lại cho ngày sau.
2. Cuối tuần / tháng, dùng template `Weekly Journal` / `Monthly Journal` để nhìn lại; `Life Reflection` cho tổng kết dài hơn.
3. Ghi chú nào đã xử lý xong mà không dùng thường xuyên thì chuyển sang `3. ARCHIVED`.

## Công cụ hỗ trợ

**Plugin cộng đồng gợi ý**

| Plugin | Dùng để |
| --- | --- |
| Periodic Notes, Calendar, Full Calendar | Tạo và duyệt nhật ký theo ngày/tuần/tháng, xem lịch |
| Natural Language Dates | Gõ ngày bằng ngôn ngữ tự nhiên |
| Dataview | Truy vấn note theo thuộc tính/tag (ví dụ bảng tiến độ OKR trong nhật ký) |
| Obsidian TODO | Quản lý task dạng text |
| Mind Map, Charts | Mindmap và biểu đồ từ ghi chú |
| Icon Folder, Emoji Shortcodes, Editing Toolbar | Hiển thị và soạn thảo |
| Claudian | Chat với Claude ngay trong vault |

Bên cạnh đó là các plugin lõi: Templates, Canvas, Bases, Backlinks, Graph view, Bookmarks, Properties, Sync.
