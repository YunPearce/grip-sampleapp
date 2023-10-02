/-  *hood
|%
++  send-to-pharos
  |=  [=ship =ticket]
  ^-  card:agent:gall
  :*  %pass
      /pharos
      %agent
      [ship %pharos]
      %poke
      %pharos-action
      !>([%create-ticket ticket])
  ==
::
::vats need proper parcing to body msg 
++  vats 
|=  [our=@p now=@da]
^-  @t
=/  desks              .^((set desk) %cd /(scot %p our)//(scot %da now))
=/  deks=(list desk)   ~(tap in desks)
=/  vat
    %+  turn  deks 
    |=(a=desk (flop (report-vat (report-prep our now) our now a |)))
%-  crip  ~(ram re [%rose [" " "" ""] (zing vat)])
::
++  on-fail-ticket
|=  [dap=@tas our=@p now=@da anon=?]
=/  body-vats  (vats our now)
^-  ticket 
=/  =ticket
:*
    board=dap
    title='on-fail'
    body=body-vats
    author=our
    anon=anon
    version=*app-version
    =%report 
==
?:  =(anon &)  ticket 
=.  author.ticket  ~zod 
ticket
::
+$  action
  $%
  [%create-ticket =ticket]
  [%set-anon anon=?]
  [%set-enabled enabled=?]
  ::[%fail-ticket =ticket(?)]
  ==
::
+$  ticket-type 
  $%  %request   :: feature request
      %support   :: support request
      %report    :: bug report
      %document  :: request for documentation
      %general   :: general feedback
      ::type for on-fail
  ==
+$  ticket
  $:  board=term
      title=@t
      body=@t
      author=@p
      anon=?
      version=app-version
      =ticket-type
      ::contact-further
      ==
+$  app-version
  [major=@ud minor=@ud patch=@ud]
  ::
++  agent
  |=  [dev=ship version=app-version]
  ^-  $-(agent:gall agent:gall)
  |^  agent
  ::
  +$  versioned-state 
    $%  state-0
    ==
  +$  state-0  $:  %0  
                  anon=?           ::by default anon on
                  auto-enabled=_|  ::by default auto tickets disabled
                ==
  +$  card  card:agent:gall
  ++  agent
    |=  inner=agent:gall
    =|  state-0
    :: provide ui page by default to ask about on-fail auto report 
    =*  state  -
    ^-  agent:gall
    |_  =bowl:gall
    +*  this  .
        ag    ~(. inner bowl)
    ::
    ++  on-init
      ^-  (quip card _this)
      =^  cards  inner  on-init:ag
      [cards this]
    ++  on-save  
    !>([[%grip state] on-save:ag])
    ::
    ++  on-load  
    |=  val=vase
    ^-  (quip card _this)
    ?.  ?=([[%grip *] *] q.val)
    ::    is it a good practice ?
    =.  anon           &
    =.  auto-enabled   |
    =^  cards  inner  (on-load:ag val)
    [cards this]
    =+  !<([[%grip old=state-0] =vase] val)
    =.  state  old
    =^  cards  inner  (on-load:ag vase)
    [cards this]
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      ?:  ?=(%grip mark)
        ?>  =(src.bowl our.bowl)
        =/  pok  !<(action vase)
        ?-  -.pok
            %create-ticket 
            ::~&  ticket.pok
            =.  board.ticket.pok  dap.bowl
            =.  version.ticket.pok  *app-version
            ::~&   (send-to-pharos dev ticket.pok)
            =.  author.ticket.pok  ?.(anon our.bowl ~zod)
          :_  this
          :~
            (send-to-pharos dev ticket.pok)
          ==
          %set-anon
          ~&  anon
          `this(anon +.pok)
          %set-enabled
          `this(auto-enabled +.pok)
       ==
      ::
      =^  cards  inner  (on-poke:ag mark vase)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      =^  cards  inner  (on-watch:ag path)
      [cards this]
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card _this)
      =^  cards  inner  (on-leave:ag path)
      [cards this]
    ::
    ++  on-peek
      |=  =path
      ^-  (unit (unit cage))
      (on-peek:ag path)
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
    ?+    wire  (on-agent wire sign)
      [%pharos ~]
    ?.  ?=(%poke-ack -.sign)
      (on-agent wire sign)
    ?~  p.sign
      %-  (slog '%poke succeeded!' ~)
      `this
    %-  (slog 'poke failed!' ~)
    `this
    ==
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card _this)
      =^  cards  inner  (on-arvo:ag wire sign-arvo)
      [cards this]
    ::
    ++  on-fail
      |=  [=term =tang]
      ^-  (quip card _this)
      =/  cards  
        ?:  =(auto-enabled &)
          :~  (send-to-pharos dev (on-fail-ticket dap.bowl our.bowl now.bowl anon))
          ==
        ~
      ~&  [auto-enabled cards]
       ::=/  report  (report-vat (report-prep our.bowl now.bowl) our.bowl now.bowl %grip |)
       ::~&  byk.bowl
      [cards this]
    ::
    --
  --
--