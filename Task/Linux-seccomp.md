# Seccomp là gì
seccomp (SECure COMPuting) là một cơ sở bảo mật máy tính trong nhân Linux, được sáp nhập vào dòng chính của nhân Linux trong phiên bản kernel 2.6.12. Như chúng ta đã biết, rất nhiều cuộc gọi hệ thống được tiếp xúc trực tiếp với các chương trình, nhưng không phải tất cả các cuộc gọi hệ thống đều cần thiết cho người dùng, điều này sẽ nguy hiểm nếu ai đó lạm dụng các cuộc gọi hệ thống. Bằng cách sử dụng seccomp, chúng tôi có thể giới hạn chương trình sử dụng các cuộc gọi hệ thống cụ thể, điều này có thể làm cho hệ thống an toàn hơn.


## Tài liệu tham khảo
- https://www.w0lfzhang.com/2017/11/29/Linux-Seccomp-Learning/
