gui, Add, Button, x+5 ym    w55  h25  default g�˻�, �˻�
gui,add,edit,x+5 ym w100 h25 v�˻���,��
Gui, Add, ActiveX,x10  y+10 w1200 h800 border vwb, Explorer.Shell
gui,show,x500 y500 ,youtube
wb.navigate("http://www.youtube.com/embed/EyyepT8tyL8?&autoplay=1")
Return
GuiClose:
exitapp
�˻�:
gui,submit,nohide
wb.navigate("http://www.youtube.com/results?search_query="UriEncode(�˻���))
while !(wb.readyState=4 && wb.document.readyState="complete")
continue
HTML:=wb.document.body.outerHTML
b:=RegExMatch(html, "watch\?v=(.*?)""", a)+30 ;��ġã��
address:=SubStr(a1, 1, 11)
RegExMatch(html, "watch\?v=(.*?)</span>", a,b) ;����,�ð�ã��
RegExMatch(a, ">(.*?)</a>", title)
StringTrimLeft, title, title, 1
StringTrimRight, title, title, 4
RegExMatch(a, ":(.*?)<", time)
StringTrimLeft, time, time,2
StringTrimRight, time, time, 1
msgbox,����=%address%`n����=%title%`n�ð�=%time%
return
f1::

return
UriEncode(Uri, Enc = "UTF-8") {
	StrPutVar2(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop {
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
		Break
		If (Code >= 0x30 && Code <= 0x39
		|| Code >= 0x41 && Code <= 0x5A
		|| Code >= 0x61 && Code <= 0x7A)
		Res .= Chr(Code)
		Else
		Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}
StrPutVar2(Str, ByRef Var, Enc = "") {
Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
VarSetCapacity(Var, Len, 0)
Return, StrPut(Str, &Var, Enc)
}


encode(string) {
    formatInteger := A_FormatInteger
    SetFormat, IntegerFast, H
    VarSetCapacity(utf8, StrPut(string, "UTF-8"))
    Loop % StrPut(string, &utf8, "UTF-8") - 1
    {
        byte := NumGet(utf8, A_Index-1, "UChar")
        encoded .= byte > 127 ? "%" Substr(byte, 3) : Chr(byte)
    }
    SetFormat, IntegerFast, %formatInteger%
    return encoded
}