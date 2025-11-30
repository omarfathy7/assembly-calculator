.model small
.stack 100h
.486

.data
hello        db "===========CALCULATOR===========$"
addOp        db "1.Addition$"
subOp        db "2.Subtraction$"
mulOp        db "3.Multiplication$"
divOp        db "4.Division$"
exitMsg      db "ESC - Exit$"
divZeroMsg   db "Cannot divide by zero.$"
askOp        db "Select an operation to perform: $"
xPrompt      db "Enter x: $"
yPrompt      db "Enter y: $"
resultMsg    db "Result: $"
nextStep     db "Press ENTER to continue or ESC to exit.$"

xnum db ?
ynum db ?

.code
main proc
start:
    mov ax, @data
    mov ds, ax
    call cls

    mov dx, offset hello
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset addOp
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset subOp
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset mulOp
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset divOp
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset exitMsg
    mov ah, 09h
    int 21h
    call newline

    mov dx, offset askOp
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    je addition
    cmp al, '2'
    je subtraction
    cmp al, '3'
    je multiplication
    cmp al, '4'
    je division
    cmp al, 1Bh     ; ESC
    je endProg
    jmp start

;------------------------------------
; ADDITION
;------------------------------------
addition:
    call newline
    mov dx, offset xPrompt
    mov ah, 09h
    int 21h
    call readX

    call newline
    mov dx, offset yPrompt
    mov ah, 09h
    int 21h
    call readY

    mov al, xnum
    add al, ynum

    call newline
    mov dx, offset resultMsg
    mov ah, 09h
    int 21h

    call printNumber
    jmp continueProg

;------------------------------------
; SUBTRACTION
;------------------------------------
subtraction:
    call newline
    mov dx, offset xPrompt
    mov ah, 09h
    int 21h
    call readX

    call newline
    mov dx, offset yPrompt
    mov ah, 09h
    int 21h
    call readY

    mov al, xnum
    cmp al, ynum
    jl negCase

    ; Normal case (x >= y)
    sub al, ynum
    mov ah, 0           ; Ensure AH is cleared
    jmp subDone

negCase:
    mov dl, '-'
    mov ah, 02h
    int 21h

    mov al, ynum
    sub al, xnum
    mov ah, 0           ; Ensure AH is cleared

subDone:
    call newline
    mov dx, offset resultMsg
    mov ah, 09h
    int 21h

    call printNumber
    jmp continueProg

;------------------------------------
; MULTIPLICATION
;------------------------------------
multiplication:
    call newline
    mov dx, offset xPrompt
    mov ah, 09h
    int 21h
    call readX

    call newline
    mov dx, offset yPrompt
    mov ah, 09h
    int 21h
    call readY

    mov al, xnum
    mov bl, ynum
    mul bl      ; AX = result

    call newline
    mov dx, offset resultMsg
    mov ah, 09h
    int 21h

    call printNumber
    jmp continueProg

;------------------------------------
; DIVISION
;------------------------------------
division:
    call newline
    mov dx, offset xPrompt
    mov ah, 09h
    int 21h
    call readX

    call newline
    mov dx, offset yPrompt
    mov ah, 09h
    int 21h
    call readY

    mov bl, ynum
    cmp bl, 0
    je divZero

    mov al, xnum
    mov ah, 0
    div bl      ; AL = quotient, AH = remainder

    call newline
    mov dx, offset resultMsg
    mov ah, 09h
    int 21h

    ; Print quotient
    mov ah, 0
    call printNumber

    ; Print remainder if non-zero
    mov al, ah      ; Move remainder to AL
    cmp al, 0
    je continueProg

    ; Print 'r'
    mov dl, 'r'
    mov ah, 02h
    int 21h

    ; Print remainder
    mov ah, 0
    call printNumber

    jmp continueProg

divZero:
    call newline
    mov dx, offset divZeroMsg
    mov ah, 09h
    int 21h
    jmp continueProg

;------------------------------------
; CONTINUE OR EXIT
;------------------------------------
continueProg:
    call newline
    mov dx, offset nextStep
    mov ah, 09h
    int 21h
    call newline

    mov ah, 01h
    int 21h
    cmp al, 0Dh ; ENTER
    je start
    cmp al, 1Bh ; ESC
    je endProg
    jmp continueProg

;------------------------------------
; PRINT NUMBER (AX or AL)
;------------------------------------
printNumber:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0       ; Clear AH to ensure correct number
    mov bx, 10
    mov cx, 0

convertLoop:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convertLoop

printLoop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop printLoop

    pop dx
    pop cx
    pop bx
    pop ax
    ret

;------------------------------------
; NEW LINE
;------------------------------------
newline:
    push ax
    push dx
    mov ah,02h
    mov dl,13
    int 21h
    mov dl,10
    int 21h
    pop dx
    pop ax
    ret

readX:
    mov ah,01h
    int 21h
    sub al, 30h
    mov xnum, al
    ret

readY:
    mov ah,01h
    int 21h
    sub al, 30h
    mov ynum, al
    ret

cls:
    mov ax, 3
    int 10h
    ret

endProg:
    mov ah, 4Ch
    int 21h

main endp
end main