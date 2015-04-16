#include "qeushullyfs.h"
#include <QFile>
#include <QDir>
#include <QRegExp>
#include "qeushullyfile.h"
#include "qeushullybin.h"

QEushullyFS::QEushullyFS(QObject *parent) :
    QObject(parent)
{
    this->m_root = "";
    this->m_archives.clear();
}

bool QEushullyFS::load(const QString path)
{
    this->m_root = path;
    this->m_archives.clear();

    QDir dir = QDir(this->m_root);
    QStringList files = dir.entryList(QDir::Files);
    for (int i=0 ; i<files.count() ; i++)
    {
        if (QEushullyALF::is_format(this->m_root+files.at(i)))
        {
            QEushullyALF *alf = new QEushullyALF();
            if (alf->load_from_file(this->m_root+files.at(i)))
            {
                this->m_archives.append(alf);
            }
        }
    }
    return true;
}

void QEushullyFS::unload()
{
}

bool QEushullyFS::get_loaded()
{
    return (this->m_archives.count() != 0);
}

QString QEushullyFS::get_root()
{
    return this->m_root;
}

QEushullyALF *QEushullyFS::get_archive_by_file(const QString filename)
{
    for (int i=0 ; i<this->m_archives.count() ; i++)
        if (this->m_archives.at(i)->is_exist(filename))
            return this->m_archives.at(i);
    return NULL;
}

QEushullyALF *QEushullyFS::get_main_archive()
{
    for (int i=0 ; i<this->m_archives.count() ; i++)
        if (this->m_archives.at(i)->get_type() == ALF_DATA)
            return this->m_archives.at(i);
    return NULL;
}

void QEushullyFS::extract_texts(QString dest_dir)
{
    for (int i=0 ; i<this->m_archives.count() ; i++)
    {
        QEushullyALF *alf = this->m_archives.at(i);
        for (int j=0 ; j<alf->get_files_count() ; j++)
        {
            if (QRegExp("*.bin", Qt::CaseInsensitive).exactMatch(alf->get_file_name(j)))
            {
                QEushullyFile script;
                script.open(alf->get_file_name(j));
                QEushullyBIN bin;
                if (bin.load(script))
                {
                    QFile file(dest_dir + alf->get_file_name(j) + ".raw");
                    QStringList list = bin.getStringsRAW();
                    for (int k=0 ; k<list.count() ; k++)
                    {
                        file.write(list.at(k).toUtf8());
                        file.write("\x13");
                    }
                    //file.write(.)
                    file.close();
                }
                bin.close();
                script.close();
            }
        }
    }
}

void QEushullyFS::tree_fill(QTreeWidgetItem *parent_item, QString filter)
{
    for (int i=0 ; i<this->m_archives.count() ; i++)
    {
        QEushullyALF *alf = this->m_archives.at(i);
        for (int j=0 ; j<alf->get_files_count() ; j++)
        {
            if (QRegExp(filter, Qt::CaseInsensitive).exactMatch(alf->get_file_name(j)))
            {
                QTreeWidgetItem *item = new QTreeWidgetItem();
                QString fn = alf->get_file_name(j);
                item->setText(0, fn);
                //item->setText(1, QEushullyFile::size_human(fn));
                item->setData(0, Qt::UserRole, 1);
                parent_item->addChild(item);
            }
        }
    }
}
