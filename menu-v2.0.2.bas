' SOSDG Menu Application
' Copyright (c) 2002-2004 Brian Bruns <bruns@2mbit.com>
' Copyright (c) 2002-2004 The Summit Open Source Development Group / Administrative Team - http://www.2mbit.com
' All Rights Reserved
'
' URL: http://www.2mbit.com/software.html
' Build: 2.0.2
' License: See Below
' Source: YES (e-mail bruns@2mbit.com for more info and latest version)
' Notes: 
'
'* Redistribution and use in source and binary forms, with or without
'* modification, are permitted provided that the following conditions
'* are met:
'* 1. Redistributions of source code must retain the above copyright
'*    notice, this list of conditions and the following disclaimer.
'* 2. Redistributions in binary form must reproduce the above copyright
'*    notices, the above paragraph (the one permitting redistribution),
'*    this list of conditions and the following disclaimer in the 
'*    documentation and/or other materials provided with the distribution.
'* 3. The names of the author(s) may not be used to endorse or promote 
'*    products derived from this software without specific prior written
'*    permission.
'* 
'* THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR 
'* IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
'* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
'* IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
'* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
'* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
'* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
'* AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
'* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY 
'* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
'* SUCH DAMAGE.

' VERSION HISTORY
' 1.0 - Development, initial test version
' 1.2 - Limited testing
' 1.3 - Bug fixing stage 1
' 1.4 - Bug fixing stage 2
' 1.5 - Bug fixing state 3
' 1.6 - Solid stable public version used in builds prior to Dec 16th 2002
' 1.7 - Testing INI config file
' 1.8 - Solid stable public version using INI file, changed server listing slightly, bug fixes,
'       disabled the Real Name field (still not implemented properly, why get users hopes up?),
'       and removed cruft from old builds that I left in for my own reference.
' 1.9 - See version.txt from the ircii epic4 installer, or check the website

$OPTIMIZE ON

$INCLUDE "RAPIDQ.INC"
' RQ INI File Support - Contact: StarBase12@OneBox.com 
$INCLUDE "QLibrary.inc"




$TYPECHECK OFF
$ESCAPECHARS OFF


APPLICATION.TITLE = "ircII EPIC4"

DECLARE SUB NickClick
DECLARE SUB FullNameClick
DECLARE SUB UserNameClick
DECLARE SUB ServerNameClick
DECLARE SUB SaveOptToDisk
DECLARE SUB AboutMenuShow
DECLARE SUB AboutMenuClose
DECLARE SUB QuitProgram
DECLARE SUB DelOptFile
DECLARE SUB RunWithCurrOpt
DECLARE SUB LoadOptionsFile
DECLARE SUB DispServerList
DECLARE SUB DispServerListClose
DECLARE SUB ChangeServerName2 (Sender AS QLISTBOX)
DECLARE SUB ReadOptFromDisk
DECLARE SUB ShowVerHistory
DECLARE SUB CloseVerHistory
DECLARE SUB ShowMenuOpt
DECLARE SUB CloseMenuOpt
DECLARE SUB CancelMenuOpt
DECLARE SUB ReadMenuOpt
DECLARE SUB LoadWin32Readme
DECLARE SUB LoadUNIXReadme
DECLARE SUB LoadLicense
DECLARE SUB LoadVersHistory
DECLARE SUB SaveTempOpt
DECLARE SUB OptWinResetDefaults
DECLARE SUB Editircrc
Declare Sub SaveEPICini
DECLARE Sub AddNoConFlag
DECLARE Sub AddNoircrcFlag
DECLARE Sub AddXDebugFlag
DECLARE Sub JoinChanOnCon
DECLARE Sub AddJoinChannel
DECLARE Sub PasswdConnectOpt
DECLARE Sub LoadServerList
DECLARE Sub ChkServerListExist

DIM CmdLineOpts AS STRING
DIM JoinChanStr AS STRING
DIM PasswordStr AS STRING
DIM ServerConnectStr AS STRING
DIM NoConStr AS STRING
DIM NoircrcStr AS STRING
DIM XDebugStr AS STRING
DIM EPIC4PathCurr AS STRING
DIM EPIC4BinCurr AS STRING
DIM EPIC4TermInfoCurr AS STRING
DIM EPIC4DocsCurr AS STRING
DIM EPIC4ExtraOptCurr AS STRING
DIM RXVTBinCurr AS STRING
DIM DOCREADMEWIN AS STRING
DIM DOCREADMEUNIX AS STRING
DIM DOCREADMELICENSE AS STRING
DIM DOCREADMEVERSION AS STRING


