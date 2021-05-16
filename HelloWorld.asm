\ Simple example illustrating use of BeebAsm

oswrch = &FFEE
osasci = &FFE3
addr = &70

ORG &2000         ; code origin (like P%=&2000)

.start
    LDA #22
    JSR oswrch
    LDA #7
    JSR oswrch
    LDA #mytext MOD 256
    STA addr
    LDA #mytext DIV 256
    STA addr+1
    LDY #0

.loop
    LDA (addr),Y
    BEQ finished
    JSR osasci
    INY
    BNE loop
    
.finished
    RTS

.mytext EQUS "Hello world!", 13, 0
.end

SAVE "MAIN", start, end