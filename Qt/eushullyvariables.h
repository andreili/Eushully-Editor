#ifndef EUSHULLYVARIABLES_H
#define EUSHULLYVARIABLES_H

#include <QDockWidget>
#include "qeushullyvariables.h"

namespace Ui {
class EushullyVariables;
}

class EushullyVariables : public QDockWidget
{
    Q_OBJECT
    
public:
    explicit EushullyVariables(QWidget *parent = 0);
    ~EushullyVariables();
    
private:
    Ui::EushullyVariables *ui;

public slots:
    void variableAdded(EushullyVariable var);
    void variableUpdated(EushullyVariable var);
};

#endif // EUSHULLYVARIABLES_H
