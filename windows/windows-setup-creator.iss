; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Jenkins Board"
#define MyAppVersion "0.1.0"
#define MyAppPublisher "Stone"
#define MyAppURL "https://github.com/stonega/jenkins-board"
#define MyAppExeName "jenkins_board.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{c832b5f7-0835-43f1-a636-390cc3f9e279}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\build\installer
OutputBaseFilename=Jenkins-Board-windows-x86_64-setup
SetupIconFile=..\windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\runner\Release\jenkins_board.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\runner\Release\local_notifier_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
