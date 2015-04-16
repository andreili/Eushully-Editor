#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTreeWidgetItem>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    
private slots:
    void on_treeWidget_currentItemChanged(QTreeWidgetItem *current, QTreeWidgetItem *previous);

    void on_treeWidget_expanded(const QModelIndex &index);

    void on_treeWidget_itemDoubleClicked(QTreeWidgetItem *item, int column);

    void on_le_filter_textChanged(const QString &arg1);

    void on_export_texts();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
