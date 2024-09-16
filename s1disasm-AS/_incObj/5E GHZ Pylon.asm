FGObject:
        moveq    #0,d0
        move.b    obRoutine(a0),d0
        move.w    FGObject_Index(pc,d0.w),d1
        jmp    FGObject_Index(pc,d1.w)
; ===========================================================================
FGObject_Index:    dc.w FGObject_Main-FGObject_Index
        dc.w FGObject_Display-FGObject_Index
; ===========================================================================

FGObject_Main:
        addq.b    #2,obRoutine(a0)
        move.l    #Map_PylonGHZ,obMap(a0) ; Add mappings here!
        move.w    #$C000,obGfx(a0) ; Tweak this to change VRAM location tied to object!
        move.b    #$10,obRender(a0) ; This must always be at least $10! The $10 in this ensures it displays in front of all level art.
        move.b    #32,obActWid(a0)
        move.b  #$40,obHeight(a0)
        move.b    #0,obPriority(a0) ; This ensures it displays in front of almost ALL sprites.
        move.w    obX(a0), $30(a0) ; Move this here to ensure proper sprite deletion.

FGObject_Display:
    ;-- Thank you based pylon --
        move.w    $30(a0), d1 ; Store the original X position in d1....
        move.w  d1,d2 ; ... and make sure to allow us to readd it in d2 so we don't assume we are at X = 0.
        subi.w  #$A0,d1 ; Subtract A0 from d1.
        sub.w   (v_screenposx).w,d1 ; Subtract the current screen position from d1.
        asr.w    #1,d1 ; Divide d1 by 2. (Tweak this to get different scroll rates!)
        add.w    d2, d1 ; Add the base X position to our offset.
        move.w    d1, obX(a0) ; Here's our new X position!
       
    displaydelete:
        jsr    DisplaySprite
     ;   out_of_range    delete,$30(a0)
        rts  
       
delete:
        jmp DeleteObject		