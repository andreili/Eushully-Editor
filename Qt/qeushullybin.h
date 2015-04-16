#ifndef QEUSHULLYBIN_H
#define QEUSHULLYBIN_H

#include <QObject>
#include <QList>
#include <QFile>
#include <QString>
#include <QStringList>
#include "qeushullyfile.h"
#include "qeushullyscript.h"

#define BIN_SIGN    "SYS"

struct BINSubRecord
{
    quint32     count;
    quint32     offset;
};

struct BINHeader
{
    char        sign[3];        // always "SYS"
    char        version[4];
    char        space;
    quint32     type;
    quint32     d1;
    quint32     d2;
    quint32     d3;
    quint32     d4;
    quint32     d5;
    quint32     offsets_size;   // always 0x1C (include here value)
    quint32     size_71;
    quint32     offset_71;
    quint32     size_03;
    quint32     offset_03;
    quint32     size_8f;
    quint32     offset_8f;
    //BINSubRecord    subs[3];

};

class QEushullyBIN : public QObject
{
    Q_OBJECT
private:
    QString         m_name;
    BINHeader       m_header;
    QList<quint32>  m_script_raw;
    QList<quint32>  m_subs[3];
    QEushullyScript m_script;
public:
    explicit QEushullyBIN(QObject *parent = 0);

    bool load(QEushullyFile &file);
    void close();

    QString getName();
    QEushullyScript *getScript();

    QStringList getStringsRAW();
    
    static bool is_format(QEushullyFile &file);

    BINHeader header();
signals:
    
public slots:
    
};

#endif // QEUSHULLYBIN_H
