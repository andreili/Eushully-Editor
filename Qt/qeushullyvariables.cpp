#include "qeushullyvariables.h"

QEushullyVariables::QEushullyVariables(QObject *parent) :
    QObject(parent)
{
}

void QEushullyVariables::set_value(quint32 name, quint32 type, quint32 value)
{
    EushullyVariable var;
    var.name = name;
    var.type = (EEushullyVariableType)type;
    var.value = value;
    if (this->m_variables.contains(name))
        emit variable_updated(var);
    else
        emit variable_added(var);
    this->m_variables.insert(name, var);
}

quint32 QEushullyVariables::get_value(quint32 name)
{
    if (this->m_variables.contains(name))
        return this->m_variables.value(name).value.toUInt();
    else
        return 0;
}
