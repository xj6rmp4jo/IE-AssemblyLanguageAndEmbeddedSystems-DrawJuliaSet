.data
  msg1:   .asciz "*****Print Name*****\n"
  msg2:   .asciz "*****End Print*****\n"
  teamNo: .asciz "Team 1\n"
  name1:  .asciz "LU,   JYUN-WEI\n"
  name2:  .asciz "YANG, RUEI-JEN\n"
  name3:  .asciz "CHEN, BO-YU\n"

.text
  .global name
  .global teamNo
  .global name1
  .global name2
  .global name3

  name:
    stmfd sp!, {lr}

    ldr   r0, =msg1
    bl    printf
    ldr   r0, =teamNo
    bl    printf
    ldr   r0, =name1
    bl    printf
    ldr   r0, =name2
    bl    printf
    ldr   r0, =name3
    bl    printf
    ldr   r0, =msg2
    bl    printf

    mov   r1, r13
    mov   r2, r14
    mov   r13, #0
    mov   r14, r15
    adds  r15, r14, r13
    mov   r13, r1
    mov   r14, r2

    ldmfd sp!, {lr}
    mov   pc, lr