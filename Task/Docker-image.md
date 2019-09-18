# Docker image
Docker images được tạo thành từ một loạt các layers. Mỗi layers sẽ đại diện cho một chỉ thị trong Dockerfile

Docker file bên trên bao gồm 4 commands và mỗi command này sẽ tạo ra một layer. Mỗi một layer chỉ là một phần khác biệt so với layer phía trước nó. Mỗi layer sẽ được xếp lên trên layer trước nó, bạn tưởng tượng những viên gạch đặt chồng lên nhau vậy. Điều quan trong ở đây bạn cần nhớ đó là khi mà bạn tạo một container mới thì bạn đã tạo ra một writeable layer on top of the underlying layers - một layer có thể ghi được đặt trên cùng so với những layer thuộc images mà container này được tạo ra. Hãy nhìn vào hình bên dưới để trực quan nhất