DIM ServerFile AS QFILESTREAM
DIM ServerListFile AS QFILESTREAM

'DIM ConfigFile AS QFILESTREAM
DIM HeaderFont AS QFONT
DIM HeaderFont2 AS QFONT
DIM HeaderFont3 AS QFONT
DIM HeaderFont4 AS QFONT
HeaderFont.Name = "Tahoma"
HeaderFont.AddStyles(fsBold)
HeaderFont.Size = 24
HeaderFont2.Name = "Tahoma"
HeaderFont2.Size = 12
HeaderFont3.Name = "Tahoma"
HeaderFont3.Size = 8
HeaderFont4.Name = "Tahoma"
HeaderFont4.Size = 10


Create EPICIniFile As QIniFile
   Name = "epic4.ini"
End Create

Create MenuIniFile AS QIniFile
   Name = "menu.ini"
End Create   

Dim EPICContent As QStringList
Dim I As Integer

Dim MenuContent AS QStringList    
   
CREATE MainForm AS QFORM
    Center
    Caption = "ircII EPIC Config App"
    Height = 350
    Width = 500
    BorderStyle = bsToolWindow
    
    CREATE MainMenu AS QMainMenu
      CREATE FileMenu AS QMenuItem
        Caption = "&File"
        CREATE LoadConfig AS QMenuItem
          Caption = "Load &Options"
          OnClick = ReadOptFromDisk
          ShortCut = "CTRL+O"
         END CREATE
        CREATE SaveConfig AS QMenuItem
          Caption = "&Save Options"
          OnClick = SaveOptToDisk
          ShortCut = "CTRL+S"
        END CREATE
        CREATE Break1 AS QMenuItem
          Caption = "-"
        END CREATE
        CREATE StartEpic AS QMenuItem
          Caption = "Run Epic"
          OnClick = RunWithCurrOpt
          ShortCut = "CTRL+R"
        END CREATE
        CREATE Break2 AS QMenuItem
          Caption = "-"
        END CREATE        
	CREATE MenuOptMenu AS QMenuItem
           Caption = "Configure Menu Settings"
           OnClick = ShowMenuOpt
         END CREATE
	CREATE Break3 AS QMenuItem
	   Caption = "-"
	END CREATE
        CREATE ExitApp AS QMenuItem
          Caption = "&Exit"
          OnClick = QuitProgram
          ShortCut = "ALT+F4"
        END CREATE
      END CREATE
      CREATE Tools AS QMenuItem
        Caption = "&Tools"
        CREATE DelOptions AS QMenuItem
           Caption = "Delete User Options"
           OnClick = DelOptFile
           ShortCut = "CTRL+D"
        END CREATE
	  CREATE EditircrcOpt AS QMenuItem
	    Caption = "Edit ircrc in Notepad"
           OnClick = Editircrc
           ShortCut = "CTRL+E"
         END CREATE
      END CREATE
      CREATE Help AS QMenuItem
        Caption = "&Help"
        CREATE EPICTxtInfo AS QMenuItem
           Caption = "EPIC Information..."
           OnClick = ShowVerHistory
        END CREATE
        CREATE AboutOpt AS QMenuItem
           Caption = "About..."
           OnClick = AboutMenuShow
        END CREATE
      END CREATE
    END CREATE

    CREATE NickLabel AS QLABEL
        Caption = "Nickname:"
        Top = 2
        Left = 10
    END CREATE
    CREATE NickEdit AS QEDIT
        Top = NickLabel.Top + 17
        Left = NickLabel.Left
        Width = 230
        Text = "EpicUser"
        MaxLength = 30
    END CREATE
    'CREATE NickHelp AS QBUTTON
    '    Top = NickEdit.Top - 2
    '    Left = 250
    '    Width = 20
    '    Caption = "?"
    '    OnClick = NickClick
    'END CREATE    
    CREATE FullNameLabel AS QLABEL
        Caption = "Full Name:"
        Top = NickEdit.Top + 27
        Left = NickLabel.Left
    END CREATE
    CREATE FullNameEdit AS QEDIT
        Top = FullNameLabel.Top + 17
        Left = NickLabel.Left
        Width = 230
        MaxLength = 100
        Text = "Some Random EPIC User"
    END CREATE
    'CREATE FullNameHelp AS QBUTTON
    '    Top = FullNameEdit.Top - 2
    '    Left = NickHelp.Left
    '    Width = 20
    '    Caption = "?"
    '    OnClick = FullNameClick
    'END CREATE    
    CREATE UserNameLabel AS QLABEL
        Caption = "User Name:"
        Top = FullNameEdit.Top + 27
        Left = NickLabel.Left
    END CREATE
    CREATE UserNameEdit AS QEDIT
        Top = UserNameLabel.Top + 17
        Left = NickLabel.Left
        Width = 230
        Text = "epicuser"
    END CREATE
    'CREATE UserNameHelp AS QBUTTON
    '    Top = UserNameEdit.Top - 2
    '    Left = NickHelp.Left
    '    Width = 20
    '    Caption = "?"
    '    OnClick = UserNameClick
    'END CREATE 
    CREATE ServerNameLabel AS QLABEL
        Caption = "Server:"
        Top = UserNameEdit.Top + 27
        Left = NickLabel.Left
    END CREATE
    CREATE ServerNameEdit AS QEDIT
        Top = ServerNameLabel.Top + 17
        Left = NickLabel.Left
        Width = 230
        Text = "irc.oftc.net"
    END CREATE
    'CREATE ServerNameHelp AS QBUTTON
    '    Top = ServerNameEdit.Top - 2
    '    Left = NickHelp.Left
    '   Width = 20
    '    Caption = "?"
    '    OnClick = ServerNameClick
    'END CREATE
