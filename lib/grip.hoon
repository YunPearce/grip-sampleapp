/-  *hood
::get rid of schooner and serever lib 
/+  schooner, server
|%
+$  action
  $%
  [%create-ticket =ticket]
  [%set-enabled enabled=?]
  ==
::
+$  ticket-type 
  $?  %request   :: feature request
      %support   :: support request
      %report    :: bug report
      %document  :: request for documentation
      %general   :: general feedback
  ==
  ::
+$  ticket
  $:  =desk
      title=@t
      body=@t
      author=@p
      anon=?
      =app-version
      =ticket-type
      ==
  ::
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
      =/  ,request-line:server  (parse-request-line:server url.request.inbound-request.req)
      =+  send=(cury response:schooner eyre-id.req)
      =*  dump   [inner-cards this]
        ?+    method.request.inbound-request.req  dump
          ::
            %'GET'
            ?.  =(ui-path `(list @ta)`(swag [0 2] site))  dump
              ::  fallback: forward poke to wrapped agent core
            =/  url       (to-tape-url (welp ui-path /new-ticket))
            =/  sett-url  (to-tape-url (welp site /settings))
            =.  site      (oust [0 2] site)  :: now we know this isn't ~
            ?~  site  dump
            ?+  site  dump
            ::
            [%report ~]
            :_  this
            %-  send 
            [200 ~ [%manx (home url sett-url)]]
            ::
            [%report %settings ~]
            ~&  ['auto' =(auto-enabled %.n)]
            :_  this
            %-  send 
            [200 ~ [%manx (home-setting =(auto-enabled %.y))]]
            ==
          ::
           %'POST'
            ?.  =(ui-path (snip site))  dump   ::  fallback: forward poke to wrapped agent core
            =/  back-url=tape  +:(to-tape-url (welp :~(~...) +.ui-path))
            =.  site  (oust [0 2] site)        ::  now we know this isn't ~
            ?~  site  dump                     ::  fall back if the path ends here
            ?+  site  dump
            ::
            [%new-ticket ~]
              ?~  body.request.inbound-request.req
                :_  this
                %-  send  [405 ~ [%stock ~]]
              =/  jon=(unit json)  (de:json:html q.u.body.request.inbound-request.req)
              =/  =ticket  (to-ticket (need jon))
              :_  this
              %+  welp
              %-  send  [302 ~ [%redirect (crip back-url)]]
              :~  [%pass /self-poke %agent [our.bowl dap.bowl] %poke %grip !>([%create-ticket ticket])]
              ==
            ::
            [%settings-update ~]
              ?~  body.request.inbound-request.req
                :_  this
                %-  send  [405 ~ [%stock ~]]
              =/  =json  (need (de:json:html q.u.body.request.inbound-request.req))
              =.  auto-enabled  ?:  =((auto:dejs json) 'true')  &  |
              =/  url  (crip (weld back-url "/report"))
              :_  this
              %-  send  [302 ~ [%redirect url]]
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
      `this
    `this
      [%self-poke ~]
    ?.  ?=(%poke-ack -.sign)
      (on-agent wire sign)
    ?~  p.sign
      `this
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
    |^
    ?:  =(auto-enabled &) 
      :_  this
      :~  (send-to-pharos dev on-fail-ticket)
      ==
    =^  cards  inner  (on-fail:ag term tang)
    [cards this]
      ::
      ++  on-fail-ticket
        =/  body-vats  vats
        ^-  ticket 
        :*
            desk=dap.bowl
            title='on-fail'
            body=body-vats
            author=our.bowl
            anon=|
            app-version=*app-version
            =%report 
        ==
      ::vats need proper parcing to body msg 
      ++  vats 
        ^-  @t
        =/  desks              .^((set desk) %cd /(scot %p our.bowl)//(scot %da now.bowl))
        =/  deks=(list desk)   ~(tap in desks)
        =/  vat
            %+  turn  deks 
            |=(a=desk (flop (report-vat (report-prep our.bowl now.bowl) our.bowl now.bowl a |)))
        %-  crip  ~(ram re [%rose [" " "" ""] (zing vat)])
    --
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
      ;link
        =rel          "stylesheet"
        =crossorigin  "anonymous"
        =integrity    "sha384-Kh+o8x578oGal2nue9zyjl2GP9iGiZ535uZ3CxB3mZf3DcIjovs4J1joi2p+uK18"
        =href         "https://unpkg.com/@fontsource/lora@5.0.8/index.css";
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
        ;label.check(for "anon"): Remain anonymous?
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
        ;input(type "text", name "title", required "");
        ;label(for "body"): Additional details
        ;textarea(type "text", name "body", required "");
        ;button.submit(hx-post path, hx-target "body", hx-push-url "true"): submit
      ==
    ==
  ==
  ==
++  home-setting
|=  auto=?
  %-  page
  ;div.page
        ;form.settings
        ;button.exit: X
        ;h2: This app supports automatic crush report
        ;+  ?:  auto
         ;input(type "hidden", name "auto", value "false");
        ;input(type "hidden", name "auto", value "true");
        ;button.set(hx-post "./settings-update", hx-target "body", hx-push-url "true")
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
  }
  .page{
  margin:      auto;
  width:       50%;
  padding:     10px;
  color:       white;
  font-family: Lora, serif;
  }
  .main {
  position:         absolute;
  top:              50%;
  left:             50%;
  transform:        translate(-50%, -50%);
  border:           5px solid #197489;
  padding:          10px;
  background-color: #197489;
  }
  .settings{
  position:  absolute;
  top:       50%;
  left:      50%;
  transform: translate(-50%, -50%);
  border:    10px solid #197489;
  padding:   10px;
  z-index:   3;
  background-color: #197489;
  color:            white;
  text-align:       center;
  }
  h1{
  font-family: Lora, serif;
  text-align:  center;
  width:       100%;
  margin:      auto;
  font-size:   24px;
  font-weight: bold;
  }
  h2{
  font-size:   16px;
  }
  h3{
  color:       #78c6ce;
  font-size:   11px;
  width:       100%;
  margin:      auto;
  }
  label {
  width:     100%;
  margin:    3px;
  font-size: 16px;
  display:   inline-block;
  }
  input[type=text], textarea, select{
  width:       100%;
  padding:     12px;
  margin:      3px;
  border:      none;
  resize:      vertical;
  font-family: Lora, serif;
  }
  input[type=checkbox]{
  border:       none;
  height:       20px;
  width:        20px;
  accent-color: #78C6CE;
  }
  .check{
  width:   50%;
  margin:  3px;
  display: inline-block;
  }
  input[type=submit]{
  color:   white;
  padding: 12px 20px;
  border:  none;
  cursor:  pointer;
  float:   right;
  }
  textarea{
  resize: none;
  height: 150px;
  }
  button{
  display: block;
  margin:  auto;
  width:   auto;
  padding: 10px;
  border:  2px solid white;
  background:  white;
  color:       #197489;
  font-family: Lora, serif;
  }
  button:hover{
  background:       #C9E8EF;
  border: 2px solid #C9E8EF;
  }
  .submit{
  margin-top: 10px;
  }
  .set-btn{
  color:   white;
  background:        #197489;
  border:  2px solid #197489;
  margin:  auto;
  padding: 10px;
  float:   right;
  }
  .set-btn:hover{
  background:       #92B7C5;
  border: 2px solid #92B7C5;
  }
  .exit{
  width:         auto;
  margin:        auto;
  margin-left:   6px;
  margin-bottom: 6px;
  padding:       5px;
  float:         right;
  font-size:     10px;
  }
  '''
--
--