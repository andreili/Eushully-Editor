#ifndef QEUSHULLYFILE_H
#define QEUSHULLYFILE_H

#include <QObject>
#include "qeushullyalf.h"

class QEushullyFile : public QObject
{
    Q_OBJECT

private:
    QFile   m_f;
    AlfFile m_file;
public:
    explicit QEushullyFile(QObject *parent = 0);

    bool open(const QString name);
    void close();

    QString getName();

    quint32 size();
    QString size_human();
    static QString size_human(QString filename);

    int read(char *buf, int size);
    quint32 seek(quint32 seek);
    
signals:
    
public slots:
    
};

#endif // QEUSHULLYFILE_H
