#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
//#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Lets get the color names
    //QStringList colors = QColor::colorNames();

    QQuickView view;
    //view.rootContext()->setContextProperty("colors", QVariant::fromValue(colors));
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}
