import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtCore import QUrl
from PySide6.QtQml import QQmlApplicationEngine
from presentation.graph.graphView import GraphView


def main():
    app = QGuiApplication()
    engine = QQmlApplicationEngine()

    graphModel = GraphView()

    engine.rootContext().setContextProperty("graphModel", graphModel)

    qml_file = Path(__file__).parent / "presentation" / "main.qml"
    engine.load(QUrl.fromLocalFile(qml_file))
    if not engine.rootObjects():
        sys.exit(-1)

    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


main()
