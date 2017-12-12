;Title Of Your Application
Name "ircII EPIC4 For Windows 2.6 Build 238"
CompletedText "You have successfully installed ircII EPIC4 for Windows.  Enjoy!"

CRCCheck On
SetCompress Auto
SetCompressor lzma
SetOverwrite IfNewer
SetDatablockOptimize on

;Output File Name
OutFile "installers\epic4-installer-2.6-build238.exe"

;License Page Introduction
LicenseText "Please read the following license information before using this program:"

;License Data
LicenseData "C:\epic4\docs\copyright.txt"

;The Default Installation Directory
InstallDir "C:\epic4"

;The text to prompt the user to enter a directory
DirText "Please select the folder below you wish to install to.  Do not change it unless you absolutely need to."

Section "Install"
  ;Install Files
  SetOutPath $INSTDIR
  SetCompress Auto
  SetOverwrite IfNewer
  File /r "C:\epic4\bin"
  File /r "C:\epic4\libexec"
  File /r "C:\epic4\share"
  File /r "C:\epic4\docs"
  File /r "C:\epic4\terminfo"
  File /r "C:\epic4\identd"
  File "C:\epic4\ircservers.txt"
  File "C:\epic4\menu.exe"


  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ircII EPIC4 For Windows" "DisplayName" "ircII EPIC4 For Windows (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ircII EPIC4 For Windows" "UninstallString" "$INSTDIR\Uninst.exe"
WriteUninstaller "Uninst.exe"
SectionEnd

Section "Shortcuts"
  ;Add Shortcuts
  CreateDirectory "$SMPROGRAMS\ircII EPIC4"
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\ircII EPIC4.lnk" "$INSTDIR\menu.exe" "" "$INSTDIR\menu.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\ircII EPIC4 License.lnk" "$INSTDIR\docs\copyright.txt" "" "$INSTDIR\docs\copyright.txt" 0
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\Identd Daemon.lnk" "$INSTDIR\identd\identd_win32.exe" "" $INSTDIR\identd\identd_win32.exe" 0
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\Identd Source Code.lnk" "$INSTDIR\identd\src" "" "$INSTDIR\identd\src" 0
  CreateShortCut "$SMPROGRAMS\ircII EPIC4\Identd License.lnk" "$INSTDIR\identd\license.rtf" "" "$INSTDIR\identd\license.rtf" 0
SectionEnd

UninstallText "This will uninstall ircII EPIC4 from your system"

Section Uninstall
  ;Delete Files
  RMDir /r "$INSTDIR"

  ; Additional Files To Remove During Uninstall
  RMDir /r "$SMPROGRAMS\ircII EPIC4"

  ;Delete Uninstaller And Unistall Registry Entries
  Delete "$INSTDIR\Uninst.exe"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\ircII EPIC4 For Windows"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ircII EPIC4 For Windows"
  RMDir "$INSTDIR"
SectionEnd