* = $1000

.label ScreenLocation = $C1
.label Rows           = $C3
.label Cols           = $C4

Start:
    lda #12
    jsr $FFE3

    lda #$7D
    sta ScreenLocation + 1
    lda #$FB
    sta ScreenLocation
    lda #3
    sta Rows
    lda #18
    sta Cols
    
LineLooper:
    ldx Cols
    jsr DrawLine

    inc Cols
    inc Cols

    lda ScreenLocation + 1
    cmp #$7B
    bne !ByPassExit+
    jmp *

!ByPassExit:
    // #1 -> #40
    jsr EorAmount

    // SBC -> ADC -> SBC
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

    // #40 -> #1
    jsr EorAmount

    jmp LineLooper

DrawLine:
    lda #64
    ldy #0
    sta (ScreenLocation),y
    dex 
    bne DrawLineCLC
    rts
DrawLineCLC:
    sec
    lda ScreenLocation
DrawLineInstr:
    sbc DrawLineAm: #1
    sta ScreenLocation
    lda ScreenLocation + 1
DrawLineHiInstr:
    sbc #0
    sta ScreenLocation + 1
    jmp DrawLine

EorAmount:
    lda DrawLineAm
    eor #$29
    sta DrawLineAm
    rts
