.data

.text
  .global drawJuliaSet    @ Function

  drawJuliaSet :
    stmfd sp!, {r4-r11, lr}
@-----------------------------------------------------------------
    mov   r11,r0    @ r11 = cY
    mov   r4, r1    @ r4 = frame
    mov   r5, #0    @ r5 = x, initial x = 0
    subs  r0, r14, r13  @ !!!!!!!!!!!!!!!!

  loopX :
    cmp   r5, #640  @ if ( x < 640 )
    bge   DoneX
    mov   r6, #0    @ r6 = y, initial y = 0

  loopY :
    cmp   r6, #480  @ if ( y < 480 )
    bge   DoneY
@----------------------------------------------------------
    ldr   r0, .constant    @ r0 = 1500
    mul   r0, r0, r5       @ r0 = 1500x ( r5 = x )
    ldr   r1, .constant+4  @ r1 = 480000
    sub   r0, r1           @ r0 = 1500x - 480000
    mov   r1, #320         @ r1 = 320
    bl    __aeabi_idiv     @ r0 = ( 1500x - 480000 ) / 320
    mov   r8, r0           @ r8 = ( 1500x - 480000 ) / 320 (r8 = zx)

    mov   r0, #1000        @ r0 = 1000
    mul   r0, r0, r6       @ r0 = 1000y (r6 = y)
    ldr   r1, .constant+8  @ r1 = 240000
    sub   r0, r1           @ r0 = 1000y - 240000
    mov   r1, #240         @ r1 = 240
    bl    __aeabi_idiv     @ r0 = ( 1000y - 240000 ) / 240
    mov   r9, r0           @ r9 = ( 1000y - 240000 ) / 240 (r9 = zy)

    mov   r7, #255         @ r7 = i, i = 255, initial !!!!
    mul   r0, r8, r8       @ r0 = zx * zx (r8 = zx)
    mul   r1, r9, r9       @ r1 = zy * zy (r9 = zy)

    add   r2, r0, r1       @ r2 = zx * zx + zy * zy
    ldr   r3, .constant+12 @ r3 = 400,0000

    mov   r10, #0
    cmp   r10, #1
    cmpne r2, r3           @ zx * zx + zy * zy < 4000000
    bge   DoneWhile
    cmplt r7, #0           @ i > 0
    ble   DoneWhile


  While :
    sub   r0, r1           @ r0 = zx * zx - zy * zy
    mov   r1, #1000
    bl    __aeabi_idiv     @ r0 = ( zx * zx - zy * zy ) / 1000
    sub   r10, r0, #700    @ r10 = ( zx * zx - zy * zy ) / 1000 - 700
                           @ ( r10 = tmp )

    mul   r0, r8, r9       @ r0 = zx * zy (r8 = zx, r9 = zy)
    mov   r1, #500         @ r1 = 500
    bl    __aeabi_idiv     @ r0 = zx * zy / 500
    add   r9, r0, r11      @ zy = zx*zy/500 + cY (r9 = zy, r11 = cY)

    mov   r8, r10          @ zx = tmp (r8 = zx, r10 = tmp)

    sub   r7, #1           @ i--
@-------------------------------------------------------------------
    mul   r0, r8, r8       @ r0 = zx * zx (r8 = zx)
    mul   r1, r9, r9       @ r1 = zy * zy (r9 = zy)
    add   r2, r0, r1       @ r2 = zx * zx + zy * zy
    ldr   r3, .constant+12 @ r3 = 400,0000

    cmp   r2, r3           @ zx * zx + zy * zy < 4000000
    bge   DoneWhile
    cmp   r7, #0           @ i > 0
    ble   DoneWhile
    b     While

@---------------------------------------------
  DoneWhile :
    and   r7, r7, #0xff      @ r7 = i, i = i & 0xff
    mov   r0, #8

    orr   r7, r7, r7, lsl r0 @ r7 = (i & 0xff) | ((i & 0xff) << 8)

    ldr   r0, .constant+16   @ r0 = 0xffff
    bic   r7, r0, r7         @ r7 = (~r7) & 0xffff

    mov   r0, r4             @ r0 = frame
    mov   r1, #1280          @ r1 = 1280
    mul   r1, r1, r6         @ r1 = 1280y (r6 = y)
    add   r0, r1             @ r0 = frame + 1280y
    add   r0, r5, lsl #1     @ r0 = frame + 1280y + 2x (r5 = x)

    strh  r7, [r0]
@--------------------------------------------------------------------
    add   r6, #1          @ y++
    b     loopY
@----------------------------------------------------------
  DoneY :
    add   r5, #1          @ x++
    b     loopX
@-------------------------------------------------------
  DoneX :
    ldmfd sp!, {r4-r11, lr}
    mov   pc, lr

@-----------------------------------------------------------------
  .constant :
    .word 1500            @ .constant+0
    .word 480000          @ .constant+4
    .word 240000          @ .constant+8
    .word 4000000         @ .constant+12
    .word 0xffff          @ .constant+16