#include "qeushullyalf.h"
#include "lzss.h"
#include <QFile>
#include <QFileInfo>

    QEushullyALF::QEushullyALF(QObject *parent) :
        QObject(parent)
    {
    }

    bool QEushullyALF::is_format(const QString file_name)
    {
        QFile file(file_name);
        file.open(QIODevice::ReadOnly);
        char sign[4];
        file.read(sign, 4);
        file.close();

        return ((memcmp(sign, ALF_SIGNATURE_DATA, 4)==0) ||
                (memcmp(sign, ALF_SIGNATURE_APPEND, 4)==0));
    }

    bool QEushullyALF::load_from_file(const QString filename)
    {
        this->m_file_name = filename;

        QFile file(this->m_file_name);
        file.open(QIODevice::ReadOnly);

        bool ret = this->load_from_file(file);
        file.close();
        return ret;
    }

    bool QEushullyALF::load_from_file(QFile &file)
    {
        this->m_file_name = file.fileName();
        QFileInfo info(this->m_file_name);
        this->m_root = info.path().append('/');
        // reading header & check signature
        file.read((char*)&this->m_header, sizeof(AlfHeader));
        if (memcmp(this->m_header.sign, ALF_SIGNATURE_DATA, 4)==0)
            file.read((char*)&this->m_data_header, sizeof(AlfDataHeader));
        else
            file.read((char*)&this->m_append_header, sizeof(AlfAppendHeader));

        if (this->get_type() == ALF_UNK)
            return false;

        quint32 header_size;
        QByteArray header;
        read_sect(file, header, header_size);

        QDataStream stream(header);
        quint32 archive_count;

        // reading archives list
        stream.readRawData((char*)&archive_count, sizeof(quint32));
        for (quint32 i=0 ; i<archive_count ; i++)
        {
            char fn[ALF_ARCHIVE_NAME_LEN];
            stream.readRawData(&fn[0], ALF_ARCHIVE_NAME_LEN);
            this->m_archives.append(QString(fn));
        }

        // reading files entry list
        quint32 m_files_count;
        stream.readRawData((char*)&m_files_count, sizeof(quint32));
        for (quint32 i=0 ; i<m_files_count ; i++)
        {
            AlfFileEntry entry;
            stream.readRawData((char*)&entry, sizeof(AlfFileEntry));
            this->m_files.append(entry);
        }

        if (!stream.atEnd())
        {
            stream.readRawData((char*)&this->m_data1_header, sizeof(AlfData1Header));
            quint32 data[this->m_data1_header.data_count];
            stream.readRawData((char*)data, this->m_data1_header.data_count * sizeof(quint32));
            for (quint32 i=0 ; i<this->m_data1_header.data_count ; i++)
                this->m_data1.append(data[i]);

            stream.readRawData((char*)&this->m_setings_header, sizeof(AlfSettingsHeader));
            char settings[this->m_setings_header.data_size];
            stream.readRawData((char*)settings, this->m_setings_header.data_size);
            char *raw = &settings[0];
            for (quint32 i=0 ; i<this->m_setings_header.d1 ; i++)
            {
                QString name = QString::fromLatin1(raw);
                raw += name.length() + 1;
                QString value = QString::fromLatin1(raw);
                raw += value.length() + 1;
                this->m_settings.insert(name, value);
            }
        }

        // reading custom data
        /*if (!stream.atEnd())
        {
            quint32 custom_data_size = quint32(stream.device()->size() - stream.device()->pos());
            this->m_custom_data.resize(custom_data_size);
            stream.readRawData(this->m_custom_data.data(), custom_data_size);
        }*/

        header.clear();
        return true;
    }

    EAlfType QEushullyALF::get_type()
    {
        if (memcmp(this->m_header.sign, ALF_SIGNATURE_DATA, 4) ==0)
            return ALF_DATA;
        else if (memcmp(this->m_header.sign, ALF_SIGNATURE_APPEND, 4) ==0)
            return ALF_APPEND;
        else
            return ALF_UNK;
    }

    int QEushullyALF::get_files_count()
    {
        return this->m_files.count();
    }

    QString QEushullyALF::get_file_name(int idx)
    {
        if (idx >= this->m_files.count())
            return "";
        else
            return QString(this->m_files.at(idx).file_name);
    }

    quint32 QEushullyALF::get_file_size(int idx)
    {
        if (idx >= this->m_files.count())
            return (quint32)-1;
        else
            return this->m_files.at(idx).length;
    }

    bool QEushullyALF::is_exist(const QString filename)
    {
        for (int i=0 ; i<this->m_files.count() ; i++)
        {
            if (filename.compare(this->m_files.at(i).file_name, Qt::CaseInsensitive) == 0)
                return true;
        }
        return false;
    }

    AlfFile QEushullyALF::open(const QString filename)
    {
        AlfFile ret;
        ret.length = quint32(-1);
        for (int i=0 ; i<this->m_files.count() ; i++)
        {
            if (filename.compare(this->m_files.at(i).file_name, Qt::CaseInsensitive) == 0)
            {
                AlfFileEntry entry = this->m_files.at(i);
                ret.length = entry.length;
                ret.offset = entry.offset;
                ret.file_name = QString(entry.file_name);
                ret.archive_name = this->m_root + this->m_archives.at(entry.archive_index);
                return ret;
            }
        }
        return ret;
    }

    int QEushullyALF::get_settings_count()
    {
        return this->m_settings.count();
    }

    QString QEushullyALF::get_setting_name(int idx)
    {
        return this->m_settings.keys().at(idx);
    }

    QString QEushullyALF::get_setting_value(int idx)
    {
        return this->m_settings.value(this->m_settings.keys().at(idx));
    }

    QString QEushullyALF::get_setting_value(QString name)
    {
        return this->m_settings.value(name);
    }
