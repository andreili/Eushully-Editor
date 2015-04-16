#ifndef EUSHULLYBINVIEWER_H
#define EUSHULLYBINVIEWER_H

#include <QDialog>
#include <QUrl>
#include "qeushullybin.h"

namespace Ui {
class EushullyBinViewer;
}

class EushullyBinViewer : public QDialog
{
    Q_OBJECT
    
public:
    explicit EushullyBinViewer(QEushullyFile &file, QWidget *parent = 0);
    ~EushullyBinViewer();

    QEushullyBIN bin;
    
private slots:
    void on_actionDebugRun_triggered();

    void on_actionDebugStep_triggered();

    void on_actionDebugStepInto_triggered();

private:
    Ui::EushullyBinViewer *ui;
protected:
    bool eventFilter(QObject *obj, QEvent *event);
};

#endif // EUSHULLYBINVIEWER_H
