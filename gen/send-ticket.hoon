/+  *grip
::  :app +grip!send-ticket
:-  %say 
|=  [* ~ ~]
=/  =ticket
:*    board=%name
      title='title'
      body='body error text'
      author=*@p
      anon=&
      app-version=*app-version
      ticket-type=%general
      ==
:-  %grip
:-  %create-ticket
ticket