Nguyên tắc cơ bản của service discovery cung cấp metadata như machine type, tags, region in `__meta_*` và sau đó relabel tới labels mà bán muốn cho targets với `relabel_configs`. Bạn cũng có thể lọc các targets với action `keep` hoặc `drop`.

## Tài liệu tham khảo
- https://www.robustperception.io/life-of-a-label
- https://www.robustperception.io/target-labels-are-for-life-not-just-for-christmas
