# Bash shell programming

**Shell** là một chương trinh soạn thảo cung cấp giao diện người dùng với các của sổ terminal. Nó cũng thường được sử dụng để chạy các đoạn script, thậm chí cả các phiên không tương tác mà không có cửa sổ terminal, khi các lệnh được gõ trức tiếp.

- Tạo file **Shell**
```sh
vim shell.sh
```
- Sửa file **Shell**
```sh
#!/bin/bash
find /usr/lib -name "*.c" -ls
```
Dòng đầu tiên của script sẽ bắt đầu với `#!/bin/bash` chứa toàn bộ đường dẫn của trình thông dịch được sử dụng trên file. Trình thông dịch có nhiệm vụ thực thi các yêu cầu trong script. Một số trình thông dịch phổ biến được sử dụng :

	/usr/bin/perl
	/bin/bash
	/bin/csh
	/bin/tcsh
	/bin/ksh
	/usr/bin/python
	/bin/sh

Tất cả các shell script đều trả về các giá trị khi thực hiện. Nếu thành công sẽ trả về 0, không thành công sẽ trả về một số khác không, và mọi giá trị trả về đều được lưu trong biến môi trường `$?` sử dụng `echo` để xem.

## Một số các cú pháp cơ bản

|Kí tự|	Mô tả|
|--|--|
|#	|Sử dụng để thêm bình luận, trừ khi dùng như # hoặc #! là để bắt đầu một script|
|\\	|sử dụng ở cuối dòng để chỉ ra rằng dòng lệnh vẫn tiếp tục xuống các dòng dưới|
|;|	Sử dụng để thông dịch những lệnh tiếp sau|
|$|	chỉ ra rằng đó là một biến|

Thường thì mỗi lệnh sẽ một dòng, nếu viết chúng trên một dòng thì dùng dấu `;` để phiên cách.</br>
Nếu dùng `&&` để nối các câu lệnh thì lệnh vẫn được thực hiện tuần tự, nhưng nếu có một lệnh bất kỳ sai thì cả dòng bị hủy bỏ.</br>
Còn nếu dùng `||` thì nếu lệnh đầu lỗi thì các lệnh theo sau đó sẽ không được thực thi.</br>
Trường hợp này sẽ chạy các câu lệnh cho tới khi có một lệnh nào đó thành công thì dừng thực thi các lệnh sau đó.</br>
## Functions</br>
Một hàm là một khối các mã lệnh thực thi nhiều tiến trình. Hàm rất hưu ích cho việc thực hiện các thủ tục nhiều lần.</br>
Hàm còn được gọi là các chương trình con. Sử dụng hàm trong script có hai bước:</br>

1. Khai báo hàm
2. Gọi hàm

Cấu trúc cơ bản của việc khai báo hàm:

```sh
function_name () {
   command...
}
```
Hàm không giới hạn số dòng và số câu, nó có thể được gọi bất cứ khi nào cần thiết. Dưới đây sẽ chỉ ra làm thế nào để đưa các tham số vào một hàm.</br>
Các tham số tương ứng theo thứ tự $1, $2, $3,... Tên của script là $0, tất cả các tham số được truyền vào là $* và số các đối số là $#.
```sh
# cat script.sh
#!/bin/bash
echo The name of this program is: $0
echo The first argument passed from the command line is: $1
echo The second argument passed from the command line is: $2
echo The third argument passed from the command line is: $3
echo All of the arguments passed from the command line are : $*
echo All done with $0
exit 0
```
```sh
# ./script.sh A B C
The name of this program is: ./script.sh
The first argument passed from the command line is: A
The second argument passed from the command line is: B
The third argument passed from the command line is: C
All of the arguments passed from the command line are : A B C
All done with ./script.sh
```
## Command substitution (Lệnh thay thế)</br>
Bạn có thể cần sử dụng kết quả của lệnh này như là biến của lệnh khác, điều này có thể thực hiện bằng cách sau :

1. Kết thúc câu lệnh bằng ()
2. Kết thúc câu lệnh innner bằng $()

