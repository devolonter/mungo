#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define MUNGOSERVER_VERSION "0.1.1"

#include <QMainWindow>
#include <QFileInfo>
#include <QDesktopServices>
#include <QUrl>
#include <QHash>
#include <QSystemTrayIcon>
#include <QMenu>

#include "ui_mainwindow.h"
#include "httpserver.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void createHttpServer(QString filename);

public slots:
    void receiveMessage(QString filename);
    void onShowWindow(QSystemTrayIcon::ActivationReason reason);

protected:
    void changeEvent(QEvent *event);

private:
    Ui::MainWindow *ui;

    quint16 port;
    QHash<QString, HttpServer*> httpServers;
    QSystemTrayIcon *tray;
};

#endif // MAINWINDOW_H
