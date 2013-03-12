unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.Samples.Spin, Vcl.Tabs, Vcl.CheckLst, Vcl.ActnMan,
  Vcl.ActnColorMaps, Vcl.ExtDlgs, Vcl.ImgList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, dglOpenGL, Unit2, openil;

type

  TForm1 = class(TForm)
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdleHandler(Sender: TObject; var Done : Boolean);
    procedure InitMode(M_type: integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);

  private
    { Private declarations }
    procedure SetupGL;
  //  procedure Draw;
  public
    { Public declarations }
    dc : HDC;
    hrc : HGLRC;
    rotation: real;
    bx,by:integer;
    createcontext: boolean;

  end;

const
  NearClipping = 0.1;    //������� ��������� ���������
  FarClipping  = 200;    //������� ��������� ���������
  g = 9.8;


type
  Rectangle=record
    x: real;
    y: real;
    width: integer;
    height: integer;
  end;

  Objects = record
  box : Rectangle;
  lives : integer;
  typei:integer;
  Ttype: integer;
  Collision: Boolean;
  draw: integer;
  end;



var
  Form1: TForm1;
  mode: integer=1;
  camera_x: extended=0.0;
  camera_y: extended;
  mouse_up: boolean=false;
  m_x, m_y,m_x1, m_y1: integer;
  mouse_down, mouse_move: boolean;
  box: rectangle;
  gameobj: array[1..5000] of objects;
  useSnap: boolean;
  snapstepy, snapstepx: integer;
  gobj_count: longint;
  filename: string='0';
  filelable: string='0';
  mouse_x, mouse_y : real;
    mouse_mx, mouse_my: real;

  ff: text;
  k: integer; selected:boolean;
  k_s:integer;

implementation

{$R *.dfm}

procedure TForm1.SetupGL;
begin

  glEnable(GL_DEPTH_TEST); //�������� ����� ���� �������
  glEnable(GL_CULL_FACE); //�������� ����� ����������� ������ �������� ������������
end;

procedure TForm1.IdleHandler(Sender : TObject; var Done : Boolean);
begin
  Sleep(1);
  Done := False;
  FormPaint(Sender);
end;

procedure TForm1.InitMode(M_type: integer);      //�� ����� �������� � ���� �������, ���� � ��������������� ���� � ������������� ��������
begin
  case M_type of
     1: begin
          glViewport(0,0,ClientWidth,ClientHeight);
          //��������� ������� � ������������ ������ //
          glmatrixmode(GL_PROJECTION);        //�������� � ������ ������������ �������
          glloadidentity();                   //�������� ������� ������� �� ���������
          glortho(0, ClientWidth, ClientHeight, 0, 0, 1); //�������� ������������� ������������ �������
          glmatrixmode(GL_MODELVIEW);         //�������� � ������ ��������-������� �������
          glloadidentity();                   //�������� ������� ������� �� ���������
          gltranslatef(0.375, 0.375, 0);      //������� ������� ������� (���, ����� ������� �������� � �������)
          glDisable(GL_DEPTH_TEST);           //��������� �������� ������ �������
          glEnable(GL_CULL_FACE);             //�������� ��������� ������ ������
          glCullFace(GL_BACK);                //���������� ����� ������ ����� (��������� ����� � ������)
          glFrontFace(GL_CCW);                //�������� ��������� ������ ���������� � ������� "������ ������� �������"
          glShadeModel(GL_SMOOTH);            //������������� ������ ��������
        end;
     2: begin
          glViewport(0,0,ClientWidth,ClientHeight);
          glMatrixMode(GL_PROJECTION);
          glLoadIdentity;
          gluPerspective(45.0,ClientWidth/ClientHeight,NearClipping,FarClipping);
          glMatrixMode(GL_MODELVIEW);
          glLoadIdentity;
        end;
  end;

end;


procedure Scene_Draw();
var i:integer;
begin
  for I := 1 to 5000 do
    if gameobj[i].draw=1 then

    draw_quad(gameobj[i].box.x,
              gameobj[i].box.y,
              gameobj[i].box.width,
              gameobj[i].box.height);

end;

procedure TForm1.FormResize(Sender: TObject);
var
  tmpBool : Boolean;
begin
  InitMode(mode);
  idleHandler(Sender,tmpBool);
  FormPaint(Sender);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
    tclick:=not tclick;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
    Randomize;
   dc := GetDC(Form1.Handle); //�������� �������� ���������� �� ����� Form1
  //� InitOpenGL ���������������� OpenGL, ���� ��� �� ������� �� ���������� �����������
  if  (not InitOpenGL)  then
    Application.Terminate;

  //��� ������ ������ �������� ����������
  hrc := CreateRenderingContext(dc,[opDoubleBuffered],32,24,0,0,0,0);

  ActivateRenderingContext(dc,hrc); //���������� �������� ����������
  SetupGL;                          //��������� ������� OpenGL
  Application.OnIdle := IdleHandler;
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  glDisable(GL_COLOR_MATERIAL);
  ilInit();

  ReleaseFont;

  TextInit();

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DeactivateRenderingContext;
  DestroyRenderingContext(hrc);
  ReleaseDC(Handle,dc);

end;

procedure TForm1.FormHide(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    mouse_x:=x;
    mouse_y:=y;
end;

procedure TForm1.FormPaint(Sender: TObject);
var p:boolean;
begin
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    InitMode(mode);

    glBindTexture(GL_TEXTURE_2D, Tex.gobject[2]);
    draw_quad(0,0,ClientWidth,ClientHeight);
   // TPrintText(floattostr(mouse_x),ClientWidth/2,ClientHeight/2,4,true,37);
   // TPrintText(floattostr(mouse_y),ClientWidth/2,ClientHeight/2+50,4,tclick,37);
	CreateButton(ClientWidth/2,ClientHeight/2,'ololo ya voditel ufo',4,
				 true,37,'purple',trunc(mouse_x), Trunc(mouse_y));

    SwapBuffers(dc);
end;

end.

