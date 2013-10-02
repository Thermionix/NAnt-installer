#define AppName "NAnt"
#define SrcDir "src"
#define SrcApp SrcDir + "\bin\NAnt.exe"
#define FileVerStr GetFileVersion(SrcApp)
#define StripBuild(str VerStr) Copy(VerStr, 1, RPos(".", VerStr)-1)
#define AppVerStr StripBuild(FileVerStr)

[Setup]
AppPublisher=nant.sourceforge.net
AppName={#AppName}
AppVersion={#AppVerStr}
AppVerName={#AppName} {#AppVerStr}
UninstallDisplayName={#AppName}
VersionInfoVersion={#FileVerStr}
VersionInfoTextVersion={#AppVerStr}
OutputBaseFilename={#AppName}-{#AppVerStr}-setup
DefaultDirName={pf}\{#AppName}
LicenseFile={#SrcDir}\COPYING.txt

ChangesAssociations=true
PrivilegesRequired=poweruser
ChangesEnvironment=true
AllowUNCPath=false
ShowLanguageDialog=yes

[Files]
Source: {#SrcDir}\README.txt; DestDir: {app}; Flags: isreadme
Source: {#SrcDir}\COPYING.txt; DestDir: {app}
Source: {#SrcDir}\bin\*.*; DestDir: {app}\bin; Flags: recursesubdirs
Source: {#SrcDir}\doc\*.*; DestDir: {app}\doc; Flags: recursesubdirs
Source: {#SrcDir}\examples\*.*; DestDir: {app}\examples; Flags: recursesubdirs
Source: {#SrcDir}\schema\*.*; DestDir: {app}\schema; Flags: recursesubdirs
Source: nant.ico; DestDir: {app}

[Registry]
Root: HKCR; Subkey: .build; ValueType: string; ValueData: NAnt; Flags: uninsdeletevalue
Root: HKCR; Subkey: NAnt; ValueType: string; ValueData: NAnt build file; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: NAnt\DefaultIcon; ValueType: string; ValueData: {app}\nant.ico
Root: HKCR; Subkey: NAnt\shell\open\command; ValueType: string; ValueData: """{app}\bin\nant.exe"" ""%1"""
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: Path; ValueData: "{reg:HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment,Path|};{app}\bin"

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep=ssPostInstall then
  begin
    SaveStringToFile(ExpandConstant('{win}\nant.bat'), ExpandConstant('@"{app}\bin\NAnt.exe" %*'), False);
  end;
end;

[UninstallDelete]
Type: files; Name: "{win}\nant.bat"
