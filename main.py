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

    graphModel.addNode(1, 100.0, 100.0)
    graphModel.setNodeName(1, "Node A")

    graphModel.addNode(2, 400.0, 400.0)
    graphModel.setNodeName(2, "Node B")

    graphModel.addNode(3, 200.0, 300.0)

    graphModel.addEdge(1, 2)
    graphModel.setEdgeWeight(1, 2, 42.5)

    graphModel.addEdge(1, 3)

    engine.rootContext().setContextProperty("graphModel", graphModel)

    qml_file = Path(__file__).parent / "presentation" / "main.qml"
    engine.load(QUrl.fromLocalFile(qml_file))
    if not engine.rootObjects():
        sys.exit(-1)

    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


main()
