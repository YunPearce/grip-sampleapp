/-  *hood
::get rid of schooner and serever lib 
/+  schooner, server
|%
+$  action
  $%
  [%create-ticket =ticket]
  [%set-enabled enabled=?]
  ::[%fail-ticket =ticket(?)]
  ==
::
+$  ticket-type 
  $?  %request   :: feature request
      %support   :: support request
      %report    :: bug report
      %document  :: request for documentation
      %general   :: general feedback
  ==
+$  ticket
  $:  =desk
      title=@t
      body=@t
      author=@p
      anon=?
      =app-version
      =ticket-type
      ==
+$  app-version
  [major=@ud minor=@ud patch=@ud]
  ::
++  agent
  |=  [dev=ship version=app-version ui-path=path]
  ^-  $-(agent:gall agent:gall)
  |^  agent
  ::
  +$  state-0  $:  %0  
                  auto-enabled=?
                ==
  +$  card  card:agent:gall
  ++  agent
    |=  inner=agent:gall
    =|  state-0
    =*  state  -
    ^-  agent:gall
    |_  =bowl:gall
    +*  this  .
        ag    ~(. inner bowl)
    ::
    ++  on-init
      ^-  (quip card _this)
      =.  auto-enabled  %.n
      ~&  ['auto' auto-enabled]
      =^  cards  inner  on-init:ag
      [cards this]
    ::
    ++  on-save  
    !>([[%grip state] on-save:ag])
    ::
    ++  on-load  
    |=  val=vase
    ^-  (quip card _this)
    ?.  ?=([[%grip *] *] q.val)
      =.  auto-enabled  %.n
      ~&  ['auto' auto-enabled]
      =^  cards  inner  (on-load:ag val)
      [cards this]
      ::
    =+  !<([[%grip old=state-0] =vase] val)
    =.  state  old
    =^  cards  inner  (on-load:ag vase)
    [cards this]
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      |^
      ?+  mark  [inner-cards this]
      %grip
        ?>  =(src.bowl our.bowl)
        =/  pok  !<(action vase)
        ?-  -.pok
          %create-ticket 
            =.  desk.ticket.pok    dap.bowl
            =.  app-version.ticket.pok  *app-version
            =.  author.ticket.pok   ?.(anon.ticket.pok our.bowl ~zod)
            ~&  ticket.pok
            ~&  dev
          :_  this
          :~  (send-to-pharos dev ticket.pok)
          ==
          ::
          %set-enabled
          `this(auto-enabled +.pok)
        ==
      %handle-http-request
      ?>  =(src.bowl our.bowl)
      =/  req  !<([eyre-id=@ta =inbound-request:eyre] vase)
      ::=/  site  site:(parse-request-line:server url.request.inbound-request.req)
      =/  ,request-line:server  (parse-request-line:server url.request.inbound-request.req)
      =+  send=(cury response:schooner eyre-id.req)
      =*  dump   [inner-cards this]
      :: =^  cards  state
        :: ^-  (quip card _state)
        :: dump
        ?+    method.request.inbound-request.req  dump
          ::
            %'GET'
            ~&  `(list @ta)`(swag [0 2] site)
            ?.  =(ui-path `(list @ta)`(swag [0 2] site))  dump
              ::  fallback: forward poke to wrapped agent core
            =/  new-site=(list @t)  (oust [0 2] site)  :: now we know this isn't ~
            =/  url=tape  (to-tape-url (welp ui-path [~.new-ticket ~]))
            =/  sett-url  (to-tape-url (welp site /settings))
            ?:  =(~ new-site)  dump
            ?+  new-site  dump
            [%report ~]
            :_  this
            %-  send 
            [200 ~ [%manx (home url sett-url)]]
            ::
            [%report %settings ~]
            ~&  ['auto' =(auto-enabled %.n)]
            :_  this
            %-  send 
            ::[200 ~ [%manx (home-setting "./settings-update" auto-enabled)]]
            [200 ~ [%manx (home-setting "./settings-update" =(auto-enabled %.y))]]
            ==
           %'POST'
            ?.  =(ui-path (snip site))  dump
              ::  fallback: forward poke to wrapped agent core
            =/  site=(list @t)  (oust [0 2] site)  :: now we know this isn't ~
            ?:  =(~ site)  dump
              ::  fall back if the path ends here
            ?+  site  dump
            ::
            [%new-ticket ~]
              ?~  body.request.inbound-request.req
                :_  this
                %-  send  [405 ~ [%stock ~]]
              =/  jon=(unit json)  (de:json:html q.u.body.request.inbound-request.req)
              ~&  `@t`q.u.body.request.inbound-request.req
              =/  =ticket  (to-ticket (need jon))
              =/  url  (crip +:(to-tape-url (welp :~(~...) +.ui-path)))
              :_  this
              %+  welp
              %-  send  [302 ~ [%redirect url]]
              :~  [%pass /self-poke %agent [our.bowl dap.bowl] %poke %grip !>([%create-ticket ticket])]
              ==
            [%settings-update ~]
            ~&  'setting-update'
              ?~  body.request.inbound-request.req
                :_  this
                %-  send  [405 ~ [%stock ~]]
              =/  =json  (need (de:json:html q.u.body.request.inbound-request.req))
              =.  auto-enabled  ?:  =((auto:dejs json) 'true')  &  |
              ~&  ['updated' auto-enabled]
              ~&  ['json' (auto:dejs json)]
              :_  this
              %-  send  [302 ~ [%redirect '../app/report']]
          ==
        ==
      ==
      ++  to-tape-url
      |=  site=path
      ^-  tape
      (sa:dejs:format (path:enjs:format site))
      ::
      ++  inner-cards
      =^  cards  inner  (on-poke:ag mark vase)
      cards
      --
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      ::=^  cards  inner  (on-watch:ag path)
      ::[cards this]
      `this
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
      [%self-poke ~]
    ?.  ?=(%poke-ack -.sign)
      (on-agent wire sign)
    ?~  p.sign
      %-  (slog '%self-poke succeeded!' ~)
      `this
    %-  (slog '%self-poke failed!' ~)
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
      ::=/  cards  
      ::~&  ['enabled' auto-enabled]
      ::?:  =(auto-enabled &) ::CHANGE BACK TO &
      ~&  (send-to-pharos dev (on-fail-ticket dap.bowl our.bowl now.bowl))
      ::   :_  this
      ::   :~  (send-to-pharos dev (on-fail-ticket dap.bowl our.bowl now.bowl anon))
      ::   ==
      =^  cards  inner  (on-fail:ag term tang)
      [cards this]
  --
::
++  send-to-pharos
  |=  [=ship =ticket]
  ^-  card:agent:gall
  ~&  [%create-ticket ticket]
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
|=  [dap=@tas our=@p now=@da]
=/  body-vats  (vats our now)
^-  ticket 
::=/  =ticket
:*
    desk=dap
    title='on-fail'
    body=body-vats
    author=our
    anon=|
    app-version=*app-version
    =%report 
==

:: ?:  =(anon &)  ticket 
:: =.  author.ticket  ~zod 
:: ticket
::
++  to-ticket 
|=  =json
^-  ticket 
=/  val=[title=@t body=@t tt=@t anon=@t]  (json-ticket:dejs json)
=/  tt  (tt-check tt.val)
:*  
    desk=*@tas
    title=title.val
    body=body.val
    author=~zod
    anon=?~(anon.val | &)
    app-version=*app-version
    ticket-type=tt
==
::
  ++  tt-check 
  |=  i=@t
  %-  ticket-type  i
  ::
  ++  dejs
  =,  dejs:format 
  |%  
  ++  json-ticket
  %-  ou
  :~  [%title (un so)]
      [%body (un so)]
      [%ticket-type (un so)]
      [%anon (uf '' so)]
  ==
  ++  auto
  %-  ou
  :~  [%auto (un so)]
  ==
  --
::
++  page
  |=  kid=manx
  ^-  manx
  ;html
    ;head
      ;title: Ticket
      ;meta(charset "utf-8");
      ;script
        =crossorigin  "anonymous"
        =integrity    "sha384-aOxz9UdWG0yBiyrTwPeMibmaoq07/d3a96GCbb9x60f3mOt5zwkjdbcHFnKH8qls"
        =src          "https://unpkg.com/htmx.org@1.9.0";
      ;script
        =crossorigin  "anonymous"
        =integrity    "sha384-nRnAvEUI7N/XvvowiMiq7oEI04gOXMCqD3Bidvedw+YNbj7zTQACPlRI3Jt3vYM4"
        =src          "https://unpkg.com/htmx.org@1.9.0/dist/ext/json-enc.js";
      ;style: {style}
    ==
    ;body(hx-ext "json-enc,include-vals")
      ;+  kid
    ==
  ==
::
++  home
|=  [path=tape sett-path=tape]
  %-  page
  ;div.page
  ;button.set-btn(hx-get sett-path, hx-swap "outerHTML"): Settings
  ;div.main
    ;h1: Support ticket form
    ;div.form
    ;form
        ;label.check(for "anon"): Want to remain anonymous?
        ;input(type "checkbox", name "anon", value "true", defaultvalue "false");
        ;h3: By remaining anonymous your @p wont be shared with developer.
        ;h3: By adding your @p developer may be able to provide you more detailed support.
        ;label(for "ticket-type"): How can we help you?
        ;select(name "ticket-type")
          ;option(value "request"):  Feature ideas
          ;option(value "support"):  Support request
          ;option(value "report"):   Report bug
          ;option(value "document"): Request to provide documetation
          ;option(value "general"):  Leave feedback
          ==
        ;label(for "title"): Describe the problem
        ;input(type "text", name "title");
        ;label(for "body"): Additional details
        ;textarea(type "text", name "body");
        ;button(hx-post path, hx-target "body", hx-push-url "true"): submit
      ==
    ==
  ==
  ==
++  home-setting
|=  [path=tape auto=?]
  %-  page
  ;div.page
        ;form.settings
        ;button.set: X
        ;h2: This app supports automatic crush report
        ;+  ?:  auto
         ;input(type "hidden", name "auto", value "false");
        ;input(type "hidden", name "auto", value "true");
        ;button.set(hx-post path, hx-target "body", hx-push-url "true")
            ;+  ?:  auto
              ;/  "disable" 
            ;/  "enable"
        ==
    ==
  ==
::
++  style
  ^~
  %-  trip
  '''
  :root {
  --measure: 70ch;
  font-family: Lora, serif;
  }
  .page{
  margin: auto;
  width: 50%;
  padding: 10px;
  color: #197489;
  font-family: Lora, serif;
  }
  .main {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 5px solid #78c6ce;
  padding: 10px;
  background-color: #78c6ce;
  }
  .settings{
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border: 5px solid #197489;
  padding: 10px;
  z-index:3;
  background-color: #197489;
  color: white;
  }
  .set{
  background: #78c6ce;
  border: 2px solid #78c6ce;
  width:auto;
  margin: auto;
  padding:10px;
  float:right;
  }
  .set:hover{
  background: #197489;
  border: #78c6ce;
  color: white;
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
  border: none;
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
  background: #197489;
  border: 2px solid #197489;
  color: white;
  }
  button:hover{
  background: #197489;
  border: #197489;
  color: white;
  }
  .set-btn{
  border: 2px solid #197489;
  width:auto;
  margin: auto;
  padding:10px;
  float:right;
  }
  '''
--
--