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

    RowLayout {
        id: contentContainer

        readonly property int spacer: 12

        spacing: contentContainer.spacer
        height: windowRoot.height
        width: windowRoot.width

        Rectangle {
            id: optionsContainer

            readonly property int widthAmount: 120

            color: "#8B5538"
            Layout.fillHeight: true
            width: widthAmount

            ColumnLayout {
                Layout.margins: contentContainer.spacer
                spacing: contentContainer.spacer
                Layout.fillHeight: true
                Layout.fillWidth: true

                Repeater {
                    Button {
                        required property string uniqueID
                        required property string content

                        display: AbstractButton.TextUnderIcon
                        text: content
                        Layout.alignment: Qt.AlignHCenter
                        Layout.margins: contentContainer.spacer
                        Layout.preferredHeight: optionsContainer.width - 2 * contentContainer.spacer
                        Layout.preferredWidth: optionsContainer.width - 2 * contentContainer.spacer
                    }

                    model: ListModel {
                        ListElement {
                            uniqueID: "adjacencyButton"
                            content: "Adjacencia"
                        }

                        ListElement {
                            uniqueID: "incidenceButton"
                            content: "Incidencia"
                        }

                        ListElement {
                            uniqueID: "mstButton"
                            content: "Arbol Minimo"
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
                Layout.alignment: Qt.AlignHCenter
                padding: 48
            }

            Text {
                text: "[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]\n[ 0 0 0 0 0 0 0 0 0 0 0 0 ]"
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

            Text {
                // GraphView Mockup
                text: "Grafo"
                font.pointSize: 24
                padding: 24
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                color: "#D9D9D9"
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.preferredHeight: 240

                Text {
                    id: graphElement
                }

                TextField {
                    id: graphElementInput
                }

                Button {
                    id: acceptElementButton
                }

                Button {
                    id: deleteElementButton
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
            font.pointSize: 24
        }

    }

}
