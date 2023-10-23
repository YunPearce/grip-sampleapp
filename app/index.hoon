::
|^  ^-  octs
::
%-  as-octs:mimes:html
::
%-  crip
%-  en-xml:html
^-  manx
;html
  ;head
    ;title: GripApp
    ;meta(charset "utf-8");
    ;style: {style}
    ==
  ;body
    ;div.main
    ;div.header
      ;h1: Your amazing app
    ==
    ;h3: about app text
    ;div.btn
    ;a/"./app/report": HELP
    ==
    ==
  ==
==
++  style
  ^~
  %-  trip
  '''
  :root {
  --measure: 70ch;
  }
  body{
  background:  black;
  }
  .main{
  possition:        absolute;
  border:           2px solid black;
  margin:           auto;
  padding:          20px;
  padding-top:      5px;
  background:       white;
  }
  .header{  
  text-align: center;
  color:      white;
  background: black;
  width:      50%;
  margin:     auto;
  padding:    10px;
  border-radius:10px;
  }
  .btn{
  display: flex; 
  justify-content: flex-end; 
  }
  a{
  margin:20px;
  background: black;
  color: yellow;
  padding: 10px;
  border-radius:10px;
  }
  '''
--

