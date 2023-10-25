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
  ;body.bdy
    ;div.body-main
    ;div.header
      ;h1: Your amazing app
    ==
    ;h3: Ultimately, what makes an app truly awesome its ability to enhance and simplify users lives and provide solutions to their problems. Click the button bellow to help us help you!
    ;div.butn
    ;a/"./app/report": HELP?
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
  .bdy{
  background:  black;
  }
  .body-main{
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
  .butn{
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

