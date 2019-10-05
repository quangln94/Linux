# SECCOMP
## 1.Seccomp là gì
SECCOMP (SECure COMPuting) là một cơ sở bảo mật máy tính trong Linux-kernel, được thêm vào Linux kernel mainline trong phiên bản kernel 2.6.12. Như chúng ta đã biết, rất nhiều system calls được tiếp xúc trực tiếp với các chương trình, nhưng không phải tất cả system calls đều cần thiết cho người dùng, điều này sẽ nguy hiểm nếu ai đó lạm dụng system calls. Bằng cách sử dụng seccomp, chúng tôi có thể giới hạn chương trình sử dụng system calls cụ thể, điều này có thể làm cho hệ thống an toàn hơn.

## 2.Làm thế nào để sử dụng nó


## Tài liệu tham khảo
- https://www.w0lfzhang.com/2017/11/29/Linux-Seccomp-Learning/
- https://firejail.wordpress.com/documentation-2/seccomp-guide/
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/container_security_guide/linux_capabilities_and_seccomp
