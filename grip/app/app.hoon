/+  default-agent, dbug, grip
|%
+$  versioned-state 
  $%  state-0
  ==
+$  state-0  $:  %0  val=@
                 ==
+$  card  card:agent:gall
--  
!:
=|  state-0
=*  state  -
%-  %+  agent:grip
  ~zod               ::dev @p
  *app-version:grip  ::curent version of the app 
::add path for UI
%-  agent:dbug
^-  agent:gall
=<
    |_  =bowl:gall
    +*  this      .
        def   ~(. (default-agent this %.n) bowl)
        hc       ~(. +> bowl)
        ::
++  on-init  
  ^-  (quip card _this)
  `this
::
++  on-save  
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
++  on-poke  on-poke:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
::
|_  bowl=bowl:gall
::
++  dev  ~zod
--