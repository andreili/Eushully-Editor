#include "eushullybinviewer.h"
#include "ui_eushullybinviewer.h"
#include <QKeyEvent>
#include <QUrl>

EushullyBinViewer::EushullyBinViewer(QEushullyFile &file, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::EushullyBinViewer)
{
    ui->setupUi(this);
    this->bin.load(file);
    this->ui->textBrowser->setHtml(this->bin.getScript()->getParseResult());
    this->setWindowTitle(this->bin.getName());
    this->ui->textBrowser->installEventFilter(this);
    this->ui->lAddr->setText("0x0");
}

EushullyBinViewer::~EushullyBinViewer()
{
    this->bin.close();
    delete ui;
}

bool EushullyBinViewer::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress)
    {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        switch (keyEvent->key())
        {
        case Qt::Key_F5:
            this->ui->actionDebugRun->trigger();
            break;
        case Qt::Key_F10:
            this->ui->actionDebugStep->trigger();
            break;
        case Qt::Key_F11:
            this->ui->actionDebugStepInto->trigger();
            break;
        }

        return true;
    }
    else
    {
        return QObject::eventFilter(obj, event);
    }
}

void EushullyBinViewer::on_actionDebugRun_triggered()
{
    //
}

void EushullyBinViewer::on_actionDebugStep_triggered()
{
    quint32 addr = this->bin.getScript()->step();
    this->ui->lAddr->setText(QString::number(addr, 16));
    QUrl url;
    url.setUrl("#" + QString::number(addr, 16));
    this->ui->textBrowser->setSource(url);

    QTextEdit::ExtraSelection hl;
    hl.cursor = this->ui->textBrowser->cursorForPosition(QPoint(0, 0));
    hl.cursor.movePosition(QTextCursor::StartOfLine);
    hl.cursor.movePosition(QTextCursor::EndOfLine, QTextCursor::KeepAnchor);
    hl.format.setBackground(Qt::red);

    QList<QTextEdit::ExtraSelection> list;
    list << hl;
    this->ui->textBrowser->setExtraSelections(list);
}

void EushullyBinViewer::on_actionDebugStepInto_triggered()
{
    quint32 addr = this->bin.getScript()->step_into();
    this->ui->lAddr->setText(QString::number(addr, 16));
    QUrl url;
    url.setFragment("#" + QString::number(addr, 16));
    this->ui->textBrowser->setSource(url);
}
