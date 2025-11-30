.model small
.stack 100h
.486
.data
hello db "===========CALCULATOR===========$"
addOp db "1.Addition$"
subOp db "2.Subtraction$"
mulOp db "3.Multiplication$"
divOp db "4.Division$"
exitMsg db "ESC - Exit$"
divZeroMsg db "Cannot divide by zero.$"
askOp db "Select an operation to perform: $"
xPrompt db "Enter x: $"
yPrompt db "Enter y: $"
xnum db ?
ynum db ?
resultMsg db "Result: $"
nextStep db "Press ENTER to continue or ESC to exit.$"

.code
main proc
start:
    mov ax, @data
    mov ds, ax
    
    call cls

    mov dx, offset hello
    mov ah,09h
    int 21h
    call newline

    mov dx,offset addOp
    mov ah,09h
    int 21h
    call newline

    mov dx,offset subOp
    mov ah,09h
    int 21h
    call newline

    mov dx, offset mulOp
    mov ah,09h
    int 21h
    call newline

    mov dx, offset divOp
    mov ah,09h
    int 21h
    call newline

    mov dx, offset exitMsg
    mov ah,09h
    int 21h
    call newline

    mov dx, offset askOp
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    cmp al, '1'
    je addition
    cmp al,'2'
    je subtraction
    cmp al,'3'
    je multiplication
    cmp al,'4'
    je division
    cmp al, 1bh ; ESC key
    je endProg
    jmp start

addition:
    call newline
    mov dx, offset xPrompt
    mov ah,09h
    int 21h
    call readX

    call newline
    mov dx,offset yPrompt
    mov ah,09h
    int 21h
    call readY

    ; Calculate addition
    mov al, xnum
    add al, ynum
    
    ; Print result
    call newline
    mov dx, offset resultMsg
    mov ah,09h
    int 21h
    
    ; Convert number to ASCII and print
    call printNumber
    jmp continueProg

subtraction:
    call newline
    mov dx,offset xPrompt
    mov ah,09h
    int 21h
    call readX

    call newline
    mov dx,offset yPrompt
    mov ah,09h
    int 21h
    call readY

    ; Calculate subtraction
    mov al, xnum
    sub al, ynum
    
    ; Print result
    call newline
    mov dx, offset resultMsg
    mov ah,09h
    int 21h
    
    call printNumber
    jmp continueProg

multiplication:
    call newline
    mov dx,offset xPrompt
    mov ah,09h
    int 21h
    call readX

    call newline
    mov dx,offset yPrompt
    mov ah,09h
    int 21h
    call readY

    ; Calculate multiplication
    mov al, xnum
    mov bl, ynum
    mul bl
    
    ; Print result
    call newline
    mov dx, offset resultMsg
    mov ah,09h
    int 21h
    
    call printNumber
    jmp continueProg

division:
    call newline
    mov dx, offset xPrompt
    mov ah,09h
    int 21h
    call readX

    call newline
    mov dx,offset yPrompt
    mov ah,09h
    int 21h
    call readY

    ; Check for division by zero
    mov bl, ynum
    cmp bl, 0
    je divByZero

    ; Calculate division
    mov al, xnum
    mov ah, 0
    div bl
    
    ; Print result
    call newline
    mov dx, offset resultMsg
    mov ah,09h
    int 21h
    
    call printNumber
    jmp continueProg

divByZero:
    call newline
    mov dx,offset divZeroMsg
    mov ah,09h
    int 21h
    jmp continueProg

continueProg:
    call newline
    mov dx,offset nextStep
    mov ah,09h
    int 21h
    call newline

    mov ah,01h
    int 21h
    cmp al,0dh ; ENTER key
    je start
    cmp al,1bh ; ESC key
    je endProg
    jmp continueProg

; Procedure to print a number in AL (range 0 to 99)
printNumber:
    push ax
    push bx
    push cx
    push dx
    
    mov bl, al          ; Save the number in BL
    mov ah, 0
    mov al, bl
    
    ; Divide by 10 to separate tens and ones
    mov cl, 10
    div cl              ; AL = tens digit, AH = ones digit
    
    mov bh, ah          ; Save ones digit in BH
    mov bl, al          ; Save tens digit in BL
    
    ; Print tens digit if not zero
    cmp bl, 0
    je print_ones
    
    mov dl, bl
    add dl, '0'
    mov ah, 02h
    int 21h
    
print_ones:
    ; Print ones digit
    mov dl, bh
    add dl, '0'
    mov ah, 02h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

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
    mov xnum,al
    ret

readY:
    mov ah,01h
    int 21h
    sub al, 30h
    mov ynum,al
    ret

cls:
    mov ax,3
    int 10h
    ret

endProg:
    mov ah,4ch
    int 21h

main endp
end main