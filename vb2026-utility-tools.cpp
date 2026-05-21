#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

int main(int argc, char* argv[])
{
    // QMLを使う場合は QApplication ではなく QGuiApplication を使います
    QGuiApplication app(argc, argv);

    // QMLエンジンを初期化
    QQmlApplicationEngine engine;

    // 作成した main.qml ファイルを読み込む
    const QUrl url(QStringLiteral("qrc:/UI/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

    // もしリソース化していない場合は直接ファイルを指定（開発中はこれが楽です）
    engine.load(QUrl::fromLocalFile("ui/main.qml"));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}