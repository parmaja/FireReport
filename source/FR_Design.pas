{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Report Designer             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Design;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Printers, ComCtrls,
  System.Contnrs, System.Types, System.UITypes,
  Menus, FR_Classes, FR_Color,
  FR_Dock, FR_Inspector, FR_MemoEditor, ImgList, ToolWin, System.ImageList;


const
  MaxUndoBuffer = 100;
  crPencil = 11;

type
  TfrDesignerForm = class;
  TfrDesigner = class(TComponent) // fake component
  private
    FTemplDir: string;
  public
    procedure Loaded; override;
  published
    property TemplateDir: string read FTemplDir write FTemplDir;
  end;

  TfrSelectionType = (ssBand, ssMemo, ssOther, ssMultiple, ssClipboardFull);
  TfrSelectionStatus = set of TfrSelectionType;
  TfrReportUnits = (ruPixels, ruMM, ruInches);
  TfrShapeMode = (smFrame, smAll);

  TfrUndoAction = (acInsert, acDelete, acEdit, acZOrder);
  TfrUndoObj = class(TObject)
  public
    Next: TfrUndoObj;
    ObjID: Integer;
    ObjPtr: TfrView;
    Int: Integer;
  end;

  TfrUndoRec = record
    Action: TfrUndoAction;
    Page: Integer;
    Objects: TfrUndoObj;
  end;

  TfrUndoRec1 = class(TObject)
  public
    ObjPtr: TfrView;
    Int: Integer;
  end;

  PfrUndoBuffer = ^TfrUndoBuffer;
  TfrUndoBuffer = array[0..MaxUndoBuffer - 1] of TfrUndoRec;

  TfrMenuItemInfo = class(TObject)
  private
    MenuItem: TMenuItem;
    Btn: TToolButton;
  end;
  TfrDesignerDrawMode = (dmAll, dmSelection, dmShape);

  TfrSplitInfo = record
    SplRect: TRect;
    SplX: Integer;
    View1, View2: TfrView;
  end;

  TfrDesignerPage = class(TPanel)
  private
    Down, // mouse button was pressed
    Moved, // mouse was moved (with pressed btn)
    DFlag, // was double click
    RFlag: Boolean; // selecting objects by framing
    Mode: (mdInsert, mdSelect); // current mode
    CT: (ctNone, ct1, ct2, ct3, ct4, ct5, ct6, ct7, ct8); // cursor type
    LastX, LastY: Integer; // here stored last mouse coords
    SplitInfo: TfrSplitInfo;
    RightBottom: Integer;
    LeftTop: TPoint;
    FirstBandMove: Boolean;
    FDesigner: TfrDesignerForm;
    procedure NormalizeRect(var r: TRect);
    procedure NormalizeCoord(t: TfrView);
    function FindNearestEdge(var x, y: Integer): Boolean;
    procedure RoundCoord(var x, y: Integer);
    procedure Draw(N: Integer; ClipRgn: HRGN);
    procedure DrawPage(DrawMode: TfrDesignerDrawMode);
    procedure DrawRectLine(Rect: TRect);
    procedure DrawFocusRect(Rect: TRect);
    procedure DrawHSplitter(Rect: TRect);
    procedure DrawSelection(t: TfrView);
    procedure DrawShape(t: TfrView);
    procedure MDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DClick(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init;
    procedure SetPage;
    procedure GetMultipleSelected;
  end;

  TfrDesignerForm = class(TfrReportDesigner)
    StatusBar1: TStatusBar;
    EditPopup: TPopupMenu;
    ECopyMnu: TMenuItem;
    ECutMnu: TMenuItem;
    EPasteMnu: TMenuItem;
    EDeleteMnu: TMenuItem;
    EEditObjectMnu: TMenuItem;
    MainMenu: TMainMenu;
    FileMnu: TMenuItem;
    EditMnu: TMenuItem;
    ToolsMnu: TMenuItem;
    ExitMnu: TMenuItem;
    CutMnu: TMenuItem;
    CopyMnu: TMenuItem;
    PasteMnu: TMenuItem;
    OpenMnu: TMenuItem;
    SaveMnu: TMenuItem;
    N21: TMenuItem;
    NewMnu: TMenuItem;
    N24: TMenuItem;
    PageOptionsMnu: TMenuItem;
    DeleteMnu: TMenuItem;
    SelectAllMnu: TMenuItem;
    N26: TMenuItem;
    AddPageMnu: TMenuItem;
    RemovePageMnu: TMenuItem;
    N31: TMenuItem;
    BringToFrontMnu: TMenuItem;
    SendToBackMnu: TMenuItem;
    EditObjectMnu: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SelectImageList: TImageList;
    ObjectInspectorMnu: TMenuItem;
    ReportOptionsMnu: TMenuItem;
    FontImageList: TImageList;
    N38: TMenuItem;
    AlignmentMnu: TMenuItem;
    PreviewMnu: TMenuItem;
    N40: TMenuItem;
    VariablesListMnu: TMenuItem;
    ESelectAllMnu: TMenuItem;
    ToolbarsMnu: TMenuItem;
    StandardMnu: TMenuItem;
    TextMnu: TMenuItem;
    RectangleMnu: TMenuItem;
    ObjectsMnu: TMenuItem;
    Tab1: TTabControl;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    HelpMnu: TMenuItem;
    AboutMnu: TMenuItem;
    UndoMnu: TMenuItem;
    N47: TMenuItem;
    RedoMnu: TMenuItem;
    Image2: TImage;
    OptionsMnu: TMenuItem;
    Panel7: TPanel;
    PBox1: TPaintBox;
    SaveAsMnu: TMenuItem;
    N18: TMenuItem;
    HelpContentsMnu: TMenuItem;
    HelpToolMnu: TMenuItem;
    PagePopup: TPopupMenu;
    N41: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    CoolBar1: TCoolBar;
    StandardPnl: TToolBar;
    NewBtn: TToolButton;
    OpenBtn: TToolButton;
    SaveBtn: TToolButton;
    PreviewBtn: TToolButton;
    CutBtn: TToolButton;
    CopyBtn: TToolButton;
    PasteBtn: TToolButton;
    BringToFrontBtn: TToolButton;
    SendToBackBtn: TToolButton;
    SelectAllBtn: TToolButton;
    AddPageBtn: TToolButton;
    RemovePageBtn: TToolButton;
    PageOptionsBtn: TToolButton;
    GridBtn: TToolButton;
    GridAlignBtn: TToolButton;
    frTBSeparator1: TToolButton;
    frTBSeparator2: TToolButton;
    frTBSeparator3: TToolButton;
    FitToGridBtn: TToolButton;
    UndoBtn: TToolButton;
    frTBSeparator14: TToolButton;
    RedoBtn: TToolButton;
    TextPnl: TToolBar;
    LeftAlignBtn: TToolButton;
    RightAlignBtn: TToolButton;
    CenterAlignBtn: TToolButton;
    RotateBtn: TToolButton;
    VerticalCenterBtn: TToolButton;
    BoldBtn: TToolButton;
    ItalicBtn: TToolButton;
    UnderLineBtn: TToolButton;
    FontColorBtn: TSpeedButton;
    TopAlignBtn: TToolButton;
    BottomAlignBtn: TToolButton;
    frTBSeparator8: TToolButton;
    frTBSeparator9: TToolButton;
    WidthAlignBtn: TToolButton;
    RectanglePnl: TToolBar;
    TopFrameLineBtn: TToolButton;
    LeftFrameLineBtn: TToolButton;
    BottomFrameLineBtn: TToolButton;
    RightFrameLineBtn: TToolButton;
    BackgroundColorBtn: TSpeedButton;
    FrameColorBtn: TSpeedButton;
    AllFrameLinesBtn: TToolButton;
    NoFrameBtn: TToolButton;
    frTBSeparator10: TToolButton;
    frTBSeparator15: TToolButton;
    LineStyleBtn: TToolButton;
    frTBPanel2: TPanel;
    FrameWidthEdit: TEdit;
    ToolButton1: TToolButton;
    FontSizeCbo: TComboBox;
    FontsCbo: TComboBox;
    ToolbarImages: TImageList;
    LineStyleImages: TImageList;
    LinePanel: TPanel;
    frSpeedButton1: TSpeedButton;
    frSpeedButton2: TSpeedButton;
    frSpeedButton3: TSpeedButton;
    frSpeedButton4: TSpeedButton;
    frSpeedButton5: TSpeedButton;
    frSpeedButton6: TSpeedButton;
    FrameWidthUpDown: TUpDown;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    CoolBar2: TCoolBar;
    CoolBar3: TCoolBar;
    AlignmentPnl: TToolBar;
    AlignBottomsBtn: TToolButton;
    AlignLeftEdgesBtn: TToolButton;
    SpaceEquallyVerticallyBtn: TToolButton;
    CenterVerticallyInWindowBtn: TToolButton;
    AlignVerticalCentersBtn: TToolButton;
    AlignTopsBtn: TToolButton;
    AlignRightEdgesBtn: TToolButton;
    SpaceEquallyHorizontallyBtn: TToolButton;
    CenterHorizontallyInWindowBtn: TToolButton;
    AlignHorizontalCentersBtn: TToolButton;
    ObjectsPnl: TToolBar;
    SelectObjectBtn: TToolButton;
    DrawLinesBtn: TToolButton;
    InsertPictureBtn: TToolButton;
    InsertBandBtn: TToolButton;
    InsertRectangleObjectBtn: TToolButton;
    InsertSubReportBtn: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoClick(Sender: TObject);
    procedure BackgroundColorBtnClick(Sender: TObject);
    procedure GridBtnClick(Sender: TObject);
    procedure BringToFrontBtnClick(Sender: TObject);
    procedure SendToBackBtnClick(Sender: TObject);
    procedure AddPageBtnClick(Sender: TObject);
    procedure RemovePageBtnClick(Sender: TObject);
    procedure InsertRectangleObjectBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelectObjectBtnClick(Sender: TObject);
    procedure CutBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure PageOptionsBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EDeleteMnuClick(Sender: TObject);
    procedure EEditObjectMnuClick(Sender: TObject);
    procedure GridAlignBtnClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ReportOptionsMnuClick(Sender: TObject);
    procedure FontsCboDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure PreviewBtnClick(Sender: TObject);
    procedure VariablesListMnuClick(Sender: TObject);
    procedure EditPopupPopup(Sender: TObject);
    procedure NewMnuClick(Sender: TObject);
    procedure ToolbarsMnuClick(Sender: TObject);
    procedure StandardMnuClick(Sender: TObject);
    procedure OptionsMnuClick(Sender: TObject);
    procedure AlignLeftEdgesBtnClick(Sender: TObject);
    procedure AlignHorizontalCentersBtnClick(Sender: TObject);
    procedure CenterHorizontallyInWindowBtnClick(Sender: TObject);
    procedure SpaceEquallyHorizontallyBtnClick(Sender: TObject);
    procedure AlignRightEdgesBtnClick(Sender: TObject);
    procedure AlignTopsBtnClick(Sender: TObject);
    procedure AlignVerticalCentersBtnClick(Sender: TObject);
    procedure CenterVerticallyInWindowBtnClick(Sender: TObject);
    procedure SpaceEquallyVerticallyBtnClick(Sender: TObject);
    procedure AlignBottomsBtnClick(Sender: TObject);
    procedure Tab1Change(Sender: TObject);
    procedure AboutMnuClick(Sender: TObject);
    procedure FitToGridBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure PBox1Paint(Sender: TObject);
    procedure HelpContentsMnuClick(Sender: TObject);
    procedure Tab1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure frSpeedButton1Click(Sender: TObject);
    procedure LineStyleBtnClick(Sender: TObject);
    procedure FontsCboClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FrameWidthUpDownChanging(Sender: TObject; var AllowChange: Boolean);
  private
    PageView: TfrDesignerPage;
    InspForm: TfrInspForm;
    EditorForm: TfrMemoEditorForm;
    BPanel, RPanel: TPanel;
    ColorSelector: TColorSelector;
    MenuItems: TList;
    ItemWidths: TStringList;
    FCurPage: Integer;
    FGridSize: Integer;
    FGridShow, FGridAlign: Boolean;
    FUnits: TfrReportUnits;
    FGrayedButtons: Boolean;
    FUndoBuffer, FRedoBuffer: TfrUndoBuffer;
    FUndoBufferLength, FRedoBufferLength: Integer;
    FirstTime: Boolean;
    MaxItemWidth, MaxShortCutWidth: Integer;
    ObjectValues: TFRObjectValues;
    EditAfterInsert: Boolean;
    FCurDocName: string;
    FileModified: Boolean;
    ShapeMode: TfrShapeMode;
    procedure StartEdit;
    procedure StopEdit;
    procedure GetFontList;
    procedure SetMenuBitmaps;
    procedure SetCurPage(Value: Integer);
    procedure SetGridSize(Value: Integer);
    procedure SetGridShow(Value: Boolean);
    procedure SetGridAlign(Value: Boolean);
    procedure SetUnits(Value: TfrReportUnits);
    procedure SetGrayedButtons(Value: Boolean);
    procedure SetCurDocName(Value: string);
    procedure SelectionChanged;
    procedure ShowPosition;
    procedure ShowContent;
    procedure EnableControls;
    procedure ResetSelection;
    procedure DeleteObjects;
    procedure AddPage;
    procedure RemovePage(n: Integer);
    procedure SetPageTitles;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure FillInspFields;
    function RectTypEnabled: Boolean;
    function FontTypEnabled: Boolean;
    function ZEnabled: Boolean;
    function CutEnabled: Boolean;
    function CopyEnabled: Boolean;
    function PasteEnabled: Boolean;
    function DelEnabled: Boolean;
    function EditEnabled: Boolean;
    procedure ColorSelected(Sender: TObject);
    procedure MoveObjects(dx, dy: Integer; Resize: Boolean);
    procedure SelectAll;
    procedure Unselect;
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure SaveState;
    procedure RestoreState;
    procedure ClearBuffer(Buffer: TfrUndoBuffer; var BufferLength: Integer);
    procedure ClearUndoBuffer;
    procedure ClearRedoBuffer;
    procedure Undo(Buffer: PfrUndoBuffer);
    procedure ReleaseAction(ActionRec: TfrUndoRec);
    procedure AddAction(Buffer: PfrUndoBuffer; a: TfrUndoAction; List: TList);
    procedure AddUndoAction(a: TfrUndoAction);
    procedure DoDrawText(Canvas: TCanvas; Caption: string;
      Rect: TRect; Selected, Enabled: Boolean; Flags: Longint);
    procedure MeasureItem(AMenuItem: TMenuItem; ACanvas: TCanvas;
      var AWidth, AHeight: Integer);
    procedure DrawItem(AMenuItem: TMenuItem; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    function FindMenuItem(AMenuItem: TMenuItem): TfrMenuItemInfo;
    procedure SetMenuItemBitmap(AMenuItem: TMenuItem; ABtn: TToolButton);
    procedure FillMenuItems(MenuItem: TMenuItem);
    procedure DeleteMenuItems(MenuItem: TMenuItem);
    procedure GetDefaultSize(var dx, dy: Integer);
    function SelStatus: TfrSelectionStatus;
    function GetFirstSelected: TfrView;
    function GetLeftObject: Integer;
    function GetTopObject: Integer;
    function GetBottomObject: Integer;
    function GetRightObject: Integer;
    function GetUnusedBand: TfrBandType;
    procedure SendBandsToDown;
    function TopSelected: Integer;
    procedure GetRegion;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RegisterObject(vImageIndex: Integer; vImageList:TImageList; const ButtonHint: string; ButtonTag: Integer); override;
    procedure BeforeChange; override;
    procedure AfterChange; override;
    procedure ShowMemoEditor; override;
    procedure ShowEditor; override;
    procedure RedrawPage; override;
    function CheckBand(Band: TfrBandType): Boolean; override;
    procedure OnModify(Item: Integer; var EditText: string);
    function PointsToUnits(x: Integer): Double;
    function UnitsToPoints(x: Double): Integer;
    property CurDocName: string read FCurDocName write SetCurDocName;
    property CurPage: Integer read FCurPage write SetCurPage;
    property GridSize: Integer read FGridSize write SetGridSize;
    property ShowGrid: Boolean read FGridShow write SetGridShow;
    property GridAlign: Boolean read FGridAlign write SetGridAlign;
    property Units: TfrReportUnits read FUnits write SetUnits;
    property GrayedButtons: Boolean read FGrayedButtons write SetGrayedButtons;
  end;

var
  frTemplateDir: string;

procedure InitProc;
procedure FinalProc;

implementation

{$R *.DFM}
{$R *.RES}

uses
  FR_PageOptions, FR_PictureEditor, FR_Template, FR_NewReport, FR_DesignOptions, FR_Consts,
  FR_Printer, FR_Hilit, FR_Fields, FR_DocOptions, FR_VariableEditor, FR_BandEditor, FR_BandsEditor,
  FR_BandType, FR_Utils, FR_GroupBandEditor, FR_About, FR_InsertFields, FR_Parser, FR_DBDataset,
  Registry, DB;

type
  THackView = class(TfrView)
  end;

procedure frSetGlyph(frDesigner:TfrDesignerForm; Color: TColor; sb: TSpeedButton; n: Integer);
var
  b: TBitmap;
  r: TRect;
  i, j: Integer;
begin
  b := TBitmap.Create;
  b.Width := 32;
  b.Height := 16;
  with b.Canvas do
  begin
    r := Rect(n * 32, 0, n * 32 + 32, 16);
    CopyRect(Rect(0, 0, 32, 16), frDesigner.Image1.Picture.Bitmap.Canvas, r);
    for i := 0 to 32 do
      for j := 0 to 16 do
        if Pixels[i, j] = clRed then
          Pixels[i, j] := Color;
    if Color = clNone then
      for i := 1 to 14 do
        Pixels[i, 13] := clBtnFace;
  end;
  sb.Glyph.Assign(b);
  sb.NumGlyphs := 2;
  b.Free;
end;

procedure ClearClipBoard; forward;

var
  FirstSelected: TfrView;
  SelNum: Integer; // number of objects currently selected
  MRFlag, // several objects was selected
    ObjRepeat, // was pressed Shift + Insert Object
    WasOk: Boolean; // was Ok pressed in dialog
  OldRect, OldRect1: TRect; // object rect after mouse was clicked
  Busy: Boolean; // busy flag. need!
  ShowSizes: Boolean;
  LastFontName: string;
  LastFontSize, LastAdjust: Integer;
  LastFrameWidth, LastLineWidth: Single;
  LastFrameType, LastFontStyle: Word;
  LastFrameColor, LastFillColor, LastFontColor: TColor;
  ClrButton: TSpeedButton;
  FirstChange: Boolean;
  ClipRgn: HRGN;

// globals
  ClipBd: TList; // clipboard
  GridBitmap: TBitmap; // for drawing grid in design time


{----------------------------------------------------------------------------}

procedure TfrDesigner.Loaded;
begin
  inherited Loaded;
  frTemplateDir := TemplateDir;
end;

{--------------------------------------------------}

constructor TfrDesignerPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Color := clWhite;
  BorderStyle := bsNone;
  OnMouseDown := MDown;
  OnMouseUp := MUp;
  OnMouseMove := MMove;
  OnDblClick := DClick;
end;

procedure TfrDesignerPage.Init;
begin
  Down := False; DFlag := False; RFlag := False;
  Cursor := crDefault; CT := ctNone;
end;

procedure TfrDesignerPage.SetPage;
var
  Pgw, Pgh: Integer;
begin
  Pgw := FDesigner.Page.PrnInfo.Pgw;
  Pgh := FDesigner.Page.PrnInfo.Pgh;
  if Pgw > Parent.Width then
    SetBounds(10, 10, Pgw, Pgh) else
    SetBounds((Parent.Width - Pgw) div 2, 10, Pgw, Pgh);
  FDesigner.BPanel.Top := Top + Height + 10;
  FDesigner.RPanel.Left := Left + Width + 10;
end;

procedure TfrDesignerPage.Paint;
begin
  Draw(10000, 0);
end;

procedure TfrDesignerPage.NormalizeCoord(t: TfrView);
begin
  if t.dx < 0 then
  begin
    t.dx := -t.dx;
    t.x := t.x - t.dx;
  end;
  if t.dy < 0 then
  begin
    t.dy := -t.dy;
    t.y := t.y - t.dy;
  end;
end;

procedure TfrDesignerPage.NormalizeRect(var r: TRect);
var
  i: Integer;
begin
  with r do
  begin
    if Left > Right then begin i := Left; Left := Right; Right := i end;
    if Top > Bottom then begin i := Top; Top := Bottom; Bottom := i end;
  end;
end;

procedure TfrDesignerPage.DrawHSplitter(Rect: TRect);
begin
  with Canvas do
  begin
    Pen.Mode := pmXor;
    Pen.Color := clSilver;
    Pen.Width := 1;
    MoveTo(Rect.Left, Rect.Top);
    LineTo(Rect.Right, Rect.Bottom);
    Pen.Mode := pmCopy;
  end;
end;

procedure TfrDesignerPage.DrawRectLine(Rect: TRect);
begin
  with Canvas do
  begin
    Pen.Mode := pmNot;
    Pen.Style := psSolid;
    Pen.Width := Round(LastLineWidth);
    with Rect do
      if Abs(Right - Left) > Abs(Bottom - Top) then
      begin
        MoveTo(Left, Top);
        LineTo(Right, Top);
      end
      else
      begin
        MoveTo(Left, Top);
        LineTo(Left, Bottom);
      end;
    Pen.Mode := pmCopy;
  end;
end;

procedure TfrDesignerPage.DrawFocusRect(Rect: TRect);
begin
  with Canvas do
  begin
    Pen.Mode := pmXor;
    Pen.Color := clSilver;
    Pen.Width := 1;
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    if (Rect.Right = Rect.Left + 1) or (Rect.Bottom = Rect.Top + 1) then
    begin
      if Rect.Right = Rect.Left + 1 then
        Dec(Rect.Right, 1) else
        Dec(Rect.Bottom, 1);
      MoveTo(Rect.Left, Rect.Top);
      LineTo(Rect.Right, Rect.Bottom);
    end
    else
      Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
  end;
end;

procedure TfrDesignerPage.DrawSelection(t: TfrView);
var
  px, py: Word;
  procedure DrawPoint(x, y: Word);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x, y);
  end;
begin
  if t.Selected then
    with t, Canvas do
    begin
      Pen.Width := 5;
      Pen.Mode := pmXor;
      Pen.Color := clWhite;
      px := x + dx div 2;
      py := y + dy div 2;
      DrawPoint(x, y); DrawPoint(x + dx, y);
      DrawPoint(x, y + dy);
      if FDesigner.Page.Objects.IndexOf(t) = RightBottom then
        Pen.Color := clTeal;
      DrawPoint(x + dx, y + dy);
      Pen.Color := clWhite;
      if SelNum = 1 then
      begin
        DrawPoint(px, y); DrawPoint(px, y + dy);
        DrawPoint(x, py); DrawPoint(x + dx, py);
      end;
      Pen.Mode := pmCopy;
    end;
end;

procedure TfrDesignerPage.DrawShape(t: TfrView);
begin
  if t.Selected then
    with t do
      DrawFocusRect(Rect(x, y, x + dx + 1, y + dy + 1))
end;

procedure TfrDesignerPage.Draw(N: Integer; ClipRgn: HRGN);
var
  i: Integer;
  t: TfrView;
  R, R1: HRGN;
  Objects: TList;
  procedure DrawBackground;
  var
    i, j: Integer;
  begin
    with Canvas do
    begin
      if FDesigner.ShowGrid and (FDesigner.GridSize <> 18) then
      begin
        with GridBitmap.Canvas do
        begin
          Brush.Color := clWhite;
          FillRect(Rect(0, 0, 8, 8));
          Pixels[0, 0] := clBlack;
          if FDesigner.GridSize = 4 then
          begin
            Pixels[4, 0] := clBlack;
            Pixels[0, 4] := clBlack;
            Pixels[4, 4] := clBlack;
          end;
        end;
        Brush.Bitmap := GridBitmap;
      end
      else
      begin
        Brush.Color := clWhite;
        Brush.Style := bsSolid;
      end;
      FillRgn(Handle, R, Brush.Handle);
      if FDesigner.ShowGrid and (FDesigner.GridSize = 18) then
      begin
        i := 0;
        while i < Width do
        begin
          j := 0;
          while j < Height do
          begin
            if RectVisible(Handle, Rect(i, j, i + 1, j + 1)) then
              SetPixel(Handle, i, j, clBlack);
            Inc(j, FDesigner.GridSize);
          end;
          Inc(i, FDesigner.GridSize);
        end;
      end;
      Brush.Style := bsClear;
      Pen.Width := 1;
      Pen.Color := clGray;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
      with FDesigner.Page do
      begin
        if UseMargins then
          Rectangle(LeftMargin, TopMargin, RightMargin, BottomMargin);
        if ColCount > 1 then
        begin
          ColWidth := (RightMargin - LeftMargin) div ColCount;
          Pen.Style := psDot;
          j := LeftMargin;
          for i := 1 to ColCount do
          begin
            Rectangle(j, -1, j + ColWidth + 1, PrnInfo.Pgh + 1);
            Inc(j, ColWidth + ColGap);
          end;
          Pen.Style := psSolid;
        end;
      end;
    end;
  end;
  function IsVisible(t: TfrView): Boolean;
  var
    R: HRGN;
  begin
    R := t.GetClipRgn(rtNormal);
    Result := CombineRgn(R, R, ClipRgn, RGN_AND) <> NULLREGION;
    DeleteObject(R);
  end;

begin
  if FDesigner.Page = nil then
    Exit;
  FDesigner.Report.DocMode := dmDesigning;
  Objects := FDesigner.Page.Objects;
  if ClipRgn = 0 then
    with Canvas.ClipRect do
      ClipRgn := CreateRectRgn(Left, Top, Right, Bottom);
  R := CreateRectRgn(0, 0, Width, Height);
  for i := Objects.Count - 1 downto 0 do
  begin
    t := Objects[i];
    if i <= N then
      if t.Selected then
        t.Draw(Canvas)
      else if IsVisible(t) then
      begin
        R1 := CreateRectRgn(0, 0, 1, 1);
        CombineRgn(R1, ClipRgn, R, RGN_AND);
        SelectClipRgn(Canvas.Handle, R1);
        DeleteObject(R1);
        t.Draw(Canvas);
      end;
    R1 := t.GetClipRgn(rtNormal);
    CombineRgn(R, R, R1, RGN_DIFF);
    DeleteObject(R1);
    SelectClipRgn(Canvas.Handle, R);
  end;
  CombineRgn(R, R, ClipRgn, RGN_AND);
  DrawBackground;

  DeleteObject(R);
  DeleteObject(ClipRgn);
  SelectClipRgn(Canvas.Handle, 0);
  if not Down then
    DrawPage(dmSelection);
end;

procedure TfrDesignerPage.DrawPage(DrawMode: TfrDesignerDrawMode);
var
  i: Integer;
  t: TfrView;
begin
  if FDesigner.Report.DocMode <> dmDesigning then Exit;
  for i := 0 to FDesigner.Page.Objects.Count - 1 do
  begin
    t := FDesigner.Page.Objects[i];
    case DrawMode of
      dmAll: t.Draw(Canvas);
      dmSelection: DrawSelection(t);
      dmShape: DrawShape(t);
    end;
  end;
end;

function TfrDesignerPage.FindNearestEdge(var x, y: Integer): Boolean;
var
  i: Integer;
  t: TfrView;
  min: Double;
  p: TPoint;
  function DoMin(a: array of TPoint): Boolean;
  var
    i: Integer;
    d: Double;
  begin
    Result := False;
    for i := Low(a) to High(a) do
    begin
      d := sqrt((x - a[i].x) * (x - a[i].x) + (y - a[i].y) * (y - a[i].y));
      if d < min then
      begin
        min := d;
        p := a[i];
        Result := True;
      end;
    end;
  end;
begin
  Result := False;
  min := FDesigner.GridSize;
  p := Point(x, y);
  for i := 0 to FDesigner.Page.Objects.Count - 1 do
  begin
    t := FDesigner.Page.Objects[i];
    if DoMin([Point(t.x, t.y), Point(t.x + t.dx, t.y),
      Point(t.x + t.dx, t.y + t.dy), Point(t.x, t.y + t.dy)]) then
      Result := True;
  end;
  x := p.x; y := p.y;
end;

procedure TfrDesignerPage.RoundCoord(var x, y: Integer);
begin
  with FDesigner do
    if GridAlign then
    begin
      x := x div GridSize * GridSize;
      y := y div GridSize * GridSize;
    end;
end;

procedure TfrDesignerPage.GetMultipleSelected;
var
  i, j, k: Integer;
  t: TfrView;
begin
  j := 0; k := 0;
  LeftTop := Point(10000, 10000);
  RightBottom := -1;
  MRFlag := False;
  if SelNum > 1 then {find right-bottom element}
  begin
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
    begin
      t := FDesigner.Page.Objects[i];
      if t.Selected then
      begin
        t.OriginalRect := Rect(t.x, t.y, t.dx, t.dy);
        if (t.x + t.dx > j) or ((t.x + t.dx = j) and (t.y + t.dy > k)) then
        begin
          j := t.x + t.dx;
          k := t.y + t.dy;
          RightBottom := i;
        end;
        if t.x < LeftTop.x then LeftTop.x := t.x;
        if t.y < LeftTop.y then LeftTop.y := t.y;
      end;
    end;
    t := FDesigner.Page.Objects[RightBottom];
    OldRect := Rect(LeftTop.x, LeftTop.y, t.x + t.dx, t.y + t.dy);
    OldRect1 := OldRect;
    MRFlag := True;
  end;
end;

procedure TfrDesignerPage.MDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  f, DontChange, v: Boolean;
  t: TfrView;
  Rgn: HRGN;
  p: TPoint;
begin
  if DFlag then
  begin
    DFlag := False;
    Exit;
  end;
  if (Button = mbRight) and Down and RFlag then
    DrawFocusRect(OldRect);
  RFlag := False;
  DrawPage(dmSelection);
  Down := True;
  DontChange := False;
  if Button = mbLeft then
    if (ssCtrl in Shift) or (Cursor = crCross) then
    begin
      RFlag := True;
      if Cursor = crCross then
      begin
        DrawFocusRect(OldRect);
        RoundCoord(x, y);
        OldRect1 := OldRect;
      end;
      OldRect := Rect(x, y, x, y);
      FDesigner.Unselect;
      SelNum := 0;
      RightBottom := -1;
      MRFlag := False;
      FirstSelected := nil;
      Exit;
    end
    else if Cursor = crPencil then
    begin
      with FDesigner do
        if GridAlign then
          if not FindNearestEdge(x, y) then
          begin
            x := Round(x / GridSize) * GridSize;
            y := Round(y / GridSize) * GridSize;
          end;
      OldRect := Rect(x, y, x, y);
      FDesigner.Unselect;
      SelNum := 0;
      RightBottom := -1;
      MRFlag := False;
      FirstSelected := nil;
      LastX := x;
      LastY := y;
      Exit;
    end;
  if Cursor = crDefault then
  begin
    f := False;
    for i := FDesigner.Page.Objects.Count - 1 downto 0 do
    begin
      t := FDesigner.Page.Objects[i];
      Rgn := t.GetClipRgn(rtNormal);
      v := PtInRegion(Rgn, X, Y);
      DeleteObject(Rgn);
      if v then
      begin
        if ssShift in Shift then
        begin
          t.Selected := not t.Selected;
          if t.Selected then Inc(SelNum) else Dec(SelNum);
        end
        else
        begin
          if not t.Selected then
          begin
            FDesigner.Unselect;
            SelNum := 1;
            t.Selected := True;
          end
          else DontChange := True;
        end;
        if SelNum = 0 then FirstSelected := nil
        else if SelNum = 1 then FirstSelected := t
        else if FirstSelected <> nil then
          if not FirstSelected.Selected then FirstSelected := nil;
        f := True;
        break;
      end;
    end;
    if not f then
    begin
      FDesigner.Unselect;
      SelNum := 0;
      FirstSelected := nil;
      if Button = mbLeft then
      begin
        RFlag := True;
        OldRect := Rect(x, y, x, y);
        Exit;
      end;
    end;
    GetMultipleSelected;
    if not DontChange then FDesigner.SelectionChanged;
  end;
  if SelNum = 0 then
  begin // reset multiple selection
    RightBottom := -1;
    MRFlag := False;
  end;
  LastX := x;
  LastY := y;
  Moved := False;
  FirstChange := True;
  FirstBandMove := True;
  if Button = mbRight then
  begin
    DrawPage(dmSelection);
    Down := False;
    GetCursorPos(p);
    FDesigner.EditPopupPopup(nil);
    TrackPopupMenu(FDesigner.EditPopup.Handle,
      TPM_LEFTALIGN or TPM_RIGHTBUTTON, p.X, p.Y, 0, FDesigner.Handle, nil);
  end
  else if FDesigner.ShapeMode = smFrame then
    DrawPage(dmShape);
end;

procedure TfrDesignerPage.MUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  frBandTypesForm: TfrBandTypesForm;
  i, k, dx, dy: Integer;
  t: TfrView;
  ObjectInserted: Boolean;
  procedure AddObject(ot: Byte);
  begin
    FDesigner.Page.Objects.Add(frCreateObject(FDesigner.Report, ot, ''));
    t := FDesigner.Page.Objects.Last as TfrView;
  end;
  procedure CreateSection;
  var
    s: string;
  begin
    frBandTypesForm := TfrBandTypesForm.Create(FDesigner);
    ObjectInserted := frBandTypesForm.ShowModal = mrOk;
    if ObjectInserted then
    begin
      FDesigner.Page.Objects.Add(TfrBandView.Create(FDesigner.Report));
      t := FDesigner.Page.Objects.Last as TfrView;
      (t as TfrBandView).BandType := frBandTypesForm.SelectedType;
      s := frBandNames[Integer(frBandTypesForm.SelectedType)];
      if Pos(' ', s) <> 0 then
      begin
        s[Pos(' ', s) + 1] := UpCase(s[Pos(' ', s) + 1]);
        Delete(s, Pos(' ', s), 1);
      end;
      THackView(t).BaseName := s;
      FDesigner.SendBandsToDown;
    end;
    frBandTypesForm.Free;
  end;

  procedure CreateSubReport;
  begin
    FDesigner.Page.Objects.Add(TfrSubReportView.Create(FDesigner.Report));
    t := FDesigner.Page.Objects.Last as TfrView;
    (t as TfrSubReportView).SubPage := FDesigner.Report.Pages.Count;
    FDesigner.Report.Pages.Add;
  end;

begin
  if Button <> mbLeft then Exit;
  Down := False;
  if FDesigner.ShapeMode = smFrame then
    DrawPage(dmShape);
// inserting a new object
  if Cursor = crCross then
  begin
    Mode := mdSelect;
    DrawFocusRect(OldRect);
    if (OldRect.Left = OldRect.Right) and (OldRect.Top = OldRect.Bottom) then
      OldRect := OldRect1;
    NormalizeRect(OldRect);
    RFlag := False;
    ObjectInserted := True;
    with FDesigner.ObjectsPnl do
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TToolButton then
          with Controls[i] as TToolButton do
            if Down then
            begin
              if Tag = gtBand then
                if FDesigner.GetUnusedBand <> btNone then
                  CreateSection
                else
                  Exit
              else if Tag = gtSubReport then
                CreateSubReport
              else if Tag >= gtAddIn then
              begin
                k := Tag - gtAddIn;
                FDesigner.Page.Objects.Add(frCreateObject(FDesigner.Report, gtAddIn, frAddIns[k].ClassRef.ClassName));
                t := FDesigner.Page.Objects.Last as TfrView;
              end
              else
                AddObject(Tag);
              break;
            end;
    if ObjectInserted then
    begin
      t.CreateUniqueName;
      with OldRect do
        if (Left = Right) or (Top = Bottom) then
        begin
          dx := 40; dy := 40;
          if t is TfrMemoView then
            FDesigner.GetDefaultSize(dx, dy);
          OldRect := Rect(Left, Top, Left + dx, Top + dy);
        end;
      FDesigner.Unselect;
      t.x := OldRect.Left; t.y := OldRect.Top;
      t.dx := OldRect.Right - OldRect.Left; t.dy := OldRect.Bottom - OldRect.Top;
      if (t is TfrBandView) and
        (TfrBandType(t.FrameType) in [btCrossHeader..btCrossFooter]) and
        (t.dx > Width - 10) then
        t.dx := 40;
      t.FrameWidth := LastFrameWidth;
      t.FrameColor := LastFrameColor;
      t.FillColor := LastFillColor;
      t.Selected := True;
      if t.Typ <> gtBand then
        t.FrameType := LastFrameType;
      if t is TfrMemoView then
        with t as TfrMemoView do
        begin
          Font.Name := LastFontName;
          Font.Size := LastFontSize;
          Font.Color := LastFontColor;
          Font.Style := frSetFontStyle(LastFontStyle);
          Adjust := LastAdjust;
        end;
      SelNum := 1;
      if t.Typ = gtBand then
        Draw(10000, t.GetClipRgn(rtExtended))
      else
      begin
        t.Draw(Canvas);
        DrawSelection(t);
      end;
      with FDesigner do
      begin
        SelectionChanged;
        AddUndoAction(acInsert);
        if EditAfterInsert then
          ShowEditor;
      end;
    end;
    if not ObjRepeat then
      FDesigner.SelectObjectBtn.Down := True
    else
      DrawFocusRect(OldRect);
    Exit;
  end;
// line drawing
  if Cursor = crPencil then
  begin
    DrawRectLine(OldRect);
    AddObject(gtLine);
    t.CreateUniqueName;
    t.x := OldRect.Left; t.y := OldRect.Top;
    t.dx := OldRect.Right - OldRect.Left; t.dy := OldRect.Bottom - OldRect.Top;
    if t.dx < 0 then
    begin
      t.dx := -t.dx; if Abs(t.dx) > Abs(t.dy) then t.x := OldRect.Right;
    end;
    if t.dy < 0 then
    begin
      t.dy := -t.dy; if Abs(t.dy) > Abs(t.dx) then t.y := OldRect.Bottom;
    end;
    t.Selected := True;
    t.FrameWidth := LastLineWidth;
    t.FrameColor := LastFrameColor;
    SelNum := 1;
    t.Draw(Canvas);
    DrawSelection(t);
    FDesigner.SelectionChanged;
    FDesigner.AddUndoAction(acInsert);
    Exit;
  end;

// calculating which objects contains in frame (if user select it with mouse+Ctrl key)
  if RFlag then
  begin
    DrawFocusRect(OldRect);
    RFlag := False;
    NormalizeRect(OldRect);
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
    begin
      t := FDesigner.Page.Objects[i];
      with OldRect do
        if t.Typ <> gtBand then
          if not ((t.x > Right) or (t.x + t.dx < Left) or
            (t.y > Bottom) or (t.y + t.dy < Top)) then
          begin
            t.Selected := True;
            Inc(SelNum);
          end;
    end;
    GetMultipleSelected;
    FDesigner.SelectionChanged;
    DrawPage(dmSelection);
    Exit;
  end;
// splitting
  if Moved and MRFlag and (Cursor = crHSplit) then
  begin
    with SplitInfo do
    begin
      dx := SplRect.Left - SplX;
      if (View1.dx + dx > 0) and (View2.dx - dx > 0) then
      begin
        Inc(View1.dx, dx);
        Inc(View2.x, dx);
        Dec(View2.dx, dx);
      end;
    end;
    GetMultipleSelected;
    Draw(FDesigner.TopSelected, ClipRgn);
    Exit;
  end;
// resizing several objects
  if Moved and MRFlag and (Cursor <> crDefault) then
  begin
    Draw(FDesigner.TopSelected, ClipRgn);
    Exit;
  end;
// redrawing all moved or resized objects
  if not Moved then DrawPage(dmSelection);
  if (SelNum >= 1) and Moved then
    if SelNum > 1 then
    begin
      Draw(FDesigner.TopSelected, ClipRgn);
      GetMultipleSelected;
      FDesigner.ShowPosition;
    end
    else
    begin
      t := FDesigner.Page.Objects[FDesigner.TopSelected];
      NormalizeCoord(t);
      if Cursor <> crDefault then t.Resized;
      Draw(FDesigner.TopSelected, ClipRgn);
      FDesigner.ShowPosition;
    end;
  Moved := False;
  CT := ctNone;
end;

procedure TfrDesignerPage.MMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, j, kx, ky, w, dx, dy: Integer;
  t, t1, Bnd: TfrView;
  nx, ny, x1, x2, y1, y2: Double;
  hr, hr1: HRGN;

  function Cont(px, py, x, y: Integer): Boolean;
  begin
    Result := (x >= px - w) and (x <= px + w + 1) and
      (y >= py - w) and (y <= py + w + 1);
  end;
  function GridCheck: Boolean;
  begin
    with FDesigner do
    begin
      Result := (kx >= GridSize) or (kx <= -GridSize) or
        (ky >= GridSize) or (ky <= -GridSize);
      if Result then
      begin
        kx := kx - kx mod GridSize;
        ky := ky - ky mod GridSize;
      end;
    end;
  end;

  procedure AddRgn(var HR: HRGN; T: TfrView);
  var
    tr: HRGN;
  begin
    tr := t.GetClipRgn(rtExtended);
    CombineRgn(HR, HR, TR, RGN_OR);
    DeleteObject(TR);
  end;


begin
  Moved := True;
  w := 2;
  if FirstChange and Down and not RFlag then
  begin
    kx := x - LastX;
    ky := y - LastY;
    if not FDesigner.GridAlign or GridCheck then
    begin
      FDesigner.GetRegion;
      FDesigner.AddUndoAction(acEdit);
    end;
  end;

  if not Down then
    if FDesigner.DrawLinesBtn.Down then
    begin
      Mode := mdSelect;
      Cursor := crPencil;
    end
    else if FDesigner.SelectObjectBtn.Down then
    begin
      Mode := mdSelect;
      Cursor := crDefault;
    end
    else
    begin
      Mode := mdInsert;
      if Cursor <> crCross then
      begin
        RoundCoord(x, y);
        kx := Width; ky := 40;
        if not FDesigner.InsertBandBtn.Down then
          FDesigner.GetDefaultSize(kx, ky);
        OldRect := Rect(x, y, x + kx, y + ky);
        DrawFocusRect(OldRect);
      end;
      Cursor := crCross;
    end;
  if (Mode = mdInsert) and not Down then
  begin
    DrawFocusRect(OldRect);
    RoundCoord(x, y);
    OffsetRect(OldRect, x - OldRect.Left, y - OldRect.Top);
    DrawFocusRect(OldRect);
    ShowSizes := True;
    FDesigner.PBox1Paint(nil);
    ShowSizes := False;
    Exit;
  end;

 // cursor shapes
  if not Down and (SelNum = 1) and (Mode = mdSelect) and
    not FDesigner.DrawLinesBtn.Down then
  begin
    t := FDesigner.Page.Objects[FDesigner.TopSelected];
    if Cont(t.x, t.y, x, y) or Cont(t.x + t.dx, t.y + t.dy, x, y) then
      Cursor := crSizeNWSE
    else if Cont(t.x + t.dx, t.y, x, y) or Cont(t.x, t.y + t.dy, x, y) then
      Cursor := crSizeNESW
    else if Cont(t.x + t.dx div 2, t.y, x, y) or Cont(t.x + t.dx div 2, t.y + t.dy, x, y) then
      Cursor := crSizeNS
    else if Cont(t.x, t.y + t.dy div 2, x, y) or Cont(t.x + t.dx, t.y + t.dy div 2, x, y) then
      Cursor := crSizeWE
    else
      Cursor := crDefault;
  end;
  // selecting a lot of objects
  if Down and RFlag then
  begin
    DrawFocusRect(OldRect);
    if Cursor = crCross then
      RoundCoord(x, y);
    OldRect := Rect(OldRect.Left, OldRect.Top, x, y);
    DrawFocusRect(OldRect);
    ShowSizes := True;
    if Cursor = crCross then
      FDesigner.PBox1Paint(nil);
    ShowSizes := False;
    Exit;
  end;
  // line drawing
  if Down and (Cursor = crPencil) then
  begin
    kx := x - LastX;
    ky := y - LastY;
    if FDesigner.GridAlign and not GridCheck then Exit;
    DrawRectLine(OldRect);
    OldRect := Rect(OldRect.Left, OldRect.Top, OldRect.Right + kx, OldRect.Bottom + ky);
    DrawRectLine(OldRect);
    Inc(LastX, kx);
    Inc(LastY, ky);
    Exit;
  end;
  // check for multiple selected objects - right-bottom corner
  if not Down and (SelNum > 1) and (Mode = mdSelect) then
  begin
    t := FDesigner.Page.Objects[RightBottom];
    if Cont(t.x + t.dx, t.y + t.dy, x, y) then
      Cursor := crSizeNWSE
  end;
  // split checking
  if not Down and (SelNum > 1) and (Mode = mdSelect) then
  begin
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
    begin
      t := FDesigner.Page.Objects[i];
      if (t.Typ <> gtBand) and t.Selected then
        if (x >= t.x) and (x <= t.x + t.dx) and (y >= t.y) and (y <= t.y + t.dy) then
        begin
          for j := 0 to FDesigner.Page.Objects.Count - 1 do
          begin
            t1 := FDesigner.Page.Objects[j];
            if (t1.Typ <> gtBand) and (t1 <> t) and t1.Selected then
              if ((t.x = t1.x + t1.dx) and ((x >= t.x) and (x <= t.x + 2))) or
                ((t1.x = t.x + t.dx) and ((x >= t1.x - 2) and (x <= t.x))) then
              begin
                Cursor := crHSplit;
                with SplitInfo do
                begin
                  SplRect := Rect(x, t.y, x, t.y + t.dy);
                  if t.x = t1.x + t1.dx then
                  begin
                    SplX := t.x;
                    View1 := t1;
                    View2 := t;
                  end
                  else
                  begin
                    SplX := t1.x;
                    View1 := t;
                    View2 := t1;
                  end;
                  SplRect.Left := SplX;
                  SplRect.Right := SplX;
                end;
              end;
          end;
        end;
    end;
  end;
  // splitting
  if Down and MRFlag and (Mode = mdSelect) and (Cursor = crHSplit) then
  begin
    kx := x - LastX;
    ky := 0;
    if FDesigner.GridAlign and not GridCheck then Exit;
    with SplitInfo do
    begin
      DrawHSplitter(SplRect);
      SplRect := Rect(SplRect.Left + kx, SplRect.Top, SplRect.Right + kx, SplRect.Bottom);
      DrawHSplitter(SplRect);
    end;
    Inc(LastX, kx);
    Exit;
  end;
  // sizing several objects
  if Down and MRFlag and (Mode = mdSelect) and (Cursor <> crDefault) then
  begin
    kx := x - LastX;
    ky := y - LastY;
    if FDesigner.GridAlign and not GridCheck then Exit;

    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape)
    else
    begin
      hr := CreateRectRgn(0, 0, 0, 0);
      hr1 := CreateRectRgn(0, 0, 0, 0);
    end;
    OldRect := Rect(OldRect.Left, OldRect.Top, OldRect.Right + kx, OldRect.Bottom + ky);
    nx := (OldRect.Right - OldRect.Left) / (OldRect1.Right - OldRect1.Left);
    ny := (OldRect.Bottom - OldRect.Top) / (OldRect1.Bottom - OldRect1.Top);
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
    begin
      t := FDesigner.Page.Objects[i];
      if t.Selected then
      begin
        if FDesigner.ShapeMode = smAll then
          AddRgn(hr, t);
        x1 := (t.OriginalRect.Left - LeftTop.x) * nx;
        x2 := t.OriginalRect.Right * nx;
        dx := Round(x1 + x2) - (Round(x1) + Round(x2));
        t.x := LeftTop.x + Round(x1); t.dx := Round(x2) + dx;

        y1 := (t.OriginalRect.Top - LeftTop.y) * ny;
        y2 := t.OriginalRect.Bottom * ny;
        dy := Round(y1 + y2) - (Round(y1) + Round(y2));
        t.y := LeftTop.y + Round(y1); t.dy := Round(y2) + dy;
        if FDesigner.ShapeMode = smAll then
          AddRgn(hr1, t);
      end;
    end;
    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape)
    else
    begin
      Draw(10000, hr);
      Draw(10000, hr1);
    end;
    Inc(LastX, kx);
    Inc(LastY, ky);
    FDesigner.PBox1Paint(nil);
    Exit;
  end;
  // moving
  if Down and (Mode = mdSelect) and (SelNum >= 1) and (Cursor = crDefault) then
  begin
    kx := x - LastX;
    ky := y - LastY;
    if FDesigner.GridAlign and not GridCheck then Exit;
    if FirstBandMove and (SelNum = 1) and ((kx <> 0) or (ky <> 0)) and
      not (ssAlt in Shift) then
      if TfrView(FDesigner.Page.Objects[FDesigner.TopSelected]).Typ = gtBand then
      begin
        Bnd := FDesigner.Page.Objects[FDesigner.TopSelected];
        for i := 0 to FDesigner.Page.Objects.Count - 1 do
        begin
          t := FDesigner.Page.Objects[i];
          if t.Typ <> gtBand then
            if (t.x >= Bnd.x) and (t.x + t.dx <= Bnd.x + Bnd.dx) and
              (t.y >= Bnd.y) and (t.y + t.dy <= Bnd.y + Bnd.dy) then
            begin
              t.Selected := True;
              Inc(SelNum);
            end;
        end;
        FDesigner.SelectionChanged;
        GetMultipleSelected;
      end;
    FirstBandMove := False;
    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape)
    else
    begin
      hr := CreateRectRgn(0, 0, 0, 0);
      hr1 := CreateRectRgn(0, 0, 0, 0);
    end;
    for i := 0 to FDesigner.Page.Objects.Count - 1 do
    begin
      t := FDesigner.Page.Objects[i];
      if not t.Selected then continue;
      if FDesigner.ShapeMode = smAll then
        AddRgn(hr, t);
      t.x := t.x + kx;
      t.y := t.y + ky;
      if FDesigner.ShapeMode = smAll then
        AddRgn(hr1, t);
    end;
    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape)
    else
    begin
      CombineRgn(hr, hr, hr1, RGN_OR);
      DeleteObject(hr1);
      Draw(10000, hr);
    end;
    Inc(LastX, kx);
    Inc(LastY, ky);
    FDesigner.PBox1Paint(nil);
  end;
 // resizing
  if Down and (Mode = mdSelect) and (SelNum = 1) and (Cursor <> crDefault) then
  begin
    kx := x - LastX;
    ky := y - LastY;
    if FDesigner.GridAlign and not GridCheck then Exit;
    t := FDesigner.Page.Objects[FDesigner.TopSelected];
    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape) else
      hr := t.GetClipRgn(rtExtended);
    w := 3;
    if Cursor = crSizeNWSE then
      if (CT <> ct2) and ((CT = ct1) or Cont(t.x, t.y, LastX, LastY)) then
      begin
        t.x := t.x + kx;
        t.dx := t.dx - kx;
        t.y := t.y + ky;
        t.dy := t.dy - ky;
        CT := ct1;
      end
      else
      begin
        t.dx := t.dx + kx;
        t.dy := t.dy + ky;
        CT := ct2;
      end;
    if Cursor = crSizeNESW then
      if (CT <> ct4) and ((CT = ct3) or Cont(t.x + t.dx, t.y, LastX, LastY)) then
      begin
        t.y := t.y + ky;
        t.dx := t.dx + kx;
        t.dy := t.dy - ky;
        CT := ct3;
      end
      else
      begin
        t.x := t.x + kx;
        t.dx := t.dx - kx;
        t.dy := t.dy + ky;
        CT := ct4;
      end;
    if Cursor = crSizeWE then
      if (CT <> ct6) and ((CT = ct5) or Cont(t.x, t.y + t.dy div 2, LastX, LastY)) then
      begin
        t.x := t.x + kx;
        t.dx := t.dx - kx;
        CT := ct5;
      end
      else
      begin
        t.dx := t.dx + kx;
        CT := ct6;
      end;
    if Cursor = crSizeNS then
      if (CT <> ct8) and ((CT = ct7) or Cont(t.x + t.dx div 2, t.y, LastX, LastY)) then
      begin
        t.y := t.y + ky;
        t.dy := t.dy - ky;
        CT := ct7;
      end
      else
      begin
        t.dy := t.dy + ky;
        CT := ct8;
      end;
    if FDesigner.ShapeMode = smFrame then
      DrawPage(dmShape)
    else
    begin
      CombineRgn(hr, hr, t.GetClipRgn(rtExtended), RGN_OR);
      Draw(10000, hr);
    end;
    Inc(LastX, kx);
    Inc(LastY, ky);
    FDesigner.PBox1Paint(nil);
  end;
