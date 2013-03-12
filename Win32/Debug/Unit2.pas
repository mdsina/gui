unit Unit2;

interface

uses dglOpengl, Windows, openil, openilu, Messages, SysUtils;

Type
  SymbolTType = record
  x: real;
  y: real;
  width:real;
  height: real;
  ptSymbol:gluint;
  end;

  SymbolTexture = record
  width:real;
  height: real;
  mSymbol: glUint;
  end;
  Rectangle = record
  x:         real;
  y:         real;
  width:   real;
  height:  real;
  end;

  Textures = record
  gobject:array[1..500] of glUint;
  end;

Var
  TSymbol : array[1..256] of SymbolTexture;
  Symbol_height: real;
  Symbol_width: real;
  pSymbol: array[1..256] of SymbolTType;
  Tex: Textures;
  mouse_x, mouse_y: integer;
  tclick: boolean;

function LoadBmp(path : pAnsiChar) : uint32;
procedure ReleaseFont;
procedure draw_quad_c(_x, _y, _width, _height :real);
procedure draw_quad_c2(r: Rectangle);
procedure draw_quad2(r: Rectangle);
procedure draw_quad(_x, _y, _width, _height :real);
function TPrintText(text2:string; t1, t2,TLength: real; draw:boolean; theight:real): integer;
function FindSymbol(strings: string; lu:string): integer;
procedure PrintText(a: array of SymbolTType; k:integer);
procedure TextInit;
function CreateButton(x,y:integer; text2:string; TLength: real;
                      draw:boolean; theight:real; texture:string; mx, my: integer):boolean;

implementation

function LoadBmp(path : PAnsiChar) : uint32;
var
  gBitmap : hBitmap;
  sBitmap : Bitmap;
  TextureID : uint32;
  format : uint32;
  videoformat : uint32;

begin
  gbitmap:=LoadImageA(GetModuleHandle(NIL), path, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION or LR_LOADFROMFILE);
  GetObject(gbitmap, sizeof(sbitmap), @sbitmap);

  glEnable ( GL_TEXTURE_2D );
  glGenTextures ( 1, @TextureID );
  glBindTexture ( GL_TEXTURE_2D, TextureID );

  glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

  if (sbitmap.bmBitsPixel / 8 = 4) then
     format := GL_BGRA
  else
     format := GL_BGR;

  if format = GL_BGR then
      videoformat := GL_RGB
  else
    videoformat := GL_RGBA;

   Symbol_height:=sbitmap.bmHeight;
   Symbol_width:=sbitmap.bmWidth;
   glTexImage2D(GL_TEXTURE_2D, 0, videoformat, sbitmap.bmWidth, sbitmap.bmHeight,
               0, format, GL_UNSIGNED_BYTE, sBitmap.bmBits);

  Result := TextureID;
end;

