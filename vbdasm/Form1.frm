VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6915
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3765
   ScaleWidth      =   6915
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Courier"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3540
      Left            =   60
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   0
      Width           =   6735
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'sample using libdasm from vb6
'https://github.com/jtpereyda/libdasm

'VB6 Wrapper by:  dzzie@yahoo.com  http://sandsprite.com
'same license as libdasm

'to make libdasm compatiable with vb6 compile as a dll and add following to top of libdasm.c
'  #define EXPORT comment(linker, "/EXPORT:"__FUNCTION__"="__FUNCDNAME__)
'
'  change following prototypes to stdcall and add #pragma EXPORT to first line of function body
'       int __stdcall get_instruction
'       int __stdcall get_instruction_string
'       {
'       #pragma EXPORT
'
'precompiled version is available at https://github.com/dzzie/libs/tree/master/libdasm

Private Type Operand
    operType As Long       ' Operand type (register, memory, etc) - enum Operand
    reg As Long            ' Register (if any)
    basereg As Long        ' Base register (if any)
    indexreg As Long       ' Index register (if any)
    scale As Long          ' Scale (if any)
    dispbytes As Long      ' Displacement bytes (0 = no displacement)
    dispoffset As Long     ' Displacement value offset
    immbytes As Long       ' Immediate bytes (0 = no immediate)
    immoffset As Long      ' Immediate value offset
    sectionbytes As Long   ' Section prefix bytes (0 = no section prefix)
    section As Integer     ' Section prefix value
    displacement As Long   ' Displacement value
    immediate As Long      ' Immediate value
    flags As Long          ' Operand flags
End Type

Private Type INSTRUCTION
    length As Long          'Instruction length
    instType As Long        'Instruction type - enum Instruction
    addrMode As Long        'Addressing mode  - enum Mode  //OffsetOf i.mode = 8
    opcode As Byte          'Actual opcode
    modrm As Byte           'MODRM byte
    sib As Byte             'SIB byte
    extindex As Long        'Extension table index
    fpuindex As Long        'FPU table index
    dispbytes As Long       'Displacement bytes (0 = no displacement)
    immbytes As Long        'Immediate bytes (0 = no immediate)
    sectionbytes As Long    'Section prefix bytes (0 = no section prefix)
    op1 As Operand          'First operand (if any)
    op2 As Operand          'Second operand (if any)
    op3 As Operand          'Additional operand (if any)
    ptr As Long             'Pointer to instruction table
    flags As Long           'Instruction flags
End Type

Enum disasmMode
    MODE_32 = 0
    MODE_16 = 1
End Enum

Enum disasmFormat
    FORMAT_ATT = 0
    FORMAT_INTEL = 1
End Enum

'int __stdcall get_instruction(PINSTRUCTION inst, BYTE *addr, enum Mode mode)
Private Declare Function get_instruction Lib "libdasm.dll" ( _
    ByRef inst As INSTRUCTION, _
    ByRef src As Byte, _
    Optional ByVal m As disasmMode = MODE_32 _
) As Long

'int __stdcall get_instruction_string(INSTRUCTION *inst, enum Format format, DWORD offset, char *string, int length)
Private Declare Function get_instruction_string Lib "libdasm.dll" ( _
    ByRef inst As INSTRUCTION, _
    ByVal fmt As disasmFormat, _
    ByVal offset As Long, _
    ByRef buf As Byte, _
    ByVal bufLen As Long _
) As Long
 
Private Sub Form_Load()
    
    Dim i As INSTRUCTION
    Dim o As Operand
    Dim sz As Long, ptr As Long, rv As Long
    Dim b() As Byte, buf() As Byte
    Dim baseOffset As Long
    
    
    'Size of i = 0xd4, sizeof o = 0x38
    'printf("Size of i = 0x%x, sizeof o = 0x%x\n", sizeof(i), sizeof(o));
    
    'i = 0xD4   o = 0x38
    'Text1 = " i = 0x" & Hex(LenB(i)) & "   o = 0x" & Hex(LenB(o))
    
