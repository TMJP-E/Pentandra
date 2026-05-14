import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

ApplicationWindow {
    id: windowRoot

    property string selectedNodeId: ""

    color: "#FFFFFF"
    title: "Pentandra"
    height: 800
    width: 1280
    visible: true

    FontLoader {
        id: futuraBook

        source: "resources/fonts/futura/futuraBook.ttf"
    }

    MouseArea {
        anchors.fill: contentContainer
        onClicked: {
            forceActiveFocus();
            windowRoot.selectedNodeId = "";
        }
    }

    RowLayout {
        id: contentContainer

        readonly property int spacer: 12

        spacing: contentContainer.spacer
        height: windowRoot.height
        width: windowRoot.width

        Rectangle {
            id: optionsContainer

            readonly property int widthAmount: 160

            color: "#8B5538"
            Layout.fillHeight: true
            width: widthAmount

            ColumnLayout {
                spacing: contentContainer.spacer

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: contentContainer.spacer
                }

                Repeater {
                    Button {
                        required property string content
                        required property string source
                        required property string objectName

                        display: AbstractButton.TextUnderIcon
                        Layout.preferredHeight: optionsContainer.width - 1 * contentContainer.spacer
                        Layout.preferredWidth: optionsContainer.width - 2 * contentContainer.spacer
                        bottomPadding: 13
                        text: content
                        font.family: futuraBook.font.family
                        font.pointSize: 12
                        font.bold: true

                        icon {
                            source: source
                            height: optionsContainer.width - 4 * contentContainer.spacer
                            width: optionsContainer.width - 4 * contentContainer.spacer
                            color: "#FFFFFF"
                        }

                        background: Rectangle {
                            color: parent.down ? Qt.darker(optionsContainer.color, 2) : Qt.darker(optionsContainer.color, 1.5)
                            radius: contentContainer.spacer
                        }

                    }

                    model: ListModel {
                        ListElement {
                            content: "Adjacencia"
                            source: "resources/icons/matrix-adjacency.svg"
                            objectName: "adjacencyButton"
                        }

                        ListElement {
                            content: "Incidencia"
                            source: "resources/icons/matrix-incidence.svg"
                            objectName: "incidenceButton"
                        }

                        ListElement {
                            content: "Arbol Minimo"
                            source: "resources/icons/tree.svg"
                            objectName: "mstButton"
                        }

                    }

                }

            }

        }

        ColumnLayout {
            id: resultsContainer

            spacing: 12
            Layout.margins: 12
            Layout.fillHeight: true
            Layout.preferredWidth: 540

            Text {
                id: actionTitle

                property string content: "Title"

                font.family: futuraBook.font.family
                text: content
                font.pointSize: 32
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                padding: 48
            }

            Text {
                wrapMode: Text.WordWrap
                font.pointSize: 24
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
            }

        }

        ColumnLayout {
            id: graphContainer

            Layout.rightMargin: 36
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            Text {
                text: "Grafo"
                font.pointSize: 24
                font.bold: true
                font.family: futuraBook.font.family
                padding: 24
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.preferredHeight: this.width
                Layout.fillWidth: true
                color: "#D9D9D9"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        windowRoot.selectedNodeId = "";
                        parent.forceActiveFocus();
                    }
                    onDoubleClicked: (mouse) => {
                        graphModel.addNode(graphModel.rowCount() + 1, mouse.x, mouse.y);
                    }
                }

                Item {
                    Repeater {
                        id: graphRepeater

                        model: graphModel

                        delegate: Loader {
                            property string type: elementType
                            property string idName: elementId
                            property string name: elementName
                            property double xPoint: modelXPoint
                            property double yPoint: modelYPoint
                            property double weight: modelWeight
                            property double startXPoint: modelStartXPoint
                            property double startYPoint: modelStartYPoint
                            property double endXPoint: modelEndXPoint
                            property double endYPoint: modelEndYPoint

                            sourceComponent: elementType === "node" ? nodeComponent : edgeComponent
                            z: type === "node" ? 1 : 0
                        }

                    }

                    Component {
                        id: nodeComponent

                        Rectangle {
                            objectName: idName
                            radius: width / 2
                            x: xPoint - radius
                            y: yPoint - radius
                            width: 24
                            height: 24
                            color: "#619FF0"
                            border.width: windowRoot.selectedNodeId === idName ? 2 : 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    parent.forceActiveFocus();
                                    windowRoot.selectedNodeId = idName;
                                    graphElementInput.text = name !== undefined ? name : "";
                                    graphElementInput.forceActiveFocus();
                                }
                            }

                            Text {
                                anchors.top: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: name !== undefined ? name : ""
                                visible: text !== ""
                            }

                        }

                    }

                    Component {
                        id: edgeComponent

                        Item {
                            id: idName

                            Shape {
                                ShapePath {
                                    strokeColor: "#000000"
                                    strokeWidth: 2
                                    startX: startXPoint
                                    startY: startYPoint

                                    PathLine {
                                        x: endXPoint
                                        y: endYPoint
                                    }

                                }

                            }

                            Text {
                                x: (startXPoint + endXPoint) / 2
                                y: (startYPoint + endYPoint) / 2
                                text: weight !== 0 ? weight : ""
                                visible: weight !== undefined
                                anchors.verticalCenterOffset: -10
                            }

                        }

                    }

                }

            }

            RowLayout {
                Layout.preferredHeight: 120

                Text {
                    id: graphElement

                    font.pointSize: 20
                    font.bold: true
                    width: 120
                    font.family: futuraBook.font.family
                    text: "Nombre:"
                    elide: Text.ElideLeft
                    onTextChanged: this.text = this.text + ":"
                    padding: 4
                }

                TextField {
                    id: graphElementInput

                    enabled: windowRoot.selectedNodeId
                    font.pointSize: 18
                    font.bold: true
                    color: "#000000"
                    onAccepted: acceptElementButton.clicked()
                    placeholderText: enabled ? "Ingrese nombre" : "Seleccione un nodo"
                    onActiveFocusChanged: {
                        !windowRoot.selectedNodeId ? text = "" : text = text;
                    }

                    background: Rectangle {
                        implicitHeight: 36
                        implicitWidth: 480 - graphElement.width - acceptElementButton.width - deleteElementButton.width
                        color: parent.focus ? Qt.darker("#D9D9D9", 1.1) : Qt.darker("#D9D9D9", 1.2)
                        radius: 4
                    }

                }

                Button {
                    id: acceptElementButton

                    property color fillColor: (windowRoot.selectedNodeId && graphElementInput.text !== "") ? (down ? Qt.darker("#4ED433", 1.5) : "#4ED433") : "#D9D9D9"

                    enabled: windowRoot.selectedNodeId && graphElementInput.text !== ""
                    onClicked: {
                        if (windowRoot.selectedNodeId) {
                            graphModel.setNodeName(parseInt(windowRoot.selectedNodeId), graphElementInput.text);
                            windowRoot.selectedNodeId = "";
                            graphElementInput.text = "";
                            contentContainer.forceActiveFocus();
                        }
                    }

                    icon {
                        source: "resources/icons/check.svg"
                        height: 24
                        width: 24
                        color: fillColor
                    }

                    background: Rectangle {
                        radius: 4
                        border.color: parent.fillColor
                        border.width: 4
                    }

                }

                Button {
                    id: deleteElementButton

                    property color fillColor: (windowRoot.selectedNodeId) ? (down ? Qt.darker("#D72020", 1.5) : "#D72020") : "#D9D9D9"

                    enabled: windowRoot.selectedNodeId
                    onClicked: {
                        if (windowRoot.selectedNodeId) {
                            graphModel.removeNode(parseInt(windowRoot.selectedNodeId));
                            windowRoot.selectedNodeId = "";
                            graphElementInput.text = "";
                            contentContainer.forceActiveFocus();
                        }
                    }

                    icon {
                        source: "resources/icons/trashcan.svg"
                        height: 24
                        width: 24
                        color: fillColor
                    }

                    background: Rectangle {
                        radius: 4
                        border.color: parent.fillColor
                        border.width: 4
                    }

                }

            }

        }

    }

    header: Rectangle {
        id: headerContainer

        color: "#57B95A"
        height: 80
        Layout.fillWidth: true

        Text {
            id: headerText

            anchors.centerIn: headerContainer
            font.family: futuraBook.font.family
            color: "#FFFFFF"
            text: "Pentandra"
            font.bold: true
            font.pointSize: 24
        }

    }

}