Bất kể là phương thức nào thì câu lệnh inner cũng sẽ được chạy trong một môi trường shell mới. Đầu ra của shell sẽ được chèn vào nơi mà bạn thực hiện lệnh thay thế. Hầu hết các lệnh đều thực hiện được theo cách này. Lưu ý rằng phương pháp thứ 2 sẽ cho phép thực hiện các lệnh lồng nhau.</br>
### 1. Khai báo biến
Biến được gán trực tiếp. Giá trị của biến có thể là số hoặc một chuỗi. `TÊN_BIẾN=giá_trị`</br>
*Chú ý* giữa tên biến dâú bằng và giá trị không được có dấu cách.</br> 
Nếu `giá trị` là một chuỗi gồm nhiều từ thì cần đặt trong dấu `" "`</br>
Để gọi giá trị biến đã gán ta sử dụng ký tự `$` phía trước tên biến có thể sử dụng một trong 2 cách `$TÊN_BIẾN` hoặc `${TÊN_BIẾN}`</br>
#### Một số biến đặc biệt
Có một số biến mà ta không cần gán giá trị trực tiếp cho nó. Ta chỉ cần gọi nó ra còn giá trị của nó tùy thuộc vào lúc ta chạy chương trình
VD `./tên_file chuỗi`
Thì các biến đặc biệt đó là
 * `$#` sẽ trả về tổng số từ của chuỗi
 * `$0` trả về `tên_file`
 * `$1` trả về từ đầu tiên của chuỗi
 * `$2` trả về từ thứ 2 của chuỗi
 ................
 * `$9` trả về từ thứ 9 của chuỗi
 * `$@` trả về một chuỗi đầy đủ
VD một file `test` có nội dung như sau
```
#!/bin/sh
echo "I was called with $# parameters"
echo "My name is $0"
echo "My first parameter is $1"
echo "My second parameter is $2"
echo "All parameters are $@"
```
Khi chạy file này sẽ trả về kết quả như sau:
```
[client2@localhost ~]$ ./test dinh trong niem
I was called with 3 parameters
My name is ./test
My first parameter is dinh
My second parameter is trong
All parameters are dinh trong niem
```
### 2. Vòng lặp
#### for
```
for biến in giá_trị
do 
    lệnh
done
```
`giá_trị` có thể gồm nhiều giá trị ngăn cách nhau bởi dấu cách</br>
Hoặc
```
for (( expr1; expr2; expr3 ))
do 
    lệnh (lệnh ở đây được thự hiện cho đến biểu thức expr2 là sai)
done
```
#### while
```
while [ điều kiện ]
do
    lệnh
done
```
#### if
```
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
else
    lệnh nếu điều kiện sai
fi
```
hoặc
```
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
fi
```
Với trường hợp này nếu điều kiện đúng thì thực hiện lệnh còn điều kiện sai thì thoát khỏi vòng lặp

Hoặc ta có thể lồng nhiều điều kiện vào với nhau bằng cách
```
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
elif [ điều kiện tiếp theo nếu điều kiện trên là sai ]
then
    lệnh nếu điều kiện đầu sai điều kiện sau đúng
else
    lệnh nếu ko thỏa nãn bất kỳ điều kiện nào
fi
```
#### case
``` 
case điều_kiện in
    TH1) 
        lệnh
        ;;
    TH2)
        lệnh
        ;;
    THn)
        lệnh
        ;;
    *)
        lệnh
        ;;
esac
```
trong đó `*` ở trường hợp cuối cùng thể hiện những trường hợp không trùng với trường hợp nào được liệt kê ở trên.

*Chú ý* ta có thể đặt các vòng lặp lồng vào nhau để giải quyết một bài toán cụ thể.

### 3. Cấu trúc
Để tránh việc lặp đi lặp lại một đoạn code ta có thể đặt nó trong một cấu trúc và những lần sau muôn sử dụng lại ta chỉ cần gọi lại nó
```
!#/bin/sh

tên()
{
    lệnh
}

# đoạn thân code

# muốn gọi lại cấu trúc bên trên
tên $đối_số
```
### 4. Phép kiểm tra so sánh

1. Toán tử kết hợp

| !   | Phủ định (not)|
| ---- | -------------- |
| -a  | Và (and) |
| -o  | Hoặc (or) |