end;

procedure TfrDesignerPage.DClick(Sender: TObject);
begin
  Down := False;
  if SelNum = 0 then
  begin
    FDesigner.PageOptionsBtnClick(nil);
    DFlag := True;
  end
  else if SelNum = 1 then
  begin
    DFlag := True;
    FDesigner.ShowEditor;
  end
  else Exit;
end;

procedure TfrDesignerPage.CMMouseLeave(var Message: TMessage);
begin
  if (Mode = mdInsert) and not Down then
  begin
    DrawFocusRect(OldRect);
    OffsetRect(OldRect, -10000, -10000);
  end;
end;

{-----------------------------------------------------------------------------}

procedure BDown(SB: TToolButton);
begin
  SB.Down := True;
end;

procedure BUp(SB: TToolButton);
begin
  SB.Down := False;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  (TObject(Data) as TStringList).AddObject(StrPas(LogFont.lfFaceName), TObject(FontType));
  Result := 1;
end;

procedure TfrDesignerForm.GetFontList;
var
  aStrings:TStringList;
begin
  FontsCbo.Items.Clear;
  aStrings:=TStringList.Create;
  EnumFonts(Prn.Printer.Handle, nil, @EnumFontsProc, Pointer(aStrings));
  aStrings.Sort;
  FontsCbo.Items.Assign(aStrings);
  aStrings.Free;

  if FontsCbo.Items.Count > 0 then
    LastFontName := FontsCbo.Items[0]
  else
    LastFontName := 'Arial';
  LastFontSize := 10;
