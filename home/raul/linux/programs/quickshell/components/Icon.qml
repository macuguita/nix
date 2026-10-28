import QtQuick

DefaultedText {
    id: root

    property real fill: 0
    property int grade: 0
    property bool rounded: false

    required property string icon

    font.family: rounded ? "Material Symbols Rounded" : "Material Symbols Outlined"
    font.variableAxes: {
        "FILL": root.fill,
        "opsz": root.fontInfo.pixelSize,
        "GRAD": root.grade,
        "wght": root.fontInfo.weight
    }

    font.hintingPreference: Font.PreferFullHinting

    text: icon
}
