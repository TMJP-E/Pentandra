import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtCore import QUrl
from PySide6.QtQml import QQmlApplicationEngine
from presentation.graph.graphView import GraphModel


def main():

    presentation_path = Path(__file__).parent / "presentation"
    app_icon = presentation_path / "resources" / "icons" / "logo.jpg"
    main_qml = presentation_path / "main.qml"

    # Crea la aplicacion
    app = QGuiApplication()
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon(str(app_icon)))

    # Agregamos el modelo a la aplicacion.
    graphModel = GraphModel()
    engine.rootContext().setContextProperty("graphModel", graphModel)
    engine.load(QUrl.fromLocalFile(main_qml))
    if not engine.rootObjects():
        sys.exit(-1)

    # Ejecuta la aplicacion
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
