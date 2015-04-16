#include "qeushullybin.h"

QEushullyBIN::QEushullyBIN(QObject *parent) :
    QObject(parent)
{
}

bool QEushullyBIN::load(QEushullyFile &file)
{
    file.seek(0);
    file.read((char*)&this->m_header, sizeof(BINHeader));
    if (memcmp(this->m_header.sign, BIN_SIGN, 3) != 0)
        return false;

    this->m_name = file.getName();

    quint32 infos[this->m_header.offset_71];
    file.read((char*)infos, this->m_header.offset_71 * 4);
    for (quint32 i=0 ; i<this->m_header.offset_71 ; i++)
        this->m_script_raw.append(infos[i]);
    this->m_script.parse(this->m_script_raw);

    file.seek(this->m_header.offset_71*4);
    quint32 data_71[this->m_header.size_71];
    file.read((char*)data_71, this->m_header.size_71*4);
    for (quint32 j=0 ; j<this->m_header.size_71 ; j++)
        this->m_subs[0].append(data_71[j]);

    file.seek(this->m_header.offset_03*4);
    quint32 data_03[this->m_header.size_03];
    file.read((char*)data_03, this->m_header.size_03*4);
    for (quint32 j=0 ; j<this->m_header.size_03 ; j++)
        this->m_subs[1].append(data_03[j]);

    file.seek(this->m_header.offset_8f*4);
    quint32 data_8f[this->m_header.size_8f];
    file.read((char*)data_8f, this->m_header.size_8f*4);
    for (quint32 j=0 ; j<this->m_header.size_8f ; j++)
        this->m_subs[2].append(data_8f[j]);

    return true;
}

void QEushullyBIN::close()
{
    //
}

QString QEushullyBIN::getName()
{
    return this->m_name;
}

QEushullyScript *QEushullyBIN::getScript()
{
    return &this->m_script;
}

QStringList QEushullyBIN::getStringsRAW()
{
    //
}

bool QEushullyBIN::is_format(QEushullyFile &file)
{
    BINHeader header;
    file.read((char*)&header, sizeof(BINHeader));
    return (memcmp(header.sign, BIN_SIGN, 3) == 0);
}

BINHeader QEushullyBIN::header()
{
    return this->m_header;
}