procedure ReleaseFont;
begin
  TSymbol[1].mSymbol:=LoadBmp('Data\Font\1.bmp');
  TSymbol[1].width:=Symbol_width;
  TSymbol[1].height:=Symbol_height;

  TSymbol[2].mSymbol:=LoadBmp('Data\Font\2.bmp');
  TSymbol[2].width:=Symbol_width;
  TSymbol[2].height:=Symbol_height;

  TSymbol[3].mSymbol:=LoadBmp('Data\Font\3.bmp');
  TSymbol[3].width:=Symbol_width;
  TSymbol[3].height:=Symbol_height;

  TSymbol[4].mSymbol:=LoadBmp('Data\Font\4.bmp');
  TSymbol[4].width:=Symbol_width;
  TSymbol[4].height:=Symbol_height;

  TSymbol[5].mSymbol:=LoadBmp('Data\Font\5.bmp');
  TSymbol[5].width:=Symbol_width;
  TSymbol[5].height:=Symbol_height;

  TSymbol[6].mSymbol:=LoadBmp('Data\Font\6.bmp');
  TSymbol[6].width:=Symbol_width;
  TSymbol[6].height:=Symbol_height;

  TSymbol[7].mSymbol:=LoadBmp('Data\Font\7.bmp');
  TSymbol[7].width:=Symbol_width;
  TSymbol[7].height:=Symbol_height;

  TSymbol[8].mSymbol:=LoadBmp('Data\Font\8.bmp');
  TSymbol[8].width:=Symbol_width;
  TSymbol[8].height:=Symbol_height;

  TSymbol[9].mSymbol:=LoadBmp('Data\Font\9.bmp');
  TSymbol[9].width:=Symbol_width;
  TSymbol[9].height:=Symbol_height;

  TSymbol[10].mSymbol:=LoadBmp('Data\Font\0.bmp');
  TSymbol[10].width:=Symbol_width;
  TSymbol[10].height:=Symbol_height;

  TSymbol[11].mSymbol:=LoadBmp('Data\Font\t.bmp');
  TSymbol[11].width:=Symbol_width;
  TSymbol[11].height:=Symbol_height;

  TSymbol[12].mSymbol:=LoadBmp('Data\Font\x.bmp');
  TSymbol[12].width:=Symbol_width;
  TSymbol[12].height:=Symbol_height;

  TSymbol[13].mSymbol:=LoadBmp('Data\Font\l.bmp');
  TSymbol[13].width:=Symbol_width;
  TSymbol[13].height:=Symbol_height;

  TSymbol[14].mSymbol:=LoadBmp('Data\Font\v.bmp');
  TSymbol[14].width:=Symbol_width;
  TSymbol[14].height:=Symbol_height;

  TSymbol[15].mSymbol:=LoadBmp('Data\Font\e.bmp');
  TSymbol[15].width:=Symbol_width;
  TSymbol[15].height:=Symbol_height;

  TSymbol[16].mSymbol:=LoadBmp('Data\Font\point.bmp');
  TSymbol[16].width:=Symbol_width;
  TSymbol[16].height:=Symbol_height;

  TSymbol[17].mSymbol:=LoadBmp('Data\Font\a.bmp');
  TSymbol[17].width:=Symbol_width;
  TSymbol[17].height:=Symbol_height;

  TSymbol[18].mSymbol:=LoadBmp('Data\Font\b.bmp');
  TSymbol[18].width:=Symbol_width;
  TSymbol[18].height:=Symbol_height;

  TSymbol[19].mSymbol:=LoadBmp('Data\Font\c.bmp');
  TSymbol[19].width:=Symbol_width;
  TSymbol[19].height:=Symbol_height;

  TSymbol[20].mSymbol:=LoadBmp('Data\Font\d.bmp');
  TSymbol[20].width:=Symbol_width;
  TSymbol[20].height:=Symbol_height;

  TSymbol[21].mSymbol:=LoadBmp('Data\Font\f.bmp');
  TSymbol[21].width:=Symbol_width;
  TSymbol[21].height:=Symbol_height;

  TSymbol[22].mSymbol:=LoadBmp('Data\Font\g.bmp');
  TSymbol[22].width:=Symbol_width;
  TSymbol[22].height:=Symbol_height;

  TSymbol[23].mSymbol:=LoadBmp('Data\Font\h.bmp');
  TSymbol[23].width:=Symbol_width;
  TSymbol[23].height:=Symbol_height;

  TSymbol[24].mSymbol:=LoadBmp('Data\Font\i.bmp');
  TSymbol[24].width:=Symbol_width;
  TSymbol[24].height:=Symbol_height;

  TSymbol[25].mSymbol:=LoadBmp('Data\Font\j.bmp');
  TSymbol[25].width:=Symbol_width;
  TSymbol[25].height:=Symbol_height;

  TSymbol[26].mSymbol:=LoadBmp('Data\Font\k.bmp');
  TSymbol[26].width:=Symbol_width;
  TSymbol[26].height:=Symbol_height;

  TSymbol[27].mSymbol:=LoadBmp('Data\Font\m.bmp');
  TSymbol[27].width:=Symbol_width;
  TSymbol[27].height:=Symbol_height;

  TSymbol[28].mSymbol:=LoadBmp('Data\Font\n.bmp');
  TSymbol[28].width:=Symbol_width;
  TSymbol[28].height:=Symbol_height;

  TSymbol[29].mSymbol:=LoadBmp('Data\Font\o.bmp');
  TSymbol[29].width:=Symbol_width;
  TSymbol[29].height:=Symbol_height;

  TSymbol[30].mSymbol:=LoadBmp('Data\Font\p.bmp');
  TSymbol[30].width:=Symbol_width;
  TSymbol[30].height:=Symbol_height;

  TSymbol[31].mSymbol:=LoadBmp('Data\Font\q.bmp');
  TSymbol[31].width:=Symbol_width;
  TSymbol[31].height:=Symbol_height;

  TSymbol[32].mSymbol:=LoadBmp('Data\Font\r.bmp');
  TSymbol[32].width:=Symbol_width;
  TSymbol[32].height:=Symbol_height;

  TSymbol[33].mSymbol:=LoadBmp('Data\Font\s.bmp');
  TSymbol[33].width:=Symbol_width;
  TSymbol[33].height:=Symbol_height;

  TSymbol[34].mSymbol:=LoadBmp('Data\Font\u.bmp');
  TSymbol[34].width:=Symbol_width;
  TSymbol[34].height:=Symbol_height;

  TSymbol[35].mSymbol:=LoadBmp('Data\Font\w.bmp');
  TSymbol[35].width:=Symbol_width;
  TSymbol[35].height:=Symbol_height;

  TSymbol[36].mSymbol:=LoadBmp('Data\Font\y.bmp');
  TSymbol[36].width:=Symbol_width;
  TSymbol[36].height:=Symbol_height;

  TSymbol[37].mSymbol:=LoadBmp('Data\Font\z.bmp');
  TSymbol[37].width:=Symbol_width;
  TSymbol[37].height:=Symbol_height;

  TSymbol[38].mSymbol:=LoadBmp('Data\Font\question.bmp');
  TSymbol[38].width:=Symbol_width;
  TSymbol[38].height:=Symbol_height;

  TSymbol[39].mSymbol:=LoadBmp('Data\Font\space.bmp');
  TSymbol[39].width:=Symbol_width;
  TSymbol[39].height:=Symbol_height;
