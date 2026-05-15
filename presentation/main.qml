import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import "resources/styles"

ApplicationWindow {
    id: windowRoot

    property string selectedNodeId: ""
    property string selectedEdgeId: ""

    function selectNode(id) {
        windowRoot.selectedNodeId = id;
        windowRoot.selectedEdgeId = "";
    }

    function selectEdge(id) {
        windowRoot.selectedNodeId = "";
        windowRoot.selectedEdgeId = id;
    }

    title: "Pentandra"
    color: styles.background
    height: 800
    width: 1280
    visible: true

    Styles {
        id: styles
    }

    FontLoader {
        id: titleFont

        source: "resources/fonts/aldrich.ttf"
    }

    FontLoader {
        id: contentFont

        source: "resources/fonts/futuraBook.ttf"
    }

    FontLoader {
        id: resultsFont

        source: "resources/fonts/googleSansCode.ttf"
    }

    MouseArea {
        anchors.fill: fullContainer
        onClicked: {
            windowRoot.selectedNodeId = "";
            windowRoot.selectedEdgeId = "";
            forceActiveFocus();
        }
    }

    RowLayout {
        id: fullContainer

        anchors.rightMargin: styles.smallSpacing
        spacing: styles.bigSpacing
        anchors.fill: parent

        Rectangle {
            id: barContainer

            color: styles.bar
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: 40 + parent.width / 10

            ColumnLayout {
                spacing: styles.midSpacing
                Layout.fillHeight: true
                Layout.fillWidth: true

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: styles.smallSpacing
                }

                Repeater {
                    Button {
                        required property string content
                        required property string source
                        required property string objectName
                        required property string actionType

                        text: content
                        font.family: contentFont.font.family
                        font.pointSize: styles.button
                        font.bold: true
                        display: AbstractButton.TextUnderIcon
                        Layout.preferredHeight: barContainer.width - styles.smallSpacing
                        Layout.preferredWidth: barContainer.width - styles.bigSpacing
                        onClicked: {
                            actionTitle.text = content;
                            if (actionType === "adjacency") {
                                actionResults.text = graphModel.getAdjacencyMatrix();
                            } else if (actionType === "incidence") {
                                actionResults.text = graphModel.getIncidenceMatrix();
                            } else if (actionType === "mst") {
                                actionResults.text = "Calculando...";
                                mstDelayTimer.start();
                            }
                        }

                        icon {
                            height: barContainer.width - 4 * styles.smallSpacing
                            width: barContainer.width - 4 * styles.smallSpacing
                            source: source
                            color: styles.background
                        }

                        background: Rectangle {
                            color: parent.down ? Qt.darker(styles.bar, 2) : Qt.darker(styles.bar, 1.5)
                            radius: styles.smallSpacing
                        }

                    }

                    model: ListModel {
                        ListElement {
                            content: "Adyacencia"
                            source: "resources/icons/matrix-adjacency.svg"
                            objectName: "adjacencyButton"
                            actionType: "adjacency"
                        }

                        ListElement {
                            content: "Incidencia"
                            source: "resources/icons/matrix-incidence.svg"
                            objectName: "incidenceButton"
                            actionType: "incidence"
                        }

                        ListElement {
                            content: "Árbol"
                            source: "resources/icons/tree.svg"
                            objectName: "mstButton"
                            actionType: "mst"
                        }

                    }

                }

                Timer {
                    id: mstDelayTimer

                    interval: 100
                    repeat: false
                    onTriggered: {
                        actionResults.text = graphModel.getMST();
                    }
                }

            }

        }

        ColumnLayout {
            id: resultsContainer

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.horizontalStretchFactor: 1

            Text {
                id: actionTitle

                text: "Resultados"
                font.family: contentFont.font.family
                font.pointSize: styles.heading
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                padding: styles.bigSpacing
            }

            Text {
                id: actionResults

                text: "Seleccione una opción del panel izquierdo."
                font.family: resultsFont.font.family
                font.pointSize: styles.content
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

        }

        ColumnLayout {
            id: graphContainer

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: 800

            RowLayout {
                id: graphTitleContainer

                property bool graphIsEmpty: true
                property bool graphHasColors: false

                Layout.alignment: Qt.AlignHCenter
                spacing: styles.midSpacing

                Connections {
                    function onModelReset() {
                        graphTitleContainer.graphIsEmpty = graphModel.isGraphEmpty();
                        graphTitleContainer.graphHasColors = graphModel.hasColors();
                    }

                    function onDataChanged() {
                        graphTitleContainer.graphIsEmpty = graphModel.isGraphEmpty();
                        graphTitleContainer.graphHasColors = graphModel.hasColors();
                    }

                    target: graphModel
                }

                Text {
                    text: "Grafo"
                    font.family: contentFont.font.family
                    font.pointSize: styles.title
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Button {
                    id: cleanColorsButton

                    property color fillColor: (enabled) ? (down ? Qt.darker(styles.accept, 1.5) : styles.accept) : styles.selector

                    enabled: !parent.graphIsEmpty && parent.graphHasColors
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: styles.heading
                    Layout.preferredWidth: styles.heading
                    onClicked: {
                        graphModel.clearColors();
                        if (actionTitle.text === "Árbol")
                            actionResults.text = "Seleccione una opción del panel izquierdo.";

                    }

                    icon {
                        source: "resources/icons/clean.svg"
                        color: fillColor
                        height: styles.title
                        width: styles.title
                    }

                    background: Rectangle {
                        border.color: parent.fillColor
                        border.width: 4
                        radius: 4
                    }

                }

                Button {
                    id: clearGraphButton

                    property color fillColor: (enabled) ? (down ? Qt.darker(styles.danger, 1.5) : styles.danger) : styles.selector

                    enabled: !parent.graphIsEmpty
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: styles.heading
                    Layout.preferredWidth: styles.heading
                    onClicked: {
                        graphModel.clearGraph();
                        windowRoot.selectedNodeId = "";
                        windowRoot.selectedEdgeId = "";
                        graphElementInput.text = "";
                        actionResults.text = "Seleccione una opción del panel izquierdo.";
                    }

                    icon {
                        source: "resources/icons/trashcan.svg"
                        height: styles.title
                        width: styles.title
                        color: fillColor
                    }

                    background: Rectangle {
                        radius: 4
                        border.color: parent.fillColor
                        border.width: 4
                    }

                }

            }

            Rectangle {
                id: graphView

                color: styles.selector
                Layout.preferredHeight: this.width
                Layout.fillWidth: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        windowRoot.selectedNodeId = "";
                        windowRoot.selectedEdgeId = "";
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
                            property var treeColor: elementColor
                            property double weight: modelWeight
                            property double xPoint: modelXPoint
                            property double yPoint: modelYPoint
                            property double startXPoint: modelStartX
                            property double startYPoint: modelStartY
                            property double endXPoint: modelEndX
                            property double endYPoint: modelEndY

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
                            color: (treeColor !== undefined && treeColor !== "") ? treeColor : styles.element
                            border.color: windowRoot.selectedNodeId === idName ? Qt.darker(color, 1.25) : "transparent"
                            border.width: windowRoot.selectedNodeId === idName ? 2 : 0
                            onXChanged: {
                                if (mouseArea.drag.active)
                                    graphModel.updateNodePosition(parseInt(idName), x + radius, y + radius);

                            }
                            onYChanged: {
                                if (mouseArea.drag.active)
                                    graphModel.updateNodePosition(parseInt(idName), x + radius, y + radius);

                            }

                            MouseArea {
                                id: mouseArea

                                anchors.fill: parent
                                onClicked: (mouse) => {
                                    windowRoot.selectedEdgeId = "";
                                    if (windowRoot.selectedNodeId !== "" && windowRoot.selectedNodeId !== idName) {
                                        graphModel.addEdge(parseInt(windowRoot.selectedNodeId), parseInt(idName));
                                        windowRoot.selectedNodeId = "";
                                        graphElementInput.text = "";
                                    } else {
                                        windowRoot.selectedNodeId = idName;
                                        graphElementInput.text = name !== undefined ? name : "";
                                        graphElementInput.forceActiveFocus();
                                    }
                                }

                                drag {
                                    target: parent
                                    minimumX: graphView.x
                                    minimumY: graphView.y - 92
                                    maximumX: graphView.width - 24
                                    maximumY: graphView.height - 24
                                }

                            }

                            Text {
                                anchors.top: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: name !== undefined ? name : ""
                                font.family: resultsFont.font.family
                                font.bold: windowRoot.selectedNodeId === idName
                                visible: text !== ""
                            }

                        }

                    }

                    Component {
                        id: edgeComponent

                        Item {
                            id: edgeContainer

                            readonly property real dx: endXPoint - startXPoint
                            readonly property real dy: endYPoint - startYPoint
                            readonly property real distance: Math.sqrt(dx * dx + dy * dy)
                            readonly property real angle: Math.atan2(dy, dx) * 180 / Math.PI

                            objectName: idName

                            Shape {
                                antialiasing: true
                                smooth: true

                                ShapePath {
                                    property color lineColor: (treeColor !== undefined && treeColor !== "") ? treeColor : styles.element

                                    strokeColor: (windowRoot.selectedEdgeId === idName ? Qt.darker(lineColor, 1.5) : Qt.darker(lineColor, 1.25))
                                    strokeWidth: (treeColor !== undefined && treeColor !== "") ? 3 : 2
                                    startX: startXPoint
                                    startY: startYPoint

                                    PathLine {
                                        x: endXPoint
                                        y: endYPoint
                                    }

                                }

                                Rectangle {
                                    id: hitbox

                                    x: startXPoint
                                    y: startYPoint - height / 2
                                    color: "transparent"
                                    width: edgeContainer.distance
                                    height: 12
                                    rotation: edgeContainer.angle
                                    transformOrigin: Item.Left

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            windowRoot.selectedNodeId = "";
                                            windowRoot.selectedEdgeId = idName;
                                            graphElementInput.text = weight !== 0 ? weight : "";
                                            graphElementInput.forceActiveFocus();
                                        }
                                    }

                                }

                            }

                            Text {
                                anchors.verticalCenterOffset: -10
                                text: weight !== 0 ? weight : ""
                                font.family: resultsFont.font.family
                                font.bold: windowRoot.selectedEdgeId === idName
                                visible: weight !== undefined
                                x: (startXPoint + endXPoint) / 2
                                y: (startYPoint + endYPoint) / 2
                                z: 2
                            }

                        }

                    }

                }

            }

            RowLayout {
                Layout.preferredHeight: 120

                Text {
                    id: graphElement

                    text: "Dato:"
                    font.family: contentFont.font.family
                    font.pointSize: styles.title
                    font.bold: true
                    elide: Text.ElideLeft
                    padding: 4
                    width: 120
                }

                DoubleValidator {
                    id: edgeWeightValidator

                    bottom: 0
                    top: 1e+06
                    decimals: 2
                    notation: DoubleValidator.StandardNotation
                    locale: "C"
                }

                TextField {
                    id: graphElementInput

                    enabled: windowRoot.selectedNodeId || windowRoot.selectedEdgeId
                    font.pointSize: styles.label
                    font.bold: true
                    color: "#000000"
                    onAccepted: acceptElementButton.clicked()
                    placeholderText: enabled ? "Ingrese valor" : "Seleccione elemento"
                    onActiveFocusChanged: {
                        !(windowRoot.selectedNodeId || windowRoot.selectedEdgeId) ? text = "" : text = text;
                    }
                    validator: windowRoot.selectedEdgeId ? edgeWeightValidator : null

                    background: Rectangle {
                        color: parent.focus ? Qt.darker(styles.selector, 1.1) : Qt.darker(styles.selector, 1.2)
                        radius: 4
                        implicitHeight: styles.heading
                        implicitWidth: 480 - graphElement.width - acceptElementButton.width - deleteElementButton.width
                    }

                }

                Button {
                    id: acceptElementButton

                    property color fillColor: (enabled) ? (down ? Qt.darker(styles.accept, 1.5) : styles.accept) : styles.selector

                    enabled: (windowRoot.selectedNodeId || windowRoot.selectedEdgeId) && graphElementInput.text !== "" && (windowRoot.selectedEdgeId === "" || (!isNaN(parseFloat(graphElementInput.text)) && isFinite(graphElementInput.text) && parseFloat(graphElementInput.text) >= 0))
                    onClicked: {
                        if (windowRoot.selectedNodeId) {
                            graphModel.setNodeName(parseInt(windowRoot.selectedNodeId), graphElementInput.text);
                        } else if (windowRoot.selectedEdgeId) {
                            let parts = windowRoot.selectedEdgeId.split("-");
                            graphModel.setEdgeWeight(parseInt(parts[0]), parseInt(parts[1]), parseFloat(graphElementInput.text));
                        }
                        windowRoot.selectedNodeId = "";
                        windowRoot.selectedEdgeId = "";
                        graphElementInput.text = "";
                        fullContainer.forceActiveFocus();
                    }

                    icon {
                        source: "resources/icons/check.svg"
                        height: styles.midSpacing
                        width: styles.midSpacing
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

                    property color fillColor: (enabled) ? (down ? Qt.darker(styles.danger, 1.5) : styles.danger) : styles.selector

                    enabled: windowRoot.selectedNodeId || windowRoot.selectedEdgeId
                    onClicked: {
                        if (windowRoot.selectedNodeId) {
                            graphModel.removeNode(parseInt(windowRoot.selectedNodeId));
                        } else if (windowRoot.selectedEdgeId) {
                            let parts = windowRoot.selectedEdgeId.split("-");
                            graphModel.removeEdge(parseInt(parts[0]), parseInt(parts[1]));
                        }
                        windowRoot.selectedNodeId = "";
                        windowRoot.selectedEdgeId = "";
                        graphElementInput.text = "";
                        fullContainer.forceActiveFocus();
                    }

                    icon {
                        source: "resources/icons/trashcan.svg"
                        height: styles.midSpacing
                        width: styles.midSpacing
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

        color: styles.header
        height: headerText.height + styles.midSpacing
        width: parent.width

        Text {
            id: headerText

            anchors.centerIn: headerContainer
            text: "Pentandra"
            color: styles.headerText

            font {
                family: titleFont.font.family
                weight: 900
                pointSize: styles.heading
            }

        }

    }

}
