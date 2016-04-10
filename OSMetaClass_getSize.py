from idautils import *
from idaapi import *

funName = '__ZN11OSMetaClassC2EPKcPKS_j'


def getRegValue(reg,ea):
    startEa = GetFunctionAttr(ea,FUNCATTR_START)
    while reg not in GetOpnd(ea,0) and ea > startEa:#rcx or ecx
        ea = FindCode(ea,SEARCH_UP)
    if 'mov' in GetMnem(ea): #mov
        if GetOpType(ea,1) == o_imm:
            return GetOpnd(ea,1)
        if 'cs:' in GetOpnd(ea,1):#mov rcx,cs:xxx
            xxx = GetOperandValue(ea,1)
            return GetDisasm(LocByName(xxx)).split(' ')[1]

    if 'lea' in GetMnem(ea):#lea
        xxx = GetOperandValue(ea,1)
        return GetDisasm(LocByName(xxx)).split(' ')[1]
    
    

def getObjSize(ea):
    startEa = GetFunctionAttr(ea,FUNCATTR_START)
    while 'cx' not in GetOpnd(ea,0) and ea > startEa:#rcx or ecx
        ea = FindCode(ea,SEARCH_UP)
    if 'mov' in GetMnem(ea): #mov
        if GetOpType(ea,1) == o_imm:
            return GetOpnd(ea,1)
        if 'cs:' in GetOpnd(ea,1):#mov rcx,cs:xxx
            xxx = GetOperandValue(ea,1)
            return GetDisasm(LocByName(xxx)).split(' ')[1]

    if 'lea' in GetMnem(ea):#lea
        xxx = GetOperandValue(ea,1)
        return GetDisasm(LocByName(xxx)).split(' ')[1]

funea = LocByName(funName)
for xref in XrefsTo(funea):
    objsize = getObjSize(xref.frm)
    print 'addr:0x%x  objsize:%s' % (xref.frm,objsize)