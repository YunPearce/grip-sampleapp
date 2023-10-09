/-  *hood
::get rid of schooner and serever lib 
/+  schooner, server
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
  |=  [dev=ship version=app-version ui-path=path]
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
      =^  cards  inner  (on-poke:ag mark vase)
      ?+  mark  `this::[cards this]
      %grip
        ?>  =(src.bowl our.bowl)
        =/  pok  !<(action vase)
        ?-  -.pok
          %create-ticket 
            =.  board.ticket.pok    dap.bowl
            =.  version.ticket.pok  *app-version
            =.  author.ticket.pok   ?.(anon our.bowl ~zod)
          :_  this
          :~
            (send-to-pharos dev ticket.pok)
          ==
          %set-anon
          `this(anon +.pok)
          ::
          %set-enabled
          `this(auto-enabled +.pok)
        ==
      
      %handle-http-request
      ?>  =(src.bowl our.bowl)
      =/  req  !<([eyre-id=@ta =inbound-request:eyre] vase)
      =/  site  site:(parse-request-line:server url.request.inbound-request.req)
      =+  send=(cury response:schooner eyre-id.req)
      =*  dump   [cards this]
      ::
      =^  cards  state
        ^-  (quip card _state)
        dump
        ?+    method.request.inbound-request.req  dump
          ::
            %'GET'
            ~&  site
            ?.  =(ui-path (snip site))  dump
              ::  fallback: forward poke to wrapped agent core
            =/  site=(list @t)  (oust [0 2] site)  :: now we know this isn't ~
            ?:  =(~ site)  dump
              ::  fall back if the path ends here
            ?+  site  dump
            ::check if url == "{ui-path}"
            [%report ~]
            :_  this
            %-  send 
            [200 ~ [%manx home]]
            ==
        ==
      ==
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      =^  cards  inner  (on-watch:ag path)
      [cards this]
      ::`this
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
      [cards this]
  --
::
++  page
  |=  kid=manx
  ^-  manx
  ;html
    ;head
      ;title: Ticket
      ;meta(charset "utf-8");
      ;style: {style}
    ==
    ;body
      ;+  kid
    ==
  ==
::
++  home
  %-  page
  ;div.main
    ;h1: Support ticket form
    ;div.form
    ;form(method "post")
        ;label.check(for "anon"): Want to remain anonymous?
        ;input(type "checkbox", name "anon", value "&");
        ;h3: By remaining anonymous your @p wont be shared with developer.
        ;h3: By adding your @p developer may be able to provide you more detailed support.
        ;label(for "ticket-type"): How can we help you?
        ;select(name "ticket-type")
          ;option(value "request");
          ;option(value "support");
          ;option(value "report");
          ;option(value "document");
          ;option(value "general");
          ==
        ;label(for "title" value:"{title.ticket}"): Describe the problem
        ;input(type "text", name "title", value "");
        ;label(for "body"): Additional details
        ;textarea(type "text", name "body", value "");
        ;button(type "submit"):"submit"
      ==
    ==
    ::==
  ==
::
++  style
  ^~
  %-  trip
  '''
  :root {
    --measure: 70ch;
  }
  .main {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 3px solid black;
  padding: 10px;
  }
  h1{
  text-align:center;
  width: 100%;
  margin: auto;
  }
  h3{
  color: #727272;
  font-size: 11px;
  width: 100%;
  margin: auto;
  }
  input[type=text], textarea, select{
  width: 100%;
  padding: 12px;
  margin: 3px;
  border: 1px solid black;
  resize: vertical;
  }
  label {
  width: 100%;
  margin:3px;
  display: inline-block;
  }
  input[type=checkbox]{
  height: 20px;
  width: 20px;
  }
  .check{
  width: 50%;
  margin:3px;
  display: inline-block;
  }
  input[type=submit] {
  background-color: #04AA6D;
  color: white;
  padding: 12px 20px;
  border: none;
  cursor: pointer;
  float: right;
  }
  textarea{
  resize: none;
  height: 150px;
  }
  button{
  width: 100%;
  margin:3px;
  display: inline-block;
  background: white;
  border: 1px solid black;
  }
  button:hover{
  background: black;
  color: white;
  }
  '''
--
--