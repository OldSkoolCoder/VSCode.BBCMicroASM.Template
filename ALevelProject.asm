OSWRCH      = &FFEE
OSASCI      = &FFE3

NoOfRounds  = &78
XStart      = &72
YStart      = &73
XEnd        = &75
YEnd        = &76
ScreenPos   = &70
CharPosition= &74
Character   = &77

NoOfCols    = 39
NoOfRows    = 24

ScreenRam   = &7C00

TitleStart  = &7DEC
TitleEnd    = &7DFB

\4450 FOR C = 0 TO 2 STEP 2
\4460 P%=&6000
\4470 [OPTC

ORG &6000

.CodeStart
    LDA #12
    JSR &FFE3
    LDA #0
    STA NoOfRounds

.Start
    LDA #0   
    STA XStart
    STA YStart
    STA ScreenPos
    STA CharPosition  
    LDY #0

.Print
    LDA Text,Y
    STA TitleStart,Y
    INY
    CPY #_Text - Text
    BNE Print

    LDA NoOfRounds
    LSR A
    CLC
    ADC #129
    STA TitleEnd
    LDA #>ScreenRam
    STA ScreenPos + 1
    LDA #NoOfCols
    STA XEnd
    LDA #NoOfRows
    STA YEnd

.Next
    LDX CharPosition
    LDA Char,X
    CPX #0
    BNE Next1
    LDA NoOfRounds
    LSR A
    CLC
    ADC #129 

.Next1
    STA Character
    LDA NoOfRounds
    AND #1
    CMP #1
    BNE TopStart
    LDA XStart
    CMP #1
    BCC TopStart
    LDA #32
    STA Character

.TopStart
    LDY XStart

.Top 
    LDA Character
    STA (ScreenPos),Y
    INY
    CPY XEnd
    BNE Top
    LDX YStart
    LDY XEnd

.Right
    LDA Character
    STA (ScreenPos),Y
    CLC
    LDA ScreenPos
    ADC #40
    STA ScreenPos
    LDA ScreenPos + 1 
    ADC #0
    STA ScreenPos + 1
    INX
    CPX YEnd
    BNE Right
    LDY XEnd

.Bottom
    LDA Character
    STA (ScreenPos),Y
    DEY
    CPY XStart
    BNE Bottom
    LDX YEnd
    LDY XStart

.Left
    LDA Character
    STA (ScreenPos),Y
    SEC
    LDA ScreenPos
    SBC #40
    STA ScreenPos
    LDA ScreenPos + 1
    SBC #0
    STA ScreenPos + 1
    DEX
    CPX YStart
    BNE Left
    CLC
    LDA ScreenPos
    ADC #40
    STA ScreenPos
    LDA ScreenPos + 1
    ADC #0
    STA ScreenPos + 1
    LDX #32

.Del1
    LDY #255

.Del2
    DEY
    BNE Del2
    DEX
    BNE Del1
    INC XStart
    DEC XEnd
    INC YStart
    DEC YEnd
    INC CharPosition
    LDA CharPosition
    CMP #_Char - Char
    BEQ Next3
    JMP Next

.Next3 
    INC NoOfRounds
    LDA NoOfRounds
    CMP #(_Char - Char) + 1
    BEQ Next4
    JMP Start 

.Next4
    RTS 


.Char   EQUS " BANKACCOUNT"
._Char

.Text   EQUS 135, " Bank Account"
._Text

.CodeEnd

SAVE "MAIN", CodeStart, CodeEnd

\5140 ]
\5150 Char=P%:$P%=" BANKACCOUNT":P%=P%+12
\5160 Text=P%:$P%="  Bank Account "
\5170 NEXT
\5180 CALL&6000
\5190 CALL&6000