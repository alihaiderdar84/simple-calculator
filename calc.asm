section .bss
num1 resb 32
op resb 2
num2 resb 32
result resb 32

section .data
msg1 db "Enter a number: ", 0xa
msg1_len equ $ - msg1

msg2 db "Enter an operation (+, -, *, /): ", 0xa
msg2_len equ $ - msg2

msg3 db "Enter the second number: ", 0xa
msg3_len equ $ - msg3

res_msg db "Result: ", 0xa
res_len equ $ - res_msg

err_msg db "Invalid Operation", 0xa
err_len equ $ - err_msg


section .text
global _start

_start:

; num1

mov rdi, msg1
mov rsi, msg1_len
call print


mov rdi, num1
call scan

mov rdi, num1
call atd
mov [num1], al

; op

mov rdi, msg2
mov rsi, msg2_len
call print

mov rdi, op
call scan

; num2

mov rdi, msg3
mov rsi, msg3_len
call print


mov rdi, num2
call scan

mov rdi, num2
call atd
mov [num2], al

case_add:
cmp byte [op], '+'
jne case_sub

movzx rdi, byte [num1]
movzx rsi, byte [num2]
call add

mov rdi, rax
call dta

mov [result], al
mov byte [result + 1], 0xa

mov rdi, result
mov rsi, 32
call print_res
call exit

case_sub:
cmp byte [op], '-'
jne case_mul

movzx rdi, byte [num1]
movzx rsi, byte [num2]
call sub

mov rdi, rax
call dta

mov [result], al
mov byte [result + 1], 0xa

mov rdi, result
mov rsi, 32
call print_res
call exit

case_mul:
cmp byte [op], '*'
jne case_div

movzx rdi, byte [num1]
movzx rsi, byte [num2]
call mul

mov rdi, rax
call dta

mov [result], al
mov byte [result + 1], 0xa

mov rdi, result
mov rsi, 32
call print_res
call exit

case_div:
cmp byte [op], '/'
jne error

cmp byte [num2], 0
je error 

movzx rdi, byte [num1]
movzx rsi, byte [num2]
call div

mov rdi, rax
call dta

mov [result], al
mov byte [result + 1], 0xa

mov rdi, result
mov rsi, 32
call print_res
call exit

error:
mov rdi, err_msg
mov rsi, err_len
call print
call exit

exit:
mov rax, 60
xor rdi,rdi
syscall

print:
mov rcx, rdi
mov rbx, rsi
mov rax, 1
mov rdi, 1
mov rsi, rcx
mov rdx, rbx
syscall
ret

scan:
mov rsi, rdi
mov rax, 0
mov rdi, 0
mov rdx, 2
syscall
ret

print_res:
push rsi
push rdi

mov rax, 1
mov rdi, 1
mov rsi, res_msg
mov rdx, res_len
syscall

pop rdi
pop rsi

sub rsp, 8
call print
add rsp, 8
ret

atd:
movzx rax, byte [rdi]
sub rax, '0'
ret

dta:
mov rax, rdi
add rax, '0'
ret

add:
mov rax, rdi
add rax, rsi
ret

sub:
mov rax, rdi
sub rax, rsi
ret

mul:
mov rax, rdi
imul rsi
ret

div:
mov rax, rdi
cqo
idiv rsi
ret