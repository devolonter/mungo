#include "mainwindow.h"

QString appTitle = "MungoServer - Micro HTTP Server For Mungo";

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ui->console->appendPlainText("MungoServer v" MUNGOSERVER_VERSION);

    QIcon appIcon(":/mserver.ico");
    setWindowTitle(appTitle);
    setWindowIcon(appIcon);

    tray = new QSystemTrayIcon(this);
    tray->setIcon(appIcon);
    tray->setToolTip(appTitle);
    tray->show();
    QMenu *menu = new QMenu(this);
    QAction *restore = new QAction(tr("Show"), this);
    connect(restore,SIGNAL(triggered()),this,SLOT(showNormal()));
    menu->addAction(restore);
    QAction *a = new QAction("", this);
    a->setSeparator(true);
    menu->addAction(a);
    QAction *quit = new QAction(tr("Quit"), this);
    connect(quit,SIGNAL(triggered()),this,SLOT(close()));
    menu->addAction(quit);
    tray->setContextMenu(menu);
    connect(tray,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),this,SLOT(onShowWindow(QSystemTrayIcon::ActivationReason)));
    tray->showMessage(appTitle, "Successfully started!");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::onShowWindow(QSystemTrayIcon::ActivationReason reason) {
    if(reason == QSystemTrayIcon::DoubleClick) {
        showNormal();
    }
}

void MainWindow::changeEvent(QEvent *event) {
    if(windowState() & Qt::WindowMinimized) {
        hide();
    }
}

void MainWindow::createHttpServer(QString filename)
{
    QFileInfo f(filename);

    if (!f.exists())
        return;

    HttpServer *httpServer;

    if (!httpServers.contains(f.absolutePath()))
    {
        port = httpServers.empty() ? 8080 : port + 10;
        httpServer = new HttpServer(f.absolutePath(), port, this);

        while(!httpServer->listen(QHostAddress::LocalHost, port) && port < 9080) {
            port+=10;
            httpServer->port = port;
        }

        if (httpServer->isListening())
        {
            ui->console->appendPlainText("HTTP server active and listening on port " + QString::number(port));
            httpServers.insert(f.absolutePath(), httpServer);
        }
        else
        {
            ui->console->appendPlainText("HttpServer server failed to bind socket to port " + QString::number(port));
        }

    }
    else
    {
        httpServer = httpServers.value(f.absolutePath());
        ui->console->appendPlainText("HTTP server active and listening on port " + QString::number(httpServer->port));
    }

    QDesktopServices::openUrl(QUrl(QString("http://localhost:%1/%2").arg(QString::number(httpServer->port), f.fileName())));
}

void MainWindow::receiveMessage(QString filename)
{
    if (filename.length())
        this->createHttpServer(filename);
}
