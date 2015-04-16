#ifndef QEUSHULLYALF_H
#define QEUSHULLYALF_H

#include <QObject>
#include <QFile>
#include <QStringList>
#include <QMap>

    #define ALF_SIGNATURE_APPEND    "S4AC"
    #define ALF_SIGNATURE_DATA      "S4IC"
    #define ALF_FILE_ENTRY_NAME_LEN 64
    #define ALF_ARCHIVE_NAME_LEN    256

    enum EAlfType {ALF_DATA, ALF_APPEND, ALF_UNK};

    struct AlfHeader
    {
        char    sign[4];
        char    version[3];
        char    space;
        char    title[232];
    };

    struct AlfDataHeader
    {
        quint32 d1;
        quint32 d2;
        quint32 d3;
        quint32 d4; // always 0x00000001
        quint32 d5; // always 0x00000001
        quint32 d6; // always 0x00000001
        quint32 d7; // always 0x00000280
        quint32 d8; // always 0x000001e0
        quint32 d9; // always 0x00000010
        quint32 d10;
        quint32 d11;
        quint32 d12;
        quint32 d13;// always 0x00000002
        quint32 d14;// always 0x00000002
        quint32 d15;// always 0x00000002
    };

    struct AlfAppendHeader
    {
        quint32 d1;
        quint32 d2;
        quint32 d3;
        quint32 d4;
        quint32 d5;
        quint32 d6;
        quint32 appen_no;
    };

    struct AlfFileEntry
    {
        char        file_name[ALF_FILE_ENTRY_NAME_LEN];
        quint32     archive_index;
        quint32     file_index;
        quint32     offset;
        quint32     length;
    };

    struct AlfData1Header
    {
        quint32     d1;
        quint32     d2;
        quint32     data_count;
    };

    struct AlfSettingsHeader
    {
        quint32     data_size;
        quint32     d1;
    };

    struct AlfFile
    {
        QString     archive_name;
        QString     file_name;
        quint32     offset;
        quint32     length;
        quint32     pos;
    };

    class QEushullyALF : public QObject
    {
        Q_OBJECT
    private:
        QString             m_file_name;
        QString             m_root;
        AlfHeader           m_header;
        AlfDataHeader       m_data_header;
        AlfAppendHeader     m_append_header;
        QStringList         m_archives;
        QList<AlfFileEntry> m_files;
        AlfData1Header      m_data1_header;
        QList<quint32>      m_data1;
        AlfSettingsHeader   m_setings_header;
        QMap<QString,QString>m_settings;
    public:
        explicit QEushullyALF(QObject *parent = 0);

        bool load_from_file(const QString filename);
        bool load_from_file(QFile &file);
        EAlfType get_type();

        int get_files_count();
        QString get_file_name(int idx);
        quint32 get_file_size(int idx);
        bool is_exist(const QString filename);
        AlfFile open(const QString filename);

        int get_settings_count();
        QString get_setting_name(int idx);
        QString get_setting_value(int idx);
        QString get_setting_value(QString name);

        static bool is_format(const QString file_name);

    signals:

    public slots:

    };


#endif // QEUSHULLYALF_H