'    CREATE ServerNameMult AS QBUTTON
'        Top = ServerNameHelp.Top
'        Left = ServerNameEdit.Left + 205
'        Width = 18
'        Caption = "..."
'        Enabled = True
'        OnClick = DispServerList
'    END CREATE
    CREATE PortNumLabel AS QLABEL
        Caption = "Port:"
        Top = ServerNameEdit.Top + 27
        Left = NickLabel.Left
    END CREATE
    CREATE PortNumEdit AS QEDIT
        Top = PortNumLabel.Top + 17
        Left = NickLabel.Left
        Width = 60
        Text = "6667"
        MaxLength = 6
    END CREATE
    CREATE ServerListLabel2 AS QLABEL
        Left = 280
        Top = NickLabel.Top
        Width = 300
        Caption = "Please Select A Server Below:"
    END CREATE
    CREATE ServerListBox1 AS QLISTBOX
        Left = ServerListLabel2.Left
        Top = ServerLabelList2.Top + 20
        Height = 120
        Width = 200
        MultiSelect = False
        'AddItems "OFTC (http://www.oftc.net)", "EFNet (http://www.efnet.net)", "DALNet (http://www.dalnet.net)"
        'AddItems "FreeNode (http://www.freenode.net)", "IRCNet (http://www.ircnet.org)
        OnClick = ChangeServerName2
    END CREATE
    'CREATE ServerListOK AS QBUTTON
    '    'Kind = bkOK
    '    Width = 80
    'Caption = "Set Server"
    '    Top = ServerNameHelp.Top
    '    Left = ServerListLabel2.Left + 57
    '    'ModalResult = mrOK
    '    OnClick = ChangeServerName2
    'END CREATE
    CREATE NoConCheckBox AS QCHECKBOX
	 Left = ServerListLabel2.Left
        Top = ServerListBox1.Top + 130
        Caption = "Don't connect automatically"
	 Width = 170
        OnClick = AddNoConFlag
    END CREATE
    CREATE NoircrcCheckBox AS QCHECKBOX
	 Left = NoConCheckBox.Left
        Top = NoConCheckBox.Top + 20
        Caption = "Don't load ircrc"
	 Width = 170
	 OnClick = AddNoircrcFlag
    END CREATE
    CREATE XDebugCheckBox AS QCHECKBOX
	 Left = NoConCheckBox.Left
        Top = NoircrcCheckBox.Top + 20
        Caption = "X_Debug Mode"
        OnClick = AddXDebugFlag
	 Width = 170
    END CREATE
    CREATE ChanConnectCheckBox AS QCHECKBOX
	 Left = PortNumLabel.Left + 70
        Top = PortNumLabel.Top
        Caption = "Join channel:"
        OnClick = AddJoinChannel
	 Width = 170
    END CREATE
    CREATE ChannelNameEdit AS QEDIT
        Top = ChanConnectCheckBox.Top + 17
        Left = ChanConnectCheckBox.Left
        Width = 160
        Text = "#irchelp"
	 Enabled = False
        MaxLength = 100
    END CREATE
    CREATE PassConnectCheckBox AS QCHECKBOX
	 Left = ChanConnectCheckBox.Left
        Top = ChannelNameEdit.Top + 30
        Caption = "Server password:"
        OnClick = PasswdConnectOpt
	 Width = 170
    END CREATE
    CREATE PassConnectEdit AS QEDIT
        Top = PassConnectCheckBox.Top + 17
        Left = PassConnectCheckBox.Left
        Width = 160
        Enabled = False
        MaxLength = 32
    END CREATE

    CREATE RunEpic AS QBUTTON
        Top = 260
        Left = 350
        Width = 100
        Caption = "Run EPIC"
        OnClick = RunWithCurrOpt 
    END CREATE
    'CREATE URLLabel1 AS QLABEL
    '    Left = 10
    '    Top = 270
    '    Width = 100
    '    Caption = "http://www.2mbit.com/software.html - v2.0.2"
    '    Font = HeaderFont3
    'END CREATE
   CREATE StatusBar AS QStatusBar
    AddPanels "",""
    Panel(0).Width = 380
    'Panel(0).Caption = str$(StatusBar.Panel(0).Width)
    Panel(1).Caption = "Version 2.0.2"
    SizeGrip = False
   END CREATE
