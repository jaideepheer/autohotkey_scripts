; Creates a tooltip relative to the mouse position and makes the tooltip follow the mouse cursor.
;
; Usage Eg.,
;  toolTip := MouseTooltip.new("Press (Alt + h) to show/hide this tooltip.")
;  toolTip2 := MouseTooltip.new("Second text.", -20, -40)
;  toggle := False
;  !h::
;    toggle := !toggle
;    If (toggle) {
;      toolTip.show()
;      toolTip2.show()
;      } else {
;        toolTip.hide()
;        toolTip2.hide()
;        }
;  return
;
; requires AutoHotkey v2
;========================================== TIP ==========================================
class MouseTooltip
{
  static _instCount := 0
  _curInst := 0
  _withTimeout := False
  _isRunning := False

  timeout := 0
  message := "No message set"
  _X := 0
  _Y := 0

  __New(message := "No message set", x := 20, y := 20, updateInterval := 20)
  {
    ++MouseTooltip._instCount
    this._curInst := MouseTooltip._instCount
    this.message := message
    this._X := x
    this._Y := y
    this._updateInterval := updateInterval
  }

  __Delete()
  {
    this.hide()
  }

  _lastRunTime := 0
  _update()
  {
    if(this.timeout <= 0 && this._withTimeout == True)
    {
      this._isRunning := False
      Tooltip(, , , this._curInst)
      SetTimer(, 0)
    }
    else
    {
      ; update tooltip
      MouseGetPos OutputVarX, OutputVarY
      Tooltip(this.message, this._X+OutputVarX, this._Y+OutputVarY, this._curInst)
      ; update timeout
      if(this._withTimeout == True)
      {
        this.timeout := this.timeout - (A_TickCount - this._lastRunTime)
        this._lastRunTime := A_TickCount
      }
    }
  }

  show(timeout := 0)
  {
    this.timeout := timeout
    this._withTimeout := (timeout>0)
    this._lastRunTime := A_TickCount
    if(this._isRunning == False)
    {
      this._isRunning := True
      SetTimer(this.GetMethod("_update").Bind(this), this._updateInterval)
    }
  }
  hide()
  {
    this.timeout := 0
    this._withTimeout := True
  }
}
;=========================================================================================