#ifndef QEUSHULLYSCRIPT_H
#define QEUSHULLYSCRIPT_H

#include <QObject>
#include <QList>
#include <QStringList>
#include "qeushullyoperations.h"

class QEushullyBIN;

struct QEushullyCMD
{
    quint32 addr;
    quint32 cmd;
    quint32 params_size;
};

class QEushullyScript : public QObject
{
    Q_OBJECT

    QStringList m_parse_result;
    quint32     m_addr;
    bool        m_debug;
    QString     m_debug_msg;
    QList<quint32> m_script;

    QString parse_param(quint32 type, quint32 value, bool isAddr = false);
    quint32 parse_cmd(quint32 addr, bool execute = false);
public:
    explicit QEushullyScript(QObject *parent = 0);
    
    void parse(QList<quint32> &raw);
    QString getParseResult();

    quint32 getScriptLineCount() { return this->m_script.count(); }
    QString getScriptLine(quint32 line) { return this->m_script.at(line); }

    // returned at a stop-line address
    quint32 run();
    quint32 step();
    quint32 step_into();
signals:
    
public slots:
    
};

#endif // QEUSHULLYSCRIPT_H
