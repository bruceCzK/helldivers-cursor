#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
#MaxThreadsPerHotkey 2

ProcessIdentifier := "ahk_exe helldivers.exe"
CrosshairId := ""
CrosshairImage := "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAgMAAAAqbBEUAAAADFBMVEX///8AAAAA/yER/yMGwUjdAAAATElEQVR4Xt3SMQoAIAiGUZfu1+Li0ulc/vs1W0IgCo0tfYs8cBEk3tHOZ4YA6hhmsyDWKjqd2lNwgDN+637pCOhTxFNUmE2HABn3r1r9oEm3lJSOlAAAAABJRU5ErkJggg=="

MainLabel:
    GenerateCrosshair()
    SetTimer, UpdateCrosshair, 10
Return

GenerateCrosshair() {
    global CrosshairId

    Gui, New, +E0x20 -Caption +LastFound +ToolWindow +AlwaysOnTop -DPIScale
    Gui, Color, FFFFFF
    WinSet, TransColor, FFFFFF
    Gui, Margin, 0, 0

    Gui, Add, ActiveX, w64 h64 +BackgroundTrans, % "mshtml:<img src='" CrosshairImage "' />"
    Gui, Show, w64 h64 x-64 y-64

    CrosshairId := WinExist()
    WinHide, ahk_id %CrosshairId%
    SetWinDelay, 0
    CoordMode, Mouse, Screen
}

UpdateCrosshair:
    global CrosshairId

    If (WinActive(ProcessIdentifier)) {
        If (WinVisible("ahk_id " . CrosshairId) == 0) {
            WinShow, ahk_id %CrosshairId%
            WinActivate, %ProcessIdentifier%
        }

        MouseGetPos, MousePosX, MousePosY
        MousePosX := MousePosX - 32
        MousePosY := MousePosY - 32
        WinMove, ahk_id %CrosshairId%, , MousePosX, MousePosY
    }
    Else {
        WinHide, ahk_id %CrosshairId%
    }
Return

; https://autohotkey.com/board/topic/1555-determine-if-a-window-is-visible/?p=545045
WinVisible(WinTitle) {
    WinGet, Style, Style, %WinTitle%
    Transform, Result, BitAnd, %Style%, 0x10000000 ; 0x10000000 is WS_VISIBLE.
    if Result <> 0 ;Window is Visible
        Return 1
    Else  ;Window is Hidden
        Return 0
}

GuiClose:
    ExitApp
Return
