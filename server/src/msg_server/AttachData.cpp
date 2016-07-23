/*
 * AttachData.cpp
 *
 *  Created on: 2014年4月16日
 *      Author: ziteng
 */


#include "AttachData.h"
//--> use simplebuffer write parameters to m_buf
CDbAttachData::CDbAttachData(uint32_t type, uint32_t handle, uint32_t service_type /* = 0 */)			// 序列化
{
	CByteStream os(&m_buf, 0);

	os << type;
	os << handle;
    os << service_type;
    wstring wstrIn;
}
//--> read from buf,len to fill m_xxx field
CDbAttachData::CDbAttachData(uchar_t* attach_data, uint32_t attach_len)	// 反序列化
{
	CByteStream is(attach_data, attach_len);

	is >> m_type;
	is >> m_handle;
    is >> m_service_type;
}
//--> use simplebuffer write parameters to m_buf
CPduAttachData::CPduAttachData(uint32_t type, uint32_t handle, uint32_t pduLength, uchar_t* pdu, uint32_t service_type) // 序列化
{
    CByteStream os(&m_buf, 0);
    
	os << type;
	os << handle;
    os << service_type;
    os.WriteData(pdu, pduLength);
}
//--> read from buf,len to fill m_xxx field
CPduAttachData::CPduAttachData(uchar_t* attach_data, uint32_t attach_len) // 反序列化
{
    CByteStream is(attach_data, attach_len);
    
	is >> m_type;
	is >> m_handle;
    is >> m_service_type;
    m_pdu = is.ReadData(m_pduLength);
}
