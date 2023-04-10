.data
  msg1:        .asciz "*****Input ID*****\n"
  msg2:        .asciz "** Please Enter Member 1 ID : **\n"
  msg3:        .asciz "** Please Enter Member 2 ID : **\n"
  msg4:        .asciz "** Please Enter Member 3 ID : **\n"
  msg5:        .asciz "** Please Enter Command **\n"
  msg6:        .asciz "*****Print Team Member ID and ID Summation*****\n"
  msg7:        .asciz "ID Summation = %d\n"
  msg8:        .asciz "*****End Print*****\n\n"
  IntEnter:    .asciz "%d\n"
  Enter:       .asciz "\n"
  P:           .asciz "p"
  inputInt:    .asciz "%d"
  inputString: .asciz "%s"

  id1 :        .word 0
  id2 :        .word 0
  id3 :        .word 0
  idSum :      .word 0
  command:     .space 80

  id1_address:   .word 0
  id2_address:   .word 0
  id3_address:   .word 0
  idSum_address: .word 0

.text
  .global id    @ Function
  .global id1   @ Int
  .global id2   @ Int
  .global id3   @ Int
  .global idSum @ Int

  id:
    stmfd sp!, {lr}
@-------------------------------------------------------
    ldr   r4, =id1_address
    str   r0, [r4]
    ldr   r4, =id2_address
    str   r1, [r4]
    ldr   r4, =id3_address
    str   r2, [r4]
    ldr   r4, =idSum_address
    str   r3, [r4]
@---------------------------------------------------------------
    ldr   r0, =msg1     @ r0 = "*****Input ID*****\n"
    bl    printf
@-------------------------------------------------------------------
    ldr   r0, =msg2     @ r0 = "** Please Enter Member 1 ID : **\n"
    bl    printf
    ldr   r0, =inputInt @ r0 = "%d"
    ldr   r1, =id1      @ r1 = Int
    bl    scanf
@-------------------------------------------------------------
    ldr   r0, =msg3     @ r0 = "** Please Enter Member 2 ID : **\n"
    bl    printf
    ldr   r0, =inputInt @ r0 = "%d"
    ldr   r1, =id2      @ r1 = Int
    bl    scanf
@-----------------------------------------------------------------
    ldr   r0, =msg4     @ r0 = "** Please Enter Member 3 ID : **\n"
    bl    printf
    ldr   r0, =inputInt @ r0 = "%d"
    ldr   r1, =id3      @ r1 = Int
    bl    scanf

@---------add------
    mov   r0, #0    @ () = addressing mode
    mov   r1, #0    @ [] = operand2
    cmp   r0, r1    @ {} = conditional Execution

    ldr   r1, =id1            @           r1 = id1's address
    ldr   r1, [r1]            @ (1)       r1 = id1's value
    ldr   r2, =id2            @           r2 = id2's address
    ldr   r2, [r2]            @           r2 = id2's value
    addeq r3, r1, r2          @    [1]{1} r3 = id1 + id2
    ldr   r1, =id3            @           r1 = id3's address
    ldr   r1, [r1]            @           r1 = id3's value
    add   r3, r3, r1 ,ror #31 @    [2]    r3 += id3*2
    sub   r3, r1              @           r3 -= id3

    addge r3, r3, #1          @    [3]{2} r3 = r3 + 1
    sub   r3, #1              @           r3 -= 1

    ldrne r4, [r4, #1]        @ (2)   {3}
    ldrne r6, [r4, r5]        @ (3)
    ldrne r6, [r4, #3]!       @ (4)

    ldr   r5, =idSum          @ r5 = idSum's address
    str   r3, [r5]            @ store r3(id1 + id2 + id3) in r5's value
@--------------add--------------------------------
    ldr   r1, =id1_address
    ldr   r1, [r1]
    ldr   r0, =id1
    ldr   r0, [r0]
    str   r0, [r1]

    ldr   r1, =id2_address
    ldr   r1, [r1]
    ldr   r0, =id2
    ldr   r0, [r0]
    str   r0, [r1]

    ldr   r1, =id3_address
    ldr   r1, [r1]
    ldr   r0, =id3
    ldr   r0, [r0]
    str   r0, [r1]

    ldr   r1, =idSum_address
    ldr   r1, [r1]
    ldr   r0, =idSum
    ldr   r0, [r0]
    str   r0, [r1]
@-------------------------------------------------
    mov   r0, #0
    ldr   r0, =msg5        @ r0 = "** Please Enter Command **\n"
    bl    printf

    ldr   r0, =inputString @ r0 = "%s"
    ldr   r1, =command     @ r1 = String
    bl    scanf

    ldr   r0, =P          @ r0 = P's address
    ldrb  r0, [r0]        @ r0 = P's value   (P = "p")
    ldr   r1, =command    @ r1 = command's address
    ldr   r1, [r1]        @ r1 = command's value
    cmp   r0, r1
    blne  CommandIsNotP   @ if ( command != "p" ) go to main

    ldr   r0, =msg6       @ r0 = "*****Print Team Member ID and ID Summation*****\n"
    bl    printf
@-------------------------------
    ldr   r0, =IntEnter   @ r0 = "%d\n"
    ldr   r1, =id1        @ r1 = Int
    ldr   r1, [r1]
    bl    printf
@---------------------------------
    ldr   r0, =IntEnter   @ r0 = "%d\n"
    ldr   r1, =id2        @ r1 = Int
    ldr   r1, [r1]
    bl    printf
@------------------------
    ldr   r0, =IntEnter   @ r0 = "%d\n"
    ldr   r1, =id3        @ r1 = Int
    ldr   r1, [r1]
    bl    printf
@-----------------------------------------
    ldr   r0, =Enter      @ r0 = "\n"
    bl    printf

    ldr   r0, =msg7       @ r0 = "ID Summation = %d\n"
    ldr   r1, =idSum      @ r1 = Int
    ldr   r1, [r1]
    bl    printf
@---------------------------------------------
    ldr   r0, =msg8       @ r0 = "*****End Print*****\n\n"
    bl    printf
@----------------------------------------------------------
    ldmfd sp!,{lr}
    mov   pc, lr


  CommandIsNotP:
    ldr   r0, =msg8    @  r0 = "*****End Print*****\n\n"
    bl    printf

    ldmfd sp!,{lr}
    mov   pc, lr