end;

procedure TfrDesignerForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  Busy := True;
  FirstTime := True;
  // these invisible panels are added to set scroll range to
  // 0..Preview.Width+10 and 0..Preview.Height+10
  BPanel := TPanel.Create(ScrollBox1);
  BPanel.Parent := ScrollBox1;
  BPanel.Height := 1; BPanel.Left := 0; BPanel.Top := ScrollBox1.Height;
  BPanel.Color := ScrollBox1.Color;

  RPanel := TPanel.Create(ScrollBox1);
  RPanel.Parent := ScrollBox1;
  RPanel.Width := 1; RPanel.Left := ScrollBox1.Width; RPanel.Top := 0;
  RPanel.Color := ScrollBox1.Color;

  PageView := TfrDesignerPage.Create(ScrollBox1);
  PageView.FDesigner := Self;
  PageView.PopupMenu := EditPopup;
  PageView.ShowHint := True;

  ColorSelector := TColorSelector.Create(Self);
  ColorSelector.OnColorSelected := ColorSelected;

  for i := 0 to frAddInsCount - 1 do
    with frAddIns[i] do
      RegisterObject(ImageIndex, ImageList, ButtonHint, Integer(gtAddIn) + i);

  ObjectValues := TFRObjectValues.Create;
  ObjectValues.Add('Name');
  ObjectValues.Add('Left');
  ObjectValues.Add('Top');
  ObjectValues.Add('Width');
  ObjectValues.Add('Height');
  ObjectValues.Add('Visible');
  ObjectValues.Add('Memo');

  InspForm := TfrInspForm.Create(Self);
  EditorForm := TfrMemoEditorForm.Create(Self);
  with InspForm do
  begin
    ClearItems;
    Items.AddObject('Name', TFRItemObject.Create(ObjectValues[0], csEdit, nil));
    Items.AddObject('Left', TFRItemObject.Create(ObjectValues[1], csEdit, nil));
    Items.AddObject('Top', TFRItemObject.Create(ObjectValues[2], csEdit, nil));
    Items.AddObject('Width', TFRItemObject.Create(ObjectValues[3], csEdit, nil));
    Items.AddObject('Height', TFRItemObject.Create(ObjectValues[4], csEdit, nil));
    Items.AddObject('Visible', TFRItemObject.Create(ObjectValues[5], csEdit, nil));
    Items.AddObject('Memo', TFRItemObject.Create(ObjectValues[6], csDefEditor, EditorForm));
    OnModify := Self.OnModify;
  end;

  MenuItems := TList.Create;
  ItemWidths := TStringlist.Create;

  N41.OnClick := AddPageMnu.OnClick;
  N43.OnClick := RemovePageMnu.OnClick;
  N44.OnClick := PageOptionsMnu.OnClick;
