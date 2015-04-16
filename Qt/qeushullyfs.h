#ifndef QEUSHULLYFS_H
#define QEUSHULLYFS_H

#include <QObject>
#include <QString>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include "qeushullyalf.h"


    class QEushullyFS : public QObject
    {
        Q_OBJECT
    private:
        QString                 m_root;
        QList<QEushullyALF*>    m_archives;
    public:
        explicit QEushullyFS(QObject *parent = 0);

        bool load(const QString path);
        void unload();
        bool get_loaded();
        QString get_root();

        QEushullyALF *get_archive_by_file(const QString filename);
        QEushullyALF *get_main_archive();

        void extract_texts(QString dest_dir);
    signals:

    public slots:
        void tree_fill(QTreeWidgetItem *parent_item, QString filter = ".*\\..*");

    };


#endif // QEUSHULLYFS_H
