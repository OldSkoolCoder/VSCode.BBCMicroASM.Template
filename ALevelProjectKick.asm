.label OSWRCH      = $FFEE
.label OSASCI      = $FFE3

.label NoOfRounds  = $78
.label Xstart      = $72
.label Ystart      = $73
.label XEnd        = $75
.label YEnd        = $76
.label ScreenPos   = $70
.label CharPosition= $74
.label Character   = $77

.label NoOfCols    = 39
.label NoOfRows    = 24

.label ScreenRam   = $7C00

.label Titlestart  = $7dec
.label TitleEnd    = $7DFB

//4450 FOR C = 0 TO 2 STEP 2
//4460 P%=$6000
//4470 [OPTC

* = $1900 "Main Code"

Codestart:
    lda #12
    jsr $FFE3
    lda #0
    sta NoOfRounds

start:
    lda #0   
    sta Xstart
    sta Ystart
    sta ScreenPos
    sta CharPosition  
    ldy #0

Print:
    lda Text,Y
    sta Titlestart,Y
    iny
    cpy #_Text - Text
    bne Print

    lda NoOfRounds
    lsr
    clc
    adc #129
    sta TitleEnd
    lda #>ScreenRam
    sta ScreenPos + 1
    lda #NoOfCols
    sta XEnd
    lda #NoOfRows
    sta YEnd

Next:
    ldx CharPosition
    lda Char,X
    cpx #0
    bne Next1
    lda NoOfRounds
    lsr
    clc
    adc #129 

Next1:
    sta Character
    lda NoOfRounds
    and #1
    cmp #1
    bne Topstart
    lda Xstart
    cmp #1
    bcc Topstart
    lda #32
    sta Character

Topstart:
    ldy Xstart

Top: 
    lda Character
    sta (ScreenPos),Y
    iny
    cpy XEnd
    bne Top
    ldx Ystart
    ldy XEnd

Right:
    lda Character
    sta (ScreenPos),Y
    clc
    lda ScreenPos
    adc #40
    sta ScreenPos
    lda ScreenPos + 1 
    adc #0
    sta ScreenPos + 1
    inx
    cpx YEnd
    bne Right
    ldy XEnd

Bottom:
    lda Character
    sta (ScreenPos),Y
    dey
    cpy Xstart
    bne Bottom
    ldx YEnd
    ldy Xstart

Left:
    lda Character
    sta (ScreenPos),Y
    sec
    lda ScreenPos
    sbc #40
    sta ScreenPos
    lda ScreenPos + 1
    sbc #0
    sta ScreenPos + 1
    dex
    cpx Ystart
    bne Left
    clc
    lda ScreenPos
    adc #40
    sta ScreenPos
    lda ScreenPos + 1
    adc #0
    sta ScreenPos + 1
    ldx #32

Del1:
    ldy #255

Del2:
    dey
    bne Del2
    dex
    bne Del1
    inc Xstart
    dec XEnd
    inc Ystart
    dec YEnd
    inc CharPosition
    lda CharPosition
    cmp #_Char - Char
    beq Next3
    jmp Next

Next3:
    inc NoOfRounds
    lda NoOfRounds
    cmp #(_Char - Char) + 1
    beq Next4
    jmp start 

Next4:
    rts 


Char:
    .encoding "ascii"
    .text " BANKACCOUNT"
_Char:

Text:   .byte 135
        .text " Bank Account"
_Text:

CodeEnd:

// SAVE "MAIN", Codestart, CodeEnd

// 5140 ]
// 5150 Char=P%:$P%=" BANKACCOUNT":P%=P%+12
// 5160 Text=P%:$P%="  Bank Account "
// 5170 NEXT
// 5180 CALL$6000
// 5190 CALL$6000