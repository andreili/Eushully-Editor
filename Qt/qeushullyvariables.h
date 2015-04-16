#ifndef QEUSHULLYVARIABLES_H
#define QEUSHULLYVARIABLES_H

#include <QObject>
#include <QVariant>
#include <QMap>

#define SCRIPT_FIELD_VALUE      0x00000000
#define SCRIPT_FIELD_TEXT       0x00000002
#define SCRIPT_FIELD_VAR_NUM    0x00000003
#define SCRIPT_FIELD_VAR_TEXT   0x00000005
#define SCRIPT_FIELD_UNK        0x00000009
//#define SCRIPT_FIELD_   0x0000000

enum EEushullyVariableType
{
    VAR_VALUE = SCRIPT_FIELD_VALUE,
    VAR_TEXT = SCRIPT_FIELD_TEXT,
    VAR_NUM = SCRIPT_FIELD_VAR_NUM,
    VAR_NUM_TEXT = SCRIPT_FIELD_VAR_TEXT,
    VAR_UNK = SCRIPT_FIELD_UNK
};

struct EushullyVariableRAW
{
    quint32     type;
    quint32     name;
};

struct EushullyVariable
{
    quint32                 name;
    EEushullyVariableType   type;
    QVariant                value;
};

class QEushullyVariables : public QObject
{
    Q_OBJECT
private:
    QMap<quint32, EushullyVariable> m_variables;
public:
    explicit QEushullyVariables(QObject *parent = 0);

    void set_value(quint32 name, quint32 type, quint32 value);
    quint32 get_value(quint32 name);
    
signals:

    void variable_added(EushullyVariable var);
    void variable_updated(EushullyVariable var);
    
public slots:
    
};

#endif // QEUSHULLYVARIABLES_H
