#include "qeushullyfile.h"
#include "qeushullygame.h"

extern QEushullyGame eushully_game;

QEushullyFile::QEushullyFile(QObject *parent) :
    QObject(parent)
{
    this->m_file.length = (quint32)-1;
}

bool QEushullyFile::open(const QString name)
{
    QEushullyALF *alf;
    if ((alf = eushully_game.get_FS()->get_archive_by_file(name)) == NULL)
        return false;

    this->m_file = alf->open(name);

    // try open extracted file
    this->m_f.setFileName(eushully_game.get_FS()->get_root() + name);
    if (this->m_f.exists())
    {
        this->m_f.open(QIODevice::ReadOnly);
        this->m_file.offset = 0;
        this->m_file.length = this->m_f.size();
        this->m_file.pos = 0;
    }
    else
    {
        this->m_f.setFileName(this->m_file.archive_name);
        this->m_f.open(QIODevice::ReadOnly);
        this->m_file.pos = 0;
    }
    return (this->m_file.length != quint32(-1));
}

void QEushullyFile::close()
{
    this->m_f.close();
    this->m_file.length = (quint32)-1;
}

QString QEushullyFile::getName()
{
    return this->m_file.file_name;
}

int QEushullyFile::read(char *buf, int size)
{
    if (this->m_file.pos+size > this->m_file.length)
        size = this->m_file.length - this->m_file.pos;
    this->m_f.seek(this->m_file.offset + this->m_file.pos);
    int readed = this->m_f.read(buf, size);
    this->m_file.pos += readed;
    return readed;
}

quint32 QEushullyFile::seek(quint32 seek)
{
    this->m_file.pos = ((this->m_file.length < seek) ? this->m_file.length : seek);
    return this->m_file.pos;
}

quint32 QEushullyFile::size()
{
    return this->m_file.length;
}

QString QEushullyFile::size_human()
{
     float num = this->m_file.length;
     QStringList list;
     list << "KB" << "MB" << "GB" << "TB";

     QStringListIterator i(list);
     QString unit("bytes");

     while(num >= 1024.0 && i.hasNext())
      {
         unit = i.next();
         num /= 1024.0;
     }
     return QString().setNum(num,'f',2)+" "+unit;
}

QString QEushullyFile::size_human(QString filename)
{
    QEushullyALF *alf;
    if ((alf = eushully_game.get_FS()->get_archive_by_file(filename)) == NULL)
        return "-1";

    // try open extracted file
    QFile file;
    file.setFileName(eushully_game.get_FS()->get_root() + filename);
    AlfFile file_info = alf->open(filename);
    if (file.exists())
    {
        file.open(QIODevice::ReadOnly);
        file_info.length = file.size();
        file.close();
    }


     float num = file_info.length;
     QStringList list;
     list << "KB" << "MB" << "GB" << "TB";

     QStringListIterator i(list);
     QString unit("bytes");

     while(num >= 1024.0 && i.hasNext())
      {
         unit = i.next();
         num /= 1024.0;
     }
     return QString().setNum(num,'f',2)+" "+unit;
}