end;

procedure TfrDesignerForm.FormShow(Sender: TObject);
begin
  Screen.Cursors[crPencil] := LoadCursor(hInstance, 'FR_PENCIL');
  Panel7.Hide;
  if FirstTime then
    SetMenuBitmaps;
  FirstTime := False;
  ClearUndoBuffer;
  ClearRedoBuffer;
  Modified := False;
  FileModified := False;
  Busy := True; 
  Report.DocMode := dmDesigning;
  GetFontList;
  FontsCbo.Perform(CB_SETDROPPEDWIDTH, 170, 0);
  CurPage := 0; // this cause page sizing
  CurDocName := Report.FileName;
  Unselect;
  PageView.Init;
  EnableControls;
  BDown(SelectObjectBtn);
  frSetGlyph(Self, 0, BackgroundColorBtn, 1);
  frSetGlyph(Self, 0, FontColorBtn, 0);
  frSetGlyph(Self, 0, FrameColorBtn, 2);
  ColorSelector.Hide;
  LinePanel.Hide;
  ShowPosition;
  RestoreState;
  FormResize(nil);
end;

procedure TfrDesignerForm.FormHide(Sender: TObject);
begin
  ClearUndoBuffer;
  ClearRedoBuffer;
  SaveState;
  Report.FileName := CurDocName;
end;

procedure TfrDesignerForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  if (CurDocName <> '') and (FileModified) then
  begin
    Report.SaveToFile(CurDocName, False);
    FileModified := False;
  end;
  for i := 0 to MenuItems.Count - 1 do
    TfrMenuItemInfo(MenuItems[i]).Free;
  MenuItems.Free;
  ItemWidths.Free;
  PageView.Free;
  BPanel.Free;
  RPanel.Free;
  ColorSelector.Free;
  InspForm.Free;
  EditorForm.Free;
end;

