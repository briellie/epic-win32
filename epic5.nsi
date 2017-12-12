;Title Of Your Application
Name "ircII EPIC5 For Windows 0.3.2 Build 4"
CompletedText "You have successfully installed ircII EPIC5 for Windows.  Enjoy!"

CRCCheck On
SetCompress Auto
SetCompressor lzma
SetOverwrite IfNewer
SetDatablockOptimize on

;Output File Name
OutFile "installers\epic5-installer-0.3.2-build4.exe"

;License Page Introduction
LicenseText "Please read the following license information before using this program:"

;License Data
LicenseData "C:\epic5\docs\copyright.txt"

;The Default Installation Directory
InstallDir "C:\epic5"

;The text to prompt the user to enter a directory
DirText "Please select the folder below you wish to install to.  Do not change it unless you absolutely need to."

Section "Install"
  ;Install Files
  SetOutPath $INSTDIR
  SetCompress Auto
  SetOverwrite IfNewer
  File /r "C:\epic5\bin"
  File /r "C:\epic5\libexec"
  File /r "C:\epic5\share"
  File /r "C:\epic5\docs"
  File /r "C:\epic5\terminfo"
  File /r "C:\epic5\identd"
  File "C:\epic5\ircservers.txt"
  File "C:\epic5\menu.exe"


  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ircII epic5 For Windows" "DisplayName" "ircII epic5 For Windows (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ircII epic5 For Windows" "UninstallString" "$INSTDIR\Uninst.exe"
WriteUninstaller "Uninst.exe"
SectionEnd

Section "Shortcuts"
  ;Add Shortcuts
  CreateDirectory "$SMPROGRAMS\ircII epic5"
  CreateShortCut "$SMPROGRAMS\ircII epic5\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII epic5\ircII epic5.lnk" "$INSTDIR\menu.exe" "" "$INSTDIR\menu.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII epic5\ircII epic5 License.lnk" "$INSTDIR\docs\copyright.txt" "" "$INSTDIR\docs\copyright.txt" 0
  CreateShortCut "$SMPROGRAMS\ircII epic5\Identd Daemon.lnk" "$INSTDIR\identd\identd_win32.exe" "" $INSTDIR\identd\identd_win32.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII epic5\Identd Source Code.lnk" "$INSTDIR\identd\src" "" "$INSTDIR\identd\src" 0
  CreateShortCut "$SMPROGRAMS\ircII epic5\Identd License.lnk" "$INSTDIR\identd\license.rtf" "" "$INSTDIR\identd\license.rtf" 0
SectionEnd

UninstallText "This will uninstall ircII epic5 from your system"

Section Uninstall
  ;Delete Files
  RMDir /r "$INSTDIR"

  ; Additional Files To Remove During Uninstall
  RMDir /r "$SMPROGRAMS\ircII epic5"

  ;Delete Uninstaller And Unistall Registry Entries
  Delete "$INSTDIR\Uninst.exe"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\ircII epic5 For Windows"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ircII epic5 For Windows"
  RMDir "$INSTDIR"
SectionEnd