editw:=420,buttonx:=422,listw:=460,listh:=150,activew:=460,activeh:=320,guiw:=468,guih:=516,title:="Youtube Player ver "1.0,na=1
Gui, main:Add, edit, x2 y-1 w420 h20 ,1
Gui, main:Add, Button, xp+%editw% yp w40 h20 gsearchgui,검색
Gui, main:Add, ListView, x2 yp+20 w%listw% h%listh% vlist1 glist1, 번호|제목|재생시간|주소
Gui, main:Add, ActiveX, x2 yp+%listh% w%activew% h%activeh% vyou, Explorer.Shell
Gui, main:Add, Slider, x372 yp+%activeh% w90 h20 +AltSubmit vsl gsl, 100
Gui, main:Add, ActiveX, x2 y169  vser, Explorer.Shell
GuiControl, hide, ser
you.navigate("about:blank")
gui,main:+Resize -MaximizeBox
Gui, main:Show, x761 y95 h%guih% w%guiw%,%title%
Gui, main:Default 
gui,ListView,list
LV_ModifyCol(1,"36"),LV_ModifyCol(2,"240"),LV_ModifyCol(3,"60 center"),LV_ModifyCol(4,"120")
WinGetPos, mainx, mainy, mainw, mainh,%title%
Gui, search:Add, Edit, x2 y-1 w370 h20 v검색어, 롤
Gui, search:Add, Button, x372 y-1 w60 h20 vsear gsearch, 검색
Gui, search:Add, ListView, x2 y19 w430 h150 vlist2 glist2, 번호|제목|재생시간|주소
Menu, search:listmenu,Add,지금재생
Menu, search:listmenu,Add,재생목록추가
Return
f1::
a:=you.Navigate("javascript: player.getVideoLoadedFraction()")
msgbox,%a%
Clipboard=%a%
return
list1:
if (A_GuiEvent="DoubleClick") { 
event=%A_EventInfo%
you.navigate("http://www.youtube.com/embed/" . guro(event,4,1) . "?&autoplay=1&vq=highres&width=460&height=380&modestbranding=1&showinfo=0")
title:=guro(event,2,1)
WinSetTitle,% title
}
return

list2:
if (A_GuiEvent="R") { 
MouseGetPos, vx, vy, 
Menu, search:listmenu, Show, %vx%, %vy%
}
return

searchgui:
WinGetPos, mainx, mainy, mainw, mainh,%title%
Gui, search:Show, % "x"mainx+mainw "y"mainy "h177 w440", 검색
return

searchGuiClose:
gui,search: Hide
return

mainguisize:
Gui, main:Default 
AutoXYWH("w", "검색어"),AutoXYWH("x", "sear"),AutoXYWH("w", "list1"),dhi:=AutoXYWH("wh", "you"),AutoXYWH("xy", "sl")
return

mainGuiClose:
ExitApp

sl:
gui,submit,NoHide
sl:=sl*2.55
WinSet, Transparent,%sl%
return


/*
f1::
gui,submit,NoHide
WinSet, Transparent,255,%title%
GuiControl, , sl, 255
return

f2::
gui,submit,NoHide
WinSet, Transparent,0,%title%
GuiControl, , sl, 0
return
*/
지금재생:
Gui, search:Default 
gui,ListView,list2
event:=LV_GetNext()
you.navigate("http://www.youtube.com/embed/" . guro(event,4,1) . "?&autoplay=1&vq=highres&width=460&height=380&modestbranding=1&showinfo=0")
title:=guro(event,2,1)
Gui, main:Default 
gui,main:show,,%title%
return

재생목록추가:
Gui, search:Default 
gui,ListView,list2
event:=LV_GetNext()
LV_Add("", na, guro1(event,2,2),guro1(event,3,2),guro1(event,4,2))
na++
return

search:
LV_Delete()
n:=1,b:=1
내용:=Object()
제목:=Object()
시간:=Object()
gui,submit,nohide
ser.navigate("http://www.youtube.com/results?search_query="encode(검색어))
while !(ser.readyState=4 && ser.document.readyState="complete")
continue
source:=ser.document.body.outerHTML
loop,25{
	b:=RegExMatch(source, "watch\?v=(.*?)""", a,b)+30 ;위치찾기
	address:=SubStr(a1, 1, 11)
	b:=RegExMatch(source, "watch\?v=(.*?)</span>", a,b) ;제목,시간찾기
	RegExMatch(a, ">(.*?)</a>", tit)
	StringTrimLeft, tit, tit, 1
	StringTrimRight, tit, tit, 4
	RegExMatch(a, ":(.*?)<", time)
	StringTrimLeft, time, time,2
	StringTrimRight, time, time, 1
	내용[n]:=address
	제목[n]:=tit
	시간[n]:=time
        Gui, search:Default 
        gui,ListView,list2
        LV_Add("", n, 제목[n],시간[n],내용[n])
        LV_ModifyCol(1,"36"),LV_ModifyCol(2,"240"),LV_ModifyCol(3,"60 center"),LV_ModifyCol(4,"120")
	n++
	b:=b+1000
}
return

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

guro(event,col,list) ;구이이벤트,열
{
        gui,ListView,list%list%
	LV_GetText(text,event,col)
	return text
}

guro1(event,col,list) ;구이이벤트,열
{
        Gui, search:Default 
        gui,ListView,list2
        LV_GetText(text,event,col)
        Gui, main:Default 
        gui,ListView,list1
        return text
}

AutoXYWH(DimSize, cList*){       ;
    Gui, main:Default 
  static cInfo := {}
  If (DimSize = "reset")
    Return cInfo := {}
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
        ;wh=x%A_GuiWidth%y%A_GuiHeight%
        ;return wh
} } }

/*
&width=가로,&height=세로
&vq=small(240p),medium(360p),large(480),hd720(720p),hd1080(1080p),highres(원본)
&theme=dark(default),white
&autohide=0,1,2(default)
&showinfo=0,1(default),2
&rel=0,1(default) ;추천동영상
&autoplay=0(default),1
&loop=0(default),1
&fs=0,1(default) 전체화면
&modestbranding=0(default),1 유튜브재생
*/