procedure TfrDesignerForm.FormResize(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  with ScrollBox1 do
  begin
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;
  end;
  PageView.SetPage;
  Panel7.Top := StatusBar1.Top + 3;
  Panel7.Show;
end;

procedure TfrDesignerForm.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin // for best view - not actual in Win98 :(
  with Msg.MinMaxInfo^ do
  begin
    ptMaxSize.x := Screen.Width;
    ptMaxSize.y := Screen.Height;
    ptMaxPosition.x := 0;
    ptMaxPosition.y := 0;
  end;
end;

procedure TfrDesignerForm.SetCurPage(Value: Integer);
begin // setting curpage and do all manipulation
  FCurPage := Value;
  Page := Report.Pages[CurPage];
  ScrollBox1.VertScrollBar.Position := 0;
  ScrollBox1.HorzScrollBar.Position := 0;
  PageView.SetPage;
  SetPageTitles;
  Tab1.TabIndex := Value;
  ResetSelection;
  SendBandsToDown;
  PageView.Repaint;
end;

procedure TfrDesignerForm.SetGridSize(Value: Integer);
begin
  if FGridSize = Value then Exit;
  FGridSize := Value;
  RedrawPage;
end;

procedure TfrDesignerForm.SetGridShow(Value: Boolean);
begin
  if FGridShow = Value then Exit;
  FGridShow := Value;
  GridBtn.Down := Value;
  RedrawPage;
end;

procedure TfrDesignerForm.SetGridAlign(Value: Boolean);
begin
  if FGridAlign = Value then Exit;
  GridAlignBtn.Down := Value;
  FGridAlign := Value;
end;

procedure TfrDesignerForm.SetUnits(Value: TfrReportUnits);
var
  s: string;
begin
  FUnits := Value;
  case Value of
    ruPixels: s := 'Pixels';
    ruMM: s := 'MM';
    ruInches: s := 'Inches';
  end;
  StatusBar1.Panels[0].Text := s;
  ShowPosition;
end;

procedure TfrDesignerForm.SetGrayedButtons(Value: Boolean);
  procedure DoButtons(t: array of TControl);
  var
    i, j: Integer;
    c: TWinControl;
    c1: TControl;
  begin
    for i := Low(t) to High(t) do
    begin
      c := TWinControl(t[i]);
      for j := 0 to c.ControlCount - 1 do
      begin
        c1 := c.Controls[j];
        if c1 is TToolButton then
          TToolButton(c1).Enabled := Value;
      end;
    end;
  end;
begin
  FGrayedButtons := Value;
  DoButtons([RectanglePnl, StandardPnl, TextPnl, ObjectsPnl, AlignmentPnl]);
end;

procedure TfrDesignerForm.SetCurDocName(Value: string);
begin
  FCurDocName := Value;
  Caption := 'Designer - [' + ExtractFileName(Value)+']';
end;

procedure TfrDesignerForm.RegisterObject(vImageIndex: Integer; vImageList:TImageList; const ButtonHint: string; ButtonTag: Integer);
var
  b: TToolButton;
begin
  b := TToolButton.Create(Self);
  with b do
  begin
    Hint := ButtonHint;
    Style := tbsCheck;
    AllowAllUp := False;
    Grouped := True;
    Tag := ButtonTag;
    OnMouseDown := InsertRectangleObjectBtnMouseDown;
    SetBounds(1000, 1000, 22, 22);
    ImageIndex := vImageIndex;
    Parent := ObjectsPnl;
  end;
end;

procedure TfrDesignerForm.AddPage;
begin
  Report.Pages.Add;
  Page := Report.Pages[Report.Pages.Count - 1];
  PageOptionsBtnClick(nil);
  if WasOk then
  begin
    Modified := True;
    FileModified := True;
    CurPage := Report.Pages.Count - 1
  end
  else
  begin
    Report.Pages.Delete(Report.Pages.Count - 1);
    CurPage := CurPage;
  end;
end;

procedure TfrDesignerForm.RemovePage(n: Integer);
  procedure AdjustSubReports;
  var
    i, j: Integer;
    t: TfrView;
  begin
    with Report do
      for i := 0 to Pages.Count - 1 do
      begin
        j := 0;
        while j < Pages[i].Objects.Count do
        begin
          t := Pages[i].Objects[j];
          if t.Typ = gtSubReport then
            if TfrSubReportView(t).SubPage = n then
            begin
              Pages[i].Delete(j);
              Dec(j);
            end
            else if TfrSubReportView(t).SubPage > n then
              Dec(TfrSubReportView(t).SubPage);
          Inc(j);
        end;
      end;
  end;
begin
  Modified := True;
  FileModified := True;
  with Report do
    if (n >= 0) and (n < Pages.Count) then
      if Pages.Count = 1 then
        Pages[n].Clear else
      begin
        Report.Pages.Delete(n);
        Tab1.Tabs.Delete(n);
        Tab1.TabIndex := 0;
        AdjustSubReports;
        CurPage := 0;
      end;
  ClearUndoBuffer;
  ClearRedoBuffer;
end;

procedure TfrDesignerForm.SetPageTitles;
var
  i: Integer;
  s: string;
  function IsSubreport(PageN: Integer): Boolean;
  var
    i, j: Integer;
    t: TfrView;
  begin
    Result := False;
    with Report do
      for i := 0 to Pages.Count - 1 do
        for j := 0 to Pages[i].Objects.Count - 1 do
        begin
          t := Pages[i].Objects[j];
          if t.Typ = gtSubReport then
            if TfrSubReportView(t).SubPage = PageN then
            begin
              s := t.Name;
              Result := True;
              Exit;
            end;
        end;
  end;
begin
  if Tab1.Tabs.Count = Report.Pages.Count then
    for i := 0 to Tab1.Tabs.Count - 1 do
    begin
      if not IsSubreport(i) then
        s := 'Page' + IntToStr(i + 1);
      if Tab1.Tabs[i] <> s then
        Tab1.Tabs[i] := s;
    end
  else
  begin
    Tab1.Tabs.Clear;
    for i := 0 to Report.Pages.Count - 1 do
    begin
      if not IsSubreport(i) then
        s := 'Page' + IntToStr(i + 1);
      Tab1.Tabs.Add(s);
    end;
  end;
end;

procedure TfrDesignerForm.CutToClipboard;
var
  i: Integer;
  t: TfrView;
begin
  ClearClipBoard;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      ClipBd.Add(frCreateObject(Report, t.Typ, t.ClassName));
      TfrView(ClipBd.Last).Assign(t);
    end;
  end;
  for i := Page.Objects.Count - 1 downto 0 do
  begin
    t := Page.Objects[i];
    if t.Selected then Page.Delete(i);
  end;
  SelNum := 0;
end;

procedure TfrDesignerForm.CopyToClipboard;
var
  i: Integer;
  t: TfrView;
begin
  ClearClipBoard;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      ClipBd.Add(frCreateObject(Report, t.Typ, t.ClassName));
      TfrView(ClipBd.Last).Assign(t);
    end;
  end;
end;

constructor TfrDesignerForm.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfrDesignerForm.SelectAll;
var
  i: Integer;
begin
  SelNum := 0;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    TfrView(Page.Objects[i]).Selected := True;
    Inc(SelNum);
  end;
end;

procedure TfrDesignerForm.Unselect;
var
  i: Integer;
begin
  SelNum := 0;
  for i := 0 to Page.Objects.Count - 1 do
    TfrView(Page.Objects[i]).Selected := False;
end;

procedure TfrDesignerForm.ResetSelection;
begin
  Unselect;
  EnableControls;
  ShowPosition;
end;

function TfrDesignerForm.PointsToUnits(x: Integer): Double;
begin
  Result := x;
  case FUnits of
    ruMM: Result := x / 18 * 5;
    ruInches: Result := x / 18 * 5 / 25.4;
  end;
end;

function TfrDesignerForm.UnitsToPoints(x: Double): Integer;
begin
  Result := Round(x);
  case FUnits of
    ruMM: Result := Round(x / 5 * 18);
    ruInches: Result := Round(x * 25.4 / 5 * 18);
  end;
end;

procedure TfrDesignerForm.RedrawPage;
begin
  PageView.Draw(10000, 0);
end;

procedure TfrDesignerForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StepX, StepY: Integer;
  i, tx, ty, tx1, ty1, d, d1: Integer;
  t, t1: TfrView;
begin
  StepX := 0; StepY := 0;
  if (Key = vk_Return) and (ActiveControl = FontSizeCbo) then
  begin
    Key := 0;
    DoClick(FontSizeCbo);
  end;
  if (Key = vk_Return) and (ActiveControl = FrameWidthEdit) then
  begin
    Key := 0;
    DoClick(FrameWidthEdit);
  end;
  if (Key = vk_Delete) and DelEnabled then
  begin
    DeleteObjects;
    Key := 0;
  end;
  if (Key = vk_Return) and EditEnabled then
  begin
    if ssCtrl in Shift then
      ShowMemoEditor else
      ShowEditor;
  end;
  if (Chr(Key) in ['1'..'9']) and (ssCtrl in Shift) and DelEnabled then
  begin
    FrameWidthEdit.Text := Chr(Key);
    DoClick(FrameWidthEdit);
    Key := 0;
  end;
  if (Chr(Key) = 'F') and (ssCtrl in Shift) and DelEnabled then
  begin
    AllFrameLinesBtn.Click;
    Key := 0;
  end;
  if (Chr(Key) = 'D') and (ssCtrl in Shift) and DelEnabled then
  begin
    NoFrameBtn.Click;
    Key := 0;
  end;
  if (Chr(Key) = 'G') and (ssCtrl in Shift) then
  begin
    ShowGrid := not ShowGrid;
    Key := 0;
  end;
  if (Chr(Key) = 'B') and (ssCtrl in Shift) then
  begin
    GridAlign := not GridAlign;
    Key := 0;
  end;
  if CutEnabled then
    if (Key = vk_Delete) and (ssShift in Shift) then CutBtnClick(Self);
  if CopyEnabled then
    if (Key = vk_Insert) and (ssCtrl in Shift) then CopyBtnClick(Self);
  if PasteEnabled then
    if (Key = vk_Insert) and (ssShift in Shift) then PasteBtnClick(Self);
  if Key = vk_Prior then
    with ScrollBox1.VertScrollBar do
    begin
      Position := Position - 200;
      Key := 0;
    end;
  if Key = vk_Next then
    with ScrollBox1.VertScrollBar do
    begin
      Position := Position + 200;
      Key := 0;
    end;
  if SelNum > 0 then
  begin
    if Key = vk_Up then StepY := -1
    else if Key = vk_Down then StepY := 1
    else if Key = vk_Left then StepX := -1
    else if Key = vk_Right then StepX := 1;
    if (StepX <> 0) or (StepY <> 0) then
    begin
      if ssCtrl in Shift then
        MoveObjects(StepX, StepY, False)
      else if ssShift in Shift then
        MoveObjects(StepX, StepY, True)
      else if SelNum = 1 then
      begin
        t := Page.Objects[TopSelected];
        tx := t.x; ty := t.y; tx1 := t.x + t.dx; ty1 := t.y + t.dy;
        d := 10000;
        t1 := nil;
        for i := 0 to Page.Objects.Count - 1 do
        begin
          t := Page.Objects[i];
          if not t.Selected and (t.Typ <> gtBand) then
          begin
            d1 := 10000;
            if StepX <> 0 then
            begin
              if t.y + t.dy < ty then
                d1 := ty - (t.y + t.dy)
              else if t.y > ty1 then
                d1 := t.y - ty1
              else if (t.y <= ty) and (t.y + t.dy >= ty1) then
                d1 := 0
              else
                d1 := t.y - ty;
              if ((t.x <= tx) and (StepX = 1)) or
                ((t.x + t.dx >= tx1) and (StepX = -1)) then
                d1 := 10000;
              if StepX = 1 then
                if t.x >= tx1 then
                  d1 := d1 + t.x - tx1 else
                  d1 := d1 + t.x - tx
              else if t.x + t.dx <= tx then
                d1 := d1 + tx - (t.x + t.dx) else
                d1 := d1 + tx1 - (t.x + t.dx);
            end
            else if StepY <> 0 then
            begin
              if t.x + t.dx < tx then
                d1 := tx - (t.x + t.dx)
              else if t.x > tx1 then
                d1 := t.x - tx1
              else if (t.x <= tx) and (t.x + t.dx >= tx1) then
                d1 := 0
              else
                d1 := t.x - tx;
              if ((t.y <= ty) and (StepY = 1)) or
                ((t.y + t.dy >= ty1) and (StepY = -1)) then
                d1 := 10000;
              if StepY = 1 then
                if t.y >= ty1 then
                  d1 := d1 + t.y - ty1 else
                  d1 := d1 + t.y - ty
              else if t.y + t.dy <= ty then
                d1 := d1 + ty - (t.y + t.dy) else
                d1 := d1 + ty1 - (t.y + t.dy);
            end;
            if d1 < d then
            begin
              d := d1;
              t1 := t;
            end;
          end;
        end;
        if t1 <> nil then
        begin
          t := Page.Objects[TopSelected];
          if not (ssAlt in Shift) then
          begin
            PageView.DrawPage(dmSelection);
            Unselect;
            SelNum := 1;
            t1.Selected := True;
            PageView.DrawPage(dmSelection);
          end
          else
          begin
            if (t1.x >= t.x + t.dx) and (Key = vk_Right) then
              t.x := t1.x - t.dx
            else if (t1.y > t.y + t.dy) and (Key = vk_Down) then
              t.y := t1.y - t.dy
            else if (t1.x + t1.dx <= t.x) and (Key = vk_Left) then
              t.x := t1.x + t1.dx
            else if (t1.y + t1.dy <= t.y) and (Key = vk_Up) then
              t.y := t1.y + t1.dy;
            RedrawPage;
          end;
          SelectionChanged;
        end;
      end;
    end;
  end;
end;

procedure TfrDesignerForm.MoveObjects(dx, dy: Integer; Resize: Boolean);
var
  i: Integer;
  t: TfrView;
begin
  AddUndoAction(acEdit);
  GetRegion;
  PageView.DrawPage(dmSelection);
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      if Resize then
      begin
        Inc(t.dx, dx); Inc(t.dy, dy);
      end
      else
      begin
        Inc(t.x, dx); Inc(t.y, dy);
      end;
  end;
  ShowPosition;
  PageView.GetMultipleSelected;
  PageView.Draw(TopSelected, ClipRgn);
end;

procedure TfrDesignerForm.DeleteObjects;
var
  i: Integer;
  t: TfrView;
begin
  AddUndoAction(acDelete);
  GetRegion;
  PageView.DrawPage(dmSelection);
  for i := Page.Objects.Count - 1 downto 0 do
  begin
    t := Page.Objects[i];
    if t.Selected then Page.Delete(i);
  end;
  SetPageTitles;
  ResetSelection;
  FirstSelected := nil;
  PageView.Draw(10000, ClipRgn);
end;

destructor TfrDesignerForm.Destroy;
begin
  FreeAndNil(ObjectValues);
  inherited;
end;

function TfrDesignerForm.SelStatus: TfrSelectionStatus;
var
  t: TfrView;
begin
  Result := [];
  if SelNum = 1 then
  begin
    t := Page.Objects[TopSelected];
    if t.Typ = gtBand then
      Result := [ssBand]
    else if t is TfrMemoView then
      Result := [ssMemo] else
      Result := [ssOther];
  end
  else if SelNum > 1 then
    Result := [ssMultiple];
  if ClipBd.Count > 0 then
    Result := Result + [ssClipboardFull];
end;

function TfrDesignerForm.RectTypEnabled: Boolean;
begin
  Result := [ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.FontTypEnabled: Boolean;
begin
  Result := [ssMemo, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.ZEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.CutEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.CopyEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.PasteEnabled: Boolean;
begin
  Result := ssClipboardFull in SelStatus;
end;

function TfrDesignerForm.DelEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TfrDesignerForm.EditEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther] * SelStatus <> [];
end;

procedure TfrDesignerForm.EnableControls;
  procedure SetEnabled(const Ar: array of TObject; en: Boolean);
  var
    i: Integer;
  begin
    for i := Low(Ar) to High(Ar) do
      if Ar[i] is TControl then
        (Ar[i] as TControl).Enabled := en
      else if Ar[i] is TMenuItem then
        (Ar[i] as TMenuItem).Enabled := en;
  end;
begin
  SetEnabled([TopFrameLineBtn, LeftFrameLineBtn, BottomFrameLineBtn, RightFrameLineBtn, AllFrameLinesBtn, NoFrameBtn, BackgroundColorBtn, FrameColorBtn, FrameWidthEdit, LineStyleBtn],
    RectTypEnabled);
  SetEnabled([FontColorBtn, FontsCbo, FontSizeCbo, BoldBtn, ItalicBtn, UnderLineBtn, LeftAlignBtn, RightAlignBtn, CenterAlignBtn, RotateBtn, VerticalCenterBtn, TopAlignBtn, BottomAlignBtn, WidthAlignBtn],
    FontTypEnabled);
  SetEnabled([BringToFrontBtn, SendToBackBtn, BringToFrontMnu, SendToBackMnu, FitToGridBtn], ZEnabled);
  SetEnabled([CutBtn, CutMnu, ECutMnu], CutEnabled);
  SetEnabled([CopyBtn, CopyMnu, ECopyMnu], CopyEnabled);
  SetEnabled([PasteBtn, PasteMnu, EPasteMnu], PasteEnabled);
  SetEnabled([DeleteMnu, EDeleteMnu], DelEnabled);
  SetEnabled([EditObjectMnu, EEditObjectMnu], EditEnabled);
  if not FontsCbo.Enabled then
  begin
    FontsCbo.ItemIndex := -1;
    FontSizeCbo.Text := '';
  end;
  InspForm.EnableItem(6, EditEnabled);
  StatusBar1.Repaint;
  PBox1Paint(nil);
end;

procedure TfrDesignerForm.SelectionChanged;
var
  t: TfrView;
begin
  Busy := True;
  ColorSelector.Hide;
  LinePanel.Hide;
  EnableControls;
  if SelNum = 1 then
  begin
    t := Page.Objects[TopSelected];
    if t.Typ <> gtBand then
      with t do
      begin
        TopFrameLineBtn.Down := (FrameType and $8) <> 0;
        LeftFrameLineBtn.Down := (FrameType and $4) <> 0;
        BottomFrameLineBtn.Down := (FrameType and $2) <> 0;
        RightFrameLineBtn.Down := (FrameType and $1) <> 0;
        FrameWidthEdit.Text := FloatToStrF(FrameWidth, ffGeneral, 2, 2);
        frSetGlyph(Self, FillColor, BackgroundColorBtn, 1);
        frSetGlyph(Self, FrameColor, FrameColorBtn, 2);
        if t is TfrMemoView then
          with t as TfrMemoView do
          begin
            frSetGlyph(Self, Font.Color, FontColorBtn, 0);
            if FontsCbo.ItemIndex <> FontsCbo.Items.IndexOf(Font.Name) then
              FontsCbo.ItemIndex := FontsCbo.Items.IndexOf(Font.Name);
            if FontSizeCbo.Text <> IntToStr(Font.Size) then
              FontSizeCbo.Text := IntToStr(Font.Size);
            BoldBtn.Down := fsBold in Font.Style;
            ItalicBtn.Down := fsItalic in Font.Style;
            UnderLineBtn.Down := fsUnderline in Font.Style;
            RotateBtn.Down := (Adjust and $4) <> 0;
            VerticalCenterBtn.Down := (Adjust and $18) = $8;
            TopAlignBtn.Down := (Adjust and $18) = 0;
            BottomAlignBtn.Down := (Adjust and $18) = $10;
            case (Adjust and $3) of
              0: BDown(LeftAlignBtn);
              1: BDown(RightAlignBtn);
              2: BDown(CenterAlignBtn);
              3: BDown(WidthAlignBtn);
            end;
          end;
      end;
  end
  else if SelNum > 1 then
  begin
    BUp(TopFrameLineBtn); BUp(LeftFrameLineBtn); BUp(BottomFrameLineBtn); BUp(RightFrameLineBtn);
    frSetGlyph(Self, 0, BackgroundColorBtn, 1);
    FrameWidthEdit.Text := '1';
    FontsCbo.ItemIndex := -1;
    FontSizeCbo.Text := '';
    BUp(BoldBtn); BUp(ItalicBtn);
    BUp(UnderLineBtn);
    BDown(LeftAlignBtn);
    BUp(RotateBtn);
    BUp(VerticalCenterBtn);
  end;
  Busy := False;
  ShowPosition;
  ShowContent;
  ActiveControl := nil;
end;

procedure TfrDesignerForm.ShowPosition;
begin
  FillInspFields;
  InspForm.ItemsChanged;
  StatusBar1.Repaint;
  PBox1Paint(nil);
end;

procedure TfrDesignerForm.ShowContent;
var
  t: TfrView;
  s: string;
begin
  s := '';
  if SelNum = 1 then
  begin
    t := Page.Objects[TopSelected];
    s := t.Name;
    if t is TfrBandView then
      s := s + ': ' + frBandNames[Integer(TfrBandView(t).BandType)]
    else if t.Memo.Count > 0 then
      s := s + ': ' + t.Memo[0];
  end;
  StatusBar1.Panels[2].Text := s;
end;

procedure SetBit(var w: Word; e: Boolean; m: Integer);
begin
  if e then w := w or m
  else w := w and not m;
end;

procedure TfrDesignerForm.DoClick(Sender: TObject);
var
  i, j, b: Integer;
  s: string;
  DRect: TRect;
  t: TfrView;
begin
  if Busy then
    Exit;
  AddUndoAction(acEdit);
  PageView.DrawPage(dmSelection);
  GetRegion;
  b := (Sender as TControl).Tag;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected and ((t.Typ <> gtBand) or (b = 16)) then
      with t do
      begin
        if t is TfrMemoView then
          with t as TfrMemoView do
            case b of
              7: if FontsCbo.ItemIndex <> 0 then
                begin
                  Font.Name := FontsCbo.Text;
                  LastFontName := Font.Name;
                end;
              8: begin
                  Font.Size := StrToInt(FontSizeCbo.Text);
                  LastFontSize := Font.Size;
                end;
              9: begin
                  LastFontStyle := frGetFontStyle(Font.Style);
                  SetBit(LastFontStyle, BoldBtn.Down, 2);
                  Font.Style := frSetFontStyle(LastFontStyle);
                end;
              10: begin
                  LastFontStyle := frGetFontStyle(Font.Style);
                  SetBit(LastFontStyle, ItalicBtn.Down, 1);
                  Font.Style := frSetFontStyle(LastFontStyle);
                end;
              11..13:
                begin
                  Adjust := (Adjust and $FC) + (b - 11);
                  LastAdjust := Adjust;
                end;
              14: begin
                  Adjust := (Adjust and $FB) + Word(RotateBtn.Down) * 4;
                  LastAdjust := Adjust;
                end;
              15: begin
                  Adjust := (Adjust and $E7) + Word(VerticalCenterBtn.Down) * 8 + Word(BottomAlignBtn.Down) * $10;
                  LastAdjust := Adjust;
                end;
              17: begin
                  Font.Color := ColorSelector.Color;
                  LastFontColor := Font.Color;
                end;
              18: begin
                  LastFontStyle := frGetFontStyle(Font.Style);
                  SetBit(LastFontStyle, UnderLineBtn.Down, 4);
                  Font.Style := frSetFontStyle(LastFontStyle);
                end;
              22: begin
                  Adjust := (Adjust and $FC) + 3;
                  LastAdjust := Adjust;
                end;
            end;
        case b of
          1:
            begin
              SetBit(FrameType, TopFrameLineBtn.Down, 8);
              DRect := Rect(t.x - 10, t.y - 10, t.x + t.dx + 10, t.y + 10)
            end;
          2:
            begin
              SetBit(FrameType, LeftFrameLineBtn.Down, 4);
              DRect := Rect(t.x - 10, t.y - 10, t.x + 10, t.y + t.dy + 10)
            end;
          3:
            begin
              SetBit(FrameType, BottomFrameLineBtn.Down, 2);
              DRect := Rect(t.x - 10, t.y + t.dy - 10, t.x + t.dx + 10, t.y + t.dy + 10)
            end;
          4:
            begin
              SetBit(FrameType, RightFrameLineBtn.Down, 1);
              DRect := Rect(t.x + t.dx - 10, t.y - 10, t.x + t.dx + 10, t.y + t.dy + 10)
            end;
          20:
            begin
              FrameType := FrameType or $F;
              LastFrameType := $F;
            end;
          21:
            begin
              FrameType := FrameType and not $F;
              LastFrameType := 0;
            end;
          5:
            begin
              FillColor := ColorSelector.Color;
              LastFillColor := FillColor;
            end;
          6:
            begin
              s := FrameWidthEdit.Text;
              for j := 1 to Length(s) do
                if s[j] in ['.', ','] then
                  s[j] := FormatSettings.DecimalSeparator;
              FrameWidth := StrToFloat(s);
              if t is TfrLineView then
                LastLineWidth := FrameWidth else
                LastFrameWidth := FrameWidth;
            end;
          19:
            begin
              FrameColor := ColorSelector.Color;
              LastFrameColor := FrameColor;
            end;
          25..30:
            FrameStyle := b - 25;
        end;
      end;
  end;
  PageView.Draw(TopSelected, ClipRgn);
  ActiveControl := nil;
  if b in [20, 21] then
    SelectionChanged;
end;

procedure TfrDesignerForm.frSpeedButton1Click(Sender: TObject);
begin
  LinePanel.Hide;
  DoClick(Sender);
end;

procedure TfrDesignerForm.FillInspFields;
var
  t: TfrView;
  i, x, y, dx, dy, v: Integer;
  procedure FillFields(x, y, dx, dy, v: Integer);
  begin
    if FUnits = ruPixels then
    begin
      if x <> -10000 then ObjectValues[1].Value := IntToStr(x);
      if y <> -10000 then ObjectValues[2].Value := IntToStr(y);
      if dx <> -10000 then ObjectValues[3].Value := IntToStr(dx);
      if dy <> -10000 then ObjectValues[4].Value := IntToStr(dy);
    end
    else
    begin
      if x <> -10000 then ObjectValues[1].Value := FloatToStrF(PointsToUnits(x), ffFixed, 4, 2);
      if y <> -10000 then ObjectValues[2].Value := FloatToStrF(PointsToUnits(y), ffFixed, 4, 2);
      if dx <> -10000 then ObjectValues[3].Value := FloatToStrF(PointsToUnits(dx), ffFixed, 4, 2);
      if dy <> -10000 then ObjectValues[4].Value := FloatToStrF(PointsToUnits(dy), ffFixed, 4, 2);
    end;
    if v <> -10000 then
    begin
      if v <> 0 then v := 1;
      ObjectValues[5].Value := IntToStr(v);
    end;
  end;
begin
  for i := 0 to ObjectValues.Count -1 do
    ObjectValues[i].Clear;

  InspForm.V := nil;
  if SelNum = 1 then
  begin
    t := Page.Objects[TopSelected];
    InspForm.V := t;
    ObjectValues[0].Value := t.Name;
    FillFields(t.x, t.y, t.dx, t.dy, Integer(t.Visible));
  end
  else if SelNum > 1 then
  begin
    t := Page.Objects[TopSelected];
    x := t.x; y := t.y; dx := t.dx; dy := t.dy; v := Integer(t.Visible);
    for i := 0 to Page.Objects.Count - 1 do
    begin
      t := Page.Objects[i];
      if t.Selected then
      begin
        if t.x <> x then x := -10000;
        if t.y <> y then y := -10000;
        if t.dx <> dx then dx := -10000;
        if t.dy <> dy then dy := -10000;
        if Integer(t.Visible) <> v then v := -10000;
      end;
    end;
    FillFields(x, y, dx, dy, v);
  end;
  InspForm.HideProperties := SelNum = 0;
end;

procedure TfrDesignerForm.OnModify(Item: Integer; var EditText: string);
var
  t: TfrView;
  i, k: Integer;
begin
  AddUndoAction(acEdit);
  if (Item = 0) and (SelNum = 1) then
  begin
    t := Page.Objects[TopSelected];
    if Report.FindObject(ObjectValues[0].Value) = nil then
      t.Name := ObjectValues[0].Value
    else
      EditText := t.Name;
    SetPageTitles;
  end
  else if Item in [1..5] then
  begin
    EditText := frParser.Calc(ObjectValues[Item].Value);
    if Item <> 6 then
      k := UnitsToPoints(StrToFloat(EditText)) else
      k := StrToInt(EditText);
    for i := 0 to Page.Objects.Count - 1 do
    begin
      t := Page.Objects[i];
      if t.Selected then
        with t do
          case Item of
            1: if (k > 0) and (k < Page.PrnInfo.Pgw) then
                x := k;
            2: if (k > 0) and (k < Page.PrnInfo.Pgh) then
                y := k;
            3: if (k > 0) and (k < Page.PrnInfo.Pgw) then
                dx := k;
            4: if (k > 0) and (k < Page.PrnInfo.Pgh) then
                dy := k;
            5: Visible := Boolean(k);
          end;
    end;
  end;
  FillInspFields;
  if Item in [1..5] then
    EditText := ObjectValues[Item].Value;
  RedrawPage;
  StatusBar1.Repaint;
  PBox1Paint(nil);
end;

procedure TfrDesignerForm.LineStyleBtnClick(Sender: TObject);
var
  p: TPoint;
begin
  if not LinePanel.Visible then
  begin
    LinePanel.Parent := Self;
    with (Sender as TControl) do
      p := Self.ScreenToClient(Parent.ClientToScreen(Point(Left, Top)));
    LinePanel.Left := p.X;
    LinePanel.Top := p.Y + 26;
  end;
  LinePanel.Visible := not LinePanel.Visible;
end;

procedure TfrDesignerForm.BackgroundColorBtnClick(Sender: TObject);
var
  p: TPoint;
begin
  with (Sender as TControl) do
    p := Self.ScreenToClient(Parent.ClientToScreen(Point(Left, Top)));
  if ColorSelector.Left = p.X then
    ColorSelector.Visible := not ColorSelector.Visible
  else
  begin
    ColorSelector.Left := p.X;
    ColorSelector.Top := p.Y + 26;
    ColorSelector.Visible := True;
  end;
  ClrButton := Sender as TSpeedButton;
  with ClrButton.Glyph.Canvas do
    if Pixels[2, 14] <> Pixels[1, 13] then
      ColorSelector.Color := clNone else
      ColorSelector.Color := Pixels[2, 14];
end;

procedure TfrDesignerForm.ColorSelected(Sender: TObject);
var
  n: Integer;
begin
  n := 0;
  if ClrButton = BackgroundColorBtn then
    n := 1
  else if ClrButton = FrameColorBtn then
    n := 2;
  frSetGlyph(Self, ColorSelector.Color, ClrButton, n);
  DoClick(ClrButton);
end;

procedure TfrDesignerForm.PBox1Paint(Sender: TObject);
var
  t: TfrView;
  s: string;
  nx, ny: Double;
  x, y, dx, dy: Integer;
begin
  with PBox1.Canvas do
  begin
    FillRect(Rect(0, 0, PBox1.Width, PBox1.Height));
    SelectImageList.Draw(PBox1.Canvas, 2, 0, 0);
    SelectImageList.Draw(PBox1.Canvas, 92, 0, 1);
    if (SelNum = 1) or ShowSizes then
    begin
      t := nil;
      if ShowSizes then
      begin
        x := OldRect.Left; y := OldRect.Top;
        dx := OldRect.Right - x; dy := OldRect.Bottom - y;
      end
      else
      begin
        t := Page.Objects[TopSelected];
        x := t.x; y := t.y; dx := t.dx; dy := t.dy;
      end;
      if FUnits = ruPixels then
        s := IntToStr(x) + ';' + IntToStr(y) else
        s := FloatToStrF(PointsToUnits(x), ffFixed, 4, 2) + '; ' +
          FloatToStrF(PointsToUnits(y), ffFixed, 4, 2);
      TextOut(20, 1, s);
      if FUnits = ruPixels then
        s := IntToStr(dx) + ';' + IntToStr(dy) else
        s := FloatToStrF(PointsToUnits(dx), ffFixed, 4, 2) + '; ' +
          FloatToStrF(PointsToUnits(dy), ffFixed, 4, 2);
      TextOut(110, 1, s);
      if not ShowSizes and (t.Typ = gtPicture) then
        with t as TfrPictureView do
          if (Picture.Graphic <> nil) and not Picture.Graphic.Empty then
          begin
            s := IntToStr(dx * 100 div Picture.Width) + ',' +
              IntToStr(dy * 100 div Picture.Height);
            TextOut(170, 1, '% ' + s);
          end;
    end
    else if (SelNum > 0) and MRFlag then
    begin
      nx := 0; ny := 0;
      if OldRect1.Right - OldRect1.Left <> 0 then
        nx := (OldRect.Right - OldRect.Left) / (OldRect1.Right - OldRect1.Left);
      if OldRect1.Bottom - OldRect1.Top <> 0 then
        ny := (OldRect.Bottom - OldRect.Top) / (OldRect1.Bottom - OldRect1.Top);
      s := IntToStr(Round(nx * 100)) + ',' + IntToStr(Round(ny * 100));
      TextOut(170, 1, '% ' + s);
    end;
  end;
end;

procedure TfrDesignerForm.FontsCboDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with FontsCbo.Canvas do
  begin
    FillRect(Rect);
    if (Integer(FontsCbo.Items.Objects[Index]) and TRUETYPE_FONTTYPE) <> 0 then
      FontImageList.Draw(FontsCbo.Canvas, Rect.Left, Rect.Top + 1, 0);
    TextOut(Rect.Left + 20, Rect.Top + 1, FontsCbo.Items[Index]);
  end;
end;

procedure TfrDesignerForm.ShowMemoEditor;
begin
  with EditorForm do
  begin
    View := Page.Objects[TopSelected];
    if ShowEditor = mrOk then
    begin
      PageView.DrawPage(dmSelection);
      PageView.Draw(TopSelected, View.GetClipRgn(rtExtended));
    end;
  end;
  ActiveControl := nil;
end;

procedure TfrDesignerForm.ShowEditor;
var
  t: TfrView;
  i: Integer;
  bt: TfrBandType;
  aEditor: TfrObjEditorForm;
  frVBandEditorForm :TfrVBandEditorForm;
  frGroupEditorForm :TfrGroupEditorForm;
  frGEditorForm :TfrGEditorForm;
  frBandEditorForm :TfrBandEditorForm;
begin
  t := Page.Objects[TopSelected];
  if t.Typ = gtMemo then
    ShowMemoEditor
  else if t.Typ = gtPicture then
  begin
    frGEditorForm := TfrGEditorForm.Create(Self);
    try
      with frGEditorForm do
      begin
        Image1.Picture.Assign((t as TfrPictureView).Picture);
        if ShowModal = mrOk then
        begin
          AddUndoAction(acEdit);
          PageView.DrawPage(dmSelection);
          (t as TfrPictureView).Picture.Assign(Image1.Picture);
          PageView.Draw(TopSelected, t.GetClipRgn(rtExtended));
        end;
      end;
    finally
      frGEditorForm.Free;
    end;
  end
  else if t.Typ = gtBand then
  begin
    PageView.DrawPage(dmSelection);
    bt := (t as TfrBandView).BandType;
    if bt in [btMasterData, btDetailData, btSubDetailData] then
    begin
      frBandEditorForm := TfrBandEditorForm.Create(Self);
      try
        frBandEditorForm.ShowEditor(t);
      finally
        frBandEditorForm.Free;
      end;
    end
    else if bt = btGroupHeader then
    begin
      frGroupEditorForm := TfrGroupEditorForm.Create(Self);
      try
        frGroupEditorForm.ShowEditor(t);
      finally
        frGroupEditorForm.Free;
      end;
    end
    else if bt = btCrossData then
    begin
      frVBandEditorForm := TfrVBandEditorForm.Create(Self);
      try
      frVBandEditorForm.ShowEditor(t);
      finally
        frVBandEditorForm.Free;
      end;
    end
    else
      PageView.DFlag := False;
    PageView.Draw(TopSelected, t.GetClipRgn(rtExtended));
  end
  else if t.Typ = gtSubReport then
    CurPage := (t as TfrSubReportView).SubPage
  else if t.Typ = gtAddIn then
  begin
    for i := 0 to frAddInsCount - 1 do
      if frAddIns[i].ClassRef.ClassName = t.ClassName then
      begin
        if frAddIns[i].EditorForm <> nil then
        begin
          PageView.DrawPage(dmSelection);
          aEditor:= frAddIns[i].EditorForm.Create(Self);
          try
            aEditor.ShowEditor(t);
            PageView.Draw(TopSelected, t.GetClipRgn(rtExtended));
          finally
            aEditor.Free;
          end;
        end
        else
          ShowMemoEditor;
        break;
      end;
  end;
  ShowContent;
  ShowPosition;
  ActiveControl := nil;
end;

procedure TfrDesignerForm.ReleaseAction(ActionRec: TfrUndoRec);
var
  p, p1: TfrUndoObj;
begin
  p := ActionRec.Objects;
  while p <> nil do
  begin
    if ActionRec.Action in [acDelete, acEdit] then
      FreeAndNil(p.ObjPtr);
    p1 := p;
    p := p.Next;
    p1.Free;
  end;
end;

procedure TfrDesignerForm.ClearBuffer(Buffer: TfrUndoBuffer; var BufferLength: Integer);
var
  i: Integer;
begin
  for i := 0 to BufferLength - 1 do
    ReleaseAction(Buffer[i]);
  BufferLength := 0;
end;

procedure TfrDesignerForm.ClearUndoBuffer;
begin
  ClearBuffer(FUndoBuffer, FUndoBufferLength);
  UndoMnu.Enabled := False;
  UndoBtn.Enabled := UndoMnu.Enabled;
end;

procedure TfrDesignerForm.ClearRedoBuffer;
begin
  ClearBuffer(FRedoBuffer, FRedoBufferLength);
  RedoMnu.Enabled := False;
  RedoBtn.Enabled := RedoMnu.Enabled;
end;

procedure TfrDesignerForm.Undo(Buffer: PfrUndoBuffer);
var
  p, p1: TfrUndoObj;
  r: TfrUndoRec1;
  BufferLength: Integer;
  List: TList;
  a: TfrUndoAction;
begin
  if Buffer = @FUndoBuffer then
    BufferLength := FUndoBufferLength else
    BufferLength := FRedoBufferLength;

  if Buffer[BufferLength - 1].Page <> CurPage then Exit;
  List := TList.Create;
  a := Buffer[BufferLength - 1].Action;
  p := Buffer[BufferLength - 1].Objects;
  while p <> nil do
  begin
    r := TfrUndoRec1.Create;
    r.ObjPtr := p.ObjPtr;
    r.Int := p.Int;
    List.Add(r);
    case Buffer[BufferLength - 1].Action of
      acInsert:
        begin
          r.Int := Page.FindObjectByID(p.ObjID);
          r.ObjPtr := Page.Objects[r.Int];
          a := acDelete;
        end;
      acDelete: a := acInsert;
      acEdit: r.ObjPtr := Page.Objects[p.Int];
      acZOrder:
        begin
          r.Int := Page.FindObjectByID(p.ObjID);
          r.ObjPtr := Page.Objects[r.Int];
          p.ObjPtr := r.ObjPtr;
        end;
    end;
    p := p.Next;
  end;
  if Buffer = @FUndoBuffer then
    AddAction(@FRedoBuffer, a, List) else
    AddAction(@FUndoBuffer, a, List);
  List.Free;

  p := Buffer[BufferLength - 1].Objects;
  while p <> nil do
  begin
    case Buffer[BufferLength - 1].Action of
      acInsert: Page.Delete(Page.FindObjectByID(p.ObjID));
      acDelete: Page.Objects.Insert(p.Int, p.ObjPtr);
      acEdit:
        begin
          TfrView(Page.Objects[p.Int]).Assign(p.ObjPtr);
          FreeAndNil(p.ObjPtr);
        end;
      acZOrder: Page.Objects[p.Int] := p.ObjPtr;
    end;
    p1 := p;
    p := p.Next;
    p1.Free;
  end;

  if Buffer = @FUndoBuffer then
    Dec(FUndoBufferLength) else
    Dec(FRedoBufferLength);

  ResetSelection;
  RedrawPage;
  UndoMnu.Enabled := FUndoBufferLength > 0;
  UndoBtn.Enabled := UndoMnu.Enabled;
  RedoMnu.Enabled := FRedoBufferLength > 0;
  RedoBtn.Enabled := RedoMnu.Enabled;
end;

procedure TfrDesignerForm.AddAction(Buffer: PfrUndoBuffer; a: TfrUndoAction; List: TList);
var
  i: Integer;
  p, p1: TfrUndoObj;
  r: TfrUndoRec1;
  t, t1: TfrView;
  BufferLength: Integer;
begin
  if Buffer = @FUndoBuffer then
    BufferLength := FUndoBufferLength else
    BufferLength := FRedoBufferLength;
  if BufferLength >= MaxUndoBuffer then
  begin
    ReleaseAction(Buffer[0]);
    for i := 0 to MaxUndoBuffer - 2 do
      Buffer^[i] := Buffer^[i + 1];
    BufferLength := MaxUndoBuffer - 1;
  end;
  Buffer[BufferLength].Action := a;
  Buffer[BufferLength].Page := CurPage;
  Buffer[BufferLength].Objects := nil;
  p := nil;
  for i := 0 to List.Count - 1 do
  begin
    r := List[i];
    t := r.ObjPtr;
    p1 := TfrUndoObj.Create;
    p1.Next := nil;
    if Buffer[BufferLength].Objects = nil then
      Buffer[BufferLength].Objects := p1 else
      p.Next := p1;
    p := p1;
    case a of
      acInsert: p.ObjID := t.ID;
      acDelete, acEdit:
        begin
          t1 := frCreateObject(Report, t.Typ, t.ClassName);
          t1.Assign(t);
          t1.ID := t.ID;
          p.ObjID := t.ID;
          p.ObjPtr := t1;
          p.Int := r.Int;
        end;
      acZOrder:
        begin
          p.ObjID := t.ID;
          p.Int := r.Int;
        end;
    end;
    r.Free;
  end;
  if Buffer = @FUndoBuffer then
  begin
    FUndoBufferLength := BufferLength + 1;
    UndoMnu.Enabled := True;
    UndoBtn.Enabled := True;
  end
  else
  begin
    FRedoBufferLength := BufferLength + 1;
    RedoMnu.Enabled := True;
    RedoBtn.Enabled := True;
  end;
  Modified := True;
  FileModified := True;
end;

procedure TfrDesignerForm.AddUndoAction(a: TfrUndoAction);
var
  i: Integer;
  t: TfrView;
  List: TList;
  p: TfrUndoRec1;
begin
  ClearRedoBuffer;
  List := TList.Create;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected or (a = acZOrder) then
    begin
      p := TfrUndoRec1.Create;
      p.ObjPtr := t;
      p.Int := i;
      List.Add(p);
    end;
  end;
  AddAction(@FUndoBuffer, a, List);
  List.Free;
end;

procedure TfrDesignerForm.BeforeChange;
begin
  AddUndoAction(acEdit);
end;

procedure TfrDesignerForm.AfterChange;
begin
  PageView.DrawPage(dmSelection);
  PageView.Draw(TopSelected, 0);
end;

procedure TfrDesignerForm.BringToFrontBtnClick(Sender: TObject); // go up
var
  i, j, n: Integer;
  t: TfrView;
begin
  AddUndoAction(acZOrder);
  n := Page.Objects.Count; i := 0; j := 0;
  while j < n do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      Page.Objects.Extract(t);
      Page.Objects.Add(t);
    end else Inc(i);
    Inc(j);
  end;
  SendBandsToDown;
  RedrawPage;
end;

procedure TfrDesignerForm.SendToBackBtnClick(Sender: TObject); // go down
var
  t: TfrView;
  i, j, n: Integer;
begin
  AddUndoAction(acZOrder);
  n := Page.Objects.Count; j := 0; i := n - 1;
  while j < n do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      Page.Objects.Extract(t);
      Page.Objects.Insert(0, t);
    end else Dec(i);
    Inc(j);
  end;
  SendBandsToDown;
  RedrawPage;
end;

procedure TfrDesignerForm.AddPageBtnClick(Sender: TObject); // add page
begin
  ResetSelection;
  AddPage;
end;

procedure TfrDesignerForm.RemovePageBtnClick(Sender: TObject); // remove page
begin
  if MessageBox(0, 'Remove this page?',
    'Confirm', mb_IconQuestion + mb_YesNo) = mrYes then
    RemovePage(CurPage);
end;

procedure TfrDesignerForm.SelectObjectBtnClick(Sender: TObject);
begin
  ObjRepeat := False;
end;

procedure TfrDesignerForm.InsertRectangleObjectBtnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ObjRepeat := ssShift in Shift;
  PageView.Cursor := crDefault;
end;

procedure TfrDesignerForm.CutBtnClick(Sender: TObject); //cut
begin
  AddUndoAction(acDelete);
  CutToClipboard;
  FirstSelected := nil;
  EnableControls;
  ShowPosition;
  RedrawPage;
end;

procedure TfrDesignerForm.CopyBtnClick(Sender: TObject); //copy
begin
  CopyToClipboard;
  EnableControls;
end;

procedure TfrDesignerForm.PasteBtnClick(Sender: TObject); //paste
var
  i, minx, miny: Integer;
  t, t1: TfrView;
begin
  Unselect;
  SelNum := 0;
  minx := 32767; miny := 32767;
  with ClipBd do
    for i := 0 to Count - 1 do
    begin
      t := Items[i];
      if t.x < minx then minx := t.x;
      if t.y < miny then miny := t.y;
    end;
  for i := 0 to ClipBd.Count - 1 do
  begin
    t := ClipBd.Items[i];
    if t.Typ = gtBand then
      if not (TfrBandType(t.FrameType) in [btMasterHeader..btSubDetailFooter,
        btGroupHeader, btGroupFooter]) and
        CheckBand(TfrBandType(t.FrameType)) then
        continue;
    if PageView.Left < 0 then
      t.x := t.x - minx + ((-PageView.Left) div GridSize * GridSize) else
      t.x := t.x - minx;
    if PageView.Top < 0 then
      t.y := t.y - miny + ((-PageView.Top) div GridSize * GridSize) else
      t.y := t.y - miny;
    Inc(SelNum);
    t1 := frCreateObject(Report, t.Typ, t.ClassName);
    t1.Assign(t);
    if Report.FindObject(t1.Name) <> nil then
      t1.CreateUniqueName;
    Page.Objects.Add(t1);
  end;
  SelectionChanged;
  SendBandsToDown;
  PageView.GetMultipleSelected;
  RedrawPage;
  AddUndoAction(acInsert);
end;

procedure TfrDesignerForm.UndoBtnClick(Sender: TObject); // undo
begin
  Undo(@FUndoBuffer);
end;

procedure TfrDesignerForm.RedoBtnClick(Sender: TObject); // redo
begin
  Undo(@FRedoBuffer);
end;

procedure TfrDesignerForm.SelectAllBtnClick(Sender: TObject); // select all
begin
  PageView.DrawPage(dmSelection);
  SelectAll;
  PageView.GetMultipleSelected;
  PageView.DrawPage(dmSelection);
  SelectionChanged;
end;

procedure TfrDesignerForm.ExitBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrDesignerForm.EDeleteMnuClick(Sender: TObject); // popup delete command
begin
  DeleteObjects;
end;

procedure TfrDesignerForm.EEditObjectMnuClick(Sender: TObject); // popup edit command
begin
  ShowEditor;
end;

procedure TfrDesignerForm.NewBtnClick(Sender: TObject); // create new
var
  w: Word;
begin
  if FileModified then
  begin
    w := MessageBox(0, PChar('Save changes to' + ExtractFileName(CurDocName) + '?'),
      'Confirm', mb_IconQuestion + mb_YesNoCancel);
    if w = mrCancel then Exit;
    if w = mrYes then
    begin
      SaveBtnClick(nil);
      if not WasOk then Exit;
    end;
  end;
  ClearUndoBuffer;
  Report.Pages.Clear;
  Report.Pages.Add;
  CurPage := 0;
  CurDocName := '';
  FileModified := False;
end;

procedure TfrDesignerForm.NewMnuClick(Sender: TObject); // create new from template
var
  frTemplForm :TfrTemplForm;
begin
  frTemplForm := TfrTemplForm.Create(Self);
  try
    with frTemplForm do
      if ShowModal = mrOk then
      begin
        ClearUndoBuffer;
        Report.LoadTemplate(TemplName, nil, nil, True);
        CurDocName := '';
        CurPage := 0; // do all
      end;
  finally
    frTemplForm.Free;
  end;
end;

procedure TfrDesignerForm.OpenBtnClick(Sender: TObject); // open
var
  w: Word;
begin
  w := mrNo;
  if FileModified then
    w := MessageBox(0, PChar('Save changes to ' + ExtractFileName(CurDocName) + '?'), 'Confirm', mb_IconQuestion + mb_YesNoCancel);
  if w = mrCancel then Exit;
  if w = mrYes then
  begin
    SaveBtnClick(nil);
    if not WasOk then Exit;
  end;
  OpenDialog.Filter := 'FireReport form' + ' (*.frf)|*.frf';
  if OpenDialog.Execute then
  begin
    ClearUndoBuffer;
    CurDocName := OpenDialog.FileName;
    Report.LoadFromFile(CurDocName, True);
    FileModified := False;
    CurPage := 0; // do all
  end;
end;

procedure TfrDesignerForm.SaveAsClick(Sender: TObject); // save as
var
  s: string;
  frTemplNewForm :TfrTemplNewForm;
begin
  WasOk := False;
  with SaveDialog do
  begin
    Filter := 'FireReport form' + ' (*.frf)|*.frf|' + 'FireReport template' + ' (*.frt)|*.frt';
    FileName := CurDocName;
    FilterIndex := 1;
    if Execute then
      if FilterIndex = 1 then
      begin
        s := ChangeFileExt(FileName, '.frf');
        Report.SaveToFile(s, True);
        CurDocName := s;
        WasOk := True;
      end
      else
      begin
        s := ExtractFileName(ChangeFileExt(FileName, '.frt'));
        if frTemplateDir <> '' then
          s := frTemplateDir + '\' + s;
        frTemplNewForm := TfrTemplNewForm.Create(Self);
        try
          with frTemplNewForm do
            if ShowModal = mrOk then
            begin
              Report.SaveTemplate(s, Memo.Lines, Image1.Picture.Bitmap);
              WasOk := True;
            end;
        finally
          frTemplNewForm.Free;
        end;
      end;
  end;
end;

procedure TfrDesignerForm.SaveBtnClick(Sender: TObject); // save
begin
  if CurDocName <> '' then
  begin
    Report.SaveToFile(CurDocName, False);
    FileModified := False;
  end
  else
    SaveAsClick(nil);
end;

procedure TfrDesignerForm.PreviewBtnClick(Sender: TObject); // preview
var
  v1, v2: Boolean;
begin
  v1 := InspForm.Visible;
  v2 := Report.ModalPreview;
  InspForm.Hide;
  Application.ProcessMessages;
  Report.ModalPreview := True;
  try
    Report.ShowReport;
  finally
    InspForm.Visible := v1;
    Report.ModalPreview := v2;
    SetFocus;
    DisableDrawing := False;
    CurPage := 0;
  end;
end;

procedure TfrDesignerForm.VariablesListMnuClick(Sender: TObject); // var editor
begin
  if ShowEvEditor(Self) then
  begin
    Modified := True;
    FileModified := True;
  end;
end;

procedure TfrDesignerForm.PageOptionsBtnClick(Sender: TObject); // page setup
var
  w, h, p: Integer;
  frPgoptForm :TfrPgoptForm;
begin
  frPgoptForm := TfrPgoptForm.Create(Self);
  try
    with frPgoptForm, Page do
    begin
      CB1.Checked := PrintToPrevPage;
      CB5.Checked := not UseMargins;
      if pgOr = poPortrait then
        RB1.Checked := True else
        RB2.Checked := True;
      SizesCbo.Items := Prn.PaperNames;
      SizesCbo.ItemIndex := Prn.GetArrayPos(pgSize);
      FrameWidthEdit.Text := ''; E2.Text := '';
      if pgSize = $100 then
      begin
        FrameWidthEdit.Text := IntToStr(pgWidth div 10);
        E2.Text := IntToStr(pgHeight div 10);
      end;
      E3.Text := IntToStr(pgMargins.Left * 5 div 18);
      E4.Text := IntToStr(pgMargins.Top * 5 div 18);
      E5.Text := IntToStr(pgMargins.Right * 5 div 18);
      E6.Text := IntToStr(pgMargins.Bottom * 5 div 18);
      E7.Text := IntToStr(ColGap * 5 div 18);
      Edit1.Text := IntToStr(ColCount);
      WasOk := False;
      if ShowModal = mrOk then
      begin
        Modified := True;
        FileModified := True;
        WasOk := True;
        PrintToPrevPage := CB1.Checked;
        UseMargins := not CB5.Checked;
        if RB1.Checked then
          pgOr := poPortrait else
          pgOr := poLandscape;
        p := Prn.PaperSizes[SizesCbo.ItemIndex];
        w := 0; h := 0;
        if p = $100 then
        try
          w := StrToInt(FrameWidthEdit.Text) * 10; h := StrToInt(E2.Text) * 10;
        except
          on exception do p := 9; // A4
        end;
        try
          pgMargins := Rect(StrToInt(E3.Text) * 18 div 5,
            StrToInt(E4.Text) * 18 div 5,
            StrToInt(E5.Text) * 18 div 5,
            StrToInt(E6.Text) * 18 div 5);
          ColGap := StrToInt(E7.Text) * 18 div 5;
        except
          on exception do
          begin
            pgMargins := Rect(0, 0, 0, 0);
            ColGap := 0;
          end;
        end;
        ColCount := StrToInt(Edit1.Text);
        ChangePaper(p, w, h, pgOr);
        CurPage := CurPage; // for repaint and other
      end;
    end;
  finally
    frPgoptForm.Free;
  end;
end;

procedure TfrDesignerForm.ReportOptionsMnuClick(Sender: TObject); // report setup
var
  frDocOptForm :TfrDocOptForm;
begin
  frDocOptForm := TfrDocOptForm.Create(Self);
  try
    with frDocOptForm do
    begin
      CB1.Checked := not Report.PrintToDefault;
      CB2.Checked := Report.DoublePass;
      if ShowModal = mrOk then
      begin
        Report.PrintToDefault := not CB1.Checked;
        Report.DoublePass := CB2.Checked;
        Report.ChangePrinter(Prn.PrinterIndex, ComB1.ItemIndex);
        Modified := True;
        FileModified := True;
      end;
      CurPage := CurPage;
    end;
  finally
    frDocOptForm.Free;
  end;
end;

procedure TfrDesignerForm.OptionsMnuClick(Sender: TObject); // grid menu
var
  DesOptionsForm: TfrDesOptionsForm;
begin
  DesOptionsForm := TfrDesOptionsForm.Create(Self);
  try
    with DesOptionsForm do
    begin
      CB1.Checked := ShowGrid;
      CB2.Checked := GridAlign;
      case GridSize of
        4: RB1.Checked := True;
        8: RB2.Checked := True;
        18: RB3.Checked := True;
      end;
      if ShapeMode = smFrame then
        RB4.Checked := True else
        RB5.Checked := True;
      case Units of
        ruPixels: RB6.Checked := True;
        ruMM: RB7.Checked := True;
        ruInches: RB8.Checked := True;
      end;
      CB3.Checked := not GrayedButtons;
      CB4.Checked := EditAfterInsert;
      CB5.Checked := ShowBandTitles;
      if ShowModal = mrOk then
      begin
        ShowGrid := CB1.Checked;
        GridAlign := CB2.Checked;
        if RB1.Checked then
          GridSize := 4
        else if RB2.Checked then
          GridSize := 8
        else
          GridSize := 18;
        if RB4.Checked then
          ShapeMode := smFrame else
          ShapeMode := smAll;
        if RB6.Checked then
          Units := ruPixels
        else if RB7.Checked then
          Units := ruMM
        else
          Units := ruInches;
        GrayedButtons := not CB3.Checked;
        EditAfterInsert := CB4.Checked;
        ShowBandTitles := CB5.Checked;
        RedrawPage;
      end;
    end;
  finally
    DesOptionsForm.Free;
  end;
end;

procedure TfrDesignerForm.GridBtnClick(Sender: TObject);
begin
  ShowGrid := GridBtn.Down;
end;

procedure TfrDesignerForm.GridAlignBtnClick(Sender: TObject);
begin
  GridAlign := GridAlignBtn.Down;
end;

procedure TfrDesignerForm.FitToGridBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  AddUndoAction(acEdit);
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      t.x := Round(t.x / GridSize) * GridSize;
      t.y := Round(t.y / GridSize) * GridSize;
      t.dx := Round(t.dx / GridSize) * GridSize;
      t.dy := Round(t.dy / GridSize) * GridSize;
      if t.dx = 0 then t.dx := GridSize;
      if t.dy = 0 then t.dy := GridSize;
    end;
  end;
  RedrawPage;
  ShowPosition;
  PageView.GetMultipleSelected;
end;

procedure TfrDesignerForm.Tab1Change(Sender: TObject);
begin
  CurPage := Tab1.TabIndex;
end;

procedure TfrDesignerForm.EditPopupPopup(Sender: TObject);
var
  i: Integer;
  t, t1: TfrView;
  fl: Boolean;
begin
  DeleteMenuItems(ECutMnu.Parent);
  EnableControls;
  while EditPopup.Items.Count > 7 do
    EditPopup.Items.Delete(7);
  if SelNum = 1 then
    TfrView(Page.Objects[TopSelected]).DefinePopupMenu(Self, EditPopup)
  else if SelNum > 1 then
  begin
    t := Page.Objects[TopSelected];
    fl := True;
    for i := 0 to Page.Objects.Count - 1 do
    begin
      t1 := Page.Objects[i];
      if t1.Selected then
        if not (((t is TfrMemoView) and (t1 is TfrMemoView)) or
          ((t.Typ <> gtAddIn) and (t.Typ = t1.Typ)) or
          ((t.Typ = gtAddIn) and (t.ClassName = t1.ClassName))) then
        begin
          fl := False;
          break;
        end;
    end;
    if fl and not (t.Typ = gtBand) then t.DefinePopupMenu(Self, EditPopup);
  end;

  FillMenuItems(ECutMnu.Parent);
  SetMenuItemBitmap(ECutMnu, CutBtn);
  SetMenuItemBitmap(ECopyMnu, CopyBtn);
  SetMenuItemBitmap(EPasteMnu, PasteBtn);
  SetMenuItemBitmap(ESelectAllMnu, SelectAllBtn);
end;

procedure TfrDesignerForm.ToolbarsMnuClick(Sender: TObject);
begin // toolbars
  RectangleMnu.Checked := RectanglePnl.Visible;
  StandardMnu.Checked := StandardPnl.Visible;
  TextMnu.Checked := TextPnl.Visible;
  ObjectsMnu.Checked := ObjectsPnl.Visible;
  ObjectInspectorMnu.Checked := InspForm.Visible;
  AlignmentMnu.Checked := AlignmentPnl.Visible;
end;

procedure TfrDesignerForm.StandardMnuClick(Sender: TObject);
  procedure SetShow(c: array of TWinControl; i: Integer; b: Boolean);
  begin
    if c[i] is TToolBar then
      with c[i] as TToolBar do
      begin
        Visible := b;
      end
    else
      (c[i] as TForm).Visible := b;
  end;
begin // each toolbar
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    SetShow([RectanglePnl, StandardPnl, TextPnl, ObjectsPnl, AlignmentPnl, InspForm], Tag, Checked);
  end;
end;

procedure TfrDesignerForm.AboutMnuClick(Sender: TObject);
var
  frAboutForm :TfrAboutForm;
begin // about box
  frAboutForm := TfrAboutForm.Create(Self);
  try
    frAboutForm.ShowModal;
  finally
    frAboutForm.Free;
  end;
end;

procedure TfrDesignerForm.Tab1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  GetCursorPos(p);
  if Button = mbRight then
    TrackPopupMenu(PagePopup.Handle,
      TPM_LEFTALIGN or TPM_RIGHTBUTTON, p.X, p.Y, 0, Handle, nil);
end;

{----------------------------------------------------------------------------}
// state storing/retrieving
const
  rsGridShow = 'GridShow';
  rsGridAlign = 'GridAlign';
  rsGridSize = 'GridSize';
  rsUnits = 'Units';
  rsButtons = 'GrayButtons';
  rsEdit = 'EditAfterInsert';
  rsSelection = 'Selection';


procedure TfrDesignerForm.SaveState;
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Nm := rsForm + Name;
  Ini.WriteBool(Nm, rsGridShow, ShowGrid);
  Ini.WriteBool(Nm, rsGridAlign, GridAlign);
  Ini.WriteInteger(Nm, rsGridSize, GridSize);
  Ini.WriteInteger(Nm, rsUnits, Word(Units));
  Ini.WriteBool(Nm, rsButtons, GrayedButtons);
  Ini.WriteBool(Nm, rsEdit, EditAfterInsert);
  Ini.WriteInteger(Nm, rsSelection, Integer(ShapeMode));
  Ini.WriteInteger(Name, rsX, Left);
  Ini.WriteInteger(Name, rsY, Top);
  Ini.WriteInteger(Name, rsWidth, Width);
  Ini.WriteInteger(Name, rsHeight, Height);
  Ini.Free;
  SaveFormPosition(InspForm);
  InspForm.Hide;
end;

procedure TfrDesignerForm.RestoreState;
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Nm := rsForm + Name;
  GridSize := Ini.ReadInteger(Nm, rsGridSize, 4);
  GridAlign := Ini.ReadBool(Nm, rsGridAlign, True);
  ShowGrid := Ini.ReadBool(Nm, rsGridShow, True);
  Units := TfrReportUnits(Ini.ReadInteger(Nm, rsUnits, 0));
//  GrayedButtons := Ini.ReadBool(Nm, rsButtons, False);
  EditAfterInsert := Ini.ReadBool(Nm, rsEdit, True);
  ShapeMode := TfrShapeMode(Ini.ReadInteger(Nm, rsSelection, 1));
  Left := Ini.ReadInteger(Name, rsX, Left);
  Top := Ini.ReadInteger(Name, rsY, Top);
  Width := Ini.ReadInteger(Name, rsWidth, Width);
  Height := Ini.ReadInteger(Name, rsHeight, Height);
  Ini.Free;
  RestoreFormPosition(InspForm);
  InspForm.Panel1.Show;
end;


{----------------------------------------------------------------------------}
// menu bitmaps

procedure TfrDesignerForm.SetMenuBitmaps;
begin
  MaxItemWidth := 0; MaxShortCutWidth := 0;
  FillMenuItems(FileMnu);
  FillMenuItems(EditMnu);
  FillMenuItems(ToolsMnu);
  FillMenuItems(HelpMnu);

  SetMenuItemBitmap(NewMnu, NewBtn);
  SetMenuItemBitmap(OpenMnu, OpenBtn);
  SetMenuItemBitmap(SaveMnu, SaveBtn);
  SetMenuItemBitmap(PreviewMnu, PreviewBtn);

  SetMenuItemBitmap(UndoMnu, UndoBtn);
  SetMenuItemBitmap(RedoMnu, RedoBtn);
  SetMenuItemBitmap(CutMnu, CutBtn);
  SetMenuItemBitmap(CopyMnu, CopyBtn);
  SetMenuItemBitmap(PasteMnu, PasteBtn);
  SetMenuItemBitmap(SelectAllMnu, SelectAllBtn);
  SetMenuItemBitmap(AddPageMnu, AddPageBtn);
  SetMenuItemBitmap(RemovePageMnu, RemovePageBtn);
  SetMenuItemBitmap(BringToFrontMnu, BringToFrontBtn);
  SetMenuItemBitmap(SendToBackMnu, SendToBackBtn);
{  for i := 0 to AddinToolsMnu.Count - 1 do
    SetMenuItemBitmap(AddinToolsMnu.Items[i], ToolsPnl.Controls[i + 1] as TToolButton);}

  SetMenuItemBitmap(N41, AddPageBtn);
  SetMenuItemBitmap(N43, RemovePageBtn);
  SetMenuItemBitmap(N44, PageOptionsBtn);
end;

function TfrDesignerForm.FindMenuItem(AMenuItem: TMenuItem): TfrMenuItemInfo;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to MenuItems.Count - 1 do
    if TfrMenuItemInfo(MenuItems[i]).MenuItem = AMenuItem then
    begin
      Result := TfrMenuItemInfo(MenuItems[i]);
      Exit;
    end;
end;

procedure TfrDesignerForm.SetMenuItemBitmap(AMenuItem: TMenuItem; ABtn: TToolButton);
var
  m: TfrMenuItemInfo;
begin
  m := FindMenuItem(AMenuItem);
  if m = nil then
  begin
    m := TfrMenuItemInfo.Create;
    m.MenuItem := AMenuItem;
    MenuItems.Add(m);
  end;
  m.Btn := ABtn;
  ModifyMenu(AMenuItem.Parent.Handle, AMenuItem.MenuIndex,
    MF_BYPOSITION + MF_OWNERDRAW, AMenuItem.Command, nil);
end;

procedure TfrDesignerForm.FillMenuItems(MenuItem: TMenuItem);
var
  i: Integer;
  m: TMenuItem;
begin
  for i := 0 to MenuItem.Count - 1 do
  begin
    m := MenuItem.Items[i];
    SetMenuItemBitmap(m, nil);
    if m.Count > 0 then FillMenuItems(m);
  end;
end;

procedure TfrDesignerForm.DeleteMenuItems(MenuItem: TMenuItem);
var
  i, j: Integer;
  m: TMenuItem;
begin
  for i := 0 to MenuItem.Count - 1 do
  begin
    m := MenuItem.Items[i];
    for j := 0 to MenuItems.Count - 1 do
      if TfrMenuItemInfo(MenuItems[j]).MenuItem = m then
      begin
        TfrMenuItemInfo(MenuItems[j]).Free;
        MenuItems.Delete(j);
        break;
      end;
  end;
end;

procedure TfrDesignerForm.DoDrawText(Canvas: TCanvas; Caption: string;
  Rect: TRect; Selected, Enabled: Boolean; Flags: Longint);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    if not Enabled then
    begin
      if not Selected then
      begin
        OffsetRect(Rect, 1, 1);
        Font.Color := clBtnHighlight;
        DrawText(Handle, PChar(Caption), Length(Caption), Rect, Flags);
        OffsetRect(Rect, -1, -1);
      end;
      Font.Color := clBtnShadow;
    end;
    DrawText(Handle, PChar(Caption), Length(Caption), Rect, Flags);
  end;
end;

procedure TfrDesignerForm.DrawItem(AMenuItem: TMenuItem; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  GlyphRect: TRect;
  Btn: TToolButton;
  Glyph: TBitmap;
begin
  MaxItemWidth := 0;
  MaxShortCutWidth := 0;
  with ACanvas do
  begin
    if Selected then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText
    end
    else
    begin
      Brush.Color := clMenu;
      Font.Color := clMenuText;
    end;
    if AMenuItem.Caption <> '-' then
    begin
      FillRect(ARect);
      Btn := FindMenuItem(AMenuItem).Btn;
      GlyphRect := Bounds(ARect.Left + 1, ARect.Top + (ARect.Bottom - ARect.Top - 16) div 2, 16, 16);

      if AMenuItem.Checked then
      begin
        Glyph := TBitmap.Create;
        if AMenuItem.RadioItem then
        begin
          Glyph.Handle := LoadBitmap(hInstance, 'FR_RADIO');
          BrushCopy(GlyphRect, Glyph, Rect(0, 0, 16, 16), Glyph.TransparentColor);
        end
        else
        begin
          Glyph.Handle := LoadBitmap(hInstance, 'FR_CHECK');
          Draw(GlyphRect.Left, GlyphRect.Top, Glyph);
        end;
        Glyph.Free;
      end
      else if Btn <> nil then
      begin
        Glyph := TBitmap.Create;
        Glyph.Width := 16; Glyph.Height := 16;
//        Btn.DrawGlyph(Glyph.Canvas, 0, 0, AMenuItem.Enabled);
        BrushCopy(GlyphRect, Glyph, Rect(0, 0, 16, 16), Glyph.TransparentColor);
        Glyph.Free;
      end;
      ARect.Left := GlyphRect.Right + 4;
    end;

    if AMenuItem.Caption <> '-' then
    begin
      OffsetRect(ARect, 0, 2);
      DoDrawText(ACanvas, AMenuItem.Caption, ARect, Selected, AMenuItem.Enabled, DT_LEFT);
      if AMenuItem.ShortCut <> 0 then
      begin
        ARect.Left := StrToInt(ItemWidths.Values[AMenuItem.Parent.Name]) + 6;
        DoDrawText(ACanvas, ShortCutToText(AMenuItem.ShortCut), ARect,
          Selected, AMenuItem.Enabled, DT_LEFT);
      end;
    end
    else
    begin
      Inc(ARect.Top, 4);
      DrawEdge(Handle, ARect, EDGE_ETCHED, BF_TOP);
    end;
  end;
end;

procedure TfrDesignerForm.MeasureItem(AMenuItem: TMenuItem; ACanvas: TCanvas;
  var AWidth, AHeight: Integer);
var
  w: Integer;
begin
  w := ACanvas.TextWidth(AMenuItem.Caption) + 31;
  if MaxItemWidth < w then
    MaxItemWidth := w;
  ItemWidths.Values[AMenuItem.Parent.Name] := IntToStr(MaxItemWidth);

  if AMenuItem.ShortCut <> 0 then
  begin
    w := ACanvas.TextWidth(ShortCutToText(AMenuItem.ShortCut)) + 15;
    if MaxShortCutWidth < w then
      MaxShortCutWidth := w;
  end;

  if frGetWindowsVersion = '98' then
    AWidth := MaxItemWidth else
    AWidth := MaxItemWidth + MaxShortCutWidth;
  if AMenuItem.Caption <> '-' then
    AHeight := 19 else
    AHeight := 10;
end;

procedure TfrDesignerForm.WndProc(var Message: TMessage);
var
  MenuItem: TMenuItem;
  CCanvas: TCanvas;

  function FindItem(ItemId: Integer): TMenuItem;
  begin
    Result := MainMenu.FindItem(ItemID, fkCommand);
    if Result = nil then
      Result := EditPopup.FindItem(ItemID, fkCommand);
    if Result = nil then
      Result := PagePopup.FindItem(ItemID, fkCommand);
  end;

begin
  case Message.Msg of
    WM_COMMAND:
      if EditPopup.DispatchCommand(Message.wParam) or
        PagePopup.DispatchCommand(Message.wParam) then
        Exit;
    WM_INITMENUPOPUP:
      with TWMInitMenuPopup(Message) do
        if EditPopup.DispatchPopup(MenuPopup) or
          PagePopup.DispatchPopup(MenuPopup) then Exit;
    WM_DRAWITEM:
      with PDrawItemStruct(Message.LParam)^ do
      begin
        if (CtlType = ODT_MENU) and (Message.WParam = 0) then
        begin
          MenuItem := FindItem(ItemId);
          if MenuItem <> nil then
          begin
            CCanvas := TControlCanvas.Create;
            with CCanvas do
            begin
              Handle := hDC;
              DrawItem(MenuItem, CCanvas, rcItem, ItemState and ODS_SELECTED <> 0);
              Free;
            end;
            Exit;
          end;
        end;
      end;
    WM_MEASUREITEM:
      with PMeasureItemStruct(Message.LParam)^ do
      begin
        if (CtlType = ODT_MENU) and (Message.WParam = 0) then
        begin
          MenuItem := FindItem(ItemId);
          if MenuItem <> nil then
          begin
            MeasureItem(MenuItem, Canvas, Integer(ItemWidth), Integer(ItemHeight));
            Exit;
          end;
        end;
      end;
  end;
  inherited WndProc(Message);
end;


{----------------------------------------------------------------------------}
// alignment palette

function TfrDesignerForm.GetFirstSelected: TfrView;
begin
  if FirstSelected <> nil then
    Result := FirstSelected else
    Result := Page.Objects[TopSelected];
end;

function TfrDesignerForm.GetLeftObject: Integer;
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  t := Page.Objects[TopSelected];
  x := t.x;
  Result := TopSelected;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      if t.x < x then
      begin
        x := t.x;
        Result := i;
      end;
  end;
end;

function TfrDesignerForm.GetRightObject: Integer;
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  t := Page.Objects[TopSelected];
  x := t.x + t.dx;
  Result := TopSelected;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      if t.x + t.dx > x then
      begin
        x := t.x + t.dx;
        Result := i;
      end;
  end;
end;

function TfrDesignerForm.GetTopObject: Integer;
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  t := Page.Objects[TopSelected];
  y := t.y;
  Result := TopSelected;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      if t.y < y then
      begin
        y := t.y;
        Result := i;
      end;
  end;
end;

function TfrDesignerForm.GetBottomObject: Integer;
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  t := Page.Objects[TopSelected];
  y := t.y + t.dy;
  Result := TopSelected;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      if t.y + t.dy > y then
      begin
        y := t.y + t.dy;
        Result := i;
      end;
  end;
end;

procedure TfrDesignerForm.AlignLeftEdgesBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  x := t.x;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.x := x;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.AlignTopsBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  y := t.y;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.y := y;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.AlignRightEdgesBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  x := t.x + t.dx;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.x := x - t.dx;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.AlignBottomsBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  y := t.y + t.dy;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.y := y - t.dy;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.AlignHorizontalCentersBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  x := t.x + t.dx div 2;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.x := x - t.dx div 2;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.AlignVerticalCentersBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  BeforeChange;
  t := GetFirstSelected;
  y := t.y + t.dy div 2;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
      t.y := y - t.dy div 2;
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.CenterHorizontallyInWindowBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum = 0 then Exit;
  BeforeChange;
  t := Page.Objects[GetLeftObject];
  x := t.x;
  t := Page.Objects[GetRightObject];
  x := x + (t.x + t.dx - x - Page.PrnInfo.Pgw) div 2;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then Dec(t.x, x);
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.CenterVerticallyInWindowBtnClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum = 0 then Exit;
  BeforeChange;
  t := Page.Objects[GetTopObject];
  y := t.y;
  t := Page.Objects[GetBottomObject];
  y := y + (t.y + t.dy - y - Page.PrnInfo.Pgh) div 2;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then Dec(t.y, y);
  end;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.SpaceEquallyHorizontallyBtnClick(Sender: TObject);
var
  s: TStringList;
  i, dx: Integer;
  t: TfrView;
begin
  if SelNum < 3 then Exit;
  BeforeChange;
  s := TStringList.Create;
  s.Sorted := True;
  s.Duplicates := dupAccept;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then s.AddObject(Format('%4.4d', [t.x]), t);
  end;
  dx := (TfrView(s.Objects[s.Count - 1]).x - TfrView(s.Objects[0]).x) div (s.Count - 1);
  for i := 1 to s.Count - 2 do
    TfrView(s.Objects[i]).x := TfrView(s.Objects[i - 1]).x + dx;
  s.Free;
  PageView.GetMultipleSelected;
  RedrawPage;
end;

procedure TfrDesignerForm.SpaceEquallyVerticallyBtnClick(Sender: TObject);
var
  s: TStringList;
  i, dy: Integer;
  t: TfrView;
begin
  if SelNum < 3 then Exit;
  BeforeChange;
  s := TStringList.Create;
  s.Sorted := True;
  s.Duplicates := dupAccept;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then s.AddObject(Format('%4.4d', [t.y]), t);
  end;
  dy := (TfrView(s.Objects[s.Count - 1]).y - TfrView(s.Objects[0]).y) div (s.Count - 1);
  for i := 1 to s.Count - 2 do
    TfrView(s.Objects[i]).y := TfrView(s.Objects[i - 1]).y + dy;
  s.Free;
  PageView.GetMultipleSelected;
  RedrawPage;
end;


{----------------------------------------------------------------------------}
// miscellaneous

function TfrDesignerForm.TopSelected: Integer;
var
  i: Integer;
begin
  Result := Page.Objects.Count - 1;
  for i := Page.Objects.Count - 1 downto 0 do
    if TfrView(Page.Objects[i]).Selected then
    begin
      Result := i;
      break;
    end;
end;

function TfrDesignerForm.CheckBand(Band: TfrBandType): Boolean;
var
  i: Integer;
  t: TfrView;
begin
  Result := False;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Typ = gtBand then
      if Band = TfrBandType(t.FrameType) then
      begin
        Result := True;
        break;
      end;
  end;
end;

function TfrDesignerForm.GetUnusedBand: TfrBandType;
var
  b: TfrBandType;
begin
  Result := btNone;
  for b := btReportTitle to btNone do
    if not CheckBand(b) then
    begin
      Result := b;
      break;
    end;
  if Result = btNone then Result := btMasterData;
end;

procedure TfrDesignerForm.SendBandsToDown;
var
  i, j, n, k: Integer;
  t: TfrView;
begin
  n := Page.Objects.Count;
  j := 0;
  i := n - 1;
  k := 0;
  while j < n do
  begin
    t := Page.Objects[i];
    if t.Typ = gtBand then
    begin
      Page.Objects.Extract(t);
      Page.Objects.Insert(0, t);
      Inc(k);
    end else Dec(i);
    Inc(j);
  end;
  for i := 0 to n - 1 do // sends btOverlay to back
  begin
    t := Page.Objects[i];
    if (t.Typ = gtBand) and (t.FrameType = Integer(btOverlay)) then
    begin
      Page.Objects.Extract(t);
      Page.Objects.Insert(0, t);
      break;
    end;
  end;
  i := 0; j := 0;
  while j < n do // sends btCrossXXX to front
  begin
    t := Page.Objects[i];
    if (t.Typ = gtBand) and
      (TfrBandType(t.FrameType) in [btCrossHeader..btCrossFooter]) then
    begin
      Page.Objects.Extract(t);
      Page.Objects.Insert(k - 1, t);
    end
    else Inc(i);
    Inc(j);
  end;
end;

procedure ClearClipBoard;
var
  t: TfrView;
begin
  if Assigned(ClipBd) then
    with ClipBd do
      while Count > 0 do
      begin
        t := Items[0];
        t.Free; 
        Delete(0);
      end;
end;

procedure TfrDesignerForm.GetRegion;
var
  i: Integer;
  t: TfrView;
  R: HRGN;
begin
  ClipRgn := CreateRectRgn(0, 0, 0, 0);
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.Selected then
    begin
      R := t.GetClipRgn(rtExtended);
      CombineRgn(ClipRgn, ClipRgn, R, RGN_OR);
      DeleteObject(R);
    end;
  end;
  FirstChange := False;
end;

procedure TfrDesignerForm.GetDefaultSize(var dx, dy: Integer);
begin
  dx := 96;
  if GridSize = 18 then dx := 18 * 6;
  dy := 18;
  if GridSize = 18 then dy := 18;
  if LastFontSize in [12, 13] then dy := 20;
  if LastFontSize in [14..16] then dy := 24;
end;


procedure TfrDesignerForm.HelpContentsMnuClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure InitProc;
begin
  frDesignerClass := TfrDesignerForm;

  ClipBd := TList.Create;
  GridBitmap := TBitmap.Create;
  with GridBitmap do
  begin
    Width := 8;
    Height := 8;
  end;
  
  LastFrameType := 0;
  LastFrameWidth := 1;
  LastLineWidth := 2;
  LastFillColor := clNone;
  LastFrameColor := clBlack;
  LastFontColor := clBlack;
  LastFontStyle := 0;
  LastAdjust := 0;
  RegRootKey := 'Software\FireReport\Designer';
end;

procedure FinalProc;
begin
//  frDesigner.Free;
  ClearClipBoard;
  ClipBd.Free;
  GridBitmap.Free;
end;

procedure TfrDesignerForm.FontsCboClick(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  StartEdit;
  if FontsCbo.ItemIndex >= 0 then
    for i := 0 to Page.Objects.Count - 1 do
    begin
      t := Page.Objects[i];
      if t.Selected and (t.Typ <> gtBand) then
        with t do
        begin
          if t is TfrMemoView then
            with t as TfrMemoView do
            begin
              Font.Name := FontsCbo.Text;
              LastFontName := Font.Name;
            end;
        end;
        StopEdit;
    end;
end;

procedure TfrDesignerForm.StartEdit;
begin
  if Busy then
    Abort;
  AddUndoAction(acEdit);
  PageView.DrawPage(dmSelection);
  GetRegion;
end;

procedure TfrDesignerForm.StopEdit;
begin
  PageView.Draw(TopSelected, ClipRgn);
  ActiveControl := nil;
{  if b in [20, 21] then
    SelectionChanged;}
end;

procedure TfrDesignerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveBtnClick(Self);
  Action := caHide;
end;

procedure TfrDesignerForm.FrameWidthUpDownChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  d: Double;
begin
  d := StrToFloat(FrameWidthEdit.Text);
  FrameWidthEdit.Text := FloatToStrF(d, ffGeneral, 2, 2);
  DoClick(FrameWidthEdit);
end;

initialization
  InitProc;
finalization
  FinalProc;
end.

