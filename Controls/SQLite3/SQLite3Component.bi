'################################################################################
'#  SQLite3Component.bi                                                         #
'#  Based on:                                                                   #
'#   ClsSqlite3.inc                                                             #
'#   VisualFreeBasic Controls                                                   #
'#   Copyright (c) 2022 Yongfang Software Development Team www.yfvb.com         #
'#   Version 2.0.0.105                                                          #
'#  Adapted to Visual FB Editor ToolBox                                         #
'#  by Xusinboy Bekchanov (2022)                                                #
'################################################################################

#include once "mff/Component.bi"
#include once "sqlite3.bi"

Using My.Sys.ComponentModel

Type SQLite3Component Extends Component
Private:
	ErrStr          As UStringX
	Transaction     As Long
	EventsEn        As Long
Protected:
	FSQLite3 As sqlite3 Ptr
	FSQLite3Mem As sqlite3 Ptr
	FSynchronization As Integer
	Declare Function Event_Send(code As Long, ByRef Event_Data As WString) As Long
Public:
	Declare Function ReadProperty(PropertyName As String) As Any Ptr
	Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
	Declare Function Open(ByRef FileName As WString, ByRef Password As WString = "") As Boolean
	Declare Function MemOpen(sFileName As UStringX = "", Password As UStringX = "", Synchronization As Boolean = 0) As Boolean
	Declare Function MemSave() As Boolean
	Declare Function Find(Table As UStringX, Cond As UStringX, rs_Utf8() As String, Col As UStringX = "*", Orderby As UStringX = "", Page As Long = 1, Pagesize As Long = 0) As Long
	Declare Function FindUtf(Table_Utf8 As String, Cond_Utf8 As String, rs_Utf8() As String, Col_Utf8 As String = "*", Orderby_Utf8 As String = "", Page As Long = 1, Pagesize As Long = 0) As Long
	Declare Function FindByte(Table As UStringX, Cond As UStringX, rs_Utf8() As String, rs_Types() As Long, Col As UStringX = "*", Orderby As UStringX = "", Page As Long = 1, Pagesize As Long = 0)                        As Long
	Declare Function FindByteUtf(Table_Utf8 As String, Cond_Utf8 As String, rs_Utf8() As String, rs_Types() As Long, Col_Utf8 As String = "*", Orderby_Utf8 As String = "", Page As Long = 1, Pagesize As Long = 0) As Long
	Declare Function FindOne(Table As UStringX, Cond As UStringX, rs_Utf8() As String, Col As UStringX = "*", Orderby As UStringX = "") As Long
	Declare Function FindOneUtf(Table_Utf8 As String, Cond_Utf8 As String, rs_Utf8() As String, Col_Utf8 As String = "*", Orderby_Utf8 As String = "") As Long
	Declare Function FindOneByte(Table As UStringX, Cond As UStringX, rs_Utf8() As String, rs_Types() As Long, Col As UStringX = "*", Orderby As UStringX = "")                        As Long
	Declare Function FindOneByteUtf(Table_Utf8 As String, Cond_Utf8 As String, rs_Utf8() As String, rs_Types() As Long, Col_Utf8 As String = "*", Orderby_Utf8 As String = "") As Long
	Declare Function FindOnly(Table As UStringX, Cond As UStringX, Col As UStringX = "*", Orderby As UStringX = "") As String
	Declare Function FindOnlyUtf(Table_Utf8 As String, Cond_Utf8 As String, Col_Utf8 As String = "*", Orderby_Utf8 As String = "") As String
	Declare Function Insert(Table As UStringX, nList As UStringX)                                                                           As Long
	Declare Function InsertUtf(Table_Utf8 As String, nList_Utf8 As String)                                                            As Long
	Declare Function AddItem(Table As UStringX, nList As UStringX)                                                                          As Long
	Declare Function AddItemUtf(Table_Utf8 As String, nList_Utf8 As String)                                                           As Long
	Declare Function Update(Table As UStringX, Cond As UStringX, upList As UStringX)                                                           As Long
	Declare Function UpdateUtf(Table_Utf8 As String, Cond_Utf8 As String, upList_Utf8 As String)                                      As Long
	Declare Function UpdateText(Table As UStringX, Cond As UStringX, ColName As UStringX, Text_Utf8 As String)                                 As Long
	Declare Function UpdateTextUtf(Table_Utf8 As String, Cond_Utf8 As String, ColName_Utf8 As String, Text_Utf8 As String)            As Long
	Declare Function UpdateByte(Table As UStringX, Cond As UStringX, ColName As UStringX, nByte As Any Ptr, nLen As Long)                      As Long
	Declare Function UpdateByteUtf(Table_Utf8 As String, Cond_Utf8 As String, ColName_Utf8 As String, nByte As Any Ptr, nLen As Long) As Long
	Declare Function DeleteItem(Table As UStringX, Cond As UStringX)                                       As Long
	Declare Function DeleteItemUtf(Table_Utf8 As String, Cond_Utf8 As String)                        As Long
	Declare Function Count(Table As UStringX, Cond As UStringX = "")                                       As Long
	Declare Function CountUtf(Table_Utf8 As String, Cond_Utf8 As String = "")                        As Long
	Declare Function Sum(Table As UStringX, Cond As UStringX, ColName As UStringX)                            As LongInt
	Declare Function SumUtf(Table_Utf8 As String, Cond_Utf8 As String, ColName_Utf8 As String)       As LongInt
	Declare Function MaxID(Table As UStringX, nField As UStringX, Cond As UStringX = "")                      As Long
	Declare Function MaxIDUtf(Table_Utf8 As String, nField_Utf8 As String, Cond_Utf8 As String = "") As Long
	
	Declare Function INIGetKey(lSection As UStringX, lKeyName As UStringX, lDefault As UStringX = "") As UStringX
	Declare Function INISetKey(lSection As UStringX, lKeyName As UStringX, nValue As UStringX)        As Boolean
	
	Declare Function Exec(Sql_Utf8 As String) As Long
	
	Declare Function SQLFind(Sql_Utf8 As String, rs_Utf8() As String)    As Long
	Declare Function SQLFindOne(Sql_Utf8 As String, rs_Utf8() As String) As Long
	Declare Function CreateTable(Table As UStringX)                         As Long
	Declare Function CreateTableUtf(Table_Utf8 As String)                As Long
	Declare Function CreateIndex(Table As UStringX, IndexName As UStringX, FieldList As UStringX, Unique As Boolean = 0)                      As Long
	Declare Function CreateIndexUtf(Table_Utf8 As String, IndexName_Utf8 As String, FieldList_Utf8 As String, Unique As Boolean = 0) As Long
	Declare Function AddField(Table As UStringX, nField As UStringX, nType As UStringX, Default As UStringX = "", nNull As Boolean = 0)          As Long
	
	Declare Function Vacuum()                        As Long
	Declare Function GetSQLitePtr(Index As Long = 0) As sqlite3 Ptr
	
	Declare Sub TransactionBegin()
	Declare Function TransactionEnd()        As Long
	Declare Function TransactionRollback()   As Long
	Declare Function Version()               As String
	Declare Function ErrMsg()                As String
	Declare Function SetKey(newkey As UStringX) As Boolean
	Declare Sub Close()
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
	OnSQLString As Function(ByRef Sender As SQLite3Component, Sql_Utf8 As String) As Long
	OnErrorOut As Sub(ByRef Sender As SQLite3Component, ErrorTxt As String)
End Type

#ifndef __USE_MAKE__
	#include once "SQLite3Component.bas"
#endif