end;

procedure TextInit;
begin
  //����
  Tex.gobject[1]:=LoadBMP('Data\Images\1.bmp'); //��������� ���
  Tex.gobject[2]:=LoadBMP('Data\Images\2.bmp'); //������� ���
  Tex.gobject[3]:=LoadBMP('Data\Images\3.bmp'); //������-���������� ���
  Tex.gobject[4]:=LoadBMP('Data\Images\4.bmp'); //���������� ���
  Tex.gobject[5]:=LoadBMP('Data\Images\5.bmp'); //��������� ���
  Tex.gobject[6]:=LoadBMP('Data\Images\6.bmp'); //�����-���������� ���
  Tex.gobject[7]:=LoadBMP('Data\Images\7.bmp'); //��������� ���
  Tex.gobject[8]:=LoadBMP('Data\Images\8.bmp'); //������-��������� ���
  Tex.gobject[9]:=LoadBMP('Data\Images\9.bmp'); //������� ���
  //end-����

  //��������
  Tex.gobject[10]:=LoadBMP('Data\Images\white_vpivot.bmp'); //���������
  //end-��������
end;

//������ ��� ����. 0:0 - ����� �����//
procedure draw_quad_c(_x, _y, _width, _height :real);

begin

  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_x - (_width / 2), _y + (_height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(_x + (_width / 2), _y + (_height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(_x + (_width / 2), _y - (_height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(_x - (_width / 2), _y - (_height / 2));
  glEnd();
end;

procedure draw_quad_c2(r: Rectangle);

begin
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(r.x - (r.width / 2), r.y + (r.height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(r.x + (r.width / 2), r.y + (r.height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(r.x + (r.width / 2), r.y - (r.height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(r.x - (r.width / 2), r.y - (r.height / 2));
  glEnd();
end;

//������ ��� ����. 0:0 - ������� ����� ����//
procedure draw_quad2(r: Rectangle);
begin
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(r.x, r.y + r.height);
    glTexCoord2f(1.0, 0.0); glVertex2f(r.x + r.width, r.y + r.height);
    glTexCoord2f(1.0, 1.0); glVertex2f(r.x + r.width, r.y);
    glTexCoord2f(0.0, 1.0); glVertex2f(r.x, r.y);
  glEnd();
end;

//������ ��� ����. 0:0 - ������� ����� ����//
procedure draw_quad(_x, _y, _width, _height :real);
begin
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_x, _y + _height);
    glTexCoord2f(1.0, 0.0); glVertex2f(_x + _width, _y + _height);
    glTexCoord2f(1.0, 1.0); glVertex2f(_x + _width, _y);
    glTexCoord2f(0.0, 1.0); glVertex2f(_x, _y);
  glEnd();
end;

procedure PrintText(a: array of SymbolTType; k:integer);
var i:integer;
begin
  for I := 0 to k-1 do
    begin
      glBindTexture(GL_TEXTURE_2D, a[i].ptSymbol);
      draw_quad(a[i].x,a[i].y,a[i].width,a[i].height);
    end;

end;

function TPrintText(text2:string; t1, t2,TLength: real; draw:boolean; theight:real) : integer;
var k:integer; i:integer; m1,m2:real;
begin
  m1:=0; m2:=0;
  pSymbol[1].x:=t1;
  pSymbol[1].y:=t2;
  k:=length(text2);
  for i:=1 to k do
	begin

        case text2[i] of
            '0': begin
                  pSymbol[i].ptSymbol:=tSymbol[10].mSymbol;
                  pSymbol[i].width:=tSymbol[10].width;
                  pSymbol[i].height:=tSymbol[10].height;
                 end;
            '1': begin
                  pSymbol[i].ptSymbol:=tSymbol[1].mSymbol;
                  pSymbol[i].width:=tSymbol[1].width;
                  pSymbol[i].height:=tSymbol[1].height;
                 end;
            '2': begin
                  pSymbol[i].ptSymbol:=tSymbol[2].mSymbol;
                  pSymbol[i].width:=tSymbol[2].width;
                  pSymbol[i].height:=tSymbol[2].height;
                 end;
            '3': begin
                  pSymbol[i].ptSymbol:=tSymbol[3].mSymbol;
                  pSymbol[i].width:=tSymbol[3].width;
                  pSymbol[i].height:=tSymbol[3].height;
                 end;
            '4': begin
                  pSymbol[i].ptSymbol:=tSymbol[4].mSymbol;
                  pSymbol[i].width:=tSymbol[4].width;
                  pSymbol[i].height:=tSymbol[4].height;
                 end;
            '5': begin
                  pSymbol[i].ptSymbol:=tSymbol[5].mSymbol;
                  pSymbol[i].width:=tSymbol[5].width;
                  pSymbol[i].height:=tSymbol[5].height;
                 end;
            '6': begin
                  pSymbol[i].ptSymbol:=tSymbol[6].mSymbol;
                  pSymbol[i].width:=tSymbol[6].width;
                  pSymbol[i].height:=tSymbol[6].height;
                 end;
            '7': begin
                  pSymbol[i].ptSymbol:=tSymbol[7].mSymbol;
                  pSymbol[i].width:=tSymbol[7].width;
                  pSymbol[i].height:=tSymbol[7].height;
                 end;
            '8': begin
                  pSymbol[i].ptSymbol:=tSymbol[8].mSymbol;
                  pSymbol[i].width:=tSymbol[8].width;
                  pSymbol[i].height:=tSymbol[8].height;
                 end;
            '9': begin
                  pSymbol[i].ptSymbol:=tSymbol[9].mSymbol;
                  pSymbol[i].width:=tSymbol[9].width;
                  pSymbol[i].height:=tSymbol[9].height;
                 end;
            'a','A': begin
                  pSymbol[i].ptSymbol:=tSymbol[17].mSymbol;
                  pSymbol[i].width:=tSymbol[17].width;
                  pSymbol[i].height:=tSymbol[17].height;
                 end;
            'b','B': begin
                  pSymbol[i].ptSymbol:=tSymbol[18].mSymbol;
                  pSymbol[i].width:=tSymbol[18].width;
                  pSymbol[i].height:=tSymbol[18].height;
                 end;
            'c','C': begin
                  pSymbol[i].ptSymbol:=tSymbol[19].mSymbol;
                  pSymbol[i].width:=tSymbol[19].width;
                  pSymbol[i].height:=tSymbol[19].height;
                 end;
            'd','D': begin
                  pSymbol[i].ptSymbol:=tSymbol[20].mSymbol;
                  pSymbol[i].width:=tSymbol[20].width;
                  pSymbol[i].height:=tSymbol[20].height;
                 end;
            'e','E': begin
                  pSymbol[i].ptSymbol:=tSymbol[15].mSymbol;
                  pSymbol[i].width:=tSymbol[15].width;
                  pSymbol[i].height:=tSymbol[15].height;
                 end;
            'f','F': begin
                  pSymbol[i].ptSymbol:=tSymbol[21].mSymbol;
                  pSymbol[i].width:=tSymbol[21].width;
                  pSymbol[i].height:=tSymbol[21].height;
                 end;
            'g','G': begin
                  pSymbol[i].ptSymbol:=tSymbol[22].mSymbol;
                  pSymbol[i].width:=tSymbol[22].width;
                  pSymbol[i].height:=tSymbol[22].height;
                 end;
            'h','H': begin
                  pSymbol[i].ptSymbol:=tSymbol[23].mSymbol;
                  pSymbol[i].width:=tSymbol[23].width;
                  pSymbol[i].height:=tSymbol[23].height;
                 end;
            'i','I': begin
                  pSymbol[i].ptSymbol:=tSymbol[24].mSymbol;
                  pSymbol[i].width:=tSymbol[24].width;
                  pSymbol[i].height:=tSymbol[24].height;
                 end;
            'j','J': begin
                  pSymbol[i].ptSymbol:=tSymbol[25].mSymbol;
                  pSymbol[i].width:=tSymbol[25].width;
                  pSymbol[i].height:=tSymbol[25].height;
                 end;
            'k','K': begin
                  pSymbol[i].ptSymbol:=tSymbol[26].mSymbol;
                  pSymbol[i].width:=tSymbol[26].width;
                  pSymbol[i].height:=tSymbol[26].height;
                 end;
            'l','L': begin
                  pSymbol[i].ptSymbol:=tSymbol[13].mSymbol;
                  pSymbol[i].width:=tSymbol[13].width;
                  pSymbol[i].height:=tSymbol[13].height;
                 end;
            'm','M': begin
                  pSymbol[i].ptSymbol:=tSymbol[27].mSymbol;
                  pSymbol[i].width:=tSymbol[27].width;
                  pSymbol[i].height:=tSymbol[27].height;
                 end;
            'n','N': begin
                  pSymbol[i].ptSymbol:=tSymbol[28].mSymbol;
                  pSymbol[i].width:=tSymbol[28].width;
                  pSymbol[i].height:=tSymbol[28].height;
                 end;
            'o','O': begin
                  pSymbol[i].ptSymbol:=tSymbol[29].mSymbol;
                  pSymbol[i].width:=tSymbol[29].width;
                  pSymbol[i].height:=tSymbol[29].height;
                 end;
            'p','P': begin
                  pSymbol[i].ptSymbol:=tSymbol[30].mSymbol;
                  pSymbol[i].width:=tSymbol[30].width;
                  pSymbol[i].height:=tSymbol[30].height;
                 end;
            'q','Q': begin
                  pSymbol[i].ptSymbol:=tSymbol[31].mSymbol;
                  pSymbol[i].width:=tSymbol[31].width;
                  pSymbol[i].height:=tSymbol[31].height;
                 end;
            'r','R': begin
                  pSymbol[i].ptSymbol:=tSymbol[32].mSymbol;
                  pSymbol[i].width:=tSymbol[32].width;
                  pSymbol[i].height:=tSymbol[32].height;
                 end;
            's','S': begin
                  pSymbol[i].ptSymbol:=tSymbol[33].mSymbol;
                  pSymbol[i].width:=tSymbol[33].width;
                  pSymbol[i].height:=tSymbol[33].height;
                 end;
            't','T': begin
                  pSymbol[i].ptSymbol:=tSymbol[11].mSymbol;
                  pSymbol[i].width:=tSymbol[11].width;
                  pSymbol[i].height:=tSymbol[11].height;
                 end;
            'u','U': begin
                  pSymbol[i].ptSymbol:=tSymbol[34].mSymbol;
                  pSymbol[i].width:=tSymbol[34].width;
                  pSymbol[i].height:=tSymbol[34].height;
                 end;
            'v','V': begin
                  pSymbol[i].ptSymbol:=tSymbol[14].mSymbol;
                  pSymbol[i].width:=tSymbol[14].width;
                  pSymbol[i].height:=tSymbol[14].height;
                 end;
            'w','W': begin
                  pSymbol[i].ptSymbol:=tSymbol[35].mSymbol;
                  pSymbol[i].width:=tSymbol[35].width;
                  pSymbol[i].height:=tSymbol[35].height;
                 end;
            'x','X': begin
                  pSymbol[i].ptSymbol:=tSymbol[12].mSymbol;
                  pSymbol[i].width:=tSymbol[12].width;
                  pSymbol[i].height:=tSymbol[12].height;
                 end;
            'y','Y': begin
                  pSymbol[i].ptSymbol:=tSymbol[36].mSymbol;
                  pSymbol[i].width:=tSymbol[36].width;
                  pSymbol[i].height:=tSymbol[36].height;
                 end;
            'z','Z': begin
                  pSymbol[i].ptSymbol:=tSymbol[37].mSymbol;
                  pSymbol[i].width:=tSymbol[37].width;
                  pSymbol[i].height:=tSymbol[37].height;
                 end;
            '.',',': begin
                  pSymbol[i].ptSymbol:=tSymbol[16].mSymbol;
                  pSymbol[i].width:=tSymbol[16].width;
                  pSymbol[i].height:=tSymbol[16].height;
                 end;
            ' ','   ': begin
                  pSymbol[i].ptSymbol:=tSymbol[39].mSymbol;
                  pSymbol[i].width:=tSymbol[39].width;
                  pSymbol[i].height:=tSymbol[39].height;
                 end;
            else begin
                  pSymbol[i].ptSymbol:=tSymbol[38].mSymbol;
                  pSymbol[i].width:=tSymbol[38].width;
                  pSymbol[i].height:=tSymbol[38].height;
                 end;
        end;


        psymbol[i].width:=psymbol[i].width*theight/psymbol[i].height;
        psymbol[i].height:=theight;

		if i>1
			then
                    begin
					  pSymbol[i].x:=pSymbol[i-1].x+pSymbol[i-1].width+TLength;
					  pSymbol[i].y:=pSymbol[i-1].y;
                    end;

	end;
    if draw=true then
      PrintText(pSymbol,k);
    Result:=k;
end;

function FindSymbol(strings:string; lu: string): integer;
var k: integer; i:integer;
begin
    k:=length(strings);
    for i := 1 to k do
        if (strings[k]=lu) then   begin
            Result:=k;
            exit();
        end;
end;

function CreateButton(x,y:integer; text2:string; TLength: real;
                      draw:boolean; theight:real; texture:string; mx, my: integer):boolean;
var k: integer; width, height:real; A:integer; p:boolean; n:integer;
begin
  k:=TprintText(text2,x,y+5,tlength,false, theight);
  width:=abs(pSymbol[1].x-(pSymbol[k].x+pSymbol[k].width));
  height:=theight;

  if texture='orange' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[1]);
  if texture='blue' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[2]);
  if texture='green-light' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[3]);
  if texture='purple' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[4]);
  if texture='blue-light' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[5]);
  if texture='blue-dark' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[6]);
  if texture='red-dark' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[7]);
  if texture='orange-light' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[8]);
  if texture='green' then
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[9]);

  n:=Trunc(width+50);
  height:=height+10;
   if (mx>x) and (mx<width+x) and (my>y) and (my<height+y) then
    begin
    width:=n;
    glBindTexture(GL_TEXTURE_2D, Tex.gobject[8]);
      if tclick=true then begin
         Result:=true;
      end

        else begin
        result:=false;
        end;
    end;


  draw_quad(x,y,width,height);
  printText(pSymbol,k);

end;

end.
