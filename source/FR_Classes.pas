{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Report classes              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Classes;

interface

{$I FR.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Printers, Controls,
  Forms, StdCtrls, ComCtrls, Dialogs, Menus, Buttons, Contnrs, DB, Variants,
  System.Types, System.UITypes,
  FR_Progress, FR_Preview, FR_Parser, FR_Interpreter, FR_Dataset, FR_DBDataset;

const
// object flags
  flStretched = 1;
  flWordWrap = 2;
  flWordBreak = 4;
  flAutoSize = 8;
  flBandNewPageAfter = 2;
  flBandPrintifSubsetEmpty = 4;
  flBandPageBreak = 8;
  flBandOnFirstPage = $10;
  flBandOnLastPage = $20;
  flBandRepeatHeader = $40;
  flPictCenter = 2;
  flPictRatio = 4;
  flWantHook = $8000;

// object types
  gtMemo = 0;
  gtPicture = 1;
  gtBand = 2;
  gtSubReport = 3;
  gtLine = 4;
  gtAddIn = 10;

// frame types
  frftNone = 0;
  frftRight = 1;
  frftDown = 2;
  frftLeft = 4;
  frftUp = 8;

// text align
  frtaLeft = 0;
  frtaRight = 1;
  frtaCenter = 2;
  frtaVertical = 4;
  frtaMiddle = 8;
  frtaDown = 16;
  frtaLtrReading = 32; //zaher todo
  frtaRtlReading = 64;

type
  TfrDrawMode = (drAll, drCalcHeight, drAfterCalcHeight, drPart);
  TDocMode = (dmDesigning, dmPrinting);
  TfrBandType = (btReportTitle, btReportSummary,
    btPageHeader, btPageFooter,
    btMasterHeader, btMasterData, btMasterFooter,
    btDetailHeader, btDetailData, btDetailFooter,
    btSubDetailHeader, btSubDetailData, btSubDetailFooter,
    btOverlay, btColumnHeader, btColumnFooter,
    btGroupHeader, btGroupFooter,
    btCrossHeader, btCrossData, btCrossFooter, btNone);
  TfrDataSetPosition = (psLocal, psGlobal);
  TfrValueType = (vtNotAssigned, vtDBField, vtOther, vtFRVar);
  TfrPageMode = (pmNormal, pmBuildList);
  TfrBandRecType = (rtShowBand, rtFirst, rtNext);
  TfrRgnType = (rtNormal, rtExtended);
  TfrReportType = (rtSimple, rtMultiple);

  TfrView = class;
  TfrBand = class;
  TfrPage = class;
  TfrReport = class;
  TfrExportFilter = class;
  TfrReportDesigner = class;

  TDetailEvent = procedure(const ParName: string; var ParValue: Variant) of object;
  TEnterRectEvent = procedure(Memo: TStringList; View: TfrView) of object;
  TBeginDocEvent = procedure of object;
  TEndDocEvent = procedure of object;
  TBeginPageEvent = procedure(pgNo: Integer) of object;
  TEndPageEvent = procedure(pgNo: Integer) of object;
  TBeginBandEvent = procedure(Band: TfrBand) of object;
  TEndBandEvent = procedure(Band: TfrBand) of object;
  TProgressEvent = procedure(n: Integer) of object;
  TBeginColumnEvent = procedure(Band: TfrBand) of object;
  TPrintColumnEvent = procedure(ColNo: Integer; var Width: Integer) of object;
  TManualBuildEvent = procedure(Page: TfrPage) of object;

  TfrPrnInfo = record // print info about page size, margins e.t.c
    PPgw, PPgh, Pgw, Pgh: Integer; // page width/height (printer/screen)
    POfx, POfy, Ofx, Ofy: Integer; // offset x/y
    PPw, PPh, Pw, Ph: Integer; // printable width/height
  end;

  TfrPageRec = packed record // for save and load
    R: TRect;
    pgSize: Word;
    pgWidth, pgHeight: Integer;
    pgOr: TPrinterOrientation;
    pgMargins: Boolean;
    PrnInfo: TfrPrnInfo;
    Visible: Boolean;
  end;

  TfrPageInfo = packed class(TObject)
  private
    FStream: TMemoryStream;
    FPage: TfrPage;
  protected
    Info: TfrPageRec;
  public
    constructor Create;
    destructor Destroy; override;
    property R: TRect read Info.R write Info.R;
    property pgSize: Word read Info.pgSize write Info.pgSize;
    property pgWidth: Integer read Info.pgWidth write Info.pgWidth;
    property pgHeight: Integer read Info.pgHeight write Info.pgHeight;
    property pgOr: TPrinterOrientation read Info.pgOr write Info.pgOr;
    property pgMargins: Boolean read Info.pgMargins write Info.pgMargins;
    property PrnInfo: TfrPrnInfo read Info.PrnInfo write Info.PrnInfo;
    property Visible: Boolean read Info.Visible write Info.Visible;
    property Page: TfrPage read FPage;
    property Stream: TMemoryStream read FStream;
  end;

  TfrBandInfo = class(TObject)
  private
    FBand: TfrBand;
    FAction: TfrBandRecType;
  protected
  public
    property Band: TfrBand read FBand write FBand;
    property Action: TfrBandRecType read FAction write FAction;
  end;

  TfrMenuItem = class(TMenuItem)
  public
    frDesigner: TfrReportDesigner;
  end;

  TfrView = class(TObject)
  private
    procedure P1Click(Sender: TObject);
  protected
    SaveX, SaveY, SaveDX, SaveDY: Integer;
    SaveFW: Single;
    BaseName: string;
    Canvas: TCanvas;
    DRect: TRect;
    gapx, gapy: Integer;
    Contents: TStringList;
    FDataSet: TDataSet;
    FField: string;
    olddy: Integer;
    StreamMode: (smDesigning, smPrinting);
    FReport: TfrReport;
    procedure ShowBackGround; virtual;
    procedure ShowFrame; virtual;
    procedure BeginDraw(ACanvas: TCanvas);
    procedure GetBlob(b: TField); virtual;
    procedure OnHook(View: TfrView); virtual;
  public
    Name: string;
    Parent: TfrBand;
    ID: Integer;
    Typ: Byte;
    Selected: Boolean;
    OriginalRect: TRect;
    ScaleX, ScaleY: Double; // used for scaling objects in preview
    OffsX, OffsY: Integer; //
    IsPrinting: Boolean;
    x, y, dx, dy: Integer;
    Flags: Word;
    FrameType: Word; //zaher that not clear
    FrameWidth: Single;
    FrameColor: TColor;
    FrameStyle: Word;
    FillColor: TColor;
    Format: Integer;
    FormatStr: string;
    Visible: WordBool;
    Memo: TStringList;
    constructor Create(AReport: TfrReport); virtual;
    destructor Destroy; override;
    procedure Assign(From: TfrView); virtual;
    procedure CalcGaps; virtual;
    procedure RestoreCoord; virtual;
    procedure Draw(Canvas: TCanvas); virtual; abstract;
    procedure Print(Stream: TStream); virtual;
    procedure ExportData; virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure Resized; virtual;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); virtual;
    function GetClipRgn(rt: TfrRgnType): HRGN; virtual;
    procedure CreateUniqueName;
    procedure SetBounds(Left, Top, Width, Height: Integer);
    property Report: TfrReport read FReport;
  end;

  TfrStretcheable = class(TfrView)
  protected
    ActualHeight: Integer;
    DrawMode: TfrDrawMode;
    function CalcHeight: Integer; virtual; abstract;
    function MinHeight: Integer; virtual; abstract;
    function RemainHeight: Integer; virtual; abstract;
  end;

  TfrMemoView = class(TfrStretcheable)
  private
    FFont: TFont;
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure P4Click(Sender: TObject);
    procedure P5Click(Sender: TObject);
    procedure SetFont(Value: TFont);
  protected
    Streaming: Boolean;
    TextHeight: Integer;
    CurStrNo: Integer;
    Exporting: Boolean;
    procedure ExpandVariables;
    procedure AssignFont(Canvas: TCanvas);
    procedure WrapMemo;
    procedure ShowMemo;
    function CalcWidth(Memo: TStringList): Integer;
    function CalcHeight: Integer; override;
    function MinHeight: Integer; override;
    function RemainHeight: Integer; override;
    procedure GetBlob(b: TField); override;
  public
    Adjust: Integer;
    LineSpacing, CharacterSpacing: Integer;
    constructor Create(AReport: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure Print(Stream: TStream); override;
    procedure ExportData; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
    property Font: TFont read FFont write SetFont;
  end;

  TfrBandView = class(TfrView)
  private
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure P4Click(Sender: TObject);
    procedure P5Click(Sender: TObject);
    procedure P6Click(Sender: TObject);
    function GetBandType: TfrBandType;
    procedure SetBandType(const Value: TfrBandType);
  public
    constructor Create(AReport: TfrReport); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
    function GetClipRgn(rt: TfrRgnType): HRGN; override;
    property BandType: TfrBandType read GetBandType write SetBandType;
    property DataSet: string read FormatStr write FormatStr;
    property GroupCondition: string read FormatStr write FormatStr;
  end;

  TfrSubReportView = class(TfrView)
  public
    SubPage: Integer;
    constructor Create(AReport: TfrReport); override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
  end;

  TfrPictureView = class(TfrView)
  private
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
  protected
    procedure GetBlob(b: TField); override;
    procedure PictureChanged(Sender: TObject);
  public
    Picture: TPicture;
    constructor Create(AReport: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
  end;

  TfrLineView = class(TfrView)
  public
    constructor Create(AReport: TfrReport); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu); override;
    function GetClipRgn(rt: TfrRgnType): HRGN; override;
  end;

  TfrBand = class(TObject)
  private
    Parent: TfrPage;
    View: TfrView;
    Flags: Word;
    Next, Prev: TfrBand;
    SubIndex, MaxY: Integer;
    EOFReached: Boolean;
    EOFArr: array[0..31] of Boolean;
    Positions: array[TfrDatasetPosition] of Integer;
    LastGroupValue: Variant;
    HeaderBand, FooterBand, LastBand: TfrBand;
    Values: TStringList;
    Count: Integer;
    DisableInit: Boolean;
    CalculatedHeight: Integer;
    procedure InitDataSet(Desc: string);
    procedure DoError;
    function CalcHeight: Integer;
    procedure StretchObjects(MaxHeight: Integer);
    procedure UnStretchObjects;
    procedure DrawObject(t: TfrView);
    procedure PrepareSubReports;
    procedure DoSubReports;
    function DrawObjects: Boolean;
    procedure DrawCrossCell(AParent: TfrBand; CurX: Integer);
    procedure DrawCross;
    function CheckPageBreak(y, dy: Integer; PBreak: Boolean): Boolean;
    procedure DrawPageBreak;
    function HasCross: Boolean;
    function DoCalcHeight: Integer;
    procedure DoDraw;
    function Draw: Boolean;
    procedure InitValues;
    procedure DoAggregate;
  public
    x, y, dx, dy, maxdy: Integer;
    Typ: TfrBandType;
    PrintIfSubsetEmpty, NewPageAfter, Stretched, PageBreak, Visible: Boolean;
    Objects: TList;
    Memo, Script: TStringList;
    DataSet: TfrDataSet;
    IsVirtualDS: Boolean;
    VCDataSet: TfrDataSet;
    IsVirtualVCDS: Boolean;
    GroupCondition: string;
    ForceNewPage, ForceNewColumn: Boolean;
    constructor Create(ATyp: TfrBandType; AParent: TfrPage);
    destructor Destroy; override;
  end;

  TfrValue = class
  public
    Typ: TfrValueType;
    OtherKind: Integer; // for vtOther - typ, for vtDBField - format
    DataSet: string; // for vtDBField
    Field: string; // here is an expression for vtOther
    DSet: TDataSet;
  end;

  TfrValues = class(TPersistent)
  private
    FItems: TStringList;
    function GetValue(Index: Integer): TfrValue;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function AddValue: Integer;
    function FindVariable(const s: string): TfrValue;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    procedure Clear;
    property Items: TStringList read FItems write FItems;
    property Objects[Index: Integer]: TfrValue read GetValue;
  end;

  TfrViewList = class(TObjectList)
  private
    function GetItem(Index: Integer): TfrView;
    procedure SetItem(Index: Integer; const Value: TfrView);
  protected
  public
    function Add(frView: TfrView): Integer;
    procedure Insert(Index: Integer; frView: TfrView);
    property Items[Index: Integer]: TfrView read GetItem write SetItem; default;
  end;

  TfrPage = class(TObject)
  private
    Bands: array[TfrBandType] of TfrBand;
    Skip, InitFlag: Boolean;
    CurColumn, LastStaticColumnY, XAdjust: Integer;
    List: TObjectList;
    Mode: TfrPageMode;
    PlayFrom: Integer;
    LastBand: TfrBand;
    ColPos, CurPos: Integer;
    FReport: TfrReport;
    procedure InitReport;
    procedure DoneReport;
    procedure TossObjects;
    procedure PrepareObjects;
    procedure FormPage;
    procedure DoAggregate(a: array of TfrBandType);
    procedure AddRecord(b: TfrBand; rt: TfrBandRecType);
    procedure ClearRecList;
    function PlayRecList: Boolean;
    procedure DrawPageFooters;
    function BandExists(b: TfrBand): Boolean;
    procedure AfterPrint;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure ShowBand(b: TfrBand);
  public
    pgSize, pgWidth, pgHeight: Integer;
    pgMargins: TRect;
    pgOr: TPrinterOrientation;
    PrintToPrevPage, UseMargins: WordBool;
    PrnInfo: TfrPrnInfo;
    ColCount, ColWidth, ColGap: Integer;
    FObjects: TfrViewList;
    RTObjects: TList;
    CurY, CurBottomY: Integer;
    constructor Create(AReport: TfrReport; ASize, AWidth, AHeight: Integer; AOr: TPrinterOrientation);
    destructor Destroy; override;
    function TopMargin: Integer;
    function BottomMargin: Integer;
    function LeftMargin: Integer;
    function RightMargin: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function FindObjectByID(ID: Integer): Integer;
    function FindObject(Name: string): TfrView;
    function FindRTObject(Name: string): TfrView;
    procedure ChangePaper(ASize, AWidth, AHeight: Integer; AOr: TPrinterOrientation);
    procedure ShowBandByName(s: string);
    procedure ShowBandByType(bt: TfrBandType);
    procedure NewPage;
    procedure NewColumn(Band: TfrBand);
    property Report: TfrReport read FReport;
    property Objects: TfrViewList read FObjects;
  end;

  TfrPages = class(TObject)
  private
    FPages: TObjectList;
    FReport: TfrReport;
    function GetCount: Integer;
    function GetPages(Index: Integer): TfrPage;
  public
    constructor Create(AReport: TfrReport);
    destructor Destroy; override;
    procedure Clear;
    procedure Add;
    procedure Delete(Index: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property Pages[Index: Integer]: TfrPage read GetPages; default;
    property Count: Integer read GetCount;
  end;

  TfrEMFPages = class(TObject)
  private
    FPages: TObjectList;
    FReport: TfrReport;
    function GetCount: Integer;
    function GetPages(Index: Integer): TfrPageInfo;
    procedure ExportData(Index: Integer);
    procedure PageToObjects(Index: Integer);
    procedure ObjectsToPage(Index: Integer);
  public
    constructor Create(AReport: TfrReport);
    destructor Destroy; override;
    procedure Clear;
    procedure Draw(Index: Integer; Canvas: TCanvas; DrawRect: TRect);
    procedure Add(APage: TfrPage);
    procedure Insert(Index: Integer; APage: TfrPage);
    procedure Delete(Index: Integer);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    property Pages[Index: Integer]: TfrPageInfo read GetPages; default;
    property Count: Integer read GetCount;
  end;

  TFRVariable = class(TObject)
    Name: string;
    Value: Variant;
  end;

  TfrVariables = class(TObject)
  private
    FList: TObjectList;
    procedure SetVariable(Name: string; Value: Variant);
    function GetVariable(Name: string): Variant;
    procedure SetValue(Index: Integer; Value: Variant);
    function GetValue(Index: Integer): Variant;
    function GetName(Index: Integer): string;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    function IndexOf(Name: string): Integer;
    property Variable[Name: string]: Variant read GetVariable write SetVariable; default;
    property Value[Index: Integer]: Variant read GetValue write SetValue;
    property Name[Index: Integer]: string read GetName;
    property Count: Integer read GetCount;
  end;

  TFileEvent = procedure (FileName:string) of object;

  TfrReport = class(TComponent)
  private
    FPages: TfrPages;
    FEMFPages: TfrEMFPages;
    FVars: TStrings;
    FVal: TfrValues;
    FDataset: TfrDataset;
    FGrayedButtons: Boolean;
    FReportType: TfrReportType;
    FTitle: string;
    FShowProgress: Boolean;
    FModalPreview: Boolean;
    FModifyPrepared: Boolean;
    FPreview: TfrPreview;
    FDesigner: TfrReportDesigner;
    FProgressForm: TfrProgressForm;
    FPreviewButtons: TfrPreviewButtons;
    FInitialZoom: TfrPreviewZoom;
    FOnBeginDoc: TBeginDocEvent;
    FOnEndDoc: TEndDocEvent;
    FOnBeginPage: TBeginPageEvent;
    FOnEndPage: TEndPageEvent;
    FOnBeginBand: TBeginBandEvent;
    FOnEndBand: TEndBandEvent;
    FOnGetValue: TDetailEvent;
    FOnEnterRect: TEnterRectEvent;
    FOnProgress: TProgressEvent;
    FOnFunction: TFunctionEvent;
    FOnBeginColumn: TBeginColumnEvent;
    FOnPrintColumn: TPrintColumnEvent;
    FOnManualBuild: TManualBuildEvent;
    FCurrentFilter: TfrExportFilter;
    FPageNumbers: string;
    FCopies: Integer;
    FCurPage: TfrPage;
    FDocMode: TDocMode;
    FOnLoadFromFile: TFileEvent;
    FOnSaveToFile: TFileEvent;
    FWholeDatasources: Boolean; // current mode
    function FormatValue(V: Variant; Format: Integer;
      const FormatStr: string): string;
    procedure OnGetParsFunction(const name: string; p1, p2, p3: Variant;
      var val: string);
    procedure PrepareDataSets;
    procedure DoTerminate(Sender: TObject);
    procedure BuildBeforeModal(Sender: TObject);
    procedure ExportBeforeModal(Sender: TObject);
    procedure PrintBeforeModal(Sender: TObject);
    function DoPrepareReport: Boolean;
    procedure DoBuildReport; virtual;
    procedure DoPrintReport(PageNumbers: string; Copies: Integer);
    procedure SetPrinterTo(PrnName: string);
    procedure SetVars(Value: TStrings);
    procedure InternalLoadFromFile(FName: string);
    procedure InternalSaveToFile(FName: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoLoadFromFile(AName: string);
    procedure DoSaveToFile(AName: string);
  public
    CanRebuild: Boolean; // true, if report can be rebuilded
    Terminated: Boolean;
    PrintToDefault: WordBool;
    DoublePass: WordBool;
    FinalPass: Boolean;
    FileName: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // service methods
    function FindVariable(Variable: string): Integer;
    procedure GetVariableValue(const s: string; var v: Variant);
    procedure GetVarList(CatNo: Integer; List: TStrings);
    procedure GetCategoryList(List: TStrings);
    function FindObject(Name: string): TfrView;
    // internal events used through report building
    procedure InternalOnEnterRect(Memo: TStringList; View: TfrView);
    procedure InternalOnExportData(View: TfrView);
    procedure InternalOnExportText(x, y: Integer; const text: string; View: TfrView);
    procedure InternalOnGetValue(ParName: string; var ParValue: string);
    procedure InternalOnProgress(Percent: Integer);
    procedure InternalOnBeginColumn(Band: TfrBand);
    procedure InternalOnPrintColumn(ColNo: Integer; var ColWidth: Integer);
    procedure FillQueryParams;
    // load/save methods
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(FName: string; UseDefault: Boolean = False);
    procedure SaveToFile(FName: string; UseDefault: Boolean);
    procedure LoadFromDB(Table: TDataSet; DocN: Integer);
    procedure SaveToDB(Table: TDataSet; DocN: Integer);
    procedure LoadTemplate(fname: string; comm: TStrings;
      Bmp: TBitmap; Load: Boolean);
    procedure SaveTemplate(fname: string; comm: TStrings; Bmp: TBitmap);
    procedure LoadPreparedReport(FName: string);
    procedure SavePreparedReport(FName: string);
    // report manipulation methods
    function DesignReport: Boolean;
    function PrepareReport: Boolean;
    procedure ExportTo(Filter: TClass; FileName: string);
    procedure ShowReport;
    procedure PrintReport(PageNumbers: string = ''; Copies: Integer = 0);
    procedure ShowPreparedReport;
    procedure PrintPreparedReport(PageNumbers: string; Copies: Integer);
    function ChangePrinter(OldIndex, NewIndex: Integer): Boolean;
    procedure EditPreparedReport(PageIndex: Integer);
    //
    property Designer: TfrReportDesigner read FDesigner write FDesigner;
    property Pages: TfrPages read FPages;
    property EMFPages: TfrEMFPages read FEMFPages write FEMFPages;
    property Variables: TStrings read FVars write SetVars;
    property Values: TfrValues read FVal write FVal;
    property DocMode: TDocMode read FDocMode write FDocMode; // current mode
  published
    property Dataset: TfrDataset read FDataset write FDataset;
    property GrayedButtons: Boolean read FGrayedButtons write FGrayedButtons default False;
    property InitialZoom: TfrPreviewZoom read FInitialZoom write FInitialZoom;
    property ModalPreview: Boolean read FModalPreview write FModalPreview default True;
    property ModifyPrepared: Boolean read FModifyPrepared write FModifyPrepared default True;
    property Preview: TfrPreview read FPreview write FPreview;
    property PreviewButtons: TfrPreviewButtons read FPreviewButtons write FPreviewButtons;
    property ReportType: TfrReportType read FReportType write FReportType default rtSimple;
    property ShowProgress: Boolean read FShowProgress write FShowProgress default True;
    property Title: string read FTitle write FTitle;
    property WholeDatasources: Boolean read FWholeDatasources write FWholeDatasources default False;
    property OnBeginDoc: TBeginDocEvent read FOnBeginDoc write FOnBeginDoc;
    property OnEndDoc: TEndDocEvent read FOnEndDoc write FOnEndDoc;
    property OnBeginPage: TBeginPageEvent read FOnBeginPage write FOnBeginPage;
    property OnEndPage: TEndPageEvent read FOnEndPage write FOnEndPage;
    property OnBeginBand: TBeginBandEvent read FOnBeginBand write FOnBeginBand;
    property OnEndBand: TEndBandEvent read FOnEndBand write FOnEndBand;
    property OnGetValue: TDetailEvent read FOnGetValue write FOnGetValue;
    property OnEnterRect: TEnterRectEvent read FOnEnterRect write FOnEnterRect;
    property OnUserFunction: TFunctionEvent read FOnFunction write FOnFunction;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnBeginColumn: TBeginColumnEvent read FOnBeginColumn write FOnBeginColumn;
    property OnPrintColumn: TPrintColumnEvent read FOnPrintColumn write FOnPrintColumn;
    property OnManualBuild: TManualBuildEvent read FOnManualBuild write FOnManualBuild;
    property OnLoadFromFile: TFileEvent read FOnLoadFromFile write FOnLoadFromFile;
    property OnSaveToFile: TFileEvent read FOnSaveToFile write FOnSaveToFile;
  end;

  TfrReportForm = class(TForm)
  public
  end;

  TfrReportDesigner = class(TfrReportForm)
  public
    Report: TfrReport;
    Page: TfrPage;
    Modified: Boolean;
    procedure RegisterObject(vImageIndex: Integer; vImageList:TImageList; const ButtonHint: string; ButtonTag: Integer); virtual; abstract;
    procedure RegisterTool(MenuCaption: string; ButtonBmp: TBitmap; OnClick: TNotifyEvent); virtual; abstract; //zaher remove_it
    procedure BeforeChange; virtual; abstract;
    procedure AfterChange; virtual; abstract;
    procedure RedrawPage; virtual; abstract;
    procedure ShowMemoEditor; virtual; abstract;
    procedure ShowEditor; virtual; abstract;
    function CheckBand(Band: TfrBandType): Boolean; virtual; abstract;
  end;

  TfrReportDesignerClass = class of TfrReportDesigner;

  TfrDataManager = class(TObject)
  public
    procedure LoadFromStream(Stream: TStream); virtual; abstract;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    procedure BeforePreparing; virtual; abstract;
    procedure AfterPreparing; virtual; abstract;
    procedure PrepareDataSet(ds: TDataSet); virtual; abstract;
    function ShowParamsDialog: Boolean; virtual; abstract;
    procedure AfterParamsDialog; virtual; abstract;
  end;

  TfrEditorForm = class(TForm)
  public
    frDesigner: TfrReportDesigner;
    constructor Create(AOwner: TComponent); override;
  end;

  TfrObjEditorForm = class(TfrEditorForm)
  public
    procedure ShowEditor(t: TfrView); virtual;
  end;

  TPropEditorForm = class(TfrEditorForm)
  public
    View: TfrView;
    function ShowEditor: TModalResult; virtual;
  end;

  TfrObjEditorFormClass = class of TfrObjEditorForm;

  TfrExportFilter = class(TObject)
  protected
    Stream: TStream;
    Lines: TObjectList;
    procedure Clear;
  public
    constructor Create(AStream: TStream); virtual;
    destructor Destroy; override;
    procedure OnBeginDoc; virtual;
    procedure OnEndDoc; virtual;
    procedure OnBeginPage; virtual;
    procedure OnEndPage; virtual;
    procedure OnData(x, y: Integer; View: TfrView); virtual;
    procedure OnText(x, y: Integer; const text: string; View: TfrView); virtual;
  end;

  TfrFunctionLibrary = class(TObject)
  public
    List: TStringList;
    constructor Create; virtual;
    destructor Destroy; override;
    function OnFunction(Report: TfrReport; const FName: string; p1, p2, p3: Variant; var val: string): Boolean;
    procedure DoFunction(Report: TfrReport; FNo: Integer; p1, p2, p3: Variant; var val: string); virtual; abstract;
  end;

  TfrCompressor = class(TObject)
  public
    Enabled: Boolean;
    procedure Compress(StreamIn, StreamOut: TStream); virtual;
    procedure DeCompress(StreamIn, StreamOut: TStream); virtual;
  end;

  TfrTextInfo = class(TObject)
  public
    Next: TfrTextInfo;
    X: Integer;
    Text: string[255];
    FontName: string[32];
    FontSize, FontStyle, FontColor, FontCharset, FillColor: Integer;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TfrAddInObjectInfo = record
    ClassRef: TClass;
    EditorForm: TfrObjEditorFormClass;
    ImageIndex: Integer;
    ImageList:TImageList;
    ButtonHint: string;
  end;

  TfrExportFilterInfo = record
    ClassRef: TClass;
    FilterDesc, FilterExt: string;
  end;

  TfrFunctionInfo = record
    FunctionLibrary: TfrFunctionLibrary;
  end;

  TfrToolsInfo = record
    Caption: string;
    ButtonBmp: TBitmap;
    OnClick: TNotifyEvent;
  end;

var
  frDesignerClass: TfrReportDesignerClass = nil;

//  frDesigner: TfrReportDesigner = nil; // designer reference
  frDataManager: TfrDataManager = nil; // data manager reference
  frParser: TfrParser = nil; // parser reference
  frInterpretator: TfrInterpretator = nil; // interpretator reference
  frVariables: TfrVariables = nil; // report variables reference
  frCompressor: TfrCompressor = nil; // compressor reference

//zaher
  CurView: TfrView = nil; // currently proceeded view
  CurBand: TfrBand = nil; // currently proceeded band
  CurPage: TfrPage = nil; // currently proceeded page

  frAddIns: array[0..31] of TfrAddInObjectInfo; // add-in objects
  frAddInsCount: Integer;

  frFilters: array[0..31] of TfrExportFilterInfo; // export filters
  frFiltersCount: Integer;

  frFunctions: array[0..31] of TfrFunctionInfo; // function libraries
  frFunctionsCount: Integer;

  PageNo: Integer = 0; // current page number in Building mode //zaher to report
  frCharset: 0..255; //zaher to report

  DisableDrawing: Boolean = False;
  ShowBandTitles: Boolean = True;

  SMemo: TStringList = nil; // temporary memo used during TfrView drawing

  VHeight: Integer; // used for height calculation of TfrMemoView
  SBmp: TBitmap; // small bitmap used by TfrBandView drawing
  TempBmp: TBitmap; // temporary bitmap used by TfrMemoView
  CurDate, CurTime: TDateTime; // date/time of report starting
      CurValue: Variant; // used for highlighting
  AggrBand: TfrBand; // used for aggregate functions
  CurVariable: string;
  IsColumns: Boolean;
  SavedAllPages: Integer; // number of pages in entire report
  ErrorFlag: Boolean; // error occured through TfrView drawing
  ErrorStr: string; // error description
  SubValue: string; // used in GetValue event handler
  ObjID: Integer = 0;
  HookList: TList;

  // variables used through report building
  PrevY, PrevBottomY, ColumnXAdjust: Integer;
  Append, WasPF: Boolean;

const
  frSpecCount = 9;
  frSpecFuncs: array[0..frSpecCount - 1] of string = ('PAGE#', '',
    'DATE', 'TIME', 'LINE#', 'LINETHROUGH#', 'COLUMN#', 'CURRENT#', 'TOTALPAGES');

  frColors: array[0..15] of TColor =
  (clWhite, clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal,
    clGray, clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua);

  frSpecArr: array[0..frSpecCount - 1] of string =
  (
    'Page#',
    'Expression',
    'Date',
    'Time',
    'Line#',
    'Line through#',
    'Column#',
    'Current line#',
    'TotalPages'
    );

  frBandNames: array[0..21] of string =
  (
    'Report title',
    'Report summary',
    'Page header',
    'Page footer',
    'Master header',
    'Master data',
    'Master footer',
    'Detail header',
    'Detail data',
    'Detail footer',
    'Subdetail header',
    'Subdetail data',
    'Subdetail footer',
    'Overlay',
    'Column header',
    'Column footer',
    'Group header',
    'Group footer',
    'Cross header',
    'Cross data',
    'Cross footer',
    'None'
    );

  BoolStr: array[0..3] of string =
  (
    '0;1',
    'No;Yes',
    '_;x',
    'False;True'
    );

  frDateFormats: array[0..3] of string =
  (
    'mm.dd.yy',
    'mm.dd.yyyy',
    'd mmm yyyy',
    'd mmmm yyyy'
    );

  frTimeFormats: array[0..3] of string =
  (
    'hh:nn:ss',
    'h:nn:ss',
    'hh:nn',
    'h:nn'
    );

function GetBrackedVariable(s: string; var i, j: Integer): string;
function frCreateObject(Report: TfrReport; Typ: Byte; const ClassName: string): TfrView;
procedure frRegisterObject(ClassRef: TClass; ImageIndex: Integer; ImageList:TImageList; const ButtonHint: string; EditorForm: TfrObjEditorFormClass);
procedure frRegisterExportFilter(ClassRef: TClass; const FilterDesc, FilterExt: string);
procedure frRegisterFunctionLibrary(ClassRef: TClass);
function GetDefaultDataSet: TDataSet;

implementation

uses
  JPEG,
  FR_Format, FR_Printer, FR_Utils, FR_Consts,
  FR_Design, FR_Barcodes, FR_Shape, FR_CheckBox, FR_E_RTF, FR_E_TXT, FR_E_HTM, FR_E_CSV;

type
  TfrStdFunctionLibrary = class(TfrFunctionLibrary)
  public
    constructor Create; override;
    procedure DoFunction(Report: TfrReport; FNo: Integer; p1, p2, p3: Variant; var val: string); override;
  end;

  TInterpretator = class(TfrInterpretator)
  public
    procedure GetValue(const Name: string; var Value: Variant); override;
    procedure SetValue(const Name: string; Value: Variant); override;
    procedure DoFunction(const name: string; p1, p2, p3: Variant;
      var val: string); override;
  end;

{----------------------------------------------------------------------------}

function GetBrackedVariable(s: string; var i, j: Integer): string;
var
  c: Integer;
  fl1, fl2: Boolean;
begin
  j := i; fl1 := True; fl2 := True; c := 0;
  Result := '';
  if s = '' then
    Exit;
  Dec(j);
  repeat
    Inc(j);
    if fl1 and fl2 then
      if s[j] = '[' then
      begin
        if c = 0 then
          i := j;
        Inc(c);
      end
      else if s[j] = ']' then
        Dec(c);
    if fl1 then
      if s[j] = '"' then
        fl2 := not fl2;
    if fl2 then
      if s[j] = '''' then
        fl1 := not fl1;
  until (c = 0) or (j >= Length(s));
  Result := Copy(s, i + 1, j - i - 1);
end;

function frCreateObject(Report: TfrReport; Typ: Byte; const ClassName: string): TfrView;
var
  i: Integer;
begin
  Result := nil;
  case Typ of
    gtMemo: Result := TfrMemoView.Create(Report);
    gtPicture: Result := TfrPictureView.Create(Report);
    gtBand: Result := TfrBandView.Create(Report);
    gtSubReport: Result := TfrSubReportView.Create(Report);
    gtLine: Result := TfrLineView.Create(Report);
    gtAddIn:
      begin
        for i := 0 to frAddInsCount - 1 do
          if SameText(frAddIns[i].ClassRef.ClassName, ClassName) then
          begin
            Result := TfrView(frAddIns[i].ClassRef.NewInstance);
            Result.Create(Report);
            Result.Typ := gtAddIn;
            break;
          end;
        if Result = nil then
          raise EClassNotFound.Create('Class not found ' + ClassName);
      end;
  end;
  if Result <> nil then
  begin
    Result.ID := ObjID;
    Inc(ObjID);
  end;
end;

procedure frRegisterObject(ClassRef: TClass; ImageIndex: Integer; ImageList:TImageList; const ButtonHint: string; EditorForm: TfrObjEditorFormClass);
begin
  frAddIns[frAddInsCount].ClassRef := ClassRef;
  frAddIns[frAddInsCount].EditorForm := EditorForm;
  frAddIns[frAddInsCount].ButtonHint := ButtonHint;
  frAddIns[frAddInsCount].ImageIndex := ImageIndex;
  frAddIns[frAddInsCount].ImageList := ImageList;
  Inc(frAddInsCount);
end;

procedure frRegisterExportFilter(ClassRef: TClass;
  const FilterDesc, FilterExt: string);
begin
  frFilters[frFiltersCount].ClassRef := ClassRef;
  frFilters[frFiltersCount].FilterDesc := FilterDesc;
  frFilters[frFiltersCount].FilterExt := FilterExt;
  Inc(frFiltersCount);
end;

procedure frRegisterFunctionLibrary(ClassRef: TClass);
begin
  frFunctions[frFunctionsCount].FunctionLibrary := TfrFunctionLibrary(ClassRef.NewInstance);
  frFunctions[frFunctionsCount].FunctionLibrary.Create;
  Inc(frFunctionsCount);
end;

function Create90Font(Font: TFont): HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := 900;
  F.lfOrientation := 900;
  Result := CreateFontIndirect(F);
end;

function GetDefaultDataSet: TDataSet;
var
  Res: TfrDataset;
begin
  Result := nil; Res := nil;
  if CurBand <> nil then
    case CurBand.Typ of
      btMasterData, btReportSummary, btMasterFooter,
        btGroupHeader, btGroupFooter:
        Res := CurPage.Bands[btMasterData].DataSet;
      btDetailData, btDetailFooter:
        Res := CurPage.Bands[btDetailData].DataSet;
      btSubDetailData, btSubDetailFooter:
        Res := CurPage.Bands[btSubDetailData].DataSet;
      btCrossData, btCrossFooter:
        Res := CurPage.Bands[btCrossData].DataSet;
    end;
  if (Res <> nil) and (Res is TfrDBDataset) then
    Result := TfrDBDataSet(Res).GetDataSet;
end;

function ReadString(Stream: TStream): string;
begin
  Result := frReadString(Stream);
end;

procedure ReadMemo(Stream: TStream; Memo: TStrings);
begin
  frReadMemo(Stream, Memo)
end;

procedure CreateDS(Report: TfrReport; Desc: string; var DataSet: TfrDataSet; var IsVirtualDS: Boolean);
begin
  if (Desc <> '') and CharInSet(Desc[1], ['1'..'9']) then
  begin
    DataSet := TfrUserDataSet.Create(nil);
    DataSet.RangeEnd := reCount;
    DataSet.RangeEndCount := StrToInt(Desc);
    IsVirtualDS := True;
  end
  else
    DataSet := frFindComponent(Report.Owner, Desc) as TfrDataSet;
  if DataSet <> nil then
    DataSet.Init;
end;

{----------------------------------------------------------------------------}

constructor TfrView.Create(AReport: TfrReport);
begin
  inherited Create;
  FReport := AReport;
  Parent := nil;
  Memo := TStringList.Create;
  Contents := TStringList.Create;
  FrameWidth := 1;
  FrameColor := clBlack;
  FillColor := clNone;
  Format := 2 * 256 + Ord(FormatSettings.DecimalSeparator);
  BaseName := 'View';
  Visible := True;
  StreamMode := smDesigning;
  ScaleX := 1; ScaleY := 1;
  OffsX := 0; OffsY := 0;
  Flags := flStretched;
end;

destructor TfrView.Destroy;
begin
  Memo.Free;
  Contents.Free;
  inherited;
end;

procedure TfrView.Assign(From: TfrView);
begin
  Name := From.Name;
  Typ := From.Typ;
  Selected := From.Selected;
  x := From.x; y := From.y; dx := From.dx; dy := From.dy;
  Flags := From.Flags;
  FrameType := From.FrameType;
  FrameWidth := From.FrameWidth;
  FrameColor := From.FrameColor;
  FrameStyle := From.FrameStyle;
  FillColor := From.FillColor;
  Format := From.Format;
  FormatStr := From.FormatStr;
  Visible := From.Visible;
  Memo.Assign(From.Memo);
end;

procedure TfrView.CalcGaps;
var
  bx, by, bx1, by1, wx1, wx2, wy1, wy2: Integer;
begin
  SaveX := x; SaveY := y; SaveDX := dx; SaveDY := dy;
  SaveFW := FrameWidth;
  if FReport.DocMode = dmDesigning then
  begin
    ScaleX := 1; ScaleY := 1;
    OffsX := 0; OffsY := 0;
  end;
  x := Round(x * ScaleX) + OffsX;
  y := Round(y * ScaleY) + OffsY;
  dx := Round(dx * ScaleX);
  dy := Round(dy * ScaleY);

  wx1 := Round((FrameWidth * ScaleX - 1) / 2);
  wx2 := Round(FrameWidth * ScaleX / 2);
  wy1 := Round((FrameWidth * ScaleY - 1) / 2);
  wy2 := Round(FrameWidth * ScaleY / 2);
  FrameWidth := FrameWidth * ScaleX;
  gapx := wx2 + 2; gapy := wy2 div 2 + 1;
  bx := x;
  by := y;
  bx1 := Round((SaveX + SaveDX) * ScaleX + OffsX);
  by1 := Round((SaveY + SaveDY) * ScaleY + OffsY);
  if (FrameType and $1) <> 0 then
    Dec(bx1, wx2);
  if (FrameType and $2) <> 0 then
    Dec(by1, wy2);
  if (FrameType and $4) <> 0 then
    Inc(bx, wx1);
  if (FrameType and $8) <> 0 then
    Inc(by, wy1);
  DRect := Rect(bx, by, bx1 + 1, by1 + 1);
end;

procedure TfrView.RestoreCoord;
begin
  x := SaveX;
  y := SaveY;
  dx := SaveDX;
  dy := SaveDY;
  FrameWidth := SaveFW;
end;

procedure TfrView.ShowBackground;
var
  fp: TColor;
begin
  if DisableDrawing then
    Exit;
  if (FReport.DocMode = dmPrinting) and (FillColor = clNone) then
    Exit;
  fp := FillColor;
  if (FReport.DocMode = dmDesigning) and (fp = clNone) then
    fp := clWhite;
  Canvas.Brush.Color := fp;
  if FReport.DocMode = dmDesigning then
    Canvas.FillRect(DRect)
  else
    Canvas.FillRect(Rect(x, y,
// use calculating coords instead of dx, dy - for best view
      Round((SaveX + SaveDX) * ScaleX + OffsX), Round((SaveY + SaveDY) * ScaleY + OffsY)));
end;

procedure TfrView.ShowFrame;
var
  x1, y1: Integer;
  procedure Line(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;
  procedure Line1(x, y, x1, y1: Integer);
  var
    i, w: Integer;
  begin
    if Canvas.Pen.Style = psSolid then
    begin
      if FrameStyle <> 5 then
      begin
        Canvas.MoveTo(x, y);
        Canvas.LineTo(x1, y1);
      end
      else
      begin
        if x = x1 then
        begin
          Canvas.MoveTo(x - Round(FrameWidth), y);
          Canvas.LineTo(x1 - Round(FrameWidth), y1);
          Canvas.Pen.Color := FillColor;
          Canvas.MoveTo(x, y);
          Canvas.LineTo(x1, y1);
          Canvas.Pen.Color := FrameColor;
          Canvas.MoveTo(x + Round(FrameWidth), y);
          Canvas.LineTo(x1 + Round(FrameWidth), y1);
        end
        else
        begin
          Canvas.MoveTo(x, y - Round(FrameWidth));
          Canvas.LineTo(x1, y1 - Round(FrameWidth));
          Canvas.Pen.Color := FillColor;
          Canvas.MoveTo(x, y);
          Canvas.LineTo(x1, y1);
          Canvas.Pen.Color := FrameColor;
          Canvas.MoveTo(x, y + Round(FrameWidth));
          Canvas.LineTo(x1, y1 + Round(FrameWidth));
        end;
      end
    end
    else
    begin
      Canvas.Brush.Color := FillColor;
      w := Canvas.Pen.Width;
      Canvas.Pen.Width := 1;
      if x = x1 then
        for i := 0 to w - 1 do
        begin
          Canvas.MoveTo(x - w div 2 + i, y);
          Canvas.LineTo(x - w div 2 + i, y1);
        end
      else
        for i := 0 to w - 1 do
        begin
          Canvas.MoveTo(x, y - w div 2 + i);
          Canvas.LineTo(x1, y - w div 2 + i);
        end;
      Canvas.Pen.Width := w;
    end;
  end;
begin
  if DisableDrawing then
    Exit;
  if (FReport.DocMode = dmPrinting) and ((FrameType and $F) = 0) then
    Exit;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Style := psSolid;
    if (dx > 0) and (dy > 0) and (FReport.DocMode = dmDesigning) then
    begin
      Pen.Color := clBlack;
      Pen.Width := 1;
      Line(x, y + 3, 0, -3); Line(x, y, 4, 0);
      Line(x, y + dy - 3, 0, 3); Line(x, y + dy, 4, 0);
      Line(x + dx - 3, y, 3, 0); Line(x + dx, y, 0, 4);
      Line(x + dx - 3, y + dy, 3, 0); Line(x + dx, y + dy, 0, -4);
    end;
    Pen.Color := FrameColor;
    Pen.Width := Round(FrameWidth);
    if FrameStyle <> 5 then
      Pen.Style := TPenStyle(FrameStyle);
// use calculating coords instead of dx, dy - for best view
    x1 := Round((SaveX + SaveDX) * ScaleX + OffsX);
    y1 := Round((SaveY + SaveDY) * ScaleY + OffsY);
    if ((FrameType and $F) = $F) and (FrameStyle = 0) then
      Rectangle(x, y, x1 + 1, y1 + 1)
    else
    begin
      if (FrameType and $1) <> 0 then
        Line1(x1, y, x1, y1);
      if (FrameType and $4) <> 0 then
        Line1(x, y, x, y1);
      if (FrameType and $2) <> 0 then
        Line1(x, y1, x1, y1);
      if (FrameType and $8) <> 0 then
        Line1(x, y, x1, y);
    end;
  end;
end;

procedure TfrView.BeginDraw(ACanvas: TCanvas);
begin
  Canvas := ACanvas;
  CurView := Self;
end;

procedure TfrView.Print(Stream: TStream);
begin
  BeginDraw(Canvas);
  Contents.Assign(Memo);
  Report.InternalOnEnterRect(Contents, Self);

  if not Visible then
    Exit;

  Stream.Write(Typ, 1);
  if Typ = gtAddIn then
    frWriteString(Stream, ClassName);
  SaveToStream(Stream);
end;

procedure TfrView.ExportData;
begin
  Report.InternalOnExportData(Self);
end;

procedure TfrView.LoadFromStream(Stream: TStream);
var
  w: Integer;
begin
  with Stream do
  begin
    if StreamMode = smDesigning then
      Name := ReadString(Stream);
//    Read(x, 30); // this is equal to, but much faster:
    Read(x, 4); Read(y, 4); Read(dx, 4); Read(dy, 4);
    Read(Flags, 2);
    Read(FrameType, 2);
    Read(FrameWidth, 4);
    Read(FrameColor, 4);
    Read(FrameStyle, 2);
    Read(FillColor, 4);
    if StreamMode = smDesigning then
    begin
      Read(Format, 4);
      FormatStr := ReadString(Stream);
    end;
    ReadMemo(Stream, Memo);
    if (StreamMode = smDesigning) then
    begin
      Read(Visible, 2);
    end;
    w := PInteger(@FrameWidth)^;
    if w <= 10 then
      w := w * 1000;
    FrameWidth := w / 1000;
  end;
end;

procedure TfrView.SaveToStream(Stream: TStream);
var
  w: Integer;
  f: Single;
begin
  f := FrameWidth;
  if f <> Int(f) then
    w := Round(FrameWidth * 1000)
  else
    w := Round(f);
  PInteger(@FrameWidth)^ := w;
  with Stream do
  begin
    if StreamMode = smDesigning then
      frWriteString(Stream, Name);
    Write(x, 4); Write(y, 4); Write(dx, 4); Write(dy, 4);
    Write(Flags, 2);
    Write(FrameType, 2);
    Write(FrameWidth, 4);
    Write(FrameColor, 4);
    Write(FrameStyle, 2);
    Write(FillColor, 4);
    if StreamMode = smDesigning then
    begin
      Write(Format, 4);
      frWriteString(Stream, FormatStr);
      frWriteMemo(Stream, Memo);
    end
    else
      frWriteMemo(Stream, Contents);
    if StreamMode = smDesigning then
    begin
      Write(Visible, 2);
    end;
  end;
  FrameWidth := f;
end;

procedure TfrView.Resized;
begin
end;

procedure TfrView.GetBlob(b: TField);
begin
end;

procedure TfrView.OnHook(View: TfrView);
begin
end;

function TfrView.GetClipRgn(rt: TfrRgnType): HRGN;
var
  bx, by, bx1, by1, w1, w2: Integer;
begin
  if FrameStyle = 5 then
  begin
    w1 := Round(FrameWidth * 1.5);
    w2 := Round((FrameWidth - 1) / 2 + FrameWidth);
  end
  else
  begin
    w1 := Round(FrameWidth / 2);
    w2 := Round((FrameWidth - 1) / 2);
  end;
  bx := x; by := y; bx1 := x + dx + 1; by1 := y + dy + 1;
  if (FrameType and $1) <> 0 then
    Inc(bx1, w2);
  if (FrameType and $2) <> 0 then
    Inc(by1, w2);
  if (FrameType and $4) <> 0 then
    Dec(bx, w1);
  if (FrameType and $8) <> 0 then
    Dec(by, w1);
  if rt = rtNormal then
    Result := CreateRectRgn(bx, by, bx1, by1)
  else
    Result := CreateRectRgn(bx - 10, by - 10, bx1 + 10, by1 + 10);
end;

procedure TfrView.CreateUniqueName;
var
  i: Integer;
begin
  Name := '';
  for i := 1 to 10000 do
    if Report.FindObject(BaseName + IntToStr(i)) = nil then
    begin
      Name := BaseName + IntToStr(i);
      Exit;
    end;
end;

procedure TfrView.SetBounds(Left, Top, Width, Height: Integer);
begin
  x := Left;
  y := Top;
  dx := Width;
  dy := Height;
end;

procedure TfrView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
var
  m: TfrMenuItem;
begin
  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := '-';
  Popup.Items.Add(m);

  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Stretched';
  m.OnClick := P1Click;
  m.Checked := (Flags and flStretched) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrView.P1Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flStretched) + Word(Checked);
    end;
    frDesigner.AfterChange;
  end;
end;

{----------------------------------------------------------------------------}

constructor TfrMemoView.Create(AReport: TfrReport);
begin
  inherited;
  Typ := gtMemo;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.Size := 10;
  FFont.Color := clBlack;
  FFont.Charset := frCharset;
  BaseName := 'Memo';
  Flags := flStretched + flWordWrap;
  LineSpacing := 2;
  CharacterSpacing := 0;
end;

destructor TfrMemoView.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TfrMemoView.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TfrMemoView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Font := TfrMemoView(From).Font;
  Adjust := TfrMemoView(From).Adjust;
  LineSpacing := TfrMemoView(From).LineSpacing;
end;

procedure TfrMemoView.ExpandVariables;
var
  i: Integer;
  s: string;
  procedure GetData(var s: string);
  var
    i, j: Integer;
    s1, s2: string;
  begin
    i := 1;
    repeat
      while (i < Length(s)) and (s[i] <> '[') do
        Inc(i);
      s1 := GetBrackedVariable(s, i, j);
      if i <> j then
      begin
        Delete(s, i, j - i + 1);
        s2 := '';
        Report.InternalOnGetValue(s1, s2);
        Insert(s2, s, i);
        Inc(i, Length(s2));
        j := 0;
      end;
    until i = j;
  end;
begin
  Contents.Clear;
  for i := 0 to Memo.Count - 1 do
  begin
    s := Memo[i];
    if Length(s) > 0 then
    begin
      GetData(s);
      Contents.Text := Contents.Text + s;
    end
    else
      Contents.Add('');
  end;
end;

procedure TfrMemoView.AssignFont(Canvas: TCanvas);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;
    if not IsPrinting then
      Font.Height := -Round(Font.Size * 96 / 72 * ScaleY);
  end;
end;


type
  TWordBreaks = string;

const
  gl: set of Char = ['À', 'Å', '¨', 'È', 'Î', 'Ó', 'Û', 'Ý', 'Þ', 'ß'];
//  r_sogl: set of Char = ['Ú', 'Ü'];
  spaces: set of Char = [' ', '.', ',', '-'];

function BreakWord(s: string): TWordBreaks;
var
  i: Integer;
  CanBreak: Boolean;
begin
  Result := '';
  s := UpperCase(s);
  if Length(s) > 4 then
  begin
    i := 2;
    repeat
      CanBreak := False;
      if s[i] in gl then
      begin
        if (s[i + 1] in gl) or (s[i + 2] in gl) then
          CanBreak := True;
      end
      else
      begin
        if not (s[i + 1] in gl) and (s[i + 2] in gl) then
          CanBreak := True;
      end;
      if CanBreak then
        Result := Result + Chr(i);
      Inc(i);
    until i > Length(s) - 2;
  end;
end;

procedure TfrMemoView.WrapMemo;
var
  size, size1, maxwidth: Integer;
  b: TWordBreaks;
  WCanvas: TCanvas;

  procedure OutLine(const str: string);
  var
    n, w: Word;
  begin
    n := Length(str);
    if (n > 0) and (str[n] = #1) then
      w := WCanvas.TextWidth(Copy(str, 1, n - 1))
    else
      w := WCanvas.TextWidth(str);
    SMemo.Add(str + Chr(w div 256) + Chr(w mod 256));
    Inc(size, size1);
  end;

  procedure WrapLine(const s: string);
  var
    i, cur, beg, last: Integer;
    WasBreak, CRLF: Boolean;
  begin
    CRLF := False;
    for i := 1 to Length(s) do
      if s[i] in [#10, #13] then
      begin
        CRLF := True;
        break;
      end;
    last := 1; beg := 1;
    if not CRLF and ((Length(s) <= 1) or (WCanvas.TextWidth(s) <= maxwidth)) then
      OutLine(s + #1)
    else
    begin
      cur := 1;
      while cur <= Length(s) do
      begin
        if s[cur] in [#10, #13] then
        begin
          OutLine(Copy(s, beg, cur - beg) + #1);
          while (cur < Length(s)) and (s[cur] in [#10, #13]) do
            Inc(cur);
          beg := cur; last := beg;
          if s[cur] in [#13, #10] then
            Exit
          else
            continue;
        end;
        if s[cur] <> ' ' then
          if WCanvas.TextWidth(Copy(s, beg, cur - beg + 1)) > maxwidth then
          begin
            WasBreak := False;
            if (Flags and flWordBreak) <> 0 then
            begin
              i := cur;
              while (i <= Length(s)) and not (s[i] in spaces) do
                Inc(i);
              b := BreakWord(Copy(s, last + 1, i - last - 1));
              if Length(b) > 0 then
              begin
                i := 1;
                cur := last;
                while (i <= Length(b)) and
                  (WCanvas.TextWidth(Copy(s, beg, last - beg + 1 + Ord(b[i])) + '-') <= maxwidth) do
                begin
                  WasBreak := True;
                  cur := last + Ord(b[i]);
                  Inc(i);
                end;
                last := cur;
              end;
            end
            else if last = beg then
              last := cur;
            if WasBreak then
              OutLine(Copy(s, beg, last - beg + 1) + '-')
            else if s[last] = ' ' then
              OutLine(Copy(s, beg, last - beg))
            else
              OutLine(Copy(s, beg, last - beg + 1));
            if ((Flags and flWordBreak) <> 0) and not WasBreak and (last = cur) then
            begin
              beg := cur + 1;
              cur := Length(s);
              break;
            end;
            if (Flags and flWordBreak) = 0 then
              if last = cur then
              begin
                beg := cur;
                break;
              end;
            beg := last + 1; last := beg;
          end;
        if s[cur] in spaces then
          last := cur;
        Inc(cur);
      end;
      if beg <> cur then
        OutLine(Copy(s, beg, cur - beg + 1) + #1);
    end;
  end;

  procedure OutMemo;
  var
    i: Integer;
  begin
    size := y + gapy;
    size1 := -WCanvas.Font.Height + LineSpacing;
    maxwidth := dx - gapx - gapx;
    for i := 0 to Contents.Count - 1 do
      if (Flags and flWordWrap) <> 0 then
        WrapLine(Contents[i])
      else
        OutLine(Contents[i] + #1);
    VHeight := size - y + gapy;
    TextHeight := size1;
  end;

  procedure OutMemo90;
  var
    i: Integer;
    h, oldh: HFont;
  begin
    h := Create90Font(WCanvas.Font);
    oldh := SelectObject(WCanvas.Handle, h);
    size := x + gapx;
    size1 := -WCanvas.Font.Height + LineSpacing;
    maxwidth := dy - gapy - gapy;
    for i := 0 to Contents.Count - 1 do
      if (Flags and flWordWrap) <> 0 then
        WrapLine(Contents[i])
      else
        OutLine(Contents[i]);
    SelectObject(WCanvas.Handle, oldh);
    DeleteObject(h);
    VHeight := size - x + gapx;
    TextHeight := size1;
  end;

begin
  WCanvas := TempBmp.Canvas;
  WCanvas.Font.Assign(Font);
  WCanvas.Font.Height := -Round(Font.Size * 96 / 72);
  SetTextCharacterExtra(WCanvas.Handle, CharacterSpacing);
  SMemo.Clear;
  if (Adjust and $4) <> 0 then
    OutMemo90
  else
    OutMemo;
end;

var
  DxArray: array[0..2047] of Integer;

procedure TfrMemoView.ShowMemo;
var
  DR: TRect;
  ad, ox, oy: Integer;
  GCP: TGCPRESULTS;

  procedure OutMemo;
  var
    i, cury, th: Integer;

    function OutLine(str: string): Boolean;
    var
      i, n, aw, nw, w, curx: Integer;
      ParaEnd: Boolean;
    begin
      if not Streaming or (cury + th <= DR.Bottom) then
      begin
        n := Length(str);
        w := Ord(str[n - 1]) * 256 + Ord(str[n]);
        SetLength(str, n - 2);
        ParaEnd := True;
        if Length(str) > 0 then
          if str[Length(str)] = #1 then
            SetLength(str, Length(str) - 1)
          else
            ParaEnd := False;

        if Adjust <> 3 then
        begin
          FillChar(GCP, SizeOf(TGCPRESULTS), 0);
          GCP.lStructSize := SizeOf(TGCPRESULTS);
          GCP.lpDx := @DxArray[0];
          GCP.nGlyphs := Length(str);
          AssignFont(Canvas);

          nw := Round(w * ScaleX); // needed width
          while (Canvas.TextWidth(str) > nw) and
            (Canvas.Font.Height < -1) do
            Canvas.Font.Height := Canvas.Font.Height + 1;

          aw := Canvas.TextWidth(str); // actual width

          // preventing Win32 error when printing
          if (aw <> nw) and not Exporting then
            GetCharacterPlacement(Canvas.Handle, PChar(str), Integer(BOOL(Length(str))),
              Integer(BOOL(nw)), GCP, GCP_JUSTIFY + GCP_MAXEXTENT)
          else
            GCP.lpDx := nil;

          if Adjust = 0 then
            curx := x + gapx
          else if Adjust = 1 then
            curx := x + dx - 1 - gapx - nw
          else
            curx := x + gapx + (dx - gapx - gapx - nw) div 2;

          if not Exporting then
          begin
            if Application.UseRightToLeftAlignment then
            begin
              SetTextAlign(Canvas.Handle, TA_RTLREADING);
              ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR, PChar(str), Length(str), nil {PInteger(GCP.lpDx)});
            end
            else
              ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR, PChar(str), Length(str), PInteger(GCP.lpDx));
          end;
        end
        else
        begin
          curx := x + gapx;
          if not Exporting then
          begin
            n := 0;
            for i := 1 to Length(str) do
              if str[i] = ' ' then
                Inc(n);
            if (n <> 0) and not ParaEnd then
              SetTextJustification(Canvas.Handle,
                dx - gapx - gapx - Canvas.TextWidth(str), n);

            ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR, PChar(str), Length(str), nil);
            SetTextJustification(Canvas.Handle, 0, 0);
          end;
        end;
        if Exporting then
          Report.InternalOnExportText(curx, cury, str, Self);
        Inc(CurStrNo);
        Result := False;
      end
      else
        Result := True;
      cury := cury + th;
    end;

  begin
    cury := y + gapy;
    th := -Canvas.Font.Height + Round(LineSpacing * ScaleY);
    CurStrNo := 0;
    for i := 0 to Contents.Count - 1 do
      if OutLine(Contents[i]) then
        break;
  end;

  procedure OutMemo90;
  var
    i, th, curx: Integer;
    h, oldh: HFont;

    procedure OutLine(str: string);
    var
      i, n, cury: Integer;
      ParaEnd: Boolean;
    begin
      SetLength(str, Length(str) - 2);
      if str[Length(str)] = #1 then
      begin
        ParaEnd := True;
        SetLength(str, Length(str) - 1);
      end
      else
        ParaEnd := False;
      cury := 0;
      if Adjust = 4 then
        cury := y + dy - gapy
      else if Adjust = 5 then
        cury := y + gapy + Canvas.TextWidth(str)
      else if Adjust = 6 then
        cury := y + dy - 1 - gapy - (dy - gapy - gapy - Canvas.TextWidth(str)) div 2
      else if not Exporting then
      begin
        cury := y + dy - gapy;
        n := 0;
        for i := 1 to Length(str) do
          if str[i] = ' ' then
            Inc(n);
        if (n <> 0) and not ParaEnd then
          SetTextJustification(Canvas.Handle,
            dy - gapy - gapy - Canvas.TextWidth(str), n);
      end;
      if not Exporting then
      begin
        ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR,
          PChar(str), Length(str), nil);
        if Adjust <> 7 then
          SetTextJustification(Canvas.Handle, 0, 0);
      end;
      if Exporting then
        Report.InternalOnExportText(curx, cury, str, Self);
      Inc(CurStrNo);
      curx := curx + th;
    end;
  begin
    h := Create90Font(Canvas.Font);
    oldh := SelectObject(Canvas.Handle, h);
    curx := x + gapx;
    th := -Canvas.Font.Height + Round(LineSpacing * ScaleY);
    CurStrNo := 0;
    for i := 0 to Contents.Count - 1 do
      OutLine(Contents[i]);
    SelectObject(Canvas.Handle, oldh);
    DeleteObject(h);
  end;

begin
  AssignFont(Canvas);
  SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * ScaleX));
  DR := Rect(DRect.Left + 1, DRect.Top, DRect.Right - 2, DRect.Bottom - 1);
  VHeight := Round(VHeight * ScaleY);
  if (Adjust and $18) <> 0 then
  begin
    ad := Adjust;
    ox := x; oy := y;
    Adjust := Adjust and $7;
    if (ad and $4) <> 0 then
    begin
      if (ad and $18) = $8 then
        x := x + (dx - VHeight) div 2
      else if (ad and $18) = $10 then
        x := x + dx - VHeight;
      OutMemo90;
    end
    else
    begin
      if (ad and $18) = $8 then
        y := y + (dy - VHeight) div 2
      else if (ad and $18) = $10 then
        y := y + dy - VHeight;
      OutMemo;
    end;
    Adjust := ad;
    x := ox; y := oy;
  end
  else if (Adjust and $4) <> 0 then
    OutMemo90
  else
    OutMemo;
end;

function TfrMemoView.CalcWidth(Memo: TStringList): Integer;
var
  CalcRect: TRect;
  s: string;
  n: Integer;
begin
  CalcRect := Rect(0, 0, dx, dy);
  Canvas.Font.Assign(Font);
  Canvas.Font.Height := -Round(Font.Size * 96 / 72);
  s := Memo.Text;
  n := Length(s);
  if n > 2 then
    if (s[n - 1] = #13) and (s[n] = #10) then
      SetLength(s, n - 2);
  SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * ScaleX));
  if Application.UseRightToLeftAlignment then
    DrawText(Canvas.Handle, PChar(s), Length(s), CalcRect, DT_RTLREADING or DT_CALCRECT)
  else
    DrawText(Canvas.Handle, PChar(s), Length(s), CalcRect, DT_CALCRECT);
  Result := CalcRect.Right + Round(2 * FrameWidth) + 2;
end;

procedure TfrMemoView.Draw(Canvas: TCanvas);
var
  NeedWrap: Boolean;
  newdx: Integer;
  OldScaleX, OldScaleY: Double;
begin
  BeginDraw(Canvas);
  if ((Flags and flAutoSize) <> 0) and (Memo.Count > 0) and
    (FReport.DocMode <> dmDesigning) then
  begin
    newdx := CalcWidth(Memo);
    if (Adjust and frtaRight) <> 0 then
    begin
      x := x + dx - newdx;
      dx := newdx;
    end
    else
      dx := newdx;
  end;

  Streaming := False;
  Contents.Assign(Memo);

  OldScaleX := ScaleX; OldScaleY := ScaleY;
  ScaleX := 1; ScaleY := 1;
  CalcGaps;
  ScaleX := OldScaleX; ScaleY := OldScaleY;
  RestoreCoord;
  if Contents.Count > 0 then
  begin
    NeedWrap := Pos(#1, Contents.Text) = 0;
    if Contents[Contents.Count - 1] = #1 then
      Contents.Delete(Contents.Count - 1);
    if NeedWrap then
    begin
      WrapMemo;
      Contents.Assign(SMemo);
    end;
  end;

  CalcGaps;
  if not Exporting then
    ShowBackground;
  if not Exporting then
    ShowFrame;
  if Contents.Count > 0 then
    ShowMemo;
  RestoreCoord;
end;

procedure TfrMemoView.Print(Stream: TStream);
var
  s: string;
  CanExpandVar: Boolean;
  OldFont: TFont;
  OldFill: Integer;
  i: Integer;
begin
  BeginDraw(TempBmp.Canvas);
  Streaming := True;

  CanExpandVar := True;
  if (DrawMode = drAll) and (Assigned(Report.OnEnterRect) or
    ((FDataSet <> nil) and frIsBlob(TField(FDataSet.FindField(FField))))) then
  begin
    Contents.Assign(Memo);
    s := Contents.Text;
    Report.InternalOnEnterRect(Contents, Self);
    if s <> Contents.Text then
      CanExpandVar := False;
  end
  else if DrawMode = drAfterCalcHeight then
    CanExpandVar := False;
  if DrawMode <> drPart then
    if CanExpandVar then
      ExpandVariables;

  if not Visible then
  begin
    DrawMode := drAll;
    Exit;
  end;

  OldFont := TFont.Create;
  OldFont.Assign(Font);
  OldFill := FillColor;
  if DrawMode = drPart then
  begin
    CalcGaps;
    ShowMemo;
    SMemo.Assign(Contents);
    while Contents.Count > CurStrNo do
      Contents.Delete(CurStrNo);
    if Pos(#1, Contents.Text) = 0 then
      Contents.Add(#1);
  end;

  Stream.Write(Typ, 1);
  if Typ = gtAddIn then
    frWriteString(Stream, ClassName);
  SaveToStream(Stream);
  if DrawMode = drPart then
  begin
    Contents.Assign(SMemo);
    for i := 0 to CurStrNo - 1 do
      Contents.Delete(0);
  end;
  Font.Assign(OldFont);
  OldFont.Free;
  FillColor := OldFill;
  DrawMode := drAll;
end;

procedure TfrMemoView.ExportData;
begin
  inherited;
  Exporting := True;
  Draw(TempBmp.Canvas);
  Exporting := False;
end;

function TfrMemoView.CalcHeight: Integer;
var
  s: string;
  CanExpandVar: Boolean;
  OldFont: TFont;
  OldFill: Integer;
begin
  Result := 0;
  DrawMode := drAfterCalcHeight;
  BeginDraw(TempBmp.Canvas);

  if not Visible then
    Exit;

  CanExpandVar := True;
  Contents.Assign(Memo);
  s := Contents.Text;
  Report.InternalOnEnterRect(Contents, Self);
  if s <> Contents.Text then
    CanExpandVar := False;
  if CanExpandVar then
    ExpandVariables;

  OldFont := TFont.Create;
  OldFont.Assign(Font);
  OldFill := FillColor;

  CalcGaps;
  if Contents.Count <> 0 then
  begin
    WrapMemo;
    Result := VHeight;
  end;
  Font.Assign(OldFont);
  OldFont.Free;
  FillColor := OldFill;
end;

function TfrMemoView.MinHeight: Integer;
begin
  Result := TextHeight;
end;

function TfrMemoView.RemainHeight: Integer;
begin
  Result := Contents.Count * TextHeight;
end;

procedure TfrMemoView.LoadFromStream(Stream: TStream);
var
  w: Word;
  i: Integer;
begin
  inherited LoadFromStream(Stream);
  Font.Name := ReadString(Stream);
  with Stream do
  begin
    Read(i, 4);
    Font.Size := i;
    Read(w, 2);
    Font.Style := frSetFontStyle(w);
    Read(i, 4);
    Font.Color := i;
    Read(Adjust, 4);
    Read(w, 2);
    Font.Charset := w;
  end;
end;

procedure TfrMemoView.SaveToStream(Stream: TStream);
var
  i: Integer;
  w: Word;
begin
  inherited SaveToStream(Stream);
  frWriteString(Stream, Font.Name);
  with Stream do
  begin
    i := Font.Size;
    Write(i, 4);
    w := frGetFontStyle(Font.Style);
    Write(w, 2);
    i := Font.Color;
    Write(i, 4);
    Write(Adjust, 4);
    w := Font.Charset;
    Write(w, 2);
  end;
end;

procedure TfrMemoView.GetBlob(b: TField);
begin
  Contents.Assign(b);
end;

procedure TfrMemoView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
var
  m: TfrMenuItem;
begin
  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Variable format...';
  m.OnClick := P1Click;
  Popup.Items.Add(m);

  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Font...';
  m.OnClick := P4Click;
  Popup.Items.Add(m);
  inherited;

  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Word wrap';
  m.OnClick := P2Click;
  m.Checked := (Flags and flWordWrap) <> 0;
  Popup.Items.Add(m);

  m := TfrMenuItem.Create(Popup); //zaher: check may be not all language have wordbreak
  m.frDesigner := frDesigner;
  m.Caption := 'Word Break';
  m.OnClick := P3Click;
  m.Enabled := (Flags and flWordWrap) <> 0;
  if m.Enabled then
    m.Checked := (Flags and flWordBreak) <> 0;
  Popup.Items.Add(m);

  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Auto size';
  m.OnClick := P5Click;
  m.Checked := (Flags and flAutoSize) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrMemoView.P1Click(Sender: TObject);
var
  t: TfrView;
  i: Integer;
  frFmtForm: TfrFmtForm;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    frFmtForm := TfrFmtForm.Create(frDesigner);
    try
      with frFmtForm do
      begin
        Format := Self.Format;
        Edit1.Text := Self.FormatStr;
        if ShowModal = mrOk then
          for i := 0 to frDesigner.Page.Objects.Count - 1 do
          begin
            t := frDesigner.Page.Objects[i];
            if t.Selected then
            begin
              (t as TfrMemoView).Format := Format;
              (t as TfrMemoView).FormatStr := Edit1.Text;
            end;
          end;
      end;
    finally
      frFmtForm.Free;
    end;
  end;
end;

procedure TfrMemoView.P2Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flWordWrap) + Word(Checked) * flWordWrap;
    end;
    frDesigner.AfterChange;
  end;
end;

procedure TfrMemoView.P3Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flWordBreak) + Word(Checked) * flWordBreak;
    end;
    frDesigner.AfterChange;
  end;
end;

procedure TfrMemoView.P4Click(Sender: TObject);
var
  t: TfrView;
  i: Integer;
  fd: TFontDialog;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    fd := TFontDialog.Create(nil);

    with fd do
    begin
      Font.Assign(Self.Font);
      Font.Charset := ARABIC_CHARSET;
      if Execute then
        for i := 0 to frDesigner.Page.Objects.Count - 1 do
        begin
          t := frDesigner.Page.Objects[i];
          if t.Selected then
          begin
            if Font.Name <> Self.Font.Name then
              TfrMemoView(t).Font.Name := Font.Name;
            if Font.Size <> Self.Font.Size then
              TfrMemoView(t).Font.Size := Font.Size;
            if Font.Color <> Self.Font.Color then
              TfrMemoView(t).Font.Color := Font.Color;
            if Font.Style <> Self.Font.Style then
              TfrMemoView(t).Font.Style := Font.Style;
            if Font.Charset <> Self.Font.Charset then
              TfrMemoView(t).Font.Charset := Font.Charset;
          end;
        end;
    end;
    fd.Free;
    frDesigner.AfterChange;
  end;
end;

procedure TfrMemoView.P5Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flAutoSize) + Word(Checked) * flAutoSize;
    end;
    frDesigner.AfterChange;
  end;
end;

{----------------------------------------------------------------------------}

constructor TfrBandView.Create(AReport: TfrReport);
begin
  inherited;
  Typ := gtBand;
  Format := 0;
  BaseName := 'Band';
  Flags := flBandOnFirstPage + flBandOnLastPage;
end;

procedure TfrBandView.Draw(Canvas: TCanvas);
var
  h, oldh: HFont;
begin
  FrameWidth := 1;
  if TfrBandType(FrameType) in [btCrossHeader..btCrossFooter] then
  begin
    y := 0;
    dy := FReport.Designer.Page.PrnInfo.Pgh;
  end
  else
  begin
    x := 0;
    dx := FReport.Designer.Page.PrnInfo.Pgw;
  end;
  BeginDraw(Canvas);
  CalcGaps;
  with Canvas do
  begin
    Brush.Bitmap := SBmp;
    FillRect(DRect);
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Size := 8;
    Font.Color := clBlack;
    Pen.Width := 1;
    Pen.Color := clBtnFace;
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    Rectangle(x, y, x + dx + 1, y + dy + 1);
    Brush.Color := clBtnFace;
    if ShowBandTitles then
      if TfrBandType(FrameType) in [btCrossHeader..btCrossFooter] then
      begin
        FillRect(Rect(x - 18, y, x, y + 100));
        Pen.Color := clBtnShadow;
        MoveTo(x - 18, y + 98); LineTo(x, y + 98);
        Pen.Color := clBlack;
        MoveTo(x - 18, y + 99); LineTo(x, y + 99);
        Pen.Color := clBtnHighlight;
        MoveTo(x - 18, y + 99); LineTo(x - 18, y);
        h := Create90Font(Font);
        oldh := SelectObject(Handle, h);
        TextOut(x - 15, y + 94, frBandNames[FrameType]);
        SelectObject(Handle, oldh);
        DeleteObject(h);
      end
      else
      begin
        FillRect(Rect(x, y - 18, x + 100, y));
        Pen.Color := clBtnShadow;
        MoveTo(x + 98, y - 18); LineTo(x + 98, y);
        Pen.Color := clBlack;
        MoveTo(x + 99, y - 18); LineTo(x + 99, y);
        TextOut(x + 4, y - 17, frBandNames[FrameType]);
      end
    else
    begin
      Brush.Style := bsClear;
      if TfrBandType(FrameType) in [btCrossHeader..btCrossFooter] then
      begin
        h := Create90Font(Font);
        oldh := SelectObject(Handle, h);
        TextOut(x + 2, y + 94, frBandNames[FrameType]);
        SelectObject(Handle, oldh);
        DeleteObject(h);
      end
      else
        TextOut(x + 4, y + 2, frBandNames[FrameType]);
    end;
  end;
end;

function TfrBandView.GetClipRgn(rt: TfrRgnType): HRGN;
var
  R: HRGN;
begin
  if not ShowBandTitles then
  begin
    Result := inherited GetClipRgn(rt);
    Exit;
  end;
  if rt = rtNormal then
    Result := CreateRectRgn(x, y, x + dx + 1, y + dy + 1)
  else
    Result := CreateRectRgn(x - 10, y - 10, x + dx + 10, y + dy + 10);
  if TfrBandType(FrameType) in [btCrossHeader..btCrossFooter] then
    R := CreateRectRgn(x - 18, y, x, y + 100)
  else
    R := CreateRectRgn(x, y - 18, x + 100, y);
  CombineRgn(Result, Result, R, RGN_OR);
  DeleteObject(R);
end;

procedure TfrBandView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
var
  m: TfrMenuItem;
  b: TfrBandType;
begin
  b := TfrBandType(FrameType);
  if b in [btReportTitle, btReportSummary, btPageHeader, btCrossHeader,
    btMasterHeader..btSubDetailFooter, btGroupHeader, btGroupFooter] then
    inherited;

  if b in [btReportTitle, btReportSummary, btMasterData, btDetailData,
    btSubDetailData, btMasterFooter, btDetailFooter,
    btSubDetailFooter, btGroupHeader] then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'Force new page';
    m.OnClick := P1Click;
    m.Checked := (Flags and flBandNewPageAfter) <> 0;
    Popup.Items.Add(m);
  end;

  if b in [btMasterData, btDetailData] then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'Print if detail empty';
    m.OnClick := P2Click;
    m.Checked := (Flags and flBandPrintIfSubsetEmpty) <> 0;
    Popup.Items.Add(m);
  end;

  if b in [btReportTitle, btReportSummary, btMasterHeader..btSubDetailFooter,
    btGroupHeader, btGroupFooter] then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'Breaked';
    m.OnClick := P3Click;
    m.Checked := (Flags and flBandPageBreak) <> 0;
    Popup.Items.Add(m);
  end;

  if b in [btPageHeader, btPageFooter] then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'On first page';
    m.OnClick := P4Click;
    m.Checked := (Flags and flBandOnFirstPage) <> 0;
    Popup.Items.Add(m);
  end;

  if b = btPageFooter then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'On last page';
    m.OnClick := P5Click;
    m.Checked := (Flags and flBandOnLastPage) <> 0;
    Popup.Items.Add(m);
  end;

  if b in [btMasterHeader, btDetailHeader, btSubDetailHeader,
    btCrossHeader, btGroupHeader] then
  begin
    m := TfrMenuItem.Create(Popup);
    m.frDesigner := frDesigner;
    m.Caption := 'Show on all pages';
    m.OnClick := P6Click;
    m.Checked := (Flags and flBandRepeatHeader) <> 0;
    Popup.Items.Add(m);
  end;
end;

procedure TfrBandView.P1Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flBandNewPageAfter) +
          Word(Checked) * flBandNewPageAfter;
    end;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

procedure TfrBandView.P2Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flBandPrintifSubsetEmpty) +
          Word(Checked) * flBandPrintifSubsetEmpty;
    end;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

procedure TfrBandView.P3Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flBandPageBreak) + Word(Checked) * flBandPageBreak;
    end;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

procedure TfrBandView.P4Click(Sender: TObject);
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    Flags := (Flags and not flBandOnFirstPage) + Word(Checked) * flBandOnFirstPage;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

procedure TfrBandView.P5Click(Sender: TObject);
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    Flags := (Flags and not flBandOnLastPage) + Word(Checked) * flBandOnLastPage;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

procedure TfrBandView.P6Click(Sender: TObject);
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    Flags := (Flags and not flBandRepeatHeader) + Word(Checked) * flBandRepeatHeader;
//    frDesigner.AfterChange;//zaher: i added my self
  end;
end;

function TfrBandView.GetBandType: TfrBandType;
begin
  Result := TfrBandType(FrameType);
end;

procedure TfrBandView.SetBandType(const Value: TfrBandType);
begin
  FrameType := Integer(Value);
end;

{----------------------------------------------------------------------------}

constructor TfrSubReportView.Create(AReport: TfrReport);
begin
  inherited;
  Typ := gtSubReport;
  BaseName := 'SubReport';
end;

procedure TfrSubReportView.Assign(From: TfrView);
begin
  inherited Assign(From);
  SubPage := (From as TfrSubReportView).SubPage;
end;

procedure TfrSubReportView.Draw(Canvas: TCanvas);
begin
  BeginDraw(Canvas);
  FrameWidth := 1;
  CalcGaps;
  with Canvas do
  begin
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Size := 8;
    Font.Color := clBlack;
    Font.Charset := frCharset;
    Pen.Width := 1;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Brush.Color := clWhite;
    Rectangle(x, y, x + dx + 1, y + dy + 1);
    Brush.Style := bsClear;
    TextRect(DRect, x + 2, y + 2, 'SubReport on page' + ' ' +
      IntToStr(SubPage + 1));
  end;
  RestoreCoord;
end;

procedure TfrSubReportView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

procedure TfrSubReportView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  Stream.Read(SubPage, 4);
end;

procedure TfrSubReportView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(SubPage, 4);
end;

{----------------------------------------------------------------------------}

constructor TfrPictureView.Create(AReport: TfrReport);
begin
  inherited;
  Typ := gtPicture;
  Picture := TPicture.Create;
  Picture.OnChange := PictureChanged;
  Flags := flStretched + flPictRatio;
  BaseName := 'Picture';
end;

destructor TfrPictureView.Destroy;
begin
  Picture.Free;
  inherited;
end;

procedure TfrPictureView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Picture.Assign(TfrPictureView(From).Picture);
end;

procedure TfrPictureView.Draw(Canvas: TCanvas);
var
  r: TRect;
  kx, ky: Double;
  w, h, w1, h1: Integer;

  procedure PrintBitmap(DestRect: TRect; Bitmap: TBitmap);
  var
    BitmapHeader: pBitmapInfo;
    BitmapImage: Pointer;
    HeaderSize: DWord;
    ImageSize: DWord;
  begin
    GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
    GetMem(BitmapHeader, HeaderSize);
    GetMem(BitmapImage, ImageSize);
    try
      GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
      StretchDIBits(
        Canvas.Handle,
        DestRect.Left, DestRect.Top, // Destination Origin
        DestRect.Right - DestRect.Left, // Destination Width
        DestRect.Bottom - DestRect.Top, // Destination Height
        0, 0, // Source Origin
        Bitmap.Width, Bitmap.Height, // Source Width & Height
        BitmapImage,
        TBitmapInfo(BitmapHeader^),
        DIB_RGB_COLORS,
        SRCCOPY)
    finally
      FreeMem(BitmapHeader);
      FreeMem(BitmapImage)
    end;
  end;

begin
  BeginDraw(Canvas);
  CalcGaps;
  with Canvas do
  begin
    ShowBackground;
    if ((Picture.Graphic = nil) or Picture.Graphic.Empty) and (FReport.DocMode = dmDesigning) then
    begin
      Font.Name := 'Arial';
      Font.Size := 8;
      Font.Style := [];
      Font.Color := clBlack;
      Font.Charset := frCharset;
      TextOut(x + 2, y + 2, 'Center picture');
    end
    else if not ((Picture.Graphic = nil) or Picture.Graphic.Empty) then
    begin
      if (Flags and flStretched) <> 0 then
      begin
        r := DRect;
        if (Flags and flPictRatio) <> 0 then
        begin
          kx := dx / Picture.Width;
          ky := dy / Picture.Height;
          if kx < ky then
            r := Rect(DRect.Left, DRect.Top,
              DRect.Right, DRect.Top + Round(Picture.Height * kx))
          else
            r := Rect(DRect.Left, DRect.Top,
              DRect.Left + Round(Picture.Width * ky), DRect.Bottom);
          w := DRect.Right - DRect.Left;
          h := DRect.Bottom - DRect.Top;
          w1 := r.Right - r.Left;
          h1 := r.Bottom - r.Top;
          if (Flags and flPictCenter) <> 0 then
            OffsetRect(r, (w - w1) div 2, (h - h1) div 2);
        end;
        if IsPrinting and (Picture.Graphic is TBitmap) then
          PrintBitmap(r, Picture.Bitmap)
        else
          StretchDraw(r, Picture.Graphic);
      end
      else
      begin
        r := DRect;
        if (Flags and flPictCenter) <> 0 then
        begin
          w := DRect.Right - DRect.Left;
          h := DRect.Bottom - DRect.Top;
          OffsetRect(r, (w - Picture.Width) div 2, (h - Picture.Height) div 2);
        end;
        Draw(r.Left, r.Top, Picture.Graphic)
      end;
    end;
    ShowFrame;
  end;
  RestoreCoord;
end;

const
  pkNone = 0;
  pkBitmap = 1;
  pkMetafile = 2;
  pkIcon = 3;
  pkJPEG = 4;

procedure TfrPictureView.LoadFromStream(Stream: TStream);
var
  b: Byte;
  n: Integer;
  Graphic: TGraphic;
begin
  inherited;
  Stream.Read(b, 1); //zaher: load first 2 byte to define the extension, nop not in my mind
  Stream.Read(n, 4);
  Graphic := nil;
  case b of
    pkBitmap: Graphic := TBitmap.Create;
    pkMetafile: Graphic := TMetafile.Create;
    pkIcon: Graphic := TIcon.Create;
    pkJPEG: Graphic := TJPEGImage.Create;
  end;
  Picture.Graphic := Graphic;
  if Graphic <> nil then
  begin
    Graphic.Free;
    Picture.Graphic.LoadFromStream(Stream);
  end;
  Stream.Seek(n, soFromBeginning);
end;

procedure TfrPictureView.SaveToStream(Stream: TStream);
var
  b: Byte;
  n, o: Integer;
begin
  inherited SaveToStream(Stream);
  b := pkNone;
  if Picture.Graphic <> nil then
    if Picture.Graphic is TBitmap then
      b := pkBitmap
    else if Picture.Graphic is TMetafile then
      b := pkMetafile
    else if Picture.Graphic is TIcon then
      b := pkIcon
    else if Picture.Graphic is TJPEGImage then
      b := pkJPEG;
  Stream.Write(b, 1);
  n := Stream.Position;
  Stream.Write(n, 4);
  if b <> pkNone then
    Picture.Graphic.SaveToStream(Stream);
  o := Stream.Position;
  Stream.Seek(n, soFromBeginning);
  Stream.Write(o, 4);
  Stream.Seek(0, soFromEnd);
end;

procedure TfrPictureView.GetBlob(b: TField);
var
  aJpeg: TJPEGImage;
  bs: TStream;
begin
  if b.IsNull then
    Picture.Assign(nil)
  else
  begin
{$IFDEF JPEG} //zaher: here my define the extension before assign it
    bs := b.DataSet.CreateBlobStream(b, bmRead);
    if bs.Size = 0 then
      Picture.Assign(nil)
    else
    begin
      aJpeg := TJPEGImage.Create;
      try
        try
          aJpeg.LoadFromStream(bs);
          Picture.Graphic := aJpeg;
        finally
          aJpeg.Free;
        end;
      except
        Picture.Assign(nil);
      end;
    end;
{$ELSE}
    Picture.Assign(b);
{$ENDIF}
  end;
end;

procedure TfrPictureView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
var
  m: TfrMenuItem;
begin
  inherited;
  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Center picture';
  m.OnClick := P1Click;
  m.Checked := (Flags and flPictCenter) <> 0;
  Popup.Items.Add(m);

  m := TfrMenuItem.Create(Popup);
  m.frDesigner := frDesigner;
  m.Caption := 'Keep aspect ratio';
  m.OnClick := P2Click;
  m.Enabled := (Flags and flStretched) <> 0;
  if m.Enabled then
    m.Checked := (Flags and flPictRatio) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrPictureView.P1Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flPictCenter) + Word(Checked) * flPictCenter;
    end;
    frDesigner.AfterChange;
  end;
end;

procedure TfrPictureView.P2Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TfrMenuItem do
  begin
    frDesigner.BeforeChange;
    Checked := not Checked;
    for i := 0 to frDesigner.Page.Objects.Count - 1 do
    begin
      t := frDesigner.Page.Objects[i];
      if t.Selected then
        t.Flags := (t.Flags and not flPictRatio) + Word(Checked) * flPictRatio;
    end;
    frDesigner.AfterChange;
  end;
end;

{----------------------------------------------------------------------------}

constructor TfrLineView.Create(AReport: TfrReport);
begin
  inherited;
  Typ := gtLine;
  FrameType := 4;
  BaseName := 'Line';
end;

procedure TfrLineView.Draw(Canvas: TCanvas);
begin
  BeginDraw(Canvas);
  if dx > dy then
  begin
    dy := 0;
    FrameType := 8;
  end
  else
  begin
    dx := 0;
    FrameType := 4;
  end;
  CalcGaps;
  ShowFrame;
  RestoreCoord;
end;

procedure TfrLineView.DefinePopupMenu(frDesigner: TfrReportDesigner; Popup: TPopupMenu);
begin
  // no specific items in popup menu
end;

function TfrLineView.GetClipRgn(rt: TfrRgnType): HRGN;
var
  bx, by, bx1, by1, dd: Integer;
begin
  bx := x; by := y; bx1 := x + dx + 1; by1 := y + dy + 1;
  if FrameStyle <> 5 then
    dd := Round(FrameWidth / 2)
  else
    dd := Round(FrameWidth * 1.5);
  if FrameType = 4 then
  begin
    Dec(bx, dd);
    Inc(bx1, dd);
  end
  else
  begin
    Dec(by, dd);
    Inc(by1, dd);
  end;
  if rt = rtNormal then
    Result := CreateRectRgn(bx, by, bx1, by1)
  else
    Result := CreateRectRgn(bx - 10, by - 10, bx1 + 10, by1 + 10);
end;

{----------------------------------------------------------------------------}

constructor TfrBand.Create(ATyp: TfrBandType; AParent: TfrPage);
begin
  inherited Create;
  Typ := ATyp;
  Parent := AParent;
  Objects := TList.Create;
  Memo := TStringList.Create;
  Script := TStringList.Create;
  Values := TStringList.Create;
  Next := nil;
  Positions[psLocal] := 1;
  Positions[psGlobal] := 1;
  Visible := True;
end;

destructor TfrBand.Destroy;
begin
  if Next <> nil then
    Next.Free;
  Objects.Free;
  Memo.Free;
  Script.Free;
  Values.Free;
  if DataSet <> nil then
    DataSet.Exit;
  if IsVirtualDS then
    DataSet.Free;
  if VCDataSet <> nil then
    VCDataSet.Exit;
  if IsVirtualVCDS then
    VCDataSet.Free;
  inherited;
end;

procedure TfrBand.InitDataSet(Desc: string);
begin
  if Typ = btGroupHeader then
    GroupCondition := Desc
  else if Pos(';', Desc) = 0 then
    CreateDS(Parent.Report, Desc, DataSet, IsVirtualDS);
  if (Typ = btMasterData) and (Dataset = nil) and
    (Parent.Report.ReportType = rtSimple) then
    DataSet := Parent.Report.Dataset;
end;

procedure TfrBand.DoError;
var
  i: Integer;
begin
  ErrorFlag := True;
  ErrorStr := 'An error occured during calculating';
  for i := 0 to CurView.Memo.Count - 1 do
    ErrorStr := ErrorStr + #13 + CurView.Memo[i];
  ErrorStr := ErrorStr + #13 + 'Report:' + ' ' + Parent.Report.Name +
    #13 + 'Report title' + ' ' + frBandNames[Integer(CurView.Parent.Typ)];
  Parent.Report.Terminated := True;
end;

function TfrBand.CalcHeight: Integer;
var
  Bnd: TfrBand;
  DS: TfrDataSet;
  ddx: Integer;

  function DoCalcHeight(CheckAll: Boolean): Integer;
  var
    i, h: Integer;
    t: TfrView;
  begin
    CurBand := Self;
    AggrBand := Self;
    Result := dy;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      t.olddy := t.dy;
      if t is TfrStretcheable then
        if (t.Parent = Self) or CheckAll then
        begin
          h := TfrStretcheable(t).CalcHeight + t.y;
          if h > Result then
            Result := h;
          if CheckAll then
            TfrStretcheable(t).DrawMode := drAll;
        end
    end;
  end;
begin
  Result := dy;
  if HasCross and (Typ <> btPageFooter) then
  begin
    Parent.ColPos := 1;
    Parent.Report.InternalOnBeginColumn(Self);
    if Parent.BandExists(Parent.Bands[btCrossData]) then
    begin
      Bnd := Parent.Bands[btCrossData];
      if Bnd.DataSet <> nil then
        DS := Bnd.DataSet
      else
        DS := VCDataSet;
      DS.First;
      while not DS.Eof do
      begin
        ddx := 0;
        Parent.Report.InternalOnPrintColumn(Parent.ColPos, ddx);
        CalculatedHeight := DoCalcHeight(True);
        if CalculatedHeight > Result then
          Result := CalculatedHeight;
        Inc(Parent.ColPos);
        DS.Next;
        if Parent.Report.Terminated then
          break;
      end;
    end;
  end
  else
    Result := DoCalcHeight(False);
  CalculatedHeight := Result;
end;

procedure TfrBand.StretchObjects(MaxHeight: Integer);
var
  i: Integer;
  t: TfrView;
begin
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if (t is TfrStretcheable) or (t is TfrLineView) then
      if (t.Flags and flStretched) <> 0 then
        t.dy := MaxHeight - t.y;
  end;
end;

procedure TfrBand.UnStretchObjects;
var
  i: Integer;
  t: TfrView;
begin
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.dy := t.olddy;
  end;
end;

procedure TfrBand.DrawObject(t: TfrView);
var
  ox, oy: Integer;
begin
  CurPage := Parent;
  CurBand := Self;
  AggrBand := Self;
  try
    if (t.Parent = Self) and not DisableDrawing then
    begin
      ox := t.x; Inc(t.x, Parent.XAdjust - Parent.LeftMargin);
      oy := t.y; Inc(t.y, y);
      t.Print(Parent.Report.EMFPages[PageNo].Stream);
      t.x := ox; t.y := oy;
      if (t is TfrMemoView) and (TfrMemoView(t).DrawMode in [drAll, drAfterCalcHeight]) then
        Parent.AfterPrint;
    end;
  except
    on Exception do
      DoError;
  end;
end;

procedure TfrBand.PrepareSubReports;
var
  i: Integer;
  t: TfrView;
  Page: TfrPage;
begin
  for i := SubIndex to Objects.Count - 1 do
  begin
    t := Objects[i];
    Page := Parent.Report.Pages[(t as TfrSubReportView).SubPage];
    Page.Mode := pmBuildList;
    Page.FormPage;
    Page.CurY := y + t.y;
    Page.CurBottomY := Parent.CurBottomY;
    Page.XAdjust := Parent.XAdjust + t.x;
    Page.ColCount := 1;
    Page.PlayFrom := 0;
    EOFArr[i - SubIndex] := False;
  end;
  Parent.LastBand := nil;
end;

procedure TfrBand.DoSubReports;
var
  i: Integer;
  t: TfrView;
  Page: TfrPage;
begin
  repeat
    if not EOFReached then
      for i := SubIndex to Objects.Count - 1 do
      begin
        t := Objects[i];
        Page := Parent.Report.Pages[(t as TfrSubReportView).SubPage];
        Page.CurY := Parent.CurY;
        Page.CurBottomY := Parent.CurBottomY;
      end;
    EOFReached := True;
    MaxY := Parent.CurY;
    for i := SubIndex to Objects.Count - 1 do
      if not EOFArr[i - SubIndex] then
      begin
        t := Objects[i];
        Page := Parent.Report.Pages[(t as TfrSubReportView).SubPage];
        if Page.PlayRecList then
          EOFReached := False
        else
        begin
          EOFArr[i - SubIndex] := True;
          if Page.CurY > MaxY then
            MaxY := Page.CurY;
        end;
      end;
    if not EOFReached then
    begin
      if Parent.Skip then
      begin
        Parent.LastBand := Self;
        Exit;
      end
      else
        Parent.NewPage;
    end;
  until EOFReached or Parent.Report.Terminated;
  for i := SubIndex to Objects.Count - 1 do
  begin
    t := Objects[i];
    Page := Parent.Report.Pages[(t as TfrSubReportView).SubPage];
    Page.ClearRecList;
  end;
  Parent.CurY := MaxY;
  Parent.LastBand := nil;
end;

function TfrBand.DrawObjects: Boolean;
var
  i: Integer;
  t: TfrView;
begin
  Result := False;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t.Typ = gtSubReport then
    begin
      SubIndex := i;
      Result := True;
      PrepareSubReports;
      DoSubReports;
      break;
    end;
    DrawObject(t);
    if Parent.Report.Terminated then
      break;
  end;
end;

procedure TfrBand.DrawCrossCell(AParent: TfrBand; CurX: Integer);
var
  i, sfx, sfy: Integer;
  t: TfrView;
begin
  if DisableDrawing then
    Exit;
  try
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if AParent.Objects.IndexOf(t) <> -1 then
      begin
        sfx := t.x; Inc(t.x, CurX);
        sfy := t.y; Inc(t.y, AParent.y);
        t.Parent := AParent;
        t.Print(Parent.Report.EMFPages[PageNo].Stream);
        if (t is TfrMemoView) and
          (TfrMemoView(t).DrawMode in [drAll, drAfterCalcHeight]) then
          Parent.AfterPrint;
        t.Parent := Self;
        t.x := sfx;
        t.y := sfy;
      end;
    end;
  except
    on Exception do
      DoError;
  end;
end;

procedure TfrBand.DrawCross;
var
  Bnd: TfrBand;
  sfpage: Integer;
  CurX, ddx: Integer;
  DS: TfrDataSet;

  procedure CheckColumnPageBreak(ddx: Integer);
  var
    sfy: Integer;
    b: TfrBand;
  begin
    if CurX + ddx > Parent.RightMargin then
    begin
      Inc(ColumnXAdjust, CurX - Parent.LeftMargin);
      CurX := Parent.LeftMargin;
      Inc(PageNo);
      if PageNo >= Parent.Report.EMFPages.Count then
      begin
        Parent.Report.EMFPages.Add(Parent);
        sfy := Parent.CurY;
        Parent.ShowBand(Parent.Bands[btOverlay]);
        Parent.CurY := Parent.TopMargin;
        if (sfPage <> 0) or
          ((Parent.Bands[btPageHeader].Flags and flBandOnFirstPage) <> 0) then
          Parent.ShowBand(Parent.Bands[btPageHeader]);
        Parent.CurY := sfy;
        Parent.Report.InternalOnProgress(PageNo);
      end;
      if Parent.BandExists(Parent.Bands[btCrossHeader]) then
        if (Parent.Bands[btCrossHeader].Flags and flBandRepeatHeader) <> 0 then
        begin
          b := Parent.Bands[btCrossHeader];
          b.DrawCrossCell(Self, Parent.LeftMargin);
          CurX := Parent.LeftMargin + b.dx;
        end;
    end;
  end;
begin
  ColumnXAdjust := 0;
  Parent.ColPos := 1;
  CurX := 0;
  sfpage := PageNo;
  if Typ = btPageFooter then
    Exit;
  IsColumns := True;
  Parent.Report.InternalOnBeginColumn(Self);
  if Parent.BandExists(Parent.Bands[btCrossHeader]) then
  begin
    Bnd := Parent.Bands[btCrossHeader];
    Bnd.DrawCrossCell(Self, Bnd.x);
    CurX := Bnd.x + Bnd.dx;
  end;
  if Parent.BandExists(Parent.Bands[btCrossData]) then
  begin
    Bnd := Parent.Bands[btCrossData];
    if CurX = 0 then
      CurX := Bnd.x;
    if Bnd.DataSet <> nil then
      DS := Bnd.DataSet
    else
      DS := VCDataSet;
    if DS <> nil then
    begin
      DS.First;
      while not DS.Eof do
      begin
        ddx := Bnd.dx;
        Parent.Report.InternalOnPrintColumn(Parent.ColPos, ddx);
        CheckColumnPageBreak(ddx);
        Bnd.DrawCrossCell(Self, CurX);

        if Typ in [btMasterData, btDetailData, btSubdetailData] then
          Parent.DoAggregate([btPageFooter, btMasterFooter, btDetailFooter,
            btSubDetailFooter, btGroupFooter, btCrossFooter, btReportSummary]);

        Inc(CurX, ddx);
        Inc(Parent.ColPos);
        DS.Next;
        if Parent.Report.Terminated then
          break;
      end;
    end;
  end;
  if Parent.BandExists(Parent.Bands[btCrossFooter]) then
  begin
    Bnd := Parent.Bands[btCrossFooter];
    if CurX = 0 then
      CurX := Bnd.x;
    CheckColumnPageBreak(Bnd.dx);
    AggrBand := Bnd;
    Bnd.DrawCrossCell(Self, CurX);
    Bnd.InitValues;
  end;
  PageNo := sfpage;
  ColumnXAdjust := 0;
  IsColumns := False;
end;

function TfrBand.CheckPageBreak(y, dy: Integer; PBreak: Boolean): Boolean;
begin
  Result := False;
  with Parent do
    if y + Bands[btColumnFooter].dy + dy > CurBottomY then
    begin
      if not PBreak then
        NewColumn(Self);
      Result := True;
    end;
end;

procedure TfrBand.DrawPageBreak;
var
  i: Integer;
  dy, oldy, olddy, maxy: Integer;
  t: TfrView;
  Flag: Boolean;

  procedure CorrY(t: TfrView; dy: Integer);
  var
    i: Integer;
    t1: TfrView;
  begin
    for i := 0 to Objects.Count - 1 do
    begin
      t1 := Objects[i];
      if t1 <> t then
        if (t1.y > t.y + t.dy) and (t1.x >= t.x) and (t1.x <= t.x + t.dx) then
          Inc(t1.y, dy);
    end;
  end;

begin
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.Selected := True;
    t.OriginalRect := Rect(t.x, t.y, t.dx, t.dy);
  end;
  if not CheckPageBreak(y, maxdy, True) then
    DrawObjects
  else
  begin
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t is TfrStretcheable then
        TfrStretcheable(t).ActualHeight := 0;
      if t is TfrMemoView then
      begin
        TfrMemoView(t).CalcHeight; // wraps a memo onto separate lines
        t.Contents.Assign(SMemo);
      end;
    end;
    repeat
      dy := Parent.CurBottomY - Parent.Bands[btColumnFooter].dy - y - 2;
      maxy := 0;
      for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.Selected then
          if (t.y >= 0) and (t.y < dy) then
            if (t.y + t.dy < dy) then
            begin
              if maxy < t.y + t.dy then
                maxy := t.y + t.dy;
              DrawObject(t);
              t.Selected := False;
            end
            else
            begin
              if t is TfrStretcheable then
              begin
                olddy := t.dy;
                t.dy := dy - t.y + 1;
                Inc(TfrStretcheable(t).ActualHeight, t.dy);
                if t.dy > TfrStretcheable(t).MinHeight then
                begin
                  TfrStretcheable(t).DrawMode := drPart;
                  DrawObject(t);
                end;
                t.dy := olddy;
              end
              else
                t.y := dy
            end
          else if t is TfrStretcheable then
            if (t.y < 0) and (t.y + t.dy >= 0) then
              if t.y + t.dy < dy then
              begin
                oldy := t.y; olddy := t.dy;
                t.dy := t.y + t.dy;
                t.y := 0;
                if t.dy > TfrStretcheable(t).MinHeight div 2 then
                begin
                  t.dy := TfrStretcheable(t).RemainHeight + t.gapy * 2 + 1;
                  Inc(TfrStretcheable(t).ActualHeight, t.dy - 1);
                  if maxy < t.y + t.dy then
                    maxy := t.y + t.dy;
                  TfrStretcheable(t).DrawMode := drPart;
                  DrawObject(t);
                end;
                t.y := oldy; t.dy := olddy;
                CorrY(t, TfrStretcheable(t).ActualHeight - t.dy);
                t.Selected := False;
              end
              else
              begin
                oldy := t.y; olddy := t.dy;
                t.y := 0; t.dy := dy;
                Inc(TfrStretcheable(t).ActualHeight, t.dy);
                TfrStretcheable(t).DrawMode := drPart;
                DrawObject(t);
                t.y := oldy; t.dy := olddy;
              end;
      end;
      Flag := False;
      for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.Selected then
          Flag := True;
        Dec(t.y, dy);
      end;
      if Flag then
        CheckPageBreak(y, 10000, False);
      y := Parent.CurY;
      if Parent.Report.Terminated then
        break;
    until not Flag;
    maxdy := maxy;
  end;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.y := t.OriginalRect.Top;
    t.dy := t.OriginalRect.Bottom;
  end;
  Inc(Parent.CurY, maxdy);
end;

function TfrBand.HasCross: Boolean;
var
  i: Integer;
  t: TfrView;
begin
  Result := False;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t.Parent <> Self then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TfrBand.DoDraw;
var
  sfy, sh: Integer;
  UseY, WasSub: Boolean;

begin
  if Objects.Count = 0 then
    Exit;
  sfy := y;
  UseY := not (Typ in [btPageFooter, btOverlay, btNone]);
  if UseY then
    y := Parent.CurY;
  if Stretched then
  begin
    sh := CalculatedHeight;
//    sh := CalcHeight;
    if sh > dy then
      StretchObjects(sh);
    maxdy := sh;
    if not PageBreak then
      CheckPageBreak(y, sh, False);
    y := Parent.CurY;
    WasSub := False;
    if PageBreak then
    begin
      DrawPageBreak;
      sh := 0;
    end
    else
    begin
      WasSub := DrawObjects;
      if HasCross then
        DrawCross;
    end;
    UnStretchObjects;
    if not WasSub then
      Inc(Parent.CurY, sh);
  end
  else
  begin
    if UseY then
    begin
      if not PageBreak then
        CheckPageBreak(y, dy, False);
      y := Parent.CurY;
    end;
    if PageBreak then
    begin
      maxdy := CalculatedHeight;
//      maxdy := CalcHeight;
      DrawPageBreak;
    end
    else
    begin
      WasSub := DrawObjects;
      if HasCross then
        DrawCross;
      if UseY and not WasSub then
        Inc(Parent.CurY, dy);
    end;
  end;
  y := sfy;
  if Typ in [btMasterData, btDetailData, btSubDetailData] then
    Parent.DoAggregate([btPageFooter, btMasterFooter, btDetailFooter,
      btSubDetailFooter, btGroupFooter, btReportSummary]);
end;

function TfrBand.DoCalcHeight: Integer;
var
  b: TfrBand;
begin
  if (Typ in [btMasterData, btDetailData, btSubDetailData]) and
    (Next <> nil) and (Next.Dataset = nil) then
  begin
    b := Self;
    Result := 0;
    repeat
      Result := Result + b.CalcHeight;
      b := b.Next;
    until b = nil;
  end
  else
  begin
    Result := dy;
    CalculatedHeight := dy;
    if Stretched then
      Result := CalcHeight;
  end;
end;

function TfrBand.Draw: Boolean;
var
  b: TfrBand;
begin
  Result := False;
  CurView := View;
  CurBand := Self;
  AggrBand := Self;
  CalculatedHeight := -1;

  ForceNewPage := False;
  ForceNewColumn := False;
  if Assigned(Parent.Report.FOnBeginBand) then
    Parent.Report.FOnBeginBand(Self);
  frInterpretator.DoScript(Script);
// new page was requested in script
  if ForceNewPage then
  begin
    Parent.CurColumn := Parent.ColCount - 1;
    Parent.NewColumn(Self);
  end;
  if ForceNewColumn then
    Parent.NewColumn(Self);

  if Visible then
  begin
    if Typ = btColumnHeader then
      Parent.LastStaticColumnY := Parent.CurY;
    if Typ = btPageFooter then
      y := Parent.CurBottomY;
    if Objects.Count > 0 then
    begin
      if not (Typ in [btPageFooter, btOverlay, btNone]) then
        if (Parent.CurY + DoCalcHeight > Parent.CurBottomY) and not PageBreak then
        begin
          Result := True;
          if Parent.Skip then
            Exit
          else
            CheckPageBreak(0, 10000, False);
        end;
      EOFReached := True;

// dealing with multiple bands
      if (Typ in [btMasterData, btDetailData, btSubDetailData]) and
        (Next <> nil) and (Next.Dataset = nil) and (DataSet <> nil) then
      begin
        b := Self;
        repeat
          b.DoDraw;
          b := b.Next;
        until b = nil;
      end
      else
      begin
        DoDraw;
        if not (Typ in [btMasterData, btDetailData, btSubDetailData, btGroupHeader]) and
          NewPageAfter then
          Parent.NewPage;
      end;
      if not EOFReached then
        Result := True;
    end;
  end
// if band is not visible, just performing aggregate calculations
// relative to it
  else if Typ in [btMasterData, btDetailData, btSubDetailData] then
    Parent.DoAggregate([btPageFooter, btMasterFooter, btDetailFooter,
      btSubDetailFooter, btGroupFooter, btReportSummary]);

// check if multiple pagefooters (in cross-tab report) - resets last of them
  if not DisableInit then
    if (Typ <> btPageFooter) or (PageNo = Parent.Report.EMFPages.Count - 1) then
      InitValues;
  if Assigned(Parent.Report.FOnEndBand) then
    Parent.Report.FOnEndBand(Self);
end;

procedure TfrBand.InitValues;
var
  b: TfrBand;
begin
  if Typ = btGroupHeader then
  begin
    b := Self;
    while b <> nil do
    begin
      if b.FooterBand <> nil then
      begin
        b.FooterBand.Values.Clear;
        b.FooterBand.Count := 0;
      end;
      b.LastGroupValue := frParser.Calc(b.GroupCondition);
      b := b.Next;
    end;
  end
  else
  begin
    Values.Clear;
    Count := 0;
  end
end;

procedure TfrBand.DoAggregate;
var
  i: Integer;
  t: TfrView;
  s: string;
  v: Boolean;
begin
  for i := 0 to Values.Count - 1 do
  begin
    s := Values[i];
    Values[i] := Copy(s, 1, Pos('=', s) - 1) + '=0' + Copy(s, Pos('=', s) + 2, 255);
  end;

  v := Visible;
  Visible := False;
  AggrBand := Self;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    CurView := t;
    if t is TfrMemoView then
      TfrMemoView(t).ExpandVariables;
  end;
  Visible := v;
  Inc(Count);
end;

{----------------------------------------------------------------------------}
type
  TfrBandParts = (bpHeader, bpData, bpFooter);
const
  MAXBNDS = 3;
  Bnds: array[1..MAXBNDS, TfrBandParts] of TfrBandType =
  ((btMasterHeader, btMasterData, btMasterFooter),
    (btDetailHeader, btDetailData, btDetailFooter),
    (btSubDetailHeader, btSubDetailData, btSubDetailFooter));


constructor TfrPage.Create(AReport: TfrReport; ASize, AWidth, AHeight: Integer; AOr: TPrinterOrientation);
begin
  inherited Create;
  FReport := AReport;
  List := TObjectList.Create;
  FObjects := TfrViewList.Create;
  RTObjects := TList.Create;
  ChangePaper(ASize, AWidth, AHeight, AOr);
  PrintToPrevPage := False;
  UseMargins := True;
end;

destructor TfrPage.Destroy;
begin
  FObjects.Free;
  RTObjects.Free;
  List.Free;
  inherited;
end;

procedure TfrPage.ChangePaper(ASize, AWidth, AHeight: Integer;
  AOr: TPrinterOrientation);
begin
  try
    Prn.SetPrinterInfo(ASize, AWidth, AHeight, AOr);
    Prn.FillPrnInfo(PrnInfo);
  except
    on Exception do
    begin
      Prn.SetPrinterInfo($100, AWidth, AHeight, AOr);
      Prn.FillPrnInfo(PrnInfo);
    end;
  end;
  pgSize := Prn.PaperSize;
  pgWidth := Prn.PaperWidth;
  pgHeight := Prn.PaperHeight;
  pgOr := Prn.Orientation;
end;

procedure TfrPage.Clear;
begin
  Objects.Clear;
end;

procedure TfrPage.Delete(Index: Integer);
begin
  Objects.Delete(Index);
end;

function TfrPage.FindObjectByID(ID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Objects.Count - 1 do
    if TfrView(Objects[i]).ID = ID then
    begin
      Result := i;
      break;
    end;
end;

function TfrPage.FindObject(Name: string): TfrView;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Objects.Count - 1 do
    if CompareText(TfrView(Objects[i]).Name, Name) = 0 then
    begin
      Result := Objects[i];
      Exit;
    end;
end;

function TfrPage.FindRTObject(Name: string): TfrView;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to RTObjects.Count - 1 do
    if CompareText(TfrView(RTObjects[i]).Name, Name) = 0 then
    begin
      Result := RTObjects[i];
      Exit;
    end;
end;

procedure TfrPage.InitReport;
var
  b: TfrBandType;
begin
  for b := btReportTitle to btNone do
    Bands[b] := TfrBand.Create(b, Self);
  while RTObjects.Count > 0 do
  begin
    TfrView(RTObjects[0]).Free;
    RTObjects.Delete(0);
  end;
  TossObjects;
  InitFlag := True;
  CurPos := 1; ColPos := 1;
end;

procedure TfrPage.DoneReport;
var
  b: TfrBandType;
begin
  if InitFlag then
  begin
    for b := btReportTitle to btNone do
      Bands[b].Free;
    while RTObjects.Count > 0 do
    begin
      TfrView(RTObjects[0]).Free;
      RTObjects.Delete(0);
    end;
  end;
  InitFlag := False;
end;

function TfrPage.TopMargin: Integer;
begin
  if UseMargins then
    if pgMargins.Top = 0 then
      Result := PrnInfo.Ofy
    else
      Result := pgMargins.Top
  else
    Result := 0;
end;

function TfrPage.BottomMargin: Integer;
begin
  with PrnInfo do
    if UseMargins then
      if pgMargins.Bottom = 0 then
        Result := Ofy + Ph
      else
        Result := Pgh - pgMargins.Bottom
    else
      Result := Pgh;
  if (FReport.DocMode <> dmDesigning) and BandExists(Bands[btPageFooter]) then
    Result := Result - Bands[btPageFooter].dy;
end;

function TfrPage.LeftMargin: Integer;
begin
  if UseMargins then
    if pgMargins.Left = 0 then
      Result := PrnInfo.Ofx
    else
      Result := pgMargins.Left
  else
    Result := 0;
end;

function TfrPage.RightMargin: Integer;
begin
  with PrnInfo do
    if UseMargins then
      if pgMargins.Right = 0 then
        Result := Ofx + Pw
      else
        Result := Pgw - pgMargins.Right
    else
      Result := Pgw;
end;

procedure TfrPage.TossObjects;
var
  i, j, n, last, miny: Integer;
  b: TfrBandType;
  bt, t: TfrView;
  Bnd, Bnd1: TfrBand;
  FirstBand, Flag: Boolean;
  BArr: array[0..31] of TfrBand;
  s: string;
begin
  for i := 0 to Objects.Count - 1 do
  begin
    bt := Objects[i];
    t := frCreateObject(Report, bt.Typ, bt.ClassName);
    t.Assign(bt);
    t.StreamMode := smPrinting;
    RTObjects.Add(t);
    if (t.Flags and flWantHook) <> 0 then
      HookList.Add(t);
  end;

  for i := 0 to RTObjects.Count - 1 do // select all objects exclude bands
  begin
    t := RTObjects[i];
    t.Selected := t.Typ <> gtBand;
    t.Parent := nil;

    if t.Typ = gtSubReport then
      Report.Pages[(t as TfrSubReportView).SubPage].Skip := True;
  end;
  Flag := False;
  for i := 0 to RTObjects.Count - 1 do // search for btCrossXXX bands
  begin
    bt := RTObjects[i];
    if (bt.Typ = gtBand) and
      (TfrBandType(bt.FrameType) in [btCrossHeader..btCrossFooter]) then
      with Bands[TfrBandType(bt.FrameType)] do
      begin
        Memo.Assign(bt.Memo);

        x := bt.x; dx := bt.dx;
        InitDataSet(bt.FormatStr);
        View := bt;
        Flags := bt.Flags;
        Visible := bt.Visible;
        bt.Parent := Bands[TfrBandType(bt.FrameType)];
        Flag := True;
      end;
  end;

  if Flag then // fill a ColumnXXX bands at first
    for b := btCrossHeader to btCrossFooter do
    begin
      Bnd := Bands[b];
      for i := 0 to RTObjects.Count - 1 do
      begin
        t := RTObjects[i];
        if t.Selected then
          if (t.x >= Bnd.x) and (t.x + t.dx <= Bnd.x + Bnd.dx) then
          begin
            t.x := t.x - Bnd.x;
            t.Parent := Bnd;
            Bnd.Objects.Add(t);
          end;
      end;
    end;

  for b := btReportTitle to btGroupFooter do // fill other bands
  begin
    FirstBand := True;
    Bnd := Bands[b];
    BArr[0] := Bnd;
    Last := 1;
    for i := 0 to RTObjects.Count - 1 do // search for specified band
    begin
      bt := RTObjects[i];
      if (bt.Typ = gtBand) and (bt.FrameType = Integer(b)) then
      begin
        if not FirstBand then
        begin
          Bnd.Next := TfrBand.Create(b, Self);
          Bnd := Bnd.Next;
          BArr[Last] := Bnd;
          Inc(Last);
        end;
        FirstBand := False;
        Bnd.Memo.Assign(bt.Memo);
        Bnd.y := bt.y;
        Bnd.dy := bt.dy;
        Bnd.View := bt;
        Bnd.Flags := bt.Flags;
        Bnd.Visible := bt.Visible;
        bt.Parent := Bnd;
        with bt as TfrBandView, Bnd do
        begin
          InitDataSet(FormatStr);
          Stretched := (Flags and flStretched) <> 0;
          PrintIfSubsetEmpty := (Flags and flBandPrintIfSubsetEmpty) <> 0;
          if Skip then
          begin
            NewPageAfter := False;
            PageBreak := False;
          end
          else
          begin
            NewPageAfter := (Flags and flBandNewPageAfter) <> 0;
            PageBreak := (Flags and flBandPageBreak) <> 0;
          end;
        end;
        for j := 0 to RTObjects.Count - 1 do // placing objects over band
        begin
          t := RTObjects[j];
          if (t.Parent = nil) and (t.Typ <> gtSubReport) then
            if t.Selected then
              if (t.y >= Bnd.y) and (t.y <= Bnd.y + Bnd.dy) then
              begin
                t.Parent := Bnd;
                t.y := t.y - Bnd.y;
                t.Selected := False;
                Bnd.Objects.Add(t);
              end;
        end;
        for j := 0 to RTObjects.Count - 1 do // placing ColumnXXX objects over band
        begin
          t := RTObjects[j];
          if t.Parent <> nil then
            if t.Selected then
              if (t.y >= Bnd.y) and (t.y <= Bnd.y + Bnd.dy) then
              begin
                t.y := t.y - Bnd.y;
                t.Selected := False;
                Bnd.Objects.Add(t);
              end;
        end;
        for j := 0 to RTObjects.Count - 1 do // placing subreports over band
        begin
          t := RTObjects[j];
          if (t.Parent = nil) and (t.Typ = gtSubReport) then
            if t.Selected then
              if (t.y >= Bnd.y) and (t.y <= Bnd.y + Bnd.dy) then
              begin
                t.Parent := Bnd;
                t.y := t.y - Bnd.y;
                t.Selected := False;
                Bnd.Objects.Add(t);
              end;
        end;
      end;
    end;
    for i := 0 to Last - 1 do // sorting bands
    begin
      miny := BArr[i].y; n := i;
      for j := i + 1 to Last - 1 do
        if BArr[j].y < miny then
        begin
          miny := BArr[j].y;
          n := j;
        end;
      Bnd := BArr[i]; BArr[i] := BArr[n]; BArr[n] := Bnd;
    end;
    Bnd := BArr[0]; Bands[b] := Bnd;
    Bnd.Prev := nil;
    for i := 1 to Last - 1 do // finally ordering
    begin
      Bnd.Next := BArr[i];
      Bnd := Bnd.Next;
      Bnd.Prev := BArr[i - 1];
    end;
    Bnd.Next := nil;
    Bands[b].LastBand := Bnd;
  end;

  for i := 0 to RTObjects.Count - 1 do // place other objects on btNone band
  begin
    t := RTObjects[i];
    if t.Selected then
    begin
      t.Parent := Bands[btNone];
      Bands[btNone].y := 0;
      Bands[btNone].Objects.Add(t);
    end;
  end;

  for i := 1 to MAXBNDS do // connect header & footer to each data-band
  begin
    Bnd := Bands[Bnds[i, bpHeader]];
    while Bnd <> nil do
    begin
      Bnd1 := Bands[Bnds[i, bpData]];
      while Bnd1 <> nil do
      begin
        if Bnd1.y > Bnd.y + Bnd.dy then
          break;
        Bnd1 := Bnd1.Next;
      end;
      if (Bnd1 <> nil) and (Bnd1.HeaderBand = nil) then
        Bnd1.HeaderBand := Bnd;

      Bnd := Bnd.Next;
    end;

    Bnd := Bands[Bnds[i, bpFooter]];
    while Bnd <> nil do
    begin
      Bnd1 := Bands[Bnds[i, bpData]];
      while Bnd1 <> nil do
      begin
        if Bnd1.y + Bnd1.dy > Bnd.y then
        begin
          Bnd1 := Bnd1.Prev;
          break;
        end;
        if Bnd1.Next = nil then
          break;
        Bnd1 := Bnd1.Next;
      end;
      if (Bnd1 <> nil) and (Bnd1.FooterBand = nil) then
        Bnd1.FooterBand := Bnd;

      Bnd := Bnd.Next;
    end;
  end;

  Bnd := Bands[btGroupHeader].LastBand;
  Bnd1 := Bands[btGroupFooter];
  repeat
    Bnd.FooterBand := Bnd1;
    Bnd := Bnd.Prev;
    Bnd1 := Bnd1.Next;
  until (Bnd = nil) or (Bnd1 = nil);

  if BandExists(Bands[btCrossData]) and (Pos(';', Bands[btCrossData].View.FormatStr) <> 0) then
  begin
    s := Bands[btCrossData].View.FormatStr;
    i := 1;
    while i < Length(s) do
    begin
      j := i;
      while s[j] <> '=' do
        Inc(j);
      n := j;
      while s[n] <> ';' do
        Inc(n);
      for b := btMasterHeader to btGroupFooter do
      begin
        Bnd := Bands[b];
        while Bnd <> nil do
        begin
          if Bnd.View <> nil then
            if CompareText(Bnd.View.Name, Copy(s, i, j - i)) = 0 then
              CreateDS(Report, Copy(s, j + 1, n - j - 1), Bnd.VCDataSet, Bnd.IsVirtualVCDS);
          Bnd := Bnd.Next;
        end;
      end;
      i := n + 1;
    end;
  end;

  if ColCount = 0 then
    ColCount := 1;
  ColWidth := (RightMargin - LeftMargin) div ColCount;
end;

procedure TfrPage.PrepareObjects;
var
  i, j: Integer;
  t: TfrView;
  Value: TfrValue;
  s: string;
  DSet: TDataSet;
  Field: TField;
begin
  CurPage := Self;
  for i := 0 to RTObjects.Count - 1 do
  begin
    t := RTObjects[i];
    t.FField := '';
    if t.Memo.Count > 0 then
      s := t.Memo[0];
    j := Length(s);
    if (j > 2) and (s[1] = '[') then
    begin
      while (j > 0) and (s[j] <> ']') do
        Dec(j);
      s := Copy(s, 2, j - 2);
      t.FDataSet := nil;
      t.FField := '';
      Value := Report.Values.FindVariable(s);
      if Value = nil then
      begin
        CurBand := t.Parent;
        DSet := GetDefaultDataset;
        frGetDatasetAndField(Report.Owner, s, DSet, Field);
        if Field <> nil then
        begin
          t.FDataSet := DSet;
          t.FField := Field.FieldName;
        end;
      end
      else if Value.Typ = vtDBField then
        if Value.DSet <> nil then
        begin
          t.FDataSet := Value.DSet;
          t.FField := Value.Field;
        end;
    end;
  end;
end;

procedure TfrPage.ShowBand(b: TfrBand);
begin
  if b <> nil then
    if Mode = pmBuildList then
      AddRecord(b, rtShowBand)
    else
      b.Draw;
end;

procedure TfrPage.ShowBandByName(s: string);
var
  bt: TfrBandType;
  b: TfrBand;
begin
  for bt := btReportTitle to btNone do
  begin
    b := Bands[bt];
    while b <> nil do
    begin
      if b.View <> nil then
        if CompareText(b.View.Name, s) = 0 then
        begin
          b.Draw;
          Exit;
        end;
      b := b.Next;
    end;
  end;
end;

procedure TfrPage.ShowBandByType(bt: TfrBandType);
var
  b: TfrBand;
begin
  b := Bands[bt];
  if b <> nil then
    b.Draw;
end;

procedure TfrPage.AddRecord(b: TfrBand; rt: TfrBandRecType);
var
  p: TfrBandInfo;
begin
  p := TfrBandInfo.Create;
  p.Band := b;
  p.Action := rt;
  List.Add(p);
end;

procedure TfrPage.ClearRecList;
begin
  List.Clear;
end;

function TfrPage.PlayRecList: Boolean;
var
  p: TfrBandInfo;
  b: TfrBand;
begin
  Result := False;
  while PlayFrom < List.Count do
  begin
    p := List[PlayFrom] as TfrBandInfo;
    b := p.Band;
    case p.Action of
      rtShowBand:
        begin
          if LastBand <> nil then
          begin
            LastBand.DoSubReports;
            if LastBand <> nil then
            begin
              Result := True;
              Exit;
            end;
          end
          else if b.Draw then
          begin
            Result := True;
            Exit;
          end;
        end;
      rtFirst:
        begin
          b.DataSet.First;
          b.Positions[psLocal] := 1;
        end;
      rtNext:
        begin
          b.DataSet.Next;
          Inc(CurPos);
          Inc(b.Positions[psGlobal]);
          Inc(b.Positions[psLocal]);
        end;
    end;
    Inc(PlayFrom);
  end;
end;

procedure TfrPage.DrawPageFooters;
begin
  CurColumn := 0;
  XAdjust := LeftMargin;
  if (PageNo <> 0) or ((Bands[btPageFooter].Flags and flBandOnFirstPage) <> 0) then
    while PageNo < Report.EMFPages.Count do
    begin
      if not (Append and WasPF) then
      begin
        if Assigned(Report.FOnEndPage) then
          Report.FOnEndPage(PageNo);
        ShowBand(Bands[btPageFooter]);
      end;
      Inc(PageNo);
    end;
  PageNo := Report.EMFPages.Count;
end;

procedure TfrPage.NewPage;
begin
  Report.InternalOnProgress(PageNo + 1);
  ShowBand(Bands[btColumnFooter]);
  DrawPageFooters;
  CurBottomY := BottomMargin;
  Report.EMFPages.Add(Self);
  Append := False;
  ShowBand(Bands[btOverlay]);
  CurY := TopMargin;
  ShowBand(Bands[btPageHeader]);
  ShowBand(Bands[btColumnHeader]);
end;

procedure TfrPage.NewColumn(Band: TfrBand);
var
  b: TfrBand;
begin
  if CurColumn < ColCount - 1 then
  begin
    ShowBand(Bands[btColumnFooter]);
    Inc(CurColumn);
    Inc(XAdjust, ColWidth + ColGap);
    CurY := LastStaticColumnY;
    ShowBand(Bands[btColumnHeader]);
  end
  else
    NewPage;
  b := Bands[btGroupHeader];
  if b <> nil then
    while (b <> nil) and (b <> Band) do
    begin
      b.DisableInit := True;
      if (b.Flags and flBandRepeatHeader) <> 0 then
        ShowBand(b);
      b.DisableInit := False;
      b := b.Next;
    end;
  if Band.Typ in [btMasterData, btDetailData, btSubDetailData] then
    if (Band.HeaderBand <> nil) and
      ((Band.HeaderBand.Flags and flBandRepeatHeader) <> 0) then
      ShowBand(Band.HeaderBand);
end;

procedure TfrPage.DoAggregate(a: array of TfrBandType);
var
  i: Integer;
  procedure DoAggregate1(bt: TfrBandType);
  var
    b: TfrBand;
  begin
    b := Bands[bt];
    while b <> nil do
    begin
      b.DoAggregate;
      b := b.Next;
    end;
  end;
begin
  for i := Low(a) to High(a) do
    DoAggregate1(a[i]);
end;

procedure TfrPage.FormPage;
var
  BndStack: array[1..MAXBNDS * 3] of TfrBand;
  MaxLevel, BndStackTop: Integer;
  i, sfPage: Integer;
  HasGroups: Boolean;

  procedure AddToStack(b: TfrBand);
  begin
    if b <> nil then
    begin
      Inc(BndStackTop);
      BndStack[BndStackTop] := b;
    end;
  end;

  procedure ShowStack;
  var
    i: Integer;
  begin
    for i := 1 to BndStackTop do
      if BandExists(BndStack[i]) then
        ShowBand(BndStack[i]);
    BndStackTop := 0;
  end;

  procedure DoLoop(Level: Integer);
  var
    WasPrinted: Boolean;
    b, b1, b2: TfrBand;

    procedure InitGroups(b: TfrBand);
    begin
      while b <> nil do
      begin
        Inc(b.Positions[psLocal]);
        Inc(b.Positions[psGlobal]);
        ShowBand(b);
        b := b.Next;
      end;
    end;

  begin
    b := Bands[Bnds[Level, bpData]];
    while (b <> nil) and (b.Dataset <> nil) do
    begin
      b.DataSet.First;
      if Mode = pmBuildList then
        AddRecord(b, rtFirst)
      else
        b.Positions[psLocal] := 1;

      b1 := Bands[btGroupHeader];
      while b1 <> nil do
      begin
        b1.Positions[psLocal] := 0;
        b1.Positions[psGlobal] := 0;
        b1 := b1.Next;
      end;

      if not b.DataSet.Eof then
      begin
        if (Level = 1) and HasGroups then
          InitGroups(Bands[btGroupHeader]);
        if b.HeaderBand <> nil then
          AddToStack(b.HeaderBand);
        if b.FooterBand <> nil then
          b.FooterBand.InitValues;

        while not b.DataSet.Eof do
        begin
          Application.ProcessMessages;
          if Report.Terminated then
            break;
          AddToStack(b);
          WasPrinted := True;
          if Level < MaxLevel then
          begin
            DoLoop(Level + 1);
            if BndStackTop > 0 then
              if b.PrintIfSubsetEmpty then
                ShowStack
              else
              begin
                Dec(BndStackTop);
                WasPrinted := False;
              end;
          end
          else
            ShowStack;

          b.DataSet.Next;

          if (Level = 1) and HasGroups then
          begin
            b1 := Bands[btGroupHeader];
            while b1 <> nil do
            begin
              if (frParser.Calc(b1.GroupCondition) <> b1.LastGroupValue) or
                b.Dataset.Eof then
              begin
                ShowBand(b.FooterBand);
                b2 := Bands[btGroupHeader].LastBand;
                while b2 <> b1 do
                begin
                  ShowBand(b2.FooterBand);
                  b2.Positions[psLocal] := 0;
                  b2 := b2.Prev;
                end;
                ShowBand(b1.FooterBand);
                if not b.DataSet.Eof then
                begin
                  if b1.NewPageAfter then
                    NewPage;
                  InitGroups(b1);
                  ShowBand(b.HeaderBand);
                  b.Positions[psLocal] := 0;
                end;
                break;
              end;
              b1 := b1.Next;
            end;
          end;

          if Mode = pmBuildList then
            AddRecord(b, rtNext)
          else if WasPrinted then
          begin
            Inc(CurPos);
            Inc(b.Positions[psGlobal]);
            Inc(b.Positions[psLocal]);
            if not b.DataSet.Eof and b.NewPageAfter then
              NewPage;
          end;
          if Report.Terminated then
            break;
        end;
        if BndStackTop = 0 then
          ShowBand(b.FooterBand)
        else
          Dec(BndStackTop);
      end;
      b := b.Next;
    end;
  end;

begin
  if Mode = pmNormal then
  begin
    if Append then
      if PrevY = PrevBottomY then
      begin
        Append := False;
        WasPF := False;
        PageNo := Report.EMFPages.Count;
      end;
    if Append and WasPF then
      CurBottomY := PrevBottomY
    else
      CurBottomY := BottomMargin;
    CurColumn := 0;
    XAdjust := LeftMargin;
    if not Append then
    begin
      Report.EMFPages.Add(Self);
      CurY := TopMargin;
      ShowBand(Bands[btOverlay]);
      ShowBand(Bands[btNone]);
    end
    else
      CurY := PrevY;
    sfPage := PageNo;
    ShowBand(Bands[btReportTitle]);
    if PageNo = sfPage then // check if new page was formed
    begin
      if BandExists(Bands[btPageHeader]) and
        ((Bands[btPageHeader].Flags and flBandOnFirstPage) <> 0) then
        ShowBand(Bands[btPageHeader]);
      ShowBand(Bands[btColumnHeader]);
    end;
  end;

  BndStackTop := 0;
  for i := 1 to MAXBNDS do
    if BandExists(Bands[Bnds[i, bpData]]) then
      MaxLevel := i;
  HasGroups := Bands[btGroupHeader].Objects.Count > 0;
  DoLoop(1);
  if Mode = pmNormal then
  begin
    ShowBand(Bands[btColumnFooter]);
    ShowBand(Bands[btReportSummary]);
    PrevY := CurY;
    PrevBottomY := CurBottomY;
    if CurColumn > 0 then
      PrevY := BottomMargin;
    CurColumn := 0;
    XAdjust := LeftMargin;
    sfPage := PageNo;
    WasPF := False;
    if (Bands[btPageFooter].Flags and flBandOnLastPage) <> 0 then
    begin
      WasPF := BandExists(Bands[btPageFooter]);
      if WasPF then
        DrawPageFooters;
    end;
    PageNo := sfPage + 1;
  end;
end;

function TfrPage.BandExists(b: TfrBand): Boolean;
begin
  Result := b.Objects.Count > 0;
end;

procedure TfrPage.AfterPrint;
var
  i: Integer;
begin
  for i := 0 to HookList.Count - 1 do
    TfrView(HookList[i]).OnHook(CurView);
end;

procedure TfrPage.LoadFromStream(Stream: TStream);
var
  b: Byte;
begin
  with Stream do
  begin
    Read(pgSize, 4);
    Read(pgWidth, 4);
    Read(pgHeight, 4);
    Read(pgMargins, Sizeof(pgMargins));
    Read(b, 1);
    pgOr := TPrinterOrientation(b);
    Read(PrintToPrevPage, 2);
    Read(UseMargins, 2);
    Read(ColCount, 4);
    Read(ColGap, 4);
  end;
  ChangePaper(pgSize, pgWidth, pgHeight, pgOr);
end;

procedure TfrPage.SaveToStream(Stream: TStream);
var
  b: Byte;
begin
  with Stream do
  begin
    Write(pgSize, 4);
    Write(pgWidth, 4);
    Write(pgHeight, 4);
    Write(pgMargins, Sizeof(pgMargins));
    b := Byte(pgOr);
    Write(b, 1);
    Write(PrintToPrevPage, 2);
    Write(UseMargins, 2);
    Write(ColCount, 4);
    Write(ColGap, 4);
  end;
end;

{-----------------------------------------------------------------------}

constructor TfrPages.Create(AReport: TfrReport);
begin
  inherited Create;
  FReport := AReport;
  FPages := TObjectList.Create;
end;

destructor TfrPages.Destroy;
begin
  FreeAndNil(FPages);
  inherited;
end;

function TfrPages.GetCount: Integer;
begin
  Result := FPages.Count;
end;

function TfrPages.GetPages(Index: Integer): TfrPage;
begin
  Result := FPages[Index] as TfrPage;
end;

procedure TfrPages.Clear;
begin
  FPages.Clear;
end;

procedure TfrPages.Add;
begin
  FPages.Add(TfrPage.Create(FReport, 9, 0, 0, poPortrait));
end;

procedure TfrPages.Delete(Index: Integer);
begin
  FPages.Delete(Index);
end;

procedure TfrPages.LoadFromStream(Stream: TStream);
var
  b: Byte;
  t: TfrView;
  s: string;
  buf: string[8];

  procedure AddObject(ot: Byte; clname: string);
  begin
    Stream.Read(b, 1);
    Pages[b].Objects.Add(frCreateObject(FReport, ot, clname));
    t := Pages[b].Objects.Items[Pages[b].Objects.Count - 1];
  end;

begin
  Clear;
  Stream.Read(FReport.PrintToDefault, 2);
  Stream.Read(FReport.DoublePass, 2);
  FReport.SetPrinterTo(ReadString(Stream));
  while Stream.Position < Stream.Size do
  begin
    Stream.Read(b, 1);
    if b = $FF then // page info
    begin
      Add;
      Pages[Count - 1].LoadFromStream(Stream);
    end
    else if b = $FE then // values
    begin
      FReport.FVal.ReadBinaryData(Stream);
      ReadMemo(Stream, SMemo);
      FReport.Variables.Assign(SMemo);
    end
    else if b = $FD then // datasets
    begin
      if frDataManager <> nil then
        frDataManager.LoadFromStream(Stream);
      break;
    end
    else
    begin
      if b > Integer(gtAddIn) then
      begin
        raise Exception.Create('');
        break;
      end;
      s := '';
      if b = gtAddIn then
      begin
        s := ReadString(Stream);
        if UpperCase(s) = 'TFRFRAMEDMEMOVIEW' then
          AddObject(gtMemo, '')
        else
          AddObject(gtAddIn, s);
      end
      else
        AddObject(b, '');
      t.LoadFromStream(Stream);
      if UpperCase(s) = 'TFRFRAMEDMEMOVIEW' then
        Stream.Read(buf[1], 8);
    end;
  end;
end;

procedure TfrPages.SaveToStream(Stream: TStream);
var
  b: Byte;
  i, j: Integer;
  t: TfrView;
begin
  Stream.Write(FReport.PrintToDefault, 2);
  Stream.Write(FReport.DoublePass, 2);
  frWriteString(Stream, Prn.Printers[Prn.PrinterIndex]);
  for i := 0 to Count - 1 do // adding pages at first
  begin
    b := $FF;
    Stream.Write(b, 1); // page info
    Pages[i].SaveToStream(Stream);
  end;
  for i := 0 to Count - 1 do
  begin
    for j := 0 to Pages[i].Objects.Count - 1 do // then adding objects
    begin
      t := Pages[i].Objects[j];
      b := Byte(t.Typ);
      Stream.Write(b, 1);
      if t.Typ = gtAddIn then
        frWriteString(Stream, t.ClassName);
      Stream.Write(i, 1);
      t.SaveToStream(Stream);
    end;
  end;
  b := $FE;
  Stream.Write(b, 1);
  FReport.FVal.WriteBinaryData(Stream);
  SMemo.Assign(FReport.Variables);
  frWriteMemo(Stream, SMemo);
  if frDataManager <> nil then
  begin
    b := $FD;
    Stream.Write(b, 1);
    frDataManager.SaveToStream(Stream);
  end;
end;

{-----------------------------------------------------------------------}

constructor TfrEMFPages.Create(AReport: TfrReport);
begin
  inherited Create;
  FReport := AReport;
  FPages := TObjectList.Create;
end;

destructor TfrEMFPages.Destroy;
begin
  Clear;
  FPages.Free;
  inherited;
end;

function TfrEMFPages.GetCount: Integer;
begin
  Result := FPages.Count;
end;

function TfrEMFPages.GetPages(Index: Integer): TfrPageInfo;
begin
  Result := FPages[Index] as TfrPageInfo;
end;

procedure TfrEMFPages.Clear;
begin
  FPages.Clear;
end;

procedure TfrEMFPages.Draw(Index: Integer; Canvas: TCanvas; DrawRect: TRect);
var
  t: TfrView;
  i: Integer;
  sx, sy: Double;
  v, IsPrinting: Boolean;
  h: THandle;
begin
  IsPrinting := Printer.Printing and (Canvas.Handle = Printer.Canvas.Handle);
  FReport.FDocMode := dmPrinting;
  with Pages[Index] do
    if Visible then
    begin
      if Page = nil then
        ObjectsToPage(Index);
      sx := (DrawRect.Right - DrawRect.Left) / PrnInfo.PgW;
      sy := (DrawRect.Bottom - DrawRect.Top) / PrnInfo.PgH;
      h := Canvas.Handle;
      for i := 0 to Page.Objects.Count - 1 do
      begin
        t := Page.Objects[i];
        v := True;
        if not IsPrinting then
          with t, DrawRect do
            v := RectVisible(h, Rect(Round(x * sx) + Left - 10,
              Round(y * sy) + Top - 10,
              Round((x + dx) * sx) + Left + 10,
              Round((y + dy) * sy) + Top + 10));
        if v then
        begin
          t.ScaleX := sx; t.ScaleY := sy;
          t.OffsX := DrawRect.Left; t.OffsY := DrawRect.Top;
          t.IsPrinting := IsPrinting;
          t.Draw(Canvas);
        end;
      end;
    end
    else
    begin
      FreeAndNil(FPage);
    end;
end;

procedure TfrEMFPages.ExportData(Index: Integer);
var
  b: Byte;
  t: TfrView;
  s: string;
begin
  with Pages[Index] do
  begin
    Stream.Position := 0;
    while Stream.Position < Stream.Size do
    begin
      Stream.Read(b, 1);
      if b = gtAddIn then
        s := ReadString(Stream)
      else
        s := '';
      t := frCreateObject(FReport, b, s);
      t.StreamMode := smPrinting;
      t.LoadFromStream(Stream);
      t.ExportData;
      t.Free;
    end;
  end;
end;

procedure TfrEMFPages.ObjectsToPage(Index: Integer);
var
  b: Byte;
  t: TfrView;
  s: string;
begin
  with Pages[Index] do
  begin
    FreeAndNil(FPage);
    FPage := TfrPage.Create(FReport, pgSize, pgWidth, pgHeight, pgOr);
    Stream.Position := 0;
    while Stream.Position < Stream.Size do
    begin
      Stream.Read(b, 1);
      if b = gtAddIn then
        s := ReadString(Stream)
      else
        s := '';
      t := frCreateObject(FReport, b, s);
      t.StreamMode := smPrinting;
      t.LoadFromStream(Stream);
      t.StreamMode := smDesigning;
      Page.Objects.Add(t);
    end;
  end;
end;

procedure TfrEMFPages.PageToObjects(Index: Integer);
var
  i: Integer;
  t: TfrView;
begin
  with Pages[Index] do
  begin
    Stream.Clear;
    for i := 0 to Page.Objects.Count - 1 do
    begin
      t := Page.Objects[i];
      t.StreamMode := smPrinting;
      Stream.Write(t.Typ, 1);
      if t.Typ = gtAddIn then
        frWriteString(Stream, t.ClassName);
      t.Contents.Assign(t.Memo);
      t.SaveToStream(Stream);
    end;
  end;
end;

procedure TfrEMFPages.Insert(Index: Integer; APage: TfrPage);
var
  p: TfrPageInfo;
begin
  p := TfrPageInfo.Create;
  if Index >= FPages.Count then
    FPages.Add(p)
  else
    FPages.Insert(Index, p);
  with p do
  begin
    pgSize := APage.pgSize;
    pgWidth := APage.pgWidth;
    pgHeight := APage.pgHeight;
    pgOr := APage.pgOr;
    pgMargins := APage.UseMargins;
    PrnInfo := APage.PrnInfo;
  end;
end;

procedure TfrEMFPages.Add(APage: TfrPage);
begin
  Insert(FPages.Count, APage);
  if Assigned(FReport.FOnBeginPage) then
    FReport.FOnBeginPage(PageNo);
end;

procedure TfrEMFPages.Delete(Index: Integer);
begin
  FPages.Delete(Index);
end;

procedure TfrEMFPages.LoadFromStream(AStream: TStream);
var
  i, o, c: Integer;
  b, compr: Byte;
  p: TfrPageInfo;
  s: TMemoryStream;
begin
  Clear;
  AStream.Read(compr, 1);
  FReport.SetPrinterTo(frReadString(AStream));
  AStream.Read(c, 4);
  i := 0;
  repeat
    AStream.Read(o, 4);
    p := TfrPageInfo.Create;
    FPages.Add(p);
    with p.Info do
    begin
      AStream.Read(pgSize, 2);
      AStream.Read(pgWidth, 4);
      AStream.Read(pgHeight, 4);
      AStream.Read(b, 1);
      pgOr := TPrinterOrientation(b);
      AStream.Read(b, 1);
      pgMargins := Boolean(b);
      if compr <> 0 then
      begin
        s := TMemoryStream.Create;
        s.CopyFrom(AStream, o - AStream.Position);
        frCompressor.DeCompress(s, p.Stream);
        s.Free;
      end
      else
      begin
        p.Stream.CopyFrom(AStream, o - AStream.Position);
      end;
      Prn.SetPrinterInfo(pgSize, pgWidth, pgHeight, pgOr);
      Prn.FillPrnInfo(PrnInfo);
    end;
    AStream.Seek(o, soFromBeginning);
    Inc(i);
  until i >= c;
end;

procedure TfrEMFPages.SaveToStream(AStream: TStream);
var
  i, o, n: Integer;
  b: Byte;
  s: TMemoryStream;
begin
  b := Byte(frCompressor.Enabled);
  AStream.Write(b, 1);
  frWriteString(AStream, Prn.Printers[Prn.PrinterIndex]);
  n := Count;
  AStream.Write(n, 4);
  i := 0;
  repeat
    o := AStream.Position;
    AStream.Write(o, 4); // dummy write
    with Pages[i] do
    begin
      AStream.Write(pgSize, 2);
      AStream.Write(pgWidth, 4);
      AStream.Write(pgHeight, 4);
      b := Byte(pgOr);
      AStream.Write(b, 1);
      b := Byte(pgMargins);
      AStream.Write(b, 1);
      Stream.Position := 0;
      if frCompressor.Enabled then
      begin
        s := TMemoryStream.Create;
        frCompressor.Compress(Stream, s);
        AStream.CopyFrom(s, s.Size);
        s.Free;
      end
      else
        AStream.CopyFrom(Stream, Stream.Size);
    end;
    n := AStream.Position;
    AStream.Seek(o, soFromBeginning);
    AStream.Write(n, 4);
    AStream.Seek(0, soFromEnd);
    Inc(i);
  until i >= Count;
end;

{-----------------------------------------------------------------------}

constructor TfrValues.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
end;

destructor TfrValues.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TfrValues.WriteBinaryData(Stream: TStream);
var
  i, n: Integer;

  procedure WriteStr(s: string);
  var
    n: Byte;
  begin
    n := Length(s);
    Stream.Write(n, 1);
    Stream.Write(s[1], n);
  end;

begin
  with Stream do
  begin
    n := FItems.Count;
    WriteBuffer(n, SizeOf(n));
    for i := 0 to n - 1 do
      with Objects[i] do
      begin
        WriteBuffer(Typ, SizeOf(Typ));
        WriteBuffer(OtherKind, SizeOf(OtherKind));
        WriteStr(DataSet);
        WriteStr(Field);
        WriteStr(FItems[i]);
      end;
  end;
end;

procedure TfrValues.ReadBinaryData(Stream: TStream);
var
  i, j, n: Integer;

  function ReadStr: string;
  var
    n: Byte;
  begin
    Stream.Read(n, 1);
    SetLength(Result, n);
    Stream.Read(Result[1], n);
  end;

begin
  Clear;
  FItems.Sorted := False;
  with Stream do
  begin
    ReadBuffer(n, SizeOf(n));
    for i := 0 to n - 1 do
    begin
      j := AddValue;
      with Objects[j] do
      begin
        ReadBuffer(Typ, SizeOf(Typ));
        ReadBuffer(OtherKind, SizeOf(OtherKind));
        DataSet := ReadStr;
        Field := ReadStr;
        FItems[j] := ReadStr;
      end;
    end;
  end;
end;

function TfrValues.GetValue(Index: Integer): TfrValue;
begin
  Result := TfrValue(FItems.Objects[Index]);
end;

function TfrValues.AddValue: Integer;
begin
  Result := FItems.AddObject('', TfrValue.Create);
end;

procedure TfrValues.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TfrValue(FItems.Objects[i]).Free;
  FItems.Clear;
end;

function TfrValues.FindVariable(const s: string): TfrValue;
var
  i: Integer;
begin
  Result := nil;
  i := FItems.IndexOf(s);
  if i <> -1 then
    Result := Objects[i];
end;

{----------------------------------------------------------------------------}

constructor TfrReport.Create(AOwner: TComponent);
begin
  inherited;
  FPages := TfrPages.Create(Self);
  FEMFPages := TfrEMFPages.Create(Self);
  FVars := TStringList.Create;
  FVal := TfrValues.Create;
  FShowProgress := True;
  FModalPreview := True;
  FModifyPrepared := True;
  FPreviewButtons := [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit];
  FInitialZoom := pzDefault;
  FileName := 'Untitled';
end;

destructor TfrReport.Destroy;
begin
  FreeAndNil(FVal);
  FreeAndNil(FVars);
  FreeAndNil(FEMFPages);
  FreeAndNil(FPages);
  inherited;
end;

procedure TfrReport.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Dataset) then
    Dataset := nil;
  if (Operation = opRemove) and (AComponent = Preview) then
    Preview := nil;
  if (Operation = opRemove) and (AComponent = Designer) then
    Designer := nil;
end;

// report building events

procedure TfrReport.InternalOnProgress(Percent: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Percent)
  else if FProgressForm <> nil then
  begin
    with FProgressForm do
    begin
      if (DoublePass and FinalPass) or (FCurrentFilter <> nil) then
        Label1.Caption := FirstCaption + '  ' + IntToStr(Percent) + ' ' +
          'from' + ' ' + IntToStr(SavedAllPages)
      else
        Label1.Caption := FirstCaption + '  ' + IntToStr(Percent);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrReport.InternalOnGetValue(ParName: string; var ParValue: string);
var
  i, j, Format: Integer;
  FormatStr: string;
begin
  SubValue := '';
  Format := CurView.Format;
  FormatStr := CurView.FormatStr;
  i := Pos(' #', ParName);
  if i <> 0 then
  begin
    FormatStr := Copy(ParName, i + 2, Length(ParName) - i - 1);
    ParName := Copy(ParName, 1, i - 1);

    if FormatStr[1] in ['0'..'9', 'N', 'n'] then
    begin
      if FormatStr[1] in ['0'..'9'] then
        FormatStr := 'N' + FormatStr;
      Format := $01000000;
      if FormatStr[2] in ['0'..'9'] then
        Format := Format + $00010000;
      i := Length(FormatStr);
      while i > 1 do
      begin
        if FormatStr[i] in ['.', ',', '-'] then
        begin
          Format := Format + Ord(FormatStr[i]);
          FormatStr[i] := '.';
          if FormatStr[2] in ['0'..'9'] then
          begin
            Inc(i);
            j := i;
            while (i <= Length(FormatStr)) and (FormatStr[i] in ['0'..'9']) do
              Inc(i);
            Format := Format + 256 * StrToInt(Copy(FormatStr, j, i - j));
          end;
          break;
        end;
        Dec(i);
      end;
      if not (FormatStr[2] in ['0'..'9']) then
      begin
        FormatStr := Copy(FormatStr, 2, 255);
        Format := Format + $00040000;
      end;
    end
    else if FormatStr[1] in ['D', 'T', 'd', 't'] then
    begin
      Format := $02040000;
      FormatStr := Copy(FormatStr, 2, 255);
    end
    else if FormatStr[1] in ['B', 'b'] then
    begin
      Format := $04040000;
      FormatStr := Copy(FormatStr, 2, 255);
    end;
  end;

  CurVariable := ParName;
  CurValue := 0;
  GetVariableValue(ParName, CurValue);
  ParValue := FormatValue(CurValue, Format, FormatStr);
end;

procedure TfrReport.InternalOnEnterRect(Memo: TStringList; View: TfrView);
begin
  with View do
    if (FDataSet <> nil) and frIsBlob(TField(FDataSet.FindField(FField))) then
      GetBlob(TField(FDataSet.FindField(FField)));
  if Assigned(FOnEnterRect) then
    FOnEnterRect(Memo, View);
end;

procedure TfrReport.InternalOnExportData(View: TfrView);
begin
  FCurrentFilter.OnData(View.x, View.y, View);
end;

procedure TfrReport.InternalOnExportText(x, y: Integer; const text: string;
  View: TfrView);
begin
  FCurrentFilter.OnText(x, y, text, View);
end;

procedure TfrReport.InternalOnBeginColumn(Band: TfrBand);
begin
  if Assigned(FOnBeginColumn) then
    FOnBeginColumn(Band);
end;

procedure TfrReport.InternalOnPrintColumn(ColNo: Integer; var ColWidth: Integer);
begin
  if Assigned(FOnPrintColumn) then
    FOnPrintColumn(ColNo, ColWidth);
end;

function TfrReport.FormatValue(V: Variant; Format: Integer;
  const FormatStr: string): string;
var
  f1, f2: Integer;
  c: Char;
  s: string;
begin
  if (TVarData(v).VType = varEmpty) or (v = Null) then
  begin
    Result := ' ';
    Exit;
  end;
  c := FormatSettings.DecimalSeparator;
  f1 := (Format div $01000000) and $0F;
  f2 := (Format div $00010000) and $FF;
  try
    case f1 of
      0: Result := v;
      1:
        begin
          FormatSettings.DecimalSeparator := Chr(Format and $FF);
          case f2 of
            0: Result := FormatFloat('###.##', v);
            1: Result := FloatToStrF(v, ffFixed, 15, (Format div $0100) and $FF);
            2: Result := FormatFloat('#,###.##', v);
            3: Result := FloatToStrF(v, ffNumber, 15, (Format div $0100) and $FF);
            4: Result := FormatFloat(FormatStr, v);
          end;
        end;
      2: if f2 = 4 then
          Result := FormatDateTime(FormatStr, v)
        else
          Result := FormatDateTime(frDateFormats[f2], v);
      3: if f2 = 4 then
          Result := FormatDateTime(FormatStr, v)
        else
          Result := FormatDateTime(frTimeFormats[f2], v);
      4:
        begin
          if f2 = 4 then
            s := FormatStr
          else
            s := BoolStr[f2];
          if Integer(v) = 0 then
            Result := Copy(s, 1, Pos(';', s) - 1)
          else
            Result := Copy(s, Pos(';', s) + 1, 255);
        end;
    end;
  except
    on Exception do
      Result := v;
  end;
  //DecimalSeparator := c;
end;

procedure TfrReport.GetVariableValue(const s: string; var v: Variant); //zaher:TODO improve this procedure by cache up link to variables
var
  Value: TfrValue;
  D: TDataSet;
  F: TField;

  function MasterBand: TfrBand;
  begin
    Result := CurBand;
    if Result.DataSet = nil then
      while Result.Prev <> nil do
        Result := Result.Prev;
  end;
begin
  TVarData(v).VType := varEmpty;
  if Assigned(FOnGetValue) then
    FOnGetValue(s, v);
  if TVarData(v).VType = varEmpty then
  begin
    Value := Values.FindVariable(s);
    if Value <> nil then
      with Value do
        case Typ of
          vtNotAssigned:
            v := '';
          vtDBField:
            begin
              F := TField(DSet.FindField(Field));
              if not F.DataSet.Active then
                F.DataSet.Open;
              if Assigned(F.OnGetText) then
                v := F.DisplayText
              else
                v := F.AsVariant;
            end;
          vtFRVar:
            v := frParser.Calc(Field);
          vtOther:
            if OtherKind = 1 then
              v := frParser.Calc(Field)
            else
              v := frParser.Calc(frSpecFuncs[OtherKind]);
        end
    else
    begin
      D := GetDefaultDataSet;
      frGetDataSetAndField(Owner, s, D, F);
      if F <> nil then
      begin
        if not F.DataSet.Active then
          F.DataSet.Open;
        if Assigned(F.OnGetText) then
          v := F.DisplayText
        else
          v := F.AsVariant
      end
      else if s = 'VALUE' then
        v := CurValue
      else if s = frSpecFuncs[0] then
        v := PageNo + 1
      else if s = frSpecFuncs[2] then
        v := CurDate
      else if s = frSpecFuncs[3] then
        v := CurTime
      else if s = frSpecFuncs[4] then
        v := MasterBand.Positions[psLocal]
      else if s = frSpecFuncs[5] then
        v := MasterBand.Positions[psGlobal]
      else if s = frSpecFuncs[6] then
        v := CurPage.ColPos
      else if s = frSpecFuncs[7] then
        v := CurPage.CurPos
      else if s = frSpecFuncs[8] then
        v := SavedAllPages
      else
      begin
        if frVariables.IndexOf(s) <> -1 then
        begin
          v := frVariables[s];
          Exit;
        end;
        if s <> SubValue then
        begin
          SubValue := s;
          v := frParser.Calc(s);
          SubValue := '';
        end
        else
          raise(EParserError.Create('Undefined symbol "' + SubValue + '"'));
      end;
    end;
  end;
end;

procedure TfrReport.OnGetParsFunction(const name: string; p1, p2, p3: Variant;
  var val: string);
var
  i: Integer;
begin
  val := '0';
  for i := 0 to frFunctionsCount - 1 do
    if frFunctions[i].FunctionLibrary.OnFunction(Self, name, p1, p2, p3, val) then
      exit;
  if AggrBand.Visible then
    if Assigned(FOnFunction) then
      FOnFunction(name, p1, p2, p3, val);
end;

// load/save methods

procedure TfrReport.LoadFromStream(Stream: TStream);
begin
  try
    Pages.LoadFromStream(Stream);
  except
    Pages.Clear;
    Pages.Add;
    MessageBox(0, 'Unsupported FRF format', 'Error', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrReport.SaveToStream(Stream: TStream);
begin
  Pages.SaveToStream(Stream);
end;

procedure TfrReport.InternalLoadFromFile(FName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
  FileName := FName;
end;

procedure TfrReport.InternalSaveToFile(FName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrReport.LoadFromDB(Table: TDataSet; DocN: Integer);
var
  Stream: TMemoryStream;
begin
  Table.First;
  while not Table.Eof do
  begin
    if Table.Fields[0].AsInteger = DocN then
    begin
      Stream := TMemoryStream.Create;
      TBlobField(Table.Fields[1]).SaveToStream(Stream);
      Stream.Position := 0;
      LoadFromStream(Stream);
      Stream.Free;
      Exit;
    end;
    Table.Next;
  end;
end;

procedure TfrReport.SaveToDB(Table: TDataSet; DocN: Integer);
var
  Stream: TMemoryStream;
  Found: Boolean;
begin
  Found := False;
  Table.First;
  while not Table.Eof do
  begin
    if Table.Fields[0].AsInteger = DocN then
    begin
      Found := True;
      break;
    end;
    Table.Next;
  end;

  if Found then
    Table.Edit
  else
    Table.Append;
  Table.Fields[0].AsInteger := DocN;
  Stream := TMemoryStream.Create;
  SaveToStream(Stream);
  Stream.Position := 0;
  TBlobField(Table.Fields[1]).LoadFromStream(Stream);
  Stream.Free;
  Table.Post;
end;

procedure TfrReport.LoadPreparedReport(FName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FName, fmOpenRead);
  EMFPages.LoadFromStream(Stream);
  Stream.Free;
  CanRebuild := False;
end;

procedure TfrReport.SavePreparedReport(FName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FName, fmCreate);
  EMFPages.SaveToStream(Stream);
  Stream.Free;
end;

procedure TfrReport.LoadTemplate(FName: string; comm: TStrings;
  Bmp: TBitmap; Load: Boolean);
var
  Stream: TFileStream;
  b: Byte;
  fb: TBitmap;
  fm: TStringList;
  pos: Integer;
begin
  fb := TBitmap.Create;
  fm := TStringList.Create;
  Stream := TFileStream.Create(FName, fmOpenRead);
  if Load then
  begin
    ReadMemo(Stream, fm);
    Stream.Read(pos, 4);
    Stream.Read(b, 1);
    if b <> 0 then
      fb.LoadFromStream(Stream);
    Stream.Position := pos;
    Pages.LoadFromStream(Stream);
  end
  else
  begin
    ReadMemo(Stream, Comm);
    Stream.Read(pos, 4);
    Bmp.Assign(nil);
    Stream.Read(b, 1);
    if b <> 0 then
      Bmp.LoadFromStream(Stream);
  end;
  fm.Free; fb.Free;
  Stream.Free;
end;

procedure TfrReport.SaveTemplate(FName: string; Comm: TStrings; Bmp: TBitmap);
var
  Stream: TFileStream;
  b: Byte;
  pos, lpos: Integer;
begin
  Stream := TFileStream.Create(FName, fmCreate);
  frWriteMemo(Stream, Comm);
  b := 0;
  pos := Stream.Position;
  lpos := 0;
  Stream.Write(lpos, 4);
  if Bmp.Empty then
    Stream.Write(b, 1)
  else
  begin
    b := 1;
    Stream.Write(b, 1);
    Bmp.SaveToStream(Stream);
  end;
  lpos := Stream.Position;
  Stream.Position := pos;
  Stream.Write(lpos, 4);
  Stream.Position := lpos;
  Pages.SaveToStream(Stream);
  Stream.Free;
end;

// report manipulation methods

function TfrReport.DesignReport: Boolean;
begin
  Result := False;
  if Pages.Count = 0 then
    Pages.Add;
  if frDesignerClass <> nil then
  begin
    Designer := frDesignerClass.Create(Application);
    try
      Designer.Report := Self;
      Designer.ShowModal;
      Result := Designer.Modified;
    finally
      if Designer <> nil then
        Designer.Free;
    end;
  end;
end;

var
  FirstPassTerminated, FirstTime: Boolean;

procedure TfrReport.BuildBeforeModal(Sender: TObject);
begin
  DoBuildReport;
  if FinalPass then
  begin
    if FProgressForm <> nil then
    begin
      if Terminated then
        FProgressForm.ModalResult := mrCancel
      else
        FProgressForm.ModalResult := mrOk
    end;
  end
  else
  begin
    FirstPassTerminated := Terminated;
    SavedAllPages := EMFPages.Count;
    DoublePass := False;
    FirstTime := False;
    DoPrepareReport; // do final pass
    DoublePass := True;
  end;
end;

function TfrReport.PrepareReport: Boolean;
var
  ParamOk: Boolean;
begin
  FDocMode := dmPrinting;
  CurDate := Date; CurTime := Time;
  Values.Items.Sorted := True;
  frParser.OnGetValue := GetVariableValue;
  frParser.OnFunction := OnGetParsFunction;
  if Assigned(FOnBeginDoc) then
    FOnBeginDoc;

  Result := False;
  ParamOk := True;
  if frDataManager <> nil then
  begin
    FillQueryParams;
    ParamOk := frDataManager.ShowParamsDialog;
  end;
  if ParamOk then
    Result := DoPrepareReport;
  FinalPass := False;
  if frDataManager <> nil then
    frDataManager.AfterParamsDialog;
  if Assigned(FOnEndDoc) then
    FOnEndDoc;
end;

function TfrReport.DoPrepareReport: Boolean;
var
  s: string;
  FreeProgressForm: Boolean;
begin
  Result := True;
  Terminated := False;
  Append := False;
  FreeProgressForm := False;
  DisableDrawing := False;
  FinalPass := True;
  FirstTime := True;
  PageNo := 0;
  EMFPages.Clear;

  s := 'Report preparing';
  if DoublePass then
  begin
    DisableDrawing := True;
    FinalPass := False;
    if not Assigned(FOnProgress) and FShowProgress then
    begin
      if FProgressForm = nil then
      begin
        FProgressForm := TfrProgressForm.Create(Application);
        FProgressForm.OnTerminate := DoTerminate;
        FreeProgressForm := True;
      end;
      try
        with FProgressForm do
        begin
          if Title = '' then
            Caption := s
          else
            Caption := s + ' - ' + Title;
          FirstCaption := 'Performing 1st pass:';
          Label1.Caption := FirstCaption + '  1';
          OnBeforeModal := BuildBeforeModal;
          if ShowProgressModal = mrCancel then
            Result := False;
        end;
      finally
        if FreeProgressForm then
          FreeAndNil(FProgressForm);
      end;
    end
    else
      BuildBeforeModal(nil);
    Exit;
  end;
  if not Assigned(FOnProgress) and FShowProgress then
  begin
    if FProgressForm = nil then
    begin
      FProgressForm := TfrProgressForm.Create(Application);
      FProgressForm.OnTerminate := DoTerminate;
      FreeProgressForm := True;
    end;
    try
      with FProgressForm do
      begin
        if Title = '' then
          Caption := s
        else
          Caption := s + ' - ' + Title;
        FirstCaption := 'Processing page:';
        Label1.Caption := FirstCaption + '  1';
        OnBeforeModal := BuildBeforeModal;
        if Visible then
        begin
          if not FirstPassTerminated then
            DoublePass := True;
          BuildBeforeModal(nil);
        end
        else
        begin
          SavedAllPages := 0;
          if ShowProgressModal = mrCancel then
            Result := False;
        end;
      end;
    finally
      if FreeProgressForm then
        FreeAndNil(FProgressForm);
    end;
  end
  else
    BuildBeforeModal(nil);
  Terminated := False;
end;

var
  ExportStream: TFileStream;

procedure TfrReport.ExportBeforeModal(Sender: TObject);
var
  i: Integer;
begin
  Application.ProcessMessages;
  for i := 0 to EMFPages.Count - 1 do
  begin
    FCurrentFilter.OnBeginPage;
    EMFPages.ExportData(i);
    InternalOnProgress(i + 1);
    Application.ProcessMessages;
    FCurrentFilter.OnEndPage;
  end;
  FCurrentFilter.OnEndDoc;
  FProgressForm.ModalResult := mrOk;
end;

procedure TfrReport.ExportTo(Filter: TClass; FileName: string);
var
  s: string;
begin
  ExportStream := TFileStream.Create(FileName, fmCreate);
  FCurrentFilter := TfrExportFilter(Filter.NewInstance);
  FCurrentFilter.Create(ExportStream);
  FCurrentFilter.OnBeginDoc;

  SavedAllPages := EMFPages.Count;
  FProgressForm := TfrProgressForm.Create(Application);
  FProgressForm.OnTerminate := DoTerminate;
  with FProgressForm do
  begin
    s := 'Report preparing';
    if Title = '' then
      Caption := s
    else
      Caption := s + ' - ' + Title;
    FirstCaption := 'Processing page:';
    Label1.Caption := FirstCaption + '  1';
    OnBeforeModal := ExportBeforeModal;
    ShowProgressModal;
  end;
  FreeAndNil(FProgressForm);
  FreeAndNil(FCurrentFilter);
  FreeAndNil(ExportStream);
end;

procedure TfrReport.FillQueryParams;
var
  i, j: Integer;
  t: TfrView;
  procedure PrepareDS(ds: TfrDataSet);
  begin
    if (ds <> nil) and (ds is TfrDBDataSet) then
      frDataManager.PrepareDataSet(TDataSet((ds as TfrDBDataSet).GetDataSet));
  end;
begin
  if frDataManager = nil then
    Exit;
  frDataManager.BeforePreparing;
  if Dataset <> nil then
    PrepareDS(DataSet);
  for i := 0 to Pages.Count - 1 do
    for j := 0 to Pages[i].Objects.Count - 1 do
    begin
      t := Pages[i].Objects[j];
      if t is TfrBandView then
        PrepareDS(frFindComponent(Owner, t.FormatStr) as TfrDataSet);
    end;
  frDataManager.AfterPreparing;
end;

procedure TfrReport.DoBuildReport;
var
  i: Integer;
  b: Boolean;
begin
  HookList.Clear;
  CanRebuild := True;
  FDocMode := dmPrinting;
  Values.Items.Sorted := True;
  frParser.OnGetValue := GetVariableValue;
  frParser.OnFunction := OnGetParsFunction;
  ErrorFlag := False;
  b := (Dataset <> nil) and (ReportType = rtMultiple);
  if b then
  begin
    Dataset.Init;
    Dataset.First;
  end;
  for i := 0 to Pages.Count - 1 do
    Pages[i].Skip := False;
  for i := 0 to Pages.Count - 1 do
    Pages[i].InitReport;
  PrepareDataSets;
  for i := 0 to Pages.Count - 1 do
    Pages[i].PrepareObjects;

  repeat
    InternalOnProgress(PageNo + 1);
    for i := 0 to Pages.Count - 1 do
    begin
      FCurPage := Pages[i];
      if FCurPage.Skip then
        continue;
      FCurPage.Mode := pmNormal;
      if Assigned(FOnManualBuild) then
        FOnManualBuild(FCurPage)
      else
        FCurPage.FormPage;

      Append := False;
      if ((i <> Pages.Count - 1) and Pages[i + 1].PrintToPrevPage) then
      begin
        Dec(PageNo);
        Append := True;
      end;
      if not Append then
      begin
        PageNo := EMFPages.Count;
        InternalOnProgress(PageNo);
      end;
      if Terminated then
        break;
    end;
    InternalOnProgress(PageNo);
    if b then
      Dataset.Next;
  until Terminated or not b or Dataset.Eof;

  for i := 0 to Pages.Count - 1 do
    Pages[i].DoneReport;
  if b then
    Dataset.Exit;
  if (frDataManager <> nil) and FinalPass then
    frDataManager.AfterPreparing;
  Values.Items.Sorted := False;
end;

procedure TfrReport.ShowReport;
begin
  PrepareReport;
  if ErrorFlag then
  begin
    MessageBox(0, PChar(ErrorStr), 'Error',
      mb_Ok + mb_IconError);
    EMFPages.Clear;
  end
  else
    ShowPreparedReport;
end;

procedure TfrReport.ShowPreparedReport;
var
  s: string;
  p: TfrPreviewForm;
begin
  FDocMode := dmPrinting;
  if EMFPages.Count = 0 then
    Exit;
  s := 'Preview';
  if Title <> '' then
    s := s + ' - ' + Title;
  if not (csDesigning in ComponentState) and Assigned(Preview) then
    Preview.Connect(Self)
  else
  begin
    p := TfrPreviewForm.Create(nil);
    p.Caption := s;
    p.Show_Modal(Self);
  end;
end;

procedure TfrReport.PrintBeforeModal(Sender: TObject);
begin
  DoPrintReport(FPageNumbers, FCopies);
  if FProgressForm <> nil then
    FProgressForm.ModalResult := mrOk;
end;

procedure TfrReport.PrintPreparedReport(PageNumbers: string; Copies: Integer);
var
  s: string;
begin
  s := 'Report preparing';
  Terminated := False;
  FPageNumbers := PageNumbers;
  FCopies := Copies;
  if not Assigned(FOnProgress) and FShowProgress then
  begin
    FProgressForm := TfrProgressForm.Create(Application);
    FProgressForm.OnTerminate := DoTerminate;
    try
      with FProgressForm do
      begin
        if Title = '' then
          Caption := s
        else
          Caption := s + ' - ' + Title;
        FirstCaption := 'Printing page:';
        Label1.Caption := FirstCaption;
        OnBeforeModal := PrintBeforeModal;
        ShowProgressModal;
      end;
    finally
      FreeAndNil(FProgressForm);
    end;
  end
  else
    PrintBeforeModal(nil);
  Terminated := False;
end;

procedure TfrReport.DoPrintReport(PageNumbers: string; Copies: Integer);
var
  i, j: Integer;
  f: Boolean;
  pgList: TStringList;

  procedure ParsePageNumbers;
  var
    i, j, n1, n2: Integer;
    s: string;
    IsRange: Boolean;
  begin
    s := PageNumbers;
    while Pos(' ', s) <> 0 do
      Delete(s, Pos(' ', s), 1);
    if s = '' then
      Exit;

    s := s + ',';
    i := 1; j := 1; n1 := 1;
    IsRange := False;
    while i <= Length(s) do
    begin
      if s[i] = ',' then
      begin
        n2 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
        if IsRange then
          while n1 <= n2 do
          begin
            pgList.Add(IntToStr(n1));
            Inc(n1);
          end
        else
          pgList.Add(IntToStr(n2));
        IsRange := False;
      end
      else if s[i] = '-' then
      begin
        IsRange := True;
        n1 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
      end;
      Inc(i);
    end;
  end;

  procedure PrintPage(n: Integer);
  begin
    with Printer, EMFPages[n] do
    begin
      if not Prn.IsEqual(pgSize, pgWidth, pgHeight, pgOr) then
      begin
        EndDoc;
        Prn.SetPrinterInfo(pgSize, pgWidth, pgHeight, pgOr);
        BeginDoc;
      end
      else if not f then
        NewPage;
      Prn.FillPrnInfo(EMFPages[n].Info.PrnInfo);
      Visible := True;

      with PrnInfo do
        if pgMargins then
          EMFPages.Draw(n, Printer.Canvas, Rect(-POfx, -POfy, PPgw - POfx, PPgh - POfy))
        else
          EMFPages.Draw(n, Printer.Canvas, Rect(0, 0, PPw, PPh));

      Visible := False;
      EMFPages.Draw(n, Printer.Canvas, Rect(0, 0, 0, 0));
    end;
    InternalOnProgress(n + 1);
    Application.ProcessMessages;
    f := False;
  end;

begin
  Prn.Printer := Printer;
  pgList := TStringList.Create;

  ParsePageNumbers;
  if Copies <= 0 then
    Copies := 1;

  with EMFPages[0] do
  begin
    Prn.SetPrinterInfo(pgSize, pgWidth, pgHeight, pgOr);
    Prn.FillPrnInfo(Info.PrnInfo);
  end;
  if Title <> '' then
    Printer.Title := 'FireReport: ' + Title
  else
    Printer.Title := 'FireReport: ' + 'Untitled';

  Printer.BeginDoc;
  f := True;
  for i := 0 to EMFPages.Count - 1 do
    if (pgList.Count = 0) or (pgList.IndexOf(IntToStr(i + 1)) <> -1) then
      for j := 0 to Copies - 1 do
      begin
        PrintPage(i);
        if Terminated then
        begin
          Printer.Abort;
          pgList.Free;
          Exit;
        end;
      end;
  Printer.EndDoc;
  pgList.Free;
end;

// printer manipulation methods

procedure TfrReport.SetPrinterTo(PrnName: string);
begin
  if not PrintToDefault then
    if Prn.Printers.IndexOf(PrnName) <> -1 then
      Prn.PrinterIndex := Prn.Printers.IndexOf(PrnName);
end;

function TfrReport.ChangePrinter(OldIndex, NewIndex: Integer): Boolean;
  procedure ChangePages;
  var
    i: Integer;
  begin
    for i := 0 to Pages.Count - 1 do
      with Pages[i] do
        ChangePaper(pgSize, pgWidth, pgHeight, pgOr);
  end;
begin
  Result := True;
  try
    Prn.PrinterIndex := NewIndex;
    Prn.PaperSize := -1;
    ChangePages;
  except
    on Exception do
    begin
      MessageBox(0, 'Printer selected is not valid',
        'Error', mb_IconError + mb_Ok);
      Prn.PrinterIndex := OldIndex;
      ChangePages;
      Result := False;
    end;
  end;
end;

procedure TfrReport.EditPreparedReport(PageIndex: Integer);
var
  p: TfrPageInfo;
  Stream: TMemoryStream;
  frDesigner: TfrReportDesigner;
begin
//zaher this make bug
  Screen.Cursor := crHourGlass;
  frDesigner := frDesignerClass.Create(nil);
  frDesigner.Report := Self;
  Stream := TMemoryStream.Create;
  SaveToStream(Stream);
  Pages.Clear;
  EMFPages.ObjectsToPage(PageIndex);
  p := EMFPages[PageIndex];
  Pages.FPages.OwnsObjects := False; //zaher this is a stuped
  Pages.FPages.Add(p.Page);
  Screen.Cursor := crDefault;
  try
    frDesigner.ShowModal;
    if frDesigner.Modified then
      if MessageBox(0, 'Save changes ?', 'Confirm', mb_YesNo + mb_IconQuestion) = mrYes then
        EMFPages.PageToObjects(PageIndex);
  finally
    Pages.FPages.Clear;
    Pages.FPages.OwnsObjects := True;
    Stream.Position := 0;
    LoadFromStream(Stream);
    Stream.Free;
    frDesigner.Free;
  end;
end;


// miscellaneous methods

procedure TfrReport.PrepareDataSets;
var
  i: Integer;
begin
  with Values do
    for i := 0 to Items.Count - 1 do
      with Objects[i] do
        if Typ = vtDBField then
          DSet := frGetDataSet(Owner, DataSet);
end;

procedure TfrReport.SetVars(Value: TStrings);
begin
  FVars.Assign(Value);
end;

procedure TfrReport.GetVarList(CatNo: Integer; List: TStrings);
var
  i, n: Integer;
  s: string;
begin
  List.Clear;
  i := 0; n := 0;
  if FVars.Count > 0 then
    repeat
      s := FVars[i];
      if Length(s) > 0 then
        if s[1] <> ' ' then
          Inc(n);
      Inc(i);
    until n > CatNo;
  while i < FVars.Count do
  begin
    s := FVars[i];
    if (s <> '') and (s[1] = ' ') then
      List.Add(Copy(s, 2, Length(s) - 1))
    else
      break;
    Inc(i);
  end;
end;

procedure TfrReport.GetCategoryList(List: TStrings);
var
  i: Integer;
  s: string;
begin
  List.Clear;
  for i := 0 to FVars.Count - 1 do
  begin
    s := FVars[i];
    if (s <> '') and (s[1] <> ' ') then
      List.Add(s);
  end;
end;

function TfrReport.FindVariable(Variable: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  Variable := ' ' + Variable;
  for i := 0 to FVars.Count - 1 do
    if Variable = FVars[i] then
    begin
      Result := i;
      break;
    end;
end;

function TfrReport.FindObject(Name: string): TfrView;
var
  i, j: Integer;
begin
  Result := nil;
  for i := 0 to Pages.Count - 1 do
    for j := 0 to Pages[i].Objects.Count - 1 do
      if CompareText(TfrView(Pages[i].Objects[j]).Name, Name) = 0 then
      begin
        Result := Pages[i].Objects[j];
        Exit;
      end;
end;

{----------------------------------------------------------------------------}

procedure TfrObjEditorForm.ShowEditor(t: TfrView);
begin
// abstract method
end;


{----------------------------------------------------------------------------}

constructor TfrExportFilter.Create(AStream: TStream);
begin
  inherited Create;
  Stream := AStream;
  Lines := TObjectList.Create;
end;

destructor TfrExportFilter.Destroy;
begin
  Clear;
  Lines.Free;
  inherited;
end;

procedure TfrExportFilter.Clear;
begin
  Lines.Clear;
end;

procedure TfrExportFilter.OnBeginDoc;
begin
// abstract method
end;

procedure TfrExportFilter.OnEndDoc;
begin
// abstract method
end;

procedure TfrExportFilter.OnBeginPage;
begin
// abstract method
end;

procedure TfrExportFilter.OnEndPage;
begin
// abstract method
end;

procedure TfrExportFilter.OnData(x, y: Integer; View: TfrView);
begin
// abstract method
end;

procedure TfrExportFilter.OnText(x, y: Integer; const text: string; View: TfrView);
begin
// abstract method
end;


{----------------------------------------------------------------------------}

constructor TfrFunctionLibrary.Create;
begin
  inherited Create;
  List := TStringList.Create;
  List.Sorted := True;
end;

destructor TfrFunctionLibrary.Destroy;
begin
  List.Free;
  inherited;
end;

function TfrFunctionLibrary.OnFunction(Report: TfrReport; const FName: string; p1, p2, p3: Variant; var val: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if List.Find(FName, i) then
  begin
    DoFunction(Report, i, p1, p2, p3, val);
    Result := True;
  end;
end;


{----------------------------------------------------------------------------}

constructor TfrStdFunctionLibrary.Create;
begin
  inherited Create;
  with List do
  begin
    Add('AVG');
    Add('COUNT');
    Add('FORMATDATETIME');
    Add('FORMATFLOAT');
    Add('INPUT');
    Add('LOWERCASE');
    Add('MAX');
    Add('MIN');
    Add('NAMECASE');
    Add('STRTODATE');
    Add('STRTOTIME');
    Add('SUM');
    Add('UPPERCASE');
  end;
end;

procedure TfrStdFunctionLibrary.DoFunction(Report: TfrReport; FNo: Integer; p1, p2, p3: Variant; var val: string);
var
  DataSet: TDataSet;
  Field: TField;
  s1, s2, VarName: string;
  min, max, avg, sum, count, d, v: Double;
  dk: (dkNone, dkSum, dkMin, dkMax, dkAvg, dkCount);
  vv: Variant;
begin
  dk := dkNone;
  val := '0';
  case FNo of
    0: dk := dkAvg;
    1: dk := dkCount;
    2: val := '''' + FormatDateTime(frParser.Calc(p1), frParser.Calc(p2)) + '''';
    3: val := '''' + FormatFloat(frParser.Calc(p1), frParser.Calc(p2)) + '''';
    4:
      begin
        s1 := InputBox('', frParser.Calc(p1), frParser.Calc(p2));
        val := '''' + s1 + '''';
      end;
    5: val := '''' + LowerCase(frParser.Calc(p1)) + '''';
    6: dk := dkMax;
    7: dk := dkMin;
    8:
      begin
        s1 := LowerCase(frParser.Calc(p1));
        if Length(s1) > 0 then
          val := '''' + UpperCase(s1[1]) + Copy(s1, 2, Length(s1) - 1) + ''''
        else
          val := '''' + '''';
      end;
    9: val := '%d''' + frParser.Calc(p1) + '''';
    10: val := '%t''' + frParser.Calc(p1) + '''';
    11: dk := dkSum;
    12: val := '''' + UpperCase(frParser.Calc(p1)) + '''';
  end;
  if dk <> dkNone then
  begin
    if dk = dkCount then
      DataSet := frGetDataSet(Report, p1)
    else
      frGetDataSetAndField(Report, p1, DataSet, Field);
    if (DataSet <> nil) and AggrBand.Visible then
    begin
      min := 1E200; max := -1E200; sum := 0; count := 0; avg := 0;
      DataSet.First;
      while not DataSet.Eof do
      begin
        v := 0;
        if dk <> dkCount then
          if Field.Value <> Null then
            v := Field.AsFloat
          else
            v := 0;
        if v > max then
          max := v;
        if v < min then
          min := v;
        sum := sum + v;
        count := count + 1;
        DataSet.Next;
      end;
      if count > 0 then
        avg := sum / count;
      d := 0;
      case dk of
        dkSum: d := sum;
        dkMin: d := min;
        dkMax: d := max;
        dkAvg: d := avg;
        dkCount: d := count;
      end;
      val := FloatToStr(d);
    end
    else if DataSet = nil then
    begin
      s1 := Trim(p2);
      if s1 = '' then
        s1 := CurBand.View.Name;
      if dk <> dkCount then
        s2 := Trim(p3)
      else
        s2 := Trim(p2);
      if (AggrBand.Typ in [btPageFooter, btMasterFooter, btDetailFooter,
        btSubDetailFooter, btGroupFooter, btCrossFooter, btReportSummary]) and
        ((s2 = '1') or ((s2 <> '1') and CurBand.Visible)) then
      begin
        VarName := List[FNo] + p1;
        if IsColumns then
          if AggrBand.Typ = btCrossFooter then
            VarName := VarName + '00'
          else
            VarName := VarName + IntToStr(CurPage.ColPos);
        if not AggrBand.Visible and (CompareText(CurBand.View.Name, s1) = 0) then
        begin
          s1 := AggrBand.Values.Values[VarName];
          if s1 <> '' then
            if s1[1] = '1' then
              Exit
            else
              s1 := Copy(s1, 2, 255);
          vv := 0;
          if dk <> dkCount then
            vv := frParser.Calc(p1);
          if vv = Null then
            vv := 0;
          d := vv;
          if s1 = '' then
            if dk = dkMin then
              s1 := '1e200'
            else if dk = dkMax then
              s1 := '-1e200'
            else
              s1 := '0';
          v := StrToFloat(s1);
          case dk of
            dkAvg: v := v + d;
            dkCount: v := v + 1;
            dkMax: if v < d then
                v := d;
            dkMin: if v > d then
                v := d;
            dkSum: v := v + d;
          end;
          AggrBand.Values.Values[VarName] := '1' + FloatToStr(v);
          Exit;
        end
        else if AggrBand.Visible then
        begin
          val := Copy(AggrBand.Values.Values[VarName], 2, 255);
          if dk = dkAvg then
            val := FloatToStr(StrToFloat(val) / AggrBand.Count);
          Exit;
        end;
      end;
    end;
  end;
end;


{-----------------------------------------------------------------------------}
const
  PropCount = 16;
  PropNames: array[0..PropCount - 1] of string =
  ('Left', 'Top', 'Width', 'Height', 'Flags', 'Visible', 'FrameType',
    'FrameWidth', 'FrameColor', 'FillColor', 'Text',
    'FontName', 'FontSize', 'FontStyle', 'FontColor', 'Adjust');
  ColNames: array[0..16] of string =
  ('clWhite', 'clBlack', 'clMaroon', 'clGreen', 'clOlive', 'clNavy',
    'clPurple', 'clTeal', 'clGray', 'clSilver', 'clRed', 'clLime',
    'clYellow', 'clBlue', 'clFuchsia', 'clAqua', 'clTransparent');

{$WARNINGS OFF}

procedure TInterpretator.GetValue(const Name: string; var Value: Variant);
var
  i: Integer;
  t: TfrView;
  b: TfrBand;
  Prop: string;
  Flag: Boolean;
begin
  Value := 0;
  t := CurView;
  Prop := Name;
  if frVariables.IndexOf(Name) <> -1 then
  begin
    Value := frVariables[Name];
    Exit;
  end;
  if Name = 'FREESPACE' then
  begin
    Value := IntToStr(CurPage.CurBottomY - CurPage.CurY);
    Exit;
  end;
  if Pos('.', Name) <> 0 then
  begin
    t := CurPage.FindRTObject(Copy(Name, 1, Pos('.', Name) - 1));
    Prop := Copy(Name, Pos('.', Name) + 1, 255);
  end;
  if t = nil then
  begin
    frParser.OnGetValue(Name, Value);
    Exit;
  end;
  Flag := False;
  for i := 0 to PropCount - 1 do
    if CompareText(PropNames[i], Prop) = 0 then
    begin
      Flag := True;
      break;
    end;
  if not Flag then
    for i := 0 to 16 do
      if CompareText(ColNames[i], Prop) = 0 then
      begin
        if i <> 16 then
          Value := frColors[i]
        else
          Value := clNone;
        Exit;
      end;

  if not Flag or ((i >= 11) and not (t is TfrMemoView)) then
  begin
    frParser.OnGetValue(Name, Value);
    Exit;
  end;
  if t is TfrBandView then
  begin
    b := t.Parent;
    case i of
      0: Value := b.x;
      1: Value := b.y;
      2: Value := b.dx;
      3: Value := b.dy;
      5: Value := b.Visible;
    end;
  end
  else
    case i of
      0: Value := t.x;
      1: Value := t.y;
      2: Value := t.dx;
      3: Value := t.dy;
      4: Value := t.Flags;
      5: Value := t.Visible;
      6: Value := t.FrameType;
      7: Value := t.FrameWidth;
      8: Value := t.FrameColor;
      9: Value := t.FillColor;
      10: Value := t.Memo.Text;
      11: Value := TfrMemoView(t).Font.Name;
      12: Value := TfrMemoView(t).Font.Size;
      13: Value := frGetFontStyle(TfrMemoView(t).Font.Style);
      14: Value := TfrMemoView(t).Font.Color;
      15: Value := TfrMemoView(t).Adjust;
    end;
end;
{$WARNINGS ON}

procedure TInterpretator.SetValue(const Name: string; Value: Variant);
var
  i: Integer;
  t: TfrView;
  b: TfrBand;
  Prop: string;
  Flag: Boolean;
begin
  t := CurView;
  Prop := Name;
  if Pos('.', Name) <> 0 then
  begin
    t := CurPage.FindRTObject(Copy(Name, 1, Pos('.', Name) - 1));
    Prop := Copy(Name, Pos('.', Name) + 1, 255);
  end;
//  if t = nil then Exit;
  Flag := False;
  for i := 0 to PropCount - 1 do
    if CompareText(PropNames[i], Prop) = 0 then
    begin
      Flag := True;
      break;
    end;
  if not Flag then
  begin
    frVariables[Name] := Value;
    Exit;
  end;
  if (i >= 11) and not (t is TfrMemoView) then
    Exit;
  if t is TfrBandView then
  begin
    b := t.Parent;
    case i of
      0: b.x := Value;
      1: b.y := Value;
      2: b.dx := Value;
      3: b.dy := Value;
      5: b.Visible := Value;
    end;
  end
  else
    case i of
      0: t.x := Value;
      1: t.y := Value;
      2: t.dx := Value;
      3: t.dy := Value;
      4: t.Flags := Value;
      5: t.Visible := Value;
      6: t.FrameType := Value;
      7: t.FrameWidth := Value;
      8: t.FrameColor := Value;
      9: t.FillColor := Value;
      10: t.Memo.Text := Value;
      11: TfrMemoView(t).Font.Name := Value;
      12: TfrMemoView(t).Font.Size := Value;
      13: TfrMemoView(t).Font.Style := frSetFontStyle(Value);
      14: TfrMemoView(t).Font.Color := Value;
      15: TfrMemoView(t).Adjust := Value;
    end;
end;

procedure TInterpretator.DoFunction(const Name: string; p1, p2, p3: Variant;
  var val: string);
begin
  if Name = 'NEWPAGE' then
  begin
    CurBand.ForceNewPage := True;
    Val := '0';
  end
  else if Name = 'NEWCOLUMN' then
  begin
    CurBand.ForceNewColumn := True;
    Val := '0';
  end
  else
    frParser.OnFunction(Name, p1, p2, p3, val);
end;


{----------------------------------------------------------------------------}

procedure TfrCompressor.Compress(StreamIn, StreamOut: TStream);
begin
// abstract method
end;

procedure TfrCompressor.DeCompress(StreamIn, StreamOut: TStream);
begin
// abstract method
end;

{----------------------------------------------------------------------------}

procedure DoInit;
const
  Clr: array[0..1] of TColor = (clWhite, clSilver);
var
  i, j: Integer;
begin
  SMemo := TStringList.Create;
  SBmp := TBitmap.Create;
  TempBmp := TBitmap.Create;
  SBmp.Width := 8; SBmp.Height := 8;
  TempBmp.Width := 8; TempBmp.Height := 8;
  for j := 0 to 7 do
    for i := 0 to 7 do
      SBmp.Canvas.Pixels[i, j] := Clr[(j + i) mod 2];

  frRegisterFunctionLibrary(TfrStdFunctionLibrary);
  frCharset := ARABIC_CHARSET; //DEFAULT_CHARSET; //zaher: ok dont do it again

  frParser := TfrParser.Create;
  frInterpretator := TInterpretator.Create;
  frVariables := TfrVariables.Create;
  frCompressor := TfrCompressor.Create;
  HookList := TList.Create;
end;

procedure DoExit;
var
  i: Integer;
begin
  SBmp.Free;
  TempBmp.Free;
  SMemo.Free;
  for i := 0 to frFunctionsCount - 1 do
    frFunctions[i].FunctionLibrary.Free;
  frParser.Free;
  frInterpretator.Free;
  frVariables.Free;
  frCompressor.Free;
  HookList.Free;
end;

procedure TfrPictureView.PictureChanged(Sender: TObject);
begin
  //SetBounds(0, 0, Picture.Width, Picture.Height);
end;

procedure TfrReport.PrintReport(PageNumbers: string; Copies: Integer);
begin
  PrepareReport;
  PrintPreparedReport(PageNumbers, Copies);
end;

{ TfrEditorForm }

constructor TfrEditorForm.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TfrReportDesigner then
    frDesigner := AOwner as TfrReportDesigner;
end;

{ TPropEditorForm }

function TPropEditorForm.ShowEditor: TModalResult;
begin
  Result := ShowModal;
end;

{ TfrPageInfo }

constructor TfrPageInfo.Create;
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

destructor TfrPageInfo.Destroy;
begin
  FreeAndNil(FStream);
  FreeAndNil(FPage);
  inherited;
end;

{ TfrViewList }

function TfrViewList.Add(frView: TfrView): Integer;
begin
  Result := inherited Add(frView);
end;

function TfrViewList.GetItem(Index: Integer): TfrView;
begin
  Result := inherited Items[Index] as TfrView;
end;

procedure TfrViewList.Insert(Index: Integer; frView: TfrView);
begin
  inherited Insert(Index, frView);
end;

procedure TfrViewList.SetItem(Index: Integer; const Value: TfrView);
begin
  inherited Items[Index] := Value;
end;

{ TfrTextInfo }

constructor TfrTextInfo.Create;
begin

end;

destructor TfrTextInfo.Destroy;
var
  p, p1: TfrTextInfo;
begin
  p := Next;
  while p <> nil do
  begin
    p1 := p;
    p := p.Next;
    p1.Free;
  end;
  inherited;
end;

{------------------------------------------------------------------------------}

constructor TfrVariables.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
end;

destructor TfrVariables.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TfrVariables.Clear;
begin
  FList.Clear;
end;

procedure TfrVariables.SetVariable(Name: string; Value: Variant);
var
  i: Integer;
  v: TFRVariable;
begin
  for i := 0 to FList.Count - 1 do
    if CompareText(TFRVariable(FList[i]).Name, Name) = 0 then
    begin
      TFRVariable(FList[i]).Value := Value;
      Exit;
    end;
  v := TFRVariable.Create;
  v.Name := Name;
  v.Value := Value;
  FList.Add(v);
end;

function TfrVariables.GetVariable(Name: string): Variant;
var
  i: Integer;
begin
  Result := NULL;
  for i := 0 to FList.Count - 1 do
    if CompareText(TFRVariable(FList[i]).Name, Name) = 0 then
    begin
      Result := TFRVariable(FList[i]).Value;
      break;
    end;
end;

procedure TfrVariables.SetValue(Index: Integer; Value: Variant);
begin
  if (Index < 0) or (Index >= FList.Count) then
    Exit;
  TFRVariable(FList[Index]).Value := Value;
end;

function TfrVariables.GetValue(Index: Integer): Variant;
begin
  Result := 0;
  if (Index < 0) or (Index >= FList.Count) then
    Exit;
  Result := TFRVariable(FList[Index]).Value;
end;

function TfrVariables.IndexOf(Name: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FList.Count - 1 do
    if CompareText(TFRVariable(FList[i]).Name, Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

function TfrVariables.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TfrVariables.GetName(Index: Integer): string;
begin
  Result := '';
  if (Index < 0) or (Index >= FList.Count) then
    Exit;
  Result := TFRVariable(FList[Index]).Name;
end;

procedure TfrVariables.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

procedure TfrReport.DoTerminate(Sender: TObject);
begin
  Terminated := True;
end;

procedure TfrReport.DoLoadFromFile(AName: string);
begin
  if Assigned(FOnLoadFromFile) then
    FOnLoadFromFile(AName)
  else
    InternalLoadFromFile(AName);
end;

procedure TfrReport.DoSaveToFile(AName: string);
begin
  if Assigned(FOnSaveToFile) then
    FOnSaveToFile(AName)
  else
    InternalSaveToFile(AName);
end;

procedure TfrReport.LoadFromFile(FName: string; UseDefault: Boolean);
begin
  if UseDefault then
    InternalLoadFromFile(FName)
  else
    DoLoadFromFile(FName);
end;

procedure TfrReport.SaveToFile(FName: string; UseDefault: Boolean);
begin
  if UseDefault then
    InternalSaveToFile(FName)
  else
    DoSaveToFile(FName);
end;

initialization
  DoInit;
finalization
  DoExit;
end.

