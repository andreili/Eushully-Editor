#ifndef BREACKPOINTS_H
#define BREACKPOINTS_H

#include <QDockWidget>
#include <QTableWidgetItem>

namespace Ui {
class Breackpoints;
}

class Breackpoints : public QDockWidget
{
    Q_OBJECT
    
public:
    explicit Breackpoints(QWidget *parent = 0);
    ~Breackpoints();
    
private slots:
    void on_tableWidget_itemChanged(QTableWidgetItem *item);

private:
    Ui::Breackpoints *ui;
};

#endif // BREACKPOINTS_H
