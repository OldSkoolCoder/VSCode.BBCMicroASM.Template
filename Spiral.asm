ORG &6000

OSASCI          = &FFE3

ScreenLocation  = $C1
Rows            = $C3
Cols            = $C4

.CodeStart
    LDA #12
    JSR &FFE3

.Start
    lda #$7D
    sta ScreenLocation + 1
    lda #$FB
    sta ScreenLocation
    lda #3
    sta Rows
    lda #18
    sta Cols

.LineLooper
    ldx Cols
    jsr DrawLine

    inc Cols
    inc Cols

    lda ScreenLocation + 1
    cmp #&7B
    bne ByPassExit
    jmp *

.ByPassExit
    \ #1 -> #40
    jsr EorAmount

    \ SBC -> ADC -> SBC
    lda DrawLineCLC
    eor #$20
    sta DrawLineCLC
    lda DrawLineInstr
    eor #$80
    sta DrawLineInstr
    sta DrawLineHiInstr

    ldx Rows
    jsr DrawLine

    inc Rows
    inc Rows

    \ #40 -> #1
    jsr EorAmount

    jmp LineLooper

.DrawLine
    lda #64
    ldy #0
    sta (ScreenLocation),y
    dex 
    bne DrawLineCLC
    rts

.DrawLineCLC
    sec
    lda ScreenLocation
.DrawLineInstr
    sbc #1
    sta ScreenLocation
    lda ScreenLocation + 1
.DrawLineHiInstr
    sbc #0
    sta ScreenLocation + 1
    jmp DrawLine

.EorAmount
    lda DrawLineInstr + 1
    eor #$29
    sta DrawLineInstr + 1
    rts

.CodeEnd

SAVE "MAIN", CodeStart, CodeEnd
