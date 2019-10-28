# Pods
##
Trong Kubernetes, đơn vị nhỏ nhất là Pod. Triển khai các ứng dụng trên Kubernetes có nghĩa là đóng gói chúng trong Pods.

Đào sâu hơn một chút, Pod là môi trường thực thi chung cho một hoặc nhiều container. Khá thường xuyên, nó trên container trên mỗi Pod, nhưng Pods đa container đang trở nên phổ biến. Một trường hợp sử dụng cho Pods đa container là lập kế hoạch khối lượng công việc kết hợp chặt chẽ. Ví dụ, hai container chia sẻ bộ nhớ sẽ hoạt động nếu chúng được lên lịch trên các nút khác nhau trong cụm. Các trường hợp sử dụng ngày càng phổ biến khác bao gồm ghi nhật ký và lưới dịch vụ.
