#include "qeushullygame.h"
#include "qeushullyfs.h"
#include "qeushullyfile.h"
#include "qeushullybin.h"

QEushullyGame::QEushullyGame(QObject *parent) :
    QObject(parent)
{
    this->m_loaded = false;
    this->m_path = "";
    this->m_debug = true;
}

bool QEushullyGame::load(const QString path_to_game)
{
    this->m_path = path_to_game;
    this->m_loaded = this->m_fs.load(path_to_game);
    return this->m_loaded;
}

void QEushullyGame::unload()
{
    this->m_fs.unload();
}

QEushullyFS *QEushullyGame::get_FS()
{
    return &this->m_fs;
}

QEushullyVariables *QEushullyGame::getVars()
{
    return &this->m_variables;
}

bool QEushullyGame::get_debug()
{
    return this->m_debug;
}

void QEushullyGame::stack_push(quint32 value)
{
    this->m_stack.push(value);
}

quint32 QEushullyGame::stack_pop()
{
    return this->m_stack.pop();
}

void QEushullyGame::exec_script(QString name)
{
    QEushullyFile file;
    file.open(name);
    QEushullyBIN bin;
    if (bin.load(file))
    {
        //
    }
    bin.close();
    file.close();
}

void QEushullyGame::extract_texts(QString dest_dir)
{
    this->m_fs.extract_texts(dest_dir);
}
