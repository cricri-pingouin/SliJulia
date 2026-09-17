unit Unit1;

{$X+}

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Graphics, Inifiles, Menus,
  ExtCtrls, Dialogs;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    mniDraw: TMenuItem;
    mniOptions: TMenuItem;
    mniPNG: TMenuItem;
    mniExit: TMenuItem;
    Image1: TImage;
    procedure DrawFractal(dX, dY, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniDrawClick(Sender: TObject);
    procedure mniOptionsClick(Sender: TObject);
    procedure mniPNGClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CanvasWidth, CanvasHeight, MaxIterations: Integer;
    Xmin, Xmax, Ymin, Ymax, Cr, Ci: Single;
    Colour1, Colour2, Colour3: Tcolor;
    UseFire, DrawMandelbrot: Boolean;
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2, pngimage;

{$R *.dfm}function GetPigmentBetween(P1, P2, Percent: Double): Integer;
  {Returns a number that is Percent of the way between P1 and P2}
begin
  {Find the number between P1 and P2}
  Result := Round(((P2 - P1) * Percent) + P1);
  {Make sure we are within bounds for color.}
  if Result > 255 then
    Result := 255;
  if Result < 0 then
    Result := 0;
end;

function GetGradientColor2(R1, G1, B1, R2, G2, B2, Percent: Double): TRGBTriple;
  {Gets a color that is inbetween the colors defined by (R1,G1,B1)
  and (R2,G2,B2) Percent ranges from 0 to 1.0 (i.e. 0.5 = 50%)
  If percent = 0 then the color of (R1,G1,B1) is returned
  If Percent = 1 then the color of (R2,G2,B2) is returned
  if Percent is somewhere inbetween, then an inbetween color is returned.}
var
  NewRed, NewGreen, NewBlue: Integer;
begin
  {Validate input data in case it is off by a few thousanths.}
  if Percent > 1 then
    Percent := 1;
  if Percent < 0 then
    Percent := 0;
  {Calculate Red, green, and blue components for the new color.}
  NewRed := GetPigmentBetween(R1, R2, Percent);
  NewGreen := GetPigmentBetween(G1, G2, Percent);
  NewBlue := GetPigmentBetween(B1, B2, Percent);
  {Convert RGB to color}
  Result.rgbtRed := NewRed;
  Result.rgbtGreen := NewGreen;
  Result.rgbtBlue := NewBlue;
end;

procedure TForm1.DrawFractal(dX, dY, MinX, MinY: Single; SizeX, SizeY, MaxCount: Integer);
var
  c1, c2, z1, z2, tmp: Double;
  //Ci, Cr, Four: Double;    //FOR ASM
  i, j, Count: Integer;
  //Scanline stuff
  PicBuffer: TBitmap; //buffer
  BufferArray: array of array of Byte; // Multi-dimension array
  P: PRGBTriple; //Scanline pointer
  Palette: array[0..255] of TRGBTriple; //24bits RGB palettes
//FOR ASM
//label
//  _start, _end, _realend;
begin
//Count will always be from 1<= count <= MaxIterations
  //Initialise palette, otherwise unpredictable colours from whatever already in memory
  for i := 0 to 255 do
  begin
    Palette[i].rgbtRed := 0;
    Palette[i].rgbtGreen := 0;
    Palette[i].rgbtBlue := 0;
  end;
  //Set colour palette
  if UseFire then
  begin
    for i := 1 to (MaxIterations div 3) do
    begin
      Palette[i].rgbtRed := (i * 255) div (MaxIterations div 3);
      Palette[i].rgbtGreen := 0;
      Palette[i].rgbtBlue := 0;
    end;
    for i := (MaxIterations div 3 + 1) to (2 * MaxIterations div 3) do
    begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := ((i - MaxIterations div 3) * 255) div (MaxIterations div 3);
      Palette[i].rgbtBlue := 0;
    end;
    for i := (2 * MaxIterations div 3 + 1) to MaxIterations do
    begin
      Palette[i].rgbtRed := 255;
      Palette[i].rgbtGreen := 255;
      Palette[i].rgbtBlue := ((i - 2 * MaxIterations div 3) * 255) div (MaxIterations div 3);
    end;
  end
  else
  begin
    for i := 0 to MaxIterations div 2 - 1 do
    begin
      Palette[i] := GetGradientColor2(GetRValue(Colour1), GetGValue(Colour1), GetBValue(Colour1), GetRValue(Colour2), GetGValue(Colour2), GetBValue(Colour2), i / MaxIterations)
    end;
    for i := MaxIterations div 2 to MaxIterations do
    begin
      Palette[i] := GetGradientColor2(GetRValue(Colour2), GetGValue(Colour2), GetBValue(Colour2), GetRValue(Colour3), GetGValue(Colour3), GetBValue(Colour3), i / MaxIterations)
    end;
  end;
  //Size the buffer array according to previous variables, i.e. form size
  SetLength(BufferArray, SizeX, SizeY);
  //Initialise buffer
  PicBuffer := TBitmap.Create;
  PicBuffer.Width := SizeX;
  PicBuffer.Height := SizeY;
  PicBuffer.PixelFormat := pf24bit; //Use 24bits RGB, not TColor as we won't use alpha blending
  //Calculate Mandelbrot set
  c2 := MinY;
  for i := 0 to SizeY - 1 do
  begin
    c1 := MinX;
    for j := 0 to SizeX - 1 do
    //Compute series iterations for this Z coordinate

//DELPHI SECTION START
    begin
      z1 := c1;
      z2 := c2;
      Count := 0;
      //If |z| >=2 then z is not a member of a set
      if DrawMandelbrot then
      begin
        while ((z1 * z1 + z2 * z2 < 4.0) and (Count < MaxIterations)) do
        begin
          tmp := z1;
          z1 := z1 * z1 - z2 * z2 + c1;
          z2 := 2 * tmp * z2 + c2;
          Inc(Count);
        end;
      end
      else
        while ((z1 * z1 + z2 * z2 < 4.0) and (Count < MaxIterations)) do
        begin
          tmp := z1 * z1 - z2 * z2 + Cr;
          z2 := 2 * z1 * z2 + Ci;
          z1 := tmp;
          Inc(Count);
        end;
//DELPHI SECTION END

//ASM SECTION START
//      Four := 4.0;
//      Count := MaxIterations;
//      asm
//        // Next 4 lines not faster than z1 := 0; z2 := 0; but not slower either
//        fld     c1
//        fstp    z1
//        fld     c2
//        fstp    z2
//        //while ((z1 * z1 + z2 * z2 < 4.0) and (Count < MaxIterations)) do
//        _start  :
//        fld     z1
//        fmul    st, st
//        fld     st    //dup z1^2 for next step
//        fld     z2
//        fmul    st, st
//        fld     st    //dup z2^2 for next step
//        fxch    st(2) //get back z1^2 in st(0) to calc z1^2+z2^2
//        fadd
//        fld     Four  //OR: could do fild Four where Four is an integer but the conversion makes it slower
//        fcomip  st, st(1)
//        fstp    st //Unlike fcompp, fcomip pops the stack once not twice, so need to pop again
//        jbe     _end
//        //tmp = z1 * z1 - z2 * z2 + Cr
//        fsub
//        fld     Cr
//        fadd          //tmp
//        fld     st    //dup to store in z1
//        //z2 = 2 * z1 * z2 + Ci
//        fld     z2
//        fmul          //fmul to old z1 value copy in st(1)
//        fadd    st, st //*2; OR: fld st fadd, OR: fld1 fld1 fadd fmul, OR: fld Two fmul (where Two := 2.0; slower)
//        fld     Ci
//        fadd
//        fstp    z2 //z2 = st(0)
//        fstp    z1
//        //Dec Count
//        dec     Count
//        //while ... (Count < MaxIterations), here changed to Count>0 so can do jnz and save cmp
//        jnz     _start
//        jmp     _realend
//        _end    :
//        //Due to duplicating the z^2 values, downside is if we get here they are still in stack, need pop twice to empty
//        //OR: fucompp (comp and pops twice same speed, same speed but less compatible?), OR: emms (slower)
//        fstp    st
//        fstp    st
//        _realend :
//      end;
//ASM SECTION END

      //Colour pixel at Z coordinates
      //Colour from palette with index = number of iterations
      BufferArray[j, i] := Count;
      c1 := c1 + dX;
    end;
    c2 := c2 + dY;
  end;
  //Populate buffer using scanline
  for j := 0 to SizeY - 1 do //Height-1 or pointer will fall out=crash!
  begin
    //Loop through Y, then X. This way we process the whole scanline in one go
    P := PicBuffer.ScanLine[j];
    for i := 0 to SizeX - 1 do //Width-1 or pointer will fall out=crash!
    begin
      //Set pixel colour according to index value in palettes
      P^ := Palette[MaxIterations - BufferArray[i, j]];
      //Increment pointer AFTER, otherwise we fail to process leftmost column
      Inc(P);
    end;
  end;
  //Copy buffer to form canvas
  Image1.Canvas.Draw(0, 0, PicBuffer);
  //Canvas.Draw(0, 0, PicBuffer);
  //Free PicBuffer to avoid memory leak
  PicBuffer.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  myINI: TINIFile;
begin
  //Initialise options from INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'Julia.ini');
  //Read settings from INI file
  CanvasWidth := myINI.ReadInteger('Settings', 'CanvasWidth', 1000);
  CanvasHeight := myINI.ReadInteger('Settings', 'CanvasHeight', 800);
  Xmin := myINI.ReadFloat('Settings', 'Xmin', -1.5);
  Xmax := myINI.ReadFloat('Settings', 'Xmax', 1.5);
  Ymin := myINI.ReadFloat('Settings', 'Ymin', -1);
  Ymax := myINI.ReadFloat('Settings', 'Ymax', 1);
  MaxIterations := myINI.ReadInteger('Settings', 'MaxIterations', 255);
  Cr := myINI.ReadFloat('Settings', 'Cr', -0.8);
  Ci := myINI.ReadFloat('Settings', 'Ci', 0.156);
  Colour1 := myINI.ReadInteger('Settings', 'Colour1', 255);
  Colour2 := myINI.ReadInteger('Settings', 'Colour2', 256 * 255);
  Colour3 := myINI.ReadInteger('Settings', 'Colour3', 256 * 256 * 255);
  UseFire := myINI.ReadBool('Settings', 'UseFire', True);
  DrawMandelbrot := myINI.ReadBool('Settings', 'DrawMandelbrot', True);
  myINI.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  myINI: TINIFile;
begin
  //Save settings to INI file
  myINI := TINIFile.Create(ExtractFilePath(Application.EXEName) + 'Julia.ini');
  myINI.WriteInteger('Settings', 'CanvasWidth', CanvasWidth);
  myINI.WriteInteger('Settings', 'CanvasHeight', CanvasHeight);
  myINI.WriteFloat('Settings', 'Xmin', Xmin);
  myINI.WriteFloat('Settings', 'Xmax', Xmax);
  myINI.WriteFloat('Settings', 'Ymin', Ymin);
  myINI.WriteFloat('Settings', 'Ymax', Ymax);
  myINI.WriteInteger('Settings', 'MaxIterations', MaxIterations);
  myINI.WriteFloat('Settings', 'Cr', Cr);
  myINI.WriteFloat('Settings', 'Ci', Ci);
  myINI.WriteInteger('Settings', 'Colour1', Colour1);
  myINI.WriteInteger('Settings', 'Colour2', Colour2);
  myINI.WriteInteger('Settings', 'Colour3', Colour3);
  myINI.WriteBool('Settings', 'UseFire', UseFire);
  myINI.WriteBool('Settings', 'DrawMandelbrot', DrawMandelbrot);
  myINI.Free;
end;

procedure TForm1.mniDrawClick(Sender: TObject);
var
  dX, dY: Single;
  Start, Finish: Int64;
begin
  //Size window
  ClientWidth := CanvasWidth;
  ClientHeight := CanvasHeight;
  //Size image, it seems to fail if doing it in Julia drawing routine if size > ca. 800 pixels
  Image1.Width := CanvasWidth;
  Image1.Height := CanvasHeight;
  //Calculate steps size to make one pixel
  dX := (Xmax - Xmin) / CanvasWidth;
  dY := (Ymax - Ymin) / CanvasHeight;
  //Draw Julia
  Caption := 'Wait...';
  Start := GetTickCount;
  DrawFractal(dX, dY, Xmin, Ymin, CanvasWidth, CanvasHeight, MaxIterations);
  Finish := GetTickCount;
  Caption := 'Time: ' + IntToStr(Finish - Start) + 'ms';
  mniPNG.Enabled := True;
end;

procedure TForm1.mniOptionsClick(Sender: TObject);
begin
  if Form2.Visible = False then
    Form2.Show
  else
    Form2.Hide;
end;

procedure TForm1.mniPNGClick(Sender: TObject);
var
  i: Integer;
  FileName: string;
  PNG: TPNGObject;
begin
  FileName := 'Julia.png';
  if fileexists(FileName) then
  begin
    i := 0;
    repeat
      Inc(i);
      FileName := 'Julia' + inttostr(i) + '.png';
    until not fileexists(FileName);
  end;
  PNG := TPNGObject.Create;
  try
    PNG.Assign(Image1.Picture.Bitmap);
    PNG.SaveToFile(FileName);
    ShowMessage('Saved file ' + FileName);
  finally
    PNG.Free;
  end
end;

procedure TForm1.mniExitClick(Sender: TObject);
begin
  Close;
end;

end.

