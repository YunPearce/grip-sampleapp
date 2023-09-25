|%
++  send-to-pharos
  |=  [=ship =ticket]
  ^-  card:agent:gall
  :*  %pass
      /
      %agent
      [ship %pharos]
      %poke
      %pharos-action
      !>([%create-ticket ticket])
  ==
::
+$  action
  $%
  [%create-ticket =ticket]
  ::[%fail-ticket =ticket(?)]
  ==
::
+$  ticket-type 
  $%  %request   :: feature request
      %support   :: support request
      %report    :: bug report
      %document  :: request for documentation
      %general   :: general feedback
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
  +$  state-0  $:  %0  ~
                ==
  +$  card  card:agent:gall
  ++  agent
    |=  inner=agent:gall
    =|  state-0
    ::need state for on/off user privacy 
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
    |=  old=vase
    ^-  (quip card _this)
    ::=/  cards  (on-load:ag old)
    ?.  ?=([[%grip *] *] q.old)
    =^  cards  inner  (on-load:ag old)
    [cards this]
    =+  !<([[%grip old=state-0] =vase] old)
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
            ~&  ticket.pok
            =.  board.ticket.pok  dap.bowl
            =.  version.ticket.pok  *app-version
            ~&   (send-to-pharos dev ticket.pok)
            =.  author.ticket.pok  ?.(anon.ticket.pok our.bowl ~zod)
          :_  this
          :~
            (send-to-pharos dev ticket.pok)
          ==
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
      =^  cards  inner  (on-agent:ag wire sign)
      [cards this]
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
      =^  cards  inner  (on-fail:ag term tang)
      [cards this]
    --
  --
--