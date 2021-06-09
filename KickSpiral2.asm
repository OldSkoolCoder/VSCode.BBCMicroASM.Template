* = $1900

.label ScreenLocation = $C1
.label Rows           = $C3
.label Cols           = $C4

Start:
    lda #12
    jsr $FFE3

    lda #$7B
    sta ScreenLocation + 1
    lda #$FE
    sta ScreenLocation
    lda #25
    sta Rows
    lda #42
    sta Cols
    
LineLooper:
    ldx Cols
    jsr DrawLine

    dec Cols
    dec Cols

    //lda ScreenLocation + 1
    //cmp #$7B
    lda Rows
    //cmp #16
    bpl !ByPassExit+
    lda #$20
    sta $7C29
    jmp *

!ByPassExit:
    // #1 -> #40
    jsr EorAmount

    ldx Rows
    jsr DrawLine

    // ADC -> SBC -> ADC
    jsr EorInstructions

    dec Rows
    dec Rows

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
    clc
    lda ScreenLocation
DrawLineInstr:
    adc DrawLineAm: #1
    sta ScreenLocation
    lda ScreenLocation + 1
DrawLineHiInstr:
    adc #0
    sta ScreenLocation + 1
    jmp DrawLine

EorAmount:
    lda DrawLineAm
    eor #$29
    sta DrawLineAm
    rts

EorInstructions:
    lda DrawLineCLC
    eor #$20
    sta DrawLineCLC
    lda DrawLineInstr
    eor #$80
    sta DrawLineInstr
    sta DrawLineHiInstr
    rts
