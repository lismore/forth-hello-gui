{ ==============FORTH Hello World Windows GUI PoC===========@PatrickLismore 2019=============== }

ONLY FORTH ALSO DEFINITIONS DECIMAL

CREATE AppName ,Z" forth-hello"

[SWITCH HELLO-MESSAGES DEFWINPROC ( -- res ) WM_DESTROY RUN:  0 PostQuitMessage DROP  0 ; SWITCH]

:NONAME  MSG LOWORD HELLO-MESSAGES ; 4 CB: WNDPROC

: THEWINDOW ( -- hwnd )
      0                                 \ extended style
      AppName                           \ window class name
      Z" The FORTH Hello Program"       \ window caption
      WS_OVERLAPPEDWINDOW               \ window style
      CW_USEDEFAULT                     \ initial x position
      CW_USEDEFAULT                     \ y
      CW_USEDEFAULT                     \ x size
      CW_USEDEFAULT                     \ y
      0                                 \ parent window handle
      0                                 \ window menu handle
      HINST                             \ program instance handle
      0                                 \ creation parameter
   CreateWindowEx ;

: DEMO ( -- )
   AppName WNDPROC DefaultClass DROP
   THEWINDOW DUP SW_SHOWDEFAULT ShowWindow DROP
   UpdateWindow DROP
   DISPATCHER DROP ;

: WINMAIN ( -- )
   DEMO 0 ExitProcess ;

' WINMAIN 'MAIN !

LIBRARY WINMM

FUNCTION: PlaySound ( pszSound hmod fdwSound -- b )

CREATE HelloWinPath   INCLUDING HERE OVER 1+ ALLOT ZPLACE

: HelloWin ( -- z-addr)   HelloWinPath ZCOUNT  -NAME
   SWAP DUP >R + 0 SWAP C!  S" \HelloWin.wav" R@ ZAPPEND
   R> ;

: GREETING ( -- )
   S" HelloWin.wav" FILE-STATUS NIP IF  HelloWin
   ELSE  Z" HelloWin.wav"  THEN
   0 SND_FILENAME SND_ASYNC OR PlaySound DROP
   HWND GetDC >R
   ANSI_FIXED_FONT GetStockObject R@ SWAP SelectObject DROP
   HWND R> ReleaseDC DROP ;

: PAINT ( -- )
   HWND PAD BeginPaint ( hdc)
   HWND HERE GetClientRect DROP
   ( hdc)  S" Hello, you are running FORTH to build your Windows Application :-) !" HERE
      DT_SINGLELINE DT_CENTER OR DT_VCENTER OR DrawText DROP
   HWND PAD EndPaint DROP ;

[+SWITCH HELLO-MESSAGES ( -- res )
   WM_CREATE  RUN:  GREETING 0 ;
   WM_PAINT   RUN:  PAINT 0 ;
SWITCH]

{ ------------------Finish up------------------ }

CR
CR .( Type DEMO to run.)
CR

[DEFINED] PROGRAM [IF]

CR .( You may type PROGRAM-SEALED FORTH-HELLO.EXE  to save a turnkey executable)
CR .( of this example named FORTH-HELLO.EXE.)
CR

[THEN]