2. Lệnh kiểm tra file

| Cú pháp  | Ý nghĩa |
| -------  | ----- |
| -f file | kiểm tra xem có phải là file hay không |
| -d file | kiểm tra xem có phải thư mục hay không |
| -r file | kiểm tra xem file có đọc được không |
| -w file | kiểm tra xem file có ghi được không |
| -x file | kiểm tra xem file có thực thi được không |
| -s file | kiểm tra xem kích thước file có > 0 hay không |
| -e file | kiểm tra file có tồn tại hay không |

3 . So sánh
So sánh số với số

| Cú pháp | Ý nghĩa |
| ----- | -----|
| n1 -eq n2 | kiểm tra n1 = n2 |
| n1 -ne n2 | kiểm tra n1 khác n2 |
| n1 -lt n2 | kiểm tra n1 < n2 |
| n1 -le n2 | kiểm tra n1 <= n2 |
| n1 -gt n2 | kiểm tra n1 > n2 |
| n1 -ge n2 | kiểm tra n1 >= n2 |

So sánh chuỗi

| Cú pháp | Ý nghĩa | 
| ------ | ------- |
| s1 = s2 | kiểm tra s1 = s2 |
| s1 != s2 | kiểm tra s1 khác s2 |
| -z s1 | Kiểm tra s1 có kích thước bằng 0 |
| -n s1 | Kiểm tra s1 có kích thước khác 0 |
| s1 | Kiểm tra s1 khác rỗng |

Phép tính

| Cú pháp | Ý nghĩa |
| ----- | ------ |
| expr n1 + n2 | n1 + n2 |
| expr n1 - n2 | n1 - n2 |
| expr n1 / n2 | n1 / n2 |
| expr n1 \* n2 | n1 nhân n2 |

*Lưu ý* trong phép kiểm tra nếu phép kiểm tra là đúng thì kết quả trả về là `0` còn sai thì kết quả trả về là khác `0`
 
### The if statement
```sh
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
else
    lệnh nếu điều kiện sai
fi
```
hoặc
```
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
fi
```
Với trường hợp này nếu điều kiện đúng thì thực hiện lệnh còn điều kiện sai thì thoát khỏi vòng lặp</br>
Hoặc ta có thể lồng nhiều điều kiện vào với nhau bằng cách
```
if [ điều kiện ]
then
    lệnh nếu điều kiện đúng
elif [ điều kiện tiếp theo nếu điều kiện trên là sai ]
then
    lệnh nếu điều kiện đầu sai điều kiện sau đúng
else
    lệnh nếu ko thỏa nãn bất kỳ điều kiện nào
fi
```
Ví dụ:
```sh
$ cat ./count.sh
#!/bin/bash
if [ -f $1 ]
then
    echo "The " $1 " contains " $(wc -l < $1) " lines.";
    echo $?
fi
& ./count.sh /etc/passwd
The  /etc/passwd  contains  35  lines.
0
```
Có một số tùy chọn để check file như sau:

|Option|	Action|
|-------|---------|
|-e file|	Check if the file exists.|
|-d file|	Check if the file is a directory.|
|-f file|	Check if the file is a regular file.|
|-s file|	Check if the file is of non-zero size.|
|-g file|	Check if the file has sgid set.|
|-u file|	Check if the file has suid set.|
|-r file|	Check if the file is readable.|
|-w file|	Check if the file is writable.|
|-x file|	Check if the file is executable.|

Bạn có thể so sánh các string với nhau:

	if [ string1 == string2 ]
	then
	   ACTION
	fi

Nếu so sánh các số:

	if [ exp1 OPERATOR exp2 ]
	then
	   ACTION
	fi

Các tùy chọn cho operator

|Operator|	Action|
|--------|--------|
|-eq	|Equal to - bằng với|
|-ne	|Not equal to - không bằng với|
|-gt|	Greater than - lớn hơn|
|-lt|	Less than - nhỏ hơn|
|-ge	|Greater than or equal to - lớn hơn hoặc bằng|
|-le|	Less than or equal to - nhỏ hơn hoặc bằng|