END CREATE

SUB SaveOptToDisk
    SaveEPICini
    ShowMessage("The config has been saved.")
    LoadConfig.Enabled = True
    DelOptions.Enabled = True 
END SUB

SUB ReadOptFromDisk
    IF FILEEXISTS("epic4.ini") THEN
    NickEdit.Text = EPICIniFile.ReadEntry("Config","IRCNICK")
    UserNameEdit.Text = EPICIniFile.ReadEntry("Config","IRCUSER")
    PortNumEdit.Text = EPICIniFile.ReadEntry("Config","IRCPORT")
    ServerNameEdit.Text = EPICIniFile.ReadEntry("Config","IRCSERVER")
    FullNameEdit.Text = EPICIniFile.ReadEntry("Config","REALNAME")
    ChannelNameEdit.Text = EPICIniFile.ReadEntry("Config","CHANNEL")
    PassConnectEdit.Text = EPICIniFile.ReadEntry("Config","PASSWORD")
    'ShowMessage("The config file has been loaded")
    ELSE
    ShowMessage("The config file does not exist.  You should change the options above and click Save Options first.")
    END IF
END SUB
'--------- NickName Help Display
SUB NickClick
    ShowMessage("You can enter a nickname here.  Nicknames must consist of letters and numbers and _
               can be up to 30 characters on most IRC networks.  The only exception is EFNet, _
               which has a max of 9 characters.")
END SUB

'-------- Full Name Help Display
SUB FullNameClick
    ShowMessage("You can enter your full name here.  If you don't want to put your full name here, _
                that is ok too - anything is acceptable.  It is part of your WHOIS response.")
END SUB

'-------- User Name Help Display
SUB UserNameClick
    ShowMessage("You can enter your user name here.  If you don't have Identd installed, this is the _
                username passed to the server.  This can be only letters and numbers, and is a _
                max of 9 characters.  If you have an Ident (AKA Auth) server installed on your machine_
                , this has no affect.")
END SUB


'---------- Server Name Help
SUB ServerNameClick
    ShowMessage("You can enter a server name here, or click one of the servers to the right to use a preset.")
END SUB

'-------- About Dialog Display

CREATE AboutMenuDlg AS QFORM
    BorderStyle = bsDialog
    Center
    Caption = "About This Program..."
    Height = 200
    Width = 500
    CREATE AboutMenuLabel1 AS QLABEL
        Left = 47
        Top = 2
        Width = 300
        Caption = "ircII EPIC4 Config Menu"
        Font = HeaderFont
    END CREATE
    CREATE AboutMenuLabel2 AS QLABEL
        Left = 20
        Top = AboutMenuLabel1.Top + 40
        Width = 300
        Caption = "Copyright The Summit Open Source Development Group 2002"
        Font = HeaderFont2
    END CREATE
    CREATE AboutMenuLabel3 AS QLABEL
        Left = 5
        Top = 160
        Width = 100
        Caption = "http://www.2mbit.com"
        Font = HeaderFont3
    END CREATE
    CREATE AboutMenuLabel4 AS QLABEL
        Left = 25
        Top = AboutMenuLabel2.Top + 30
        WordWrap = True
        Width = 524
        Caption = "Developed by Brian Bruns (bruns@2mbit.com) for use with the ircII EPIC4 client on Windows 9x/ME/NT/2k/XP.  Developed under Rapid-Q from basicguru.com."
        Font = HeaderFont4
    END CREATE
    CREATE AboutMenuOK AS QBUTTON
        Kind = bkOK
        Width = 50
        Top = 145
        Left = 225
        ModalResult = mrOK
        OnClick = AboutMenuClose
    END CREATE
END CREATE    
    
SUB AboutMenuShow
    AboutMenuDlg.Show
END SUB

SUB AboutMenuClose
    AboutMenuDlg.Close
END SUB

'-- Quit Program
SUB QuitProgram
    'MainForm.Close
    Application.Terminate 
END SUB

SUB ChangeServerName2 (Sender AS QLISTBOX)
    ServerNameEdit.Text = REPLACESUBSTR$(FIELD$(Sender.item(Sender.ItemIndex),":",2),CHR$(09),"")
END SUB 

SUB DispServerList
    'ServerListDlg.Show
END SUB
SUB DispServerListClose
    'ServerListDlg.Close
END SUB

CREATE MenuOptWin AS QFORM
    BorderStyle = bsDialog
    Center
    Caption = "Menu Configuration"
    Height = 400
    Width = 420
    CREATE EPIC4PathLabel AS QLABEL
        Caption = "Path to the epic4 directory:"
        Top = 10
        Left = 5
    END CREATE
    CREATE EPIC4Path AS QEDIT
        Top = EPIC4PathLabel.Top + 20
        Left = 5
        Width = 400
        Text = "C:\epic4"
        MaxLength = 255
    END CREATE
    CREATE EPIC4BinaryLabel AS QLABEL
        Caption = "Path to the epic4 binary:"
        Top = EPIC4Path.Top + 30
        Left = 5
    END CREATE
    CREATE EPIC4Binary AS QEDIT
        Top = EPIC4BinaryLabel.Top + 20
        Left = 5
        Width = 400
        Text = "C:\epic4\bin\epic.exe"
        MaxLength = 255
    END CREATE  
    CREATE EPIC4TermInfoLabel AS QLABEL
        Caption = "Path to the Terminfo files:"
        Top = EPIC4Binary.Top + 30
        Left = 5
    END CREATE
    CREATE EPIC4TermInfo AS QEDIT
        Top = EPIC4TermInfoLabel.Top + 20
        Left = 5
        Width = 400
        Text = "C:\epic4\terminfo"
        MaxLength = 255
    END CREATE
    CREATE EPIC4DocsLabel AS QLABEL
        Caption = "Path to the EPIC4 documentation:"
        Top = EPIC4TermInfo.Top + 30
        Left = 5
    END CREATE
    CREATE EPIC4Docs AS QEDIT
        Top = EPIC4DocsLabel.Top + 20
        Left = 5
        Width = 400
        Text = "C:\epic4\docs"
        MaxLength = 255
    END CREATE
    CREATE EPIC4ExtraOptLabel AS QLABEL
        Caption = "Extra Options For EPIC:"
        Top = EPIC4Docs.Top + 30
        Left = 5
    END CREATE
    CREATE EPIC4ExtraOpt AS QEDIT
        Top = EPIC4ExtraOptLabel.Top + 20
        Left = 5
        Width = 400
        Text = ""
        MaxLength = 255
    END CREATE
    CREATE RXVTBinLabel AS QLABEL
        Caption = "Path to the RXVT binary:"
        Top = EPIC4ExtraOpt.Top + 30
        Left = 5
    END CREATE
    CREATE RXVTBinary AS QEDIT
        Top = RXVTBinLabel.Top + 20
        Left = 5
        Width = 400
        Text = "C:\epic4\bin\rxvt.exe"
        MaxLength = 255
    END CREATE 
   CREATE OptWinOK AS QBUTTON
        Kind = bkOK
        Width = 80
        Top = 340
        Left = 5
        'ModalResult = mrOk
        OnClick = CloseMenuOpt
    END CREATE
   CREATE OptWinCancel AS QBUTTON
        Kind = bkCancel
        Width = 80
        Top = 340
        Left = OptWinOk.Left + 90
        'ModalResult = mrCanel
        OnClick = CancelMenuOpt
    END CREATE
   CREATE OptWinReset AS QBUTTON
        Width = 120
        Caption = "Reset To Defaults"
        Top = 340
        Left = OptWinCancel.Left + 90
        OnClick = OptWinResetDefaults
    END CREATE
END CREATE

Sub ShowMenuOpt
    SaveTempOpt
    MenuOptWin.Show
END SUB

Sub CloseMenuOpt
   MenuContent.Clear
   MenuContent.AddItems "EPICPath="+EPIC4Path.Text
   MenuContent.AddItems "EPICBin="+EPIC4Binary.Text
   MenuContent.AddItems "Terminfo="+EPIC4TermInfo.Text
   MenuContent.AddItems "EPICDocs="+EPIC4Docs.Text
   MenuContent.AddItems "EPICExtra="+EPIC4ExtraOpt.Text
   MenuContent.AddItems "RXVTBin="+RXVTBinary.Text
   KILL "menu.ini"
   MenuIniFile.WriteSection "Config",MenuContent
   MenuOptWin.Close
   StatusBar.Panel(0).Caption = "Menu configuration saved."
END SUB

Sub ReadMenuOpt
    IF FILEEXISTS("menu.ini") THEN
    EPIC4Path.Text = MenuIniFile.ReadEntry("Config","EPICPath")
    EPIC4Binary.Text = MenuIniFile.ReadEntry("Config","EPICBin")
    EPIC4TermInfo.Text = MenuIniFile.ReadEntry("Config","Terminfo")
    EPIC4Docs.Text = MenuIniFile.ReadEntry("Config","EPICDocs")
    EPIC4ExtraOpt.Text = MenuIniFile.ReadEntry("Config","EPICExtra")
    RXVTBinary.Text = MenuIniFile.ReadEntry("Config","RXVTBin")
    END IF
End Sub

Sub SaveTempOpt
    EPIC4PathCurr = EPIC4Path.Text
    EPIC4BinCurr = EPIC4Binary.Text
    EPIC4TermInfoCurr = EPIC4TermInfo.Text
    EPIC4DocsCurr = EPIC4Docs.Text
    EPIC4ExtraOptCurr = EPIC4ExtraOpt.Text
    RXVTBinCurr = RXVTBinary.Text
END SUB

Sub OptWinResetDefaults
    EPIC4Path.Text = "C:\epic4"
    EPIC4Binary.Text = "C:\epic4\bin\epic.exe"
    EPIC4TermInfo.Text = "C:\epic4\terminfo"
    EPIC4Docs.Text = "C:\epic4\docs"
    EPIC4ExtraOpt.Text = ""
    RXVTBinary.Text = "C:\epic4\bin\rxvt.exe"
END SUB

Sub CancelMenuOpt
    EPIC4Path.Text = EPIC4PathCurr
    EPIC4Binary.Text = EPIC4BinCurr
    EPIC4TermInfo.Text = EPIC4TermInfoCurr 
    EPIC4Docs.Text = EPIC4DocsCurr
    EPIC4ExtraOpt.Text = EPIC4ExtraOptCurr
    RXVTBinary.Text = RXVTBinCurr
    MenuOptWin.Close
    StatusBar.Panel(0).Caption = "Menu configuration changes canceled."
END SUB

SUB AddNoConFlag
    IF NoConCheckBox.Checked THEN
	NoConStr = " -s "
       ChanConnectCheckBox.Enabled = False
       ChannelNameEdit.Enabled = False
       'PassConnectCheckBox.Enabled = False
       'PassConnectEdit.Enabled = False
    ELSE
       NoConStr = ""
       ChanConnectCheckBox.Enabled = True
       AddJoinChannel
       'ChannelNameEdit.Enabled = True
       'PassConnectCheckBox.Enabled = True
       'PassConnectEdit.Enabled = True
    END IF
END SUB

SUB AddNoircrcFlag
    IF NoircrcCheckBox.Checked THEN
	NoircrcStr = " -q "
    ELSE
       NoircrcStr = ""
    END IF
END SUB

SUB AddXDebugFlag
    IF XDebugCheckBox.Checked THEN
	XDebugStr = " -x "
    ELSE
       XDebugStr = ""
    END IF
END SUB

SUB AddJoinChannel
    IF ChanConnectCheckBox.Checked THEN
	ChannelNameEdit.Enabled = True
       JoinChanStr = " -c "+ChannelNameEdit.Text+" "
    ELSE
	ChannelNameEdit.Enabled = False
       JoinChanStr = ""
    END IF
END SUB

SUB PasswdConnectOpt
    IF PassConnectCheckBox.Checked THEN
	PassConnectEdit.Enabled = True
       PasswordStr = PassConnectEdit.Text
    ELSE
	PassConnectEdit.Enabled = False
       PasswordStr = ""
    END IF
END SUB


SUB RunWithCurrOpt
    DIM EPIC4Bin AS STRING
    DIM RXVTBin AS STRING
    EPIC4Bin = EPIC4Binary.Text
    RXVTBin = RXVTBinary.Text
    AddJoinChannel
    IF PassConnectCheckBox.Checked THEN
    ServerConnectStr = ServerNameEdit.Text+":"+PortNumEdit.Text+":"+PasswordStr
    ELSE
    ServerConnectStr = ServerNameEdit.Text+":"+PortNumEdit.Text
    END IF
    IF FILEEXISTS(EPIC4Bin) THEN
    ENVIRON "TERMINFO="+EPIC4TermInfo.Text
    ENVIRON "HOME="+EPIC4Path.Text
    ENVIRON "IRCNAME="+FullNameEdit.Text
    'ENVIRON "HELP_PATH="+EPIC4Path.Text+"\share\epic\help"
    'CmdLineOpts = NickEdit.Text+" -z "+UserNameEdit.Text+" -p "+PortNumEdit.Text+" "+NoConStr+NoircrcStr+XDebugStr+JoinChanStr+" "+EPIC4ExtraOpt.Text+" "+ServerNameEdit.Text
    CmdLineOpts = NickEdit.Text+" -z "+UserNameEdit.Text+" "+NoConStr+NoircrcStr+XDebugStr+JoinChanStr+" "+EPIC4ExtraOpt.Text+" "+ServerConnectStr
    RUN RXVTBin+" +ut -sr -sl 5000 -tn xterm -e "+EPIC4Bin+" -n "+CmdLineOpts
    'ShowMessage(CmdLineOpts)
    StatusBar.Panel(0).Caption = CmdLineOpts
    QuitProgram
    ELSE
    ShowMessage("Error:  The EPIC4 application was not found.  Please check the paths under Tools -> Configure Menu Settings.")
    StatusBar.Panel(0).Caption = "The EPIC4 application was not found!"
    END IF
END SUB

SUB DelOptFile
    KILL "epic4.ini"
    'ShowMessage("Config file deleted.")
    StatusBar.Panel(0).Caption = "EPIC4 config file deleted."
    LoadConfig.Enabled = False
    DelOptions.Enabled = False
END SUB

SUB ChkCfgExist
    IF FILEEXISTS("epic4.ini") THEN
        LoadConfig.Enabled = True
        DelOptions.Enabled = True
        StatusBar.Panel(0).Caption = "EPIC4 config file found and loaded."
       ReadOptFromDisk    
    ELSE
        StatusBar.Panel(0).Caption = "EPIC4 config file not found.  Loaded default settings."
        LoadConfig.Enabled = False
        DelOptions.Enabled = False
    END IF
END SUB

Sub SaveEPICini
   EPICContent.Clear
   EPICContent.AddItems "IRCNICK="+NickEdit.Text
   EPICContent.AddItems "IRCUSER="+UserNameEdit.Text
   EPICContent.AddItems "IRCPORT="+PortNumEdit.Text
   EPICContent.AddItems "IRCSERVER="+ServerNameEdit.Text
   EPICContent.AddItems "REALNAME="+FullNameEdit.Text
   EPICContent.AddItems "CHANNEL="+ChannelNameEdit.Text
   EPICContent.AddItems "PASSWORD="+PassConnectEdit.Text
   KILL "epic4.ini"
   EPICIniFile.WriteSection "Config",EPICContent
End Sub

CREATE EPICTxtWin AS QFORM
    BorderStyle = bsDialog
    Center
    Caption = "EPIC Information"
    Height = 400
    Width = 500
    CREATE REVersion AS QRICHEDIT
        ScrollBars = ssBoth
        ReadOnly = True
        Left = 5
        Top = 2
        Height = 330
        Width = 483
    END CREATE
    CREATE ReadMe AS QBUTTON
       Top = 340
       Left = 5
       Width = 80
       Caption = "EPIC (Win32)"
       OnClick = LoadWin32Readme
    END CREATE
    CREATE ReadMe2 AS QBUTTON
       Top = ReadMe.Top
       Left = ReadMe.Left + 90
       Width = 80
       Caption = "EPIC (UNIX)"
       OnClick = LoadUNIXReadme
    END CREATE
    CREATE License AS QBUTTON
       Top = ReadMe.Top
       Left = ReadMe2.Left + 90
       Width = 80
       Caption = "License"
       OnClick = LoadLicense
    END CREATE
    CREATE VersionHistory AS QBUTTON
       Top = ReadMe.Top
       Left = License.Left + 90
       Width = 80
       Caption = "Versions"
       OnClick = LoadVersHistory
    END CREATE
    CREATE TXTWinOK AS QBUTTON
        Kind = bkOK
        Width = 50
        Top = ReadMe.Top
        Left = VersionHistory.Left + 150
        ModalResult = mrOK
        OnClick = CloseVerHistory
    END CREATE       
END CREATE

Sub LoadWin32Readme
    IF FILEEXISTS(EPIC4Docs.Text+"\readme.txt") THEN
    REVersion.LoadFromFile EPIC4Docs.Text+"\readme.txt"
    ELSE
    ShowMessage("Warning: readme.txt was not found.  Unable to display!")
    END IF
End Sub

Sub LoadUNIXReadme
    IF FILEEXISTS(EPIC4Docs.Text+"\readme-unix.txt") THEN
    REVersion.LoadFromFile EPIC4Docs.Text+"\readme-unix.txt"
    ELSE
    ShowMessage("Warning: readme-unix.txt was not found.  Unable to display!")
    END IF
End Sub    

Sub LoadLicense
    IF FILEEXISTS(EPIC4Docs.Text+"\copyright.txt") THEN
    REVersion.LoadFromFile EPIC4Docs.Text+"\copyright.txt"
    ELSE
    ShowMessage("Warning: copyright.txt was not found.  Unable to display!")
    END IF
End Sub    

Sub LoadVersHistory
    IF FILEEXISTS(EPIC4Docs.Text+"\version.txt") THEN
    REVersion.LoadFromFile EPIC4Docs.Text+"\version.txt"
    ELSE
    ShowMessage("Warning: version.txt was not found.  Unable to display!")
    END IF  
End Sub    

Sub ShowVerHistory
    EPICTxtWin.Show
END SUB

Sub CloseVerHistory
    EPICTxtWin.Close
END SUB

Sub Editircrc
    IF FILEEXISTS(EPIC4Path.Text+"\ircrc") THEN
       RUN "notepad.exe "+EPIC4Path.Text+"\ircrc"
    ELSE
       DIM IRCRCFile AS QFileStream
       IRCRCFile.Open(EPIC4Path.Text+"\ircrc", fmCreate)
	IRCRCFile.WriteLine("# This is a blank ircrc file.")
	IRCRCFile.WriteLine("# You can load up your EPIC4 scripts here or put")
	IRCRCFile.WriteLine("# commands you want run when the client connects.")
       IRCRCFile.Close
       RUN "notepad.exe "+EPIC4Path.Text+"\ircrc"
    END IF
End Sub

Sub LoadServerList
	ServerFile.Open("ircservers.txt", fmOpenRead)
       ServerListBox1.Clear
	Y# = 0
       Do
            ServerListBox1.AddItems ServerFile.ReadLine
	Y++
        Loop until ServerFile.eof
       'ShowMessage(FIELD$(ServerListBox1.Item(0), CHR$(09), 2))
END SUB

Sub ChkServerListExist
	IF FILEEXISTS("ircservers.txt") THEN
	' Nothing to do
	ELSE
	ServerListFile.Open("ircservers.txt", fmCreate)
	ServerListFile.WriteLine("EFNet:"+CHR$(09)+CHR$(09)+"us.rr.efnet.net")
	ServerListFile.WriteLine("DALNet:"+CHR$(09)+CHR$(09)+"irc.dal.net")
	ServerListFile.WriteLine("OFTC:"+CHR$(09)+CHR$(09)+"irc.oftc.net")
	ServerListFile.WriteLine("XIPH:"+CHR$(09)+CHR$(09)+"irc.xiph.org")
	ServerListFile.WriteLine("FreeNode:"+CHR$(09)+"irc.openprojects.net")
	ServerListFile.WriteLine("IRCNet:"+CHR$(09)+CHR$(09)+"irc.ircnet.org")
	ServerListFile.WriteLine("UnderNet:"+CHR$(09)+"us.undernet.org")
	ServerListFile.Close
	END IF
END Sub

'FullNameEdit.Enabled = False

' Its not working correctly with the addition of the password and channel boxes
'NoConCheckBox.Enabled = False
ChkServerListExist
LoadServerList
ReadMenuOpt
ChkCfgExist

MainForm.ShowModal