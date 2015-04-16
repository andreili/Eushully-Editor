#ifndef QEUSHULLYGAME_H
#define QEUSHULLYGAME_H

#include <QString>
#include <QStack>
#include "qeushullyfs.h"
#include "qeushullyvariables.h"


    class QEushullyGame : public QObject
    {
        Q_OBJECT
    private:
        bool    m_loaded;
        QString m_path;
        bool    m_debug;
        QEushullyFS         m_fs;
        QEushullyVariables  m_variables;
        QStack<quint32>     m_stack;
    public:
        explicit QEushullyGame(QObject *parent = 0);

        bool load(const QString path_to_game);
        void unload();

        QEushullyFS *get_FS();
        QEushullyVariables *getVars();
        bool get_debug();

        void stack_push(quint32 value);
        quint32 stack_pop();

        void exec_script(QString name);
        void extract_texts(QString dest_dir);
    signals:

    public slots:
    };


#endif // QEUSHULLYGAME_H