'    00131C40   8BFF             MOV EDI,EDI     ;random grab from olly
'    00131C42   55               PUSH EBP
'    00131C43   8BEC             MOV EBP,ESP
'    00131C45   E8 06F4FFFF      CALL 00131050
'    00131C4A   E8 11000000      CALL 00131C60
'    00131C4F   5D               POP EBP
'    00131C50   C3               RETN

'    00131C40   8BFF             mov edi,edi    ;program output
'    00131C42   55               push ebp
'    00131C43   8BEC             mov ebp,esp
'    00131C45   E806F4FFFF       call 0x131050
'    00131C4A   E811000000       call 0x131c60
'    00131C4F   5D               pop ebp
'    00131C50   C3               ret

    ReDim buf(255)
    baseOffset = &H131C40
    
    b() = toBytes("8BFF 55 8BEC E8 06F4FFFF E8 11000000 5d c3")
    
    If AryIsEmpty(b) Then
        Text1 = "Failed to convert hex to bytes"
        Exit Sub
    End If
   
    Dim offsets() As Long
    Dim dump() As String
    Dim disasm() As String
    Dim final() As String
    Dim maxLen As Long
    Dim ii As Long
    
    Do
        sz = get_instruction(i, b(ptr))
        If sz = 0 Then Exit Do
        
        rv = get_instruction_string(i, FORMAT_INTEL, baseOffset, buf(0), UBound(buf))
        If rv = 0 Then Exit Do
        
        push offsets, baseOffset
        push dump, dumpBytes(b, ptr, sz, maxLen)
        push disasm, Replace(StrConv(buf, vbUnicode, &H409), Chr(0), Empty)
        
        ptr = ptr + sz
        baseOffset = baseOffset + sz
        If ptr > UBound(b) Then Exit Do
        
    Loop While 1
    
    For ii = 0 To UBound(offsets)
        push final, Right("0000000" & Hex(offsets(ii)), 8) & "   " & Rpad(dump(ii), maxLen + 7) & disasm(ii)
    Next
    
    Text1 = Join(final, vbCrLf)
     
End Sub

Function Rpad(v, Optional l As Long = 8, Optional char As String = " ")
    On Error GoTo hell
    Dim X As Long
    X = Len(v)
    If X < l Then
        Rpad = v & String(l - X, char)
    Else
hell:
        Rpad = v
    End If
End Function

'todo: add spacers between opcode bytes and arg bytes?
Private Function dumpBytes(b() As Byte, start As Long, sz As Long, ByRef maxLen As Long)
    
    On Error Resume Next
    Dim i As Long
    
    For i = start To start + sz - 1
       dumpBytes = dumpBytes & Right("0" & Hex(b(i)), 2)
    Next
    
    If Len(dumpBytes) > maxLen Then maxLen = Len(dumpBytes)
    
End Function

Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo Init
    Dim X As Long
    X = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
Init:     ReDim ary(0): ary(0) = value
End Sub

Public Function toBytes(ByVal hexstr) As Byte()
    
    Dim i As Long, b() As Byte, l As Long, tmp As String, j As Long
    
    
    hexstr = Replace(hexstr, " ", Empty)
    
    l = Len(hexstr)
    If l Mod 2 <> 0 Then Exit Function 'handles 0 len

    ReDim b((l / 2) - 1)
    For i = 1 To l Step 2
        tmp = Mid(hexstr, i, 2)
        b(j) = CByte(CLng("&h" & tmp))
        j = j + 1
    Next
    
    toBytes = b()
    
End Function



Function AryIsEmpty(ary) As Boolean
  On Error GoTo oops
    Dim i As Long
    i = UBound(ary)  '<- throws error if not initalized
    AryIsEmpty = False
  Exit Function
oops: AryIsEmpty = True
End Function
