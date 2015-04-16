#ifndef EUSHULLYBINEDITOR_H
#define EUSHULLYBINEDITOR_H

#include <QDialog>
#include "qeushullybin.h"

namespace Ui {
class EushullyBinEditor;
}

class EushullyBinEditor : public QDialog
{
    Q_OBJECT

public:
    explicit EushullyBinEditor(QEushullyFile &file, QWidget *parent = 0);
    ~EushullyBinEditor();

    QEushullyBIN bin;

private:
    Ui::EushullyBinEditor *ui;
};

#endif // EUSHULLYBINEDITOR_H
