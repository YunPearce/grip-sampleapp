/+  default-agent, dbug, grip
/=  index  /app/index
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
%-  %-  agent:grip
  :*
  ~zod                    ::dev @p
  *app-version:grip       ::curent version of the app 
  /apps/app               ::add path for UI
  ==                  
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
  :_  this
  :~  [%pass /eyre %arvo %e %connect [~ /apps/app] %app]
  ==
  ::`this
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
++  on-poke   
|=  [=mark =vase]
^-  (quip card _this)
|^
  ?+  mark  (on-poke:def mark vase)
  %noun
  =/  act  !<(?(%timer) vase)
  ?-  act
  %timer  
  :_  this
  :~  [%pass /timer %arvo %b [%wait `@da`(add now.bowl ~s10)]]
  ==
  ==
   %handle-http-request  
   (handle-http !<([@ta =inbound-request:eyre] vase))
  ==
  ::
  ++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^-  (quip card _this)
  =/  dump
  %^    give-http
      eyre-id
    :-  405
    :~  ['Content-Type' 'text/html']
        ['Content-Length' '31']
        ['Allow' 'GET, POST']
    ==
    (some (as-octs:mimes:html '<h1>405 Method Not Allowed</h1>'))
  ?.  authenticated.inbound-request
    :_  this
    (give-http eyre-id [307 ['Location' '/~/login?redirect='] ~] ~)
  ?+    method.request.inbound-request
  [dump this]
  %'GET'
  ::?+  site  [dump this]
  ::[%apps %app]
   :_  this 
    (make-200 eyre-id index)
    ::==
  ==
  --
++  on-arvo   
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  wire  (on-arvo:def wire sign-arvo)
  [%eyre *]
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:def [wire sign-arvo])
  ?:  accepted.sign-arvo
    %-  (slog leaf+"/apps/app bound successfully!" ~)
    `this
  %-  (slog leaf+"Binding /apps/app failed!" ~)
 `this
  [%timer *]
  ~|('I forced this crash!' !!)
   ==
::
++  on-agent  on-agent:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
::
|_  bowl=bowl:gall
::
++  make-200
  |=  [eyre-id=@ta dat=octs]
  ^-  (list card)
  %^    give-http
      eyre-id
    :-  200
    :~  ['Content-Type' 'text/html']
        ['Content-Length' (crip ((d-co:co 1) p.dat))]
    ==
  [~ dat]
++  give-http
  |=  [eyre-id=@ta hed=response-header:http dat=(unit octs)]
  ^-  (list card)
  :~  [%give %fact ~[/http-response/[eyre-id]] %http-response-header !>(hed)]
      [%give %fact ~[/http-response/[eyre-id]] %http-response-data !>(dat)]
      [%give %kick ~[/http-response/[eyre-id]] ~]
  ==
--