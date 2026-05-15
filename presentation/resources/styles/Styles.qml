import QtQuick

Item {
    id: styles

    property color background: "#FFFFFF"
    property color header: "#CFF4A6"
    property color headerText: "#3B3B3B"
    property color bar: "#EDDBCA"
    property color selector: "#DCDCDC"
    property color element: "#FFB8F8"
    property color accept: "#4ED433"
    property color danger: "#D72020"
    property int smallSpacing
    property int midSpacing
    property int bigSpacing
    property int heading
    property int title
    property int content
    property int label
    property int button

    states: [
        State {
            name: "mobile"
            when: parent.width < 360

            PropertyChanges {
                target: styles
                smallSpacing: 4
                midSpacing: 6
                bigSpacing: 8
                heading: 16
                title: 14
                content: 8
                label: 10
                button: 6
            }

        },
        State {
            name: "smallDesktop"
            when: parent.width >= 360 && parent.width < 600

            PropertyChanges {
                target: styles
                smallSpacing: 6
                midSpacing: 12
                bigSpacing: 18
                heading: 18
                title: 14
                content: 10
                label: 10
                button: 8
            }

        },
        State {
            name: "mediumDesktop"
            when: parent.width >= 600 && parent.width < 1280

            PropertyChanges {
                target: styles
                smallSpacing: 8
                midSpacing: 16
                bigSpacing: 24
                heading: 24
                title: 16
                content: 11
                label: 11
                button: 10
            }

        },
        State {
            name: "bigDesktop"
            when: parent.width >= 1280

            PropertyChanges {
                target: styles
                smallSpacing: 16
                midSpacing: 24
                bigSpacing: 32
                heading: 32
                title: 24
                content: 16
                label: 18
                button: 18
            }

        }
    ]
}
