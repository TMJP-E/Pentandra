import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: windowRoot

    color: "#FFFFFF"
    title: "Pentandra"
    height: 800
    width: 1280
    visible: true

    MouseArea {
        anchors.fill: contentContainer
        onClicked: forceActiveFocus()
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
                        font.pointSize: 12
                        font.bold: true
                        objectName: objectName

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
                padding: 24
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                color: "#D9D9D9"
                Layout.preferredHeight: this.width
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.preferredHeight: 120

                Text {
                    id: graphElement

                    font.pointSize: 20
                    font.bold: true
                    width: 120
                    text: "Nombre:"
                    elide: Text.ElideLeft
                    onTextChanged: this.text = this.text + ":"
                    padding: 4
                }

                TextField {
                    id: graphElementInput

                    font.pointSize: 18
                    font.bold: true
                    color: "#000000"

                    background: Rectangle {
                        implicitHeight: 36
                        implicitWidth: 480 - graphElement.width - acceptElementButton.width - deleteElementButton.width
                        color: parent.focus ? Qt.darker("#D9D9D9", 1.1) : Qt.darker("#D9D9D9", 1.2)
                        radius: 4
                    }

                }

                Button {
                    id: acceptElementButton

                    property color fillColor: down ? Qt.darker("#4ED433", 1.5) : "#4ED433"

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

                    property color fillColor: down ? Qt.darker("#D72020", 1.5) : "#D72020"

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
            color: "#FFFFFF"
            text: "Pentandra"
            font.bold: true
            font.pointSize: 24
        }

    }

}
