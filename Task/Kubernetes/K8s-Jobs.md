# Jobs - Run to Completion
- Job tạo 1 hoặc nhiều Pods và đảm bảo số lượng thành công
- Xóa Job sẽ xóa Pods được tạo
- Job sẽ start 1 Pod mới nếu Pod fails hoặc bị xóa

## CronJob
- 1 Cron Job tạo Jobs chạy theo thời gian được thiết lập
- Với mỗi CronJob, CronJob Controller kiểm tra số lần schedules bị miss, nếu lớn hơn 100 nó sẽ không start job và ghi lại lỗi.
- startingDeadlineSeconds: Tính từ thời điểm kết thúc
- concurrencyPolicy: Tính từ thời điểm bắt đầu




## Tài liệu tham khảo 
- https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/
